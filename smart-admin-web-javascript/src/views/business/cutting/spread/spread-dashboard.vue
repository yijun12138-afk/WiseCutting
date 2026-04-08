<template>
  <a-card size="small" :bordered="false" :hoverable="true">
    <a-row :gutter="16" style="margin-bottom:16px">
      <a-col :span="6">
        <a-statistic title="铺布任务总数" :value="stats.totalCount" suffix="个">
          <template #prefix><AppstoreOutlined style="color:#1890ff" /></template>
        </a-statistic>
      </a-col>
      <a-col :span="6">
        <a-statistic title="已下发" :value="stats.issuedCount" suffix="个">
          <template #prefix><SendOutlined style="color:#faad14" /></template>
        </a-statistic>
      </a-col>
      <a-col :span="6">
        <a-statistic title="已完成" :value="stats.doneCount" suffix="个">
          <template #prefix><CheckCircleOutlined style="color:#52c41a" /></template>
        </a-statistic>
      </a-col>
      <a-col :span="6">
        <a-statistic title="待作业" :value="stats.pendingCount" suffix="个">
          <template #prefix><ClockCircleOutlined style="color:#ff4d4f" /></template>
        </a-statistic>
      </a-col>
    </a-row>
    <a-divider>铺布任务列表</a-divider>
    <a-table size="small" :dataSource="tableData" :columns="columns" rowKey="spreadId" :pagination="{ pageSize: 10 }" bordered>
      <template #bodyCell="{ text, record, column }">
        <template v-if="column.dataIndex === 'status'">
          <a-tag :color="statusColor(text)">{{ statusText(text) }}</a-tag>
        </template>
        <template v-if="column.dataIndex === 'issuedFlag'">
          <a-tag :color="text ? 'blue' : 'default'">{{ text ? '已下发' : '未下发' }}</a-tag>
        </template>
      </template>
    </a-table>
  </a-card>
</template>
<script setup>
import { ref, reactive, onMounted } from 'vue';
import { AppstoreOutlined, CheckCircleOutlined, ClockCircleOutlined } from '@ant-design/icons-vue';
import { SendOutlined } from '@ant-design/icons-vue';
import { smartSentry } from '/@/lib/smart-sentry';
import { fabricSpreadApi } from '/@/api/business/production/spread-api';

const stats = reactive({ totalCount: 0, issuedCount: 0, doneCount: 0, pendingCount: 0 });
const tableData = ref([]);

const columns = [
  { title: '指令单号', dataIndex: 'orderNo', width: 140 },
  { title: '面料编号', dataIndex: 'fabricNo', width: 120 },
  { title: '面料名称', dataIndex: 'fabricName', width: 130 },
  { title: '颜色', dataIndex: 'colorName', width: 80 },
  { title: '要求层数', dataIndex: 'requireLayers', width: 90 },
  { title: '要求长度(m)', dataIndex: 'requireLength', width: 110 },
  { title: '实际层数', dataIndex: 'actualLayers', width: 90 },
  { title: '实际长度(m)', dataIndex: 'actualLength', width: 110 },
  { title: '下发状态', dataIndex: 'issuedFlag', width: 90 },
  { title: '状态', dataIndex: 'status', width: 80 },
];

function statusText(s) { return { 0: '待作业', 1: '进行中', 2: '已完成' }[s] ?? s; }
function statusColor(s) { return { 0: 'default', 1: 'blue', 2: 'green' }[s] ?? 'default'; }

async function loadData() {
  try {
    const res = await fabricSpreadApi.query({ pageNum: 1, pageSize: 100 });
    const list = res.data?.list || [];
    tableData.value = list;
    stats.totalCount = list.length;
    stats.issuedCount = list.filter(r => r.issuedFlag).length;
    stats.doneCount = list.filter(r => r.status === 2).length;
    stats.pendingCount = list.filter(r => r.status === 0).length;
  } catch (e) { smartSentry.captureError(e); }
}
onMounted(loadData);
</script>
