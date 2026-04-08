package net.lab1024.sa.admin.module.business.basic.size.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import jakarta.annotation.Resource;
import net.lab1024.sa.admin.module.business.basic.size.dao.SizeDao;
import net.lab1024.sa.admin.module.business.basic.size.domain.entity.SizeEntity;
import net.lab1024.sa.admin.module.business.basic.size.domain.form.SizeAddForm;
import net.lab1024.sa.admin.module.business.basic.size.domain.form.SizeQueryForm;
import net.lab1024.sa.admin.module.business.basic.size.domain.vo.SizeVO;
import net.lab1024.sa.base.common.domain.PageResult;
import net.lab1024.sa.base.common.domain.ResponseDTO;
import net.lab1024.sa.base.common.util.SmartBeanUtil;
import net.lab1024.sa.base.common.util.SmartPageUtil;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
public class SizeService {

    @Resource
    private SizeDao sizeDao;

    public ResponseDTO<PageResult<SizeVO>> query(SizeQueryForm queryForm) {
        queryForm.setDeletedFlag(false);
        Page<?> page = SmartPageUtil.convert2PageQuery(queryForm);
        List<SizeVO> list = sizeDao.queryPage(page, queryForm);
        return ResponseDTO.ok(SmartPageUtil.convert2PageResult(page, list));
    }

    public ResponseDTO<List<SizeVO>> queryAll() {
        return ResponseDTO.ok(sizeDao.queryAll());
    }

    @Transactional(rollbackFor = Exception.class)
    public ResponseDTO<String> addOrUpdate(SizeAddForm form) {
        SizeEntity entity = SmartBeanUtil.copy(form, SizeEntity.class);
        if (form.getSizeId() == null) {
            entity.setDeletedFlag(Boolean.FALSE);
            sizeDao.insert(entity);
        } else {
            sizeDao.updateById(entity);
        }
        return ResponseDTO.ok();
    }

    @Transactional(rollbackFor = Exception.class)
    public ResponseDTO<String> delete(Long sizeId) {
        SizeEntity entity = sizeDao.selectById(sizeId);
        if (entity == null) return ResponseDTO.userErrorParam("尺码不存在");
        entity.setDeletedFlag(Boolean.TRUE);
        sizeDao.updateById(entity);
        return ResponseDTO.ok();
    }
}
