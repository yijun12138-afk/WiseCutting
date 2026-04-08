<template>
  <a-modal :title="form.fabricId ? '编辑面料' : '新建面料'" v-model:open="visible" @ok="onSubmit" @cancel="onClose" :confirmLoading="loading" width="600px">
    <a-form ref="formRef" :model="form" :rules="rules" :label-col="{ span: 5 }">
      <a-form-item label="面料编号" name="fabricNo">
        <a-input v-model:value="form.fabricNo" placeholder="请输入面料编号" />
      </a-form-item>
      <a-form-item label="面料名称" name="fabricName">
        <a-input v-model:value="form.fabricName" placeholder="请输入面料名称" />
      </a-form-item>
      <a-form-item label="面料类型" name="fabricType">
        <a-input v-model:value="form.fabricType" placeholder="如：梭织/针织" />
      </a-form-item>
      <a-form-item label="单位名称" name="unitName">
        <a-input v-model:value="form.unitName" placeholder="如：米/码" />
      </a-form-item>
      <a-form-item label="克重(g/m²)" name="gramWeight">
        <a-input-number style="width:100%" v-model:value="form.gramWeight" :min="0" :precision="2" placeholder="克重" />
      </a-form-item>
      <a-form-item label="幅宽(cm)" name="width">
        <a-input-number style="width:100%" v-model:value="form.width" :min="0" :precision="2" placeholder="幅宽" />
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
import { fabricApi } from '/@/api/business/basic/fabric-api';

const emit = defineEmits(['reload']);
const formRef = ref();
const visible = ref(false);
const loading = ref(false);
const formDefault = { fabricId: undefined, fabricNo: '', fabricName: '', fabricType: '', unitId: undefined, unitName: '', gramWeight: undefined, width: undefined, remark: '' };
const form = reactive({ ...formDefault });
const rules = {
  fabricNo: [{ required: true, message: '面料编号不能为空' }],
  fabricName: [{ required: true, message: '面料名称不能为空' }],
};

function show(row) { Object.assign(form, formDefault); if (row) Object.assign(form, row); visible.value = true; nextTick(() => formRef.value?.clearValidate()); }
function onClose() { visible.value = false; }
async function onSubmit() {
  try { await formRef.value.validate(); loading.value = true; await fabricApi.addOrUpdate(form); message.success(form.fabricId ? '修改成功' : '添加成功'); onClose(); emit('reload'); }
  catch (e) { smartSentry.captureError(e); } finally { loading.value = false; }
}
defineExpose({ show });
</script>
