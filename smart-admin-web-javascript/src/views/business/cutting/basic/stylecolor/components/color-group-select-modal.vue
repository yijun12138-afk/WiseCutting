<template>
  <a-modal v-model:open="visible" title="颜色组" width="900px" :footer="null" @cancel="onClose">
    <a-form class="smart-query-form">
      <a-row class="smart-query-form-row">
        <a-form-item label="颜色组：" class="smart-query-form-item">
          <a-input style="width: 200px" v-model:value="queryForm.searchWord" placeholder="颜色组" />
        </a-form-item>
        <a-form-item class="smart-query-form-item">
          <a-button-group>
            <a-button type="primary" @click="onSearch"><SearchOutlined />查询</a-button>
            <a-button @click="resetQuery"><ReloadOutlined />重置</a-button>
          </a-button-group>
          <a-button type="primary" style="margin-left: 12px" @click="openForm(null)"><PlusOutlined />颜色组</a-button>
        </a-form-item>
      </a-row>
    </a-form>
    <a-table size="small" :dataSource="tableData" :columns="columns" rowKey="groupId" :pagination="false" bordered>
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
      <a-pagination
        showSizeChanger
        showQuickJumper
        :pageSizeOptions="PAGE_SIZE_OPTIONS"
        v-model:current="queryForm.pageNum"
        v-model:pageSize="queryForm.pageSize"
        :total="total"
        @change="queryData"
        :show-total="(t) => `共${t}条`"
      />
    </div>
    <ColorGroupFormModal ref="formModal" @reload="onReload" />
  </a-modal>
</template>
<script setup>
  import { ref, reactive } from 'vue';
  import { message, Modal } from 'ant-design-vue';
  import { SearchOutlined, ReloadOutlined, PlusOutlined } from '@ant-design/icons-vue';
  import { PAGE_SIZE_OPTIONS } from '/@/constants/common-const';
  import { smartSentry } from '/@/lib/smart-sentry';
  import { SmartLoading } from '/@/components/framework/smart-loading';
  import { colorGroupApi } from '/@/api/business/basic/color-group-api';
  import ColorGroupFormModal from './color-group-form-modal.vue';
  import _ from 'lodash';

  const emit = defineEmits(['reload']);
  const visible = ref(false);
  const columns = ref([
    { title: '颜色组', dataIndex: 'groupName', width: 180 },
    { title: '创建时间', dataIndex: 'createTime', width: 180 },
    { title: '操作', dataIndex: 'action', width: 120 },
  ]);
  const queryFormState = { searchWord: '', pageNum: 1, pageSize: 10 };
  const queryForm = reactive(_.cloneDeep(queryFormState));
  const tableData = ref([]);
  const total = ref(0);
  const formModal = ref();

  function show() {
    visible.value = true;
    queryData();
  }

  function onClose() {
    visible.value = false;
  }

  function resetQuery() {
    Object.assign(queryForm, _.cloneDeep(queryFormState));
    queryData();
  }

  function onSearch() {
    queryForm.pageNum = 1;
    queryData();
  }

  async function queryData() {
    try {
      const res = await colorGroupApi.query(queryForm);
      tableData.value = res.data.list;
      total.value = res.data.total;
    } catch (e) {
      smartSentry.captureError(e);
    }
  }

  function openForm(row) {
    formModal.value.show(row);
  }

  function onReload() {
    queryData();
    emit('reload');
  }

  function onDelete(row) {
    Modal.confirm({
      title: '提示',
      content: `确定删除【${row.groupName}】吗?`,
      okText: '删除',
      okType: 'danger',
      onOk: async () => {
        try {
          SmartLoading.show();
          await colorGroupApi.delete(row.groupId);
          message.success('删除成功');
          onReload();
        } catch (e) {
          smartSentry.captureError(e);
        } finally {
          SmartLoading.hide();
        }
      },
    });
  }

  defineExpose({ show });
</script>
