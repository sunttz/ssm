package com.snc.service;

import com.snc.entity.Log;
import com.snc.util.Page;

import java.util.List;
import java.util.Map;

public interface LogService {

    /**
     * 分页查询log列表
     * @param queryMap
     * @param pageNo
     * @param pageSize
     * @return
     */
    Page<Log> queryByPage(Map queryMap, Integer pageNo, Integer pageSize);

    /**
     * ip列表
     * @return
     */
    List<String> selectHostips();

    /**
     * 查询指定ip的端口列表
     * @param ip
     * @return
     */
    List<String> selectPortByIp(String ip);
}
