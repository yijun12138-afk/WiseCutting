<template>
  <a-card size="small" :bordered="false" :hoverable="true">
    <a-row :gutter="16" style="margin-bottom:16px">
      <a-col :span="6">
        <a-statistic title="今日松布任务" :value="stats.todayCount" suffix="个">
          <template #prefix><ExpandOutlined style="color:#1890ff" /></template>
        </a-statistic>
      </a-col>
      <a-col :span="6">
        <a-statistic title="进行中" :value="stats.inProgressCount" suffix="个">
          <template #prefix><SyncOutlined style="color:#faad14" /></template>
        </a-statistic>
      </a-col>
      <a-col :span="6">
        <a-statistic title="已完成" :value="stats.doneCount" suffix="个">
          <template #prefix><CheckCircleOutlined style="color:#52c41a" /></template>
        </a-statistic>
      </a-col>
      <a-col :span="6">
        <a-statistic title="待处理" :value="stats.pendingCount" suffix="个">
          <template #prefix><ClockCircleOutlined style="color:#ff4d4f" /></template>
        </a-statistic>
      </a-col>
    </a-row>
    <a-divider>松布任务列表</a-divider>
    <a-table size="small" :dataSource="tableData" :columns="columns" rowKey="relaxId" :pagination="{ pageSize: 10 }" bordered>
      <template #bodyCell="{ text, column }">
        <template v-if="column.dataIndex === 'status'">
          <a-tag :color="statusColor(text)">{{ statusText(text) }}</a-tag>
        </template>
      </template>
    </a-table>
  </a-card>
</template>
<script setup>
import { ref, reactive, onMounted } from 'vue';
import { ExpandOutlined, SyncOutlined, CheckCircleOutlined, ClockCircleOutlined } from '@ant-design/icons-vue';
import { smartSentry } from '/@/lib/smart-sentry';
import { fabricRelaxApi } from '/@/api/business/production/relax-api';

const stats = reactive({ todayCount: 0, inProgressCount: 0, doneCount: 0, pendingCount: 0 });
const tableData = ref([]);

const columns = [
  { title: '指令单号', dataIndex: 'orderNo', width: 140 },
  { title: '面料名称', dataIndex: 'fabricName', width: 130 },
  { title: '颜色', dataIndex: 'colorName', width: 90 },
  { title: '需求长度(m)', dataIndex: 'requireLength', width: 110 },
  { title: '实际长度(m)', dataIndex: 'actualLength', width: 110 },
  { title: '松布时长(h)', dataIndex: 'relaxHours', width: 110 },
  { title: '状态', dataIndex: 'status', width: 80 },
  { title: '创建时间', dataIndex: 'createTime', width: 160 },
];

function statusText(s) { return { 0: '计划', 1: '进行中', 2: '完成' }[s] ?? s; }
function statusColor(s) { return { 0: 'default', 1: 'blue', 2: 'green' }[s] ?? 'default'; }

async function loadData() {
  try {
    const res = await fabricRelaxApi.query({ pageNum: 1, pageSize: 100 });
    const list = res.data?.list || [];
    tableData.value = list;
    stats.pendingCount = list.filter(r => r.status === 0).length;
    stats.inProgressCount = list.filter(r => r.status === 1).length;
    stats.doneCount = list.filter(r => r.status === 2).length;
    stats.todayCount = list.length;
  } catch (e) { smartSentry.captureError(e); }
}
onMounted(loadData);
</script>
