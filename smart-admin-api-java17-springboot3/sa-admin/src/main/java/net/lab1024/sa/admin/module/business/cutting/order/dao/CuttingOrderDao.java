package net.lab1024.sa.admin.module.business.cutting.order.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import net.lab1024.sa.admin.module.business.cutting.order.domain.entity.CuttingOrderEntity;
import net.lab1024.sa.admin.module.business.cutting.order.domain.form.CuttingOrderQueryForm;
import net.lab1024.sa.admin.module.business.cutting.order.domain.vo.CuttingOrderVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import java.time.LocalDateTime;
import java.util.List;

@Mapper
public interface CuttingOrderDao extends BaseMapper<CuttingOrderEntity> {
    List<CuttingOrderVO> queryPage(Page<?> page, @Param("queryForm") CuttingOrderQueryForm queryForm);
    List<CuttingOrderVO> queryAll(@Param("queryForm") CuttingOrderQueryForm queryForm);

    @Select("SELECT COUNT(*) FROM t_cutting_order WHERE deleted_flag = 0 AND create_time BETWEEN #{start} AND #{end}")
    Long countByCreateTimeBetween(@Param("start") LocalDateTime start, @Param("end") LocalDateTime end);

    @Select("SELECT COUNT(*) FROM t_cutting_order WHERE deleted_flag = 0 AND status = 3 AND update_time BETWEEN #{start} AND #{end}")
    Long countCompleteByDay(@Param("start") LocalDateTime start, @Param("end") LocalDateTime end);

    @Select("SELECT COUNT(*) FROM t_cutting_order WHERE deleted_flag = 0 AND status = #{status} AND create_time BETWEEN #{start} AND #{end}")
    Long countByStatusAndDay(@Param("status") Integer status, @Param("start") LocalDateTime start, @Param("end") LocalDateTime end);
}
