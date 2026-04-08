package net.lab1024.sa.admin.module.business.production.order.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import net.lab1024.sa.admin.module.business.production.order.domain.entity.ProductionOrderEntity;
import net.lab1024.sa.admin.module.business.production.order.domain.form.ProductionOrderQueryForm;
import net.lab1024.sa.admin.module.business.production.order.domain.vo.ProductionOrderVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface ProductionOrderDao extends BaseMapper<ProductionOrderEntity> {
    List<ProductionOrderVO> queryPage(Page<?> page, @Param("queryForm") ProductionOrderQueryForm queryForm);
}
