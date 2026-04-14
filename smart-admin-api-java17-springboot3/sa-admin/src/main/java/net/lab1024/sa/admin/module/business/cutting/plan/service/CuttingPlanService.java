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
            entity.setStatus(form.getStatus() != null ? form.getStatus() : 1);
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
        if (entity == null)
            return ResponseDTO.userErrorParam("裁剪计划不存在");
        entity.setDeletedFlag(Boolean.TRUE);
        cuttingPlanDao.updateById(entity);
        return ResponseDTO.ok();
    }

    @Transactional(rollbackFor = Exception.class)
    public ResponseDTO<String> batchDelete(List<Long> planIds) {
        if (planIds == null || planIds.isEmpty()) return ResponseDTO.userErrorParam("请选择要删除的计划");
        for (Long planId : planIds) {
            CuttingPlanEntity entity = cuttingPlanDao.selectById(planId);
            if (entity != null) {
                entity.setDeletedFlag(Boolean.TRUE);
                cuttingPlanDao.updateById(entity);
            }
        }
        return ResponseDTO.ok();
    }

    @Transactional(rollbackFor = Exception.class)
    public ResponseDTO<String> batchComplete(List<Long> planIds) {
        if (planIds == null || planIds.isEmpty()) return ResponseDTO.userErrorParam("请选择要完成的计划");
        for (Long planId : planIds) {
            CuttingPlanEntity entity = cuttingPlanDao.selectById(planId);
            if (entity != null) {
                entity.setStatus(3);
                cuttingPlanDao.updateById(entity);
            }
        }
        return ResponseDTO.ok();
    }

    private String getStatusName(Integer status) {
        if (status == null)
            return "";
        return switch (status) {
            case 1 -> "计划";
            case 2 -> "进行中";
            case 3 -> "完成";
            default -> "";
        };
    }

    @Transactional(rollbackFor = Exception.class)
    public ResponseDTO<String> updateStatus(Long planId, Integer status) {
        CuttingPlanEntity entity = cuttingPlanDao.selectById(planId);
        if (entity == null)
            return ResponseDTO.userErrorParam("裁剪计划不存在");

        // 验证状态变更的合法性
        if (status == 1) { // 反下达
            if (entity.getStatus() != 2) {
                return ResponseDTO.userErrorParam("只有进行中的计划可以反下达");
            }
            entity.setActualQuantity(0); // 重置实际数量
        } else if (status == 2) { // 下达
            if (entity.getStatus() != 1) {
                return ResponseDTO.userErrorParam("只有计划状态的计划可以下达");
            }
        } else if (status == 3) { // 完成
            if (entity.getStatus() != 2) {
                return ResponseDTO.userErrorParam("只有进行中的计划可以标记为完成");
            }
        } else {
            return ResponseDTO.userErrorParam("无效的状态值");
        }

        entity.setStatus(status);
        cuttingPlanDao.updateById(entity);
        return ResponseDTO.ok();
    }
}
