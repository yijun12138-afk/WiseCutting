<template>
  <div class="workbench-page">
    <!-- 查询区 -->
    <a-form class="smart-query-form">
      <a-row class="smart-query-form-row">
        <a-form-item label="指令单号" class="smart-query-form-item">
          <a-input
            v-model:value="searchForm.orderNo"
            placeholder="输入指令单号查询"
            style="width:200px"
            allow-clear
            @pressEnter="onSearch"
          />
        </a-form-item>
        <a-form-item label="面料名称" class="smart-query-form-item">
          <a-input
            v-model:value="searchForm.fabricName"
            placeholder="输入面料名称"
            style="width:180px"
            allow-clear
            @pressEnter="onSearch"
          />
        </a-form-item>
        <a-form-item class="smart-query-form-item">
          <a-button-group>
            <a-button type="primary" @click="onSearch"><SearchOutlined />查询</a-button>
            <a-button @click="onReset"><ReloadOutlined />重置</a-button>
          </a-button-group>
        </a-form-item>
      </a-row>
    </a-form>

    <!-- Tab 切换 -->
    <div style="margin-bottom:14px;">
      <a-radio-group v-model:value="activeTab" button-style="solid">
        <a-radio-button value="todo">
          <CloseCircleOutlined style="margin-right:4px;" />
          未完成任务
          <a-badge :count="filteredTodo.length" :number-style="{ backgroundColor: '#ff4d4f', marginLeft: '4px' }" />
        </a-radio-button>
        <a-radio-button value="done">
          <CheckCircleOutlined style="margin-right:4px;" />
          已完成任务
          <a-badge :count="filteredDone.length" :number-style="{ backgroundColor: '#52c41a', marginLeft: '4px' }" />
        </a-radio-button>
      </a-radio-group>
    </div>

    <!-- 未完成面板 -->
    <div v-show="activeTab === 'todo'">
      <div v-if="filteredTodo.length > 0" class="cards-grid">
        <a-card
          v-for="item in filteredTodo"
          :key="item.spreadId"
          size="small"
          :hoverable="true"
          class="task-card"
        >
          <template #title>
            <div style="display:flex;align-items:center;gap:8px;">
              <FileTextOutlined style="color:#1677ff;" />
              <span style="font-size:14px;font-weight:600;color:#262626;">{{ item.orderNo }}</span>
              <a-tag :color="item.status === 0 ? 'default' : 'processing'" style="margin:0;">
                {{ statusTextMap[item.status] ?? '-' }}
              </a-tag>
            </div>
          </template>
          <template #extra>
            <a-button type="primary" size="small" @click="openComplete(item)">
              <CheckOutlined /> 完成任务
            </a-button>
          </template>

          <a-descriptions :column="2" size="small">
            <a-descriptions-item label="面料名称">{{ item.fabricName || '-' }}</a-descriptions-item>
            <a-descriptions-item label="颜色">
              <a-tag color="purple" style="margin:0;">{{ item.colorName || '-' }}</a-tag>
            </a-descriptions-item>
            <a-descriptions-item label="需求层数">
              <span style="font-weight:600;">{{ item.requireLayers ?? '-' }}</span>
            </a-descriptions-item>
            <a-descriptions-item label="需求长度">
              <span style="font-weight:600;">{{ item.requireLength != null ? item.requireLength + 'm' : '-' }}</span>
            </a-descriptions-item>
            <a-descriptions-item label="实际层数">
              <span :style="{ fontWeight: 600, color: item.actualLayers ? '#52c41a' : '#bfbfbf' }">
                {{ item.actualLayers ?? '待录入' }}
              </span>
            </a-descriptions-item>
            <a-descriptions-item label="实际长度">
              <span :style="{ fontWeight: 600, color: item.actualLength != null ? '#52c41a' : '#bfbfbf' }">
                {{ item.actualLength != null ? item.actualLength + 'm' : '待录入' }}
              </span>
            </a-descriptions-item>
          </a-descriptions>

          <div style="margin-top:10px;">
            <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:4px;">
              <span style="font-size:12px;color:#8c8c8c;">完成度</span>
              <span style="font-size:12px;color:#8c8c8c;">{{ getProgress(item) }}%</span>
            </div>
            <a-progress
              :percent="getProgress(item)"
              :stroke-color="'#1677ff'"
              size="small"
              :show-info="false"
            />
          </div>

          <div style="margin-top:8px;font-size:11px;color:#bfbfbf;">
            {{ item.createTime ? item.createTime.slice(0, 16) : '-' }}
          </div>
        </a-card>
      </div>
      <a-empty v-else description="暂无未完成的铺布任务" style="padding:60px 0;background:#fff;border-radius:8px;" />
    </div>

    <!-- 已完成面板 -->
    <div v-show="activeTab === 'done'">
      <div v-if="filteredDone.length > 0" class="cards-grid">
        <a-card
          v-for="item in filteredDone"
          :key="item.spreadId"
          size="small"
          :hoverable="true"
          class="task-card task-card--done"
        >
          <template #title>
            <div style="display:flex;align-items:center;gap:8px;">
              <CheckCircleFilled style="color:#52c41a;" />
              <span style="font-size:14px;font-weight:600;color:#262626;">{{ item.orderNo }}</span>
              <a-tag color="success" style="margin:0;">已完成</a-tag>
            </div>
          </template>

          <a-descriptions :column="2" size="small">
            <a-descriptions-item label="面料名称">{{ item.fabricName || '-' }}</a-descriptions-item>
            <a-descriptions-item label="颜色">
              <a-tag color="green" style="margin:0;">{{ item.colorName || '-' }}</a-tag>
            </a-descriptions-item>
            <a-descriptions-item label="计划层数">{{ item.requireLayers ?? '-' }}</a-descriptions-item>
            <a-descriptions-item label="实际层数">
              <span style="font-weight:600;color:#52c41a;">{{ item.actualLayers ?? '-' }}</span>
            </a-descriptions-item>
            <a-descriptions-item label="计划长度">
              {{ item.requireLength != null ? item.requireLength + 'm' : '-' }}
            </a-descriptions-item>
            <a-descriptions-item label="实际长度">
              <span style="font-weight:600;color:#52c41a;">
                {{ item.actualLength != null ? item.actualLength + 'm' : '-' }}
              </span>
            </a-descriptions-item>
          </a-descriptions>

          <div style="margin-top:8px;font-size:11px;color:#bfbfbf;">
            完成时间：{{ item.createTime ? item.createTime.slice(0, 16) : '-' }}
          </div>
        </a-card>
      </div>
      <a-empty v-else description="暂无已完成的铺布任务" style="padding:60px 0;background:#fff;border-radius:8px;" />
    </div>

    <SpreadCompleteModal ref="completeModal" @reload="loadAll" />
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue';
import {
  ReloadOutlined, SearchOutlined,
  CheckCircleOutlined, CloseCircleOutlined, CheckOutlined,
  CheckCircleFilled, FileTextOutlined,
} from '@ant-design/icons-vue';
import { smartSentry } from '/@/lib/smart-sentry';
import { fabricSpreadApi } from '/@/api/business/production/spread-api';
import SpreadCompleteModal from '../production/spread/components/spread-complete-modal.vue';

const activeTab = ref('todo');
const allData = ref([]);
const completeModal = ref();
const searchForm = reactive({ orderNo: '', fabricName: '' });
const statusTextMap = { 0: '待作业', 1: '进行中', 2: '已完成' };

const filteredTodo = computed(() => {
  return allData.value.filter(r => {
    if (r.status === 2) return false;
    if (searchForm.orderNo && !r.orderNo?.includes(searchForm.orderNo)) return false;
    if (searchForm.fabricName && !r.fabricName?.includes(searchForm.fabricName)) return false;
    return true;
  });
});

const filteredDone = computed(() => {
  return allData.value.filter(r => {
    if (r.status !== 2) return false;
    if (searchForm.orderNo && !r.orderNo?.includes(searchForm.orderNo)) return false;
    if (searchForm.fabricName && !r.fabricName?.includes(searchForm.fabricName)) return false;
    return true;
  });
});

function getProgress(item) {
  if (item.status === 2) return 100;
  if (!item.requireLayers || !item.actualLayers) return 0;
  return Math.min(100, Math.round((item.actualLayers / item.requireLayers) * 100));
}

async function loadAll() {
  try {
    const res = await fabricSpreadApi.workbench({});
    allData.value = res.data || [];
  } catch (e) { smartSentry.captureError(e); }
}

function onSearch() { /* computed auto-filters */ }
function onReset() { searchForm.orderNo = ''; searchForm.fabricName = ''; }
function openComplete(item) { completeModal.value.show(item); }

onMounted(loadAll);
</script>

<style scoped>
.workbench-page {
  padding: 16px;
  background: #f5f6fa;
  min-height: 100vh;
}

.cards-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: 16px;
}

.task-card {
  border-radius: 8px;
}

.task-card--done {
  opacity: 0.85;
}
</style>
