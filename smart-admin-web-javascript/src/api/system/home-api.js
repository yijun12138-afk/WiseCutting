import { getRequest } from '/@/lib/axios';

export const homeApi = {
  getStatistics: () => getRequest('/home/statistics'),
};
