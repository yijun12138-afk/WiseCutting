package net.lab1024.sa.admin.module.business.basic.stylecolor.controller;

import cn.dev33.satoken.annotation.SaCheckPermission;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import jakarta.validation.Valid;
import net.lab1024.sa.admin.module.business.basic.stylecolor.domain.form.StyleColorAddForm;
import net.lab1024.sa.admin.module.business.basic.stylecolor.domain.form.StyleColorQueryForm;
import net.lab1024.sa.admin.module.business.basic.stylecolor.domain.vo.StyleColorVO;
import net.lab1024.sa.admin.module.business.basic.stylecolor.service.StyleColorService;
import net.lab1024.sa.base.common.domain.PageResult;
import net.lab1024.sa.base.common.domain.ResponseDTO;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@Tag(name = "基础管理-款式颜色")
public class StyleColorController {

    @Resource
    private StyleColorService styleColorService;

    @Operation(summary = "款式颜色分页查询")
    @PostMapping("/basic/styleColor/query")
    @SaCheckPermission("basic:styleColor:query")
    public ResponseDTO<PageResult<StyleColorVO>> query(@RequestBody @Valid StyleColorQueryForm queryForm) {
        return styleColorService.query(queryForm);
    }

    @Operation(summary = "所有颜色列表")
    @GetMapping("/basic/styleColor/listAll")
    public ResponseDTO<List<StyleColorVO>> listAll() {
        return styleColorService.queryAll();
    }

    @Operation(summary = "新增/修改颜色")
    @PostMapping("/basic/styleColor/addOrUpdate")
    @SaCheckPermission("basic:styleColor:add")
    public ResponseDTO<String> addOrUpdate(@RequestBody @Valid StyleColorAddForm form) {
        return styleColorService.addOrUpdate(form);
    }

    @Operation(summary = "删除颜色")
    @GetMapping("/basic/styleColor/delete/{colorId}")
    @SaCheckPermission("basic:styleColor:delete")
    public ResponseDTO<String> delete(@PathVariable Long colorId) {
        return styleColorService.delete(colorId);
    }
}
