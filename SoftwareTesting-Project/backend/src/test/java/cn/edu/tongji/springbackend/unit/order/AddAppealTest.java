package cn.edu.tongji.springbackend.unit.order;

import cn.edu.tongji.springbackend.TestException;
import cn.edu.tongji.springbackend.dto.AddAppealRequest;
import cn.edu.tongji.springbackend.service.OrderService;
import io.qameta.allure.*;
import jakarta.annotation.Resource;
import lombok.AllArgsConstructor;
import lombok.Data;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.MethodSource;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.test.context.jdbc.Sql;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

import static cn.edu.tongji.springbackend.util.CSVUtils.*;
import static cn.edu.tongji.springbackend.util.PathUtil.TC_PATH_UNIT_ORDER;
import static cn.edu.tongji.springbackend.util.TimeUtils.getFormatter;

@SpringBootTest
@Transactional
public class AddAppealTest {
    /**
     * 被测对象
     */
    @Resource
    private OrderService orderService;

    /**
     * 测试用例类
     */
    @Data
    @AllArgsConstructor
    private static class AddAppealTestCase {
        private String userId;
        private String actId;
        private String cmtId;
        private String complainantId;
        private String appTime;
        private String appContent;
    }

    /**
     * 一些常量，包括测试用例路径、特定内容的列号等
     */
    private static final String TEST_CASE_FILENAME = "add_appeal.csv";
    private static final String TEST_CASE_RESULT_FILENAME = "add_appeal_result.csv";
    private static final String TEST_PERSON = "2151294";
    private static final int COLUMN_USER_ID = 1;
    private static final int COLUMN_ACT_ID = 2;
    private static final int COLUMN_CMT_ID = 3;
    private static final int COLUMN_COMPLAINANT_ID = 4;
    private static final int COLUMN_APP_TIME = 5;
    private static final int COLUMN_APP_CONTENT = 6;
    private static final int COLUMN_EXPECTED_OUTPUT = 7;
    private static final int COLUMN_ACTUAL_OUTPUT = 8;
    private static final int COLUMN_RESULT = 9;
    private static final int COLUMN_TIME = 11;
    private static final int COLUMN_PERSON = 12;

    /**
     * 测试时变量，包括读取进内存的csv表格、总用例数、已执行用例数等
     */
    private static List<String[]> data;
    private static int total = 0;
    private static int executed = 0;

    /**
     * 测试前置函数，通过读取csv文件返回测试用例对象列表。同时重置相关计数器
     * @return AddAppealTestCase列表
     */
    private static List<AddAppealTestCase> provideAddAppealTestCases() {
        List<AddAppealTestCase> suite = new ArrayList<>();
        data = readCsv(TC_PATH_UNIT_ORDER + '/' + TEST_CASE_FILENAME);
        total = data.size();
        executed = 1;

        for (int i = 1; i < data.size(); i++) {
            String[] line = data.get(i);

            suite.add(new AddAppealTestCase(
                    line[COLUMN_USER_ID],
                    line[COLUMN_ACT_ID],
                    line[COLUMN_CMT_ID],
                    line[COLUMN_COMPLAINANT_ID],
                    line[COLUMN_APP_TIME],
                    line[COLUMN_APP_CONTENT]
            ));
        }

        return suite;
    }

    @ParameterizedTest
    @MethodSource("provideAddAppealTestCases")
    @Description("""
            - 用户对于特定对象（用户、评论、活动等）进行举报
            - 举报对象id不为空且必须存在，同时只能有一类id不为空且其余为空。例如，如果对用户进行举报，则userId不为空，但评论id、活动id等必须为空，以便系统甄别举报类型
            - 申诉发起者用户id不为空且必须存在
            - 有一个参数appealMatters记录举报类型，这是一个整型值，指定了这个举报对象是什么。例如对个人用户的举报为4，对某条评论的举报为2
            - 若举报的是用户，举报者无法举报自己
            """)
    @Epic("Order模块")
    @Feature("添加申诉")
    @Story("用户对于特定对象（用户、评论、活动等）进行举报")
    @Severity(SeverityLevel.NORMAL)
    @DisplayName("单元测试：添加申诉")
    @Owner("2151294")
    @Sql(scripts = "/sql/appeal_reset.sql", executionPhase = Sql.ExecutionPhase.BEFORE_TEST_METHOD)
    public void addAppealTest(AddAppealTestCase testCase) {
        String[] line = data.get(executed);  //获取测试用例csv文件中的当前行，方便填入内容
        String actualOutput;                 //实际输出

        //调取测试方法，获取实际输出
        try {
            final String userId = testCase.getUserId();
            final String actId = testCase.getActId();
            final String cmtId = testCase.getCmtId();

            orderService.addAppeal(new AddAppealRequest(
                    LocalDateTime.parse(testCase.getAppTime(), getFormatter()),
                    testCase.getAppContent(),
                    userId == null || userId.equals("") ? null : Integer.valueOf(userId),
                    actId == null || actId.equals("") ? null : Integer.valueOf(actId),
                    cmtId == null || cmtId.equals("") ? null : Integer.valueOf(cmtId),
                    Integer.valueOf(testCase.getComplainantId()),
                    null
            ));

            actualOutput = "add appeal success";
        } catch (NumberFormatException e) {
            actualOutput = e.getMessage().subSequence(0, 20).toString();
        } catch (DataIntegrityViolationException e) {
            actualOutput = e.getMessage().subSequence(6, 30).toString();
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
