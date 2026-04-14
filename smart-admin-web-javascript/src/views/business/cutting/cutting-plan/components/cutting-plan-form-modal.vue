<template>
  <a-modal
    :title="form.planId ? '编辑裁剪计划' : '新建裁剪计划'"
    v-model:open="visible"
    @ok="onSubmit"
    @cancel="onClose"
    :confirm-loading="loading"
    width="600px"
    destroy-on-close
  >
    <a-form
      ref="formRef"
      :model="form"
      :rules="rules"
      :label-col="{ span: 6 }"
      :wrapper-col="{ span: 18 }"
      validate-on-rule-change
    >
      <a-form-item label="指令单" name="orderId">
        <a-select
          v-model:value="form.orderId"
          placeholder="请选择指令单"
          style="width: 100%"
          @change="onOrderChange"
          show-search
          option-filter-prop="children"
          allow-clear
        >
          <a-select-option
            v-for="o in orderList"
            :key="o.orderId"
            :value="o.orderId"
          >
            {{ o.orderNo }}
          </a-select-option>
        </a-select>
      </a-form-item>

      <a-form-item label="客户名称" name="customerName">
        <a-input
          v-model:value="form.customerName"
          placeholder="选择指令单后自动填充"
          disabled
        />
      </a-form-item>

      <a-form-item label="款号" name="styleNo">
        <a-input
          v-model:value="form.styleNo"
          placeholder="选择指令单后自动填充"
          disabled
        />
      </a-form-item>

      <a-form-item label="款名" name="styleName">
        <a-input
          v-model:value="form.styleName"
          placeholder="选择指令单后自动填充"
          disabled
        />
      </a-form-item>

      <a-form-item label="计划日期" name="planDate">
        <a-date-picker
          style="width: 100%"
          v-model:value="form.planDate"
          value-format="YYYY-MM-DD"
          placeholder="选择计划日期"
        />
      </a-form-item>

      <a-form-item label="计划数量" name="planQuantity">
        <a-input-number
          style="width: 100%"
          v-model:value="form.planQuantity"
          :min="1"
          placeholder="计划数量"
        />
      </a-form-item>

      <a-form-item label="实际数量" name="actualQuantity">
        <a-input-number
          style="width: 100%"
          v-model:value="form.actualQuantity"
          :min="0"
          placeholder="实际数量"
        />
      </a-form-item>

      <a-form-item label="状态" name="status">
        <a-select v-model:value="form.status" style="width: 100%">
          <a-select-option :value="1">计划</a-select-option>
          <a-select-option :value="2">进行中</a-select-option>
          <a-select-option :value="3">完成</a-select-option>
        </a-select>
      </a-form-item>

      <a-form-item label="备注" name="remark">
        <a-input
          v-model:value="form.remark"
          placeholder="请输入备注"
          type="text"
          rows="2"
        />
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

// 表单默认值
const formDefault = {
  planId: undefined,
  orderId: undefined,
  orderNo: '',
  customerName: '',
  styleNo: '',
  styleName: '',
  planDate: undefined,
  planQuantity: undefined,
  actualQuantity: 0,
  status: undefined,
  remark: '',
};

const form = reactive({ ...formDefault });

// 表单校验规则
const rules = {
  orderId: [{ required: true, message: '请选择指令单', trigger: 'change' }],
  planDate: [{ required: true, message: '请选择计划日期', trigger: 'change' }],
  planQuantity: [{ required: true, message: '请输入计划数量', trigger: 'change' }],
};

// 初始化加载指令单列表
onMounted(async () => {
  try {
    const res = await productionOrderApi.query({ pageNum: 1, pageSize: 200 });
    orderList.value = res.data?.list || [];
  } catch (e) {
    smartSentry.captureError(e);
  }
});

// 指令单切换自动回填
function onOrderChange(val) {
  const order = orderList.value.find(item => item.orderId === val);
  if (order) {
    form.orderNo = order.orderNo;
    form.customerName = order.customerName;
    form.styleNo = order.styleNo;
    form.styleName = order.styleName;
  } else {
    // 清空
    form.orderNo = '';
    form.customerName = '';
    form.styleNo = '';
    form.styleName = '';
  }
}

// 打开弹窗
function show(row) {
  Object.assign(form, formDefault);
  if (row) {
    Object.assign(form, row);
  }
  visible.value = true;
  nextTick(() => formRef.value?.clearValidate());
}

// 关闭
function onClose() {
  visible.value = false;
}

// 提交保存
async function onSubmit() {
  try {
    // 表单校验
    await formRef.value.validate();
    loading.value = true;

    await cuttingPlanApi.addOrUpdate(form);
    message.success(form.planId ? '修改成功' : '新增成功');

    onClose();
    emit('reload');
  } catch (error) {
    // 不捕获校验失败
    if (error !== false) {
      smartSentry.captureError(error);
    }
  } finally {
    loading.value = false;
  }
}

defineExpose({ show });
</script>