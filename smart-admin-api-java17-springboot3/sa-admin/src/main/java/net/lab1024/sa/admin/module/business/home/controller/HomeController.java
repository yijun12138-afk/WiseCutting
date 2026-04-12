package net.lab1024.sa.admin.module.business.home.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import net.lab1024.sa.admin.module.business.home.service.HomeService;
import net.lab1024.sa.admin.module.business.home.vo.HomeStatVO;
import net.lab1024.sa.base.common.domain.ResponseDTO;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@Tag(name = "首页统计")
public class HomeController {

    @Resource
    private HomeService homeService;

    @Operation(summary = "首页统计数据")
    @GetMapping("/home/statistics")
    public ResponseDTO<HomeStatVO> statistics() {
        return homeService.getStatistics();
    }
}
