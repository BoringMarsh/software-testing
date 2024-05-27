package cn.edu.tongji.springbackend.mapper;

import cn.edu.tongji.springbackend.model.Appeal;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Mapper
@Repository
public interface AppealMapper {
    Appeal getById(@Param("appId") int appId);
    int getCount();
    List<Appeal> getByPage(
            @Param("timeOrder") int timeOrder,
            @Param("length") int length,
            @Param("start") int start
    );
    void add(Appeal appeal);
}
