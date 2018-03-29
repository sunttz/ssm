package com.snc.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.snc.dao.LogDao;
import com.snc.entity.Log;
import com.snc.entity.Message;
import com.snc.service.LogService;
import com.snc.util.Page;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("logServiceImpl")
public class LogServiceImpl implements LogService {
    @Autowired
    LogDao logDao;

    @Override
    public Page<Log> queryByPage(Map queryMap, Integer pageNo, Integer pageSize) {
        pageNo = pageNo == null ? 1 : pageNo;
        pageSize = pageSize == null ? 20 : pageSize;
        int currIndex = (pageNo-1) * pageSize;
        queryMap.put("currIndex", currIndex);
        queryMap.put("pageSize", pageSize);

        //PageHelper.startPage(pageNo, pageSize);
        List<Log> logs = logDao.selectLogs(queryMap);
        int count = logDao.selectLogsCount(queryMap);
        int totalPageNum = (count  +  pageSize  - 1) / pageSize;
        //用PageInfo对结果进行包装
        //PageInfo<Log> page = new PageInfo<Log>(logs);
        Page<Log> page = new Page<>();
        page.setTotal(totalPageNum);
        page.setRows(logs);
        page.setPage(pageNo);
        page.setRecords(count);
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
