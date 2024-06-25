package cn.edu.tongji.springbackend.unit.user;

import cn.edu.tongji.springbackend.TestException;
import cn.edu.tongji.springbackend.service.LoginService;
import static cn.edu.tongji.springbackend.util.CSVUtils.*;
import static cn.edu.tongji.springbackend.util.PathUtil.*;
import static cn.edu.tongji.springbackend.util.TimeUtils.*;

import io.qameta.allure.*;
import jakarta.annotation.Resource;
import lombok.AllArgsConstructor;
import lombok.Data;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.MethodSource;
import org.springframework.boot.test.context.SpringBootTest;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

@SpringBootTest
public class LoginTest {
    /**
     * 被测对象
     */
    @Resource
    private LoginService loginService;

    /**
     * 测试用例类
     */
    @Data
    @AllArgsConstructor
    private static class LoginTestCase {
        private String username;
        private String password;
    }

    /**
     * 一些常量，包括测试用例路径、特定内容的列号等
     */
    private static final String TEST_CASE_FILENAME = "login.csv";
    private static final String TEST_CASE_RESULT_FILENAME = "login_result.csv";
    private static final String TEST_PERSON = "2151294";
    private static final int COLUMN_USERNAME = 1;
    private static final int COLUMN_PASSWORD = 2;
    private static final int COLUMN_EXPECTED_OUTPUT = 3;
    private static final int COLUMN_ACTUAL_OUTPUT = 4;
    private static final int COLUMN_RESULT = 5;
    private static final int COLUMN_TIME = 7;
    private static final int COLUMN_PERSON = 8;

    /**
     * 测试时变量，包括读取进内存的csv表格、总用例数、已执行用例数等
     */
    private static List<String[]> data;
    private static int total = 0;
    private static int executed = 0;

    /**
     * 测试前置函数，通过读取csv文件返回测试用例对象列表。同时重置相关计数器
     * @return LoginTestCase列表
     */
    private static List<LoginTestCase> provideLoginTestCases() {
        List<LoginTestCase> suite = new ArrayList<>();
        data = readCsv(TC_PATH_UNIT_USER + '/' + TEST_CASE_FILENAME);
        total = data.size();
        executed = 1;

        for (int i = 1; i < data.size(); i++) {
            String[] line = data.get(i);
            suite.add(new LoginTestCase(line[COLUMN_USERNAME], line[COLUMN_PASSWORD]));
        }

        return suite;
    }

    @ParameterizedTest
    @MethodSource("provideLoginTestCases")
    @Description("""
            - 用户输入用户名和密码进行登录，全部正确则登录成功
            - 输入用户名为空和不存在都会报错：用户不存在
            - 输入密码为空和不存在，若用户名正确则提示密码错误，若用户名不存在则提示用户不存在
            """)
    @Epic("User模块")
    @Feature("登录")
    @Story("用户输入用户名和密码登录")
    @Severity(SeverityLevel.CRITICAL)
    @DisplayName("单元测试：登录")
    @Owner("2151294")
    @Issue("AUTH-123")
    public void loginTest(LoginTestCase testCase) {
        String[] line = data.get(executed);  //获取测试用例csv文件中的当前行，方便填入内容
        String actualOutput;                 //实际输出

        //调取测试方法，获取实际输出
        try {
            actualOutput = loginService.login(testCase.getUsername(), testCase.getPassword()).toString();
        } catch (Exception e) {
            actualOutput = e.getMessage();
        }

        //比对预期输出和实际输出
        boolean result = Objects.equals(actualOutput, line[COLUMN_EXPECTED_OUTPUT]);

        //填入实际输出、测试时间和测试人员
        updateBlock(data, executed, COLUMN_ACTUAL_OUTPUT, actualOutput);
        updateBlock(data, executed, COLUMN_TIME, LocalDateTime.now().format(getFormatter()));
        updateBlock(data, executed, COLUMN_PERSON, TEST_PERSON);
        updateBlock(data, executed, COLUMN_RESULT, result ? "通过测试" : "未通过测试");

        //若执行到最后一行，将填入后的数据写入结果csv文件
        if (executed == total - 1)
            writeCsv(TC_PATH_UNIT_USER + '/' + TEST_CASE_RESULT_FILENAME, data);
        else
            executed++;

        //若不通过则直接抛出未通过异常，给后续报告捕获该信息
        if (!result)
            throw new TestException(executed, line[COLUMN_EXPECTED_OUTPUT], actualOutput);
    }
}
