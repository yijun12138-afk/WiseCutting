package net.lab1024.sa.admin.module.business.cutting.order.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import jakarta.annotation.Resource;
import net.lab1024.sa.admin.module.business.cutting.order.dao.CuttingOrderDao;
import net.lab1024.sa.admin.module.business.cutting.order.domain.entity.CuttingOrderEntity;
import net.lab1024.sa.admin.module.business.cutting.order.domain.form.CuttingOrderAddForm;
import net.lab1024.sa.admin.module.business.cutting.order.domain.form.CuttingOrderQueryForm;
import net.lab1024.sa.admin.module.business.cutting.order.domain.vo.CuttingOrderVO;
import net.lab1024.sa.base.common.domain.PageResult;
import net.lab1024.sa.base.common.domain.ResponseDTO;
import net.lab1024.sa.base.common.util.SmartBeanUtil;
import net.lab1024.sa.base.common.util.SmartPageUtil;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Service
public class CuttingOrderService {

    @Resource
    private CuttingOrderDao cuttingOrderDao;

    public ResponseDTO<PageResult<CuttingOrderVO>> query(CuttingOrderQueryForm queryForm) {
        queryForm.setDeletedFlag(false);
        Page<?> page = SmartPageUtil.convert2PageQuery(queryForm);
        List<CuttingOrderVO> list = cuttingOrderDao.queryPage(page, queryForm);
        list.forEach(o -> o.setStatusName(getStatusName(o.getStatus())));
        return ResponseDTO.ok(SmartPageUtil.convert2PageResult(page, list));
    }

    @Transactional(rollbackFor = Exception.class)
    public ResponseDTO<String> addOrUpdate(CuttingOrderAddForm form) {
        CuttingOrderEntity entity = SmartBeanUtil.copy(form, CuttingOrderEntity.class);
        if (form.getCuttingOrderId() == null) {
            String dateStr = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
            long count = cuttingOrderDao.selectCount(null) + 1;
            entity.setCuttingOrderNo("CO" + dateStr + String.format("%04d", count));
            entity.setStatus(1);
            entity.setDeletedFlag(Boolean.FALSE);
            cuttingOrderDao.insert(entity);
        } else {
            cuttingOrderDao.updateById(entity);
        }
        return ResponseDTO.ok();
    }

    @Transactional(rollbackFor = Exception.class)
    public ResponseDTO<String> delete(Long cuttingOrderId) {
        CuttingOrderEntity entity = cuttingOrderDao.selectById(cuttingOrderId);
        if (entity == null) return ResponseDTO.userErrorParam("裁床单不存在");
        entity.setDeletedFlag(Boolean.TRUE);
        cuttingOrderDao.updateById(entity);
        return ResponseDTO.ok();
    }

    private String getStatusName(Integer status) {
        if (status == null) return "";
        return switch (status) {
            case 1 -> "待裁";
            case 2 -> "裁剪中";
            case 3 -> "完成";
            default -> "";
        };
    }
}
