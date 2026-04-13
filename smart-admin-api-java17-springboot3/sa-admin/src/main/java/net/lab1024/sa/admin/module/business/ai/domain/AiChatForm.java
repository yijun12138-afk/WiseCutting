package net.lab1024.sa.admin.module.business.ai.domain;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class AiChatForm {
    @NotBlank(message = "消息不能为空")
    private String message;
}
