package net.lab1024.sa.admin.module.business.basic.size.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import net.lab1024.sa.admin.module.business.basic.size.domain.entity.SizeEntity;
import net.lab1024.sa.admin.module.business.basic.size.domain.form.SizeQueryForm;
import net.lab1024.sa.admin.module.business.basic.size.domain.vo.SizeVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface SizeDao extends BaseMapper<SizeEntity> {
    List<SizeVO> queryPage(Page<?> page, @Param("queryForm") SizeQueryForm queryForm);
    List<SizeVO> queryAll();
}
