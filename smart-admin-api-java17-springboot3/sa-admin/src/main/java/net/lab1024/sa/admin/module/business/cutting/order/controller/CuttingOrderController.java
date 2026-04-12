package net.lab1024.sa.admin.module.business.cutting.order.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.Valid;
import net.lab1024.sa.admin.module.business.cutting.order.domain.form.CuttingOrderAddForm;
import net.lab1024.sa.admin.module.business.cutting.order.domain.form.CuttingOrderQueryForm;
import net.lab1024.sa.admin.module.business.cutting.order.domain.vo.CuttingOrderVO;
import net.lab1024.sa.admin.module.business.cutting.order.service.CuttingOrderService;
import net.lab1024.sa.base.common.domain.PageResult;
import net.lab1024.sa.base.common.domain.ResponseDTO;
import org.springframework.web.bind.annotation.*;
import java.io.IOException;

import java.util.List;

@RestController
@Tag(name = "裁剪数据-裁床单")
public class CuttingOrderController {

    @Resource
    private CuttingOrderService cuttingOrderService;

    @Operation(summary = "裁床单分页查询")
    @PostMapping("/cutting/order/query")
    public ResponseDTO<PageResult<CuttingOrderVO>> query(@RequestBody @Valid CuttingOrderQueryForm queryForm) {
        return cuttingOrderService.query(queryForm);
    }

    @Operation(summary = "新增/修改裁床单")
    @PostMapping("/cutting/order/addOrUpdate")
    public ResponseDTO<String> addOrUpdate(@RequestBody @Valid CuttingOrderAddForm form) {
        return cuttingOrderService.addOrUpdate(form);
    }

    @Operation(summary = "删除裁床单")
    @GetMapping("/cutting/order/delete/{cuttingOrderId}")
    public ResponseDTO<String> delete(@PathVariable Long cuttingOrderId) {
        return cuttingOrderService.delete(cuttingOrderId);
    }

    @Operation(summary = "导出裁床单Excel")
    @PostMapping("/cutting/order/export")
    public void export(@RequestBody CuttingOrderQueryForm queryForm, HttpServletResponse response) throws IOException {
        cuttingOrderService.export(queryForm, response);
    }

    @Operation(summary = "更新裁床单状态")
    @PostMapping("/cutting/order/updateStatus")
    public ResponseDTO<String> updateStatus(@RequestParam Long cuttingOrderId, @RequestParam Integer status) {
        return cuttingOrderService.updateStatus(cuttingOrderId, status);
    }

    @Operation(summary = "批量删除裁床单")
    @PostMapping("/cutting/order/batchDelete")
    public ResponseDTO<String> batchDelete(@RequestBody List<Long> ids) {
        return cuttingOrderService.batchDelete(ids);
    }

    @Operation(summary = "批量完成裁床单")
    @PostMapping("/cutting/order/batchComplete")
    public ResponseDTO<String> batchComplete(@RequestBody List<Long> ids) {
        return cuttingOrderService.batchComplete(ids);
    }
}
