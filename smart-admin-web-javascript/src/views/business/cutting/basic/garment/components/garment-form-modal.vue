<template>
  <a-modal :title="form.garmentId ? '编辑成衣' : '新建成衣'" v-model:open="visible" @ok="onSubmit" @cancel="onClose" :confirmLoading="loading" width="600px">
    <a-form ref="formRef" :model="form" :rules="rules" :label-col="{ span: 5 }">
      <a-form-item label="成衣编号" name="garmentNo">
        <a-input v-model:value="form.garmentNo" placeholder="请输入成衣编号" />
      </a-form-item>
      <a-form-item label="成衣名称" name="garmentName">
        <a-input v-model:value="form.garmentName" placeholder="请输入成衣名称" />
      </a-form-item>
      <a-form-item label="成衣类型" name="garmentType">
        <a-input v-model:value="form.garmentType" placeholder="如：上衣/裤子/裙子" />
      </a-form-item>
      <a-form-item label="单位名称" name="unitName">
        <a-input v-model:value="form.unitName" placeholder="如：件/套" />
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
import { garmentApi } from '/@/api/business/basic/garment-api';

const emit = defineEmits(['reload']);
const formRef = ref();
const visible = ref(false);
const loading = ref(false);
const formDefault = { garmentId: undefined, garmentNo: '', garmentName: '', garmentType: '', unitId: undefined, unitName: '', remark: '' };
const form = reactive({ ...formDefault });
const rules = {
  garmentNo: [{ required: true, message: '成衣编号不能为空' }],
  garmentName: [{ required: true, message: '成衣名称不能为空' }],
};

function show(row) { Object.assign(form, formDefault); if (row) Object.assign(form, row); visible.value = true; nextTick(() => formRef.value?.clearValidate()); }
function onClose() { visible.value = false; }
async function onSubmit() {
  try { await formRef.value.validate(); loading.value = true; await garmentApi.addOrUpdate(form); message.success(form.garmentId ? '修改成功' : '添加成功'); onClose(); emit('reload'); }
  catch (e) { smartSentry.captureError(e); } finally { loading.value = false; }
}
defineExpose({ show });
</script>
