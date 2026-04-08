<template>
  <a-form class="smart-query-form">
    <a-row class="smart-query-form-row">
      <a-form-item label="指令单号" class="smart-query-form-item">
        <a-input style="width:180px" v-model:value="queryForm.orderNo" placeholder="指令单号" />
      </a-form-item>
      <a-form-item label="状态" class="smart-query-form-item">
        <a-select style="width:120px" v-model:value="queryForm.status" placeholder="全部" allowClear>
          <a-select-option :value="0">计划</a-select-option>
          <a-select-option :value="1">进行中</a-select-option>
          <a-select-option :value="2">完成</a-select-option>
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
        <a-button type="primary" @click="openForm(null)"><PlusOutlined />新建松布计划</a-button>
      </div>
    </a-row>
    <a-table size="small" :dataSource="tableData" :columns="columns" rowKey="relaxId" :pagination="false" bordered>
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
    <RelaxFormModal ref="formModal" @reload="queryData" />
  </a-card>
</template>
<script setup>
import { ref, reactive, onMounted } from 'vue';
import { message, Modal } from 'ant-design-vue';
import { SearchOutlined, ReloadOutlined, PlusOutlined } from '@ant-design/icons-vue';
import { SmartLoading } from '/@/components/framework/smart-loading';
import { smartSentry } from '/@/lib/smart-sentry';
import { PAGE_SIZE_OPTIONS } from '/@/constants/common-const';
import { fabricRelaxApi } from '/@/api/business/production/relax-api';
import RelaxFormModal from '../../production/relax/components/relax-form-modal.vue';
import _ from 'lodash';

const columns = [
  { title: '指令单号', dataIndex: 'orderNo', width: 140 },
  { title: '面料编号', dataIndex: 'fabricNo', width: 120 },
  { title: '面料名称', dataIndex: 'fabricName', width: 130 },
  { title: '颜色', dataIndex: 'colorName', width: 90 },
  { title: '需求长度(m)', dataIndex: 'requireLength', width: 110 },
  { title: '实际长度(m)', dataIndex: 'actualLength', width: 110 },
  { title: '松布时长(h)', dataIndex: 'relaxHours', width: 110 },
  { title: '状态', dataIndex: 'status', width: 80 },
  { title: '创建时间', dataIndex: 'createTime', width: 160 },
  { title: '操作', dataIndex: 'action', fixed: 'right', width: 120 },
];

const queryFormState = { orderNo: '', status: undefined, pageNum: 1, pageSize: 10 };
const queryForm = reactive(_.cloneDeep(queryFormState));
const tableData = ref([]);
const total = ref(0);

function statusText(s) { return { 0: '计划', 1: '进行中', 2: '完成' }[s] ?? s; }
function statusColor(s) { return { 0: 'default', 1: 'blue', 2: 'green' }[s] ?? 'default'; }
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
