package net.lab1024.sa.admin.module.business.basic.cuttingpart.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import jakarta.annotation.Resource;
import net.lab1024.sa.admin.module.business.basic.cuttingpart.dao.CuttingPartDao;
import net.lab1024.sa.admin.module.business.basic.cuttingpart.domain.entity.CuttingPartEntity;
import net.lab1024.sa.admin.module.business.basic.cuttingpart.domain.form.CuttingPartAddForm;
import net.lab1024.sa.admin.module.business.basic.cuttingpart.domain.form.CuttingPartQueryForm;
import net.lab1024.sa.admin.module.business.basic.cuttingpart.domain.vo.CuttingPartVO;
import net.lab1024.sa.base.common.domain.PageResult;
import net.lab1024.sa.base.common.domain.ResponseDTO;
import net.lab1024.sa.base.common.util.SmartBeanUtil;
import net.lab1024.sa.base.common.util.SmartPageUtil;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
public class CuttingPartService {

    @Resource
    private CuttingPartDao cuttingPartDao;

    public ResponseDTO<PageResult<CuttingPartVO>> query(CuttingPartQueryForm queryForm) {
        queryForm.setDeletedFlag(false);
        Page<?> page = SmartPageUtil.convert2PageQuery(queryForm);
        List<CuttingPartVO> list = cuttingPartDao.queryPage(page, queryForm);
        return ResponseDTO.ok(SmartPageUtil.convert2PageResult(page, list));
    }

    @Transactional(rollbackFor = Exception.class)
    public ResponseDTO<String> addOrUpdate(CuttingPartAddForm form) {
        CuttingPartEntity entity = SmartBeanUtil.copy(form, CuttingPartEntity.class);
        if (form.getPartId() == null) {
            entity.setDeletedFlag(Boolean.FALSE);
            cuttingPartDao.insert(entity);
        } else {
            cuttingPartDao.updateById(entity);
        }
        return ResponseDTO.ok();
    }

    @Transactional(rollbackFor = Exception.class)
    public ResponseDTO<String> delete(Long partId) {
        CuttingPartEntity entity = cuttingPartDao.selectById(partId);
        if (entity == null) return ResponseDTO.userErrorParam("部位不存在");
        entity.setDeletedFlag(Boolean.TRUE);
        cuttingPartDao.updateById(entity);
        return ResponseDTO.ok();
    }
}
