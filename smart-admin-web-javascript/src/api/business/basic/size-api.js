import { postRequest, getRequest } from '/@/lib/axios';

export const sizeApi = {
  query: (param) => postRequest('/basic/size/query', param),
  listAll: () => getRequest('/basic/size/listAll'),
  addOrUpdate: (param) => postRequest('/basic/size/addOrUpdate', param),
  delete: (id) => getRequest(`/basic/size/delete/${id}`),
};
