package net.lab1024.sa.admin.module.business.basic.colorgroup.controller;

import cn.dev33.satoken.annotation.SaCheckPermission;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import jakarta.validation.Valid;
import net.lab1024.sa.admin.module.business.basic.colorgroup.domain.form.ColorGroupAddForm;
import net.lab1024.sa.admin.module.business.basic.colorgroup.domain.form.ColorGroupQueryForm;
import net.lab1024.sa.admin.module.business.basic.colorgroup.domain.vo.ColorGroupVO;
import net.lab1024.sa.admin.module.business.basic.colorgroup.service.ColorGroupService;
import net.lab1024.sa.base.common.domain.PageResult;
import net.lab1024.sa.base.common.domain.ResponseDTO;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@Tag(name = "基础管理-颜色组")
public class ColorGroupController {

    @Resource
    private ColorGroupService colorGroupService;

    @Operation(summary = "颜色组分页查询")
    @PostMapping("/basic/colorGroup/query")
    @SaCheckPermission("basic:styleColor:query")
    public ResponseDTO<PageResult<ColorGroupVO>> query(@RequestBody @Valid ColorGroupQueryForm queryForm) {
        return colorGroupService.query(queryForm);
    }

    @Operation(summary = "颜色组列表")
    @GetMapping("/basic/colorGroup/listAll")
    public ResponseDTO<List<ColorGroupVO>> listAll() {
        return colorGroupService.queryAll();
    }

    @Operation(summary = "新增/修改颜色组")
    @PostMapping("/basic/colorGroup/addOrUpdate")
    @SaCheckPermission("basic:styleColor:add")
    public ResponseDTO<String> addOrUpdate(@RequestBody @Valid ColorGroupAddForm form) {
        return colorGroupService.addOrUpdate(form);
    }

    @Operation(summary = "删除颜色组")
    @GetMapping("/basic/colorGroup/delete/{groupId}")
    @SaCheckPermission("basic:styleColor:delete")
    public ResponseDTO<String> delete(@PathVariable Long groupId) {
        return colorGroupService.delete(groupId);
    }
}
