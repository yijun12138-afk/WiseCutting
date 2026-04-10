package net.lab1024.sa.admin.module.business.basic.colorgroup.domain.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("t_color_group")
public class ColorGroupEntity {

    @TableId(type = IdType.AUTO)
    private Long groupId;

    private String groupName;
    private Boolean deletedFlag;
    private String remark;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
