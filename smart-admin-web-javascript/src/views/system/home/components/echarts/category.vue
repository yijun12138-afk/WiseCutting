<template>
  <default-home-card icon="Profile" title="指令单变化趋势">
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
      },
      legend: { data: ['新建', '下达', '完工'] },
      grid: {
        left: '3%',
        right: '4%',
        bottom: '3%',
        containLabel: true,
      },
      xAxis: {
        type: 'category',
        data: ['周一', '周二', '周三', '周四', '周五', '周六', '周日'],
      },
      yAxis: { type: 'value' },
      series: [
        {
          name: '新建',
          data: [5, 8, 3, 6, 9, 2, 4],
          type: 'bar',
        },
        {
          name: '下达',
          data: [4, 6, 5, 7, 8, 3, 5],
          type: 'bar',
        },
        {
          name: '完工',
          data: [3, 5, 4, 5, 7, 2, 3],
          type: 'bar',
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
      width: 800px;
      height: 280px;
    }
  }
</style>
