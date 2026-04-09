<template>
  <a-form class="smart-query-form">
    <a-row class="smart-query-form-row">
      <a-form-item label="松布任务单" class="smart-query-form-item">
        <a-input style="width:180px" v-model:value="queryForm.orderNo" placeholder="松布任务单号" />
      </a-form-item>
      <a-form-item label="松布状态" class="smart-query-form-item">
        <a-select style="width:120px" v-model:value="queryForm.status" placeholder="全部" allowClear>
          <a-select-option :value="0">未开始</a-select-option>
          <a-select-option :value="1">进行中</a-select-option>
          <a-select-option :value="2">静置完成</a-select-option>
          <a-select-option :value="3">已结束</a-select-option>
        </a-select>
      </a-form-item>
      <a-form-item class="smart-query-form-item">
        <a-button-group>
          <a-button type="primary" @click="onSearch"><SearchOutlined />查询</a-button>
          <a-button @click="resetQuery"><ReloadOutlined />重置</a-button>
        </a-button-group>
      </a-form-item>
    </a-row>
  </a-form>
  <a-card size="small" :bordered="false" :hoverable="true">
    <a-row class="smart-table-btn-block">
      <div class="smart-table-operate-block">
        <a-button type="primary" @click="openForm(null)">
          <template #icon><PlusOutlined /></template>
          新建
        </a-button>
        <a-button danger :disabled="selectedRowKeys.length === 0" @click="onBatchDelete">
          <template #icon><DeleteOutlined /></template>
          批量删除{{ selectedRowKeys.length > 0 ? `(${selectedRowKeys.length})` : '' }}
        </a-button>
      </div>
    </a-row>
    <a-table
      size="small"
      :dataSource="tableData"
      :columns="columns"
      rowKey="relaxId"
      :pagination="false"
      bordered
      :scroll="{ x: 1300 }"
      :row-selection="rowSelection"
    >
      <template #bodyCell="{ text, record, column }">
        <template v-if="column.dataIndex === 'orderNo'">
          <span style="color:#1677ff;font-weight:500"><FileTextOutlined style="margin-right:4px" />{{ text }}</span>
        </template>
        <template v-if="column.dataIndex === 'status'">
          <a-tag :color="statusColor(text)">
            <template #icon><component :is="statusIcon(text)" /></template>
            {{ statusText(text) }}
          </a-tag>
        </template>
        <template v-if="column.dataIndex === 'progress'">
          <a-tooltip :title="`需求: ${Math.floor(record.requireLength ?? 0)} 卷 / 实际: ${Math.floor(record.actualLength ?? 0)} 卷`">
            <a-progress
              :percent="calcPercent(record)"
              :stroke-color="'#52c41a'"
              size="small"
              style="width:140px"
              :format="() => `${Math.floor(record.actualLength ?? 0)}/${Math.floor(record.requireLength ?? 0)}`"
            />
          </a-tooltip>
        </template>
        <template v-if="column.dataIndex === 'requireLength'">
          <span>{{ text ? Math.floor(text) + ' 卷' : '-' }}</span>
        </template>
        <template v-if="column.dataIndex === 'fabricNo'">
          <a-tag color="cyan">{{ text }}</a-tag>
        </template>
        <template v-if="column.dataIndex === 'colorName'">
          <a-tag color="purple">{{ text }}</a-tag>
        </template>
        <template v-if="column.dataIndex === 'relaxHours'">
          <span>{{ text ? text + ' h' : '-' }}</span>
        </template>
        <template v-if="column.dataIndex === 'action'">
          <div class="smart-table-operate">
            <a-button type="link" size="small" @click="openForm(record)">
              <EditOutlined />编辑
            </a-button>
            <a-button type="link" size="small" danger @click="onDelete(record)">
              <DeleteOutlined />删除
            </a-button>
          </div>
        </template>
      </template>
    </a-table>
    <div class="smart-query-table-page">
      <a-pagination showSizeChanger showQuickJumper :pageSizeOptions="PAGE_SIZE_OPTIONS"
        v-model:current="queryForm.pageNum" v-model:pageSize="queryForm.pageSize"
        :total="total" @change="queryData" :show-total="(t) => `共${t}条`" />
    </div>
    <RelaxFormModal ref="formModal" @reload="queryData" />
  </a-card>
</template>
<script setup>
import { ref, reactive, onMounted } from 'vue';
import { message, Modal } from 'ant-design-vue';
import {
  SearchOutlined, ReloadOutlined, PlusOutlined,
  FileTextOutlined, EditOutlined, DeleteOutlined,
  CheckCircleOutlined, SyncOutlined, ClockCircleFilled, StopOutlined,
} from '@ant-design/icons-vue';
import { SmartLoading } from '/@/components/framework/smart-loading';
import { smartSentry } from '/@/lib/smart-sentry';
import { PAGE_SIZE_OPTIONS } from '/@/constants/common-const';
import { fabricRelaxApi } from '/@/api/business/production/relax-api';
import RelaxFormModal from '../production/relax/components/relax-form-modal.vue';
import _ from 'lodash';

const columns = [
  { title: '松布计划单', dataIndex: 'orderNo', width: 150, fixed: 'left' },
  { title: '状态', dataIndex: 'status', width: 110 },
  { title: '松布进度', dataIndex: 'progress', width: 200 },
  { title: '卷数', dataIndex: 'requireLength', width: 90 },
  { title: '任务编号', dataIndex: 'relaxId', width: 90 },
  { title: '布料编号', dataIndex: 'fabricNo', width: 120 },
  { title: '布料名称', dataIndex: 'fabricName', width: 130 },
  { title: '颜色', dataIndex: 'colorName', width: 90 },
  { title: '客户', dataIndex: 'customerName', width: 120 },
  { title: '松布时间(h)', dataIndex: 'relaxHours', width: 110 },
  { title: '实际开始时间', dataIndex: 'actualStartTime', width: 160 },
  { title: '实际结束时间', dataIndex: 'actualEndTime', width: 160 },
  { title: '操作', dataIndex: 'action', fixed: 'right', width: 130 },
];

const queryFormState = { orderNo: '', status: undefined, pageNum: 1, pageSize: 10 };
const queryForm = reactive(_.cloneDeep(queryFormState));
const tableData = ref([]);
const total = ref(0);
const selectedRowKeys = ref([]);

const rowSelection = {
  selectedRowKeys,
  onChange: (keys) => { selectedRowKeys.value = keys; },
};

function statusText(s) {
  return { 0: '未开始', 1: '进行中', 2: '静置完成', 3: '已结束' }[s] ?? s;
}
function statusColor(s) {
  return { 0: 'default', 1: 'processing', 2: 'purple', 3: 'success' }[s] ?? 'default';
}
function statusIcon(s) {
  return { 0: ClockCircleFilled, 1: SyncOutlined, 2: CheckCircleOutlined, 3: StopOutlined }[s];
}
function calcPercent(record) {
  const req = record.requireLength;
  const act = record.actualLength;
  if (!req || req === 0) return 0;
  return Math.min(Math.round((act / req) * 100), 100);
}

function resetQuery() { Object.assign(queryForm, _.cloneDeep(queryFormState)); queryData(); }
function onSearch() { queryForm.pageNum = 1; queryData(); }

async function queryData() {
  try {
    const res = await fabricRelaxApi.query(queryForm);
    tableData.value = res.data.list;
    total.value = res.data.total;
  } catch (e) { smartSentry.captureError(e); }
}
onMounted(queryData);

const formModal = ref();
function openForm(row) { formModal.value.show(row); }

function onDelete(row) {
  Modal.confirm({
    title: '提示', content: `确定删除该松布任务吗?`, okText: '删除', okType: 'danger',
    onOk: async () => {
      try { SmartLoading.show(); await fabricRelaxApi.delete(row.relaxId); message.success('删除成功'); queryData(); }
      catch (e) { smartSentry.captureError(e); } finally { SmartLoading.hide(); }
    },
  });
}

function onBatchDelete() {
  Modal.confirm({
    title: '提示',
    content: `确定批量删除选中的 ${selectedRowKeys.value.length} 条松布任务吗?`,
    okText: '删除',
    okType: 'danger',
    onOk: async () => {
      try {
        SmartLoading.show();
        await fabricRelaxApi.batchDelete(selectedRowKeys.value);
        message.success('批量删除成功');
        selectedRowKeys.value = [];
        queryData();
      } catch (e) { smartSentry.captureError(e); } finally { SmartLoading.hide(); }
    },
  });
}
</script>
