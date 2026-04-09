<template>
  <default-home-card icon="AreaChartOutlined" title="本周铺布 & 松布完成趋势">
    <div class="echarts-box">
      <div class="gradient-main" id="gradient-main"></div>
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
      xAxis: [
        {
          type: 'category',
          boundaryGap: false,
          data: ['周一', '周二', '周三', '周四', '周五', '周六', '周日'],
          axisLine: { lineStyle: { color: '#eee' } },
          axisTick: { show: false },
          axisLabel: { color: '#888', fontSize: 12 },
        },
      ],
      yAxis: [
        {
          type: 'value',
          splitLine: { lineStyle: { color: '#f5f5f5', type: 'dashed' } },
          axisLabel: { color: '#888', fontSize: 12 },
        },
      ],
      series: [
        {
          name: '铺布完成',
          type: 'line',
          stack: 'Total',
          smooth: true,
          lineStyle: { width: 0 },
          showSymbol: false,
          areaStyle: {
            opacity: 0.75,
            color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
              { offset: 0, color: 'rgba(6,182,212,0.9)' },
              { offset: 1, color: 'rgba(6,182,212,0.1)' },
            ]),
          },
          emphasis: { focus: 'series' },
          data: [18, 25, 20, 30, 28, 15, 22],
        },
        {
          name: '松布完成',
          type: 'line',
          stack: 'Total',
          smooth: true,
          lineStyle: { width: 0 },
          showSymbol: false,
          areaStyle: {
            opacity: 0.75,
            color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
              { offset: 0, color: 'rgba(16,185,129,0.9)' },
              { offset: 1, color: 'rgba(16,185,129,0.1)' },
            ]),
          },
          emphasis: { focus: 'series' },
          data: [10, 14, 12, 18, 16, 9, 13],
        },
        {
          name: '裁剪完工',
          type: 'line',
          stack: 'Total',
          smooth: true,
          lineStyle: { width: 0 },
          showSymbol: false,
          label: { show: false },
          areaStyle: {
            opacity: 0.75,
            color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
              { offset: 0, color: 'rgba(99,102,241,0.9)' },
              { offset: 1, color: 'rgba(99,102,241,0.1)' },
            ]),
          },
          emphasis: { focus: 'series' },
          data: [8, 12, 9, 14, 13, 6, 10],
        },
      ],
    };
    let chartDom = document.getElementById('gradient-main');
    if (chartDom) {
      let myChart = echarts.init(chartDom);
      option && myChart.setOption(option);
      // 自适应宽度
      window.addEventListener('resize', () => myChart.resize());
    }
  }
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
