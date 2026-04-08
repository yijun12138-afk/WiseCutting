import { postRequest, getRequest } from '/@/lib/axios';

export const styleColorApi = {
  query: (param) => postRequest('/basic/styleColor/query', param),
  listAll: () => getRequest('/basic/styleColor/listAll'),
  addOrUpdate: (param) => postRequest('/basic/styleColor/addOrUpdate', param),
  delete: (id) => getRequest(`/basic/styleColor/delete/${id}`),
};
