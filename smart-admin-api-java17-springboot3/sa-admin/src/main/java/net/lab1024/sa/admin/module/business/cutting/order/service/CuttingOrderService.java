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
import net.lab1024.sa.admin.module.business.cutting.order.domain.vo.CuttingOrderExcelVO;
import net.lab1024.sa.base.common.util.SmartExcelUtil;
import net.lab1024.sa.base.common.util.SmartRequestUtil;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
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
            entity.setStatus(form.getStatus() != null ? form.getStatus() : 1);
            entity.setDeletedFlag(Boolean.FALSE);
            if (SmartRequestUtil.getRequestUser() != null) {
                entity.setCreateUserName(SmartRequestUtil.getRequestUser().getUserName());
            }
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

    public void export(CuttingOrderQueryForm queryForm, HttpServletResponse response) throws IOException {
        queryForm.setDeletedFlag(false);
        List<CuttingOrderVO> list = cuttingOrderDao.queryAll(queryForm);
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        List<CuttingOrderExcelVO> excelList = list.stream().map(o -> {
            CuttingOrderExcelVO excel = SmartBeanUtil.copy(o, CuttingOrderExcelVO.class);
            excel.setStatusName(getStatusName(o.getStatus()));
            excel.setCreateTime(o.getCreateTime() != null ? o.getCreateTime().format(formatter) : "");
            return excel;
        }).toList();
        SmartExcelUtil.exportExcel(response, "裁床单列表.xlsx", "裁床单", CuttingOrderExcelVO.class, excelList);
    }

    @Transactional(rollbackFor = Exception.class)
    public ResponseDTO<String> updateStatus(Long cuttingOrderId, Integer status) {
        CuttingOrderEntity entity = cuttingOrderDao.selectById(cuttingOrderId);
        if (entity == null) return ResponseDTO.userErrorParam("裁床单不存在");
        entity.setStatus(status);
        cuttingOrderDao.updateById(entity);
        return ResponseDTO.ok();
    }

    @Transactional(rollbackFor = Exception.class)
    public ResponseDTO<String> batchDelete(List<Long> ids) {
        if (ids == null || ids.isEmpty()) return ResponseDTO.userErrorParam("请选择要删除的裁床单");
        for (Long id : ids) {
            CuttingOrderEntity entity = cuttingOrderDao.selectById(id);
            if (entity != null) {
                entity.setDeletedFlag(Boolean.TRUE);
                cuttingOrderDao.updateById(entity);
            }
        }
        return ResponseDTO.ok();
    }

    @Transactional(rollbackFor = Exception.class)
    public ResponseDTO<String> batchComplete(List<Long> ids) {
        if (ids == null || ids.isEmpty()) return ResponseDTO.userErrorParam("请选择要完成的裁床单");
        for (Long id : ids) {
            CuttingOrderEntity entity = cuttingOrderDao.selectById(id);
            if (entity != null) {
                entity.setStatus(3);
                cuttingOrderDao.updateById(entity);
            }
        }
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