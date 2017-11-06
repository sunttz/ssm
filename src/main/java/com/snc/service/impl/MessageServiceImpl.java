package com.snc.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.snc.dao.MessageDao;
import com.snc.entity.Message;
import com.snc.service.MessageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("messageServiceImpl")
public class MessageServiceImpl implements MessageService {
    @Autowired
    MessageDao messageDao;

    @Override
    public PageInfo<Message> queryByPage(Map queryMap, Integer pageNo, Integer pageSize) {
        pageNo = pageNo == null ? 1 : pageNo;
        pageSize = pageSize == null ? 20 : pageSize;
        PageHelper.startPage(pageNo, pageSize);
        List<Message> messages = messageDao.selectMessages(queryMap);
        //用PageInfo对结果进行包装
        PageInfo<Message> page = new PageInfo<Message>(messages);
        return page;
    }

    @Override
    public List<String> selectHostips() {
        return messageDao.selectHostips();
    }
}
