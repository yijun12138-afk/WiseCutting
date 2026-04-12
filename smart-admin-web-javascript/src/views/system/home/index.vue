<!--
  * 首页（真实数据版）
-->
<template>
  <div class="home-page">
    <!-- 顶部 Banner -->
    <HomeHeader />

    <!-- 数据统计概览 -->
    <StatOverview style="margin-top: 14px" :stats-data="statsData" />

    <!-- 主体区域 -->
    <a-row :gutter="[14, 14]" style="margin-top: 14px">
      <!-- 快捷入口（全宽） -->
      <a-col :span="24">
        <QuickEntryCard />
      </a-col>

      <!-- 趋势图（全宽） -->
      <a-col :span="24">
        <Gradient :chart-data="statsData" />
      </a-col>

      <!-- 下方两列 -->
      <a-col :xs="24" :sm="24" :md="12">
        <Pie :chart-data="statsData" />
      </a-col>
      <a-col :xs="24" :sm="24" :md="12">
        <Category :chart-data="statsData" />
      </a-col>
    </a-row>
  </div>
</template>

<script setup>
  import { ref, onMounted } from 'vue';
  import HomeHeader from './home-header.vue';
  import Category from './components/echarts/category.vue';
  import Pie from './components/echarts/pie.vue';
  import Gradient from './components/echarts/gradient.vue';
  import QuickEntryCard from './components/quick-entry-card.vue';
  import StatOverview from './components/stat-overview-card.vue';
  import { homeApi } from '/@/api/system/home-api';

  const statsData = ref(null);

  onMounted(async () => {
    try {
      const res = await homeApi.getStatistics();
      statsData.value = res.data;
    } catch (e) {
      console.error('首页数据加载失败', e);
    }
  });
</script>

<style lang="less" scoped>
  .home-page {
    padding: 4px 0;
  }
</style>
