<template>
  <a-form class="smart-query-form">
    <a-row class="smart-query-form-row">
      <a-form-item label="关键字" class="smart-query-form-item">
        <a-input style="width:200px" v-model:value="queryForm.searchWord" placeholder="客户名称/公司名称" />
      </a-form-item>
      <a-form-item label="停用标识" class="smart-query-form-item">
        <a-select style="width:120px" v-model:value="queryForm.disabledFlag" placeholder="全部" allowClear>
          <a-select-option :value="false">正常</a-select-option>
          <a-select-option :value="true">停用</a-select-option>
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
    <a-table size="small" :dataSource="tableData" :columns="columns" rowKey="customerId" :pagination="false" bordered>
      <template #bodyCell="{ text, record, column }">
        <template v-if="column.dataIndex === 'disabledFlag'">
          <a-tag :color="text ? 'red' : 'green'">{{ text ? '停用' : '正常' }}</a-tag>
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
    <CustomerFormModal ref="formModal" @reload="queryData" />
  </a-card>
</template>
<script setup>
import { ref, reactive, onMounted } from 'vue';
import { message, Modal } from 'ant-design-vue';
import { SearchOutlined, ReloadOutlined, PlusOutlined } from '@ant-design/icons-vue';
import { SmartLoading } from '/@/components/framework/smart-loading';
import { smartSentry } from '/@/lib/smart-sentry';
import { PAGE_SIZE_OPTIONS } from '/@/constants/common-const';
import { customerApi } from '/@/api/business/basic/customer-api';
import CustomerFormModal from './components/customer-form-modal.vue';
import _ from 'lodash';

const columns = ref([
  { title: '客户名称', dataIndex: 'customerName', width: 150 },
  { title: '公司名称', dataIndex: 'companyName', width: 200 },
  { title: '联系人', dataIndex: 'contactPerson', width: 100 },
  { title: '电话', dataIndex: 'phone', width: 130 },
  { title: '等级', dataIndex: 'level', width: 80 },
  { title: '状态', dataIndex: 'disabledFlag', width: 80 },
  { title: '备注', dataIndex: 'remark', ellipsis: true, width: 150 },
  { title: '创建时间', dataIndex: 'createTime', width: 160 },
  { title: '操作', dataIndex: 'action', fixed: 'right', width: 120 },
]);

const queryFormState = { searchWord: '', disabledFlag: undefined, pageNum: 1, pageSize: 10 };
const queryForm = reactive(_.cloneDeep(queryFormState));
const tableData = ref([]);
const total = ref(0);

function resetQuery() { Object.assign(queryForm, _.cloneDeep(queryFormState)); queryData(); }
function onSearch() { queryForm.pageNum = 1; queryData(); }

async function queryData() {
  try {
    const res = await customerApi.query(queryForm);
    tableData.value = res.data.list;
    total.value = res.data.total;
  } catch (e) { smartSentry.captureError(e); }
}
onMounted(queryData);

const formModal = ref();
function openForm(row) { formModal.value.show(row); }

function onDelete(row) {
  Modal.confirm({
    title: '提示', content: `确定删除【${row.customerName}】吗?`,
    okText: '删除', okType: 'danger',
    onOk: async () => {
      try { SmartLoading.show(); await customerApi.delete(row.customerId); message.success('删除成功'); queryData(); }
      catch (e) { smartSentry.captureError(e); } finally { SmartLoading.hide(); }
    },
  });
}
</script>
