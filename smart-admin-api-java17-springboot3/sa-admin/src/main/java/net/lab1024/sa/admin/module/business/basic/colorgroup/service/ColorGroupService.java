package net.lab1024.sa.admin.module.business.basic.colorgroup.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import jakarta.annotation.Resource;
import net.lab1024.sa.admin.module.business.basic.colorgroup.dao.ColorGroupDao;
import net.lab1024.sa.admin.module.business.basic.colorgroup.domain.entity.ColorGroupEntity;
import net.lab1024.sa.admin.module.business.basic.colorgroup.domain.form.ColorGroupAddForm;
import net.lab1024.sa.admin.module.business.basic.colorgroup.domain.form.ColorGroupQueryForm;
import net.lab1024.sa.admin.module.business.basic.colorgroup.domain.vo.ColorGroupVO;
import net.lab1024.sa.base.common.domain.PageResult;
import net.lab1024.sa.base.common.domain.ResponseDTO;
import net.lab1024.sa.base.common.util.SmartBeanUtil;
import net.lab1024.sa.base.common.util.SmartPageUtil;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class ColorGroupService {

    @Resource
    private ColorGroupDao colorGroupDao;

    public ResponseDTO<PageResult<ColorGroupVO>> query(ColorGroupQueryForm queryForm) {
        queryForm.setDeletedFlag(false);
        Page<?> page = SmartPageUtil.convert2PageQuery(queryForm);
        List<ColorGroupVO> list = colorGroupDao.queryPage(page, queryForm);
        return ResponseDTO.ok(SmartPageUtil.convert2PageResult(page, list));
    }

    public ResponseDTO<List<ColorGroupVO>> queryAll() {
        return ResponseDTO.ok(colorGroupDao.queryAll());
    }

    @Transactional(rollbackFor = Exception.class)
    public ResponseDTO<String> addOrUpdate(ColorGroupAddForm form) {
        ColorGroupEntity entity = SmartBeanUtil.copy(form, ColorGroupEntity.class);
        if (form.getGroupId() == null) {
            entity.setDeletedFlag(Boolean.FALSE);
            colorGroupDao.insert(entity);
        } else {
            colorGroupDao.updateById(entity);
        }
        return ResponseDTO.ok();
    }

    @Transactional(rollbackFor = Exception.class)
    public ResponseDTO<String> delete(Long groupId) {
        ColorGroupEntity entity = colorGroupDao.selectById(groupId);
        if (entity == null) {
            return ResponseDTO.userErrorParam("颜色组不存在");
        }
        entity.setDeletedFlag(Boolean.TRUE);
        colorGroupDao.updateById(entity);
        return ResponseDTO.ok();
    }
}
