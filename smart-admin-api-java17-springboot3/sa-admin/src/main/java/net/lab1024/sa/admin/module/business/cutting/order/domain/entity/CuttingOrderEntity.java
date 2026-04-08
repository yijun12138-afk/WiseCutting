package net.lab1024.sa.admin.module.business.cutting.order.domain.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("t_cutting_order")
public class CuttingOrderEntity {
    @TableId(type = IdType.AUTO)
    private Long cuttingOrderId;
    private String cuttingOrderNo;
    private Long planId;
    private String planNo;
    private Long orderId;
    private String orderNo;
    private String customerName;
    private String styleNo;
    private String styleName;
    private String colorName;
    private String sizeName;
    private Integer quantity;
    private String bedNo;
    private Integer layers;
    private String fabricNo;
    private String fabricName;
    /** 状态: 1-待裁, 2-裁剪中, 3-完成 */
    private Integer status;
    private Boolean deletedFlag;
    private String remark;
    private Long createUserId;
    private String createUserName;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
