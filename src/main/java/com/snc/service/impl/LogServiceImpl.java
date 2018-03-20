package com.snc.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.snc.dao.LogDao;
import com.snc.entity.Log;
import com.snc.service.LogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("logServiceImpl")
public class LogServiceImpl implements LogService {
    @Autowired
    LogDao logDao;

    @Override
    public PageInfo<Log> queryByPage(Map queryMap, Integer pageNo, Integer pageSize) {
        pageNo = pageNo == null ? 1 : pageNo;
        pageSize = pageSize == null ? 20 : pageSize;
        PageHelper.startPage(pageNo, pageSize);
        List<Log> logs = logDao.selectLogs(queryMap);
        //用PageInfo对结果进行包装
        PageInfo<Log> page = new PageInfo<Log>(logs);
        return page;
    }

    @Override
    public List<String> selectHostips() {
        return logDao.selectHostips();
    }

    @Override
    public List<String> selectPortByIp(String ip) {
        return logDao.selectPortByIp(ip);
    }
}
