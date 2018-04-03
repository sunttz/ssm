package com.snc.controller;

import com.snc.entity.Message;
import com.snc.service.MessageService;
import com.snc.util.Page;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/message")
public class MessageController {
    @Autowired
    MessageService messageService;

    @RequestMapping(value = "/messageList")
    @ResponseBody
    public Object getMessageList(HttpServletRequest request, Model model) {
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
        Page<Message> messagePage = messageService.queryByPage(queryMap, pageNo, pageSize);
        return messagePage;
    }

    @RequestMapping(value = "/getHostips")
    @ResponseBody
    public Object getHostips(Model model){
        List<String> ips = messageService.selectHostips();
        return ips;
    }

    @RequestMapping(value = "/getPortByIp")
    @ResponseBody
    public Object getPortByIp(Model model,HttpServletRequest request){
        String ip = request.getParameter("ip");
        List<String> ports = new ArrayList<>();
        if (!StringUtils.isEmpty(ip)) {
            ports = messageService.selectPortByIp(ip);
        }
        return ports;
    }

    @RequestMapping(value = "/getTrendVal")
    @ResponseBody
    public Object getTrendVal(Model model,HttpServletRequest request){
        String starttime = request.getParameter("starttime");
        String endtime = request.getParameter("endtime");
        String hostip = request.getParameter("hostip");
        String port = request.getParameter("port");
        String alarmType = request.getParameter("alarmType");
        // 封装查询参数
        Map queryMap = new HashMap<String,String>();
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
        if (!StringUtils.isEmpty(alarmType)) {
            queryMap.put("alarmType", alarmType);
        }
        List<Map<String, Object>> trendVals = null;
        if(queryMap.size() == 5){
            trendVals = messageService.selectVals(queryMap);
        }
        return trendVals;
    }

    /**
     * 趋势图
     * @return
     */
    @RequestMapping ( "/messageTrend" )
    public ModelAndView messageTrend() {
        ModelAndView modelAndView = new ModelAndView("messageTrend");
        return modelAndView;
    }

    @RequestMapping("/getThreadDzException")
    @ResponseBody
    public Object getThreadDzException(){
        List<Map<String, Object>> maps = messageService.selectThreadDzException();
        return maps;
    }
}
