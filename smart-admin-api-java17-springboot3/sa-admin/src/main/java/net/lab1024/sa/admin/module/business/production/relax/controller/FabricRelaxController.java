package net.lab1024.sa.admin.module.business.production.relax.controller;

import cn.dev33.satoken.annotation.SaCheckPermission;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import jakarta.validation.Valid;
import net.lab1024.sa.admin.module.business.production.relax.domain.form.FabricRelaxAddForm;
import net.lab1024.sa.admin.module.business.production.relax.domain.form.FabricRelaxQueryForm;
import net.lab1024.sa.admin.module.business.production.relax.domain.vo.FabricRelaxVO;
import net.lab1024.sa.admin.module.business.production.relax.service.FabricRelaxService;
import net.lab1024.sa.base.common.domain.PageResult;
import net.lab1024.sa.base.common.domain.ResponseDTO;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@Tag(name = "生产管理-松布管理")
public class FabricRelaxController {

    @Resource
    private FabricRelaxService fabricRelaxService;

    @Operation(summary = "松布任务分页查询")
    @PostMapping("/production/relax/query")
    @SaCheckPermission("production:relax:query")
    public ResponseDTO<PageResult<FabricRelaxVO>> query(@RequestBody @Valid FabricRelaxQueryForm queryForm) {
        return fabricRelaxService.query(queryForm);
    }

    @Operation(summary = "新增/修改松布任务")
    @PostMapping("/production/relax/addOrUpdate")
    @SaCheckPermission("production:relax:add")
    public ResponseDTO<String> addOrUpdate(@RequestBody @Valid FabricRelaxAddForm form) {
        return fabricRelaxService.addOrUpdate(form);
    }

    @Operation(summary = "删除松布任务")
    @GetMapping("/production/relax/delete/{relaxId}")
    @SaCheckPermission("production:relax:query")
    public ResponseDTO<String> delete(@PathVariable Long relaxId) {
        return fabricRelaxService.delete(relaxId);
    }

    @Operation(summary = "批量删除松布任务")
    @PostMapping("/production/relax/batchDelete")
    @SaCheckPermission("production:relax:query")
    public ResponseDTO<String> batchDelete(@RequestBody List<Long> relaxIds) {
        return fabricRelaxService.batchDelete(relaxIds);
    }

    @Operation(summary = "更新松布任务状态")
    @PostMapping("/production/relax/updateStatus")
    @SaCheckPermission("production:relax:add")
    public ResponseDTO<String> updateStatus(@RequestParam Long relaxId, @RequestParam Integer status) {
        return fabricRelaxService.updateStatus(relaxId, status);
    }
}
