package net.lab1024.sa.admin.module.business.basic.sizegroup.domain.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("t_size_group")
public class SizeGroupEntity {

    @TableId(type = IdType.AUTO)
    private Long groupId;

    private String groupName;
    private Boolean deletedFlag;
    private String remark;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
