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
      </div>
    </a-row>
    <a-table size="small" :dataSource="tableData" :columns="columns" rowKey="orderId" :pagination="false" bordered>
      <template #bodyCell="{ text, record, column }">
        <template v-if="column.dataIndex === 'status'">
          <a-tag :color="statusColor(text)">{{ statusText(text) }}</a-tag>
        </template>
        <template v-if="column.dataIndex === 'action'">
          <div class="smart-table-operate">
            <a-button type="link" @click="openForm(record)">编辑</a-button>
            <a-button type="link" @click="onIssue(record)" v-if="record.status === 1">下达</a-button>
            <a-button type="link" @click="onComplete(record)" v-if="record.status === 2">完工</a-button>
            <a-button type="link" danger @click="onDelete(record)" v-if="record.status === 1">删除</a-button>
          </div>
        </template>
      </template>
    </a-table>
    <div class="smart-query-table-page">
      <a-pagination showSizeChanger showQuickJumper :pageSizeOptions="PAGE_SIZE_OPTIONS"
        v-model:current="queryForm.pageNum" v-model:pageSize="queryForm.pageSize"
        :total="total" @change="queryData" :show-total="(t) => `共${t}条`" />
    </div>
    <OrderFormDrawer ref="formDrawer" @reload="queryData" />
  </a-card>
</template>
<script setup>
import { ref, reactive, onMounted } from 'vue';
import { message, Modal } from 'ant-design-vue';
import { SearchOutlined, ReloadOutlined, PlusOutlined } from '@ant-design/icons-vue';
import { SmartLoading } from '/@/components/framework/smart-loading';
import { smartSentry } from '/@/lib/smart-sentry';
import { PAGE_SIZE_OPTIONS } from '/@/constants/common-const';
import { productionOrderApi } from '/@/api/business/production/order-api';
import OrderFormDrawer from './components/order-form-drawer.vue';
import _ from 'lodash';

const columns = ref([
  { title: '指令单号', dataIndex: 'orderNo', width: 160 },
  { title: '客户名称', dataIndex: 'customerName', width: 130 },
  { title: '款号', dataIndex: 'styleNo', width: 120 },
  { title: '款名', dataIndex: 'styleName', width: 130 },
  { title: '交货日期', dataIndex: 'deliveryDate', width: 110 },
  { title: '下单数量', dataIndex: 'orderQuantity', width: 90 },
  { title: '完成数量', dataIndex: 'finishQuantity', width: 90 },
  { title: '状态', dataIndex: 'status', width: 80 },
  { title: '创建人', dataIndex: 'createUserName', width: 100 },
  { title: '创建时间', dataIndex: 'createTime', width: 160 },
  { title: '操作', dataIndex: 'action', fixed: 'right', width: 180 },
]);

const queryFormState = { orderNo: '', styleNo: '', status: undefined, pageNum: 1, pageSize: 10 };
const queryForm = reactive(_.cloneDeep(queryFormState));
const tableData = ref([]);
const total = ref(0);

function statusText(s) { return { 1: '计划', 2: '下达', 3: '完工' }[s] || s; }
function statusColor(s) { return { 1: 'default', 2: 'blue', 3: 'green' }[s] || 'default'; }

function resetQuery() { Object.assign(queryForm, _.cloneDeep(queryFormState)); queryData(); }
function onSearch() { queryForm.pageNum = 1; queryData(); }

async function queryData() {
  try {
    const res = await productionOrderApi.query(queryForm);
    tableData.value = res.data.list;
    total.value = res.data.total;
  } catch (e) { smartSentry.captureError(e); }
}
onMounted(queryData);

const formDrawer = ref();
function openForm(row) { formDrawer.value.show(row); }

function onIssue(row) {
  Modal.confirm({
    title: '下达确认', content: `确定下达指令单【${row.orderNo}】吗？下达后不可修改。`,
    okText: '下达', okType: 'primary',
    onOk: async () => {
      try { SmartLoading.show(); await productionOrderApi.issue(row.orderId); message.success('下达成功'); queryData(); }
      catch (e) { smartSentry.captureError(e); } finally { SmartLoading.hide(); }
    },
  });
}

function onComplete(row) {
  Modal.confirm({
    title: '完工确认', content: `确定将指令单【${row.orderNo}】标记为完工吗？`,
    okText: '完工', okType: 'primary',
    onOk: async () => {
      try { SmartLoading.show(); await productionOrderApi.complete(row.orderId); message.success('完工成功'); queryData(); }
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
</script>
