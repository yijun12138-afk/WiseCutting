<template>
  <a-form class="smart-query-form">
    <a-row class="smart-query-form-row">
      <a-form-item label="松布计划单" class="smart-query-form-item">
        <a-input style="width:180px" v-model:value="queryForm.orderNo" placeholder="松布计划单号" />
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
          新建松布计划
        </a-button>
      </div>
    </a-row>
    <a-table size="small" :dataSource="tableData" :columns="columns" rowKey="relaxId" :pagination="false" bordered>
      <template #bodyCell="{ text, record, column }">
        <template v-if="column.dataIndex === 'orderNo'">
          <span style="color:#1677ff;font-weight:500"><FileTextOutlined style="margin-right:4px" />{{ text }}</span>
        </template>
        <template v-if="column.dataIndex === 'relaxHours'">
          <span><ClockCircleOutlined style="margin-right:4px;color:#faad14" />{{ text ? text + ' h' : '-' }}</span>
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
        <template v-if="column.dataIndex === 'status'">
          <a-tag :color="statusColor(text)">
            <template #icon><component :is="statusIcon(text)" /></template>
            {{ statusText(text) }}
          </a-tag>
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
  FileTextOutlined, ClockCircleOutlined, EditOutlined, DeleteOutlined,
  CheckCircleOutlined, SyncOutlined, ClockCircleFilled, StopOutlined,
} from '@ant-design/icons-vue';
import { SmartLoading } from '/@/components/framework/smart-loading';
import { smartSentry } from '/@/lib/smart-sentry';
import { PAGE_SIZE_OPTIONS } from '/@/constants/common-const';
import { fabricRelaxApi } from '/@/api/business/production/relax-api';
import RelaxFormModal from '../production/relax/components/relax-form-modal.vue';
import _ from 'lodash';

const columns = [
  { title: '松布计划单', dataIndex: 'orderNo', width: 150 },
  { title: '松布时长(h)', dataIndex: 'relaxHours', width: 120 },
  { title: '卷数', dataIndex: 'requireLength', width: 90 },
  { title: '面料编号', dataIndex: 'fabricNo', width: 120 },
  { title: '面料名称', dataIndex: 'fabricName', width: 130 },
  { title: '颜色', dataIndex: 'colorName', width: 90 },
  { title: '实际长度(m)', dataIndex: 'actualLength', width: 110 },
  { title: '状态', dataIndex: 'status', width: 100 },
  { title: '创建时间', dataIndex: 'createTime', width: 160 },
  { title: '操作', dataIndex: 'action', fixed: 'right', width: 130 },
];

const queryFormState = { orderNo: '', pageNum: 1, pageSize: 10 };
const queryForm = reactive(_.cloneDeep(queryFormState));
const tableData = ref([]);
const total = ref(0);

function statusText(s) { return { 0: '未开始', 1: '进行中', 2: '静置完成', 3: '已结束' }[s] ?? s; }
function statusColor(s) { return { 0: 'default', 1: 'processing', 2: 'purple', 3: 'success' }[s] ?? 'default'; }
function statusIcon(s) { return { 0: ClockCircleFilled, 1: SyncOutlined, 2: CheckCircleOutlined, 3: StopOutlined }[s]; }

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
    title: '提示', content: `确定删除该松布计划吗?`, okText: '删除', okType: 'danger',
    onOk: async () => {
      try { SmartLoading.show(); await fabricRelaxApi.delete(row.relaxId); message.success('删除成功'); queryData(); }
      catch (e) { smartSentry.captureError(e); } finally { SmartLoading.hide(); }
    },
  });
}
</script>
