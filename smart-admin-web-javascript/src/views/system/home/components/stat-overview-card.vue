<!--
  * 首页 - 数据统计概览（真实数据）
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
      </div>
      <div class="stat-icon-wrap">
        <component :is="$antIcons[item.icon]" class="stat-main-icon" />
      </div>
    </div>
  </div>
</template>

<script setup>
  import { computed } from 'vue';

  const props = defineProps({
    statsData: { type: Object, default: null },
  });

  const stats = computed(() => {
    const d = props.statsData;
    return [
      {
        key: 'plan',
        label: '裁剪计划（本周）',
        value: d ? d.weekCuttingPlanCount : '-',
        icon: 'FileTextOutlined',
        color: '#6366f1',
        light: 'rgba(99,102,241,0.1)',
      },
      {
        key: 'order',
        label: '裁剪指令（本周）',
        value: d ? d.weekCuttingOrderCount : '-',
        icon: 'OrderedListOutlined',
        color: '#3b82f6',
        light: 'rgba(59,130,246,0.1)',
      },
      {
        key: 'spread',
        label: '铺布任务（本周）',
        value: d ? d.weekSpreadCount : '-',
        icon: 'AppstoreOutlined',
        color: '#06b6d4',
        light: 'rgba(6,182,212,0.1)',
      },
      {
        key: 'production',
        label: '生产完工（本周）',
        value: d ? d.weekProductionCompleteCount : '-',
        icon: 'CheckCircleOutlined',
        color: '#10b981',
        light: 'rgba(16,185,129,0.1)',
      },
    ];
  });
</script>

<style scoped lang="less">
  .stat-overview {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 12px;
    margin-bottom: 0;
  }

  @media (max-width: 1100px) {
    .stat-overview {
      grid-template-columns: repeat(2, 1fr);
    }
  }

  @media (max-width: 600px) {
    .stat-overview {
      grid-template-columns: 1fr;
    }
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
    min-width: 0;

    &:hover {
      transform: translateY(-3px);
      box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
      border-color: var(--stat-color);
    }

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
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
      }

      .stat-value {
        font-size: 32px;
        font-weight: 800;
        color: #1a1a2e;
        line-height: 1;
        margin-bottom: 8px;
        font-family: 'DIN Alternate', 'Roboto', sans-serif;
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
      flex-shrink: 0;

      .stat-main-icon {
        font-size: 20px;
        color: var(--stat-color);
      }
    }
  }
</style>
