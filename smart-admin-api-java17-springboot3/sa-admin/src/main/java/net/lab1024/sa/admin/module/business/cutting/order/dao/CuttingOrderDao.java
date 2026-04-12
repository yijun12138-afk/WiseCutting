package net.lab1024.sa.admin.module.business.cutting.order.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import net.lab1024.sa.admin.module.business.cutting.order.domain.entity.CuttingOrderEntity;
import net.lab1024.sa.admin.module.business.cutting.order.domain.form.CuttingOrderQueryForm;
import net.lab1024.sa.admin.module.business.cutting.order.domain.vo.CuttingOrderVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface CuttingOrderDao extends BaseMapper<CuttingOrderEntity> {
    List<CuttingOrderVO> queryPage(Page<?> page, @Param("queryForm") CuttingOrderQueryForm queryForm);
    List<CuttingOrderVO> queryAll(@Param("queryForm") CuttingOrderQueryForm queryForm);
}
