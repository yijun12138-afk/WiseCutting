<template>
  <a-modal :title="form.sizeId ? '编辑尺寸' : '新建尺寸'" v-model:open="visible" @ok="onSubmit" @cancel="onClose" :confirmLoading="loading">
    <a-form ref="formRef" :model="form" :rules="rules" :label-col="{ span: 5 }">
      <a-form-item label="尺码组" name="sizeGroupId">
        <a-select v-model:value="form.sizeGroupId" placeholder="请选择尺码组">
          <a-select-option v-for="item in sizeGroupList" :key="item.groupId" :value="item.groupId">
            {{ item.groupName }}
          </a-select-option>
        </a-select>
      </a-form-item>
      <a-form-item label="尺寸名称" name="sizeName">
        <a-input v-model:value="form.sizeName" placeholder="请输入尺寸名称" />
      </a-form-item>
      <a-form-item label="排序" name="sort">
        <a-input-number v-model:value="form.sort" style="width: 100%" :min="0" placeholder="排序" />
      </a-form-item>
      <a-form-item label="备注" name="remark">
        <a-input v-model:value="form.remark" placeholder="请输入备注" />
      </a-form-item>
    </a-form>
  </a-modal>
</template>

<script setup>
  import { nextTick, reactive, ref } from 'vue';
  import { message } from 'ant-design-vue';
  import { sizeApi } from '/@/api/business/basic/size-api';
  import { sizeGroupApi } from '/@/api/business/basic/size-group-api';
  import { smartSentry } from '/@/lib/smart-sentry';

  const emit = defineEmits(['reload']);
  const formRef = ref();
  const visible = ref(false);
  const loading = ref(false);
  const sizeGroupList = ref([]);
  const formDefault = {
    sizeId: undefined,
    sizeGroupId: undefined,
    sizeName: '',
    sort: 0,
    remark: '',
  };
  const form = reactive({ ...formDefault });
  const rules = {
    sizeGroupId: [{ required: true, message: '尺码组不能为空' }],
    sizeName: [{ required: true, message: '尺寸名称不能为空' }],
  };

  async function loadSizeGroupList() {
    const res = await sizeGroupApi.listAll();
    sizeGroupList.value = res.data || [];
  }

  async function show(row) {
    try {
      await loadSizeGroupList();
    } catch (e) {
      smartSentry.captureError(e);
    }
    Object.assign(form, formDefault);
    if (row) {
      Object.assign(form, row);
    }
    visible.value = true;
    nextTick(() => formRef.value?.clearValidate());
  }

  function onClose() {
    visible.value = false;
  }

  async function onSubmit() {
    try {
      await formRef.value.validate();
      loading.value = true;
      await sizeApi.addOrUpdate(form);
      message.success(form.sizeId ? '修改成功' : '添加成功');
      onClose();
      emit('reload');
    } catch (e) {
      smartSentry.captureError(e);
    } finally {
      loading.value = false;
    }
  }

  defineExpose({ show });
</script>
