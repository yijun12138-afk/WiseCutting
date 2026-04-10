import { postRequest, getRequest } from '/@/lib/axios';

export const sizeGroupApi = {
  query: (param) => postRequest('/basic/sizeGroup/query', param),
  listAll: () => getRequest('/basic/sizeGroup/listAll'),
  addOrUpdate: (param) => postRequest('/basic/sizeGroup/addOrUpdate', param),
  delete: (id) => getRequest(`/basic/sizeGroup/delete/${id}`),
};
