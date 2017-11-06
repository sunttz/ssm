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
}
