<template>
  <a-modal :title="form.cuttingOrderId ? '编辑裁床单' : '新建裁床单'" v-model:open="visible" @ok="onSubmit" @cancel="onClose" :confirmLoading="loading" width="700px">
    <a-form ref="formRef" :model="form" :label-col="{ span: 6 }">
      <a-row :gutter="16">
        <a-col :span="12">
          <a-form-item label="指令单号" name="orderId">
            <a-select v-model:value="form.orderId" placeholder="请选择指令单" style="width:100%" @change="onOrderChange" showSearch optionFilterProp="children" allowClear>
              <a-select-option v-for="o in orderList" :key="o.orderId" :value="o.orderId">{{ o.orderNo }}</a-select-option>
            </a-select>
          </a-form-item>
        </a-col>
        <a-col :span="12">
          <a-form-item label="客户名称" name="customerName">
            <a-input v-model:value="form.customerName" placeholder="客户名称" disabled />
          </a-form-item>
        </a-col>
        <a-col :span="12">
          <a-form-item label="款号" name="styleNo">
            <a-input v-model:value="form.styleNo" placeholder="款号" disabled />
          </a-form-item>
        </a-col>
        <a-col :span="12">
          <a-form-item label="款名" name="styleName">
            <a-input v-model:value="form.styleName" placeholder="款名" disabled />
          </a-form-item>
        </a-col>
        <a-col :span="12">
          <a-form-item label="面料" name="fabricId">
            <a-select v-model:value="form.fabricId" placeholder="请选择面料" style="width:100%" @change="onFabricChange" showSearch optionFilterProp="children" allowClear>
              <a-select-option v-for="f in fabricList" :key="f.fabricId" :value="f.fabricId">{{ f.fabricNo }} - {{ f.fabricName }}</a-select-option>
            </a-select>
          </a-form-item>
        </a-col>
        <a-col :span="12">
          <a-form-item label="颜色" name="colorName">
            <a-select v-model:value="form.colorName" placeholder="请选择颜色" style="width:100%" allowClear>
              <a-select-option v-for="c in colorList" :key="c.colorName" :value="c.colorName">{{ c.colorName }}</a-select-option>
            </a-select>
          </a-form-item>
        </a-col>
        <a-col :span="12">
          <a-form-item label="尺码" name="sizeName">
            <a-select v-model:value="form.sizeName" placeholder="请选择尺码" style="width:100%" allowClear>
              <a-select-option v-for="s in sizeList" :key="s.sizeName" :value="s.sizeName">{{ s.sizeName }}</a-select-option>
            </a-select>
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
import { ref, reactive, nextTick, onMounted } from 'vue';
import { message } from 'ant-design-vue';
import { smartSentry } from '/@/lib/smart-sentry';
import { cuttingOrderApi } from '/@/api/business/cutting/cutting-order-api';
import { productionOrderApi } from '/@/api/business/production/order-api';
import { fabricApi } from '/@/api/business/basic/fabric-api';
import { sizeApi } from '/@/api/business/basic/size-api';

const emit = defineEmits(['reload']);
const formRef = ref();
const visible = ref(false);
const loading = ref(false);
const orderList = ref([]);
const fabricList = ref([]);
const colorList = ref([]);
const sizeList = ref([]);

const formDefault = {
  cuttingOrderId: undefined, planId: undefined, planNo: '', orderId: undefined, orderNo: '',
  customerName: '', styleNo: '', styleName: '', colorName: '', sizeName: '',
  quantity: undefined, bedNo: '', layers: undefined, fabricId: undefined, fabricNo: '', fabricName: '',
  status: 1, remark: '',
};
const form = reactive({ ...formDefault });

onMounted(async () => {
  try {
    const [orderRes, fabricRes, sizeRes] = await Promise.all([
      productionOrderApi.query({ pageNum: 1, pageSize: 200 }),
      fabricApi.listAll(),
      sizeApi.listAll(),
    ]);
    orderList.value = orderRes.data?.list || [];
    fabricList.value = fabricRes.data || [];
    sizeList.value = sizeRes.data || [];
  } catch (e) { smartSentry.captureError(e); }
});

function onOrderChange(val) {
  const o = orderList.value.find(x => x.orderId === val);
  if (o) {
    form.orderNo = o.orderNo;
    form.customerName = o.customerName;
    form.styleNo = o.styleNo;
    form.styleName = o.styleName;
  } else {
    form.orderNo = ''; form.customerName = ''; form.styleNo = ''; form.styleName = '';
  }
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
    loading.value = true;
    await cuttingOrderApi.addOrUpdate(form);
    message.success(form.cuttingOrderId ? '修改成功' : '添加成功');
    onClose();
    emit('reload');
  } catch (e) { smartSentry.captureError(e); } finally { loading.value = false; }
}
defineExpose({ show });
</script>
