package net.lab1024.sa.admin.module.business.basic.cuttingpart.controller;

import cn.dev33.satoken.annotation.SaCheckPermission;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import jakarta.validation.Valid;
import net.lab1024.sa.admin.module.business.basic.cuttingpart.domain.form.CuttingPartAddForm;
import net.lab1024.sa.admin.module.business.basic.cuttingpart.domain.form.CuttingPartQueryForm;
import net.lab1024.sa.admin.module.business.basic.cuttingpart.domain.vo.CuttingPartVO;
import net.lab1024.sa.admin.module.business.basic.cuttingpart.service.CuttingPartService;
import net.lab1024.sa.base.common.domain.PageResult;
import net.lab1024.sa.base.common.domain.ResponseDTO;
import org.springframework.web.bind.annotation.*;

@RestController
@Tag(name = "基础管理-裁片部位")
public class CuttingPartController {

    @Resource
    private CuttingPartService cuttingPartService;

    @Operation(summary = "裁片部位分页查询")
    @PostMapping("/basic/cuttingPart/query")
    @SaCheckPermission("basic:cuttingPart:query")
    public ResponseDTO<PageResult<CuttingPartVO>> query(@RequestBody @Valid CuttingPartQueryForm queryForm) {
        return cuttingPartService.query(queryForm);
    }

    @Operation(summary = "新增/修改裁片部位")
    @PostMapping("/basic/cuttingPart/addOrUpdate")
    @SaCheckPermission("basic:cuttingPart:add")
    public ResponseDTO<String> addOrUpdate(@RequestBody @Valid CuttingPartAddForm form) {
        return cuttingPartService.addOrUpdate(form);
    }

    @Operation(summary = "删除裁片部位")
    @GetMapping("/basic/cuttingPart/delete/{partId}")
    @SaCheckPermission("basic:cuttingPart:delete")
    public ResponseDTO<String> delete(@PathVariable Long partId) {
        return cuttingPartService.delete(partId);
    }
}
