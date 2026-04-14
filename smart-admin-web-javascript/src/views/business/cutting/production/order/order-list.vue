<template>
  <a-form class="smart-query-form">
    <a-row class="smart-query-form-row">
      <a-form-item label="指令单号" class="smart-query-form-item">
        <a-input style="width:180px" v-model:value="queryForm.orderNo" placeholder="指令单号" />
      </a-form-item>
      <a-form-item label="款号" class="smart-query-form-item">
        <a-input style="width:150px" v-model:value="queryForm.styleNo" placeholder="款号" />
      </a-form-item>
      <a-form-item label="状态" class="smart-query-form-item">
        <a-select style="width:120px" v-model:value="queryForm.status" placeholder="全部" allowClear>
          <a-select-option :value="1">计划</a-select-option>
          <a-select-option :value="2">下达</a-select-option>
          <a-select-option :value="3">完工</a-select-option>
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
        <a-button type="primary" style="margin-left:8px" :disabled="selectedRowKeys.length === 0" @click="onBatchComplete">
          <CheckCircleOutlined />完工
        </a-button>
        <a-button danger style="margin-left:8px" :disabled="selectedRowKeys.length === 0" @click="onBatchDelete">
          <DeleteOutlined />批量删除
        </a-button>
      </div>
    </a-row>
    <a-table
      size="small"
      :dataSource="tableData"
      :columns="columns"
      rowKey="orderId"
      :pagination="false"
      bordered
      :row-selection="rowSelection"
      :scroll="{ x: 1100 }"
    >
      <template #bodyCell="{ text, record, column }">
        <template v-if="column.dataIndex === 'orderNo'">
          <a @click="openForm(record)" style="color: #1890ff; cursor: pointer">{{ text }}</a>
        </template>
        <template v-if="column.dataIndex === 'status'">
          <a-tag :color="statusColor(text)"><template #icon><component :is="statusIcon(text)" /></template>{{ statusText(text) }}</a-tag>
        </template>
        <template v-if="column.dataIndex === 'action'">
          <div class="smart-table-operate">
            <a-button type="link" @click="openForm(record)">编辑</a-button>
            <a-button type="link" @click="onIssue(record)" v-if="record.status === 1">下达</a-button>
            <a-button type="link" @click="onUnissue(record)" v-if="record.status === 2">反下达</a-button>
            <a-button type="link" @click="onUpdateFinishQty(record)">完工数量</a-button>
            <a-button type="link" danger @click="onDelete(record)">删除</a-button>
          </div>
        </template>
      </template>
    </a-table>
    <div class="smart-query-table-page">
      <a-pagination showSizeChanger showQuickJumper :pageSizeOptions="PAGE_SIZE_OPTIONS"
        v-model:current="queryForm.pageNum" v-model:pageSize="queryForm.pageSize"
        :total="total" @change="queryData" :show-total="(t) => `共${t}条`" />
    </div>
    <OrderFormModal ref="formModal" @reload="queryData" />
  </a-card>
</template>
<script setup>
import { ref, reactive, onMounted, h } from 'vue';
import { message, Modal, InputNumber } from 'ant-design-vue';
import { SearchOutlined, ReloadOutlined, PlusOutlined, DeleteOutlined, CheckCircleOutlined,
  ClockCircleFilled, SyncOutlined } from '@ant-design/icons-vue';
import { SmartLoading } from '/@/components/framework/smart-loading';
import { smartSentry } from '/@/lib/smart-sentry';
import { PAGE_SIZE_OPTIONS } from '/@/constants/common-const';
import { productionOrderApi } from '/@/api/business/production/order-api';
import OrderFormModal from './components/order-form-modal.vue';
import _ from 'lodash';

const columns = [
  { title: '指令单号', dataIndex: 'orderNo', width: 160 },
  { title: '客户名称', dataIndex: 'customerName', width: 120 },
  { title: '款号', dataIndex: 'styleNo', width: 100 },
  { title: '款名', dataIndex: 'styleName', width: 120 },
  { title: '交货日期', dataIndex: 'deliveryDate', width: 110 },
  { title: '下单数量', dataIndex: 'orderQuantity', width: 90 },
  { title: '完成数量', dataIndex: 'finishQuantity', width: 90 },
  { title: '状态', dataIndex: 'status', width: 80 },
  { title: '创建人', dataIndex: 'createUserName', width: 90 },
  { title: '操作', dataIndex: 'action', fixed: 'right', width: 200 },
];

const queryFormState = { orderNo: '', styleNo: '', status: undefined, pageNum: 1, pageSize: 10 };
const queryForm = reactive(_.cloneDeep(queryFormState));
const tableData = ref([]);
const total = ref(0);

// 多选
const selectedRowKeys = ref([]);
const rowSelection = {
  selectedRowKeys,
  onChange: (keys) => { selectedRowKeys.value = keys; },
};

function statusText(s) { return { 1: '计划', 2: '下达', 3: '完工' }[s] || s; }
function statusColor(s) { return { 1: 'default', 2: 'processing', 3: 'success' }[s] || 'default'; }
function statusIcon(s) { return { 1: ClockCircleFilled, 2: SyncOutlined, 3: CheckCircleOutlined }[s]; }

function resetQuery() { Object.assign(queryForm, _.cloneDeep(queryFormState)); queryData(); }
function onSearch() { queryForm.pageNum = 1; queryData(); }

async function queryData() {
  try {
    const res = await productionOrderApi.query(queryForm);
    tableData.value = res.data.list;
    total.value = res.data.total;
    selectedRowKeys.value = [];
  } catch (e) { smartSentry.captureError(e); }
}
onMounted(queryData);

const formModal = ref();
function openForm(row) { formModal.value.show(row); }

function onIssue(row) {
  Modal.confirm({
    title: '下达确认', content: `确定下达指令单【${row.orderNo}】吗？`,
    okText: '下达', okType: 'primary',
    onOk: async () => {
      try { SmartLoading.show(); await productionOrderApi.issue(row.orderId); message.success('下达成功'); queryData(); }
      catch (e) { smartSentry.captureError(e); } finally { SmartLoading.hide(); }
    },
  });
}

function onUnissue(row) {
  Modal.confirm({
    title: '反下达确认', content: `确定将指令单【${row.orderNo}】反下达回计划状态吗？`,
    okText: '反下达', okType: 'default',
    onOk: async () => {
      try { SmartLoading.show(); await productionOrderApi.unissue(row.orderId); message.success('反下达成功'); queryData(); }
      catch (e) { smartSentry.captureError(e); } finally { SmartLoading.hide(); }
    },
  });
}

function onDelete(row) {
  Modal.confirm({
    title: '提示', content: `确定删除指令单【${row.orderNo}】吗?`,
    okText: '删除', okType: 'danger',
    onOk: async () => {
      try { SmartLoading.show(); await productionOrderApi.delete(row.orderId); message.success('删除成功'); queryData(); }
      catch (e) { smartSentry.captureError(e); } finally { SmartLoading.hide(); }
    },
  });
}

function onBatchDelete() {
  Modal.confirm({
    title: '批量删除', content: `确定删除选中的 ${selectedRowKeys.value.length} 条指令单吗？`,
    okText: '删除', okType: 'danger',
    onOk: async () => {
      try { SmartLoading.show(); await productionOrderApi.batchDelete(selectedRowKeys.value); message.success('批量删除成功'); queryData(); }
      catch (e) { smartSentry.captureError(e); } finally { SmartLoading.hide(); }
    },
  });
}

function onBatchComplete() {
  Modal.confirm({
    title: '批量完工', content: `确定将选中的 ${selectedRowKeys.value.length} 条指令单标记为完工吗？`,
    okText: '完工', okType: 'primary',
    onOk: async () => {
      try { SmartLoading.show(); await productionOrderApi.batchComplete(selectedRowKeys.value); message.success('批量完工成功'); queryData(); }
      catch (e) { smartSentry.captureError(e); } finally { SmartLoading.hide(); }
    },
  });
}

function onUpdateFinishQty(row) {
  const qtyRef = ref(row.finishQuantity || 0);
  Modal.confirm({
    title: `更新完工数量 - ${row.orderNo}`,
    content: h('div', { style: 'padding: 8px 0' }, [
      h('span', { style: 'margin-right: 8px' }, '完工数量：'),
      h(InputNumber, {
        defaultValue: qtyRef.value,
        min: 0,
        max: row.orderQuantity,
        style: 'width: 120px',
        onChange: (val) => { qtyRef.value = val; },
      }),
      h('span', { style: 'margin-left: 8px; color: #8c8c8c' }, `/ ${row.orderQuantity}`),
    ]),
    okText: '保存',
    okType: 'primary',
    onOk: async () => {
      try { SmartLoading.show(); await productionOrderApi.updateFinishQuantity(row.orderId, qtyRef.value); message.success('更新成功'); queryData(); }
      catch (e) { smartSentry.captureError(e); } finally { SmartLoading.hide(); }
    },
  });
}
</script>
