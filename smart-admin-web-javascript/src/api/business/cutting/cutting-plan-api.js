import { postRequest, getRequest } from '/@/lib/axios';

export const cuttingPlanApi = {
  query: (data) => postRequest('/cutting/plan/query', data),
  addOrUpdate: (data) => postRequest('/cutting/plan/addOrUpdate', data),
  delete: (id) => getRequest(`/cutting/plan/delete/${id}`),
};
