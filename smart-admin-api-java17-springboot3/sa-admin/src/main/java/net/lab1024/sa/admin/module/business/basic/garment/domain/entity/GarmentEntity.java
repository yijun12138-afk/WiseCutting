package net.lab1024.sa.admin.module.business.basic.garment.domain.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 成衣 实体类
 */
@Data
@TableName("t_garment")
public class GarmentEntity {

    @TableId(type = IdType.AUTO)
    private Long garmentId;

    private String garmentName;
    private String garmentNo;
    private String garmentType;
    private String spec;
    private Long unitId;
    private String unitName;
    private BigDecimal price;
    private Boolean disabledFlag;
    private Boolean deletedFlag;
    private String remark;

    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
