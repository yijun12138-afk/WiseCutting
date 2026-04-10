<template>
  <a-modal :title="form.groupId ? '编辑颜色组' : '新建颜色组'" v-model:open="visible" @ok="onSubmit" @cancel="onClose" :confirmLoading="loading">
    <a-form ref="formRef" :model="form" :rules="rules" :label-col="{ span: 5 }">
      <a-form-item label="颜色组" name="groupName">
        <a-input v-model:value="form.groupName" placeholder="请输入颜色组" />
      </a-form-item>
      <a-form-item label="备注" name="remark">
        <a-input v-model:value="form.remark" placeholder="请输入备注" />
      </a-form-item>
    </a-form>
  </a-modal>
</template>
<script setup>
  import { ref, reactive, nextTick } from 'vue';
  import { message } from 'ant-design-vue';
  import { smartSentry } from '/@/lib/smart-sentry';
  import { colorGroupApi } from '/@/api/business/basic/color-group-api';

  const emit = defineEmits(['reload']);
  const formRef = ref();
  const visible = ref(false);
  const loading = ref(false);
  const formDefault = { groupId: undefined, groupName: '', remark: '' };
  const form = reactive({ ...formDefault });
  const rules = {
    groupName: [{ required: true, message: '颜色组不能为空' }],
  };

  function show(row) {
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
      await colorGroupApi.addOrUpdate(form);
      message.success(form.groupId ? '修改成功' : '添加成功');
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
