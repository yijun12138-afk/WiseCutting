package net.lab1024.sa.admin.module.business.basic.unit.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import jakarta.annotation.Resource;
import net.lab1024.sa.admin.module.business.basic.unit.dao.UnitDao;
import net.lab1024.sa.admin.module.business.basic.unit.domain.entity.UnitEntity;
import net.lab1024.sa.admin.module.business.basic.unit.domain.form.UnitAddForm;
import net.lab1024.sa.admin.module.business.basic.unit.domain.form.UnitQueryForm;
import net.lab1024.sa.admin.module.business.basic.unit.domain.vo.UnitVO;
import net.lab1024.sa.base.common.domain.PageResult;
import net.lab1024.sa.base.common.domain.ResponseDTO;
import net.lab1024.sa.base.common.util.SmartBeanUtil;
import net.lab1024.sa.base.common.util.SmartPageUtil;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
public class UnitService {

    @Resource
    private UnitDao unitDao;

    public ResponseDTO<PageResult<UnitVO>> query(UnitQueryForm queryForm) {
        queryForm.setDeletedFlag(false);
        Page<?> page = SmartPageUtil.convert2PageQuery(queryForm);
        List<UnitVO> list = unitDao.queryPage(page, queryForm);
        return ResponseDTO.ok(SmartPageUtil.convert2PageResult(page, list));
    }

    public ResponseDTO<List<UnitVO>> queryAll() {
        return ResponseDTO.ok(unitDao.queryAll());
    }

    @Transactional(rollbackFor = Exception.class)
    public ResponseDTO<String> addOrUpdate(UnitAddForm form) {
        UnitEntity entity = SmartBeanUtil.copy(form, UnitEntity.class);
        if (form.getUnitId() == null) {
            // 生成单位编码: DW + 6位序号
            long count = unitDao.selectCount(null);
            entity.setUnitCode(String.format("DW%06d", count + 1));
            entity.setDeletedFlag(Boolean.FALSE);
            unitDao.insert(entity);
        } else {
            unitDao.updateById(entity);
        }
        return ResponseDTO.ok();
    }

    @Transactional(rollbackFor = Exception.class)
    public ResponseDTO<String> delete(Long unitId) {
        UnitEntity entity = unitDao.selectById(unitId);
        if (entity == null) return ResponseDTO.userErrorParam("单位不存在");
        entity.setDeletedFlag(Boolean.TRUE);
        unitDao.updateById(entity);
        return ResponseDTO.ok();
    }
}
