package net.lab1024.sa.admin.module.business.basic.customer.controller;

import cn.dev33.satoken.annotation.SaCheckPermission;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import jakarta.validation.Valid;
import net.lab1024.sa.admin.module.business.basic.customer.domain.form.CustomerAddForm;
import net.lab1024.sa.admin.module.business.basic.customer.domain.form.CustomerQueryForm;
import net.lab1024.sa.admin.module.business.basic.customer.domain.vo.CustomerVO;
import net.lab1024.sa.admin.module.business.basic.customer.service.CustomerService;
import net.lab1024.sa.base.common.domain.PageResult;
import net.lab1024.sa.base.common.domain.ResponseDTO;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@Tag(name = "基础管理-客户管理")
public class CustomerController {

    @Resource
    private CustomerService customerService;

    @Operation(summary = "客户分页查询")
    @PostMapping("/basic/customer/query")
    @SaCheckPermission("basic:customer:query")
    public ResponseDTO<PageResult<CustomerVO>> query(@RequestBody @Valid CustomerQueryForm queryForm) {
        return customerService.query(queryForm);
    }

    @Operation(summary = "客户列表（不分页）")
    @GetMapping("/basic/customer/listAll")
    public ResponseDTO<List<CustomerVO>> listAll() {
        return customerService.queryAll();
    }

    @Operation(summary = "新增/修改客户")
    @PostMapping("/basic/customer/addOrUpdate")
    @SaCheckPermission("basic:customer:add")
    public ResponseDTO<String> addOrUpdate(@RequestBody @Valid CustomerAddForm form) {
        return customerService.addOrUpdate(form);
    }

    @Operation(summary = "删除客户")
    @GetMapping("/basic/customer/delete/{customerId}")
    @SaCheckPermission("basic:customer:delete")
    public ResponseDTO<String> delete(@PathVariable Long customerId) {
        return customerService.delete(customerId);
    }

    @Operation(summary = "启用/停用客户")
    @PostMapping("/basic/customer/updateDisabledFlag")
    @SaCheckPermission("basic:customer:add")
    public ResponseDTO<String> updateDisabledFlag(@RequestParam Long customerId, @RequestParam Boolean disabledFlag) {
        return customerService.updateDisabledFlag(customerId, disabledFlag);
    }
}
