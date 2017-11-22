package com.snc.service;

import com.github.pagehelper.PageInfo;
import com.snc.entity.Message;

import java.util.List;
import java.util.Map;

public interface MessageService {
    PageInfo<Message> queryByPage(Map queryMap, Integer pageNo, Integer pageSize);

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

    /**
     * 查询val值列表
     * @return
     */
    List<Map<String, Object>> selectVals(Map queryMap);
}
