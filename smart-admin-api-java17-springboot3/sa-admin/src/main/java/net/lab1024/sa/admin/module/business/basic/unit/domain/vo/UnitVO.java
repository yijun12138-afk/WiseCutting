package net.lab1024.sa.admin.module.business.basic.unit.domain.vo;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class UnitVO {
    private Long unitId;
    private String unitName;
    private String unitCode;
    private String remark;
    private String createUserName;
    private String updateUserName;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
