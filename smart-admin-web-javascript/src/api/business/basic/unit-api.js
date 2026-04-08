import { postRequest, getRequest } from '/@/lib/axios';

export const unitApi = {
  query: (param) => postRequest('/basic/unit/query', param),
  listAll: () => getRequest('/basic/unit/listAll'),
  addOrUpdate: (param) => postRequest('/basic/unit/addOrUpdate', param),
  delete: (id) => getRequest(`/basic/unit/delete/${id}`),
};
