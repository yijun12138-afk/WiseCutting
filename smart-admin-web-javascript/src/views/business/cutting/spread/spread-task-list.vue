<template>
  <a-form class="smart-query-form">
    <a-row class="smart-query-form-row">
      <a-form-item label="指令单号" class="smart-query-form-item">
        <a-input style="width:180px" v-model:value="queryForm.orderNo" placeholder="请输入指令单号" allow-clear />
      </a-form-item>
      <a-form-item label="任务状态" class="smart-query-form-item">
        <a-select style="width:130px" v-model:value="queryForm.status" placeholder="全部状态" allowClear>
          <a-select-option :value="0">待作业</a-select-option>
          <a-select-option :value="1">进行中</a-select-option>
          <a-select-option :value="2">已完成</a-select-option>
        </a-select>
      </a-form-item>
      <a-form-item label="下达状态" class="smart-query-form-item">
        <a-select style="width:120px" v-model:value="queryForm.issuedFlag" placeholder="全部" allowClear>
          <a-select-option :value="true">已下达</a-select-option>
          <a-select-option :value="false">未下达</a-select-option>
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
          新建铺布任务
        </a-button>
        <a-button danger :disabled="selectedRowKeys.length === 0" @click="onBatchDelete">
          <template #icon><DeleteOutlined /></template>
          批量删除{{ selectedRowKeys.length > 0 ? `(${selectedRowKeys.length})` : '' }}
        </a-button>
      </div>
      <div style="display:flex;align-items:center;gap:10px;">
        <span style="font-size:13px;color:#8c8c8c;">共 {{ total }} 条</span>
        <a-button size="small" @click="queryData"><ReloadOutlined /> 刷新</a-button>
      </div>
    </a-row>

    <a-table
      size="small"
      :dataSource="tableData"
      :columns="columns"
      rowKey="spreadId"
      :pagination="false"
      bordered
      :scroll="{ x: 1200 }"
      :row-selection="rowSelection"
    >
      <template #bodyCell="{ text, record, column }">
        <template v-if="column.dataIndex === 'orderNo'">
          <span style="color:#1677ff;font-weight:500"><FileTextOutlined style="margin-right:4px" />{{ text }}</span>
        </template>

        <template v-if="column.dataIndex === 'status'">
          <a-tag :color="statusColor(text)">
            <template #icon><component :is="statusIcon(text)" /></template>
            {{ statusTextMap[text] ?? text }}
          </a-tag>
        </template>

        <template v-if="column.dataIndex === 'issuedFlag'">
          <a-tag :color="text ? 'blue' : 'default'">
            {{ text ? '已下达' : '未下达' }}
          </a-tag>
        </template>

        <template v-if="column.dataIndex === 'fabricName'">
          <div>
            <div style="font-size:13px;font-weight:500;color:#262626;">{{ text || '-' }}</div>
            <div style="font-size:11px;color:#8c8c8c;">{{ record.fabricNo }}</div>
          </div>
        </template>

        <template v-if="column.dataIndex === 'colorName'">
          <a-tag color="purple">{{ text || '-' }}</a-tag>
        </template>

        <template v-if="column.dataIndex === 'requireLayers' || column.dataIndex === 'actualLayers'">
          <span style="font-weight:600;">{{ text ?? '-' }}</span>
        </template>
        <template v-if="column.dataIndex === 'requireLength' || column.dataIndex === 'actualLength'">
          <span style="font-weight:600;">{{ text != null ? text + 'm' : '-' }}</span>
        </template>

        <template v-if="column.dataIndex === 'action'">
          <div class="smart-table-operate">
            <a-button type="link" size="small" @click="openForm(record)" v-if="!record.issuedFlag">
              <EditOutlined />编辑
            </a-button>
            <a-button type="link" size="small" @click="onIssue(record)" v-if="!record.issuedFlag">
              <SendOutlined />下达
            </a-button>
            <a-button type="link" size="small" @click="openComplete(record)" v-if="record.issuedFlag && record.status !== 2">
              <CheckOutlined />完成
            </a-button>
            <a-button type="link" size="small" danger @click="onDelete(record)" v-if="!record.issuedFlag">
              <DeleteOutlined />删除
            </a-button>
          </div>
        </template>
      </template>
    </a-table>

    <div class="smart-query-table-page">
      <a-pagination showSizeChanger showQuickJumper :pageSizeOptions="PAGE_SIZE_OPTIONS"
        v-model:current="queryForm.pageNum" v-model:pageSize="queryForm.pageSize"
        :total="total" @change="queryData" @showSizeChange="queryData"
        :show-total="(t) => `共 ${t} 条记录`" />
    </div>

    <SpreadFormModal ref="formModal" @reload="queryData" />
    <SpreadCompleteModal ref="completeModal" @reload="queryData" />
  </a-card>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue';
import { message, Modal } from 'ant-design-vue';
import {
  SearchOutlined, ReloadOutlined, PlusOutlined,
  SendOutlined, EditOutlined, CheckOutlined, DeleteOutlined,
  FileTextOutlined, CheckCircleOutlined, SyncOutlined, ClockCircleFilled,
} from '@ant-design/icons-vue';
import { SmartLoading } from '/@/components/framework/smart-loading';
import { smartSentry } from '/@/lib/smart-sentry';
import { PAGE_SIZE_OPTIONS } from '/@/constants/common-const';
import { fabricSpreadApi } from '/@/api/business/production/spread-api';
import SpreadFormModal from '../production/spread/components/spread-form-modal.vue';
import SpreadCompleteModal from '../production/spread/components/spread-complete-modal.vue';
import _ from 'lodash';

const columns = [
  { title: '指令单号', dataIndex: 'orderNo', width: 160, fixed: 'left' },
  { title: '面料信息', dataIndex: 'fabricName', width: 150 },
  { title: '颜色', dataIndex: 'colorName', width: 90 },
  { title: '需求层数', dataIndex: 'requireLayers', width: 90, align: 'center' },
  { title: '需求长度', dataIndex: 'requireLength', width: 100, align: 'center' },
  { title: '实际层数', dataIndex: 'actualLayers', width: 90, align: 'center' },
  { title: '实际长度', dataIndex: 'actualLength', width: 100, align: 'center' },
  { title: '任务状态', dataIndex: 'status', width: 110, align: 'center' },
  { title: '下达状态', dataIndex: 'issuedFlag', width: 110, align: 'center' },
  { title: '创建时间', dataIndex: 'createTime', width: 160 },
  { title: '操作', dataIndex: 'action', fixed: 'right', width: 180 },
];

const statusTextMap = { 0: '待作业', 1: '进行中', 2: '已完成' };
function statusColor(s) { return { 0: 'default', 1: 'processing', 2: 'success' }[s] ?? 'default'; }
function statusIcon(s) { return { 0: ClockCircleFilled, 1: SyncOutlined, 2: CheckCircleOutlined }[s]; }

const queryFormState = { orderNo: '', status: undefined, issuedFlag: undefined, pageNum: 1, pageSize: 10 };
const queryForm = reactive(_.cloneDeep(queryFormState));
const tableData = ref([]);
const total = ref(0);
const selectedRowKeys = ref([]);

const rowSelection = {
  selectedRowKeys,
  onChange: (keys) => { selectedRowKeys.value = keys; },
};

function resetQuery() { Object.assign(queryForm, _.cloneDeep(queryFormState)); queryData(); }
function onSearch() { queryForm.pageNum = 1; queryData(); }

async function queryData() {
  try {
    const res = await fabricSpreadApi.query(queryForm);
    tableData.value = res.data.list;
    total.value = res.data.total;
  } catch (e) { smartSentry.captureError(e); }
}
onMounted(queryData);

const formModal = ref();
const completeModal = ref();
function openForm(row) { formModal.value.show(row); }
function openComplete(row) { completeModal.value.show(row); }

function onIssue(row) {
  Modal.confirm({
    title: '下达铺布任务',
    content: `确定下达任务【${row.orderNo}】吗？下达后任务不可修改。`,
    okText: '立即下达',
    okType: 'primary',
    cancelText: '取消',
    onOk: async () => {
      try {
        SmartLoading.show();
        await fabricSpreadApi.saveAndIssue(row);
        message.success('下达成功！任务已推送至车间');
        queryData();
      } catch (e) { smartSentry.captureError(e); } finally { SmartLoading.hide(); }
    },
  });
}

function onDelete(row) {
  Modal.confirm({
    title: '删除确认',
    content: `确定删除任务【${row.orderNo}】吗？`,
    okText: '确认删除',
    okType: 'danger',
    cancelText: '取消',
    onOk: async () => {
      try {
        SmartLoading.show();
        await fabricSpreadApi.delete(row.spreadId);
        message.success('删除成功');
        queryData();
      } catch (e) { smartSentry.captureError(e); } finally { SmartLoading.hide(); }
    },
  });
}

function onBatchDelete() {
  Modal.confirm({
    title: '批量删除确认',
    content: `确定批量删除选中的 ${selectedRowKeys.value.length} 条铺布任务吗？删除后铺布工作台中对应数据也将一并删除。`,
    okText: '确认删除',
    okType: 'danger',
    cancelText: '取消',
    onOk: async () => {
      try {
        SmartLoading.show();
        await fabricSpreadApi.batchDelete(selectedRowKeys.value);
        message.success('批量删除成功');
        selectedRowKeys.value = [];
        queryData();
      } catch (e) { smartSentry.captureError(e); } finally { SmartLoading.hide(); }
    },
  });
}
</script>
