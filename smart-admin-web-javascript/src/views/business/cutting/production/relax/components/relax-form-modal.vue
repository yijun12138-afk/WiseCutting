<template>
  <a-modal :title="form.relaxId ? '编辑松布任务' : '新建松布任务'" v-model:open="visible" @ok="onSubmit" @cancel="onClose" :confirmLoading="loading" width="600px">
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
      <a-form-item label="需求卷数" name="requireLength">
        <a-input-number style="width:100%" v-model:value="form.requireLength" :min="0" :precision="0" placeholder="需求卷数" />
      </a-form-item>
      <a-form-item label="实际卷数" name="actualLength">
        <a-input-number style="width:100%" v-model:value="form.actualLength" :min="0" :precision="0" placeholder="实际卷数" />
      </a-form-item>
      <a-form-item label="松布时长(h)" name="relaxHours">
        <a-input-number style="width:100%" v-model:value="form.relaxHours" :min="0" :precision="1" placeholder="松布时长" />
      </a-form-item>
      <a-form-item label="松布时间" name="relaxTime">
        <a-date-picker show-time style="width:100%" v-model:value="form.relaxTime" placeholder="请选择松布时间" valueFormat="YYYY-MM-DD HH:mm:ss" />
      </a-form-item>
      <a-form-item label="实际开始时间" name="actualStartTime">
        <a-date-picker show-time style="width:100%" v-model:value="form.actualStartTime" placeholder="请选择实际开始时间" valueFormat="YYYY-MM-DD HH:mm:ss" />
      </a-form-item>
      <a-form-item label="实际结束时间" name="actualEndTime">
        <a-date-picker show-time style="width:100%" v-model:value="form.actualEndTime" placeholder="请选择实际结束时间" valueFormat="YYYY-MM-DD HH:mm:ss" />
      </a-form-item>
      <a-form-item label="状态" name="status">
        <a-select v-model:value="form.status" style="width:100%">
          <a-select-option :value="0">未开始</a-select-option>
          <a-select-option :value="1">进行中</a-select-option>
          <a-select-option :value="2">静置完成</a-select-option>
          <a-select-option :value="3">已结束</a-select-option>
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
import { fabricRelaxApi } from '/@/api/business/production/relax-api';
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
  relaxId: undefined, orderId: undefined, orderNo: '',
  fabricId: undefined, fabricNo: '', fabricName: '', colorName: '',
  requireLength: undefined, actualLength: undefined, relaxHours: undefined,
  relaxTime: undefined, actualStartTime: undefined, actualEndTime: undefined,
  status: 0, remark: '',
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
    await fabricRelaxApi.addOrUpdate(form);
    message.success(form.relaxId ? '修改成功' : '添加成功');
    onClose();
    emit('reload');
  } catch (e) { smartSentry.captureError(e); } finally { loading.value = false; }
}
defineExpose({ show });
</script>
