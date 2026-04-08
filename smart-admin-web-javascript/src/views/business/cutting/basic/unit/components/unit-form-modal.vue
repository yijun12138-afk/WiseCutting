<template>
  <a-modal :title="form.unitId ? '编辑单位' : '新建单位'" v-model:open="visible" @ok="onSubmit" @cancel="onClose" :confirmLoading="loading">
    <a-form ref="formRef" :model="form" :rules="rules" :label-col="{ span: 5 }">
      <a-form-item label="单位名称" name="unitName">
        <a-input v-model:value="form.unitName" placeholder="请输入单位名称" />
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
import { unitApi } from '/@/api/business/basic/unit-api';

const emit = defineEmits(['reload']);
const formRef = ref();
const visible = ref(false);
const loading = ref(false);
const formDefault = { unitId: undefined, unitName: '', remark: '' };
const form = reactive({ ...formDefault });
const rules = { unitName: [{ required: true, message: '单位名称不能为空' }] };

function show(row) { Object.assign(form, formDefault); if (row) Object.assign(form, row); visible.value = true; nextTick(() => formRef.value?.clearValidate()); }
function onClose() { visible.value = false; }
async function onSubmit() {
  try { await formRef.value.validate(); loading.value = true; await unitApi.addOrUpdate(form); message.success(form.unitId ? '修改成功' : '添加成功'); onClose(); emit('reload'); }
  catch (e) { smartSentry.captureError(e); } finally { loading.value = false; }
}
defineExpose({ show });
</script>
