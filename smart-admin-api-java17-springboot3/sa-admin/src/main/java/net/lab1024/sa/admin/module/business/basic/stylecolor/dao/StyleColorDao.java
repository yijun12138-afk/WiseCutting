package net.lab1024.sa.admin.module.business.basic.stylecolor.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import net.lab1024.sa.admin.module.business.basic.stylecolor.domain.entity.StyleColorEntity;
import net.lab1024.sa.admin.module.business.basic.stylecolor.domain.form.StyleColorQueryForm;
import net.lab1024.sa.admin.module.business.basic.stylecolor.domain.vo.StyleColorVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface StyleColorDao extends BaseMapper<StyleColorEntity> {
    List<StyleColorVO> queryPage(Page<?> page, @Param("queryForm") StyleColorQueryForm queryForm);
    List<StyleColorVO> queryAll();
}
