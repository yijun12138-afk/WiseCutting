package net.lab1024.sa.admin.module.business.cutting.plan.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import net.lab1024.sa.admin.module.business.cutting.plan.domain.entity.CuttingPlanEntity;
import net.lab1024.sa.admin.module.business.cutting.plan.domain.form.CuttingPlanQueryForm;
import net.lab1024.sa.admin.module.business.cutting.plan.domain.vo.CuttingPlanVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface CuttingPlanDao extends BaseMapper<CuttingPlanEntity> {
    List<CuttingPlanVO> queryPage(Page<?> page, @Param("queryForm") CuttingPlanQueryForm queryForm);
}
