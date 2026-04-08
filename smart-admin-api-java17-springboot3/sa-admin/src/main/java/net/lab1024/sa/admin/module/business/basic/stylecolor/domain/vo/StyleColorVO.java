package net.lab1024.sa.admin.module.business.basic.stylecolor.domain.vo;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class StyleColorVO {
    private Long colorId;
    private String styleNo;
    private String colorName;
    private String colorCode;
    private String remark;
    private String createUserName;
    private LocalDateTime createTime;
}
