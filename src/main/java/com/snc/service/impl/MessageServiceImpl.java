package com.snc.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.snc.dao.MessageDao;
import com.snc.entity.Message;
import com.snc.service.MessageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
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

    @Override
    public List<String> selectPortByIp(String ip) {
        return messageDao.selectPortByIp(ip);
    }

    @Override
    public List<Map<String, Object>> selectVals(Map queryMap) {
        String alarmType = queryMap.get("alarmType").toString();
        String jqStr = ""; // 截取字符串
        //String addNum = ""; // 补位数字
        String alarmKey = ""; // 告警关键字
        if("jdbc".equals(alarmType)){
            jqStr = "ConnectionDelayTime = ";
            //addNum = "22";
            alarmKey = "%JDBC%";
        }else if("jvm".equals(alarmType)){
            jqStr = "HeapFreePercent = ";
            //addNum = "18";
            alarmKey = "%JVM%";
        }else if("threadDz".equals(alarmType)){
            jqStr = "HoggingThreadCount = ";
            //addNum = "21";
            alarmKey = "%独占%";
        }else if("weblogic".equals(alarmType)){
            alarmKey = "%weblogic%";
        }else if("threadZz".equals(alarmType)){
            jqStr = "StuckThreadCount = ";
            alarmKey = "%线程粘滞%";
        }
        queryMap.put("jqStr",jqStr);
        //queryMap.put("addNum",addNum);
        queryMap.put("alarmKey",alarmKey);

        List<Map<String, Object>> vals = new ArrayList<>();
        if("weblogic".equals(alarmType)){
            vals = messageDao.selectVals_weblogic(queryMap);
        }else{
            vals = messageDao.selectVals(queryMap);
        }
        return vals;
    }
}
