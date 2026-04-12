import { postRequest, getRequest } from '/@/lib/axios';

export const productionOrderApi = {
  query: (param) => postRequest('/production/order/query', param),
  detail: (orderId) => getRequest(`/production/order/detail/${orderId}`),
  addOrUpdate: (param) => postRequest('/production/order/addOrUpdate', param),
  issue: (orderId) => getRequest(`/production/order/issue/${orderId}`),
  unissue: (orderId) => getRequest(`/production/order/unissue/${orderId}`),
  complete: (orderId) => getRequest(`/production/order/complete/${orderId}`),
  delete: (orderId) => getRequest(`/production/order/delete/${orderId}`),
  batchDelete: (ids) => postRequest('/production/order/batchDelete', ids),
  batchComplete: (ids) => postRequest('/production/order/batchComplete', ids),
};
