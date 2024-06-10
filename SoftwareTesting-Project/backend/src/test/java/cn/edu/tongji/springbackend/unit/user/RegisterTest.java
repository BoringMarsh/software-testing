package cn.edu.tongji.springbackend.unit.user;

import cn.edu.tongji.springbackend.TestException;
import cn.edu.tongji.springbackend.dto.RegStudentRequest;
import cn.edu.tongji.springbackend.service.RegisterService;
import io.qameta.allure.*;
import jakarta.annotation.Resource;
import lombok.AllArgsConstructor;
import lombok.Data;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.MethodSource;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.jdbc.Sql;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

import static cn.edu.tongji.springbackend.util.CSVUtils.*;
import static cn.edu.tongji.springbackend.util.CSVUtils.updateBlock;
import static cn.edu.tongji.springbackend.util.PathUtil.TC_PATH_UNIT_USER;
import static cn.edu.tongji.springbackend.util.TimeUtils.getFormatter;

@SpringBootTest
@Transactional
public class RegisterTest {
    /**
     * 被测对象
     */
    @Resource
    private RegisterService registerService;

    /**
     * 测试用例类
     */
    @Data
    @AllArgsConstructor
    private static class RegisterTestCase {
        private String username;
        private String password;
        private String email;
        private String phone;
        private String campus;
        private String payPassword;
        private String stuName;
        private String stuYear;
        private String stuSchool;
        private String stuMajor;
        private String stuNotes;
    }

    /**
     * 一些常量，包括测试用例路径、特定内容的列号等
     */
    private static final String TEST_CASE_FILENAME = "register.csv";
    private static final String TEST_CASE_RESULT_FILENAME = "register_result.csv";
    private static final String TEST_PERSON = "2151294";
    private static final int COLUMN_USERNAME = 1;
    private static final int COLUMN_PASSWORD = 2;
    private static final int COLUMN_EMAIL = 3;
    private static final int COLUMN_PHONE = 4;
    private static final int COLUMN_CAMPUS = 5;
    private static final int COLUMN_PAY_PASSWORD = 6;
    private static final int COLUMN_STU_NAME = 7;
    private static final int COLUMN_STU_YEAR = 8;
    private static final int COLUMN_STU_SCHOOL = 9;
    private static final int COLUMN_STU_MAJOR = 10;
    private static final int COLUMN_STU_NOTES = 11;
    private static final int COLUMN_EXPECTED_OUTPUT = 12;
    private static final int COLUMN_ACTUAL_OUTPUT = 13;
    private static final int COLUMN_RESULT = 14;
    private static final int COLUMN_TIME = 16;
    private static final int COLUMN_PERSON = 17;

    /**
     * 测试时变量，包括读取进内存的csv表格、总用例数、已执行用例数等
     */
    private static List<String[]> data;
    private static int total = 0;
    private static int executed = 0;

    /**
     * 测试前置函数，通过读取csv文件返回测试用例对象列表。同时重置相关计数器
     * @return RegisterTestCase列表
     */
    private static List<RegisterTestCase> provideRegisterTestCases() {
        List<RegisterTestCase> suite = new ArrayList<>();
        data = readCsv(TC_PATH_UNIT_USER + '/' + TEST_CASE_FILENAME);
        total = data.size();
        executed = 1;

        for (int i = 1; i < data.size(); i++) {
            String[] line = data.get(i);

            suite.add(new RegisterTestCase(
                    line[COLUMN_USERNAME],
                    line[COLUMN_PASSWORD],
                    line[COLUMN_EMAIL],
                    line[COLUMN_PHONE],
                    line[COLUMN_CAMPUS],
                    line[COLUMN_PAY_PASSWORD],
                    line[COLUMN_STU_NAME],
                    line[COLUMN_STU_YEAR],
                    line[COLUMN_STU_SCHOOL],
                    line[COLUMN_STU_MAJOR],
                    line[COLUMN_STU_NOTES]
            ));
        }

        return suite;
    }

    @ParameterizedTest
    @MethodSource("provideRegisterTestCases")
    @Description("This is a test description")
    @Epic("User模块")
    @Feature("注册")
    @Story("游客在注册页面输入各项信息，注册个人用户")
    @Severity(SeverityLevel.CRITICAL)
    @DisplayName("Test Authentication")
    @Owner("2151294")
    @Link(name = "Website", url = "https://dev.example.com/")
    @Issue("AUTH-123")
    @TmsLink("TMS-456")
    @Sql(scripts = "/sql/user_reset.sql", executionPhase = Sql.ExecutionPhase.BEFORE_TEST_METHOD)
    public void registerTest(RegisterTestCase testCase) {
        String[] line = data.get(executed);  //获取测试用例csv文件中的当前行，方便填入内容
        String actualOutput;                 //实际输出

        //调取测试方法，获取实际输出
        try {
            registerService.registerStudent(new RegStudentRequest(
                    testCase.getUsername(),
                    testCase.getPassword(),
                    testCase.getEmail(),
                    testCase.getPhone(),
                    testCase.getCampus(),
                    testCase.getPayPassword(),
                    testCase.getStuName(),
                    testCase.getStuYear(),
                    testCase.getStuSchool(),
                    testCase.getStuMajor(),
                    testCase.getStuNotes(),
                    new ArrayList<>()
            ));

            actualOutput = "student register success";
        } catch (Exception e) {
            actualOutput = e.getMessage();
        }

        //比对预期输出和实际输出
        boolean result = Objects.equals(actualOutput, line[COLUMN_EXPECTED_OUTPUT]);

        //填入实际输出、测试时间和测试人员
        updateBlock(data, executed, COLUMN_ACTUAL_OUTPUT, actualOutput);
        updateBlock(data, executed, COLUMN_TIME, LocalDateTime.now().format(getFormatter()));
        updateBlock(data, executed, COLUMN_PERSON, TEST_PERSON);

        //若执行到最后一行，将填入后的数据写入结果csv文件
        if (executed == total - 1)
            writeCsv(TC_PATH_UNIT_USER + '/' + TEST_CASE_RESULT_FILENAME, data);
        else
            executed++;

        //根据比对结果填入测试结果，以及若不通过则直接抛出未通过异常，给后续报告捕获该信息
        if (result) {
            updateBlock(data, executed, COLUMN_RESULT, "通过测试");
        } else {
            updateBlock(data, executed, COLUMN_RESULT, "未通过测试");
            throw new TestException(executed, line[COLUMN_EXPECTED_OUTPUT], actualOutput);
        }
    }
}
