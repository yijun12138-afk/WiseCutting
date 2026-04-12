package net.lab1024.sa.admin.module.business.production.order.controller;

import cn.dev33.satoken.annotation.SaCheckPermission;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import jakarta.validation.Valid;
import net.lab1024.sa.admin.module.business.production.order.domain.form.ProductionOrderAddForm;
import net.lab1024.sa.admin.module.business.production.order.domain.form.ProductionOrderQueryForm;
import net.lab1024.sa.admin.module.business.production.order.domain.vo.ProductionOrderVO;
import net.lab1024.sa.admin.module.business.production.order.service.ProductionOrderService;
import net.lab1024.sa.base.common.domain.PageResult;
import net.lab1024.sa.base.common.domain.ResponseDTO;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@Tag(name = "生产管理-生产制单")
public class ProductionOrderController {

    @Resource
    private ProductionOrderService productionOrderService;

    @Operation(summary = "生产制单分页查询")
    @PostMapping("/production/order/query")
    @SaCheckPermission("production:order:query")
    public ResponseDTO<PageResult<ProductionOrderVO>> query(@RequestBody @Valid ProductionOrderQueryForm queryForm) {
        return productionOrderService.query(queryForm);
    }

    @Operation(summary = "指令单详情")
    @GetMapping("/production/order/detail/{orderId}")
    @SaCheckPermission("production:order:query")
    public ResponseDTO<ProductionOrderVO> detail(@PathVariable Long orderId) {
        return productionOrderService.getDetail(orderId);
    }

    @Operation(summary = "新增/修改生产制单")
    @PostMapping("/production/order/addOrUpdate")
    @SaCheckPermission("production:order:add")
    public ResponseDTO<String> addOrUpdate(@RequestBody @Valid ProductionOrderAddForm form) {
        return productionOrderService.addOrUpdate(form);
    }

    @Operation(summary = "下达指令单")
    @GetMapping("/production/order/issue/{orderId}")
    @SaCheckPermission("production:order:issue")
    public ResponseDTO<String> issue(@PathVariable Long orderId) {
        return productionOrderService.issue(orderId);
    }

    @Operation(summary = "完工")
    @GetMapping("/production/order/complete/{orderId}")
    @SaCheckPermission("production:order:update")
    public ResponseDTO<String> complete(@PathVariable Long orderId) {
        return productionOrderService.complete(orderId);
    }

    @Operation(summary = "删除指令单")
    @GetMapping("/production/order/delete/{orderId}")
    @SaCheckPermission("production:order:delete")
    public ResponseDTO<String> delete(@PathVariable Long orderId) {
        return productionOrderService.delete(orderId);
    }

    @Operation(summary = "反下达指令单")
    @GetMapping("/production/order/unissue/{orderId}")
    @SaCheckPermission("production:order:issue")
    public ResponseDTO<String> unissue(@PathVariable Long orderId) {
        return productionOrderService.unissue(orderId);
    }

    @Operation(summary = "批量删除指令单")
    @PostMapping("/production/order/batchDelete")
    @SaCheckPermission("production:order:delete")
    public ResponseDTO<String> batchDelete(@RequestBody List<Long> orderIds) {
        return productionOrderService.batchDelete(orderIds);
    }

    @Operation(summary = "批量完工")
    @PostMapping("/production/order/batchComplete")
    @SaCheckPermission("production:order:update")
    public ResponseDTO<String> batchComplete(@RequestBody List<Long> orderIds) {
        return productionOrderService.batchComplete(orderIds);
    }
}
