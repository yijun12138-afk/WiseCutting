package net.lab1024.sa.admin.module.business.production.spread.controller;

import cn.dev33.satoken.annotation.SaCheckPermission;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import jakarta.validation.Valid;
import net.lab1024.sa.admin.module.business.production.spread.domain.form.FabricSpreadAddForm;
import net.lab1024.sa.admin.module.business.production.spread.domain.form.FabricSpreadCompleteForm;
import net.lab1024.sa.admin.module.business.production.spread.domain.form.FabricSpreadQueryForm;
import net.lab1024.sa.admin.module.business.production.spread.domain.vo.FabricSpreadVO;
import net.lab1024.sa.admin.module.business.production.spread.service.FabricSpreadService;
import net.lab1024.sa.base.common.domain.PageResult;
import net.lab1024.sa.base.common.domain.ResponseDTO;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@Tag(name = "生产管理-铺布管理")
public class FabricSpreadController {

    @Resource
    private FabricSpreadService fabricSpreadService;

    @Operation(summary = "铺布任务分页查询")
    @PostMapping("/production/spread/query")
    @SaCheckPermission("production:spread:query")
    public ResponseDTO<PageResult<FabricSpreadVO>> query(@RequestBody @Valid FabricSpreadQueryForm queryForm) {
        return fabricSpreadService.query(queryForm);
    }

    @Operation(summary = "铺布工作台列表（已下发）")
    @PostMapping("/production/spread/workbench")
    @SaCheckPermission("production:spread:query")
    public ResponseDTO<List<FabricSpreadVO>> workbench(@RequestBody FabricSpreadQueryForm queryForm) {
        return fabricSpreadService.queryWorkbench(queryForm);
    }

    @Operation(summary = "保存铺布任务")
    @PostMapping("/production/spread/save")
    @SaCheckPermission("production:spread:add")
    public ResponseDTO<String> save(@RequestBody @Valid FabricSpreadAddForm form) {
        return fabricSpreadService.addOrUpdate(form);
    }

    @Operation(summary = "保存并下发铺布任务")
    @PostMapping("/production/spread/saveAndIssue")
    @SaCheckPermission("production:spread:issue")
    public ResponseDTO<String> saveAndIssue(@RequestBody @Valid FabricSpreadAddForm form) {
        return fabricSpreadService.saveAndIssue(form);
    }

    @Operation(summary = "完成铺布任务")
    @PostMapping("/production/spread/complete")
    @SaCheckPermission("production:spread:query")
    public ResponseDTO<String> complete(@RequestBody @Valid FabricSpreadCompleteForm form) {
        return fabricSpreadService.complete(form);
    }

    @Operation(summary = "删除铺布任务")
    @GetMapping("/production/spread/delete/{spreadId}")
    @SaCheckPermission("production:spread:query")
    public ResponseDTO<String> delete(@PathVariable Long spreadId) {
        return fabricSpreadService.delete(spreadId);
    }

    @Operation(summary = "批量删除铺布任务")
    @PostMapping("/production/spread/batchDelete")
    @SaCheckPermission("production:spread:query")
    public ResponseDTO<String> batchDelete(@RequestBody List<Long> spreadIds) {
        return fabricSpreadService.batchDelete(spreadIds);
    }

    @Operation(summary = "反下达铺布任务")
    @GetMapping("/production/spread/unissue/{spreadId}")
    @SaCheckPermission("production:spread:issue")
    public ResponseDTO<String> unissue(@PathVariable Long spreadId) {
        return fabricSpreadService.unissue(spreadId);
    }

    @Operation(summary = "批量完成铺布任务")
    @PostMapping("/production/spread/batchComplete")
    @SaCheckPermission("production:spread:query")
    public ResponseDTO<String> batchComplete(@RequestBody List<Long> spreadIds) {
        return fabricSpreadService.batchComplete(spreadIds);
    }
}
