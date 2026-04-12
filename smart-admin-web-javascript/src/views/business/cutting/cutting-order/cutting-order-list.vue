<template>
  <a-form class="smart-query-form">
    <a-row class="smart-query-form-row">
      <a-form-item label="裁床单号" class="smart-query-form-item">
        <a-input style="width:160px" v-model:value="queryForm.cuttingOrderNo" placeholder="裁床单号" />
      </a-form-item>
      <a-form-item label="指令单号" class="smart-query-form-item">
        <a-input style="width:160px" v-model:value="queryForm.orderNo" placeholder="指令单号" />
      </a-form-item>
      <a-form-item label="状态" class="smart-query-form-item">
        <a-select style="width:120px" v-model:value="queryForm.status" placeholder="全部" allowClear>
          <a-select-option :value="1">待裁</a-select-option>
          <a-select-option :value="2">裁剪中</a-select-option>
          <a-select-option :value="3">完成</a-select-option>
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
        <a-button type="primary" @click="openForm(null)"><PlusOutlined />新建</a-button>
        <a-button @click="onExport" style="margin-left:8px"><DownloadOutlined />导出Excel</a-button>
      </div>
       <div class="smart-table-setting-block">
        <TableOperator v-model="columns" :tableId="TABLE_ID_CONST.BUSINESS.CUTTING.CUTTINGORDER" :refresh="queryData" />
      </div>
    </a-row>
    <a-table 
       size="small" 
      :dataSource="tableData" 
      :columns="columns" 
      :loading="tableLoading"
      rowKey="cuttingOrderId" 
      :pagination="false" bordered>
      <template #bodyCell="{ text, record, column }">
        <template v-if="column.dataIndex === 'status'">
          <a-tag :color="statusColor(text)"><template #icon><component :is="statusIcon(text)" /></template>{{ statusText(text) }}</a-tag>
        </template>
        <template v-if="column.dataIndex === 'action'">
          <div class="smart-table-operate">
            <a-button type="link" @click="openForm(record)">编辑</a-button>
            <a-button type="link" danger @click="onDelete(record)">删除</a-button>
          </div>
        </template>
      </template>
    </a-table>
    <div class="smart-query-table-page">
      <a-pagination showSizeChanger showQuickJumper 
      :pageSizeOptions="PAGE_SIZE_OPTIONS"
      v-model:current="queryForm.pageNum"
      v-model:pageSize="queryForm.pageSize"
      :total="total"
      @change="queryData" 
      :show-total="(t) => `共${t}条`"
      />
    </div>
    <CuttingOrderFormModal ref="formModal" @reload="queryData" />

  </a-card>
</template>
<script setup>
import { ref, reactive, onMounted } from 'vue';
import { message, Modal } from 'ant-design-vue';
import { SearchOutlined, ReloadOutlined, PlusOutlined, DownloadOutlined, ClockCircleFilled, SyncOutlined, CheckCircleOutlined } from '@ant-design/icons-vue';
import { SmartLoading } from '/@/components/framework/smart-loading';
import { smartSentry } from '/@/lib/smart-sentry';
import { PAGE_SIZE_OPTIONS } from '/@/constants/common-const';
import { cuttingOrderApi } from '/@/api/business/cutting/cutting-order-api';
import CuttingOrderFormModal from './components/cutting-order-form-modal.vue';
import { TABLE_ID_CONST } from '/@/constants/support/table-id-const';
import TableOperator from '/@/components/support/table-operator/index.vue';
import _ from 'lodash';
const columns = [
  { title: '裁床单号', dataIndex: 'cuttingOrderNo', width: 160 },
  { title: '指令单号', dataIndex: 'orderNo', width: 140 },
  { title: '客户', dataIndex: 'customerName', width: 100 },
  { title: '款号', dataIndex: 'styleNo', width: 90 },
  { title: '颜色', dataIndex: 'colorName', width: 80 },
  { title: '尺码', dataIndex: 'sizeName', width: 70 },
  { title: '数量', dataIndex: 'quantity', width: 70 },
  { title: '床号', dataIndex: 'bedNo', width: 80 },
  { title: '层数', dataIndex: 'layers', width: 70 },
  { title: '面料编号', dataIndex: 'fabricNo', width: 110 },
  { title: '状态', dataIndex: 'status', width: 80 },
  { title: '操作', dataIndex: 'action', fixed: 'right', width: 120 },
];

const queryFormState = { cuttingOrderNo: '', orderNo: '', status: undefined, pageNum: 1, pageSize: 10 };
const queryForm = reactive(_.cloneDeep(queryFormState));
const tableData = ref([]);
const total = ref(0);
const tableLoading = ref(false)

function statusText(s) { 
  return { 1: '待裁', 2: '裁剪中', 3: '完成' }
  [s] ?? s; 
}
function statusColor(s) {
  return { 1: 'default', 2: 'processing', 3: 'success' }
  [s] ?? 'default';
}
function statusIcon(s) {
  return { 1: ClockCircleFilled, 2: SyncOutlined, 3: CheckCircleOutlined }[s];
}
function resetQuery() { 
  Object.assign(queryForm, _.cloneDeep(queryFormState));
  queryData(); 
}

function onSearch() { queryForm.pageNum = 1; queryData(); }

async function queryData() {
  try {
    tableLoading.value = true
    const res = await cuttingOrderApi.query(queryForm);
    tableData.value = res.data.list;
    total.value = res.data.total;
  } catch (e)
   { 
    smartSentry.captureError(e); 
  } finally {
      tableLoading.value = false;
  }
}
onMounted(queryData);

const formModal = ref();
function openForm(row) {
  formModal.value.show(row);
}

async function onExport() {
  try {
    SmartLoading.show();
    await cuttingOrderApi.export({
      cuttingOrderNo: queryForm.cuttingOrderNo,
      orderNo: queryForm.orderNo,
      status: queryForm.status,
    });
    message.success('导出成功');
  } catch (e) {
    smartSentry.captureError(e);
  } finally {
    SmartLoading.hide();
  }
}

function onDelete(row) {
  Modal.confirm({
    title: '提示', content: `确定删除裁床单【${row.cuttingOrderNo}】吗?`, okText: '删除', okType: 'danger',
    onOk: async () => {
      try { SmartLoading.show(); await cuttingOrderApi.delete(row.cuttingOrderId); message.success('删除成功'); queryData(); }
      catch (e) { smartSentry.captureError(e); } finally { SmartLoading.hide(); }
    },
  });
}
</script>
<style scoped>
</style>