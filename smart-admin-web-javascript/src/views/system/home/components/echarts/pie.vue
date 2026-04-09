<template>
  <default-home-card icon="PieChartOutlined" title="指令单优先级分布">
    <div class="echarts-box">
      <div class="pie-main" id="pie-main"></div>
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
        trigger: 'item',
        formatter: '{b}：{c} 单 ({d}%)',
        backgroundColor: 'rgba(26,26,46,0.85)',
        borderColor: 'transparent',
        textStyle: { color: '#fff', fontSize: 12 },
      },
      legend: {
        bottom: '4%',
        left: 'center',
        itemWidth: 10,
        itemHeight: 10,
        textStyle: { fontSize: 12, color: '#666' },
      },
      series: [
        {
          name: '指令单优先级',
          type: 'pie',
          radius: ['38%', '65%'],
          center: ['50%', '45%'],
          avoidLabelOverlap: false,
          itemStyle: { borderRadius: 6, borderColor: '#fff', borderWidth: 2 },
          label: {
            show: true,
            position: 'outside',
            formatter: '{b}\n{d}%',
            fontSize: 11,
            color: '#555',
          },
          emphasis: {
            label: { show: true, fontSize: '14', fontWeight: 'bold' },
            itemStyle: { shadowBlur: 10, shadowOffsetX: 0, shadowColor: 'rgba(0, 0, 0, 0.3)' },
          },
          data: [
            { value: 12, name: '紧急', itemStyle: { color: '#ef4444' } },
            { value: 28, name: '高优先级', itemStyle: { color: '#f59e0b' } },
            { value: 45, name: '普通', itemStyle: { color: '#3b82f6' } },
            { value: 15, name: '低优先级', itemStyle: { color: '#94a3b8' } },
          ],
        },
      ],
    };
    let chartDom = document.getElementById('pie-main');
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
    .pie-main {
      width: 100%;
      height: 260px;
    }
  }
</style>
