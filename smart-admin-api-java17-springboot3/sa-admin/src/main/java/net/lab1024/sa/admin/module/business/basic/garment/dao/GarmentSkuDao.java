package net.lab1024.sa.admin.module.business.basic.garment.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import net.lab1024.sa.admin.module.business.basic.garment.domain.entity.GarmentSkuEntity;
import net.lab1024.sa.admin.module.business.basic.garment.domain.vo.GarmentSkuVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface GarmentSkuDao extends BaseMapper<GarmentSkuEntity> {
    List<GarmentSkuVO> queryByGarmentId(@Param("garmentId") Long garmentId);
    List<GarmentSkuVO> queryByGarmentIds(@Param("garmentIds") List<Long> garmentIds);
    void deleteByGarmentId(@Param("garmentId") Long garmentId);
}
