<template>
  <div>
    <!-- 渐变头部 -->
    <div class="dashboard-header">
      <div class="dashboard-header-content">
        <div class="dashboard-title">
          <AppstoreOutlined style="font-size:28px;margin-right:12px" />
          <span>铺布仪表盘</span>
        </div>
        <div class="dashboard-subtitle">实时监控铺布任务进度与状态</div>
      </div>
    </div>

    <!-- 统计卡片 -->
    <a-row :gutter="16" style="margin:16px 0">
      <a-col :span="6">
        <div class="stat-card stat-card-blue">
          <div class="stat-card-icon"><AppstoreOutlined /></div>
          <div class="stat-card-body">
            <div class="stat-card-label">今日铺布任务</div>
            <div class="stat-card-value">{{ stats.todayCount }}</div>
            <div class="stat-card-sub">较昨日
              <span :style="{ color: stats.todayRatio >= 0 ? '#52c41a' : '#ff4d4f' }">
                {{ stats.todayRatio >= 0 ? '+' : '' }}{{ stats.todayRatio }}%
              </span>
            </div>
          </div>
        </div>
      </a-col>
      <a-col :span="6">
        <div class="stat-card stat-card-green">
          <div class="stat-card-icon"><CheckCircleOutlined /></div>
          <div class="stat-card-body">
            <div class="stat-card-label">已完成任务</div>
            <div class="stat-card-value">{{ stats.doneCount }}</div>
            <div class="stat-card-sub">完成率 <span style="color:#52c41a;font-weight:600;">{{ completionRate }}%</span></div>
          </div>
        </div>
      </a-col>
      <a-col :span="6">
        <div class="stat-card stat-card-yellow">
          <div class="stat-card-icon"><SyncOutlined /></div>
          <div class="stat-card-body">
            <div class="stat-card-label">进行中任务</div>
            <div class="stat-card-value">{{ stats.inProgressCount }}</div>
            <div class="stat-card-sub">实时更新</div>
          </div>
        </div>
      </a-col>
      <a-col :span="6">
        <div class="stat-card stat-card-orange">
          <div class="stat-card-icon"><ClockCircleOutlined /></div>
          <div class="stat-card-body">
            <div class="stat-card-label">待作业任务</div>
            <div class="stat-card-value">{{ stats.pendingCount }}</div>
            <div class="stat-card-sub">等待处理</div>
          </div>
        </div>
      </a-col>
    </a-row>

    <!-- 图表 + 任务列表 -->
    <a-row :gutter="16">
      <!-- 左：任务状态分布 + 每日趋势 -->
      <a-col :span="16">
        <!-- 任务状态分布（ECharts 圆环图） -->
        <a-card size="small" :bordered="false" :hoverable="true" style="margin-bottom:16px">
          <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:12px">
            <span style="font-weight:600;font-size:15px">
              <PieChartOutlined style="margin-right:6px;color:#1677ff" />任务状态分布
            </span>
            <a-select v-model:value="statusChartRange" size="small" style="width:90px;" @change="loadData">
              <a-select-option value="today">今天</a-select-option>
              <a-select-option value="week">本周</a-select-option>
              <a-select-option value="month">本月</a-select-option>
            </a-select>
          </div>

          <!-- 圆环图 + 右侧详情统计 -->
          <div style="display:flex;align-items:stretch;gap:0;">
            <!-- ECharts 圆环图 -->
            <div ref="donutChartRef" style="width:260px;height:220px;flex-shrink:0;"></div>

            <!-- 右侧详情区域 -->
            <div style="flex:1;padding:8px 16px;display:flex;flex-direction:column;justify-content:space-between;">
              <!-- 各状态进度条 -->
              <div>
                <div style="font-size:13px;color:#888;margin-bottom:10px;font-weight:500;">状态占比详情</div>
                <div v-for="item in donutData" :key="item.name" style="margin-bottom:14px;">
                  <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:4px;">
                    <div style="display:flex;align-items:center;gap:8px;">
                      <span :style="{ display:'inline-block', width:'10px', height:'10px', borderRadius:'50%', background: item.color, flexShrink:0 }"></span>
                      <span style="font-size:13px;color:#555;">{{ item.name }}</span>
                    </div>
                    <div style="display:flex;align-items:center;gap:10px;">
                      <span style="font-size:13px;font-weight:600;color:#222;">{{ item.value }} 条</span>
                      <span style="font-size:12px;color:#aaa;min-width:38px;text-align:right;">{{ item.percent }}%</span>
                    </div>
                  </div>
                  <a-progress
                    :percent="item.percent"
                    :stroke-color="item.color"
                    :show-info="false"
                    size="small"
                    style="margin:0;"
                  />
                </div>
              </div>

              <!-- 底部汇总信息 -->
              <div style="display:flex;gap:12px;margin-top:8px;">
                <div class="summary-box summary-box--blue">
                  <div class="summary-box-value">{{ totalCount }}</div>
                  <div class="summary-box-label">任务总数</div>
                </div>
                <div class="summary-box summary-box--green">
                  <div class="summary-box-value">{{ completionRate }}%</div>
                  <div class="summary-box-label">完成率</div>
                </div>
                <div class="summary-box summary-box--orange">
                  <div class="summary-box-value">{{ activeRate }}%</div>
                  <div class="summary-box-label">活跃率</div>
                </div>
              </div>
            </div>
          </div>
        </a-card>

        <!-- 每日铺布任务数量 -->
        <a-card size="small" :bordered="false" :hoverable="true">
          <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:12px">
            <span style="font-weight:600;font-size:15px">
              <BarChartOutlined style="margin-right:6px;color:#1677ff" />每日铺布任务数量
            </span>
            <a-radio-group v-model:value="dailyTab" button-style="solid" size="small" @change="loadData">
              <a-radio-button value="week">本周</a-radio-button>
              <a-radio-button value="month">本月</a-radio-button>
              <a-radio-button value="quarter">本季</a-radio-button>
              <a-radio-button value="year">本年</a-radio-button>
            </a-radio-group>
          </div>
          <div ref="dailyChartRef" style="height:240px"></div>
        </a-card>
      </a-col>

      <!-- 右：今日计划任务 + 完成进度 -->
      <a-col :span="8">
        <!-- 完成进度卡片 -->
        <a-card size="small" :bordered="false" :hoverable="true" style="margin-bottom:16px;">
          <template #title>
            <span style="font-weight:600;font-size:14px;">
              <TrophyOutlined style="margin-right:6px;color:#faad14" />任务完成进度
            </span>
          </template>
          <div style="padding:4px 0;">
            <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:6px;">
              <span style="font-size:13px;color:#555;">总体完成率</span>
              <span style="font-size:15px;font-weight:700;color:#52c41a;">{{ completionRate }}%</span>
            </div>
            <a-progress
              :percent="completionRate"
              stroke-color="#52c41a"
              :stroke-width="10"
              style="margin-bottom:14px;"
            />
            <a-divider style="margin:8px 0;" />
            <div style="display:grid;grid-template-columns:1fr 1fr;gap:10px;margin-top:8px;">
              <div class="mini-stat">
                <div class="mini-stat-val" style="color:#1677ff;">{{ stats.inProgressCount }}</div>
                <div class="mini-stat-label">进行中</div>
              </div>
              <div class="mini-stat">
                <div class="mini-stat-val" style="color:#faad14;">{{ stats.pendingCount }}</div>
                <div class="mini-stat-label">待作业</div>
              </div>
              <div class="mini-stat">
                <div class="mini-stat-val" style="color:#52c41a;">{{ stats.doneCount }}</div>
                <div class="mini-stat-label">已完成</div>
              </div>
              <div class="mini-stat">
                <div class="mini-stat-val" style="color:#595959;">{{ totalCount }}</div>
                <div class="mini-stat-label">总任务</div>
              </div>
            </div>
          </div>
        </a-card>

        <!-- 今日计划任务 -->
        <a-card size="small" :bordered="false" :hoverable="true">
          <template #title>
            <span style="font-weight:600;font-size:14px">
              <UnorderedListOutlined style="margin-right:6px;color:#1677ff" />今日计划任务
            </span>
          </template>
          <template #extra>
            <a-tag color="blue">{{ tableData.length }} 个</a-tag>
          </template>
          <div style="max-height:340px;overflow-y:auto;">
            <div
              v-for="item in tableData"
              :key="item.spreadId"
              class="task-item"
              :class="'task-item--' + getTaskClass(item.status)"
            >
              <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:4px;">
                <span style="font-size:12px;font-weight:600;color:#262626;">{{ item.orderNo }}</span>
                <a-tag :color="statusTagColor[item.status]" style="margin:0;font-size:10px;line-height:18px;padding:0 6px;">
                  {{ statusTextMap[item.status] ?? '未知' }}
                </a-tag>
              </div>
              <div style="font-size:11px;color:#595959;margin-bottom:3px;">
                {{ item.fabricName || item.fabricNo || '-' }}
              </div>
              <div style="display:flex;align-items:center;justify-content:space-between;font-size:10px;color:#bfbfbf;">
                <span>床次：{{ item.requireLayers ?? '-' }}</span>
                <span>{{ item.createTime ? item.createTime.slice(0, 16) : '-' }}</span>
              </div>
            </div>
            <a-empty v-if="tableData.length === 0" description="暂无任务" style="padding:30px 0;" />
          </div>
        </a-card>
      </a-col>
    </a-row>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted, nextTick } from 'vue';
import * as echarts from 'echarts';
import {
  AppstoreOutlined, CheckCircleOutlined, SyncOutlined,
  ClockCircleOutlined, PieChartOutlined, BarChartOutlined,
  UnorderedListOutlined, TrophyOutlined,
} from '@ant-design/icons-vue';
import { smartSentry } from '/@/lib/smart-sentry';
import { fabricSpreadApi } from '/@/api/business/production/spread-api';

const statusChartRange = ref('today');
const dailyTab = ref('week');

const stats = reactive({
  todayCount: 0, todayRatio: 0,
  doneCount: 0,
  inProgressCount: 0,
  pendingCount: 0,
});

const tableData = ref([]);
const statusTextMap = { 0: '待作业', 1: '进行中', 2: '已完成' };
const statusTagColor = { 0: 'default', 1: 'processing', 2: 'success' };

const donutData = ref([
  { name: '待作业', value: 0, color: '#faad14', percent: 0 },
  { name: '进行中', value: 0, color: '#1677ff', percent: 0 },
  { name: '已完成', value: 0, color: '#52c41a', percent: 0 },
]);

const totalCount = computed(() => donutData.value.reduce((s, d) => s + d.value, 0));
const completionRate = computed(() => {
  const t = totalCount.value;
  if (!t) return 0;
  return Math.round((stats.doneCount / t) * 100);
});
const activeRate = computed(() => {
  const t = totalCount.value;
  if (!t) return 0;
  return Math.round(((stats.doneCount + stats.inProgressCount) / t) * 100);
});

const donutChartRef = ref(null);
const dailyChartRef = ref(null);
let donutChart = null;
let dailyChart = null;

function getTaskClass(status) {
  return { 0: 'pending', 1: 'progress', 2: 'done' }[status] ?? 'pending';
}

// ECharts 圆环图（可交互，hover 显示 tooltip）
function renderDonutChart(data) {
  if (!donutChart) return;
  const total = data.reduce((s, d) => s + d.value, 0) || 0;

  donutChart.setOption({
    tooltip: {
      trigger: 'item',
      formatter: (params) => {
        return `<div style="font-size:13px;">
          <span style="display:inline-block;width:10px;height:10px;border-radius:50%;background:${params.color};margin-right:6px;"></span>
          <b>${params.name}</b><br/>
          数量：<b>${params.value}</b> 条<br/>
          占比：<b>${params.percent}%</b>
        </div>`;
      },
      backgroundColor: '#fff',
      borderColor: '#e8e8e8',
      borderWidth: 1,
      textStyle: { color: '#333' },
      extraCssText: 'box-shadow: 0 4px 12px rgba(0,0,0,0.15);border-radius:8px;padding:10px 14px;',
    },
    legend: { show: false },
    // 用 graphic 独立渲染圆心文字，与 series label 完全分离，不会重叠
    graphic: [
      {
        type: 'text',
        left: 'center',
        top: '38%',
        style: {
          text: String(total),
          textAlign: 'center',
          fill: '#333',
          fontSize: 22,
          fontWeight: 'bold',
        },
        z: 10,
      },
      {
        type: 'text',
        left: 'center',
        top: '52%',
        style: {
          text: '总任务',
          textAlign: 'center',
          fill: '#999',
          fontSize: 12,
        },
        z: 10,
      },
    ],
    series: [
      {
        name: '任务状态',
        type: 'pie',
        radius: ['48%', '76%'],
        center: ['50%', '50%'],
        avoidLabelOverlap: false,
        itemStyle: {
          borderRadius: 6,
          borderColor: '#fff',
          borderWidth: 3,
        },
        // series 自身的 label 全部关闭，圆心文字由 graphic 接管
        label: { show: false },
        emphasis: {
          label: { show: false },
          itemStyle: {
            shadowBlur: 10,
            shadowOffsetX: 0,
            shadowColor: 'rgba(0, 0, 0, 0.2)',
          },
        },
        labelLine: { show: false },
        data: data.map(d => ({
          value: d.value,
          name: d.name,
          itemStyle: { color: d.color },
        })),
      },
    ],
  });

  // 用事件动态切换 graphic 文字：hover 时显示扇区数据，离开时恢复总任务
  donutChart.off('mouseover');
  donutChart.off('mouseout');

  donutChart.on('mouseover', { seriesIndex: 0 }, (params) => {
    donutChart.setOption({
      graphic: [
        {
          style: { text: String(params.value), fill: params.color, fontSize: 22, fontWeight: 'bold', textAlign: 'center' },
        },
        {
          style: { text: params.name, fill: '#999', fontSize: 12, textAlign: 'center' },
        },
      ],
    });
  });

  donutChart.on('mouseout', { seriesIndex: 0 }, () => {
    donutChart.setOption({
      graphic: [
        {
          style: { text: String(total), fill: '#333', fontSize: 22, fontWeight: 'bold', textAlign: 'center' },
        },
        {
          style: { text: '总任务', fill: '#999', fontSize: 12, textAlign: 'center' },
        },
      ],
    });
  });
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
    if (key in map) map[key] += 1;
  });
  return { dates: Object.keys(map), values: Object.values(map) };
}

function renderDailyChart(list) {
  if (!dailyChart) return;
  const { dates, values } = buildChartData(list, dailyTab.value);
  dailyChart.setOption({
    tooltip: {
      trigger: 'axis',
      axisPointer: { type: 'shadow' },
      formatter: (params) => {
        const p = params[0];
        return `<b>${p.name}</b><br/>任务数量：<b style="color:#1677ff">${p.value}</b> 条`;
      },
    },
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
      emphasis: {
        itemStyle: {
          color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
            { offset: 0, color: '#69e6e0' },
            { offset: 1, color: '#4096ff' },
          ]),
        },
      },
    }],
  });
}

async function loadData() {
  try {
    const res = await fabricSpreadApi.query({ pageNum: 1, pageSize: 100 });
    const list = res.data?.list || [];
    tableData.value = list;

    const today = new Date().toISOString().slice(0, 10);
    const todayList = list.filter(r => r.createTime?.startsWith(today));

    stats.todayCount = todayList.length;
    stats.doneCount = list.filter(r => r.status === 2).length;
    stats.inProgressCount = list.filter(r => r.status === 1).length;
    stats.pendingCount = list.filter(r => r.status === 0).length;
    stats.todayRatio = 0;

    const total = list.length || 1;
    donutData.value = [
      { name: '待作业', value: stats.pendingCount, color: '#faad14', percent: Math.round((stats.pendingCount / total) * 100) },
      { name: '进行中', value: stats.inProgressCount, color: '#1677ff', percent: Math.round((stats.inProgressCount / total) * 100) },
      { name: '已完成', value: stats.doneCount, color: '#52c41a', percent: Math.round((stats.doneCount / total) * 100) },
    ];

    await nextTick();
    renderDonutChart(donutData.value);
    renderDailyChart(list);
  } catch (e) { smartSentry.captureError(e); }
}

onMounted(async () => {
  await nextTick();
  donutChart = echarts.init(donutChartRef.value);
  dailyChart = echarts.init(dailyChartRef.value);
  loadData();
  window.addEventListener('resize', () => {
    donutChart?.resize();
    dailyChart?.resize();
  });
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
.stat-card-blue  { border-top-color: #1677ff; }
.stat-card-green { border-top-color: #52c41a; }
.stat-card-yellow { border-top-color: #faad14; }
.stat-card-orange { border-top-color: #fa8c16; }

.stat-card-icon {
  font-size: 32px;
  width: 52px; height: 52px;
  border-radius: 50%;
  display: flex; align-items: center; justify-content: center;
  flex-shrink: 0;
}
.stat-card-blue  .stat-card-icon { background: #e6f4ff; color: #1677ff; }
.stat-card-green .stat-card-icon { background: #f6ffed; color: #52c41a; }
.stat-card-yellow .stat-card-icon { background: #fffbe6; color: #faad14; }
.stat-card-orange .stat-card-icon { background: #fff7e6; color: #fa8c16; }

.stat-card-label { font-size: 13px; color: #888; margin-bottom: 4px; }
.stat-card-value { font-size: 28px; font-weight: 700; color: #222; line-height: 1.2; }
.stat-card-sub { font-size: 12px; color: #aaa; margin-top: 2px; }

/* 汇总框 */
.summary-box {
  flex: 1;
  border-radius: 8px;
  padding: 8px 10px;
  text-align: center;
}
.summary-box--blue  { background: #e6f4ff; }
.summary-box--green { background: #f6ffed; }
.summary-box--orange { background: #fff7e6; }
.summary-box-value { font-size: 18px; font-weight: 700; color: #333; line-height: 1.3; }
.summary-box--blue  .summary-box-value { color: #1677ff; }
.summary-box--green .summary-box-value { color: #52c41a; }
.summary-box--orange .summary-box-value { color: #fa8c16; }
.summary-box-label { font-size: 11px; color: #888; margin-top: 2px; }

/* 小统计块 */
.mini-stat {
  background: #fafafa;
  border-radius: 8px;
  padding: 10px 8px;
  text-align: center;
  border: 1px solid #f0f0f0;
}
.mini-stat-val { font-size: 20px; font-weight: 700; line-height: 1.2; }
.mini-stat-label { font-size: 11px; color: #888; margin-top: 3px; }

/* 任务列表项 */
.task-item {
  border-radius: 6px;
  padding: 8px 10px;
  margin-bottom: 6px;
  border-left: 3px solid #d9d9d9;
  background: #fafafa;
}
.task-item--progress { border-left-color: #1677ff; background: #f0f8ff; }
.task-item--done { border-left-color: #52c41a; background: #f6ffed; }
.task-item--pending { border-left-color: #faad14; background: #fffbe6; }
</style>
