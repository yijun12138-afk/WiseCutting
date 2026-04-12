package net.lab1024.sa.admin.module.business.production.spread.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import jakarta.annotation.Resource;
import net.lab1024.sa.admin.module.business.production.spread.dao.FabricSpreadDao;
import net.lab1024.sa.admin.module.business.production.spread.domain.entity.FabricSpreadEntity;
import net.lab1024.sa.admin.module.business.production.spread.domain.form.FabricSpreadAddForm;
import net.lab1024.sa.admin.module.business.production.spread.domain.form.FabricSpreadCompleteForm;
import net.lab1024.sa.admin.module.business.production.spread.domain.form.FabricSpreadQueryForm;
import net.lab1024.sa.admin.module.business.production.spread.domain.vo.FabricSpreadVO;
import net.lab1024.sa.base.common.domain.PageResult;
import net.lab1024.sa.base.common.domain.ResponseDTO;
import net.lab1024.sa.base.common.util.SmartBeanUtil;
import net.lab1024.sa.base.common.util.SmartPageUtil;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
public class FabricSpreadService {

    @Resource
    private FabricSpreadDao fabricSpreadDao;

    public ResponseDTO<PageResult<FabricSpreadVO>> query(FabricSpreadQueryForm queryForm) {
        queryForm.setDeletedFlag(false);
        Page<?> page = SmartPageUtil.convert2PageQuery(queryForm);
        List<FabricSpreadVO> list = fabricSpreadDao.queryPage(page, queryForm);
        list.forEach(s -> s.setStatusName(getStatusName(s.getStatus())));
        return ResponseDTO.ok(SmartPageUtil.convert2PageResult(page, list));
    }

    public ResponseDTO<List<FabricSpreadVO>> queryWorkbench(FabricSpreadQueryForm queryForm) {
        queryForm.setDeletedFlag(false);
        queryForm.setIssuedFlag(true);
        List<FabricSpreadVO> list = fabricSpreadDao.queryIssuedList(queryForm);
        list.forEach(s -> s.setStatusName(getStatusName(s.getStatus())));
        return ResponseDTO.ok(list);
    }

    @Transactional(rollbackFor = Exception.class)
    public ResponseDTO<String> addOrUpdate(FabricSpreadAddForm form) {
        FabricSpreadEntity entity = SmartBeanUtil.copy(form, FabricSpreadEntity.class);
        if (form.getSpreadId() == null) {
            entity.setStatus(0);
            entity.setIssuedFlag(Boolean.FALSE);
            entity.setDeletedFlag(Boolean.FALSE);
            fabricSpreadDao.insert(entity);
        } else {
            fabricSpreadDao.updateById(entity);
        }
        return ResponseDTO.ok();
    }

    @Transactional(rollbackFor = Exception.class)
    public ResponseDTO<String> saveAndIssue(FabricSpreadAddForm form) {
        FabricSpreadEntity entity = SmartBeanUtil.copy(form, FabricSpreadEntity.class);
        if (form.getSpreadId() == null) {
            entity.setStatus(1);
            entity.setIssuedFlag(Boolean.TRUE);
            entity.setDeletedFlag(Boolean.FALSE);
            fabricSpreadDao.insert(entity);
        } else {
            entity.setStatus(1);
            entity.setIssuedFlag(Boolean.TRUE);
            fabricSpreadDao.updateById(entity);
        }
        return ResponseDTO.ok();
    }

    @Transactional(rollbackFor = Exception.class)
    public ResponseDTO<String> complete(FabricSpreadCompleteForm form) {
        FabricSpreadEntity entity = fabricSpreadDao.selectById(form.getSpreadId());
        if (entity == null) return ResponseDTO.userErrorParam("铺布任务不存在");
        entity.setActualLayers(form.getActualLayers());
        entity.setActualLength(form.getActualLength());
        entity.setStatus(2);
        fabricSpreadDao.updateById(entity);
        return ResponseDTO.ok();
    }

    @Transactional(rollbackFor = Exception.class)
    public ResponseDTO<String> delete(Long spreadId) {
        FabricSpreadEntity entity = fabricSpreadDao.selectById(spreadId);
        if (entity == null) return ResponseDTO.userErrorParam("铺布任务不存在");
        entity.setDeletedFlag(Boolean.TRUE);
        fabricSpreadDao.updateById(entity);
        return ResponseDTO.ok();
    }

    @Transactional(rollbackFor = Exception.class)
    public ResponseDTO<String> unissue(Long spreadId) {
        FabricSpreadEntity entity = fabricSpreadDao.selectById(spreadId);
        if (entity == null) return ResponseDTO.userErrorParam("铺布任务不存在");
        entity.setIssuedFlag(Boolean.FALSE);
        entity.setStatus(0);
        fabricSpreadDao.updateById(entity);
        return ResponseDTO.ok();
    }

    @Transactional(rollbackFor = Exception.class)
    public ResponseDTO<String> batchComplete(List<Long> spreadIds) {
        if (spreadIds == null || spreadIds.isEmpty()) return ResponseDTO.userErrorParam("请选择要完成的任务");
        for (Long spreadId : spreadIds) {
            FabricSpreadEntity entity = fabricSpreadDao.selectById(spreadId);
            if (entity != null) {
                entity.setStatus(2);
                fabricSpreadDao.updateById(entity);
            }
        }
        return ResponseDTO.ok();
    }

    @Transactional(rollbackFor = Exception.class)
    public ResponseDTO<String> batchDelete(List<Long> spreadIds) {
        if (spreadIds == null || spreadIds.isEmpty()) {
            return ResponseDTO.userErrorParam("请选择要删除的任务");
        }
        for (Long spreadId : spreadIds) {
            FabricSpreadEntity entity = fabricSpreadDao.selectById(spreadId);
            if (entity != null) {
                entity.setDeletedFlag(Boolean.TRUE);
                fabricSpreadDao.updateById(entity);
            }
        }
        return ResponseDTO.ok();
    }

    private String getStatusName(Integer status) {
        if (status == null) return "";
        return switch (status) {
            case 0 -> "待作业";
            case 1 -> "进行中";
            case 2 -> "已完成";
            default -> "";
        };
    }
}
