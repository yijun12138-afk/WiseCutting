<template>
  <default-home-card icon="PieChartOutlined" title="指令单状态分布">
    <div class="echarts-box">
      <div class="pie-main" ref="chartRef"></div>
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

  function buildOption(data) {
    const plan = data?.orderStatusPlan || 0;
    const issued = data?.orderStatusIssued || 0;
    const complete = data?.orderStatusComplete || 0;
    return {
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
      series: [{
        name: '指令单状态',
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
          { value: plan, name: '计划', itemStyle: { color: '#94a3b8' } },
          { value: issued, name: '下达', itemStyle: { color: '#3b82f6' } },
          { value: complete, name: '完工', itemStyle: { color: '#10b981' } },
        ],
      }],
    };
  }

  onMounted(() => {
    if (chartRef.value) {
      myChart = echarts.init(chartRef.value);
      myChart.setOption(buildOption(props.chartData));
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
    .pie-main {
      width: 100%;
      height: 260px;
    }
  }
</style>
