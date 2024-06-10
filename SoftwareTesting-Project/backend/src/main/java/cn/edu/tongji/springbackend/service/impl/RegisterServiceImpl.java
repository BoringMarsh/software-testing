package cn.edu.tongji.springbackend.service.impl;

import cn.edu.tongji.springbackend.config.FileStorageProperties;
import cn.edu.tongji.springbackend.controller.KeywordsController;
import cn.edu.tongji.springbackend.dto.RegSocietyRequest;
import cn.edu.tongji.springbackend.dto.RegStudentRequest;
import cn.edu.tongji.springbackend.exceptions.FileStorageException;
import cn.edu.tongji.springbackend.exceptions.RegisterException;
import cn.edu.tongji.springbackend.mapper.SocietyMapper;
import cn.edu.tongji.springbackend.mapper.StudentKeywordMapper;
import cn.edu.tongji.springbackend.mapper.StudentMapper;
import cn.edu.tongji.springbackend.mapper.UserMapper;
import cn.edu.tongji.springbackend.model.*;
import cn.edu.tongji.springbackend.service.EncryptService;
import cn.edu.tongji.springbackend.service.RegisterService;
import jakarta.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.util.Base64;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class RegisterServiceImpl implements RegisterService {
    private static final Logger logger = LoggerFactory.getLogger(KeywordsController.class);
    @Resource
    private EncryptService encryptService;
    @Resource
    private UserMapper userMapper;
    @Resource
    private StudentMapper studentMapper;
    @Resource
    private StudentKeywordMapper studentKeywordMapper;
    @Resource
    private SocietyMapper societyMapper;
    @Resource
    private FileStorageProperties fileStorageProperties;

    @Override
    @Transactional
    public int registerStudent(RegStudentRequest regStudentRequest) {
        final String username = regStudentRequest.getUsername();
        final String password = regStudentRequest.getPassword();
        final String email = regStudentRequest.getEmail();
        final String phone = regStudentRequest.getPhone();
        final String payPassword = regStudentRequest.getPayPassword();
        final String stuName = regStudentRequest.getStuName();
        final String stuNotes = regStudentRequest.getStuNotes();

        if (username == null || username.equals("") || username.length() > 16) {
            throw new RegisterException("abnormal username length");
        } else if (password == null || password.equals("") || password.length() > 24) {
            throw new RegisterException("abnormal password length");
        } else if (!password.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).+$")) {
            throw new RegisterException("incorrect password pattern");
        } else if (email == null || email.equals("") || email.length() > 64) {
            throw new RegisterException("abnormal email length");
        } else if (phone == null || phone.length() != 11) {
            throw new RegisterException("abnormal phone length");
        } else if (!phone.matches("^\\d+$")) {
            throw new RegisterException("incorrect phone pattern");
        } else if (payPassword == null || payPassword.length() != 6) {
            throw new RegisterException("abnormal pay password length");
        } else if (!payPassword.matches("^\\d+$")) {
            throw new RegisterException("incorrect pay password pattern");
        } else if (stuName == null || stuName.equals("") || stuName.length() > 64) {
            throw new RegisterException("abnormal student name length");
        } else if (stuNotes == null || stuNotes.equals("") || stuNotes.length() > 128) {
            throw new RegisterException("abnormal student notes length");
        }

        User user = User.builder()
                .username(username)
                .password(encryptService.encryptPassword(password))
                .email(email)
                .phone(phone)
                .campus(regStudentRequest.getCampus())
                .loginStatus(0)
                .accountStatus(2)
                .balance(0.0)
                .payPassword(encryptService.encryptPassword(payPassword))
                .regTime(LocalDateTime.now())  // Set regTime to current time
                .role(0)  // Assuming 0 is the role for normal users
                .build();

        logger.info("Successfully set user info: {}", user);

        // Insert the user into the user table and retrieve the generated ID
        int rowsAffected = userMapper.insertUser(user);

        // Check if the insertion was successful
        if (rowsAffected > 0) {
            // Retrieve the generated ID and update the User object
            Integer generatedId = user.getId(); // Assuming the generated ID is in the getId() method
            user.setId(generatedId);
            logger.info("Successfully inserted user with ID: {}", generatedId);
        } else {
            logger.error("Failed to insert user");
        }

        Student student = Student.builder()
                .stuId(user.getId())
                .stuName(stuName)
                .stuYear(regStudentRequest.getStuYear())
                .stuSchool(regStudentRequest.getStuSchool())
                .stuMajor(regStudentRequest.getStuMajor())
                .stuNotes(stuNotes)
                .build();

        logger.info("Successfully set user info: {}", student);
        // Insert the student into the student table
        studentMapper.insertStudent(student);

        List<StudentKeyword> studentKeywords = regStudentRequest.getKeywords().stream()
                .map(keyword -> {
                    StudentKeyword studentKeyword = new StudentKeyword();
                    studentKeyword.setStuId(user.getId());
                    studentKeyword.setKeyword(keyword);
                    studentKeyword.setPreferWeight(0.0);
                    return studentKeyword;
                })
                .collect(Collectors.toList());

        // Insert each student keyword into the student_keyword table
        for (StudentKeyword studentKeyword : studentKeywords) {
            studentKeywordMapper.insertStudentKeyword(studentKeyword);
        }

        return user.getId();
    }

    // Add other methods as needed
    @Override
    @Transactional
    public int registerSociety(RegSocietyRequest regSocietyRequest) {
        try{
            User user = User.builder()
                    .username(regSocietyRequest.getUsername())
                    .password(encryptService.encryptPassword(regSocietyRequest.getPassword()))
                    .email(regSocietyRequest.getEmail())
                    .phone(regSocietyRequest.getPhone())
                    .campus(regSocietyRequest.getCampus())
                    .loginStatus(0)
                    .accountStatus(2)
                    .balance(0.0)
                    .payPassword(encryptService.encryptPassword(regSocietyRequest.getPayPassword()))
                    .regTime(LocalDateTime.now())
                    .role(1)
                    .build();

            logger.info("Successfully set user info: {}", user);
            // Insert the user into the user table and retrieve the generated ID
            int rowsAffected = userMapper.insertUser(user);

            // Check if the insertion was successful
            if (rowsAffected > 0) {
                // Retrieve the generated ID and update the User object
                Integer generatedId = user.getId(); // Assuming the generated ID is in the getId() method
                user.setId(generatedId);
                logger.info("Successfully inserted user with ID: {}", generatedId);
            } else {
                logger.error("Failed to insert user");
            }

            Society society = Society.builder()
                    .socId(user.getId())
                    .socName(regSocietyRequest.getSocName())
                    .socIntro(regSocietyRequest.getSocIntro())
                    .socType(regSocietyRequest.getSocType())
                    .build();

            // Process and save society logo
            if (regSocietyRequest.getSocLogoFile() != null && !regSocietyRequest.getSocLogoFile().isEmpty()) {
                String logoPath = saveLogo(regSocietyRequest.getSocLogoFile());
                society.setSocLogo(logoPath);
            }
            // Insert the society into the society table
            societyMapper.insertSociety(society);
            logger.info("Successfully inserted society with ID: {}", user.getId());
            // Process and save society admins, images, and keywords
            processSocietyAdmins(user.getId(), regSocietyRequest.getSocAdminRegs());
            logger.info("Successfully inserted socAdmins with ID: {}", user.getId());
            processSocietyImages(user.getId(), regSocietyRequest.getSocImageFiles());
            logger.info("Successfully inserted socImages with ID: {}", user.getId());
            processSocietyKeywords(user.getId(), regSocietyRequest.getSocKeywords());
            logger.info("Successfully inserted socKeywords with ID: {}", user.getId());

            return user.getId();
        } catch (Exception ex) {
            logger.error("Error occurred in registerSociety: " + ex.getMessage(), ex);
            throw ex; // Re-throw the exception if you want to propagate it up the call stack
        }
    }

    // Helper methods for processing society admins, images, and keywords
    private void processSocietyAdmins(Integer socId, List<SocietyAdminRegistration> socAdminRegs) {
        if (socAdminRegs != null) {
            for (SocietyAdminRegistration adminReg : socAdminRegs) {
                SocietyAdmin admin = new SocietyAdmin();
                admin.setSocId(socId);
                admin.setSocAdminNo(adminReg.getSocAdminNo());
                admin.setSocAdminName(adminReg.getSocAdminName());
                admin.setSocAdminEmail(adminReg.getSocAdminEmail());
                admin.setSocAdminPhone(adminReg.getSocAdminPhone());
                societyMapper.insertSocietyAdmin(admin);
            }
        }
    }

    private void processSocietyImages(Integer socId, List<String> socImageFiles) {
        if (socImageFiles != null) {
            for (String base64Image : socImageFiles) {
                if (base64Image != null && !base64Image.isEmpty()) {
                    String imagePath = saveImage(base64Image);
                    SocietyImage societyImage = new SocietyImage();
                    societyImage.setSocId(socId);
                    societyImage.setSocImage(imagePath);
                    societyMapper.insertSocietyImage(societyImage);
                }
            }
        }
    }

    private void processSocietyKeywords(Integer socId, List<String> socKeywords) {
        if (socKeywords != null) {
            for (String keyword : socKeywords) {
                SocietyKeyword societyKeyword = new SocietyKeyword();
                societyKeyword.setSocId(socId);
                societyKeyword.setKeyword(keyword);
                societyMapper.insertSocietyKeyword(societyKeyword);
            }
        }
    }

    private String saveLogo(String base64Logo) {
        try {
            // Specify the directory where you want to store logos
            String logoUploadDir = fileStorageProperties.getLogoUploadDir();
            Files.createDirectories(Paths.get(logoUploadDir));
            // Decode the Base64 string
            byte[] imageBytes = Base64.getDecoder().decode(base64Logo.split(",")[1]);
            // Generate a unique filename to avoid collisions
            String uniqueFileName = UUID.randomUUID().toString() + ".jpg"; // Assuming JPEG format
            Path targetLocation = Paths.get(logoUploadDir, uniqueFileName);
            // Save the decoded bytes to file
            Files.write(targetLocation, imageBytes);
            // Return the relative path
            return logoUploadDir + uniqueFileName;
        } catch (IOException ex) {
            throw new FileStorageException("Failed to store logo file", ex);
        } catch (Exception ex) {
            logger.error("General Exception occurred: " + ex.getMessage(), ex);
            throw ex; // 或者处理异常
        }
    }

    private String saveImage(String base64Image) {
        try {
            // Specify the directory where you want to store images
            String imageUploadDir = fileStorageProperties.getImageUploadDir();
            Files.createDirectories(Paths.get(imageUploadDir));

            // Decode the Base64 string
            byte[] imageBytes = Base64.getDecoder().decode(base64Image.split(",")[1]);

            // Generate a unique filename to avoid collisions
            String uniqueFileName = UUID.randomUUID().toString() + ".jpg"; // Assuming JPEG format
            Path targetLocation = Paths.get(imageUploadDir, uniqueFileName);

            // Save the decoded bytes to file
            Files.write(targetLocation, imageBytes);

            // Return the relative path
            return imageUploadDir + uniqueFileName;
        } catch (IOException ex) {
            throw new FileStorageException("Failed to store image file", ex);
        }
    }

}