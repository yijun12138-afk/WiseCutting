<template>
  <a-modal :title="form.partId ? '编辑裁片部位' : '新建裁片部位'" v-model:open="visible" @ok="onSubmit" @cancel="onClose" :confirmLoading="loading">
    <a-form ref="formRef" :model="form" :rules="rules" :label-col="{ span: 5 }">
      <a-form-item label="部位名称" name="partName">
        <a-input v-model:value="form.partName" placeholder="请输入部位名称" />
      </a-form-item>
      <a-form-item label="部位编码" name="partCode">
        <a-input v-model:value="form.partCode" placeholder="请输入部位编码" />
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
import { cuttingPartApi } from '/@/api/business/basic/cuttingpart-api';

const emit = defineEmits(['reload']);
const formRef = ref();
const visible = ref(false);
const loading = ref(false);
const formDefault = { partId: undefined, partName: '', partCode: '', remark: '' };
const form = reactive({ ...formDefault });
const rules = { partName: [{ required: true, message: '部位名称不能为空' }] };

function show(row) { Object.assign(form, formDefault); if (row) Object.assign(form, row); visible.value = true; nextTick(() => formRef.value?.clearValidate()); }
function onClose() { visible.value = false; }
async function onSubmit() {
  try { await formRef.value.validate(); loading.value = true; await cuttingPartApi.addOrUpdate(form); message.success(form.partId ? '修改成功' : '添加成功'); onClose(); emit('reload'); }
  catch (e) { smartSentry.captureError(e); } finally { loading.value = false; }
}
defineExpose({ show });
</script>
