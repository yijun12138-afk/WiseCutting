<template>
  <a-modal :title="form.cuttingOrderId ? '编辑裁床单' : '新建裁床单'" v-model:open="visible" @ok="onSubmit" @cancel="onClose" :confirmLoading="loading" width="700px">
    <a-form ref="formRef" :model="form" :label-col="{ span: 6 }">
      <a-row :gutter="16">
        <a-col :span="12">
          <a-form-item label="指令单号" name="orderNo">
            <a-input v-model:value="form.orderNo" placeholder="指令单号" />
          </a-form-item>
        </a-col>
        <a-col :span="12">
          <a-form-item label="客户名称" name="customerName">
            <a-input v-model:value="form.customerName" placeholder="客户名称" />
          </a-form-item>
        </a-col>
        <a-col :span="12">
          <a-form-item label="款号" name="styleNo">
            <a-input v-model:value="form.styleNo" placeholder="款号" />
          </a-form-item>
        </a-col>
        <a-col :span="12">
          <a-form-item label="款名" name="styleName">
            <a-input v-model:value="form.styleName" placeholder="款名" />
          </a-form-item>
        </a-col>
        <a-col :span="12">
          <a-form-item label="颜色" name="colorName">
            <a-input v-model:value="form.colorName" placeholder="颜色" />
          </a-form-item>
        </a-col>
        <a-col :span="12">
          <a-form-item label="尺码" name="sizeName">
            <a-input v-model:value="form.sizeName" placeholder="尺码" />
          </a-form-item>
        </a-col>
        <a-col :span="12">
          <a-form-item label="数量" name="quantity">
            <a-input-number style="width:100%" v-model:value="form.quantity" :min="0" placeholder="数量" />
          </a-form-item>
        </a-col>
        <a-col :span="12">
          <a-form-item label="床号" name="bedNo">
            <a-input v-model:value="form.bedNo" placeholder="床号" />
          </a-form-item>
        </a-col>
        <a-col :span="12">
          <a-form-item label="层数" name="layers">
            <a-input-number style="width:100%" v-model:value="form.layers" :min="0" placeholder="层数" />
          </a-form-item>
        </a-col>
        <a-col :span="12">
          <a-form-item label="面料编号" name="fabricNo">
            <a-input v-model:value="form.fabricNo" placeholder="面料编号" />
          </a-form-item>
        </a-col>
        <a-col :span="12">
          <a-form-item label="面料名称" name="fabricName">
            <a-input v-model:value="form.fabricName" placeholder="面料名称" />
          </a-form-item>
        </a-col>
        <a-col :span="12">
          <a-form-item label="状态" name="status">
            <a-select v-model:value="form.status" style="width:100%">
              <a-select-option :value="1">待裁</a-select-option>
              <a-select-option :value="2">裁剪中</a-select-option>
              <a-select-option :value="3">完成</a-select-option>
            </a-select>
          </a-form-item>
        </a-col>
        <a-col :span="24">
          <a-form-item label="备注" name="remark" :label-col="{ span: 3 }">
            <a-input v-model:value="form.remark" placeholder="备注" />
          </a-form-item>
        </a-col>
      </a-row>
    </a-form>
  </a-modal>
</template>
<script setup>
import { ref, reactive, nextTick } from 'vue';
import { message } from 'ant-design-vue';
import { smartSentry } from '/@/lib/smart-sentry';
import { cuttingOrderApi } from '/@/api/business/cutting/cutting-order-api';

const emit = defineEmits(['reload']);
const formRef = ref();
const visible = ref(false);
const loading = ref(false);
const formDefault = {
  cuttingOrderId: undefined, planId: undefined, planNo: '', orderId: undefined, orderNo: '',
  customerName: '', styleNo: '', styleName: '', colorName: '', sizeName: '',
  quantity: undefined, bedNo: '', layers: undefined, fabricNo: '', fabricName: '',
  status: 1, remark: '',
};
const form = reactive({ ...formDefault });

function show(row) {
  Object.assign(form, formDefault);
  if (row) Object.assign(form, row);
  visible.value = true;
  nextTick(() => formRef.value?.clearValidate());
}
function onClose() { visible.value = false; }
async function onSubmit() {
  try {
    loading.value = true;
    await cuttingOrderApi.addOrUpdate(form);
    message.success(form.cuttingOrderId ? '修改成功' : '添加成功');
    onClose();
    emit('reload');
  } catch (e) { smartSentry.captureError(e); } finally { loading.value = false; }
}
defineExpose({ show });
</script>
