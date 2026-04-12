import { postRequest, getRequest, postDownload } from '/@/lib/axios';

export const cuttingOrderApi = {
  query: (data) => postRequest('/cutting/order/query', data),
  addOrUpdate: (data) => postRequest('/cutting/order/addOrUpdate', data),
  delete: (id) => getRequest(`/cutting/order/delete/${id}`),
  export: (data) => postDownload('/cutting/order/export', data),
  updateStatus: (cuttingOrderId, status) => postRequest(`/cutting/order/updateStatus?cuttingOrderId=${cuttingOrderId}&status=${status}`),
  batchDelete: (ids) => postRequest('/cutting/order/batchDelete', ids),
  batchComplete: (ids) => postRequest('/cutting/order/batchComplete', ids),
};
