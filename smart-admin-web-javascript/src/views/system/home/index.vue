<!--
  * 首页（优化版）
  *
  * @Author:    裁匠实验室
  * @Date:      2024-04-09
  *
-->
<template>
  <div class="home-page">
    <!-- 顶部 Banner -->
    <HomeHeader />

    <!-- 数据统计概览 -->
    <StatOverview style="margin-top: 14px" />

    <!-- 主体区域 -->
    <a-row :gutter="[14, 14]" style="margin-top: 14px">
      <!-- 快捷入口（全宽） -->
      <a-col :span="24">
        <QuickEntryCard />
      </a-col>

      <!-- 趋势图（全宽） -->
      <a-col :span="24">
        <Gradient />
      </a-col>

      <!-- 下方两列 -->
      <a-col :span="12">
        <Pie />
      </a-col>
      <a-col :span="12">
        <Category />
      </a-col>
    </a-row>
  </div>
</template>

<script setup>
  import HomeHeader from './home-header.vue';
  import Category from './components/echarts/category.vue';
  import Pie from './components/echarts/pie.vue';
  import Gradient from './components/echarts/gradient.vue';
  import QuickEntryCard from './components/quick-entry-card.vue';
  import StatOverview from './components/stat-overview-card.vue';
</script>

<style lang="less" scoped>
  .home-page {
    padding: 4px 0;
  }
</style>
