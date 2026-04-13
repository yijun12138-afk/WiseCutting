package net.lab1024.sa.admin.module.business.ai.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import jakarta.validation.Valid;
import net.lab1024.sa.admin.module.business.ai.domain.AiChatForm;
import net.lab1024.sa.admin.module.business.ai.service.AiChatService;
import net.lab1024.sa.base.common.domain.ResponseDTO;
import org.springframework.web.bind.annotation.*;

@RestController
@Tag(name = "智能助手")
public class AiChatController {

    @Resource
    private AiChatService aiChatService;

    @Operation(summary = "智能助手对话")
    @PostMapping("/ai/chat")
    public ResponseDTO<String> chat(@RequestBody @Valid AiChatForm form) {
        return aiChatService.chat(form);
    }
}
