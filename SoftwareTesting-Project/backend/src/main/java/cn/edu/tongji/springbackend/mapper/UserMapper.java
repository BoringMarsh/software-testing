package cn.edu.tongji.springbackend.mapper;

import cn.edu.tongji.springbackend.model.User;
import org.apache.ibatis.annotations.*;


import java.util.List;

@Mapper
public interface UserMapper {
    List<User> getAll();
    User getUserById(Integer userId);
    int insertUser(User user);
    User getUserByUsername(@Param("username") String username);
    void updateUser(User user);
    void deleteUserById(@Param("userId") int userId);
    int getCountByUserRole(@Param("role") int role);
}
