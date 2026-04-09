<!--
  * 首页 - 数据统计概览
  *
  * @Author:    裁匠实验室
  * @Date:      2024-04-09
  *
-->
<template>
  <div class="stat-overview">
    <div
      v-for="item in stats"
      :key="item.key"
      class="stat-item"
      :style="{ '--stat-color': item.color, '--stat-light': item.light }"
    >
      <div class="stat-bg-icon">
        <component :is="$antIcons[item.icon]" />
      </div>
      <div class="stat-content">
        <div class="stat-label">{{ item.label }}</div>
        <div class="stat-value">{{ item.value }}</div>
        <div class="stat-trend">
          <component :is="$antIcons[item.trendIcon]" :style="{ color: item.trendColor }" />
          <span :style="{ color: item.trendColor }">{{ item.trend }}</span>
          <span class="stat-sub">较上周</span>
        </div>
      </div>
      <div class="stat-icon-wrap">
        <component :is="$antIcons[item.icon]" class="stat-main-icon" />
      </div>
    </div>
  </div>
</template>

<script setup>
  const stats = [
    {
      key: 'plan',
      label: '裁剪计划（本周）',
      value: '24',
      icon: 'FileTextOutlined',
      color: '#6366f1',
      light: 'rgba(99,102,241,0.1)',
      trend: '↑ 4 单',
      trendIcon: 'ArrowUpOutlined',
      trendColor: '#52c41a',
    },
    {
      key: 'order',
      label: '裁剪指令（本周）',
      value: '68',
      icon: 'OrderedListOutlined',
      color: '#3b82f6',
      light: 'rgba(59,130,246,0.1)',
      trend: '↑ 12 单',
      trendIcon: 'ArrowUpOutlined',
      trendColor: '#52c41a',
    },
    {
      key: 'spread',
      label: '铺布任务（本周）',
      value: '52',
      icon: 'AppstoreOutlined',
      color: '#06b6d4',
      light: 'rgba(6,182,212,0.1)',
      trend: '↓ 3 单',
      trendIcon: 'ArrowDownOutlined',
      trendColor: '#ff4d4f',
    },
    {
      key: 'production',
      label: '生产完工（本周）',
      value: '41',
      icon: 'CheckCircleOutlined',
      color: '#10b981',
      light: 'rgba(16,185,129,0.1)',
      trend: '↑ 8 单',
      trendIcon: 'ArrowUpOutlined',
      trendColor: '#52c41a',
    },
  ];
</script>

<style scoped lang="less">
  .stat-overview {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 12px;
    margin-bottom: 0;
  }

  .stat-item {
    background: #fff;
    border-radius: 10px;
    padding: 18px 16px;
    position: relative;
    overflow: hidden;
    cursor: pointer;
    transition: all 0.25s ease;
    box-shadow: 0 2px 12px rgba(0, 0, 0, 0.06);
    border: 1px solid #f0f0f0;

    &:hover {
      transform: translateY(-3px);
      box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
      border-color: var(--stat-color);
    }

    // 左侧彩色竖条
    &::before {
      content: '';
      position: absolute;
      left: 0;
      top: 0;
      bottom: 0;
      width: 4px;
      background: var(--stat-color);
      border-radius: 10px 0 0 10px;
    }

    .stat-bg-icon {
      position: absolute;
      right: -10px;
      bottom: -10px;
      font-size: 80px;
      color: var(--stat-light);
      opacity: 0.6;
      pointer-events: none;
    }

    .stat-content {
      padding-left: 6px;

      .stat-label {
        font-size: 12px;
        color: #888;
        margin-bottom: 8px;
      }

      .stat-value {
        font-size: 32px;
        font-weight: 800;
        color: #1a1a2e;
        line-height: 1;
        margin-bottom: 8px;
        font-family: 'DIN Alternate', 'Roboto', sans-serif;
      }

      .stat-trend {
        display: flex;
        align-items: center;
        gap: 4px;
        font-size: 12px;

        .stat-sub {
          color: #bbb;
          margin-left: 2px;
        }
      }
    }

    .stat-icon-wrap {
      position: absolute;
      top: 16px;
      right: 16px;
      width: 40px;
      height: 40px;
      background: var(--stat-light);
      border-radius: 10px;
      display: flex;
      align-items: center;
      justify-content: center;

      .stat-main-icon {
        font-size: 20px;
        color: var(--stat-color);
      }
    }
  }
</style>
