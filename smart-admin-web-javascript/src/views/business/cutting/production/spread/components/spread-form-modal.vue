<template>
  <a-modal :title="form.spreadId ? '编辑铺布任务' : '新建铺布任务'" v-model:open="visible" @ok="onSubmit" @cancel="onClose" :confirmLoading="loading" width="600px">
    <a-form ref="formRef" :model="form" :rules="rules" :label-col="{ span: 6 }">
      <a-form-item label="指令单号" name="orderId">
        <a-select v-model:value="form.orderId" placeholder="请选择指令单" style="width:100%" @change="onOrderChange" showSearch optionFilterProp="children">
          <a-select-option v-for="o in orderList" :key="o.orderId" :value="o.orderId">{{ o.orderNo }}</a-select-option>
        </a-select>
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
      <a-form-item label="需求层数" name="requireLayers">
        <a-input-number style="width:100%" v-model:value="form.requireLayers" :min="1" placeholder="需求层数" />
      </a-form-item>
      <a-form-item label="需求长度(m)" name="requireLength">
        <a-input-number style="width:100%" v-model:value="form.requireLength" :min="0" :precision="2" placeholder="需求长度" />
      </a-form-item>
      <a-form-item label="备注" name="remark">
        <a-input v-model:value="form.remark" placeholder="请输入备注" />
      </a-form-item>
    </a-form>
  </a-modal>
</template>
<script setup>
import { ref, reactive, nextTick, onMounted } from 'vue';
import { message } from 'ant-design-vue';
import { smartSentry } from '/@/lib/smart-sentry';
import { fabricSpreadApi } from '/@/api/business/production/spread-api';
import { productionOrderApi } from '/@/api/business/production/order-api';

const emit = defineEmits(['reload']);
const formRef = ref();
const visible = ref(false);
const loading = ref(false);
const orderList = ref([]);

const formDefault = {
  spreadId: undefined, orderId: undefined, orderNo: '',
  fabricId: undefined, fabricNo: '', fabricName: '', colorName: '',
  requireLayers: undefined, requireLength: undefined, remark: '',
};
const form = reactive({ ...formDefault });
const rules = { orderId: [{ required: true, message: '请选择指令单' }] };

onMounted(async () => {
  try {
    const res = await productionOrderApi.query({ pageNum: 1, pageSize: 200, status: 2 });
    orderList.value = res.data?.list || [];
  } catch (e) { smartSentry.captureError(e); }
});

function onOrderChange(val) {
  const o = orderList.value.find(x => x.orderId === val);
  form.orderNo = o ? o.orderNo : '';
}

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
    await fabricSpreadApi.save(form);
    message.success(form.spreadId ? '修改成功' : '添加成功');
    onClose();
    emit('reload');
  } catch (e) { smartSentry.captureError(e); } finally { loading.value = false; }
}
defineExpose({ show });
</script>
