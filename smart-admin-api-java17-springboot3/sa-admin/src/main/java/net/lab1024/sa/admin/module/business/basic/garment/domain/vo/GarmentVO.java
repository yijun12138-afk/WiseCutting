package net.lab1024.sa.admin.module.business.basic.garment.domain.vo;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class GarmentVO {
    private Long garmentId;
    private String garmentName;
    private String garmentNo;
    private String garmentType;
    private String spec;
    private Long unitId;
    private String unitName;
    private BigDecimal price;
    private Boolean disabledFlag;
    private String remark;
    private LocalDateTime createTime;
    private List<GarmentSkuVO> skuList;
}
