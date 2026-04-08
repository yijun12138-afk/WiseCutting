package net.lab1024.sa.admin.module.business.basic.fabric.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import jakarta.annotation.Resource;
import net.lab1024.sa.admin.module.business.basic.fabric.dao.FabricDao;
import net.lab1024.sa.admin.module.business.basic.fabric.dao.FabricSkuDao;
import net.lab1024.sa.admin.module.business.basic.fabric.domain.entity.FabricEntity;
import net.lab1024.sa.admin.module.business.basic.fabric.domain.entity.FabricSkuEntity;
import net.lab1024.sa.admin.module.business.basic.fabric.domain.form.FabricAddForm;
import net.lab1024.sa.admin.module.business.basic.fabric.domain.form.FabricQueryForm;
import net.lab1024.sa.admin.module.business.basic.fabric.domain.form.FabricSkuForm;
import net.lab1024.sa.admin.module.business.basic.fabric.domain.vo.FabricSkuVO;
import net.lab1024.sa.admin.module.business.basic.fabric.domain.vo.FabricVO;
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
public class FabricService {

    @Resource
    private FabricDao fabricDao;

    @Resource
    private FabricSkuDao fabricSkuDao;

    public ResponseDTO<PageResult<FabricVO>> query(FabricQueryForm queryForm) {
        queryForm.setDeletedFlag(false);
        Page<?> page = SmartPageUtil.convert2PageQuery(queryForm);
        List<FabricVO> list = fabricDao.queryPage(page, queryForm);
        PageResult<FabricVO> pageResult = SmartPageUtil.convert2PageResult(page, list);
        if (!pageResult.getEmptyFlag() && CollectionUtils.isNotEmpty(list)) {
            List<Long> fabricIds = list.stream().map(FabricVO::getFabricId).collect(Collectors.toList());
            List<FabricSkuVO> skuList = fabricSkuDao.queryByFabricIds(fabricIds);
            Map<Long, List<FabricSkuVO>> skuMap = skuList.stream().collect(Collectors.groupingBy(FabricSkuVO::getFabricId));
            list.forEach(f -> f.setSkuList(skuMap.getOrDefault(f.getFabricId(), new ArrayList<>())));
        }
        return ResponseDTO.ok(pageResult);
    }

    public ResponseDTO<List<FabricVO>> queryAll() {
        return ResponseDTO.ok(fabricDao.queryAll());
    }

    @Transactional(rollbackFor = Exception.class)
    public ResponseDTO<String> addOrUpdate(FabricAddForm form) {
        FabricEntity entity = SmartBeanUtil.copy(form, FabricEntity.class);
        if (form.getFabricId() == null) {
            entity.setDisabledFlag(form.getDisabledFlag() != null ? form.getDisabledFlag() : Boolean.FALSE);
            entity.setDeletedFlag(Boolean.FALSE);
            fabricDao.insert(entity);
        } else {
            fabricDao.updateById(entity);
            fabricSkuDao.deleteByFabricId(form.getFabricId());
        }
        // 保存SKU
        if (CollectionUtils.isNotEmpty(form.getSkuList())) {
            Long fabricId = entity.getFabricId();
            List<FabricSkuEntity> skuEntities = form.getSkuList().stream().map(s -> {
                FabricSkuEntity sku = SmartBeanUtil.copy(s, FabricSkuEntity.class);
                sku.setFabricId(fabricId);
                sku.setDeletedFlag(Boolean.FALSE);
                return sku;
            }).collect(Collectors.toList());
            skuEntities.forEach(fabricSkuDao::insert);
        }
        return ResponseDTO.ok();
    }

    @Transactional(rollbackFor = Exception.class)
    public ResponseDTO<String> delete(Long fabricId) {
        FabricEntity entity = fabricDao.selectById(fabricId);
        if (entity == null) return ResponseDTO.userErrorParam("面料不存在");
        entity.setDeletedFlag(Boolean.TRUE);
        fabricDao.updateById(entity);
        return ResponseDTO.ok();
    }
}
