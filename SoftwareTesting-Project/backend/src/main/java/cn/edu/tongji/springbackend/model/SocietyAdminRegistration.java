package cn.edu.tongji.springbackend.model;

import lombok.Data;
import lombok.Builder;
import java.time.LocalDateTime;

@Data
public class SocietyAdminRegistration {
    private String socAdminNo;
    private String socAdminName;
    private String socAdminPhone;
    private String socAdminEmail;
}
