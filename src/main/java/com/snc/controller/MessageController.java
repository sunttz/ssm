package com.snc.controller;

import com.github.pagehelper.PageInfo;
import com.snc.entity.Message;
import com.snc.service.MessageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
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
        PageInfo<Message> messagePageInfo = messageService.queryByPage(queryMap, pageNo, pageSize);
        return messagePageInfo;
    }

    @RequestMapping(value = "/getHostips")
    @ResponseBody
    public Object getHostips(Model model){
        List<String> ips = messageService.selectHostips();
        return ips;
    }
}
