<template>
  <a-modal :title="form.relaxId ? '编辑松布任务' : '新建松布任务'" v-model:open="visible" @ok="onSubmit" @cancel="onClose" :confirmLoading="loading" width="600px">
    <a-form ref="formRef" :model="form" :rules="rules" :label-col="{ span: 6 }">
      <a-form-item label="指令单号" name="orderNo">
        <a-input v-model:value="form.orderNo" placeholder="请输入指令单号" />
      </a-form-item>
      <a-form-item label="面料编号" name="fabricNo">
        <a-input v-model:value="form.fabricNo" placeholder="请输入面料编号" />
      </a-form-item>
      <a-form-item label="面料名称" name="fabricName">
        <a-input v-model:value="form.fabricName" placeholder="请输入面料名称" />
      </a-form-item>
      <a-form-item label="颜色" name="colorName">
        <a-input v-model:value="form.colorName" placeholder="请输入颜色" />
      </a-form-item>
      <a-form-item label="需求长度(m)" name="requireLength">
        <a-input-number style="width:100%" v-model:value="form.requireLength" :min="0" :precision="2" placeholder="需求长度" />
      </a-form-item>
      <a-form-item label="实际长度(m)" name="actualLength">
        <a-input-number style="width:100%" v-model:value="form.actualLength" :min="0" :precision="2" placeholder="实际长度" />
      </a-form-item>
      <a-form-item label="松布时长(h)" name="relaxHours">
        <a-input-number style="width:100%" v-model:value="form.relaxHours" :min="0" :precision="1" placeholder="松布时长" />
      </a-form-item>
      <a-form-item label="状态" name="status">
        <a-select v-model:value="form.status" style="width:100%">
          <a-select-option :value="0">计划</a-select-option>
          <a-select-option :value="1">进行中</a-select-option>
          <a-select-option :value="2">完成</a-select-option>
        </a-select>
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
import { fabricRelaxApi } from '/@/api/business/production/relax-api';

const emit = defineEmits(['reload']);
const formRef = ref();
const visible = ref(false);
const loading = ref(false);
const formDefault = {
  relaxId: undefined, orderId: undefined, orderNo: '',
  fabricId: undefined, fabricNo: '', fabricName: '', colorName: '',
  requireLength: undefined, actualLength: undefined, relaxHours: undefined,
  status: 0, remark: '',
};
const form = reactive({ ...formDefault });
const rules = { orderNo: [{ required: true, message: '指令单号不能为空' }] };

function show(row) {
  Object.assign(form, formDefault);
  if (row) Object.assign(form, row);
  visible.value = true;
  nextTick(() => formRef.value?.clearValidate());
}
function onClose() { visible.value = false; }
async function onSubmit() {
  try {
    await formRef.value.validate();
    loading.value = true;
    await fabricRelaxApi.addOrUpdate(form);
    message.success(form.relaxId ? '修改成功' : '添加成功');
    onClose();
    emit('reload');
  } catch (e) { smartSentry.captureError(e); } finally { loading.value = false; }
}
defineExpose({ show });
</script>
