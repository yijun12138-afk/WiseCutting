package net.lab1024.sa.admin.module.business.cutting.order.domain.vo;

import cn.idev.excel.annotation.ExcelProperty;
import cn.idev.excel.annotation.write.style.ColumnWidth;
import lombok.Data;

@Data
@ColumnWidth(20)
public class CuttingOrderExcelVO {

    @ExcelProperty("裁床单号")
    private String cuttingOrderNo;

    @ExcelProperty("指令单号")
    private String orderNo;

    @ExcelProperty("客户")
    private String customerName;

    @ExcelProperty("款号")
    private String styleNo;

    @ExcelProperty("款名")
    private String styleName;

    @ExcelProperty("颜色")
    private String colorName;

    @ExcelProperty("尺码")
    private String sizeName;

    @ExcelProperty("数量")
    private Integer quantity;

    @ExcelProperty("床号")
    private String bedNo;

    @ExcelProperty("层数")
    private Integer layers;

    @ExcelProperty("面料编号")
    private String fabricNo;

    @ExcelProperty("面料名称")
    private String fabricName;

    @ExcelProperty("状态")
    private String statusName;

    @ExcelProperty("备注")
    private String remark;

    @ExcelProperty("创建人")
    private String createUserName;

    @ExcelProperty("创建时间")
    private String createTime;
}
