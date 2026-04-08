<template>
  <a-modal :title="form.planId ? '编辑裁剪计划' : '新建裁剪计划'" v-model:open="visible" @ok="onSubmit" @cancel="onClose" :confirmLoading="loading" width="600px">
    <a-form ref="formRef" :model="form" :rules="rules" :label-col="{ span: 6 }">
      <a-form-item label="指令单" name="orderId">
        <a-select v-model:value="form.orderId" placeholder="请选择指令单" style="width:100%" @change="onOrderChange" showSearch optionFilterProp="children" allowClear>
          <a-select-option v-for="o in orderList" :key="o.orderId" :value="o.orderId">{{ o.orderNo }}</a-select-option>
        </a-select>
      </a-form-item>
      <a-form-item label="客户名称" name="customerName">
        <a-input v-model:value="form.customerName" placeholder="选择指令单后自动填充" />
      </a-form-item>
      <a-form-item label="款号" name="styleNo">
        <a-input v-model:value="form.styleNo" placeholder="选择指令单后自动填充" />
      </a-form-item>
      <a-form-item label="款名" name="styleName">
        <a-input v-model:value="form.styleName" placeholder="选择指令单后自动填充" />
      </a-form-item>
      <a-form-item label="计划日期" name="planDate">
        <a-date-picker style="width:100%" v-model:value="form.planDate" valueFormat="YYYY-MM-DD" placeholder="选择计划日期" />
      </a-form-item>
      <a-form-item label="计划数量" name="planQuantity">
        <a-input-number style="width:100%" v-model:value="form.planQuantity" :min="0" placeholder="计划数量" />
      </a-form-item>
      <a-form-item label="实际数量" name="actualQuantity">
        <a-input-number style="width:100%" v-model:value="form.actualQuantity" :min="0" placeholder="实际数量" />
      </a-form-item>
      <a-form-item label="状态" name="status">
        <a-select v-model:value="form.status" style="width:100%">
          <a-select-option :value="1">计划</a-select-option>
          <a-select-option :value="2">进行中</a-select-option>
          <a-select-option :value="3">完成</a-select-option>
        </a-select>
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
import { cuttingPlanApi } from '/@/api/business/cutting/cutting-plan-api';
import { productionOrderApi } from '/@/api/business/production/order-api';

const emit = defineEmits(['reload']);
const formRef = ref();
const visible = ref(false);
const loading = ref(false);
const orderList = ref([]);

const formDefault = {
  planId: undefined, orderId: undefined, orderNo: '', customerName: '',
  styleNo: '', styleName: '', planDate: undefined, planQuantity: undefined,
  actualQuantity: undefined, status: 1, remark: '',
};
const form = reactive({ ...formDefault });
const rules = {};

onMounted(async () => {
  try {
    const res = await productionOrderApi.query({ pageNum: 1, pageSize: 200 });
    orderList.value = res.data?.list || [];
  } catch (e) { smartSentry.captureError(e); }
});

function onOrderChange(val) {
  const o = orderList.value.find(x => x.orderId === val);
  if (o) {
    form.orderNo = o.orderNo;
    form.customerName = o.customerName;
    form.styleNo = o.styleNo;
    form.styleName = o.styleName;
  }
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
    loading.value = true;
    await cuttingPlanApi.addOrUpdate(form);
    message.success(form.planId ? '修改成功' : '添加成功');
    onClose();
    emit('reload');
  } catch (e) { smartSentry.captureError(e); } finally { loading.value = false; }
}
defineExpose({ show });
</script>
