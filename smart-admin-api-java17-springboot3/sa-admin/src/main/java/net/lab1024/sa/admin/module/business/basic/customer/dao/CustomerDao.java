package net.lab1024.sa.admin.module.business.basic.customer.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import net.lab1024.sa.admin.module.business.basic.customer.domain.entity.CustomerEntity;
import net.lab1024.sa.admin.module.business.basic.customer.domain.form.CustomerQueryForm;
import net.lab1024.sa.admin.module.business.basic.customer.domain.vo.CustomerVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

/**
 * 客户管理 Dao
 */
@Mapper
public interface CustomerDao extends BaseMapper<CustomerEntity> {

    List<CustomerVO> queryPage(Page<?> page, @Param("queryForm") CustomerQueryForm queryForm);

    List<CustomerVO> queryAll(@Param("queryForm") CustomerQueryForm queryForm);
}
