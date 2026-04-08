<template>
  <a-form class="smart-query-form">
    <a-row class="smart-query-form-row">
      <a-form-item label="指令单号" class="smart-query-form-item">
        <a-input style="width:150px" v-model:value="queryForm.orderNo" placeholder="指令单号" />
      </a-form-item>
      <a-form-item label="状态" class="smart-query-form-item">
        <a-select style="width:120px" v-model:value="queryForm.status" placeholder="全部" allowClear>
          <a-select-option :value="0">待作业</a-select-option>
          <a-select-option :value="1">进行中</a-select-option>
          <a-select-option :value="2">已完成</a-select-option>
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
    <a-table size="small" :dataSource="tableData" :columns="columns" rowKey="spreadId" :pagination="false" bordered>
      <template #bodyCell="{ text, record, column }">
        <template v-if="column.dataIndex === 'status'">
          <a-tag :color="{ 0: 'default', 1: 'orange', 2: 'green' }[text]">{{ { 0: '待作业', 1: '进行中', 2: '已完成' }[text] }}</a-tag>
        </template>
        <template v-if="column.dataIndex === 'issuedFlag'">
          <a-tag :color="text ? 'blue' : 'default'">{{ text ? '已下达' : '未下达' }}</a-tag>
        </template>
        <template v-if="column.dataIndex === 'action'">
          <div class="smart-table-operate">
            <a-button type="link" @click="openForm(record)" v-if="!record.issuedFlag">编辑</a-button>
            <a-button type="link" @click="onIssue(record)" v-if="!record.issuedFlag">下达</a-button>
            <a-button type="link" @click="openComplete(record)" v-if="record.issuedFlag && record.status !== 2">完成</a-button>
            <a-button type="link" danger @click="onDelete(record)" v-if="!record.issuedFlag">删除</a-button>
          </div>
        </template>
      </template>
    </a-table>
    <div class="smart-query-table-page">
      <a-pagination showSizeChanger showQuickJumper :pageSizeOptions="PAGE_SIZE_OPTIONS"
        v-model:current="queryForm.pageNum" v-model:pageSize="queryForm.pageSize"
        :total="total" @change="queryData" :show-total="(t) => `共${t}条`" />
    </div>
    <SpreadFormModal ref="formModal" @reload="queryData" />
    <SpreadCompleteModal ref="completeModal" @reload="queryData" />
  </a-card>
</template>
<script setup>
import { ref, reactive, onMounted } from 'vue';
import { message, Modal } from 'ant-design-vue';
import { SearchOutlined, ReloadOutlined, PlusOutlined } from '@ant-design/icons-vue';
import { SmartLoading } from '/@/components/framework/smart-loading';
import { smartSentry } from '/@/lib/smart-sentry';
import { PAGE_SIZE_OPTIONS } from '/@/constants/common-const';
import { fabricSpreadApi } from '/@/api/business/production/spread-api';
import SpreadFormModal from './components/spread-form-modal.vue';
import SpreadCompleteModal from './components/spread-complete-modal.vue';
import _ from 'lodash';

const columns = ref([
  { title: '指令单号', dataIndex: 'orderNo', width: 150 },
  { title: '面料编号', dataIndex: 'fabricNo', width: 120 },
  { title: '面料名称', dataIndex: 'fabricName', width: 130 },
  { title: '颜色', dataIndex: 'colorName', width: 90 },
  { title: '需求层数', dataIndex: 'requireLayers', width: 90 },
  { title: '需求长度(m)', dataIndex: 'requireLength', width: 110 },
  { title: '实际层数', dataIndex: 'actualLayers', width: 90 },
  { title: '实际长度(m)', dataIndex: 'actualLength', width: 110 },
  { title: '状态', dataIndex: 'status', width: 90 },
  { title: '下达', dataIndex: 'issuedFlag', width: 80 },
  { title: '创建时间', dataIndex: 'createTime', width: 160 },
  { title: '操作', dataIndex: 'action', fixed: 'right', width: 180 },
]);

const queryFormState = { orderNo: '', status: undefined, pageNum: 1, pageSize: 10 };
const queryForm = reactive(_.cloneDeep(queryFormState));
const tableData = ref([]);
const total = ref(0);

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
    title: '提示', content: `确定下达铺布任务吗?下达后不可修改。`,
    okText: '下达', okType: 'primary',
    onOk: async () => {
      try {
        SmartLoading.show();
        await fabricSpreadApi.saveAndIssue(row);
        message.success('下达成功');
        queryData();
      } catch (e) { smartSentry.captureError(e); } finally { SmartLoading.hide(); }
    },
  });
}

function onDelete(row) {
  Modal.confirm({
    title: '提示', content: `确定删除该铺布任务吗?`,
    okText: '删除', okType: 'danger',
    onOk: async () => {
      try { SmartLoading.show(); await fabricSpreadApi.delete(row.spreadId); message.success('删除成功'); queryData(); }
      catch (e) { smartSentry.captureError(e); } finally { SmartLoading.hide(); }
    },
  });
}
</script>
