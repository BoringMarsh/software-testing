package cn.edu.tongji.springbackend.model;

import lombok.Data;
import lombok.Builder;
import java.time.LocalDateTime;

@Data
@Builder
public class Student {
    private Integer stuId;
    private String stuName;
    private String stuYear;
    private String stuSchool;
    private String stuMajor;
    private String stuNotes;
}