package net.lab1024.sa.admin.module.business.basic.sizegroup.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import jakarta.annotation.Resource;
import net.lab1024.sa.admin.module.business.basic.sizegroup.dao.SizeGroupDao;
import net.lab1024.sa.admin.module.business.basic.sizegroup.domain.entity.SizeGroupEntity;
import net.lab1024.sa.admin.module.business.basic.sizegroup.domain.form.SizeGroupAddForm;
import net.lab1024.sa.admin.module.business.basic.sizegroup.domain.form.SizeGroupQueryForm;
import net.lab1024.sa.admin.module.business.basic.sizegroup.domain.vo.SizeGroupVO;
import net.lab1024.sa.base.common.domain.PageResult;
import net.lab1024.sa.base.common.domain.ResponseDTO;
import net.lab1024.sa.base.common.util.SmartBeanUtil;
import net.lab1024.sa.base.common.util.SmartPageUtil;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class SizeGroupService {

    @Resource
    private SizeGroupDao sizeGroupDao;

    public ResponseDTO<PageResult<SizeGroupVO>> query(SizeGroupQueryForm queryForm) {
        queryForm.setDeletedFlag(false);
        Page<?> page = SmartPageUtil.convert2PageQuery(queryForm);
        List<SizeGroupVO> list = sizeGroupDao.queryPage(page, queryForm);
        return ResponseDTO.ok(SmartPageUtil.convert2PageResult(page, list));
    }

    public ResponseDTO<List<SizeGroupVO>> queryAll() {
        return ResponseDTO.ok(sizeGroupDao.queryAll());
    }

    @Transactional(rollbackFor = Exception.class)
    public ResponseDTO<String> addOrUpdate(SizeGroupAddForm form) {
        SizeGroupEntity entity = SmartBeanUtil.copy(form, SizeGroupEntity.class);
        if (form.getGroupId() == null) {
            entity.setDeletedFlag(Boolean.FALSE);
            sizeGroupDao.insert(entity);
        } else {
            sizeGroupDao.updateById(entity);
        }
        return ResponseDTO.ok();
    }

    @Transactional(rollbackFor = Exception.class)
    public ResponseDTO<String> delete(Long groupId) {
        SizeGroupEntity entity = sizeGroupDao.selectById(groupId);
        if (entity == null) {
            return ResponseDTO.userErrorParam("尺码组不存在");
        }
        entity.setDeletedFlag(Boolean.TRUE);
        sizeGroupDao.updateById(entity);
        return ResponseDTO.ok();
    }
}
