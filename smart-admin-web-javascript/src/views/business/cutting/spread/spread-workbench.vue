<template>
  <a-card size="small" :bordered="false" :hoverable="true" title="铺布工作台 - 已下发任务">
    <template #extra>
      <a-button @click="loadData"><ReloadOutlined />刷新</a-button>
    </template>
    <a-row :gutter="16">
      <a-col v-for="item in tableData" :key="item.spreadId" :span="8" style="margin-bottom:16px">
        <a-card size="small" :bordered="true" :hoverable="true">
          <template #title>
            <span>{{ item.orderNo }}</span>
            <a-tag style="margin-left:8px" :color="statusColor(item.status)">{{ statusText(item.status) }}</a-tag>
          </template>
          <a-descriptions :column="1" size="small">
            <a-descriptions-item label="面料">{{ item.fabricName }}</a-descriptions-item>
            <a-descriptions-item label="颜色">{{ item.colorName }}</a-descriptions-item>
            <a-descriptions-item label="要求层数">{{ item.requireLayers }}</a-descriptions-item>
            <a-descriptions-item label="要求长度">{{ item.requireLength }}m</a-descriptions-item>
            <a-descriptions-item label="实际层数">{{ item.actualLayers ?? '-' }}</a-descriptions-item>
            <a-descriptions-item label="实际长度">{{ item.actualLength ? item.actualLength + 'm' : '-' }}</a-descriptions-item>
          </a-descriptions>
          <div style="margin-top:8px;text-align:right" v-if="item.status !== 2">
            <a-button type="primary" size="small" @click="openComplete(item)">完成铺布</a-button>
          </div>
        </a-card>
      </a-col>
      <a-col v-if="tableData.length === 0" :span="24">
        <a-empty description="暂无已下发的铺布任务" />
      </a-col>
    </a-row>
    <SpreadCompleteModal ref="completeModal" @reload="loadData" />
  </a-card>
</template>
<script setup>
import SpreadCompleteModal from '../production/spread/components/spread-complete-modal.vue';
import { ref, onMounted } from 'vue';
import { ReloadOutlined } from '@ant-design/icons-vue';
import { smartSentry } from '/@/lib/smart-sentry';
import { fabricSpreadApi } from '/@/api/business/production/spread-api';

const tableData = ref([]);
const completeModal = ref();

function statusText(s) { return { 0: '待作业', 1: '进行中', 2: '已完成' }[s] ?? s; }
function statusColor(s) { return { 0: 'default', 1: 'blue', 2: 'green' }[s] ?? 'default'; }

async function loadData() {
  try {
    const res = await fabricSpreadApi.workbench({});
    tableData.value = res.data || [];
  } catch (e) { smartSentry.captureError(e); }
}
onMounted(loadData);

function openComplete(row) { completeModal.value.show(row); }
</script>
