package cn.edu.tongji.springbackend.exceptions;

public class RegisterException extends RuntimeException {
    public RegisterException(String message) {
        super(message);
    }
}
