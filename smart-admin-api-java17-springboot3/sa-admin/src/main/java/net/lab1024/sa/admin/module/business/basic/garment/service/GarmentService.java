package net.lab1024.sa.admin.module.business.basic.garment.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import jakarta.annotation.Resource;
import net.lab1024.sa.admin.module.business.basic.garment.dao.GarmentDao;
import net.lab1024.sa.admin.module.business.basic.garment.dao.GarmentSkuDao;
import net.lab1024.sa.admin.module.business.basic.garment.domain.entity.GarmentEntity;
import net.lab1024.sa.admin.module.business.basic.garment.domain.entity.GarmentSkuEntity;
import net.lab1024.sa.admin.module.business.basic.garment.domain.form.GarmentAddForm;
import net.lab1024.sa.admin.module.business.basic.garment.domain.form.GarmentQueryForm;
import net.lab1024.sa.admin.module.business.basic.garment.domain.vo.GarmentSkuVO;
import net.lab1024.sa.admin.module.business.basic.garment.domain.vo.GarmentVO;
import net.lab1024.sa.base.common.domain.PageResult;
import net.lab1024.sa.base.common.domain.ResponseDTO;
import net.lab1024.sa.base.common.util.SmartBeanUtil;
import net.lab1024.sa.base.common.util.SmartPageUtil;
import org.apache.commons.collections4.CollectionUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class GarmentService {

    @Resource
    private GarmentDao garmentDao;

    @Resource
    private GarmentSkuDao garmentSkuDao;

    public ResponseDTO<List<GarmentVO>> queryAll() {
        return ResponseDTO.ok(garmentDao.queryAll());
    }

    public ResponseDTO<PageResult<GarmentVO>> query(GarmentQueryForm queryForm) {
        queryForm.setDeletedFlag(false);
        Page<?> page = SmartPageUtil.convert2PageQuery(queryForm);
        List<GarmentVO> list = garmentDao.queryPage(page, queryForm);
        PageResult<GarmentVO> pageResult = SmartPageUtil.convert2PageResult(page, list);
        if (!pageResult.getEmptyFlag() && CollectionUtils.isNotEmpty(list)) {
            List<Long> garmentIds = list.stream().map(GarmentVO::getGarmentId).collect(Collectors.toList());
            List<GarmentSkuVO> skuList = garmentSkuDao.queryByGarmentIds(garmentIds);
            Map<Long, List<GarmentSkuVO>> skuMap = skuList.stream().collect(Collectors.groupingBy(GarmentSkuVO::getGarmentId));
            list.forEach(g -> g.setSkuList(skuMap.getOrDefault(g.getGarmentId(), new ArrayList<>())));
        }
        return ResponseDTO.ok(pageResult);
    }

    @Transactional(rollbackFor = Exception.class)
    public ResponseDTO<String> addOrUpdate(GarmentAddForm form) {
        GarmentEntity entity = SmartBeanUtil.copy(form, GarmentEntity.class);
        if (form.getGarmentId() == null) {
            entity.setDisabledFlag(form.getDisabledFlag() != null ? form.getDisabledFlag() : Boolean.FALSE);
            entity.setDeletedFlag(Boolean.FALSE);
            garmentDao.insert(entity);
        } else {
            garmentDao.updateById(entity);
            garmentSkuDao.deleteByGarmentId(form.getGarmentId());
        }
        if (CollectionUtils.isNotEmpty(form.getSkuList())) {
            Long garmentId = entity.getGarmentId();
            List<GarmentSkuEntity> skuEntities = form.getSkuList().stream().map(s -> {
                GarmentSkuEntity sku = SmartBeanUtil.copy(s, GarmentSkuEntity.class);
                sku.setGarmentId(garmentId);
                sku.setDeletedFlag(Boolean.FALSE);
                return sku;
            }).collect(Collectors.toList());
            skuEntities.forEach(garmentSkuDao::insert);
        }
        return ResponseDTO.ok();
    }

    @Transactional(rollbackFor = Exception.class)
    public ResponseDTO<String> updateDisabledFlag(Long garmentId, Boolean disabledFlag) {
        GarmentEntity entity = garmentDao.selectById(garmentId);
        if (entity == null) return ResponseDTO.userErrorParam("成衣不存在");
        entity.setDisabledFlag(disabledFlag);
        garmentDao.updateById(entity);
        return ResponseDTO.ok();
    }

    @Transactional(rollbackFor = Exception.class)
    public ResponseDTO<String> delete(Long garmentId) {
        GarmentEntity entity = garmentDao.selectById(garmentId);
        if (entity == null) return ResponseDTO.userErrorParam("成衣不存在");
        entity.setDeletedFlag(Boolean.TRUE);
        garmentDao.updateById(entity);
        return ResponseDTO.ok();
    }
}
