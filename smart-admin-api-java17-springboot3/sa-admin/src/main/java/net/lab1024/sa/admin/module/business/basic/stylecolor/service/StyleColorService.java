package net.lab1024.sa.admin.module.business.basic.stylecolor.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import jakarta.annotation.Resource;
import net.lab1024.sa.admin.module.business.basic.colorgroup.dao.ColorGroupDao;
import net.lab1024.sa.admin.module.business.basic.colorgroup.domain.entity.ColorGroupEntity;
import net.lab1024.sa.admin.module.business.basic.stylecolor.dao.StyleColorDao;
import net.lab1024.sa.admin.module.business.basic.stylecolor.domain.entity.StyleColorEntity;
import net.lab1024.sa.admin.module.business.basic.stylecolor.domain.form.StyleColorAddForm;
import net.lab1024.sa.admin.module.business.basic.stylecolor.domain.form.StyleColorQueryForm;
import net.lab1024.sa.admin.module.business.basic.stylecolor.domain.vo.StyleColorVO;
import net.lab1024.sa.base.common.domain.PageResult;
import net.lab1024.sa.base.common.domain.ResponseDTO;
import net.lab1024.sa.base.common.util.SmartBeanUtil;
import net.lab1024.sa.base.common.util.SmartPageUtil;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class StyleColorService {

    @Resource
    private StyleColorDao styleColorDao;

    @Resource
    private ColorGroupDao colorGroupDao;

    public ResponseDTO<PageResult<StyleColorVO>> query(StyleColorQueryForm queryForm) {
        queryForm.setDeletedFlag(false);
        Page<?> page = SmartPageUtil.convert2PageQuery(queryForm);
        List<StyleColorVO> list = styleColorDao.queryPage(page, queryForm);
        return ResponseDTO.ok(SmartPageUtil.convert2PageResult(page, list));
    }

    public ResponseDTO<List<StyleColorVO>> queryAll() {
        return ResponseDTO.ok(styleColorDao.queryAll());
    }

    @Transactional(rollbackFor = Exception.class)
    public ResponseDTO<String> addOrUpdate(StyleColorAddForm form) {
        ColorGroupEntity colorGroup = colorGroupDao.selectById(form.getColorGroupId());
        if (colorGroup == null || Boolean.TRUE.equals(colorGroup.getDeletedFlag())) {
            return ResponseDTO.userErrorParam("颜色组不存在");
        }
        StyleColorEntity entity = SmartBeanUtil.copy(form, StyleColorEntity.class);
        if (form.getColorId() == null) {
            entity.setDeletedFlag(Boolean.FALSE);
            styleColorDao.insert(entity);
        } else {
            styleColorDao.updateById(entity);
        }
        return ResponseDTO.ok();
    }

    @Transactional(rollbackFor = Exception.class)
    public ResponseDTO<String> delete(Long colorId) {
        StyleColorEntity entity = styleColorDao.selectById(colorId);
        if (entity == null) return ResponseDTO.userErrorParam("颜色不存在");
        entity.setDeletedFlag(Boolean.TRUE);
        styleColorDao.updateById(entity);
        return ResponseDTO.ok();
    }
}
