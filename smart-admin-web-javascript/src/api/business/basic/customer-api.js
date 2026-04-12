import { postRequest, getRequest } from '/@/lib/axios';

export const customerApi = {
  query: (param) => postRequest('/basic/customer/query', param),
  listAll: () => getRequest('/basic/customer/listAll'),
  addOrUpdate: (param) => postRequest('/basic/customer/addOrUpdate', param),
  delete: (id) => getRequest(`/basic/customer/delete/${id}`),
  updateDisabledFlag: (id, flag) => postRequest(`/basic/customer/updateDisabledFlag?customerId=${id}&disabledFlag=${flag}`),
};
