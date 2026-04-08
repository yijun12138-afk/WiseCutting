<template>
  <a-modal :title="form.spreadId ? '编辑铺布任务' : '新建铺布任务'" v-model:open="visible" @ok="onSubmit" @cancel="onClose" :confirmLoading="loading" width="600px">
    <a-form ref="formRef" :model="form" :rules="rules" :label-col="{ span: 6 }">
      <a-form-item label="指令单" name="orderId">
        <a-select v-model:value="form.orderId" placeholder="请选择指令单" style="width:100%" @change="onOrderChange" showSearch optionFilterProp="children" allowClear>
          <a-select-option v-for="o in orderList" :key="o.orderId" :value="o.orderId">{{ o.orderNo }}</a-select-option>
        </a-select>
      </a-form-item>
      <a-form-item label="面料" name="fabricId">
        <a-select v-model:value="form.fabricId" placeholder="请选择面料" style="width:100%" @change="onFabricChange" showSearch optionFilterProp="children" allowClear>
          <a-select-option v-for="f in fabricList" :key="f.fabricId" :value="f.fabricId">{{ f.fabricNo }} - {{ f.fabricName }}</a-select-option>
        </a-select>
      </a-form-item>
      <a-form-item label="颜色" name="colorName">
        <a-select v-model:value="form.colorName" placeholder="请选择颜色" style="width:100%" allowClear>
          <a-select-option v-for="c in colorList" :key="c.colorName" :value="c.colorName">{{ c.colorName }}</a-select-option>
        </a-select>
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
import { fabricApi } from '/@/api/business/basic/fabric-api';

const emit = defineEmits(['reload']);
const formRef = ref();
const visible = ref(false);
const loading = ref(false);
const orderList = ref([]);
const fabricList = ref([]);
const colorList = ref([]);

const formDefault = {
  spreadId: undefined, orderId: undefined, orderNo: '',
  fabricId: undefined, fabricNo: '', fabricName: '', colorName: '',
  requireLayers: undefined, requireLength: undefined, remark: '',
};
const form = reactive({ ...formDefault });
const rules = { orderId: [{ required: true, message: '请选择指令单' }] };

onMounted(async () => {
  try {
    const [orderRes, fabricRes] = await Promise.all([
      productionOrderApi.query({ pageNum: 1, pageSize: 200 }),
      fabricApi.listAll(),
    ]);
    orderList.value = orderRes.data?.list || [];
    fabricList.value = fabricRes.data || [];
  } catch (e) { smartSentry.captureError(e); }
});

function onOrderChange(val) {
  const o = orderList.value.find(x => x.orderId === val);
  form.orderNo = o ? o.orderNo : '';
}

async function onFabricChange(val) {
  const f = fabricList.value.find(x => x.fabricId === val);
  if (f) { form.fabricNo = f.fabricNo; form.fabricName = f.fabricName; }
  else { form.fabricNo = ''; form.fabricName = ''; }
  form.colorName = '';
  colorList.value = [];
  if (!val) return;
  try {
    const res = await fabricApi.skuList(val);
    colorList.value = res.data || [];
  } catch (e) { smartSentry.captureError(e); }
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
