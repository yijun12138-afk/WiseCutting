package net.lab1024.sa.admin.module.business.production.relax.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import jakarta.annotation.Resource;
import net.lab1024.sa.admin.module.business.production.relax.dao.FabricRelaxDao;
import net.lab1024.sa.admin.module.business.production.relax.domain.entity.FabricRelaxEntity;
import net.lab1024.sa.admin.module.business.production.relax.domain.form.FabricRelaxAddForm;
import net.lab1024.sa.admin.module.business.production.relax.domain.form.FabricRelaxQueryForm;
import net.lab1024.sa.admin.module.business.production.relax.domain.vo.FabricRelaxVO;
import net.lab1024.sa.base.common.domain.PageResult;
import net.lab1024.sa.base.common.domain.ResponseDTO;
import net.lab1024.sa.base.common.util.SmartBeanUtil;
import net.lab1024.sa.base.common.util.SmartPageUtil;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
public class FabricRelaxService {

    @Resource
    private FabricRelaxDao fabricRelaxDao;

    public ResponseDTO<PageResult<FabricRelaxVO>> query(FabricRelaxQueryForm queryForm) {
        queryForm.setDeletedFlag(false);
        Page<?> page = SmartPageUtil.convert2PageQuery(queryForm);
        List<FabricRelaxVO> list = fabricRelaxDao.queryPage(page, queryForm);
        list.forEach(r -> r.setStatusName(getStatusName(r.getStatus())));
        return ResponseDTO.ok(SmartPageUtil.convert2PageResult(page, list));
    }

    @Transactional(rollbackFor = Exception.class)
    public ResponseDTO<String> addOrUpdate(FabricRelaxAddForm form) {
        FabricRelaxEntity entity = SmartBeanUtil.copy(form, FabricRelaxEntity.class);
        if (form.getRelaxId() == null) {
            entity.setStatus(0);
            entity.setDeletedFlag(Boolean.FALSE);
            fabricRelaxDao.insert(entity);
        } else {
            fabricRelaxDao.updateById(entity);
        }
        return ResponseDTO.ok();
    }

    @Transactional(rollbackFor = Exception.class)
    public ResponseDTO<String> delete(Long relaxId) {
        FabricRelaxEntity entity = fabricRelaxDao.selectById(relaxId);
        if (entity == null) return ResponseDTO.userErrorParam("松布任务不存在");
        entity.setDeletedFlag(Boolean.TRUE);
        fabricRelaxDao.updateById(entity);
        return ResponseDTO.ok();
    }

    private String getStatusName(Integer status) {
        if (status == null) return "";
        return switch (status) {
            case 0 -> "计划";
            case 1 -> "进行中";
            case 2 -> "完成";
            default -> "";
        };
    }
}
