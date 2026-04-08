import { postRequest, getRequest } from '/@/lib/axios';

export const garmentApi = {
  query: (param) => postRequest('/basic/garment/query', param),
  addOrUpdate: (param) => postRequest('/basic/garment/addOrUpdate', param),
  delete: (id) => getRequest(`/basic/garment/delete/${id}`),
};
