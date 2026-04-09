<!--
  * 首页 用户头部信息（优化版）
  *
  * @Author:    裁匠实验室
  * @Date:      2024-04-09
  *
-->
<template>
  <div class="home-banner">
    <!-- 左侧：用户信息 -->
    <div class="banner-left">
      <div class="avatar-wrap">
        <a-avatar :size="64" style="background: linear-gradient(135deg,#667eea,#764ba2); font-size:28px">
          {{ userName ? userName.charAt(0) : 'U' }}
        </a-avatar>
        <div class="online-dot"></div>
      </div>
      <div class="user-info">
        <div class="welcome-line">
          <span class="greeting">{{ welcomeSentence }}</span>
          <span class="wave">👋</span>
        </div>
        <div class="sub-info">
          <a-tag color="purple" class="dept-tag">
            <apartment-outlined />
            {{ departmentName }}
          </a-tag>
          <a-tag color="blue" class="date-tag">
            <calendar-outlined />
            {{ shortDate }}
          </a-tag>
        </div>
        <div class="last-login">
          <alert-outlined style="color:#faad14; margin-right:4px" />
          <span>{{ lastLoginInfo }}</span>
        </div>
      </div>
    </div>

    <!-- 中部：格言 -->
    <div class="banner-center">
      <div class="quote-box">
        <div class="quote-icon">"</div>
        <div class="quote-text">{{ heartSentence }}</div>
      </div>
      <div class="day-full-info">
        <CalendarOutlined style="margin-right:6px;color:#1890ff" />
        {{ dayInfo }}
      </div>
    </div>

    <!-- 右侧：天气 -->
    <div class="banner-right">
      <iframe
        width="320"
        scrolling="no"
        height="52"
        frameborder="0"
        allowtransparency="true"
        src="//i.tianqi.com/index.php?c=code&id=12&icon=1&num=3&site=12"
      ></iframe>
    </div>
  </div>
</template>

<script setup>
  import { computed } from 'vue';
  import { useUserStore } from '/@/store/modules/system/user';
  import uaparser from 'ua-parser-js';
  import { Solar, Lunar } from 'lunar-javascript';
  import _ from 'lodash';
  import heartSentenceArray from './heart-sentence';

  const userStore = useUserStore();

  const departmentName = computed(() => userStore.departmentName);
  const userName = computed(() => userStore.$state.actualName);

  // 欢迎语
  const welcomeSentence = computed(() => {
    let sentence = '';
    let now = new Date().getHours();
    if (now > 0 && now <= 6) {
      sentence = '深夜还在奋战，';
    } else if (now > 6 && now <= 11) {
      sentence = '早上好，';
    } else if (now > 11 && now <= 14) {
      sentence = '中午好，';
    } else if (now > 14 && now <= 18) {
      sentence = '下午好，';
    } else {
      sentence = '晚上好，';
    }
    return sentence + userStore.$state.actualName + ' ！';
  });

  //上次登录信息
  const lastLoginInfo = computed(() => {
    let info = '';
    if (userStore.$state.lastLoginTime) {
      info = info + '上次登录：' + userStore.$state.lastLoginTime;
    }
    if (userStore.$state.lastLoginUserAgent) {
      let ua = uaparser(userStore.$state.lastLoginUserAgent);
      info = info + '  |  设备：';
      if (ua.browser.name) info = info + ua.browser.name;
      if (ua.os.name) info = info + ' ' + ua.os.name;
    }
    if (userStore.$state.lastLoginIpRegion) {
      info = info + '  |  ' + userStore.$state.lastLoginIpRegion;
    }
    if (userStore.$state.lastLoginIp) {
      info = info + '  (' + userStore.$state.lastLoginIp + ')';
    }
    return info;
  });

  // 简短日期
  const shortDate = computed(() => {
    let solar = Solar.fromDate(new Date());
    let week = solar.getWeekInChinese();
    return `${solar.getMonth()}月${solar.getDay()}日  星期${week}`;
  });

  //日期、节日、节气
  const dayInfo = computed(() => {
    let solar = Solar.fromDate(new Date());
    let day = solar.toString();
    let week = solar.getWeekInChinese();
    let lunar = Lunar.fromDate(new Date());
    let lunarMonth = lunar.getMonthInChinese();
    let lunarDay = lunar.getDayInChinese();
    let jieqi = lunar.getJieQi();
    let next = lunar.getNextJieQi();
    let nextJieqi = next.getName() + ' ' + next.getSolar().toYmd();
    return `${day} 星期${week}，农历${lunarMonth}月${lunarDay}（${jieqi ? '当前节气：' + jieqi + '，' : ''}下个节气：${nextJieqi}）`;
  });

  // 毒鸡汤
  const heartSentence = computed(() => {
    return heartSentenceArray[_.random(0, heartSentenceArray.length - 1)];
  });
</script>

<style scoped lang="less">
  .home-banner {
    width: 100%;
    background: linear-gradient(135deg, #1a1a2e 0%, #16213e 40%, #0f3460 70%, #533483 100%);
    border-radius: 12px;
    padding: 24px 32px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 24px;
    margin-bottom: 16px;
    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.25);
    position: relative;
    overflow: hidden;

    // 背景装饰
    &::before {
      content: '';
      position: absolute;
      top: -60px;
      right: -60px;
      width: 200px;
      height: 200px;
      border-radius: 50%;
      background: rgba(255, 255, 255, 0.04);
    }
    &::after {
      content: '';
      position: absolute;
      bottom: -80px;
      left: 200px;
      width: 280px;
      height: 280px;
      border-radius: 50%;
      background: rgba(255, 255, 255, 0.03);
    }
  }

  .banner-left {
    display: flex;
    align-items: center;
    gap: 18px;
    flex-shrink: 0;

    .avatar-wrap {
      position: relative;

      .online-dot {
        position: absolute;
        bottom: 2px;
        right: 2px;
        width: 14px;
        height: 14px;
        background: #52c41a;
        border-radius: 50%;
        border: 2px solid #16213e;
        animation: pulse 2s infinite;
      }
    }

    .user-info {
      .welcome-line {
        font-size: 22px;
        font-weight: 700;
        color: #fff;
        display: flex;
        align-items: center;
        gap: 6px;
        margin-bottom: 8px;

        .greeting { letter-spacing: 1px; }
        .wave { font-size: 20px; }
      }

      .sub-info {
        display: flex;
        gap: 8px;
        margin-bottom: 8px;

        .dept-tag, .date-tag {
          border-radius: 20px;
          padding: 2px 10px;
          font-size: 12px;
          display: flex;
          align-items: center;
          gap: 4px;
        }
      }

      .last-login {
        font-size: 12px;
        color: rgba(255, 255, 255, 0.55);
        display: flex;
        align-items: center;
      }
    }
  }

  .banner-center {
    flex: 1;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 12px;

    .quote-box {
      background: rgba(255, 255, 255, 0.08);
      border-radius: 12px;
      padding: 12px 20px;
      border: 1px solid rgba(255, 255, 255, 0.12);
      max-width: 380px;
      width: 100%;
      position: relative;

      .quote-icon {
        position: absolute;
        top: -8px;
        left: 14px;
        font-size: 36px;
        color: rgba(255, 255, 255, 0.3);
        font-family: Georgia, serif;
        line-height: 1;
      }

      .quote-text {
        color: rgba(255, 255, 255, 0.85);
        font-size: 13px;
        text-align: center;
        line-height: 1.6;
        padding-top: 4px;
      }
    }

    .day-full-info {
      font-size: 12px;
      color: rgba(255, 255, 255, 0.5);
      text-align: center;
    }
  }

  .banner-right {
    flex-shrink: 0;
    display: flex;
    align-items: center;

    iframe {
      border-radius: 8px;
      filter: brightness(0.9);
    }
  }

  @keyframes pulse {
    0% { box-shadow: 0 0 0 0 rgba(82, 196, 26, 0.5); }
    70% { box-shadow: 0 0 0 8px rgba(82, 196, 26, 0); }
    100% { box-shadow: 0 0 0 0 rgba(82, 196, 26, 0); }
  }
</style>
