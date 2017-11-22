<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" pageEncoding="UTF-8"%>
<html lang="cn">
<jsp:include page="/WEB-INF/jsp/common/commonHead.jsp" flush="true"/>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<script type="text/javascript">
		$(function(){
			var jqOption;
            jqOption = {
                url: 'message/messageList.do',//组件创建完成之后请求数据的url
                datatype: "json",//请求数据返回的类型。可选json,xml,txt
                postData: {starttime: '', endtime: ''},
                colNames: [ 'IP', '主机名称', '端口', "标题", '规则', "内容", '内置告警时间', "程序插入时间"],//jqGrid的列显示名字
                colModel: [ //jqGrid每一列的配置信息。包括名字，索引，宽度,对齐方式.....
                    {name: 'hostip', index: 'hostip', width: '8%', align: "center"},
                    {name: 'servername', index: 'servername', width: '8%', align: "center"},
                    {name: 'port', index: 'port', width: '3%', align: "center"},
                    {name: 'title', index: 'title', width: '15%', align: "center"},
                    {name: 'rule', index: 'rule', width: '15%', align: "center"},
                    {name: 'content', index: 'content', width: '20%', align: "center"},
                    {name: 'watchtime', index: 'watchtime', width: '13%', align: "center"},
                    {
                        name: 'jmxtime',
                        index: 'jmxtime',
                        width: '10%',
                        align: "center",
                        formatter: function (cellvalue, options, row) {
                            return getLocalTime(cellvalue)
                        }
                    }
                ],
                rowNum: 20,//一页显示多少条
                rownumbers: true,
                rowList: [20, 50, 100],//可供用户选择一页显示多少条
                pager: '#pageGridPager',//表格页脚的占位符(一般是div)的id
                sortname: 'id',//初始化的时候排序的字段
                sortorder: "desc",//排序方式,可选desc,asc
                mtype: "post",//向后台请求数据的ajax的类型。可选post,get
                viewrecords: true,
                caption: "检索结果",//表格的标题名字
                autoWidth: true,
                jsonReader: {
                    root: "list",   // json中代表实际模型数据的入口
                    page: "pageNum",   // json中代表当前页码的数据
                    total: "pages", // json中代表页码总数的数据
                    records: "total" // json中代表数据行总数的数据
                }
            };
			//创建jqGrid组件
			jQuery("#pageGrid").jqGrid(jqOption).setGridWidth($(window).width()-200);
			/*创建jqGrid的操作按钮容器*/
			/*可以控制界面上增删改查的按钮是否显示*/
			jQuery("#pageGrid").jqGrid('navGrid', '#pageGridPager', {edit : false,add : false,del : false,search: false});
			var newHeight = $(window).height() - 200;
			$(".ui-jqgrid .ui-jqgrid-bdiv").css("cssText","height: "+newHeight+"px!important;");
			$(window).resize(function() {
				$("#pageGrid").setGridWidth($(window).width()-200);
			});


			
			$("#searchBtn").bind("click",function () {
                var starttime = $("#starttime").val();
                var endtime = $("#endtime").val();
                var hostip = $("#hostip").val();
                var port = $("#port").val();

                $("#pageGrid").jqGrid('setGridParam', { // 重新加载数据
                    datatype: 'json',
                    postData: {
                        starttime: starttime,
                        endtime : endtime,
                        hostip : hostip,
                        port : port
                    },
                    page: 1
                }).trigger("reloadGrid");
            });

			// ip选择框
            $.ajax({
                url:'${base}/message/getHostips.do',
                sync:false,
                type : 'post',
                data : {},
                dataType : "json",
                error : function(data) {
                    console.info("网络异常");
                    return false;
                },
                success : function(data) {
                    data = eval(data);
                    var options = "";
					for(var i=0; i<data.length; i++){
						options += '<option value="'+data[i]+'">'+data[i]+'</option>';
                    }
					$("#hostip").append(options);
                }
            });

            // 端口选择框
            $("#hostip").change(function () {
                $.ajax({
                    url:'${base}/message/getPortByIp.do',
                    sync:false,
                    type : 'post',
                    data : {ip:$("#hostip").val()},
                    dataType : "json",
                    error : function(data) {
                        console.info("网络异常");
                        return false;
                    },
                    success : function(data) {
                        data = eval(data);
                        var options = '<option value="">请选择</option>';
                        for(var i=0; i<data.length; i++){
                            options += '<option value="'+data[i]+'">'+data[i]+'</option>';
                        }
                        $("#port").html(options);
                    }
                });
            });

		});

        function getLocalTime(nS) {
            return new Date(parseInt(nS)).toLocaleString().replace(/年|月/g, "-").replace(/日/g, " ");
        }
	</script>
</head>

<body>

	<form action="">
		<div class="container" style="margin: 10px 10px 10px 10px;">

			<div class="form-group">
				<div class="col-sm-12" style="margin-bottom: 5px;width: 1240px;">
					<label for="starttime" class="control-label pull-left" style="margin: 5px 0px 0px 10px;">开始时间：</label>
					<div class="col-sm-2">
						<input type="text" name="starttime" class="form-control" id="starttime" onclick="WdatePicker({doubleCalendar:false,dateFmt:'yyyy-MM-dd HH:mm:ss',autoPickDate:true,maxDate:'#F{$dp.$D(\'endtime\')||\'%y-%M-%d %H:%m:%s\'}'});" />
					</div>
					<label for="endtime" class="control-label pull-left" style="margin: 5px 0px 0px 10px;">结束时间：</label>
					<div class="col-sm-2">
						<input type="text" name="endtime" class="form-control" id="endtime" onclick="WdatePicker({doubleCalendar:false,minDate:'#F{$dp.$D(\'starttime\')}',maxDate:'%y-%M-%d %H:%m:%s',dateFmt:'yyyy-MM-dd HH:mm:ss',autoPickDate:true});" />
					</div>
					<label for="hostip" class="control-label pull-left" style="margin: 5px 0px 0px 10px;">IP：</label>
					<div class="col-sm-2">
						<select name="hostip" class="form-control" id="hostip">
							<option value="">---请选择---</option>
						</select>
					</div>
					<label for="port" class="control-label pull-left" style="margin: 5px 0px 0px 10px;">端口：</label>
					<div class="col-sm-1">
						<select name="port" class="form-control" id="port" style="width: 80px;">
							<option value="">请选择</option>
						</select>
					</div>
					<div>
						<button type="button" class="btn btn-primary"
							id="searchBtn">检索</button>
						<button type="button" class="btn btn-primary"
								id="alartTrend" onclick="window.location.href='message/messageTrend.do'">告警趋势图</button>
					</div>
				</div>
			</div>
			<div class="col-sm-12">
				<table id="pageGrid" rel="jqgridForm" class="jqgrid"></table>
				<div id="pageGridPager"></div>
			</div>
		</div>
	</form>
</body>
</html>