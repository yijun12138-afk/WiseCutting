package net.lab1024.sa.admin.module.business.basic.sizegroup.domain.vo;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class SizeGroupVO {
    private Long groupId;
    private String groupName;
    private String remark;
    private LocalDateTime createTime;
}
