package net.lab1024.sa.admin.module.business.basic.unit.controller;

import cn.dev33.satoken.annotation.SaCheckPermission;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import jakarta.validation.Valid;
import net.lab1024.sa.admin.module.business.basic.unit.domain.form.UnitAddForm;
import net.lab1024.sa.admin.module.business.basic.unit.domain.form.UnitQueryForm;
import net.lab1024.sa.admin.module.business.basic.unit.domain.vo.UnitVO;
import net.lab1024.sa.admin.module.business.basic.unit.service.UnitService;
import net.lab1024.sa.base.common.domain.PageResult;
import net.lab1024.sa.base.common.domain.ResponseDTO;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@Tag(name = "基础管理-单位管理")
public class UnitController {

    @Resource
    private UnitService unitService;

    @Operation(summary = "单位分页查询")
    @PostMapping("/basic/unit/query")
    @SaCheckPermission("basic:unit:query")
    public ResponseDTO<PageResult<UnitVO>> query(@RequestBody @Valid UnitQueryForm queryForm) {
        return unitService.query(queryForm);
    }

    @Operation(summary = "所有单位列表")
    @GetMapping("/basic/unit/listAll")
    public ResponseDTO<List<UnitVO>> listAll() {
        return unitService.queryAll();
    }

    @Operation(summary = "新增/修改单位")
    @PostMapping("/basic/unit/addOrUpdate")
    @SaCheckPermission("basic:unit:add")
    public ResponseDTO<String> addOrUpdate(@RequestBody @Valid UnitAddForm form) {
        return unitService.addOrUpdate(form);
    }

    @Operation(summary = "删除单位")
    @GetMapping("/basic/unit/delete/{unitId}")
    @SaCheckPermission("basic:unit:delete")
    public ResponseDTO<String> delete(@PathVariable Long unitId) {
        return unitService.delete(unitId);
    }
}
