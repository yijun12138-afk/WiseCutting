<!--
  * 首页的 通知公告
  *
  * @Author:    裁匠实验室
  * @Date:      2024-04-09
  *
-->
<template>
  <default-home-card extra="更多" icon="SoundOutlined" title="通知公告" @extraClick="onMore">
    <a-spin :spinning="loading">
      <div class="content-wrapper">
        <a-empty v-if="$lodash.isEmpty(data)" description="暂无通知" />
        <ul v-else>
          <li v-for="(item, index) in data" :key="index" :class="[item.viewFlag ? 'read' : 'un-read']">
            <a-tooltip placement="top">
              <template #title>
                <span>{{ item.title }}</span>
              </template>
              <a class="content" @click="toDetail(item.noticeId)">
                <span class="dot" :class="{ unread: !item.viewFlag }"></span>
                {{ item.title }}
              </a>
            </a-tooltip>
            <span class="time">{{ item.publishDate }}</span>
          </li>
        </ul>
      </div>
    </a-spin>
  </default-home-card>
</template>

<script setup>
  import { onMounted, ref } from 'vue';
  import { useRouter } from 'vue-router';
  import { noticeApi } from '/@/api/business/oa/notice-api';
  import { smartSentry } from '/@/lib/smart-sentry';
  import DefaultHomeCard from '/@/views/system/home/components/default-home-card.vue';

  const props = defineProps({
    noticeTypeId: {
      type: Number,
      default: 1,
    },
  });

  const queryForm = {
    noticeTypeId: props.noticeTypeId,
    pageNum: 1,
    pageSize: 8,
    searchCount: false,
  };

  let data = ref([]);
  const loading = ref(false);

  async function queryNoticeList() {
    try {
      loading.value = true;
      const result = await noticeApi.queryEmployeeNotice(queryForm);
      data.value = result.data.list;
    } catch (err) {
      smartSentry.captureError(err);
    } finally {
      loading.value = false;
    }
  }

  onMounted(() => {
    queryNoticeList();
  });

  const router = useRouter();

  function onMore() {
    router.push({ path: '/oa/notice/notice-employee-list' });
  }

  function toDetail(noticeId) {
    router.push({ path: '/oa/notice/notice-employee-detail', query: { noticeId } });
  }
</script>

<style lang="less" scoped>
  .content-wrapper {
    min-height: 160px;
    max-height: 220px;
    overflow-y: auto;
    overflow-x: hidden;

    &::-webkit-scrollbar {
      width: 4px;
    }
    &::-webkit-scrollbar-thumb {
      background: #e0e0e0;
      border-radius: 4px;
    }
  }

  ul {
    padding: 0;
    margin: 0;
    list-style: none;
  }

  ul li {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 7px 6px;
    border-radius: 6px;
    margin-bottom: 2px;
    transition: background 0.2s;

    &:hover {
      background: #f8f8ff;
    }

    .content {
      display: flex;
      align-items: center;
      gap: 6px;
      white-space: nowrap;
      text-overflow: ellipsis;
      overflow: hidden;
      word-break: break-all;
      margin-right: 8px;
      font-size: 13px;

      .dot {
        flex-shrink: 0;
        width: 7px;
        height: 7px;
        border-radius: 50%;
        background: #d9d9d9;

        &.unread {
          background: #ef4444;
          box-shadow: 0 0 4px rgba(239, 68, 68, 0.5);
        }
      }
    }

    .time {
      flex-shrink: 0;
      color: #bbb;
      font-size: 11px;
      min-width: 75px;
      text-align: right;
    }
  }

  .read .content {
    color: #aaa;
  }
</style>
