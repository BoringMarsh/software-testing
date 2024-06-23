package cn.edu.tongji.springbackend.unit.comment;

import cn.edu.tongji.springbackend.TestException;
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
public class DeleteCommentTest {
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
    private static class DeleteCommentTestCase {
        private String cmtId;
    }

    /**
     * 一些常量，包括测试用例路径、特定内容的列号等
     */
    private static final String TEST_CASE_FILENAME = "delete_comment.csv";
    private static final String TEST_CASE_RESULT_FILENAME = "delete_comment_result.csv";
    private static final String TEST_PERSON = "2151294";
    private static final int COLUMN_CMT_ID = 1;
    private static final int COLUMN_EXPECTED_OUTPUT = 2;
    private static final int COLUMN_ACTUAL_OUTPUT = 3;
    private static final int COLUMN_RESULT = 4;
    private static final int COLUMN_TIME = 6;
    private static final int COLUMN_PERSON = 7;

    /**
     * 测试时变量，包括读取进内存的csv表格、总用例数、已执行用例数等
     */
    private static List<String[]> data;
    private static int total = 0;
    private static int executed = 0;

    /**
     * 测试前置函数，通过读取csv文件返回测试用例对象列表。同时重置相关计数器
     * @return DeleteCommentTestCase列表
     */
    private static List<DeleteCommentTestCase> provideDeleteCommentTestCases() {
        List<DeleteCommentTestCase> suite = new ArrayList<>();
        data = readCsv(TC_PATH_UNIT_COMMENT + '/' + TEST_CASE_FILENAME);
        total = data.size();
        executed = 1;

        for (int i = 1; i < data.size(); i++) {
            suite.add(new DeleteCommentTestCase(data.get(i)[COLUMN_CMT_ID]));
        }

        return suite;
    }

    @ParameterizedTest
    @MethodSource("provideDeleteCommentTestCases")
    @Description("""
            - 用户在社团的活动下方删除自己发表的评论。若评论id不存在报错
            """)
    @Epic("Comment模块")
    @Feature("删除评论")
    @Story("用户在社团的活动下方删除自己发送的评论")
    @Severity(SeverityLevel.BLOCKER)
    @DisplayName("单元测试：删除评论")
    @Owner("2151294")
    @Sql(scripts = "/sql/comment_reset.sql", executionPhase = Sql.ExecutionPhase.BEFORE_TEST_METHOD)
    public void addCommentTest(DeleteCommentTestCase testCase) {
        String[] line = data.get(executed);  //获取测试用例csv文件中的当前行，方便填入内容
        String actualOutput;                 //实际输出

        //调取测试方法，获取实际输出
        try {
            communicateService.deleteComment(Integer.parseInt(testCase.getCmtId()));
            actualOutput = "delete comment success";
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
        updateBlock(data, executed, COLUMN_RESULT, result ? "通过测试" : "未通过测试");

        //若执行到最后一行，将填入后的数据写入结果csv文件
        if (executed == total - 1)
            writeCsv(TC_PATH_UNIT_COMMENT + '/' + TEST_CASE_RESULT_FILENAME, data);
        else
            executed++;

        //若不通过则直接抛出未通过异常，给后续报告捕获该信息
        if (!result)
            throw new TestException(executed, line[COLUMN_EXPECTED_OUTPUT], actualOutput);
    }
}
