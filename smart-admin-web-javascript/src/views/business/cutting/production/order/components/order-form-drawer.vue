<template>
  <a-drawer :title="form.orderId ? '编辑指令单' : '新建指令单'" :width="700" :open="visible" @close="onClose">
    <a-form ref="formRef" :model="form" :rules="rules" :label-col="{ span: 5 }">
      <a-form-item label="客户" name="customerId">
        <a-select v-model:value="form.customerId" placeholder="请选择客户" style="width:100%" @change="onCustomerChange">
          <a-select-option v-for="c in customerList" :key="c.customerId" :value="c.customerId">{{ c.customerName }}</a-select-option>
        </a-select>
      </a-form-item>
      <a-form-item label="款号" name="styleNo">
        <a-input v-model:value="form.styleNo" placeholder="请输入款号" />
      </a-form-item>
      <a-form-item label="款名" name="styleName">
        <a-input v-model:value="form.styleName" placeholder="请输入款名" />
      </a-form-item>
      <a-form-item label="交货日期" name="deliveryDate">
        <a-date-picker style="width:100%" v-model:value="form.deliveryDate" valueFormat="YYYY-MM-DD" placeholder="请选择交货日期" />
      </a-form-item>
      <a-form-item label="单价" name="unitPrice">
        <a-input-number style="width:100%" v-model:value="form.unitPrice" :min="0" :precision="2" placeholder="单价" />
      </a-form-item>
      <a-form-item label="下单数量" name="orderQuantity">
        <a-input-number style="width:100%" v-model:value="form.orderQuantity" :min="1" placeholder="下单数量" />
      </a-form-item>
      <a-form-item label="备注" name="remark">
        <a-textarea v-model:value="form.remark" placeholder="请输入备注" :rows="2" />
      </a-form-item>
    </a-form>
    <div style="position:absolute;right:0;bottom:0;width:100%;border-top:1px solid #e9e9e9;padding:10px 16px;background:#fff;text-align:right;z-index:1;">
      <a-button style="margin-right:8px" @click="onClose">取消</a-button>
      <a-button type="primary" :loading="loading" @click="onSubmit">提交</a-button>
    </div>
  </a-drawer>
</template>
<script setup>
import { ref, reactive, nextTick, onMounted } from 'vue';
import { message } from 'ant-design-vue';
import { smartSentry } from '/@/lib/smart-sentry';
import { productionOrderApi } from '/@/api/business/production/order-api';
import { customerApi } from '/@/api/business/basic/customer-api';

const emit = defineEmits(['reload']);
const formRef = ref();
const visible = ref(false);
const loading = ref(false);
const customerList = ref([]);

const formDefault = {
  orderId: undefined, customerId: undefined, customerName: '',
  styleNo: '', styleName: '', deliveryDate: undefined,
  unitPrice: undefined, orderQuantity: undefined, remark: '',
};
const form = reactive({ ...formDefault });
const rules = {
  customerId: [{ required: true, message: '请选择客户' }],
  styleNo: [{ required: true, message: '款号不能为空' }],
  orderQuantity: [{ required: true, message: '下单数量不能为空' }],
};

onMounted(async () => {
  try {
    const res = await customerApi.listAll();
    customerList.value = res.data || [];
  } catch (e) { smartSentry.captureError(e); }
});

function onCustomerChange(val) {
  const c = customerList.value.find(x => x.customerId === val);
  form.customerName = c ? c.customerName : '';
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
    await productionOrderApi.addOrUpdate(form);
    message.success(form.orderId ? '修改成功' : '添加成功');
    onClose();
    emit('reload');
  } catch (e) { smartSentry.captureError(e); } finally { loading.value = false; }
}
defineExpose({ show });
</script>
