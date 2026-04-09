<template>
  <!-- 渐变头部 -->
  <div class="dashboard-header">
    <div class="dashboard-header-content">
      <div class="dashboard-title">
        <ExpandOutlined style="font-size:28px;margin-right:12px" />
        <span>松布仪表盘</span>
      </div>
      <div class="dashboard-subtitle">实时监控松布任务进度与状态</div>
    </div>
  </div>

  <!-- 统计卡片 -->
  <a-row :gutter="16" style="margin:16px 0">
    <a-col :span="6">
      <div class="stat-card stat-card-blue">
        <div class="stat-card-icon"><ClockCircleOutlined /></div>
        <div class="stat-card-body">
          <div class="stat-card-label">未开始任务</div>
          <div class="stat-card-value">{{ stats.pendingRolls }} <span class="stat-unit">卷</span></div>
          <div class="stat-card-sub">共 {{ stats.pendingCount }} 个任务</div>
        </div>
      </div>
    </a-col>
    <a-col :span="6">
      <div class="stat-card stat-card-yellow">
        <div class="stat-card-icon"><SyncOutlined /></div>
        <div class="stat-card-body">
          <div class="stat-card-label">静置中任务</div>
          <div class="stat-card-value">{{ stats.inProgressRolls }} <span class="stat-unit">卷</span></div>
          <div class="stat-card-sub">共 {{ stats.inProgressCount }} 个任务</div>
        </div>
      </div>
    </a-col>
    <a-col :span="6">
      <div class="stat-card stat-card-pink">
        <div class="stat-card-icon"><CheckCircleOutlined /></div>
        <div class="stat-card-body">
          <div class="stat-card-label">静置完成任务</div>
          <div class="stat-card-value">{{ stats.doneRolls }} <span class="stat-unit">卷</span></div>
          <div class="stat-card-sub">共 {{ stats.doneCount }} 个任务</div>
        </div>
      </div>
    </a-col>
    <a-col :span="6">
      <div class="stat-card stat-card-green">
        <div class="stat-card-icon"><StopOutlined /></div>
        <div class="stat-card-body">
          <div class="stat-card-label">已结束任务</div>
          <div class="stat-card-value">{{ stats.endedRolls }} <span class="stat-unit">卷</span></div>
          <div class="stat-card-sub">共 {{ stats.endedCount }} 个任务</div>
        </div>
      </div>
    </a-col>
  </a-row>

  <!-- 图表 + 播报 -->
  <a-row :gutter="16">
    <!-- 条形图 -->
    <a-col :span="16">
      <a-card size="small" :bordered="false" :hoverable="true" style="height:360px">
        <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:12px">
          <span style="font-weight:600;font-size:15px"><BarChartOutlined style="margin-right:6px;color:#1677ff" />每日松布卷数</span>
          <a-radio-group v-model:value="chartPeriod" button-style="solid" size="small" @change="updateChart">
            <a-radio-button value="week">本周</a-radio-button>
            <a-radio-button value="month">本月</a-radio-button>
            <a-radio-button value="quarter">本季</a-radio-button>
            <a-radio-button value="year">本年</a-radio-button>
          </a-radio-group>
        </div>
        <div ref="chartRef" style="height:280px"></div>
      </a-card>
    </a-col>

    <!-- 静置完成任务播报 -->
    <a-col :span="8">
      <a-card size="small" :bordered="false" :hoverable="true" style="height:360px">
        <template #title>
          <span style="font-weight:600;font-size:15px">
            <NotificationOutlined style="margin-right:6px;color:#eb2f96" />静置完成任务播报
          </span>
        </template>
        <div class="broadcast-container" ref="broadcastRef">
          <div class="broadcast-list" :style="{ transform: `translateY(-${scrollOffset}px)`, transition: 'transform 0.5s ease' }">
            <div
              v-for="(item, idx) in doneTasks.concat(doneTasks)"
              :key="idx"
              class="broadcast-item"
            >
              <div class="broadcast-item-header">
                <FileTextOutlined style="color:#1677ff;margin-right:4px" />
                <span style="font-weight:600;color:#1677ff">{{ item.orderNo }}</span>
                <a-tag color="pink" style="margin-left:auto;font-size:11px">静置完成</a-tag>
              </div>
              <div class="broadcast-item-body">
                <span class="broadcast-field"><TagOutlined style="color:#722ed1" /> {{ item.fabricName || '-' }}</span>
                <span class="broadcast-field"><BgColorsOutlined style="color:#eb2f96" /> {{ item.colorName || '-' }}</span>
                <span class="broadcast-field"><InboxOutlined style="color:#52c41a" /> {{ item.requireLength ? Math.floor(item.requireLength) + ' 卷' : '-' }}</span>
                <span class="broadcast-field"><ClockCircleOutlined style="color:#faad14" /> {{ item.relaxHours ? item.relaxHours + ' h' : '-' }}</span>
              </div>
            </div>
          </div>
        </div>
      </a-card>
    </a-col>
  </a-row>
</template>

<script setup>
import { ref, reactive, onMounted, onUnmounted, nextTick } from 'vue';
import * as echarts from 'echarts';
import {
  ExpandOutlined, SyncOutlined, CheckCircleOutlined, ClockCircleOutlined,
  StopOutlined, BarChartOutlined, NotificationOutlined,
  FileTextOutlined, TagOutlined, BgColorsOutlined, InboxOutlined,
} from '@ant-design/icons-vue';
import { smartSentry } from '/@/lib/smart-sentry';
import { fabricRelaxApi } from '/@/api/business/production/relax-api';

const stats = reactive({
  pendingCount: 0, pendingRolls: 0,
  inProgressCount: 0, inProgressRolls: 0,
  doneCount: 0, doneRolls: 0,
  endedCount: 0, endedRolls: 0,
});

const doneTasks = ref([]);
const chartPeriod = ref('week');
const chartRef = ref();
const broadcastRef = ref();
let chartInstance = null;
let scrollTimer = null;
let scrollOffset = ref(0);
let allList = [];

function sumRolls(arr) {
  return arr.reduce((s, r) => s + Math.floor(r.requireLength || 0), 0);
}

function buildChartData(list, period) {
  const now = new Date();
  const map = {};

  let days = 7;
  if (period === 'month') days = 30;
  else if (period === 'quarter') days = 90;
  else if (period === 'year') days = 365;

  for (let i = days - 1; i >= 0; i--) {
    const d = new Date(now);
    d.setDate(d.getDate() - i);
    const key = `${d.getMonth() + 1}/${d.getDate()}`;
    map[key] = 0;
  }

  list.forEach(r => {
    if (!r.createTime) return;
    const d = new Date(r.createTime);
    const key = `${d.getMonth() + 1}/${d.getDate()}`;
    if (key in map) map[key] += Math.floor(r.requireLength || 0);
  });

  return { dates: Object.keys(map), values: Object.values(map) };
}

function renderChart(list) {
  if (!chartInstance) return;
  const { dates, values } = buildChartData(list, chartPeriod.value);
  chartInstance.setOption({
    tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
    grid: { left: 40, right: 20, top: 20, bottom: 40 },
    xAxis: {
      type: 'category',
      data: dates,
      axisLabel: { fontSize: 11, rotate: dates.length > 14 ? 45 : 0 },
    },
    yAxis: { type: 'value', minInterval: 1 },
    series: [{
      type: 'bar',
      data: values,
      barMaxWidth: 40,
      itemStyle: {
        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
          { offset: 0, color: '#36cfc9' },
          { offset: 1, color: '#1677ff' },
        ]),
        borderRadius: [4, 4, 0, 0],
      },
    }],
  });
}

function updateChart() {
  renderChart(allList);
}

function startScroll() {
  if (doneTasks.value.length === 0) return;
  const itemHeight = 90;
  scrollTimer = setInterval(() => {
    scrollOffset.value += itemHeight;
    if (scrollOffset.value >= doneTasks.value.length * itemHeight) {
      scrollOffset.value = 0;
    }
  }, 2500);
}

async function loadData() {
  try {
    const res = await fabricRelaxApi.query({ pageNum: 1, pageSize: 500 });
    allList = res.data?.list || [];

    const pending = allList.filter(r => r.status === 0);
    const inProgress = allList.filter(r => r.status === 1);
    const done = allList.filter(r => r.status === 2);
    const ended = allList.filter(r => r.status === 3);

    stats.pendingCount = pending.length;
    stats.pendingRolls = sumRolls(pending);
    stats.inProgressCount = inProgress.length;
    stats.inProgressRolls = sumRolls(inProgress);
    stats.doneCount = done.length;
    stats.doneRolls = sumRolls(done);
    stats.endedCount = ended.length;
    stats.endedRolls = sumRolls(ended);

    doneTasks.value = done;

    await nextTick();
    renderChart(allList);
    startScroll();
  } catch (e) { smartSentry.captureError(e); }
}

onMounted(async () => {
  await nextTick();
  chartInstance = echarts.init(chartRef.value);
  loadData();
});

onUnmounted(() => {
  if (scrollTimer) clearInterval(scrollTimer);
  if (chartInstance) chartInstance.dispose();
});
</script>

<style scoped>
.dashboard-header {
  background: linear-gradient(135deg, #1677ff 0%, #36cfc9 100%);
  border-radius: 8px;
  padding: 24px 32px;
  margin-bottom: 4px;
  color: #fff;
}
.dashboard-header-content { display: flex; flex-direction: column; }
.dashboard-title { display: flex; align-items: center; font-size: 24px; font-weight: 700; }
.dashboard-subtitle { margin-top: 4px; font-size: 13px; opacity: 0.85; }

.stat-card {
  border-radius: 8px;
  padding: 20px 20px 16px;
  display: flex;
  align-items: center;
  gap: 16px;
  border-top: 4px solid transparent;
  background: #fff;
  box-shadow: 0 2px 8px rgba(0,0,0,0.08);
}
.stat-card-blue { border-top-color: #1677ff; }
.stat-card-yellow { border-top-color: #faad14; }
.stat-card-pink { border-top-color: #eb2f96; }
.stat-card-green { border-top-color: #52c41a; }

.stat-card-icon {
  font-size: 32px;
  width: 52px;
  height: 52px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}
.stat-card-blue .stat-card-icon { background: #e6f4ff; color: #1677ff; }
.stat-card-yellow .stat-card-icon { background: #fffbe6; color: #faad14; }
.stat-card-pink .stat-card-icon { background: #fff0f6; color: #eb2f96; }
.stat-card-green .stat-card-icon { background: #f6ffed; color: #52c41a; }

.stat-card-label { font-size: 13px; color: #888; margin-bottom: 4px; }
.stat-card-value { font-size: 28px; font-weight: 700; color: #222; line-height: 1.2; }
.stat-unit { font-size: 14px; font-weight: 400; color: #888; }
.stat-card-sub { font-size: 12px; color: #aaa; margin-top: 2px; }

.broadcast-container {
  height: 280px;
  overflow: hidden;
  position: relative;
}
.broadcast-list { will-change: transform; }
.broadcast-item {
  background: #fafafa;
  border: 1px solid #f0f0f0;
  border-radius: 6px;
  padding: 10px 12px;
  margin-bottom: 8px;
  height: 82px;
  box-sizing: border-box;
}
.broadcast-item-header {
  display: flex;
  align-items: center;
  margin-bottom: 8px;
}
.broadcast-item-body {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}
.broadcast-field {
  font-size: 12px;
  color: #555;
  display: flex;
  align-items: center;
  gap: 3px;
}
</style>
