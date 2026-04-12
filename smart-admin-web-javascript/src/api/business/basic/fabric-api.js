import { postRequest, getRequest } from '/@/lib/axios';

export const fabricApi = {
  query: (param) => postRequest('/basic/fabric/query', param),
  listAll: () => getRequest('/basic/fabric/listAll'),
  skuList: (fabricId) => getRequest(`/basic/fabric/skuList/${fabricId}`),
  addOrUpdate: (param) => postRequest('/basic/fabric/addOrUpdate', param),
  delete: (id) => getRequest(`/basic/fabric/delete/${id}`),
  updateDisabledFlag: (id, flag) => postRequest(`/basic/fabric/updateDisabledFlag?fabricId=${id}&disabledFlag=${flag}`),
};
