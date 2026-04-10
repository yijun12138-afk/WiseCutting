package net.lab1024.sa.admin.module.business.basic.cuttingpart.domain.vo;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class CuttingPartVO {
    private Long partId;
    private String partName;
    private String partCode;
    private String remark;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
