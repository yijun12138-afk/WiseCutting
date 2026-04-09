<!--
  * 首页 card 插槽
  *
  * @Author:    裁匠实验室
  * @Date:      2024-04-09
  *
-->
<template>
  <div class="card-container">
    <a-card size="small">
      <template #title>
        <div class="title">
          <component :is="$antIcons[props.icon]" v-if="props.icon" :style="{ fontSize: '17px', color: token.colorPrimary }" />
          <slot name="title"></slot>
          <span v-if="!$slots.title" class="smart-margin-left10 title-text">{{ props.title }}</span>
        </div>
      </template>
      <template v-if="props.extra" #extra>
        <slot name="extra"></slot>
        <a v-if="!$slots.extra" class="extra-link" @click="extraClick">{{ props.extra }} →</a>
      </template>
      <slot></slot>
    </a-card>
  </div>
</template>
<script setup>
  import { theme } from 'ant-design-vue';
  import { computed } from 'vue';

  let props = defineProps({
    icon: String,
    title: String,
    extra: String,
  });
  let emits = defineEmits(['extraClick']);

  function extraClick() {
    emits('extraClick');
  }

  const { useToken } = theme;
  const { token } = useToken();
  const color = computed(() => {
    return token.colorPrimary;
  });
</script>
<style lang="less" scoped>
  .card-container {
    height: 100%;

    :deep(.ant-card) {
      border-radius: 10px;
      box-shadow: 0 2px 12px rgba(0, 0, 0, 0.06);
      border: 1px solid #f0f0f0;
      height: 100%;
    }

    :deep(.ant-card-head) {
      min-height: 44px;
      border-bottom: 1px solid #f5f5f5;
    }

    .title {
      display: flex;
      align-items: center;

      .title-text {
        font-size: 14px;
        font-weight: 600;
        color: #1a1a2e;
      }

      &::before {
        content: '';
        position: absolute;
        top: 3px;
        left: 0;
        width: 3px;
        height: 30px;
        background: v-bind('token.colorPrimary');
        border-radius: 0 3px 3px 0;
      }
    }

    .extra-link {
      font-size: 12px;
      color: v-bind('token.colorPrimary');

      &:hover {
        text-decoration: underline;
      }
    }
  }
</style>
