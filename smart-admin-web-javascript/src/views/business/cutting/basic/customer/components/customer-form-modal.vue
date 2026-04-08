<template>
  <a-modal :title="form.customerId ? '编辑客户' : '新建客户'" v-model:open="visible" @ok="onSubmit" @cancel="onClose" :confirmLoading="loading">
    <a-form ref="formRef" :model="form" :rules="rules" :label-col="{ span: 5 }">
      <a-form-item label="客户名称" name="customerName">
        <a-input v-model:value="form.customerName" placeholder="请输入客户名称" />
      </a-form-item>
      <a-form-item label="公司名称" name="companyName">
        <a-input v-model:value="form.companyName" placeholder="请输入公司名称" />
      </a-form-item>
      <a-form-item label="联系人" name="contactPerson">
        <a-input v-model:value="form.contactPerson" placeholder="请输入联系人" />
      </a-form-item>
      <a-form-item label="电话" name="phone">
        <a-input v-model:value="form.phone" placeholder="请输入电话" />
      </a-form-item>
      <a-form-item label="等级" name="level">
        <a-input v-model:value="form.level" placeholder="如：A/B/C" />
      </a-form-item>
      <a-form-item label="状态" name="disabledFlag">
        <a-radio-group v-model:value="form.disabledFlag">
          <a-radio :value="false">正常</a-radio>
          <a-radio :value="true">停用</a-radio>
        </a-radio-group>
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
import { customerApi } from '/@/api/business/basic/customer-api';

const emit = defineEmits(['reload']);
const formRef = ref();
const visible = ref(false);
const loading = ref(false);
const formDefault = { customerId: undefined, customerName: '', companyName: '', contactPerson: '', phone: '', level: '', disabledFlag: false, remark: '' };
const form = reactive({ ...formDefault });
const rules = { customerName: [{ required: true, message: '客户名称不能为空' }] };

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
    await customerApi.addOrUpdate(form);
    message.success(form.customerId ? '修改成功' : '添加成功');
    onClose();
    emit('reload');
  } catch (e) { smartSentry.captureError(e); } finally { loading.value = false; }
}
defineExpose({ show });
</script>
