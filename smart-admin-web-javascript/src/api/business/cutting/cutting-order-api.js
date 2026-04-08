import { postRequest, getRequest } from '/@/lib/axios';

export const cuttingOrderApi = {
  query: (data) => postRequest('/cutting/order/query', data),
  addOrUpdate: (data) => postRequest('/cutting/order/addOrUpdate', data),
  delete: (id) => getRequest(`/cutting/order/delete/${id}`),
};
