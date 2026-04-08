package net.lab1024.sa.admin.module.business.basic.unit.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import net.lab1024.sa.admin.module.business.basic.unit.domain.entity.UnitEntity;
import net.lab1024.sa.admin.module.business.basic.unit.domain.form.UnitQueryForm;
import net.lab1024.sa.admin.module.business.basic.unit.domain.vo.UnitVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface UnitDao extends BaseMapper<UnitEntity> {
    List<UnitVO> queryPage(Page<?> page, @Param("queryForm") UnitQueryForm queryForm);
    List<UnitVO> queryAll();
}
