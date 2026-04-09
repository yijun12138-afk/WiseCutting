<!--
  * 首页 - 快捷功能入口卡片
  *
  * @Author:    裁匠实验室
  * @Date:      2024-04-09
  *
-->
<template>
  <div class="quick-entry-card">
    <div class="card-header">
      <component :is="$antIcons['ThunderboltOutlined']" class="header-icon" />
      <span class="header-title">快捷入口</span>
    </div>
    <div class="entry-grid">
      <div
        v-for="item in entries"
        :key="item.key"
        class="entry-item"
        @click="goto(item.path)"
        @mouseenter="hoverKey = item.key"
        @mouseleave="hoverKey = ''"
      >
        <div
          class="entry-icon-wrap"
          :style="{
            background: hoverKey === item.key ? item.color : item.light,
            borderColor: hoverKey === item.key ? item.color : 'transparent',
          }"
        >
          <component
            :is="$antIcons[item.icon]"
            class="entry-icon"
            :style="{ color: hoverKey === item.key ? '#fff' : item.color }"
          />
        </div>
        <span class="entry-label">{{ item.label }}</span>
        <a-tag :color="item.tagColor" class="entry-tag">{{ item.tag }}</a-tag>
      </div>
    </div>
  </div>
</template>

<script setup>
  import { ref } from 'vue';
  import { useRouter } from 'vue-router';

  const router = useRouter();
  const hoverKey = ref('');

  const entries = [
    { key: 'production-order', label: '生产制单',  icon: 'FileTextOutlined',        color: '#6366f1', light: 'rgba(99,102,241,0.1)',  tagColor: 'purple', tag: '生产', path: '/production/order' },
    { key: 'cutting-plan',     label: '裁剪计划',  icon: 'CalendarOutlined',         color: '#3b82f6', light: 'rgba(59,130,246,0.1)',  tagColor: 'blue',   tag: '计划', path: '/cutting/plan' },
    { key: 'cutting-order',    label: '裁床单',    icon: 'OrderedListOutlined',      color: '#8b5cf6', light: 'rgba(139,92,246,0.1)',  tagColor: 'geekblue',tag: '裁床', path: '/cutting/order' },
    { key: 'relax-plan',       label: '松布计划',  icon: 'ProfileOutlined',          color: '#10b981', light: 'rgba(16,185,129,0.1)', tagColor: 'green',  tag: '松布', path: '/relax/plan' },
    { key: 'relax-task',       label: '松布任务',  icon: 'UnorderedListOutlined',    color: '#06b6d4', light: 'rgba(6,182,212,0.1)',   tagColor: 'cyan',   tag: '任务', path: '/relax/task' },
    { key: 'spread-task',      label: '铺布任务',  icon: 'AppstoreOutlined',         color: '#f59e0b', light: 'rgba(245,158,11,0.1)', tagColor: 'orange', tag: '铺布', path: '/spread/task' },
    { key: 'spread-workbench', label: '铺布工作台',icon: 'DesktopOutlined',          color: '#ef4444', light: 'rgba(239,68,68,0.1)',  tagColor: 'red',    tag: '工台', path: '/spread/workbench' },
    { key: 'garment',          label: '成衣列表',  icon: 'ShoppingOutlined',         color: '#ec4899', light: 'rgba(236,72,153,0.1)', tagColor: 'magenta',tag: '成衣', path: '/material/garment' },
    { key: 'fabric',           label: '面料列表',  icon: 'TagOutlined',              color: '#14b8a6', light: 'rgba(20,184,166,0.1)', tagColor: 'cyan',   tag: '面料', path: '/material/fabric' },
    { key: 'customer',         label: '客户管理',  icon: 'TeamOutlined',             color: '#f97316', light: 'rgba(249,115,22,0.1)', tagColor: 'orange', tag: '客户', path: '/basic/customer' },
    { key: 'style-color',      label: '款式颜色',  icon: 'BgColorsOutlined',         color: '#a855f7', light: 'rgba(168,85,247,0.1)', tagColor: 'purple', tag: '款式', path: '/basic/style-color' },
    { key: 'basic',            label: '基础数据',  icon: 'DatabaseOutlined',         color: '#64748b', light: 'rgba(100,116,139,0.1)',tagColor: 'default',tag: '基础', path: '/basic/cutting-part' },
  ];

  function goto(path) {
    router.push({ path });
  }
</script>

<style scoped lang="less">
  .quick-entry-card {
    background: #fff;
    border-radius: 10px;
    padding: 16px 20px;
    box-shadow: 0 2px 12px rgba(0, 0, 0, 0.06);
    border: 1px solid #f0f0f0;

    .card-header {
      display: flex;
      align-items: center;
      gap: 8px;
      margin-bottom: 16px;
      padding-bottom: 12px;
      border-bottom: 2px solid #f5f5f5;
      position: relative;

      &::before {
        content: '';
        position: absolute;
        left: -20px;
        top: -16px;
        bottom: 11px;
        width: 3px;
        background: #6366f1;
        border-radius: 0 3px 3px 0;
      }

      .header-icon {
        font-size: 17px;
        color: #6366f1;
      }

      .header-title {
        font-size: 14px;
        font-weight: 600;
        color: #1a1a2e;
      }
    }

    .entry-grid {
      display: grid;
      grid-template-columns: repeat(12, 1fr);
      gap: 10px;
    }

    .entry-item {
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 6px;
      padding: 14px 6px;
      border-radius: 10px;
      cursor: pointer;
      transition: all 0.22s ease;
      border: 1px solid transparent;

      &:hover {
        transform: translateY(-3px);
        box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
        background: rgba(0, 0, 0, 0.02);
      }

      .entry-icon-wrap {
        width: 46px;
        height: 46px;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: all 0.22s ease;
        border: 1px solid transparent;

        .entry-icon {
          font-size: 22px;
          transition: color 0.22s ease;
        }
      }

      .entry-label {
        font-size: 12px;
        font-weight: 500;
        color: #444;
        text-align: center;
        white-space: nowrap;
      }

      .entry-tag {
        font-size: 10px;
        padding: 0 5px;
        line-height: 16px;
        height: 16px;
        border-radius: 8px;
      }
    }
  }
</style>
