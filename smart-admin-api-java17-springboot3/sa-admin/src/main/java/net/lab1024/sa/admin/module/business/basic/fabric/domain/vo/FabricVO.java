package net.lab1024.sa.admin.module.business.basic.fabric.domain.vo;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class FabricVO {
    private Long fabricId;
    private String fabricName;
    private String fabricNo;
    private String fabricType;
    private String spec;
    private Long unitId;
    private String unitName;
    private BigDecimal gramWeight;
    private BigDecimal width;
    private Boolean disabledFlag;
    private String remark;
    private LocalDateTime createTime;
    private List<FabricSkuVO> skuList;
}
