import { postRequest, getRequest } from '/@/lib/axios';

export const fabricSpreadApi = {
  query: (param) => postRequest('/production/spread/query', param),
  workbench: (param) => postRequest('/production/spread/workbench', param),
  save: (param) => postRequest('/production/spread/save', param),
  saveAndIssue: (param) => postRequest('/production/spread/saveAndIssue', param),
  complete: (param) => postRequest('/production/spread/complete', param),
  delete: (id) => getRequest(`/production/spread/delete/${id}`),
  batchDelete: (ids) => postRequest('/production/spread/batchDelete', ids),
  unissue: (id) => getRequest(`/production/spread/unissue/${id}`),
  batchComplete: (ids) => postRequest('/production/spread/batchComplete', ids),
};
