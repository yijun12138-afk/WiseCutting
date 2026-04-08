<template>
  <a-form class="smart-query-form">
    <a-row class="smart-query-form-row">
      <a-form-item label="计划单号" class="smart-query-form-item">
        <a-input style="width:160px" v-model:value="queryForm.planNo" placeholder="计划单号" />
      </a-form-item>
      <a-form-item label="指令单号" class="smart-query-form-item">
        <a-input style="width:160px" v-model:value="queryForm.orderNo" placeholder="指令单号" />
      </a-form-item>
      <a-form-item label="状态" class="smart-query-form-item">
        <a-select style="width:120px" v-model:value="queryForm.status" placeholder="全部" allowClear>
          <a-select-option :value="1">计划</a-select-option>
          <a-select-option :value="2">进行中</a-select-option>
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
      </div>
    </a-row>
    <a-table size="small" :dataSource="tableData" :columns="columns" rowKey="planId" :pagination="false" bordered>
      <template #bodyCell="{ text, record, column }">
        <template v-if="column.dataIndex === 'status'">
          <a-tag :color="statusColor(text)">{{ statusText(text) }}</a-tag>
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
      <a-pagination showSizeChanger showQuickJumper :pageSizeOptions="PAGE_SIZE_OPTIONS"
        v-model:current="queryForm.pageNum" v-model:pageSize="queryForm.pageSize"
        :total="total" @change="queryData" :show-total="(t) => `共${t}条`" />
    </div>
    <CuttingPlanFormModal ref="formModal" @reload="queryData" />
  </a-card>
</template>
<script setup>
import { ref, reactive, onMounted } from 'vue';
import { message, Modal } from 'ant-design-vue';
import { SearchOutlined, ReloadOutlined, PlusOutlined } from '@ant-design/icons-vue';
import { SmartLoading } from '/@/components/framework/smart-loading';
import { smartSentry } from '/@/lib/smart-sentry';
import { PAGE_SIZE_OPTIONS } from '/@/constants/common-const';
import { cuttingPlanApi } from '/@/api/business/cutting/cutting-plan-api';
import CuttingPlanFormModal from './components/cutting-plan-form-modal.vue';
import _ from 'lodash';

const columns = [
  { title: '计划单号', dataIndex: 'planNo', width: 160 },
  { title: '指令单号', dataIndex: 'orderNo', width: 140 },
  { title: '客户', dataIndex: 'customerName', width: 120 },
  { title: '款号', dataIndex: 'styleNo', width: 100 },
  { title: '款名', dataIndex: 'styleName', width: 120 },
  { title: '计划日期', dataIndex: 'planDate', width: 110 },
  { title: '计划数量', dataIndex: 'planQuantity', width: 90 },
  { title: '实际数量', dataIndex: 'actualQuantity', width: 90 },
  { title: '状态', dataIndex: 'status', width: 80 },
  { title: '备注', dataIndex: 'remark', ellipsis: true },
  { title: '操作', dataIndex: 'action', fixed: 'right', width: 120 },
];

const queryFormState = { planNo: '', orderNo: '', status: undefined, pageNum: 1, pageSize: 10 };
const queryForm = reactive(_.cloneDeep(queryFormState));
const tableData = ref([]);
const total = ref(0);

function statusText(s) { return { 1: '计划', 2: '进行中', 3: '完成' }[s] ?? s; }
function statusColor(s) { return { 1: 'default', 2: 'blue', 3: 'green' }[s] ?? 'default'; }
function resetQuery() { Object.assign(queryForm, _.cloneDeep(queryFormState)); queryData(); }
function onSearch() { queryForm.pageNum = 1; queryData(); }

async function queryData() {
  try {
    const res = await cuttingPlanApi.query(queryForm);
    tableData.value = res.data.list;
    total.value = res.data.total;
  } catch (e) { smartSentry.captureError(e); }
}
onMounted(queryData);

const formModal = ref();
function openForm(row) { formModal.value.show(row); }
function onDelete(row) {
  Modal.confirm({
    title: '提示', content: `确定删除计划单【${row.planNo}】吗?`, okText: '删除', okType: 'danger',
    onOk: async () => {
      try { SmartLoading.show(); await cuttingPlanApi.delete(row.planId); message.success('删除成功'); queryData(); }
      catch (e) { smartSentry.captureError(e); } finally { SmartLoading.hide(); }
    },
  });
}
</script>
