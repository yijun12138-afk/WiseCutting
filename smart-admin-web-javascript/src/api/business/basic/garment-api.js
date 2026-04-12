import { postRequest, getRequest } from '/@/lib/axios';

export const garmentApi = {
  query: (param) => postRequest('/basic/garment/query', param),
  listAll: () => getRequest('/basic/garment/listAll'),
  addOrUpdate: (param) => postRequest('/basic/garment/addOrUpdate', param),
  delete: (id) => getRequest(`/basic/garment/delete/${id}`),
  updateDisabledFlag: (id, flag) => postRequest(`/basic/garment/updateDisabledFlag?garmentId=${id}&disabledFlag=${flag}`),
};
