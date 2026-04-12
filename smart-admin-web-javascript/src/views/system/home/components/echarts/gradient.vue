<template>
  <default-home-card icon="AreaChartOutlined" title="本周铺布 &amp; 松布 &amp; 裁剪完工趋势">
    <div class="echarts-box">
      <div class="gradient-main" ref="chartRef"></div>
    </div>
  </default-home-card>
</template>
<script setup>
  import DefaultHomeCard from '/@/views/system/home/components/default-home-card.vue';
  import * as echarts from 'echarts';
  import { onMounted, watch, ref } from 'vue';

  const props = defineProps({
    chartData: { type: Object, default: null },
  });

  const chartRef = ref(null);
  let myChart = null;

  const days = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];

  function buildOption(data) {
    const spreadData = data?.spreadDailyComplete || [0, 0, 0, 0, 0, 0, 0];
    const relaxData = data?.relaxDailyComplete || [0, 0, 0, 0, 0, 0, 0];
    const cuttingData = data?.cuttingDailyComplete || [0, 0, 0, 0, 0, 0, 0];
    return {
      tooltip: {
        trigger: 'axis',
        axisPointer: { type: 'cross', label: { backgroundColor: '#1a1a2e' } },
        backgroundColor: 'rgba(26,26,46,0.88)',
        borderColor: 'transparent',
        textStyle: { color: '#fff', fontSize: 12 },
      },
      legend: {
        data: ['铺布完成', '松布完成', '裁剪完工'],
        top: 4,
        right: 8,
        itemWidth: 14,
        itemHeight: 8,
        textStyle: { fontSize: 12, color: '#666' },
      },
      grid: { left: '2%', right: '3%', bottom: '3%', top: '36px', containLabel: true },
      xAxis: [{
        type: 'category',
        boundaryGap: false,
        data: days,
        axisLine: { lineStyle: { color: '#eee' } },
        axisTick: { show: false },
        axisLabel: { color: '#888', fontSize: 12 },
      }],
      yAxis: [{
        type: 'value',
        splitLine: { lineStyle: { color: '#f5f5f5', type: 'dashed' } },
        axisLabel: { color: '#888', fontSize: 12 },
      }],
      series: [
        {
          name: '铺布完成', type: 'line', stack: 'Total', smooth: true,
          lineStyle: { width: 0 }, showSymbol: false,
          areaStyle: { opacity: 0.75, color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{ offset: 0, color: 'rgba(6,182,212,0.9)' }, { offset: 1, color: 'rgba(6,182,212,0.1)' }]) },
          emphasis: { focus: 'series' }, data: spreadData,
        },
        {
          name: '松布完成', type: 'line', stack: 'Total', smooth: true,
          lineStyle: { width: 0 }, showSymbol: false,
          areaStyle: { opacity: 0.75, color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{ offset: 0, color: 'rgba(16,185,129,0.9)' }, { offset: 1, color: 'rgba(16,185,129,0.1)' }]) },
          emphasis: { focus: 'series' }, data: relaxData,
        },
        {
          name: '裁剪完工', type: 'line', stack: 'Total', smooth: true,
          lineStyle: { width: 0 }, showSymbol: false,
          label: { show: false },
          areaStyle: { opacity: 0.75, color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{ offset: 0, color: 'rgba(99,102,241,0.9)' }, { offset: 1, color: 'rgba(99,102,241,0.1)' }]) },
          emphasis: { focus: 'series' }, data: cuttingData,
        },
      ],
    };
  }

  onMounted(() => {
    if (chartRef.value) {
      myChart = echarts.init(chartRef.value);
      myChart.setOption(buildOption(props.chartData));
      window.addEventListener('resize', () => myChart?.resize());
    }
  });

  watch(() => props.chartData, (val) => {
    if (myChart && val) {
      myChart.setOption(buildOption(val));
    }
  });
</script>
<style lang="less" scoped>
  .echarts-box {
    display: flex;
    align-items: center;
    justify-content: center;
    .gradient-main {
      width: 100%;
      height: 260px;
    }
  }
</style>
