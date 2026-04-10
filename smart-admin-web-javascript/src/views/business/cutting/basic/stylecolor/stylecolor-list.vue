<template>
  <a-form class="smart-query-form">
    <a-row class="smart-query-form-row">
      <a-form-item label="关键字" class="smart-query-form-item">
        <a-input style="width:200px" v-model:value="queryForm.searchWord" placeholder="颜色名称/备注" />
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
      <div class="smart-table-setting-block">
        <TableOperator v-model="columns" :tableId="51003" :refresh="queryData" />
      </div>
    </a-row>
    <a-table size="small" :dataSource="tableData" :columns="columns" rowKey="colorId" :pagination="false" bordered>
      <template #bodyCell="{ record, column }">
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
    <StyleColorFormModal ref="formModal" @reload="queryData" />
  </a-card>
</template>
<script setup>
import { ref, reactive, onMounted } from 'vue';
import { message, Modal } from 'ant-design-vue';
import { SearchOutlined, ReloadOutlined, PlusOutlined } from '@ant-design/icons-vue';
import { SmartLoading } from '/@/components/framework/smart-loading';
import { smartSentry } from '/@/lib/smart-sentry';
import { PAGE_SIZE_OPTIONS } from '/@/constants/common-const';
import { styleColorApi } from '/@/api/business/basic/stylecolor-api';
import StyleColorFormModal from './components/stylecolor-form-modal.vue';
import _ from 'lodash';
import TableOperator from '/@/components/support/table-operator/index.vue';

const columns = ref([
  { title: '颜色名称', dataIndex: 'colorName', width: 150 },
  { title: '创建时间', dataIndex: 'createTime', width: 160 },
  { title: '创建人', dataIndex: 'createUserName', width: 100 },
  { title: '备注', dataIndex: 'remark', ellipsis: true, width: 200 },
  { title: '操作', dataIndex: 'action', fixed: 'right', width: 120 },
]);

const queryFormState = { searchWord: '', pageNum: 1, pageSize: 10 };
const queryForm = reactive(_.cloneDeep(queryFormState));
const tableData = ref([]);
const total = ref(0);

function resetQuery() { Object.assign(queryForm, _.cloneDeep(queryFormState)); queryData(); }
function onSearch() { queryForm.pageNum = 1; queryData(); }

async function queryData() {
  try {
    const res = await styleColorApi.query(queryForm);
    tableData.value = res.data.list;
    total.value = res.data.total;
  } catch (e) { smartSentry.captureError(e); }
}
onMounted(queryData);

const formModal = ref();
function openForm(row) { formModal.value.show(row); }

function onDelete(row) {
  Modal.confirm({
    title: '提示', content: `确定删除【${row.colorName}】吗?`,
    okText: '删除', okType: 'danger',
    onOk: async () => {
      try { SmartLoading.show(); await styleColorApi.delete(row.colorId); message.success('删除成功'); queryData(); }
      catch (e) { smartSentry.captureError(e); } finally { SmartLoading.hide(); }
    },
  });
}
</script>
