import { postRequest, getRequest } from '/@/lib/axios';

export const cuttingPartApi = {
  query: (param) => postRequest('/basic/cuttingPart/query', param),
  addOrUpdate: (param) => postRequest('/basic/cuttingPart/addOrUpdate', param),
  delete: (id) => getRequest(`/basic/cuttingPart/delete/${id}`),
};
