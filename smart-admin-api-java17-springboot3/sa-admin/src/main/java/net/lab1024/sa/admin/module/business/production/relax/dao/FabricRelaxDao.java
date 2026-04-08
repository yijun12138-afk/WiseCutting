package net.lab1024.sa.admin.module.business.production.relax.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import net.lab1024.sa.admin.module.business.production.relax.domain.entity.FabricRelaxEntity;
import net.lab1024.sa.admin.module.business.production.relax.domain.form.FabricRelaxQueryForm;
import net.lab1024.sa.admin.module.business.production.relax.domain.vo.FabricRelaxVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface FabricRelaxDao extends BaseMapper<FabricRelaxEntity> {
    List<FabricRelaxVO> queryPage(Page<?> page, @Param("queryForm") FabricRelaxQueryForm queryForm);
}
