package net.lab1024.sa.admin.module.business.basic.cuttingpart.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import net.lab1024.sa.admin.module.business.basic.cuttingpart.domain.entity.CuttingPartEntity;
import net.lab1024.sa.admin.module.business.basic.cuttingpart.domain.form.CuttingPartQueryForm;
import net.lab1024.sa.admin.module.business.basic.cuttingpart.domain.vo.CuttingPartVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface CuttingPartDao extends BaseMapper<CuttingPartEntity> {
    List<CuttingPartVO> queryPage(Page<?> page, @Param("queryForm") CuttingPartQueryForm queryForm);
}
