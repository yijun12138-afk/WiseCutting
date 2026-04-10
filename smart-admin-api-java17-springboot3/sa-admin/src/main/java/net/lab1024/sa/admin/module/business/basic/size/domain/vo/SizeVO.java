package net.lab1024.sa.admin.module.business.basic.size.domain.vo;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class SizeVO {
    private Long sizeId;
    private Long sizeGroupId;
    private String sizeGroupName;
    private String sizeName;
    private Integer sort;
    private String remark;
    private LocalDateTime createTime;
}
