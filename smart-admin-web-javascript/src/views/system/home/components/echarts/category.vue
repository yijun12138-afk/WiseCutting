<template>
  <default-home-card icon="LineChartOutlined" title="本周裁剪指令趋势">
    <div class="echarts-box">
      <div class="category-main" ref="chartRef"></div>
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
    const newData = data?.cuttingOrderDailyNew || [0, 0, 0, 0, 0, 0, 0];
    const issuedData = data?.cuttingOrderDailyIssued || [0, 0, 0, 0, 0, 0, 0];
    const completeData = data?.cuttingOrderDailyComplete || [0, 0, 0, 0, 0, 0, 0];
    return {
      tooltip: {
        trigger: 'axis',
        axisPointer: { type: 'shadow' },
        backgroundColor: 'rgba(26,26,46,0.85)',
        borderColor: 'transparent',
        textStyle: { color: '#fff', fontSize: 12 },
      },
      legend: {
        data: ['待裁', '裁剪中', '完成'],
        top: 4,
        right: 8,
        itemWidth: 12,
        itemHeight: 12,
        textStyle: { fontSize: 12, color: '#666' },
      },
      grid: { left: '2%', right: '3%', bottom: '3%', top: '36px', containLabel: true },
      xAxis: {
        type: 'category',
        data: days,
        axisLine: { lineStyle: { color: '#eee' } },
        axisTick: { show: false },
        axisLabel: { color: '#888', fontSize: 12 },
      },
      yAxis: {
        type: 'value',
        splitLine: { lineStyle: { color: '#f5f5f5', type: 'dashed' } },
        axisLabel: { color: '#888', fontSize: 12 },
        minInterval: 1,
      },
      series: [
        {
          name: '待裁', data: newData, type: 'bar', barMaxWidth: 18,
          itemStyle: { color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{ offset: 0, color: '#818cf8' }, { offset: 1, color: '#6366f1' }]), borderRadius: [4, 4, 0, 0] },
        },
        {
          name: '裁剪中', data: issuedData, type: 'bar', barMaxWidth: 18,
          itemStyle: { color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{ offset: 0, color: '#60a5fa' }, { offset: 1, color: '#3b82f6' }]), borderRadius: [4, 4, 0, 0] },
        },
        {
          name: '完成', data: completeData, type: 'bar', barMaxWidth: 18,
          itemStyle: { color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{ offset: 0, color: '#34d399' }, { offset: 1, color: '#10b981' }]), borderRadius: [4, 4, 0, 0] },
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
    .category-main {
      width: 100%;
      height: 240px;
    }
  }
</style>
