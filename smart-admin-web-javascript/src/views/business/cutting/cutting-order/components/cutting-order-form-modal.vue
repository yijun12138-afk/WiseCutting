<template>
  <a-modal
    :title="form.cuttingOrderId ? '编辑裁床单' : '新建裁床单'"
    v-model:open="visible"
    @ok="onSubmit"
    @cancel="onClose"
    :confirm-loading="loading"
    width="700px"
    destroy-on-close
  >
    <a-form
      ref="formRef"
      :model="form"
      :label-col="{ span: 6 }"
      :wrapper-col="{ span: 18 }"
      :rules="rules"
      validate-on-rule-change
    >
      <a-row :gutter="16">
        <a-col :span="12">
          <a-form-item label="指令单号" name="orderId">
            <a-select
              v-model:value="form.orderId"
              placeholder="请选择指令单"
              style="width: 100%"
              @change="onOrderChange"
              show-search
              option-filter-prop="children"
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
            <a-select
              v-model:value="form.fabricId"
              placeholder="请选择面料"
              style="width: 100%"
              @change="onFabricChange"
              show-search
              option-filter-prop="children"
              allow-clear
            >
              <a-select-option
                v-for="f in fabricList"
                :key="f.fabricId"
                :value="f.fabricId"
              >
                {{ f.fabricNo }} - {{ f.fabricName }}
              </a-select-option>
            </a-select>
          </a-form-item>
        </a-col>

        <a-col :span="12">
          <a-form-item label="颜色" name="colorName">
            <a-select
              v-model:value="form.colorName"
              placeholder="请选择颜色"
              style="width: 100%"
              allow-clear
            >
              <a-select-option
                v-for="c in colorList"
                :key="c.colorName"
                :value="c.colorName"
              >
                {{ c.colorName }}
              </a-select-option>
            </a-select>
          </a-form-item>
        </a-col>

        <a-col :span="12">
          <a-form-item label="尺码" name="sizeName">
            <a-select
              v-model:value="form.sizeName"
              placeholder="请选择尺码"
              style="width: 100%"
              allow-clear
            >
              <a-select-option
                v-for="s in sizeList"
                :key="s.sizeName"
                :value="s.sizeName"
              >
                {{ s.sizeName }}
              </a-select-option>
            </a-select>
          </a-form-item>
        </a-col>

        <a-col :span="12">
          <a-form-item label="数量" name="quantity">
            <a-input-number
              style="width: 100%"
              v-model:value="form.quantity"
              :min="1"
              placeholder="数量"
            />
          </a-form-item>
        </a-col>

        <a-col :span="12">
          <a-form-item label="床号" name="bedNo">
            <a-input v-model:value="form.bedNo" placeholder="床号" />
          </a-form-item>
        </a-col>

        <a-col :span="12">
          <a-form-item label="层数" name="layers">
            <a-input-number
              style="width: 100%"
              v-model:value="form.layers"
              :min="1"
              placeholder="层数"
            />
          </a-form-item>
        </a-col>

        <a-col :span="12">
          <a-form-item label="状态" name="status">
            <a-select v-model:value="form.status" style="width: 100%">
              <a-select-option :value="1">待裁</a-select-option>
              <a-select-option :value="2">裁剪中</a-select-option>
              <a-select-option :value="3">完成</a-select-option>
            </a-select>
          </a-form-item>
        </a-col>

        <a-col :span="24">
          <a-form-item label="备注" name="remark" :label-col="{ span: 3 }" :wrapper-col="{ span: 21 }">
            <a-input v-model:value="form.remark" placeholder="请输入备注" type="text" rows="3" />
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
import { styleColorApi } from '/@/api/business/basic/stylecolor-api';
import { sizeApi } from '/@/api/business/basic/size-api';

const emit = defineEmits(['reload']);
const formRef = ref();
const visible = ref(false);
const loading = ref(false);

// 下拉列表数据
const orderList = ref([]);
const fabricList = ref([]);
const colorList = ref([]);
const sizeList = ref([]);

// 表单默认值
const formDefault = {
  cuttingOrderId: undefined,
  planId: undefined,
  planNo: '',
  orderId: undefined,
  orderNo: '',
  customerName: '',
  styleNo: '',
  styleName: '',
  colorName: '',
  sizeName: '',
  quantity: undefined,
  bedNo: '',
  layers: undefined,
  fabricId: undefined,
  fabricNo: '',
  fabricName: '',
  status: 1, // 默认待裁
  remark: '',
};

const form = reactive({ ...formDefault });

// 表单校验规则
const rules = {
  orderId: [{ required: true, message: '请选择指令单号', trigger: 'change' }],
  fabricId: [{ required: true, message: '请选择面料', trigger: 'change' }],
  colorName: [{ required: true, message: '请选择颜色', trigger: 'change' }],
  sizeName: [{ required: true, message: '请选择尺码', trigger: 'change' }],
  quantity: [{ required: true, message: '请输入数量', trigger: 'change' }],
  layers: [{ required: true, message: '请输入层数', trigger: 'change' }],
  bedNo: [{ required: true, message: '请输入床号', trigger: 'blur' }],
};

// 初始化加载下拉数据
onMounted(async () => {
  try {
    const [orderRes, fabricRes, sizeRes, colorRes] = await Promise.all([
      productionOrderApi.query({ pageNum: 1, pageSize: 200 }),
      fabricApi.listAll(),
      sizeApi.listAll(),
      styleColorApi.listAll(),
    ]);
    orderList.value = orderRes.data?.list || [];
    fabricList.value = fabricRes.data || [];
    sizeList.value = sizeRes.data || [];
    colorList.value = colorRes.data || [];
  } catch (e) {
    smartSentry.captureError(e);
  }
});

// 指令单切换
function onOrderChange(val) {
  const order = orderList.value.find(item => item.orderId === val);
  if (order) {
    form.orderNo = order.orderNo;
    form.customerName = order.customerName;
    form.styleNo = order.styleNo;
    form.styleName = order.styleName;
  } else {
    form.orderNo = '';
    form.customerName = '';
    form.styleNo = '';
    form.styleName = '';
  }
}

// 面料切换 → 加载对应颜色
async function onFabricChange(val) {
  // 重置
  form.fabricNo = '';
  form.fabricName = '';
  form.colorName = '';
  colorList.value = [];

  if (!val) return;

  // 赋值面料信息
  const fabric = fabricList.value.find(item => item.fabricId === val);
  if (fabric) {
    form.fabricNo = fabric.fabricNo;
    form.fabricName = fabric.fabricName;
  }

  // 查询颜色SKU
  try {
    const res = await fabricApi.skuList(val);
    colorList.value = res.data || [];
  } catch (e) {
    smartSentry.captureError(e);
  }
}

// 打开弹窗
function show(row) {
  // 重置表单
  Object.assign(form, formDefault);
  // 编辑赋值
  if (row) {
    Object.assign(form, row);
    // 编辑时：如果有面料ID，重新加载颜色列表
    if (row.fabricId) {
      onFabricChange(row.fabricId);
    }
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

    // 保存接口
    await cuttingOrderApi.addOrUpdate(form);
    message.success(form.cuttingOrderId ? '修改成功' : '新增成功');

    onClose();
    emit('reload');
  } catch (error) {
    // 校验不触发错误捕获
    if (error !== false) {
      smartSentry.captureError(error);
    }
  } finally {
    loading.value = false;
  }
}

// 暴露方法给父组件
defineExpose({ show });
</script>