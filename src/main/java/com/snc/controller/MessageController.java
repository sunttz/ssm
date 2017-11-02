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
        PageInfo<Message> messagePageInfo = messageService.queryByPage(queryMap, pageNo, pageSize);
        return messagePageInfo;
    }
}
