package net.lab1024.sa.admin.module.business.home.vo;

import lombok.Data;
import java.util.List;

@Data
public class HomeStatVO {

    /** 统计概览 */
    private Long weekCuttingPlanCount;    // 本周裁剪计划数
    private Long weekCuttingOrderCount;   // 本周裁剪指令数
    private Long weekSpreadCount;         // 本周铺布任务数
    private Long weekProductionCompleteCount; // 本周生产完工数

    /** 本周铺布&松布&裁剪完工趋势（7天，周一到周日） */
    private List<Integer> spreadDailyComplete;  // 铺布每日完成数
    private List<Integer> relaxDailyComplete;   // 松布每日完成数
    private List<Integer> cuttingDailyComplete; // 裁剪每日完成数

    /** 指令单状态分布 */
    private Long orderStatusPlan;     // 计划
    private Long orderStatusIssued;   // 下达
    private Long orderStatusComplete; // 完工

    /** 本周裁剪指令趋势（每日新建/下达/完成） */
    private List<Integer> cuttingOrderDailyNew;      // 每日新建
    private List<Integer> cuttingOrderDailyIssued;   // 每日下达（状态2）
    private List<Integer> cuttingOrderDailyComplete; // 每日完成（状态3）
}
