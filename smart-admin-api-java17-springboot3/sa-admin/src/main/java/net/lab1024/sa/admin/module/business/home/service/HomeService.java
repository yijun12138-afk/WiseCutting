package net.lab1024.sa.admin.module.business.home.service;

import jakarta.annotation.Resource;
import net.lab1024.sa.admin.module.business.home.vo.HomeStatVO;
import net.lab1024.sa.admin.module.business.production.spread.dao.FabricSpreadDao;
import net.lab1024.sa.admin.module.business.production.relax.dao.FabricRelaxDao;
import net.lab1024.sa.admin.module.business.cutting.order.dao.CuttingOrderDao;
import net.lab1024.sa.admin.module.business.cutting.plan.dao.CuttingPlanDao;
import net.lab1024.sa.admin.module.business.production.order.dao.ProductionOrderDao;
import net.lab1024.sa.base.common.domain.ResponseDTO;
import org.springframework.stereotype.Service;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.TemporalAdjusters;
import java.util.ArrayList;
import java.util.List;

@Service
public class HomeService {

    @Resource
    private FabricSpreadDao fabricSpreadDao;
    @Resource
    private FabricRelaxDao fabricRelaxDao;
    @Resource
    private CuttingOrderDao cuttingOrderDao;
    @Resource
    private CuttingPlanDao cuttingPlanDao;
    @Resource
    private ProductionOrderDao productionOrderDao;

    public ResponseDTO<HomeStatVO> getStatistics() {
        HomeStatVO vo = new HomeStatVO();

        // 本周开始（周一）和结束（周日）
        LocalDate today = LocalDate.now();
        LocalDate weekStart = today.with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));
        LocalDate weekEnd = weekStart.plusDays(6);

        LocalDateTime weekStartTime = weekStart.atStartOfDay();
        LocalDateTime weekEndTime = weekEnd.atTime(23, 59, 59);

        // === 统计概览 ===
        vo.setWeekCuttingPlanCount(cuttingPlanDao.countByCreateTimeBetween(weekStartTime, weekEndTime));
        vo.setWeekCuttingOrderCount(cuttingOrderDao.countByCreateTimeBetween(weekStartTime, weekEndTime));
        vo.setWeekSpreadCount(fabricSpreadDao.countByCreateTimeBetween(weekStartTime, weekEndTime));
        vo.setWeekProductionCompleteCount(productionOrderDao.countCompleteByCreateTimeBetween(weekStartTime, weekEndTime));

        // === 本周铺布&松布&裁剪完工趋势（7天） ===
        List<Integer> spreadDaily = new ArrayList<>();
        List<Integer> relaxDaily = new ArrayList<>();
        List<Integer> cuttingDaily = new ArrayList<>();

        for (int i = 0; i < 7; i++) {
            LocalDate day = weekStart.plusDays(i);
            LocalDateTime dayStart = day.atStartOfDay();
            LocalDateTime dayEnd = day.atTime(23, 59, 59);
            spreadDaily.add(fabricSpreadDao.countCompleteByDay(dayStart, dayEnd).intValue());
            relaxDaily.add(fabricRelaxDao.countCompleteByDay(dayStart, dayEnd).intValue());
            cuttingDaily.add(cuttingOrderDao.countCompleteByDay(dayStart, dayEnd).intValue());
        }
        vo.setSpreadDailyComplete(spreadDaily);
        vo.setRelaxDailyComplete(relaxDaily);
        vo.setCuttingDailyComplete(cuttingDaily);

        // === 指令单状态分布 ===
        vo.setOrderStatusPlan(productionOrderDao.countByStatus(1));
        vo.setOrderStatusIssued(productionOrderDao.countByStatus(2));
        vo.setOrderStatusComplete(productionOrderDao.countByStatus(3));

        // === 本周裁剪指令趋势 ===
        List<Integer> cuttingNew = new ArrayList<>();
        List<Integer> cuttingIssued = new ArrayList<>();
        List<Integer> cuttingComplete = new ArrayList<>();

        for (int i = 0; i < 7; i++) {
            LocalDate day = weekStart.plusDays(i);
            LocalDateTime dayStart = day.atStartOfDay();
            LocalDateTime dayEnd = day.atTime(23, 59, 59);
            cuttingNew.add(cuttingOrderDao.countByStatusAndDay(1, dayStart, dayEnd).intValue());
            cuttingIssued.add(cuttingOrderDao.countByStatusAndDay(2, dayStart, dayEnd).intValue());
            cuttingComplete.add(cuttingOrderDao.countByStatusAndDay(3, dayStart, dayEnd).intValue());
        }
        vo.setCuttingOrderDailyNew(cuttingNew);
        vo.setCuttingOrderDailyIssued(cuttingIssued);
        vo.setCuttingOrderDailyComplete(cuttingComplete);

        return ResponseDTO.ok(vo);
    }
}
