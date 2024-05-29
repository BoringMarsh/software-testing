package cn.edu.tongji.springbackend.util;

import java.time.format.DateTimeFormatter;

public class TimeUtils {
    public static DateTimeFormatter getFormatter() {
        return DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    }
}
