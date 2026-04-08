package net.lab1024.sa.admin.module.business.cutting.plan.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import jakarta.annotation.Resource;
import net.lab1024.sa.admin.module.business.cutting.plan.dao.CuttingPlanDao;
import net.lab1024.sa.admin.module.business.cutting.plan.domain.entity.CuttingPlanEntity;
import net.lab1024.sa.admin.module.business.cutting.plan.domain.form.CuttingPlanAddForm;
import net.lab1024.sa.admin.module.business.cutting.plan.domain.form.CuttingPlanQueryForm;
import net.lab1024.sa.admin.module.business.cutting.plan.domain.vo.CuttingPlanVO;
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
public class CuttingPlanService {

    @Resource
    private CuttingPlanDao cuttingPlanDao;

    public ResponseDTO<PageResult<CuttingPlanVO>> query(CuttingPlanQueryForm queryForm) {
        queryForm.setDeletedFlag(false);
        Page<?> page = SmartPageUtil.convert2PageQuery(queryForm);
        List<CuttingPlanVO> list = cuttingPlanDao.queryPage(page, queryForm);
        list.forEach(p -> p.setStatusName(getStatusName(p.getStatus())));
        return ResponseDTO.ok(SmartPageUtil.convert2PageResult(page, list));
    }

    @Transactional(rollbackFor = Exception.class)
    public ResponseDTO<String> addOrUpdate(CuttingPlanAddForm form) {
        CuttingPlanEntity entity = SmartBeanUtil.copy(form, CuttingPlanEntity.class);
        if (form.getPlanId() == null) {
            String dateStr = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
            long count = cuttingPlanDao.selectCount(null) + 1;
            entity.setPlanNo("CP" + dateStr + String.format("%04d", count));
            entity.setStatus(1);
            entity.setDeletedFlag(Boolean.FALSE);
            cuttingPlanDao.insert(entity);
        } else {
            cuttingPlanDao.updateById(entity);
        }
        return ResponseDTO.ok();
    }

    @Transactional(rollbackFor = Exception.class)
    public ResponseDTO<String> delete(Long planId) {
        CuttingPlanEntity entity = cuttingPlanDao.selectById(planId);
        if (entity == null) return ResponseDTO.userErrorParam("裁剪计划不存在");
        entity.setDeletedFlag(Boolean.TRUE);
        cuttingPlanDao.updateById(entity);
        return ResponseDTO.ok();
    }

    private String getStatusName(Integer status) {
        if (status == null) return "";
        return switch (status) {
            case 1 -> "计划";
            case 2 -> "进行中";
            case 3 -> "完成";
            default -> "";
        };
    }
}
