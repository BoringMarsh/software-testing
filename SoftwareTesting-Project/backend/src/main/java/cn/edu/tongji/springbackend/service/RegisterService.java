package cn.edu.tongji.springbackend.service;

import cn.edu.tongji.springbackend.dto.RegSocietyRequest;
import cn.edu.tongji.springbackend.dto.RegStudentRequest;
import org.springframework.stereotype.Service;

@Service
public interface RegisterService {
    int registerStudent(RegStudentRequest registrationRequest);
    int registerSociety(RegSocietyRequest registrationRequest);

}
