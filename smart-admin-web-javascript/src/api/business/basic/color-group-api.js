import { postRequest, getRequest } from '/@/lib/axios';

export const colorGroupApi = {
  query: (param) => postRequest('/basic/colorGroup/query', param),
  listAll: () => getRequest('/basic/colorGroup/listAll'),
  addOrUpdate: (param) => postRequest('/basic/colorGroup/addOrUpdate', param),
  delete: (id) => getRequest(`/basic/colorGroup/delete/${id}`),
};
