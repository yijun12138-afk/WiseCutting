package net.lab1024.sa.admin.module.business.basic.sizegroup.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import net.lab1024.sa.admin.module.business.basic.sizegroup.domain.entity.SizeGroupEntity;
import net.lab1024.sa.admin.module.business.basic.sizegroup.domain.form.SizeGroupQueryForm;
import net.lab1024.sa.admin.module.business.basic.sizegroup.domain.vo.SizeGroupVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface SizeGroupDao extends BaseMapper<SizeGroupEntity> {
    List<SizeGroupVO> queryPage(Page<?> page, @Param("queryForm") SizeGroupQueryForm queryForm);
    List<SizeGroupVO> queryAll();
}
