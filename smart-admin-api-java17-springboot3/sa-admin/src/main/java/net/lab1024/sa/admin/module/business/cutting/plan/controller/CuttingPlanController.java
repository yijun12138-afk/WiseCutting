package net.lab1024.sa.admin.module.business.cutting.plan.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import jakarta.validation.Valid;
import net.lab1024.sa.admin.module.business.cutting.plan.domain.form.CuttingPlanAddForm;
import net.lab1024.sa.admin.module.business.cutting.plan.domain.form.CuttingPlanQueryForm;
import net.lab1024.sa.admin.module.business.cutting.plan.domain.vo.CuttingPlanVO;
import net.lab1024.sa.admin.module.business.cutting.plan.service.CuttingPlanService;
import net.lab1024.sa.base.common.domain.PageResult;
import net.lab1024.sa.base.common.domain.ResponseDTO;
import org.springframework.web.bind.annotation.*;

@RestController
@Tag(name = "裁剪数据-裁剪计划")
public class CuttingPlanController {

    @Resource
    private CuttingPlanService cuttingPlanService;

    @Operation(summary = "裁剪计划分页查询")
    @PostMapping("/cutting/plan/query")
    public ResponseDTO<PageResult<CuttingPlanVO>> query(@RequestBody @Valid CuttingPlanQueryForm queryForm) {
        return cuttingPlanService.query(queryForm);
    }

    @Operation(summary = "新增/修改裁剪计划")
    @PostMapping("/cutting/plan/addOrUpdate")
    public ResponseDTO<String> addOrUpdate(@RequestBody @Valid CuttingPlanAddForm form) {
        return cuttingPlanService.addOrUpdate(form);
    }

    @Operation(summary = "删除裁剪计划")
    @GetMapping("/cutting/plan/delete/{planId}")
    public ResponseDTO<String> delete(@PathVariable Long planId) {
        return cuttingPlanService.delete(planId);
    }
}
