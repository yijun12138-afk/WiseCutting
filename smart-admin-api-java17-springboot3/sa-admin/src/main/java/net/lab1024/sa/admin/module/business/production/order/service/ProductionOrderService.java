package net.lab1024.sa.admin.module.business.production.order.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import jakarta.annotation.Resource;
import net.lab1024.sa.admin.module.business.production.order.dao.*;
import net.lab1024.sa.admin.module.business.production.order.domain.entity.*;
import net.lab1024.sa.admin.module.business.production.order.domain.form.*;
import net.lab1024.sa.admin.module.business.production.order.domain.vo.*;
import net.lab1024.sa.base.common.domain.PageResult;
import net.lab1024.sa.base.common.domain.ResponseDTO;
import net.lab1024.sa.base.common.util.SmartBeanUtil;
import net.lab1024.sa.base.common.util.SmartPageUtil;
import org.apache.commons.collections4.CollectionUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class ProductionOrderService {

    @Resource
    private ProductionOrderDao productionOrderDao;
    @Resource
    private ProductionOrderDetailDao productionOrderDetailDao;
    @Resource
    private ProductionOrderFabricDao productionOrderFabricDao;
    @Resource
    private ProductionProcessDao productionProcessDao;

    public ResponseDTO<PageResult<ProductionOrderVO>> query(ProductionOrderQueryForm queryForm) {
        queryForm.setDeletedFlag(false);
        Page<?> page = SmartPageUtil.convert2PageQuery(queryForm);
        List<ProductionOrderVO> list = productionOrderDao.queryPage(page, queryForm);
        list.forEach(o -> o.setStatusName(getStatusName(o.getStatus())));
        return ResponseDTO.ok(SmartPageUtil.convert2PageResult(page, list));
    }

    public ResponseDTO<ProductionOrderVO> getDetail(Long orderId) {
        ProductionOrderEntity entity = productionOrderDao.selectById(orderId);
        if (entity == null) return ResponseDTO.userErrorParam("指令单不存在");
        ProductionOrderVO vo = SmartBeanUtil.copy(entity, ProductionOrderVO.class);
        vo.setStatusName(getStatusName(entity.getStatus()));
        vo.setDetailList(productionOrderDetailDao.queryByOrderId(orderId));
        vo.setFabricList(productionOrderFabricDao.queryByOrderId(orderId));
        vo.setProcessList(productionProcessDao.queryByOrderId(orderId));
        return ResponseDTO.ok(vo);
    }

    @Transactional(rollbackFor = Exception.class)
    public ResponseDTO<String> addOrUpdate(ProductionOrderAddForm form) {
        ProductionOrderEntity entity = SmartBeanUtil.copy(form, ProductionOrderEntity.class);
        if (form.getOrderId() == null) {
            // 生成单据编号
            if (entity.getOrderNo() == null || entity.getOrderNo().isEmpty()) {
                String dateStr = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
                long count = productionOrderDao.selectCount(null) + 1;
                entity.setOrderNo("SC" + dateStr + String.format("%04d", count));
            }
            entity.setStatus(1); // 计划状态
            entity.setOrderQuantity(0);
            entity.setFinishQuantity(0);
            entity.setDeletedFlag(Boolean.FALSE);
            productionOrderDao.insert(entity);
        } else {
            productionOrderDao.updateById(entity);
            // 清除旧的明细、面料、工序
            productionOrderDetailDao.deleteByOrderId(form.getOrderId());
            productionOrderFabricDao.deleteByOrderId(form.getOrderId());
            productionProcessDao.deleteByOrderId(form.getOrderId());
        }
        Long orderId = entity.getOrderId();

        // 统计下单总数量
        int totalQty = 0;

        // 保存颜色尺码明细
        if (CollectionUtils.isNotEmpty(form.getDetailList())) {
            for (OrderDetailForm d : form.getDetailList()) {
                ProductionOrderDetailEntity detail = SmartBeanUtil.copy(d, ProductionOrderDetailEntity.class);
                detail.setDetailId(null); // 强制新增，避免主键冲突
                detail.setOrderId(orderId);
                detail.setDeletedFlag(Boolean.FALSE);
                productionOrderDetailDao.insert(detail);
                if (d.getQuantity() != null) totalQty += d.getQuantity();
            }
            // 更新订单数量
            ProductionOrderEntity updateQty = new ProductionOrderEntity();
            updateQty.setOrderId(orderId);
            updateQty.setOrderQuantity(totalQty);
            productionOrderDao.updateById(updateQty);
        }

        // 保存面料信息
        if (CollectionUtils.isNotEmpty(form.getFabricList())) {
            for (OrderFabricForm f : form.getFabricList()) {
                ProductionOrderFabricEntity fabric = SmartBeanUtil.copy(f, ProductionOrderFabricEntity.class);
                fabric.setId(null); // 强制新增
                fabric.setOrderId(orderId);
                fabric.setDeletedFlag(Boolean.FALSE);
                productionOrderFabricDao.insert(fabric);
            }
        }

        // 保存工序
        if (CollectionUtils.isNotEmpty(form.getProcessList())) {
            for (OrderProcessForm p : form.getProcessList()) {
                ProductionProcessEntity process = SmartBeanUtil.copy(p, ProductionProcessEntity.class);
                process.setProcessId(null); // 强制新增
                process.setOrderId(orderId);
                process.setStatus(0);
                process.setDeletedFlag(Boolean.FALSE);
                productionProcessDao.insert(process);
            }
        }

        return ResponseDTO.ok();
    }

    @Transactional(rollbackFor = Exception.class)
    public ResponseDTO<String> issue(Long orderId) {
        ProductionOrderEntity entity = productionOrderDao.selectById(orderId);
        if (entity == null) return ResponseDTO.userErrorParam("指令单不存在");
        if (entity.getStatus() != 1) return ResponseDTO.userErrorParam("只有计划状态的单据才能下达");
        entity.setStatus(2);
        entity.setIssueDate(LocalDateTime.now());
        productionOrderDao.updateById(entity);
        return ResponseDTO.ok();
    }

    @Transactional(rollbackFor = Exception.class)
    public ResponseDTO<String> complete(Long orderId) {
        ProductionOrderEntity entity = productionOrderDao.selectById(orderId);
        if (entity == null) return ResponseDTO.userErrorParam("指令单不存在");
        entity.setStatus(3);
        productionOrderDao.updateById(entity);
        return ResponseDTO.ok();
    }

    @Transactional(rollbackFor = Exception.class)
    public ResponseDTO<String> unissue(Long orderId) {
        ProductionOrderEntity entity = productionOrderDao.selectById(orderId);
        if (entity == null) return ResponseDTO.userErrorParam("指令单不存在");
        if (entity.getStatus() != 2) return ResponseDTO.userErrorParam("只有已下达的单据才能反下达");
        entity.setStatus(1);
        entity.setIssueDate(null);
        productionOrderDao.updateById(entity);
        return ResponseDTO.ok();
    }

    @Transactional(rollbackFor = Exception.class)
    public ResponseDTO<String> delete(Long orderId) {
        ProductionOrderEntity entity = productionOrderDao.selectById(orderId);
        if (entity == null) return ResponseDTO.userErrorParam("指令单不存在");
        entity.setDeletedFlag(Boolean.TRUE);
        productionOrderDao.updateById(entity);
        return ResponseDTO.ok();
    }

    @Transactional(rollbackFor = Exception.class)
    public ResponseDTO<String> batchDelete(List<Long> orderIds) {
        if (orderIds == null || orderIds.isEmpty()) return ResponseDTO.userErrorParam("请选择要删除的单据");
        for (Long orderId : orderIds) {
            ProductionOrderEntity entity = productionOrderDao.selectById(orderId);
            if (entity != null) {
                entity.setDeletedFlag(Boolean.TRUE);
                productionOrderDao.updateById(entity);
            }
        }
        return ResponseDTO.ok();
    }

    @Transactional(rollbackFor = Exception.class)
    public ResponseDTO<String> batchComplete(List<Long> orderIds) {
        if (orderIds == null || orderIds.isEmpty()) return ResponseDTO.userErrorParam("请选择要完工的单据");
        for (Long orderId : orderIds) {
            ProductionOrderEntity entity = productionOrderDao.selectById(orderId);
            if (entity != null) {
                entity.setStatus(3);
                productionOrderDao.updateById(entity);
            }
        }
        return ResponseDTO.ok();
    }

    private String getStatusName(Integer status) {
        if (status == null) return "";
        return switch (status) {
            case 1 -> "计划";
            case 2 -> "下达";
            case 3 -> "完工";
            default -> "";
        };
    }
}
