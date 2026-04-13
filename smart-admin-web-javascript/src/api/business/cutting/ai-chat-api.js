import { request } from '/@/lib/axios';

export const aiChatApi = {
  chat: (message) => request({
    url: '/ai/chat',
    method: 'post',
    data: { message },
    headers: { 'Content-Type': 'application/json' },
  }),
};
