import { postRequest, getRequest } from '/@/lib/axios';

export const fabricRelaxApi = {
  query: (param) => postRequest('/production/relax/query', param),
  addOrUpdate: (param) => postRequest('/production/relax/addOrUpdate', param),
  delete: (id) => getRequest(`/production/relax/delete/${id}`),
};
