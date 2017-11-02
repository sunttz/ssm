package com.snc.service;

import com.github.pagehelper.PageInfo;
import com.snc.entity.Message;

import java.util.Map;

public interface MessageService {
    PageInfo<Message> queryByPage(Map queryMap, Integer pageNo, Integer pageSize);
}
