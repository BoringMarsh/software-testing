package cn.edu.tongji.springbackend.unit.order;

import cn.edu.tongji.springbackend.TestException;
import cn.edu.tongji.springbackend.service.ProfileService;
import io.qameta.allure.*;
import jakarta.annotation.Resource;
import lombok.AllArgsConstructor;
import lombok.Data;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.MethodSource;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

import static cn.edu.tongji.springbackend.util.CSVUtils.*;
import static cn.edu.tongji.springbackend.util.CSVUtils.updateBlock;
import static cn.edu.tongji.springbackend.util.PathUtil.TC_PATH_UNIT_ORDER;
import static cn.edu.tongji.springbackend.util.TimeUtils.getFormatter;

@SpringBootTest
@Transactional
public class ProcessingRegRequestTest {
    /**
     * 被测对象
     */
    @Resource
    private ProfileService profileService;

    /**
     * 测试用例类
     */
    @Data
    @AllArgsConstructor
    private static class ProcessingRegRequestTestCase {
        private String userId;
        private String ifPassed;
    }

    /**
     * 一些常量，包括测试用例路径、特定内容的列号等
     */
    private static final String TEST_CASE_FILENAME = "processing_reg_request.csv";
    private static final String TEST_CASE_RESULT_FILENAME = "processing_reg_request_result.csv";
    private static final String TEST_PERSON = "2154064";
    private static final int COLUMN_USER_ID = 1;
    private static final int COLUMN_IF_PASSED = 2;
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
     * @return ProcessingRegRequestTestCase列表
     */
    private static List<ProcessingRegRequestTestCase> provideProcessingRegRequestTestCases() {
        List<ProcessingRegRequestTestCase> suite = new ArrayList<>();
        data = readCsv(TC_PATH_UNIT_ORDER + '/' + TEST_CASE_FILENAME);
        total = data.size();
        executed = 1;

        for (int i = 1; i < data.size(); i++) {
            suite.add(new ProcessingRegRequestTestCase(data.get(i)[COLUMN_USER_ID], data.get(i)[COLUMN_IF_PASSED]));
        }
        return suite;
    }

    @ParameterizedTest
    @MethodSource("provideProcessingRegRequestTestCases")
    @Description("""
            - 管理员审批用户注册申请
            - 用户注册时在数据库插入一条信息，账户状态置为待审批（Account_status=2）
            - 审批通过则修改账户状态
            - 审批被驳回则从数据库中删除账户
            - 不支持审批不存在的账户申请
            - 不支持审批待审批状态之外的账户
            """)
    @Epic("Order模块")
    @Feature("处理注册申请")
    @Story("管理员审批用户注册申请，决定通过或驳回")
    @Severity(SeverityLevel.MINOR)
    @DisplayName("单元测试：处理注册申请")
    @Owner("2154064")
    public void processingRegRequestTest(ProcessingRegRequestTestCase testCase) {
        String[] line = data.get(executed);  //获取测试用例csv文件中的当前行，方便填入内容
        String actualOutput;                 //实际输出

        //调取测试方法，获取实际输出
        try {
            int ifPassed = Integer.parseInt(testCase.getIfPassed());

            if (ifPassed == 1){
                profileService.passRegRequest(Integer.parseInt(testCase.getUserId()));
                actualOutput = "pass register request success";
            } else if (ifPassed == 0){
                profileService.refuseRegRequest(Integer.parseInt(testCase.getUserId()));
                actualOutput = "refuse register request success";
            } else
                actualOutput = "decision exceeding expectations";

        } catch (NumberFormatException e) {
            actualOutput = e.getMessage().subSequence(0, 20).toString();
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
            writeCsv(TC_PATH_UNIT_ORDER + '/' + TEST_CASE_RESULT_FILENAME, data);
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
