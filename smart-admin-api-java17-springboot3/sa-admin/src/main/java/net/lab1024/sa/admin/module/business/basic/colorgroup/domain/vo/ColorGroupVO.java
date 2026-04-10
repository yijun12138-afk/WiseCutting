package net.lab1024.sa.admin.module.business.basic.colorgroup.domain.vo;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class ColorGroupVO {
    private Long groupId;
    private String groupName;
    private String remark;
    private LocalDateTime createTime;
}
