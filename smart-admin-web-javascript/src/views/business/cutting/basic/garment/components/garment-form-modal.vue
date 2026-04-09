<template>
  <a-modal :title="form.garmentId ? '编辑成衣' : '新建成衣'" v-model:open="visible" @ok="onSubmit" @cancel="onClose" :confirmLoading="loading" width="750px">
    <a-form ref="formRef" :model="form" :rules="rules" :label-col="{ span: 5 }">
      <a-form-item label="成衣编号" name="garmentNo">
        <a-input v-model:value="form.garmentNo" placeholder="请输入成衣编号" />
      </a-form-item>
      <a-form-item label="成衣名称" name="garmentName">
        <a-input v-model:value="form.garmentName" placeholder="请输入成衣名称" />
      </a-form-item>
      <a-form-item label="成衣类型" name="garmentType">
        <a-input v-model:value="form.garmentType" placeholder="如：上衣/裤子/裙子" />
      </a-form-item>
      <a-form-item label="单位" name="unitId">
        <a-select v-model:value="form.unitId" placeholder="请选择单位" style="width:100%" @change="onUnitChange" allowClear>
          <a-select-option v-for="u in unitList" :key="u.unitId" :value="u.unitId">{{ u.unitName }}</a-select-option>
        </a-select>
      </a-form-item>
      <a-form-item label="停用" name="disabledFlag">
        <a-switch v-model:checked="form.disabledFlag" checked-children="停用" un-checked-children="正常" />
      </a-form-item>
      <a-form-item label="备注" name="remark">
        <a-input v-model:value="form.remark" placeholder="请输入备注" />
      </a-form-item>
      <a-divider>颜色尺码属性</a-divider>
      <a-row style="margin-bottom:8px">
        <a-col :span="24">
          <a-button type="dashed" block @click="addSku"><PlusOutlined />添加颜色/尺码</a-button>
        </a-col>
      </a-row>
      <a-table size="small" :dataSource="form.skuList" :columns="skuColumns" :pagination="false" bordered rowKey="__key">
        <template #bodyCell="{ record, column }">
          <template v-if="column.dataIndex === 'colorName'">
            <a-input v-model:value="record.colorName" placeholder="颜色名称" />
          </template>
          <template v-if="column.dataIndex === 'sizeName'">
            <a-input v-model:value="record.sizeName" placeholder="尺码" />
          </template>
          <template v-if="column.dataIndex === 'skuNo'">
            <a-input v-model:value="record.skuNo" placeholder="SKU编号" />
          </template>
          <template v-if="column.dataIndex === 'price'">
            <a-input-number v-model:value="record.price" :min="0" :precision="2" style="width:100%" placeholder="价格" />
          </template>
          <template v-if="column.dataIndex === 'action'">
            <a-button type="link" danger @click="removeSku(record)">删除</a-button>
          </template>
        </template>
      </a-table>
    </a-form>
  </a-modal>
</template>
<script setup>
import { ref, reactive, nextTick, onMounted } from 'vue';
import { message } from 'ant-design-vue';
import { PlusOutlined } from '@ant-design/icons-vue';
import { smartSentry } from '/@/lib/smart-sentry';
import { garmentApi } from '/@/api/business/basic/garment-api';
import { unitApi } from '/@/api/business/basic/unit-api';

const emit = defineEmits(['reload']);
const formRef = ref();
const visible = ref(false);
const loading = ref(false);
const unitList = ref([]);

const formDefault = { garmentId: undefined, garmentNo: '', garmentName: '', garmentType: '', unitId: undefined, unitName: '', disabledFlag: false, remark: '', skuList: [] };
const form = reactive({ ...formDefault, skuList: [] });
const rules = {
  garmentNo: [{ required: true, message: '成衣编号不能为空' }],
  garmentName: [{ required: true, message: '成衣名称不能为空' }],
};
const skuColumns = [
  { title: '颜色名称', dataIndex: 'colorName', width: 120 },
  { title: '尺码', dataIndex: 'sizeName', width: 100 },
  { title: 'SKU编号', dataIndex: 'skuNo', width: 120 },
  { title: '价格', dataIndex: 'price', width: 100 },
  { title: '操作', dataIndex: 'action', width: 80 },
];

let keyCounter = 0;
function nextKey() { return ++keyCounter; }

onMounted(async () => {
  try { const res = await unitApi.listAll(); unitList.value = res.data || []; }
  catch (e) { smartSentry.captureError(e); }
});

function onUnitChange(val) {
  const u = unitList.value.find(x => x.unitId === val);
  form.unitName = u ? u.unitName : '';
}

function addSku() { form.skuList.push({ __key: nextKey(), colorName: '', sizeName: '', skuNo: '', price: undefined }); }
function removeSku(row) { form.skuList = form.skuList.filter(x => x.__key !== row.__key); }

function show(row) {
  Object.assign(form, { ...formDefault, skuList: [] });
  if (row) {
    Object.assign(form, row);
    form.skuList = (row.skuList || []).map(s => ({ ...s, __key: nextKey() }));
  }
  visible.value = true;
  nextTick(() => formRef.value?.clearValidate());
}
function onClose() { visible.value = false; }
async function onSubmit() {
  try {
    await formRef.value.validate();
    loading.value = true;
    const payload = { ...form, skuList: form.skuList.map(({ __key, ...rest }) => rest) };
    await garmentApi.addOrUpdate(payload);
    message.success(form.garmentId ? '修改成功' : '添加成功');
    onClose();
    emit('reload');
  } catch (e) { smartSentry.captureError(e); } finally { loading.value = false; }
}
defineExpose({ show });
</script>
