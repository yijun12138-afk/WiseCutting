import { postRequest, getRequest } from '/@/lib/axios';

export const fabricRelaxApi = {
  query: (param) => postRequest('/production/relax/query', param),
  addOrUpdate: (param) => postRequest('/production/relax/addOrUpdate', param),
  delete: (id) => getRequest(`/production/relax/delete/${id}`),
  batchDelete: (ids) => postRequest('/production/relax/batchDelete', ids),
  updateStatus: (relaxId, status) => postRequest(`/production/relax/updateStatus?relaxId=${relaxId}&status=${status}`),
};
