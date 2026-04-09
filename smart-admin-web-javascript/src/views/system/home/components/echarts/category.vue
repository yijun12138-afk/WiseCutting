<template>
  <default-home-card icon="LineChartOutlined" title="本周裁剪指令趋势">
    <div class="echarts-box">
      <div class="category-main" id="category-main"></div>
    </div>
  </default-home-card>
</template>
<script setup>
  import DefaultHomeCard from '/@/views/system/home/components/default-home-card.vue';
  import * as echarts from 'echarts';
  import { onMounted } from 'vue';

  onMounted(() => {
    init();
  });

  function init() {
    let option = {
      tooltip: {
        trigger: 'axis',
        axisPointer: { type: 'shadow' },
        backgroundColor: 'rgba(26,26,46,0.85)',
        borderColor: 'transparent',
        textStyle: { color: '#fff', fontSize: 12 },
      },
      legend: {
        data: ['新建', '下达', '完工'],
        top: 4,
        right: 8,
        itemWidth: 12,
        itemHeight: 12,
        textStyle: { fontSize: 12, color: '#666' },
      },
      grid: { left: '2%', right: '3%', bottom: '3%', top: '36px', containLabel: true },
      xAxis: {
        type: 'category',
        data: ['周一', '周二', '周三', '周四', '周五', '周六', '周日'],
        axisLine: { lineStyle: { color: '#eee' } },
        axisTick: { show: false },
        axisLabel: { color: '#888', fontSize: 12 },
      },
      yAxis: {
        type: 'value',
        splitLine: { lineStyle: { color: '#f5f5f5', type: 'dashed' } },
        axisLabel: { color: '#888', fontSize: 12 },
      },
      series: [
        {
          name: '新建',
          data: [5, 8, 3, 6, 9, 2, 4],
          type: 'bar',
          barMaxWidth: 18,
          itemStyle: { color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{ offset: 0, color: '#818cf8' }, { offset: 1, color: '#6366f1' }]), borderRadius: [4, 4, 0, 0] },
        },
        {
          name: '下达',
          data: [4, 6, 5, 7, 8, 3, 5],
          type: 'bar',
          barMaxWidth: 18,
          itemStyle: { color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{ offset: 0, color: '#60a5fa' }, { offset: 1, color: '#3b82f6' }]), borderRadius: [4, 4, 0, 0] },
        },
        {
          name: '完工',
          data: [3, 5, 4, 5, 7, 2, 3],
          type: 'bar',
          barMaxWidth: 18,
          itemStyle: { color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{ offset: 0, color: '#34d399' }, { offset: 1, color: '#10b981' }]), borderRadius: [4, 4, 0, 0] },
        },
      ],
    };
    let chartDom = document.getElementById('category-main');
    if (chartDom) {
      let myChart = echarts.init(chartDom);
      option && myChart.setOption(option);
    }
  }
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
