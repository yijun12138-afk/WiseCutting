package net.lab1024.sa.admin.module.business.basic.garment.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import net.lab1024.sa.admin.module.business.basic.garment.domain.entity.GarmentEntity;
import net.lab1024.sa.admin.module.business.basic.garment.domain.form.GarmentQueryForm;
import net.lab1024.sa.admin.module.business.basic.garment.domain.vo.GarmentVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface GarmentDao extends BaseMapper<GarmentEntity> {
    List<GarmentVO> queryPage(Page<?> page, @Param("queryForm") GarmentQueryForm queryForm);
    List<GarmentVO> queryAll();
}
