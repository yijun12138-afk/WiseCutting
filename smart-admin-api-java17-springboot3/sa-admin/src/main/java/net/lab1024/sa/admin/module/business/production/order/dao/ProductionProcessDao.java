package net.lab1024.sa.admin.module.business.production.order.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import net.lab1024.sa.admin.module.business.production.order.domain.entity.ProductionProcessEntity;
import net.lab1024.sa.admin.module.business.production.order.domain.vo.OrderProcessVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface ProductionProcessDao extends BaseMapper<ProductionProcessEntity> {
    List<OrderProcessVO> queryByOrderId(@Param("orderId") Long orderId);
    void deleteByOrderId(@Param("orderId") Long orderId);
}
