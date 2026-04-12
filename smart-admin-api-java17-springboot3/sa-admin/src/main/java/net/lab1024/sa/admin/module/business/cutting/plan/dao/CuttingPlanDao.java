package net.lab1024.sa.admin.module.business.cutting.plan.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import net.lab1024.sa.admin.module.business.cutting.plan.domain.entity.CuttingPlanEntity;
import net.lab1024.sa.admin.module.business.cutting.plan.domain.form.CuttingPlanQueryForm;
import net.lab1024.sa.admin.module.business.cutting.plan.domain.vo.CuttingPlanVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import java.time.LocalDateTime;
import java.util.List;

@Mapper
public interface CuttingPlanDao extends BaseMapper<CuttingPlanEntity> {
    List<CuttingPlanVO> queryPage(Page<?> page, @Param("queryForm") CuttingPlanQueryForm queryForm);

    @Select("SELECT COUNT(*) FROM t_cutting_plan WHERE deleted_flag = 0 AND create_time BETWEEN #{start} AND #{end}")
    Long countByCreateTimeBetween(@Param("start") LocalDateTime start, @Param("end") LocalDateTime end);
}
