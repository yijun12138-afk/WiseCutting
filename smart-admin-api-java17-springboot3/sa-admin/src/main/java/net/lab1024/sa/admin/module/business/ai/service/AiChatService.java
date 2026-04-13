package net.lab1024.sa.admin.module.business.ai.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.annotation.Resource;
import net.lab1024.sa.admin.module.business.ai.domain.AiChatForm;
import net.lab1024.sa.base.common.domain.ResponseDTO;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.LocalDate;
import java.time.DayOfWeek;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Service
public class AiChatService {

    @Resource
    private JdbcTemplate jdbcTemplate;

    private static final String API_KEY = "sk-api-VpqBu7mFyrb1QfjHmCN0IZ9QqcK7s3kZAk34SnmqLnxm3cYF-69Bj8D-V3TYhztmKHljnSgCUIbztwJ2BPb2MsrSRlo3pS6xXNuka_I-iiiZBQeviir9T5A";
    private static final String API_URL = "https://api.minimax.chat/v1/text/chatcompletion_v2";
    private static final String MODEL = "MiniMax-M2";

    public ResponseDTO<String> chat(AiChatForm form) {
        String userMessage = form.getMessage();
        if (userMessage == null || userMessage.trim().isEmpty()) {
            return ResponseDTO.userErrorParam("消息不能为空");
        }

        // 查询相关数据构建上下文
        String context = buildContext(userMessage);

        // 调用AI API
        String answer = callAiApi(userMessage, context);
        return ResponseDTO.ok(answer);
    }

    private String buildContext(String message) {
        StringBuilder ctx = new StringBuilder();

        // 提取生产指令单号 (SC开头)
        List<String> orderNos = extractPatterns(message, "(SC\\d+)");
        for (String orderNo : orderNos) {
            try {
                List<Map<String, Object>> orders = jdbcTemplate.queryForList(
                    "SELECT o.order_id, o.order_no, o.customer_name, o.style_no, o.style_name, " +
                    "o.order_quantity, o.status, o.create_time, o.update_time, " +
                    "CASE o.status WHEN 0 THEN '草稿' WHEN 1 THEN '已下达' WHEN 2 THEN '生产中' WHEN 3 THEN '已完工' ELSE '未知' END AS status_name " +
                    "FROM t_production_order o WHERE o.order_no = ? AND o.deleted_flag = 0", orderNo);
                if (!orders.isEmpty()) {
                    ctx.append("【生产指令单 ").append(orderNo).append("】\n");
                    Map<String, Object> o = orders.get(0);
                    ctx.append("状态: ").append(o.get("status_name")).append("\n");
                    ctx.append("客户: ").append(o.get("customer_name")).append("\n");
                    ctx.append("款号: ").append(o.get("style_no")).append(" 款名: ").append(o.get("style_name")).append("\n");
                    ctx.append("订单数量: ").append(o.get("order_quantity")).append("\n");
                    ctx.append("创建时间: ").append(o.get("create_time")).append("\n");

                    // 查铺布任务
                    Long orderId = ((Number) o.get("order_id")).longValue();
                    List<Map<String, Object>> spreads = jdbcTemplate.queryForList(
                        "SELECT fabric_name, color_name, require_length, actual_length, status, " +
                        "CASE status WHEN 0 THEN '未开始' WHEN 1 THEN '进行中' WHEN 2 THEN '已完成' ELSE '未知' END AS status_name " +
                        "FROM t_fabric_spread WHERE order_id = ? AND deleted_flag = 0", orderId);
                    if (!spreads.isEmpty()) {
                        ctx.append("铺布任务(共").append(spreads.size()).append("条):\n");
                        for (Map<String, Object> s : spreads) {
                            ctx.append("  面料:").append(s.get("fabric_name"))
                               .append(" 颜色:").append(s.get("color_name"))
                               .append(" 状态:").append(s.get("status_name")).append("\n");
                        }
                    }

                    // 查松布任务
                    List<Map<String, Object>> relaxes = jdbcTemplate.queryForList(
                        "SELECT fabric_name, color_name, require_length, status, " +
                        "CASE status WHEN 0 THEN '未开始' WHEN 1 THEN '进行中' WHEN 2 THEN '静置完成' WHEN 3 THEN '已结束' ELSE '未知' END AS status_name " +
                        "FROM t_fabric_relax WHERE order_id = ? AND relax_type = 1 AND deleted_flag = 0", orderId);
                    if (!relaxes.isEmpty()) {
                        ctx.append("松布任务(共").append(relaxes.size()).append("条):\n");
                        for (Map<String, Object> r : relaxes) {
                            ctx.append("  面料:").append(r.get("fabric_name"))
                               .append(" 颜色:").append(r.get("color_name"))
                               .append(" 状态:").append(r.get("status_name")).append("\n");
                        }
                    }

                    // 查裁剪计划
                    List<Map<String, Object>> cuttingPlans = jdbcTemplate.queryForList(
                        "SELECT plan_no, cutting_part_name, plan_quantity, status, " +
                        "CASE status WHEN 0 THEN '未开始' WHEN 1 THEN '进行中' WHEN 2 THEN '已完成' ELSE '未知' END AS status_name " +
                        "FROM t_cutting_plan WHERE order_id = ? AND deleted_flag = 0", orderId);
                    if (!cuttingPlans.isEmpty()) {
                        ctx.append("裁剪计划(共").append(cuttingPlans.size()).append("条):\n");
                        for (Map<String, Object> cp : cuttingPlans) {
                            ctx.append("  计划号:").append(cp.get("plan_no"))
                               .append(" 裁片:").append(cp.get("cutting_part_name"))
                               .append(" 状态:").append(cp.get("status_name")).append("\n");
                        }
                    }
                }
            } catch (Exception e) {
                // 忽略查询错误
            }
        }

        // 提取裁剪单号 (CO开头)
        List<String> cuttingOrderNos = extractPatterns(message, "(CO\\d+)");
        for (String coNo : cuttingOrderNos) {
            try {
                List<Map<String, Object>> cos = jdbcTemplate.queryForList(
                    "SELECT co.cutting_order_no, co.order_no, co.garment_name, co.cutting_quantity, co.status, " +
                    "CASE co.status WHEN 0 THEN '草稿' WHEN 1 THEN '待裁剪' WHEN 2 THEN '裁剪中' WHEN 3 THEN '已完工' ELSE '未知' END AS status_name, " +
                    "co.create_time " +
                    "FROM t_cutting_order co WHERE co.cutting_order_no = ? AND co.deleted_flag = 0", coNo);
                if (!cos.isEmpty()) {
                    ctx.append("【裁剪单 ").append(coNo).append("】\n");
                    Map<String, Object> co = cos.get(0);
                    ctx.append("关联指令单: ").append(co.get("order_no")).append("\n");
                    ctx.append("款式: ").append(co.get("garment_name")).append("\n");
                    ctx.append("裁剪数量: ").append(co.get("cutting_quantity")).append("\n");
                    ctx.append("状态: ").append(co.get("status_name")).append("\n");
                }
            } catch (Exception e) {
                // 忽略
            }
        }

        // 提取裁剪计划号 (CP开头)
        List<String> planNos = extractPatterns(message, "(CP\\d+)");
        for (String pNo : planNos) {
            try {
                List<Map<String, Object>> plans = jdbcTemplate.queryForList(
                    "SELECT plan_no, order_no, cutting_part_name, plan_quantity, status, " +
                    "CASE status WHEN 0 THEN '未开始' WHEN 1 THEN '进行中' WHEN 2 THEN '已完成' ELSE '未知' END AS status_name " +
                    "FROM t_cutting_plan WHERE plan_no = ? AND deleted_flag = 0", pNo);
                if (!plans.isEmpty()) {
                    ctx.append("【裁剪计划 ").append(pNo).append("】\n");
                    Map<String, Object> p = plans.get(0);
                    ctx.append("关联指令单: ").append(p.get("order_no")).append("\n");
                    ctx.append("裁片: ").append(p.get("cutting_part_name")).append("\n");
                    ctx.append("计划数量: ").append(p.get("plan_quantity")).append("\n");
                    ctx.append("状态: ").append(p.get("status_name")).append("\n");
                }
            } catch (Exception e) {
                // 忽略
            }
        }

        // 如果没有具体单号，查询通用统计数据
        if (ctx.length() == 0) {
            try {
                // 计算本周时间范围
                LocalDate today = LocalDate.now();
                LocalDate weekStart = today.with(DayOfWeek.MONDAY);
                LocalDate weekEnd = today.with(DayOfWeek.SUNDAY);
                DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyy-MM-dd");
                String weekStartStr = weekStart.format(fmt);
                String weekEndStr = weekEnd.format(fmt) + " 23:59:59";
                String todayStart = today.format(fmt) + " 00:00:00";
                String todayEnd = today.format(fmt) + " 23:59:59";

                boolean isWeekQuery = message.contains("本周") || message.contains("这周") || message.contains("本星期");
                boolean isTodayQuery = message.contains("今日") || message.contains("今天");
                boolean isCuttingQuery = message.contains("裁剪") || message.contains("裁床");
                boolean isSpreadQuery = message.contains("铺布");
                boolean isRelaxQuery = message.contains("松布");
                boolean isOrderQuery = message.contains("指令单") || message.contains("生产单");
                boolean isStatQuery = message.contains("统计") || message.contains("多少") || message.contains("数量") || message.contains("几");

                // 本周裁剪单查询
                if ((isWeekQuery || isTodayQuery) && isCuttingQuery) {
                    String timeStart = isWeekQuery ? weekStartStr + " 00:00:00" : todayStart;
                    String timeEnd = isWeekQuery ? weekEndStr : todayEnd;
                    String timeLabel = isWeekQuery ? "本周（" + weekStartStr + " 至 " + weekEnd.format(fmt) + "）" : "今日（" + today.format(fmt) + "）";
                    List<Map<String, Object>> list = jdbcTemplate.queryForList(
                        "SELECT cutting_order_no, order_no, garment_name, cutting_quantity, " +
                        "CASE status WHEN 0 THEN '草稿' WHEN 1 THEN '待裁剪' WHEN 2 THEN '裁剪中' WHEN 3 THEN '已完工' ELSE '未知' END AS status_name, " +
                        "update_time FROM t_cutting_order " +
                        "WHERE deleted_flag = 0 AND update_time BETWEEN ? AND ? ORDER BY update_time DESC LIMIT 20",
                        timeStart, timeEnd);
                    ctx.append("【").append(timeLabel).append("裁剪单数据】\n");
                    ctx.append("共查询到 ").append(list.size()).append(" 条记录:\n");
                    for (Map<String, Object> row : list) {
                        ctx.append("  ").append(row.get("cutting_order_no"))
                           .append(" | 款式:").append(row.get("garment_name"))
                           .append(" | 数量:").append(row.get("cutting_quantity"))
                           .append(" | 状态:").append(row.get("status_name")).append("\n");
                    }
                }
                // 本周/今日铺布查询
                else if ((isWeekQuery || isTodayQuery) && isSpreadQuery) {
                    String timeStart = isWeekQuery ? weekStartStr + " 00:00:00" : todayStart;
                    String timeEnd = isWeekQuery ? weekEndStr : todayEnd;
                    String timeLabel = isWeekQuery ? "本周" : "今日";
                    List<Map<String, Object>> list = jdbcTemplate.queryForList(
                        "SELECT order_no, fabric_name, color_name, require_length, " +
                        "CASE status WHEN 0 THEN '未开始' WHEN 1 THEN '进行中' WHEN 2 THEN '已完成' ELSE '未知' END AS status_name " +
                        "FROM t_fabric_spread " +
                        "WHERE deleted_flag = 0 AND update_time BETWEEN ? AND ? ORDER BY update_time DESC LIMIT 20",
                        timeStart, timeEnd);
                    ctx.append("【").append(timeLabel).append("铺布任务数据】\n");
                    ctx.append("共查询到 ").append(list.size()).append(" 条记录:\n");
                    for (Map<String, Object> row : list) {
                        ctx.append("  ").append(row.get("order_no"))
                           .append(" | 面料:").append(row.get("fabric_name"))
                           .append(" | 颜色:").append(row.get("color_name"))
                           .append(" | 状态:").append(row.get("status_name")).append("\n");
                    }
                }
                // 本周/今日松布查询
                else if ((isWeekQuery || isTodayQuery) && isRelaxQuery) {
                    String timeStart = isWeekQuery ? weekStartStr + " 00:00:00" : todayStart;
                    String timeEnd = isWeekQuery ? weekEndStr : todayEnd;
                    String timeLabel = isWeekQuery ? "本周" : "今日";
                    List<Map<String, Object>> list = jdbcTemplate.queryForList(
                        "SELECT order_no, fabric_name, color_name, " +
                        "CASE status WHEN 0 THEN '未开始' WHEN 1 THEN '进行中' WHEN 2 THEN '静置完成' WHEN 3 THEN '已结束' ELSE '未知' END AS status_name " +
                        "FROM t_fabric_relax " +
                        "WHERE relax_type = 1 AND deleted_flag = 0 AND update_time BETWEEN ? AND ? ORDER BY update_time DESC LIMIT 20",
                        timeStart, timeEnd);
                    ctx.append("【").append(timeLabel).append("松布任务数据】\n");
                    ctx.append("共查询到 ").append(list.size()).append(" 条记录:\n");
                    for (Map<String, Object> row : list) {
                        ctx.append("  ").append(row.get("order_no"))
                           .append(" | 面料:").append(row.get("fabric_name"))
                           .append(" | 颜色:").append(row.get("color_name"))
                           .append(" | 状态:").append(row.get("status_name")).append("\n");
                    }
                }
                // 通用统计（包含"多少"、"统计"、"数量"等）
                else if (isStatQuery || isOrderQuery || isCuttingQuery || isSpreadQuery || isRelaxQuery) {
                    List<Map<String, Object>> stats = jdbcTemplate.queryForList(
                        "SELECT " +
                        "(SELECT COUNT(*) FROM t_production_order WHERE deleted_flag=0) AS total_orders, " +
                        "(SELECT COUNT(*) FROM t_production_order WHERE status=0 AND deleted_flag=0) AS draft_orders, " +
                        "(SELECT COUNT(*) FROM t_production_order WHERE status=1 AND deleted_flag=0) AS issued_orders, " +
                        "(SELECT COUNT(*) FROM t_production_order WHERE status=2 AND deleted_flag=0) AS producing_orders, " +
                        "(SELECT COUNT(*) FROM t_production_order WHERE status=3 AND deleted_flag=0) AS completed_orders, " +
                        "(SELECT COUNT(*) FROM t_cutting_order WHERE deleted_flag=0) AS total_cutting, " +
                        "(SELECT COUNT(*) FROM t_cutting_order WHERE status=3 AND deleted_flag=0) AS completed_cutting, " +
                        "(SELECT COUNT(*) FROM t_fabric_spread WHERE deleted_flag=0) AS total_spread, " +
                        "(SELECT COUNT(*) FROM t_fabric_spread WHERE status=2 AND deleted_flag=0) AS completed_spread, " +
                        "(SELECT COUNT(*) FROM t_fabric_relax WHERE relax_type=1 AND deleted_flag=0) AS total_relax, " +
                        "(SELECT COUNT(*) FROM t_fabric_relax WHERE status=2 AND relax_type=1 AND deleted_flag=0) AS completed_relax");
                    if (!stats.isEmpty()) {
                        Map<String, Object> s = stats.get(0);
                        ctx.append("【系统总体统计数据（截止当前）】\n");
                        ctx.append("生产指令单: 共").append(s.get("total_orders")).append("条")
                           .append("（草稿").append(s.get("draft_orders"))
                           .append("/已下达").append(s.get("issued_orders"))
                           .append("/生产中").append(s.get("producing_orders"))
                           .append("/已完工").append(s.get("completed_orders")).append("）\n");
                        ctx.append("裁剪单: 共").append(s.get("total_cutting")).append("条")
                           .append("，已完工").append(s.get("completed_cutting")).append("条\n");
                        ctx.append("铺布任务: 共").append(s.get("total_spread")).append("条")
                           .append("，已完成").append(s.get("completed_spread")).append("条\n");
                        ctx.append("松布任务: 共").append(s.get("total_relax")).append("条")
                           .append("，已完成").append(s.get("completed_relax")).append("条\n");
                    }
                }
            } catch (Exception e) {
                // 忽略
            }
        }

        return ctx.toString();
    }

    private List<String> extractPatterns(String text, String regex) {
        List<String> results = new ArrayList<>();
        Pattern p = Pattern.compile(regex, Pattern.CASE_INSENSITIVE);
        Matcher m = p.matcher(text.toUpperCase());
        while (m.find()) {
            results.add(m.group(1));
        }
        return results;
    }

    private String callAiApi(String userMessage, String context) {
        try {
            ObjectMapper mapper = new ObjectMapper();

            String systemPrompt = "你是一个服装生产管理系统的智能助手，名叫小裁，专门帮助用户查询生产进度、订单状态等信息。\n" +
                "【重要规则1】你没有任何工具调用能力，不需要调用任何工具或函数。绝对禁止输出任何 XML 标签、tool_call、invoke、function_call 等内容。\n" +
                "【重要规则2】你只能根据用户消息中【已提供的数据库查询结果】来回答，绝对不能编造、猜测或虚构任何数据，包括单号、日期、数量、客户名等。\n" +
                "【重要规则3】如果用户消息中没有提供相关数据，你必须直接告知用户'系统未查询到相关数据，请尝试提供具体单号或换个问法'，绝不能自己编造数据。\n" +
                "【重要规则4】所有数据已由系统实时查询并提供给你，你只需阅读并用简洁友好的中文回答即可。\n" +
                "回答要简洁明了，重点突出状态和关键信息，避免不必要的废话。";

            String userContent = userMessage;
            if (!context.isEmpty()) {
                userContent = "以下是系统从数据库实时查询到的真实数据：\n" + context + "\n\n用户问题：" + userMessage;
            } else {
                userContent = "【注意：系统未查询到与此问题相关的数据库记录，请直接告知用户未找到数据，不要编造任何信息。】\n\n用户问题：" + userMessage;
            }

            Map<String, Object> requestBody = new LinkedHashMap<>();
            requestBody.put("model", MODEL);
            requestBody.put("max_tokens", 1000);

            List<Map<String, String>> messages = new ArrayList<>();
            Map<String, String> sysMsg = new LinkedHashMap<>();
            sysMsg.put("role", "system");
            sysMsg.put("content", systemPrompt);
            messages.add(sysMsg);

            Map<String, String> userMsg = new LinkedHashMap<>();
            userMsg.put("role", "user");
            userMsg.put("content", userContent);
            messages.add(userMsg);

            requestBody.put("messages", messages);

            String body = mapper.writeValueAsString(requestBody);

            HttpClient client = HttpClient.newHttpClient();
            HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(API_URL))
                .header("Content-Type", "application/json")
                .header("Authorization", "Bearer " + API_KEY)
                .POST(HttpRequest.BodyPublishers.ofString(body))
                .build();

            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
            String responseBody = response.body();

            // 解析响应
            Map<String, Object> responseMap = mapper.readValue(responseBody, Map.class);
            if (responseMap.containsKey("error")) {
                Map<String, Object> error = (Map<String, Object>) responseMap.get("error");
                return "AI服务暂时不可用：" + error.get("message");
            }

            List<Map<String, Object>> choices = (List<Map<String, Object>>) responseMap.get("choices");
            if (choices != null && !choices.isEmpty()) {
                Map<String, Object> choice = choices.get(0);
                Map<String, Object> msgObj = (Map<String, Object>) choice.get("message");
                return (String) msgObj.get("content");
            }

            return "抱歉，AI未能生成有效回复，请重试。";
        } catch (Exception e) {
            return "调用AI服务失败：" + e.getMessage();
        }
    }
}
