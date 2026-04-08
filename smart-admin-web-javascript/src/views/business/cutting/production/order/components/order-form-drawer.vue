<template>
  <a-drawer :title="form.orderId ? '编辑指令单' : '新建指令单'" :width="800" :open="visible" @close="onClose">
    <a-tabs v-model:activeKey="activeTab">
      <!-- 基本信息 -->
      <a-tab-pane key="basic" tab="基本信息">
        <a-form ref="formRef" :model="form" :rules="rules" :label-col="{ span: 5 }">
          <a-form-item label="单据编号" name="orderNo">
            <a-input v-model:value="form.orderNo" placeholder="留空则系统自动生成" />
          </a-form-item>
          <a-form-item label="客户" name="customerId">
            <a-select v-model:value="form.customerId" placeholder="请选择客户" style="width:100%" @change="onCustomerChange" showSearch optionFilterProp="children">
              <a-select-option v-for="c in customerList" :key="c.customerId" :value="c.customerId">{{ c.customerName }}</a-select-option>
            </a-select>
          </a-form-item>
          <a-form-item label="款号" name="styleNo">
            <a-input v-model:value="form.styleNo" placeholder="请输入款号" />
          </a-form-item>
          <a-form-item label="款名" name="styleName">
            <a-input v-model:value="form.styleName" placeholder="请输入款名" />
          </a-form-item>
          <a-form-item label="交期" name="deliveryDate">
            <a-date-picker style="width:100%" v-model:value="form.deliveryDate" valueFormat="YYYY-MM-DD" placeholder="请选择交货日期" />
          </a-form-item>
          <a-form-item label="单价" name="unitPrice">
            <a-input-number style="width:100%" v-model:value="form.unitPrice" :min="0" :precision="2" placeholder="单价" />
          </a-form-item>
          <a-form-item label="备注" name="remark">
            <a-textarea v-model:value="form.remark" placeholder="请输入备注" :rows="2" />
          </a-form-item>
          <a-divider>颜色尺码配置</a-divider>
          <a-row style="margin-bottom:8px">
            <a-col :span="24">
              <a-button type="dashed" block @click="addDetail"><PlusOutlined />添加颜色/尺码</a-button>
            </a-col>
          </a-row>
          <a-table size="small" :dataSource="form.detailList" :columns="detailColumns" :pagination="false" bordered rowKey="__key">
            <template #bodyCell="{ record, column }">
              <template v-if="column.dataIndex === 'colorName'">
                <a-select v-model:value="record.colorName" placeholder="选择颜色" style="width:100%" allowClear showSearch>
                  <a-select-option v-for="c in colorList" :key="c.colorId" :value="c.colorName">{{ c.colorName }}</a-select-option>
                </a-select>
              </template>
              <template v-if="column.dataIndex === 'sizeName'">
                <a-select v-model:value="record.sizeName" placeholder="选择尺码" style="width:100%" allowClear showSearch>
                  <a-select-option v-for="s in sizeList" :key="s.sizeId" :value="s.sizeName">{{ s.sizeName }}</a-select-option>
                </a-select>
              </template>
              <template v-if="column.dataIndex === 'quantity'">
                <a-input-number v-model:value="record.quantity" :min="0" style="width:100%" />
              </template>
              <template v-if="column.dataIndex === 'action'">
                <a-button type="link" danger @click="removeDetail(record)">删除</a-button>
              </template>
            </template>
          </a-table>
        </a-form>
      </a-tab-pane>

      <!-- 面料信息 -->
      <a-tab-pane key="fabric" tab="面料信息">
        <a-row style="margin-bottom:8px">
          <a-col :span="24">
            <a-button type="dashed" block @click="addFabric"><PlusOutlined />添加面料</a-button>
          </a-col>
        </a-row>
        <a-table size="small" :dataSource="form.fabricList" :columns="fabricColumns" :pagination="false" bordered rowKey="__key">
          <template #bodyCell="{ record, column }">
            <template v-if="column.dataIndex === 'fabricId'">
              <a-select v-model:value="record.fabricId" placeholder="选择面料" style="width:100%" @change="(val) => onFabricChange(val, record)" showSearch optionFilterProp="children" allowClear>
                <a-select-option v-for="f in fabricList" :key="f.fabricId" :value="f.fabricId">{{ f.fabricNo }} - {{ f.fabricName }}</a-select-option>
              </a-select>
            </template>
            <template v-if="column.dataIndex === 'colorName'">
              <a-input v-model:value="record.colorName" placeholder="颜色/规格" />
            </template>
            <template v-if="column.dataIndex === 'action'">
              <a-button type="link" danger @click="removeFabric(record)">删除</a-button>
            </template>
          </template>
        </a-table>
      </a-tab-pane>

      <!-- 流程设置 -->
      <a-tab-pane key="process" tab="流程设置">
        <a-row style="margin-bottom:8px" :gutter="8">
          <a-col>
            <a-button @click="applyDefaultProcess">应用默认流程</a-button>
          </a-col>
          <a-col>
            <a-button @click="pushForward">正推</a-button>
          </a-col>
          <a-col>
            <a-button @click="pullBack">倒推</a-button>
          </a-col>
          <a-col>
            <a-button @click="clearAllTime">清除所有时间</a-button>
          </a-col>
          <a-col>
            <a-button type="dashed" @click="addProcess"><PlusOutlined />添加工序</a-button>
          </a-col>
        </a-row>
        <a-table size="small" :dataSource="form.processList" :columns="processColumns" :pagination="false" bordered rowKey="__key">
          <template #bodyCell="{ record, column }">
            <template v-if="column.dataIndex === 'nodeName'">
              <a-input v-model:value="record.nodeName" placeholder="节点名称" />
            </template>
            <template v-if="column.dataIndex === 'principal'">
              <a-input v-model:value="record.principal" placeholder="负责人" />
            </template>
            <template v-if="column.dataIndex === 'durationHours'">
              <a-input-number v-model:value="record.durationHours" :min="0" :precision="1" style="width:100%" placeholder="时效(h)" />
            </template>
            <template v-if="column.dataIndex === 'planStartTime'">
              <a-date-picker show-time v-model:value="record.planStartTime" valueFormat="YYYY-MM-DD HH:mm:ss" style="width:100%" placeholder="计划开始" />
            </template>
            <template v-if="column.dataIndex === 'action'">
              <a-button type="link" danger @click="removeProcess(record)">删除</a-button>
            </template>
          </template>
        </a-table>
      </a-tab-pane>
    </a-tabs>

    <div style="position:absolute;right:0;bottom:0;width:100%;border-top:1px solid #e9e9e9;padding:10px 16px;background:#fff;text-align:right;z-index:1;">
      <a-button style="margin-right:8px" @click="onClose">取消</a-button>
      <a-button type="primary" :loading="loading" @click="onSubmit">保存</a-button>
    </div>
  </a-drawer>
</template>
<script setup>
import { ref, reactive, nextTick, onMounted } from 'vue';
import { message } from 'ant-design-vue';
import { PlusOutlined } from '@ant-design/icons-vue';
import { smartSentry } from '/@/lib/smart-sentry';
import { productionOrderApi } from '/@/api/business/production/order-api';
import { customerApi } from '/@/api/business/basic/customer-api';
import { fabricApi } from '/@/api/business/basic/fabric-api';
import { styleColorApi } from '/@/api/business/basic/stylecolor-api';
import { sizeApi } from '/@/api/business/basic/size-api';

const emit = defineEmits(['reload']);
const formRef = ref();
const visible = ref(false);
const loading = ref(false);
const activeTab = ref('basic');
const customerList = ref([]);
const fabricList = ref([]);
const colorList = ref([]);
const sizeList = ref([]);

const formDefault = {
  orderId: undefined, orderNo: '', customerId: undefined, customerName: '',
  styleNo: '', styleName: '', deliveryDate: undefined,
  unitPrice: undefined, remark: '',
  detailList: [], fabricList: [], processList: [],
};
const form = reactive({ ...formDefault, detailList: [], fabricList: [], processList: [] });
const rules = {
  customerId: [{ required: true, message: '请选择客户' }],
  styleNo: [{ required: true, message: '款号不能为空' }],
  styleName: [{ required: true, message: '款名不能为空' }],
  deliveryDate: [{ required: true, message: '请选择交期' }],
};

const detailColumns = [
  { title: '颜色', dataIndex: 'colorName', width: 150 },
  { title: '尺码', dataIndex: 'sizeName', width: 120 },
  { title: '数量', dataIndex: 'quantity', width: 100 },
  { title: '操作', dataIndex: 'action', width: 80 },
];
const fabricColumns = [
  { title: '面料', dataIndex: 'fabricId', width: 250 },
  { title: '颜色/规格', dataIndex: 'colorName', width: 150 },
  { title: '操作', dataIndex: 'action', width: 80 },
];
const processColumns = [
  { title: '序号', dataIndex: 'seqNo', width: 60 },
  { title: '节点名称', dataIndex: 'nodeName', width: 130 },
  { title: '负责人', dataIndex: 'principal', width: 120 },
  { title: '时效(h)', dataIndex: 'durationHours', width: 90 },
  { title: '计划开始时间', dataIndex: 'planStartTime', width: 180 },
  { title: '操作', dataIndex: 'action', width: 80 },
];

let keyCounter = 0;
function nextKey() { return ++keyCounter; }

onMounted(async () => {
  try {
    const [custRes, fabRes, colorRes, sizeRes] = await Promise.all([
      customerApi.listAll(),
      fabricApi.listAll(),
      styleColorApi.listAll(),
      sizeApi.listAll(),
    ]);
    customerList.value = custRes.data || [];
    fabricList.value = fabRes.data || [];
    colorList.value = colorRes.data || [];
    sizeList.value = sizeRes.data || [];
  } catch (e) { smartSentry.captureError(e); }
});

function onCustomerChange(val) {
  const c = customerList.value.find(x => x.customerId === val);
  form.customerName = c ? c.customerName : '';
}

function onFabricChange(val, record) {
  const f = fabricList.value.find(x => x.fabricId === val);
  if (f) { record.fabricNo = f.fabricNo; record.fabricName = f.fabricName; }
  else { record.fabricNo = ''; record.fabricName = ''; }
}

function addDetail() { form.detailList.push({ __key: nextKey(), colorName: '', sizeName: '', quantity: undefined }); }
function removeDetail(row) { form.detailList = form.detailList.filter(x => x.__key !== row.__key); }

function addFabric() { form.fabricList.push({ __key: nextKey(), fabricId: undefined, fabricNo: '', fabricName: '', colorName: '' }); }
function removeFabric(row) { form.fabricList = form.fabricList.filter(x => x.__key !== row.__key); }

function addProcess() {
  const seq = form.processList.length + 1;
  form.processList.push({ __key: nextKey(), seqNo: seq, nodeName: '', principal: '', durationHours: undefined, planStartTime: undefined });
}
function removeProcess(row) {
  form.processList = form.processList.filter(x => x.__key !== row.__key);
  form.processList.forEach((p, i) => { p.seqNo = i + 1; });
}

function applyDefaultProcess() {
  form.processList = [
    { __key: nextKey(), seqNo: 1, nodeName: '铺布', principal: '', durationHours: 2, planStartTime: undefined },
    { __key: nextKey(), seqNo: 2, nodeName: '裁剪', principal: '', durationHours: 2, planStartTime: undefined },
    { __key: nextKey(), seqNo: 3, nodeName: '分包', principal: '', durationHours: 1, planStartTime: undefined },
  ];
}

function pushForward() {
  if (!form.deliveryDate) { message.warning('请先设置交期'); return; }
  let current = new Date(form.deliveryDate + 'T08:00:00');
  form.processList.forEach(p => {
    p.planStartTime = current.toISOString().slice(0, 19).replace('T', ' ');
    const hours = p.durationHours || 0;
    current = new Date(current.getTime() + hours * 3600000);
  });
}

function pullBack() {
  if (!form.deliveryDate) { message.warning('请先设置交期'); return; }
  let current = new Date(form.deliveryDate + 'T18:00:00');
  for (let i = form.processList.length - 1; i >= 0; i--) {
    const p = form.processList[i];
    const hours = p.durationHours || 0;
    current = new Date(current.getTime() - hours * 3600000);
    p.planStartTime = current.toISOString().slice(0, 19).replace('T', ' ');
  }
}

function clearAllTime() {
  form.processList.forEach(p => { p.planStartTime = undefined; p.planEndTime = undefined; });
}

async function show(row) {
  Object.assign(form, { ...formDefault, detailList: [], fabricList: [], processList: [] });
  activeTab.value = 'basic';
  if (row) {
    try {
      const res = await productionOrderApi.detail(row.orderId);
      const data = res.data;
      Object.assign(form, data);
      form.detailList = (data.detailList || []).map(d => ({ ...d, __key: nextKey() }));
      form.fabricList = (data.fabricList || []).map(f => ({ ...f, __key: nextKey() }));
      form.processList = (data.processList || []).map(p => ({ ...p, __key: nextKey() }));
    } catch (e) { smartSentry.captureError(e); }
  }
  visible.value = true;
  nextTick(() => formRef.value?.clearValidate());
}

function onClose() { visible.value = false; }

async function onSubmit() {
  try {
    await formRef.value.validate();
    loading.value = true;
    const payload = {
      ...form,
      detailList: form.detailList.map(({ __key, ...rest }) => rest),
      fabricList: form.fabricList.map(({ __key, ...rest }) => rest),
      processList: form.processList.map(({ __key, ...rest }) => rest),
    };
    await productionOrderApi.addOrUpdate(payload);
    message.success(form.orderId ? '修改成功' : '添加成功');
    onClose();
    emit('reload');
  } catch (e) { smartSentry.captureError(e); } finally { loading.value = false; }
}
defineExpose({ show });
</script>
