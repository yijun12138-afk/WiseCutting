package net.lab1024.sa.admin.module.business.production.order.domain.form;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Data
public class ProductionOrderAddForm {

    @Schema(description = "订单ID（修改时必填）")
    private Long orderId;

    @Schema(description = "单据编号")
    private String orderNo;

    @NotNull(message = "客户不能为空")
    private Long customerId;
    private String customerName;

    @NotBlank(message = "款号不能为空")
    private String styleNo;

    @NotBlank(message = "款名不能为空")
    private String styleName;

    @NotNull(message = "交货日期不能为空")
    private LocalDate deliveryDate;

    private BigDecimal unitPrice;
    private String remark;

    @Schema(description = "颜色尺码明细")
    private List<OrderDetailForm> detailList;

    @Schema(description = "面料信息")
    private List<OrderFabricForm> fabricList;

    @Schema(description = "流程工序")
    private List<OrderProcessForm> processList;
}
