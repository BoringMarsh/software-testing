package cn.edu.tongji.springbackend.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class AppealDetailedInfo {
    private Integer appId;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime appTime;

    private Integer appMatters;
    private String appContent;
    private Integer userId;
    private Integer actId;
    private Integer cmtId;
    private String cmtContent;
    private Integer complainantId;
    private List<String> images;
}
