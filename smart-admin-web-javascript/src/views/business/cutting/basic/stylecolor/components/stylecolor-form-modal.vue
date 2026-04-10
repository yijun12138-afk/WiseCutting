<template>
  <a-modal :title="form.colorId ? '编辑款式颜色' : '新建款式颜色'" v-model:open="visible" @ok="onSubmit" @cancel="onClose" :confirmLoading="loading">
    <a-form ref="formRef" :model="form" :rules="rules" :label-col="{ span: 5 }">
      <a-form-item label="颜色组" name="colorGroupId">
        <a-select v-model:value="form.colorGroupId" placeholder="请选择颜色组">
          <a-select-option v-for="item in colorGroupList" :key="item.groupId" :value="item.groupId">
            {{ item.groupName }}
          </a-select-option>
        </a-select>
      </a-form-item>
      <a-form-item label="颜色名称" name="colorName">
        <a-input v-model:value="form.colorName" placeholder="请输入颜色名称" />
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
  import { colorGroupApi } from '/@/api/business/basic/color-group-api';
  import { styleColorApi } from '/@/api/business/basic/stylecolor-api';
  import { smartSentry } from '/@/lib/smart-sentry';

  const emit = defineEmits(['reload']);
  const formRef = ref();
  const visible = ref(false);
  const loading = ref(false);
  const colorGroupList = ref([]);
  const formDefault = {
    colorId: undefined,
    colorGroupId: undefined,
    colorName: '',
    remark: '',
  };
  const form = reactive({ ...formDefault });
  const rules = {
    colorGroupId: [{ required: true, message: '颜色组不能为空' }],
    colorName: [{ required: true, message: '颜色名称不能为空' }],
  };

  async function loadColorGroupList() {
    const res = await colorGroupApi.listAll();
    colorGroupList.value = res.data || [];
  }

  async function show(row) {
    try {
      await loadColorGroupList();
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
      await styleColorApi.addOrUpdate(form);
      message.success(form.colorId ? '修改成功' : '添加成功');
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
