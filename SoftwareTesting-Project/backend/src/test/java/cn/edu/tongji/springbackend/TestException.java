package cn.edu.tongji.springbackend;

public class TestException extends RuntimeException {
    public TestException(int testCaseNo, String expectedOutput, String actualOutput) {
        super("Test case " + testCaseNo + " not passed: expecting \"" + expectedOutput + "\", actually \"" + actualOutput +"\"");
    }
}
