package net.lab1024.sa.admin.module.business.basic.fabric.controller;

import cn.dev33.satoken.annotation.SaCheckPermission;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import jakarta.validation.Valid;
import net.lab1024.sa.admin.module.business.basic.fabric.domain.form.FabricAddForm;
import net.lab1024.sa.admin.module.business.basic.fabric.domain.form.FabricQueryForm;
import net.lab1024.sa.admin.module.business.basic.fabric.domain.vo.FabricSkuVO;
import net.lab1024.sa.admin.module.business.basic.fabric.domain.vo.FabricVO;
import net.lab1024.sa.admin.module.business.basic.fabric.service.FabricService;
import net.lab1024.sa.base.common.domain.PageResult;
import net.lab1024.sa.base.common.domain.ResponseDTO;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@Tag(name = "基础管理-面料列表")
public class FabricController {

    @Resource
    private FabricService fabricService;

    @Operation(summary = "面料分页查询")
    @PostMapping("/basic/fabric/query")
    @SaCheckPermission("basic:fabric:query")
    public ResponseDTO<PageResult<FabricVO>> query(@RequestBody @Valid FabricQueryForm queryForm) {
        return fabricService.query(queryForm);
    }

    @Operation(summary = "所有面料列表")
    @GetMapping("/basic/fabric/listAll")
    public ResponseDTO<List<FabricVO>> listAll() {
        return fabricService.queryAll();
    }

    @Operation(summary = "面料SKU列表（颜色）")
    @GetMapping("/basic/fabric/skuList/{fabricId}")
    public ResponseDTO<List<FabricSkuVO>> skuList(@PathVariable Long fabricId) {
        return fabricService.querySkuList(fabricId);
    }

    @Operation(summary = "新增/修改面料")
    @PostMapping("/basic/fabric/addOrUpdate")
    @SaCheckPermission("basic:fabric:add")
    public ResponseDTO<String> addOrUpdate(@RequestBody @Valid FabricAddForm form) {
        return fabricService.addOrUpdate(form);
    }

    @Operation(summary = "删除面料")
    @GetMapping("/basic/fabric/delete/{fabricId}")
    @SaCheckPermission("basic:fabric:delete")
    public ResponseDTO<String> delete(@PathVariable Long fabricId) {
        return fabricService.delete(fabricId);
    }

    @Operation(summary = "启用/停用面料")
    @PostMapping("/basic/fabric/updateDisabledFlag")
    @SaCheckPermission("basic:fabric:add")
    public ResponseDTO<String> updateDisabledFlag(@RequestParam Long fabricId, @RequestParam Boolean disabledFlag) {
        return fabricService.updateDisabledFlag(fabricId, disabledFlag);
    }
}
