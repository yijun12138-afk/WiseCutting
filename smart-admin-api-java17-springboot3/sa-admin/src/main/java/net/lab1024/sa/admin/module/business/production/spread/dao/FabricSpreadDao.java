package net.lab1024.sa.admin.module.business.production.spread.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import net.lab1024.sa.admin.module.business.production.spread.domain.entity.FabricSpreadEntity;
import net.lab1024.sa.admin.module.business.production.spread.domain.form.FabricSpreadQueryForm;
import net.lab1024.sa.admin.module.business.production.spread.domain.vo.FabricSpreadVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface FabricSpreadDao extends BaseMapper<FabricSpreadEntity> {
    List<FabricSpreadVO> queryPage(Page<?> page, @Param("queryForm") FabricSpreadQueryForm queryForm);
    List<FabricSpreadVO> queryIssuedList(@Param("queryForm") FabricSpreadQueryForm queryForm);
}
