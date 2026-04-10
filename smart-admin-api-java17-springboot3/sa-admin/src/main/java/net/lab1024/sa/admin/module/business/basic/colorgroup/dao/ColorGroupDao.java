package net.lab1024.sa.admin.module.business.basic.colorgroup.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import net.lab1024.sa.admin.module.business.basic.colorgroup.domain.entity.ColorGroupEntity;
import net.lab1024.sa.admin.module.business.basic.colorgroup.domain.form.ColorGroupQueryForm;
import net.lab1024.sa.admin.module.business.basic.colorgroup.domain.vo.ColorGroupVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ColorGroupDao extends BaseMapper<ColorGroupEntity> {
    List<ColorGroupVO> queryPage(Page<?> page, @Param("queryForm") ColorGroupQueryForm queryForm);
    List<ColorGroupVO> queryAll();
}
