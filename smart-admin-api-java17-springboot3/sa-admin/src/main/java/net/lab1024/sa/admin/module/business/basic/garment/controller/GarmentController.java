package net.lab1024.sa.admin.module.business.basic.garment.controller;

import cn.dev33.satoken.annotation.SaCheckPermission;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import jakarta.validation.Valid;
import net.lab1024.sa.admin.module.business.basic.garment.domain.form.GarmentAddForm;
import net.lab1024.sa.admin.module.business.basic.garment.domain.form.GarmentQueryForm;
import net.lab1024.sa.admin.module.business.basic.garment.domain.vo.GarmentVO;
import java.util.List;
import net.lab1024.sa.admin.module.business.basic.garment.service.GarmentService;
import net.lab1024.sa.base.common.domain.PageResult;
import net.lab1024.sa.base.common.domain.ResponseDTO;
import org.springframework.web.bind.annotation.*;

@RestController
@Tag(name = "基础管理-成衣列表")
public class GarmentController {

    @Resource
    private GarmentService garmentService;

    @Operation(summary = "成衣分页查询")
    @PostMapping("/basic/garment/query")
    @SaCheckPermission("basic:garment:query")
    public ResponseDTO<PageResult<GarmentVO>> query(@RequestBody @Valid GarmentQueryForm queryForm) {
        return garmentService.query(queryForm);
    }

    @Operation(summary = "所有成衣列表")
    @GetMapping("/basic/garment/listAll")
    public ResponseDTO<List<GarmentVO>> listAll() {
        return garmentService.queryAll();
    }

    @Operation(summary = "新增/修改成衣")
    @PostMapping("/basic/garment/addOrUpdate")
    @SaCheckPermission("basic:garment:add")
    public ResponseDTO<String> addOrUpdate(@RequestBody @Valid GarmentAddForm form) {
        return garmentService.addOrUpdate(form);
    }

    @Operation(summary = "删除成衣")
    @GetMapping("/basic/garment/delete/{garmentId}")
    @SaCheckPermission("basic:garment:delete")
    public ResponseDTO<String> delete(@PathVariable Long garmentId) {
        return garmentService.delete(garmentId);
    }

    @Operation(summary = "启用/停用成衣")
    @PostMapping("/basic/garment/updateDisabledFlag")
    @SaCheckPermission("basic:garment:add")
    public ResponseDTO<String> updateDisabledFlag(@RequestParam Long garmentId, @RequestParam Boolean disabledFlag) {
        return garmentService.updateDisabledFlag(garmentId, disabledFlag);
    }
}
