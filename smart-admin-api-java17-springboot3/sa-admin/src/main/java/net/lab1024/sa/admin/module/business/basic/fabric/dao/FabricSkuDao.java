package net.lab1024.sa.admin.module.business.basic.fabric.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import net.lab1024.sa.admin.module.business.basic.fabric.domain.entity.FabricSkuEntity;
import net.lab1024.sa.admin.module.business.basic.fabric.domain.vo.FabricSkuVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface FabricSkuDao extends BaseMapper<FabricSkuEntity> {
    List<FabricSkuVO> queryByFabricId(@Param("fabricId") Long fabricId);
    List<FabricSkuVO> queryByFabricIds(@Param("fabricIds") List<Long> fabricIds);
    void deleteByFabricId(@Param("fabricId") Long fabricId);
}
