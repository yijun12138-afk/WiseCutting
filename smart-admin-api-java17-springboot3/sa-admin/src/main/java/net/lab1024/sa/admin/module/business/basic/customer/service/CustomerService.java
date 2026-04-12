package net.lab1024.sa.admin.module.business.basic.customer.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import jakarta.annotation.Resource;
import net.lab1024.sa.admin.module.business.basic.customer.dao.CustomerDao;
import net.lab1024.sa.admin.module.business.basic.customer.domain.entity.CustomerEntity;
import net.lab1024.sa.admin.module.business.basic.customer.domain.form.CustomerAddForm;
import net.lab1024.sa.admin.module.business.basic.customer.domain.form.CustomerQueryForm;
import net.lab1024.sa.admin.module.business.basic.customer.domain.vo.CustomerVO;
import net.lab1024.sa.base.common.domain.PageResult;
import net.lab1024.sa.base.common.domain.ResponseDTO;
import net.lab1024.sa.base.common.util.SmartBeanUtil;
import net.lab1024.sa.base.common.util.SmartPageUtil;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class CustomerService {

    @Resource
    private CustomerDao customerDao;

    public ResponseDTO<PageResult<CustomerVO>> query(CustomerQueryForm queryForm) {
        queryForm.setDeletedFlag(false);
        Page<?> page = SmartPageUtil.convert2PageQuery(queryForm);
        List<CustomerVO> list = customerDao.queryPage(page, queryForm);
        return ResponseDTO.ok(SmartPageUtil.convert2PageResult(page, list));
    }

    public ResponseDTO<List<CustomerVO>> queryAll() {
        CustomerQueryForm queryForm = new CustomerQueryForm();
        queryForm.setDeletedFlag(false);
        List<CustomerVO> list = customerDao.queryAll(queryForm);
        return ResponseDTO.ok(list);
    }

    @Transactional(rollbackFor = Exception.class)
    public ResponseDTO<String> addOrUpdate(CustomerAddForm form) {
        CustomerEntity entity = SmartBeanUtil.copy(form, CustomerEntity.class);
        if (form.getCustomerId() == null) {
            if (entity.getDisabledFlag() == null) {
                entity.setDisabledFlag(Boolean.FALSE);
            }
            entity.setDeletedFlag(Boolean.FALSE);
            customerDao.insert(entity);
        } else {
            customerDao.updateById(entity);
        }
        return ResponseDTO.ok();
    }

    @Transactional(rollbackFor = Exception.class)
    public ResponseDTO<String> updateDisabledFlag(Long customerId, Boolean disabledFlag) {
        CustomerEntity entity = customerDao.selectById(customerId);
        if (entity == null) return ResponseDTO.userErrorParam("客户不存在");
        entity.setDisabledFlag(disabledFlag);
        customerDao.updateById(entity);
        return ResponseDTO.ok();
    }

    @Transactional(rollbackFor = Exception.class)
    public ResponseDTO<String> delete(Long customerId) {
        CustomerEntity entity = customerDao.selectById(customerId);
        if (entity == null) {
            return ResponseDTO.userErrorParam("客户不存在");
        }
        entity.setDeletedFlag(Boolean.TRUE);
        customerDao.updateById(entity);
        return ResponseDTO.ok();
    }
}
