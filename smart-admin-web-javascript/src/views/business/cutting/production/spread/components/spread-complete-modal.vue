<template>
  <a-modal title="完成铺布" v-model:open="visible" @ok="onSubmit" @cancel="onClose" :confirmLoading="loading">
    <a-form ref="formRef" :model="form" :label-col="{ span: 6 }">
      <a-form-item label="实际层数" name="actualLayers">
        <a-input-number style="width:100%" v-model:value="form.actualLayers" :min="0" placeholder="实际层数" />
      </a-form-item>
      <a-form-item label="实际长度(m)" name="actualLength">
        <a-input-number style="width:100%" v-model:value="form.actualLength" :min="0" :precision="2" placeholder="实际长度" />
      </a-form-item>
    </a-form>
  </a-modal>
</template>
<script setup>
import { ref, reactive, nextTick } from 'vue';
import { message } from 'ant-design-vue';
import { smartSentry } from '/@/lib/smart-sentry';
import { fabricSpreadApi } from '/@/api/business/production/spread-api';

const emit = defineEmits(['reload']);
const formRef = ref();
const visible = ref(false);
const loading = ref(false);
const form = reactive({ spreadId: undefined, actualLayers: undefined, actualLength: undefined });

function show(row) {
  form.spreadId = row.spreadId;
  form.actualLayers = row.actualLayers;
  form.actualLength = row.actualLength;
  visible.value = true;
  nextTick(() => formRef.value?.clearValidate());
}
function onClose() { visible.value = false; }
async function onSubmit() {
  try {
    loading.value = true;
    await fabricSpreadApi.complete(form);
    message.success('完成成功');
    onClose();
    emit('reload');
  } catch (e) { smartSentry.captureError(e); } finally { loading.value = false; }
}
defineExpose({ show });
</script>
