package net.lab1024.sa.admin.module.business.production.order.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import net.lab1024.sa.admin.module.business.production.order.domain.entity.ProductionOrderEntity;
import net.lab1024.sa.admin.module.business.production.order.domain.form.ProductionOrderQueryForm;
import net.lab1024.sa.admin.module.business.production.order.domain.vo.ProductionOrderVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import java.time.LocalDateTime;
import java.util.List;

@Mapper
public interface ProductionOrderDao extends BaseMapper<ProductionOrderEntity> {
    List<ProductionOrderVO> queryPage(Page<?> page, @Param("queryForm") ProductionOrderQueryForm queryForm);

    @Select("SELECT COUNT(*) FROM t_production_order WHERE deleted_flag = 0 AND status = 3 AND create_time BETWEEN #{start} AND #{end}")
    Long countCompleteByCreateTimeBetween(@Param("start") LocalDateTime start, @Param("end") LocalDateTime end);

    @Select("SELECT COUNT(*) FROM t_production_order WHERE deleted_flag = 0 AND status = #{status}")
    Long countByStatus(@Param("status") Integer status);
}
