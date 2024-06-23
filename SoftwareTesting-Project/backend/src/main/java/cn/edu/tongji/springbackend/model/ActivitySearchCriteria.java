package cn.edu.tongji.springbackend.model;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
public class ActivitySearchCriteria {
    private Integer socId;
    private Integer status;
    private Integer order;
    private List<String> keyword;
    private String query;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime uploadTime;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime regEndTime;

    private Integer page;
    private Integer pageSize;
}
