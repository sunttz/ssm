package com.snc.controller;

import com.snc.entity.Log;
import com.snc.service.LogService;
import com.snc.util.Page;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/log")
public class LogController {

    @Autowired
    LogService logService;

    @RequestMapping(value = "logList")
    public String logList(){
        return "logList";
    }

    @RequestMapping(value = "/getLogList")
    @ResponseBody
    public Object getLogList(HttpServletRequest request, Model model) {
        String starttime = request.getParameter("starttime");
        String endtime = request.getParameter("endtime");
        String hostip = request.getParameter("hostip");
        String port = request.getParameter("port");
        int pageNo = Integer.parseInt(request.getParameter("page"));
        int pageSize = Integer.parseInt(request.getParameter("rows"));
        // 封装查询参数
        Map queryMap = new HashMap<>();
        if (!StringUtils.isEmpty(starttime)) {
            queryMap.put("starttime", starttime);
        }
        if (!StringUtils.isEmpty(endtime)) {
            queryMap.put("endtime", endtime);
        }
        if (!StringUtils.isEmpty(hostip)) {
            queryMap.put("hostip", hostip);
        }
        if (!StringUtils.isEmpty(port)) {
            queryMap.put("port", port);
        }
        Page<Log> logPage = logService.queryByPage(queryMap, pageNo, pageSize);
        return logPage;
    }

    @RequestMapping(value = "/getHostips")
    @ResponseBody
    public Object getHostips(Model model){
        List<String> ips = logService.selectHostips();
        return ips;
    }

    @RequestMapping(value = "/getPortByIp")
    @ResponseBody
    public Object getPortByIp(Model model,HttpServletRequest request){
        String ip = request.getParameter("ip");
        List<String> ports = new ArrayList<>();
        if (!StringUtils.isEmpty(ip)) {
            ports = logService.selectPortByIp(ip);
        }
        return ports;
    }
}
