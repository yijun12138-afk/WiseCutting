import { postRequest, getRequest } from '/@/lib/axios';

export const fabricApi = {
  query: (param) => postRequest('/basic/fabric/query', param),
  listAll: () => getRequest('/basic/fabric/listAll'),
  addOrUpdate: (param) => postRequest('/basic/fabric/addOrUpdate', param),
  delete: (id) => getRequest(`/basic/fabric/delete/${id}`),
};
