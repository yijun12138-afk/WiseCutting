package net.lab1024.sa.admin.module.business.basic.fabric.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import net.lab1024.sa.admin.module.business.basic.fabric.domain.entity.FabricEntity;
import net.lab1024.sa.admin.module.business.basic.fabric.domain.form.FabricQueryForm;
import net.lab1024.sa.admin.module.business.basic.fabric.domain.vo.FabricVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface FabricDao extends BaseMapper<FabricEntity> {
    List<FabricVO> queryPage(Page<?> page, @Param("queryForm") FabricQueryForm queryForm);
    List<FabricVO> queryAll();
}
