package net.lab1024.sa.admin.module.business.basic.size.controller;

import cn.dev33.satoken.annotation.SaCheckPermission;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import jakarta.validation.Valid;
import net.lab1024.sa.admin.module.business.basic.size.domain.form.SizeAddForm;
import net.lab1024.sa.admin.module.business.basic.size.domain.form.SizeQueryForm;
import net.lab1024.sa.admin.module.business.basic.size.domain.vo.SizeVO;
import net.lab1024.sa.admin.module.business.basic.size.service.SizeService;
import net.lab1024.sa.base.common.domain.PageResult;
import net.lab1024.sa.base.common.domain.ResponseDTO;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@Tag(name = "基础管理-尺寸列表")
public class SizeController {

    @Resource
    private SizeService sizeService;

    @Operation(summary = "尺寸分页查询")
    @PostMapping("/basic/size/query")
    @SaCheckPermission("basic:size:query")
    public ResponseDTO<PageResult<SizeVO>> query(@RequestBody @Valid SizeQueryForm queryForm) {
        return sizeService.query(queryForm);
    }

    @Operation(summary = "所有尺码列表")
    @GetMapping("/basic/size/listAll")
    public ResponseDTO<List<SizeVO>> listAll() {
        return sizeService.queryAll();
    }

    @Operation(summary = "新增/修改尺码")
    @PostMapping("/basic/size/addOrUpdate")
    @SaCheckPermission("basic:size:add")
    public ResponseDTO<String> addOrUpdate(@RequestBody @Valid SizeAddForm form) {
        return sizeService.addOrUpdate(form);
    }

    @Operation(summary = "删除尺码")
    @GetMapping("/basic/size/delete/{sizeId}")
    @SaCheckPermission("basic:size:delete")
    public ResponseDTO<String> delete(@PathVariable Long sizeId) {
        return sizeService.delete(sizeId);
    }
}
