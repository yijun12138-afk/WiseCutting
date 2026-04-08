package net.lab1024.sa.admin.module.business.production.order.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import net.lab1024.sa.admin.module.business.production.order.domain.entity.ProductionOrderDetailEntity;
import net.lab1024.sa.admin.module.business.production.order.domain.vo.OrderDetailVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface ProductionOrderDetailDao extends BaseMapper<ProductionOrderDetailEntity> {
    List<OrderDetailVO> queryByOrderId(@Param("orderId") Long orderId);
    void deleteByOrderId(@Param("orderId") Long orderId);
}
