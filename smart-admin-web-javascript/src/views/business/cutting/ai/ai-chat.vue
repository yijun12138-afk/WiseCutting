<template>
  <div class="ai-chat-container">
    <div class="chat-header">
      <span class="header-avatar">✂️</span>
      <div class="header-info">
        <span class="header-title">小裁</span>
        <span class="header-subtitle">服装生产智能助手</span>
      </div>
      <a-button
        v-if="messages.length > 0"
        size="small"
        danger
        ghost
        @click="clearHistory"
        class="clear-btn"
      >清空记录</a-button>
    </div>

    <!-- 自我介绍卡片 -->
    <div class="intro-card">
      <div class="intro-content">
        <span class="intro-icon">👋</span>
        <div>
          <div class="intro-name">你好，我是<strong>小裁</strong>！</div>
          <div class="intro-desc">我是服装生产管理系统的智能助手，可以帮您查询生产指令单、裁剪计划、铺布松布进度等信息。试着问我：</div>
          <div class="intro-examples">
            <a @click="setExample('SC202604070001 现在什么状态？')">📋 SC202604070001 现在什么状态？</a>
            <a @click="setExample('裁剪计划有多少个在进行中？')">✂️ 裁剪计划有多少个在进行中？</a>
            <a @click="setExample('系统目前有多少生产指令单？')">📊 系统目前有多少生产指令单？</a>
          </div>
        </div>
      </div>
    </div>

    <div class="chat-messages" ref="messagesRef">
      <div
        v-for="(msg, idx) in messages"
        :key="idx"
        :class="['message-item', msg.role === 'user' ? 'user-message' : 'ai-message']"
      >
        <div class="message-avatar">
          <span v-if="msg.role === 'user'">👤</span>
          <span v-else>✂️</span>
        </div>
        <div class="message-bubble">
          <div class="message-content" v-html="formatContent(msg.content)"></div>
          <div class="message-time">{{ msg.time }}</div>
        </div>
      </div>

      <div v-if="loading" class="message-item ai-message">
        <div class="message-avatar"><span>✂️</span></div>
        <div class="message-bubble">
          <div class="message-content loading-dots">
            <span></span><span></span><span></span>
          </div>
        </div>
      </div>
    </div>

    <div class="chat-input-area">
      <a-textarea
        v-model:value="inputText"
        placeholder="请输入您的问题，例如：SC202604070001 现在什么状态？"
        :auto-size="{ minRows: 1, maxRows: 4 }"
        :disabled="loading"
        @keydown.enter.exact.prevent="sendMessage"
      />
      <a-button
        type="primary"
        :loading="loading"
        :disabled="!inputText.trim()"
        @click="sendMessage"
        class="send-btn"
      >
        发送
      </a-button>
    </div>
    <div class="input-hint">按 Enter 发送，Shift+Enter 换行</div>
  </div>
</template>

<script setup>
import { ref, nextTick, onMounted } from 'vue';
import { aiChatApi } from '/@/api/business/cutting/ai-chat-api.js';

const STORAGE_KEY = 'xiao_cai_chat_history';

const messages = ref([]);
const inputText = ref('');
const loading = ref(false);
const messagesRef = ref(null);

// 从 localStorage 加载历史记录
onMounted(() => {
  try {
    const saved = localStorage.getItem(STORAGE_KEY);
    if (saved) {
      messages.value = JSON.parse(saved);
      nextTick(() => scrollToBottom());
    }
  } catch (e) {
    // 忽略解析错误
  }
});

// 保存历史记录到 localStorage
function saveHistory() {
  try {
    // 最多保存100条
    const toSave = messages.value.slice(-100);
    localStorage.setItem(STORAGE_KEY, JSON.stringify(toSave));
  } catch (e) {
    // 忽略存储错误
  }
}

// 清空历史记录
function clearHistory() {
  messages.value = [];
  localStorage.removeItem(STORAGE_KEY);
}

function formatTime() {
  const now = new Date();
  return `${now.getHours().toString().padStart(2, '0')}:${now.getMinutes().toString().padStart(2, '0')}`;
}

function formatContent(text) {
  if (!text) return '';
  return text
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/\*\*(.+?)\*\*/g, '<strong>$1</strong>')
    .replace(/\n/g, '<br/>');
}

function setExample(text) {
  inputText.value = text;
}

async function scrollToBottom() {
  await nextTick();
  if (messagesRef.value) {
    messagesRef.value.scrollTop = messagesRef.value.scrollHeight;
  }
}

async function sendMessage() {
  const text = inputText.value.trim();
  if (!text || loading.value) return;

  messages.value.push({ role: 'user', content: text, time: formatTime() });
  inputText.value = '';  // 立即清空输入框
  await nextTick();       // 确保 DOM 同步，防止残留
  inputText.value = '';  // 二次清空防止任何回填
  loading.value = true;
  await scrollToBottom();

  try {
    const res = await aiChatApi.chat(text);
    const answer = res?.data || res;
    if (answer) {
      messages.value.push({ role: 'ai', content: String(answer), time: formatTime() });
    } else {
      messages.value.push({ role: 'ai', content: '抱歉，AI未能生成有效回复，请重试。', time: formatTime() });
    }
  } catch (e) {
    const errMsg = e?.data?.msg || e?.message || '网络错误，请检查服务是否正常运行。';
    messages.value.push({ role: 'ai', content: errMsg, time: formatTime() });
  } finally {
    loading.value = false;
    saveHistory();  // 保存历史记录
    await scrollToBottom();
  }
}
</script>

<style lang="less" scoped>
.ai-chat-container {
  display: flex;
  flex-direction: column;
  height: calc(100vh - 120px);
  background: #f7f8fc;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 2px 12px rgba(0,0,0,0.08);
}

.chat-header {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 14px 20px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: #fff;

  .header-avatar {
    font-size: 28px;
    line-height: 1;
  }
  .header-info {
    flex: 1;
    display: flex;
    flex-direction: column;
    .header-title {
      font-size: 17px;
      font-weight: 700;
      line-height: 1.2;
    }
    .header-subtitle {
      font-size: 12px;
      opacity: 0.8;
    }
  }
  .clear-btn {
    border-color: rgba(255,255,255,0.6);
    color: #fff;
    font-size: 12px;
    &:hover {
      border-color: #fff;
      background: rgba(255,255,255,0.15);
    }
  }
}

.intro-card {
  background: linear-gradient(135deg, #f0f4ff 0%, #faf0ff 100%);
  border-bottom: 1px solid #e8ecf8;
  padding: 14px 20px;

  .intro-content {
    display: flex;
    gap: 12px;
    align-items: flex-start;

    .intro-icon {
      font-size: 28px;
      flex-shrink: 0;
      margin-top: 2px;
    }

    .intro-name {
      font-size: 15px;
      color: #333;
      margin-bottom: 4px;
      strong { color: #667eea; }
    }

    .intro-desc {
      font-size: 13px;
      color: #666;
      line-height: 1.5;
      margin-bottom: 8px;
    }

    .intro-examples {
      display: flex;
      flex-wrap: wrap;
      gap: 8px;
      a {
        font-size: 12px;
        color: #667eea;
        background: rgba(102,126,234,0.08);
        border: 1px solid rgba(102,126,234,0.2);
        padding: 3px 10px;
        border-radius: 12px;
        cursor: pointer;
        white-space: nowrap;
        &:hover {
          background: rgba(102,126,234,0.15);
        }
      }
    }
  }
}

.chat-messages {
  flex: 1;
  overflow-y: auto;
  padding: 16px 20px;
  display: flex;
  flex-direction: column;
  gap: 14px;
}

.message-item {
  display: flex;
  gap: 10px;
  align-items: flex-start;

  &.user-message {
    flex-direction: row-reverse;
    .message-avatar {
      background: #667eea;
    }
    .message-bubble {
      align-items: flex-end;
      .message-content {
        background: #667eea;
        color: #fff;
        border-radius: 18px 4px 18px 18px;
      }
    }
  }

  &.ai-message {
    .message-avatar {
      background: #fff;
      border: 2px solid #e0e4f0;
    }
    .message-bubble {
      align-items: flex-start;
      .message-content {
        background: #fff;
        color: #333;
        border-radius: 4px 18px 18px 18px;
        box-shadow: 0 1px 4px rgba(0,0,0,0.06);
      }
    }
  }
}

.message-avatar {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 18px;
  flex-shrink: 0;
}

.message-bubble {
  display: flex;
  flex-direction: column;
  max-width: 72%;

  .message-content {
    padding: 10px 14px;
    font-size: 14px;
    line-height: 1.65;
    word-break: break-word;
  }

  .message-time {
    font-size: 11px;
    color: #bbb;
    margin-top: 3px;
    padding: 0 4px;
  }
}

.loading-dots {
  display: flex;
  align-items: center;
  gap: 4px;
  padding: 14px 16px !important;

  span {
    width: 7px;
    height: 7px;
    border-radius: 50%;
    background: #667eea;
    animation: bounce 1.2s infinite;

    &:nth-child(2) { animation-delay: 0.2s; }
    &:nth-child(3) { animation-delay: 0.4s; }
  }
}

@keyframes bounce {
  0%, 60%, 100% { transform: translateY(0); opacity: 0.4; }
  30% { transform: translateY(-5px); opacity: 1; }
}

.chat-input-area {
  display: flex;
  gap: 10px;
  padding: 14px 20px 8px;
  background: #fff;
  border-top: 1px solid #eee;

  .send-btn {
    border-radius: 20px;
    height: auto;
    padding: 6px 20px;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    border: none;
    flex-shrink: 0;
    font-size: 14px;
  }
}

.input-hint {
  text-align: center;
  font-size: 11px;
  color: #bbb;
  padding: 4px 0 10px;
  background: #fff;
}
</style>
