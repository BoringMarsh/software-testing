package cn.edu.tongji.springbackend.unit.comment;

import cn.edu.tongji.springbackend.TestException;
import cn.edu.tongji.springbackend.dto.AddCommentRequest;
import cn.edu.tongji.springbackend.dto.ReplyCommentRequest;
import cn.edu.tongji.springbackend.service.CommunicateService;
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
import static cn.edu.tongji.springbackend.util.PathUtil.TC_PATH_UNIT_COMMENT;
import static cn.edu.tongji.springbackend.util.TimeUtils.getFormatter;

@SpringBootTest
@Transactional
@Sql(scripts = "/sql/comment_reset.sql", executionPhase = Sql.ExecutionPhase.BEFORE_TEST_CLASS)
public class StateTransitionTest {
    /**
     * 被测对象
     */
    @Resource
    private CommunicateService communicateService;

    /**
     * 测试用例类
     */
    @Data
    @AllArgsConstructor
    private static class StateTransitionTestCase {
        private String addUserId;
        private String addActId;
        private String addCmtContent;
        private String addCmtTime;
        private String replyCmtFather1;
        private String replyUserId1;
        private String replyActId1;
        private String replyCmtContent1;
        private String replyCmtTime1;
        private String replyCmtFather2;
        private String replyUserId2;
        private String replyActId2;
        private String replyCmtContent2;
        private String replyCmtTime2;
        private String replyCmtFather3;
        private String replyUserId3;
        private String replyActId3;
        private String replyCmtContent3;
        private String replyCmtTime3;
        private String deleteCmtId;
        private String getCmtId;
    }

    /**
     * 一些常量，包括测试用例路径、特定内容的列号等
     */
    private static final String TEST_CASE_FILENAME = "state_transition.csv";
    private static final String TEST_CASE_RESULT_FILENAME = "state_transition_result.csv";
    private static final String TEST_PERSON = "2151294";
    private static final int COLUMN_ADD_USER_ID = 1;
    private static final int COLUMN_ADD_ACT_ID = 2;
    private static final int COLUMN_ADD_CMT_CONTENT = 3;
    private static final int COLUMN_ADD_CMT_TIME = 4;
    private static final int COLUMN_REPLY_CMT_FATHER_1 = 5;
    private static final int COLUMN_REPLY_USER_ID_1 = 6;
    private static final int COLUMN_REPLY_ACT_ID_1 = 7;
    private static final int COLUMN_REPLY_CMT_CONTENT_1 = 8;
    private static final int COLUMN_REPLY_CMT_TIME_1 = 9;
    private static final int COLUMN_REPLY_CMT_FATHER_2 = 10;
    private static final int COLUMN_REPLY_USER_ID_2 = 11;
    private static final int COLUMN_REPLY_ACT_ID_2 = 12;
    private static final int COLUMN_REPLY_CMT_CONTENT_2 = 13;
    private static final int COLUMN_REPLY_CMT_TIME_2 = 14;
    private static final int COLUMN_REPLY_CMT_FATHER_3 = 15;
    private static final int COLUMN_REPLY_USER_ID_3 = 16;
    private static final int COLUMN_REPLY_ACT_ID_3 = 17;
    private static final int COLUMN_REPLY_CMT_CONTENT_3 = 18;
    private static final int COLUMN_REPLY_CMT_TIME_3 = 19;
    private static final int COLUMN_DELETE_CMT_ID = 20;
    private static final int COLUMN_GET_CMT_ID = 21;
    private static final int COLUMN_EXPECTED_OUTPUT = 22;
    private static final int COLUMN_ACTUAL_OUTPUT = 23;
    private static final int COLUMN_RESULT = 24;
    private static final int COLUMN_TIME = 26;
    private static final int COLUMN_PERSON = 27;

    /**
     * 测试时变量，包括读取进内存的csv表格、总用例数、已执行用例数等
     */
    private static List<String[]> data;
    private static int total = 0;
    private static int executed = 0;

    /**
     * 测试前置函数，通过读取csv文件返回测试用例对象列表。同时重置相关计数器
     * @return StateTransitionTestCase列表
     */
    private static List<StateTransitionTestCase> provideStateTransitionTestCases() {
        List<StateTransitionTestCase> suite = new ArrayList<>();
        data = readCsv(TC_PATH_UNIT_COMMENT + '/' + TEST_CASE_FILENAME);
        total = data.size();
        executed = 1;

        for (int i = 1; i < data.size(); i++) {
            String[] line = data.get(i);

            suite.add(new StateTransitionTestCase(
                    line[COLUMN_ADD_USER_ID],
                    line[COLUMN_ADD_ACT_ID],
                    line[COLUMN_ADD_CMT_CONTENT],
                    line[COLUMN_ADD_CMT_TIME],
                    line[COLUMN_REPLY_CMT_FATHER_1],
                    line[COLUMN_REPLY_USER_ID_1],
                    line[COLUMN_REPLY_ACT_ID_1],
                    line[COLUMN_REPLY_CMT_CONTENT_1],
                    line[COLUMN_REPLY_CMT_TIME_1],
                    line[COLUMN_REPLY_CMT_FATHER_2],
                    line[COLUMN_REPLY_USER_ID_2],
                    line[COLUMN_REPLY_ACT_ID_2],
                    line[COLUMN_REPLY_CMT_CONTENT_2],
                    line[COLUMN_REPLY_CMT_TIME_2],
                    line[COLUMN_REPLY_CMT_FATHER_3],
                    line[COLUMN_REPLY_USER_ID_3],
                    line[COLUMN_REPLY_ACT_ID_3],
                    line[COLUMN_REPLY_CMT_CONTENT_3],
                    line[COLUMN_REPLY_CMT_TIME_3],
                    line[COLUMN_DELETE_CMT_ID],
                    line[COLUMN_GET_CMT_ID]
            ));
        }

        return suite;
    }

    @ParameterizedTest
    @MethodSource("provideStateTransitionTestCases")
    @Description("根据需求分析规约对Comment类级别状态图，构建Robust State Transition Tree并进行测试")
    @Epic("Comment模块")
    @Feature("模块级别状态转换测试")
    @Story("无特定业务故事")
    @Severity(SeverityLevel.BLOCKER)
    @DisplayName("单元测试：Comment模块状态转换测试")
    @Owner("2151294")
    public void stateTransitionTest(StateTransitionTestCase testCase) {
        String[] line = data.get(executed);  //获取测试用例csv文件中的当前行，方便填入内容
        String actualOutput;                 //实际输出

        //调取测试方法，获取实际输出
        try {
            communicateService.addComment(new AddCommentRequest(
                    testCase.getAddCmtContent(),
                    LocalDateTime.parse(testCase.getAddCmtTime(), getFormatter()),
                    Integer.valueOf(testCase.getAddActId()),
                    Integer.valueOf(testCase.getAddUserId())
            ));

            if (!Objects.equals(testCase.getReplyCmtFather1(), "")) {
                communicateService.replyComment(new ReplyCommentRequest(
                        Integer.valueOf(testCase.getReplyCmtFather1()),
                        testCase.getReplyCmtContent1(),
                        LocalDateTime.parse(testCase.getReplyCmtTime1(), getFormatter()),
                        Integer.valueOf(testCase.getReplyActId1()),
                        Integer.valueOf(testCase.getReplyUserId1())
                ));
            }

            if (!Objects.equals(testCase.getReplyCmtFather2(), "")) {
                communicateService.replyComment(new ReplyCommentRequest(
                        Integer.valueOf(testCase.getReplyCmtFather2()),
                        testCase.getReplyCmtContent2(),
                        LocalDateTime.parse(testCase.getReplyCmtTime2(), getFormatter()),
                        Integer.valueOf(testCase.getReplyActId2()),
                        Integer.valueOf(testCase.getReplyUserId2())
                ));
            }

            if (!Objects.equals(testCase.getReplyCmtFather3(), "")) {
                communicateService.replyComment(new ReplyCommentRequest(
                        Integer.valueOf(testCase.getReplyCmtFather3()),
                        testCase.getReplyCmtContent3(),
                        LocalDateTime.parse(testCase.getReplyCmtTime3(), getFormatter()),
                        Integer.valueOf(testCase.getReplyActId3()),
                        Integer.valueOf(testCase.getReplyUserId3())
                ));
            }

            if (!Objects.equals(testCase.getDeleteCmtId(), "")) {
                communicateService.deleteComment(Integer.parseInt(testCase.getDeleteCmtId()));
            }

            actualOutput = String.valueOf(communicateService.getDetailedCommentByCmtId(Integer.parseInt(testCase.getGetCmtId())));
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
            writeCsv(TC_PATH_UNIT_COMMENT + '/' + TEST_CASE_RESULT_FILENAME, data);
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
