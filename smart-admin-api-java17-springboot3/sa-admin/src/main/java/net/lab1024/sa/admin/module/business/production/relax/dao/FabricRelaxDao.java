package net.lab1024.sa.admin.module.business.production.relax.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import net.lab1024.sa.admin.module.business.production.relax.domain.entity.FabricRelaxEntity;
import net.lab1024.sa.admin.module.business.production.relax.domain.form.FabricRelaxQueryForm;
import net.lab1024.sa.admin.module.business.production.relax.domain.vo.FabricRelaxVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import java.time.LocalDateTime;
import java.util.List;

@Mapper
public interface FabricRelaxDao extends BaseMapper<FabricRelaxEntity> {
    List<FabricRelaxVO> queryPage(Page<?> page, @Param("queryForm") FabricRelaxQueryForm queryForm);

    @Select("SELECT COUNT(*) FROM t_fabric_relax WHERE deleted_flag = 0 AND status = 2 AND update_time BETWEEN #{start} AND #{end}")
    Long countCompleteByDay(@Param("start") LocalDateTime start, @Param("end") LocalDateTime end);
}
