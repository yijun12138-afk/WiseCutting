package net.lab1024.sa.admin.module.business.basic.sizegroup.controller;

import cn.dev33.satoken.annotation.SaCheckPermission;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import jakarta.validation.Valid;
import net.lab1024.sa.admin.module.business.basic.sizegroup.domain.form.SizeGroupAddForm;
import net.lab1024.sa.admin.module.business.basic.sizegroup.domain.form.SizeGroupQueryForm;
import net.lab1024.sa.admin.module.business.basic.sizegroup.domain.vo.SizeGroupVO;
import net.lab1024.sa.admin.module.business.basic.sizegroup.service.SizeGroupService;
import net.lab1024.sa.base.common.domain.PageResult;
import net.lab1024.sa.base.common.domain.ResponseDTO;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@Tag(name = "基础管理-尺码组")
public class SizeGroupController {

    @Resource
    private SizeGroupService sizeGroupService;

    @Operation(summary = "尺码组分页查询")
    @PostMapping("/basic/sizeGroup/query")
    @SaCheckPermission("basic:size:query")
    public ResponseDTO<PageResult<SizeGroupVO>> query(@RequestBody @Valid SizeGroupQueryForm queryForm) {
        return sizeGroupService.query(queryForm);
    }

    @Operation(summary = "尺码组列表")
    @GetMapping("/basic/sizeGroup/listAll")
    public ResponseDTO<List<SizeGroupVO>> listAll() {
        return sizeGroupService.queryAll();
    }

    @Operation(summary = "新增/修改尺码组")
    @PostMapping("/basic/sizeGroup/addOrUpdate")
    @SaCheckPermission("basic:size:add")
    public ResponseDTO<String> addOrUpdate(@RequestBody @Valid SizeGroupAddForm form) {
        return sizeGroupService.addOrUpdate(form);
    }

    @Operation(summary = "删除尺码组")
    @GetMapping("/basic/sizeGroup/delete/{groupId}")
    @SaCheckPermission("basic:size:delete")
    public ResponseDTO<String> delete(@PathVariable Long groupId) {
        return sizeGroupService.delete(groupId);
    }
}
