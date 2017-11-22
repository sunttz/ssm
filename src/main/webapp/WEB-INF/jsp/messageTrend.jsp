<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<jsp:include page="/WEB-INF/jsp/common/commonHead.jsp" flush="true"/>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>告警趋势图</title>
    <script type="text/javascript" src="${pageContext.request.contextPath }/plugin/echarts/echarts.min.js"></script>
    <script type="text/javascript">
        var myChart = null;
        $(function(){
            // 默认最近一周
            var startdate = getDateStr(-6) + " 00:00:00";
            var enddate = getDateStr(0) + " 23:59:59";
            $("#starttime").val(startdate);
            $("#endtime").val(enddate);

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

            // 初始化告警图表start
            myChart = echarts.init(document.getElementById('alarmTrend'));
            var date = [];
            var data = [];
            var option = {
                tooltip: {
                    trigger: 'axis',
                    position: function (pt) {
                        return [pt[0], '10%'];
                    },
                    formatter: function( params ) {
                        return params[0].seriesName + '<br/>' + formatDate(params[0].name) + ' ：' + params[0].data;
                    }
                },
                title: {
                    left: 'center',
                    text: '告警趋势图',
                },
                xAxis: {
                    type: 'category',
                    boundaryGap: false,
                    data: date,
                    axisLabel: {
                        show: true, // 默认为true
                        formatter: function(data) {
                            return formatDate(data);
                        },
                        //interval: 0
                    }
                },
                yAxis: {
                    type: 'value',
                    boundaryGap: [0, '100%']
                },
                dataZoom: [{
                    type: 'inside',
                    start: 0,
                    end: 100
                }, {
                    start: 0,
                    end: 100,
                    handleIcon: 'M10.7,11.9v-1.3H9.3v1.3c-4.9,0.3-8.8,4.4-8.8,9.4c0,5,3.9,9.1,8.8,9.4v1.3h1.3v-1.3c4.9-0.3,8.8-4.4,8.8-9.4C19.5,16.3,15.6,12.2,10.7,11.9z M13.3,24.4H6.7V23h6.6V24.4z M13.3,19.6H6.7v-1.4h6.6V19.6z',
                    handleSize: '80%',
                    handleStyle: {
                        color: '#fff',
                        shadowBlur: 3,
                        shadowColor: 'rgba(0, 0, 0, 0.6)',
                        shadowOffsetX: 2,
                        shadowOffsetY: 2
                    }
                }],
                series: [
                    {
                        name:'JDBC告警',
                        type:'line',
                        smooth:true,
                        symbol: 'none',
                        //symbolSize : 10,
                        sampling: 'average',
                        itemStyle: {
                            normal: {
                                color: 'rgb(255, 70, 131)'
                            }
                        },
                        areaStyle: {
                            normal: {
                                color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
                                    offset: 0,
                                    color: 'rgb(255, 158, 68)'
                                }, {
                                    offset: 1,
                                    color: 'rgb(255, 70, 131)'
                                }])
                            }
                        },
                        data: data
                    }
                ]
            };
            myChart.setOption(option);
            // 初始化告警图表end
        });

        // 检索
        function search(){
            var starttime = $("#starttime").val();
            var endtime = $("#endtime").val();
            var hostip = $("#hostip").val();
            var port = $("#port").val();
            var alarmType = $("#alarmType option:selected").val();
            var msg = "";
            if(starttime == null || starttime == ""){
                msg += "开始时间不能为空<br/>";
            }
            if(endtime == null || endtime == ""){
                msg += "结束时间不能为空<br/>";
            }
            if(hostip == null || hostip == ""){
                msg += "IP不能为空<br/>";
            }
            if(port == null || port == ""){
                msg += "端口不能为空<br/>";
            }
            if(alarmType == null || alarmType == ""){
                msg += "告警类型不能为空<br/>";
            }
            if(msg != ""){
                $("#msgText").html(msg);
                $('#myModal').modal('show');
                return;
            }
            myChart.showLoading();
            var date = [];
            var data = [];
            $.ajax({
                url:'${base}/message/getTrendVal.do',
                sync:false,
                type : 'post',
                data : {starttime:starttime,endtime:endtime,hostip:hostip,port:port,alarmType:alarmType},
                dataType : "json",
                error : function(data) {
                    console.info("网络异常");
                    return false;
                },
                success : function(dd) {
                    dd = eval(dd);
                    if(dd != null){
                        for(var i=0; i<dd.length; i++){
                            var row = dd[i];
                            date.push(row.jmxtime);
                            data.push($.trim(row.val));
                        }
                        var option = {};
                        if(alarmType == "jdbc"){
                            option = {
                                xAxis: {
                                    data: date,
                                },
                                series: [
                                    {
                                        name:'JDBC延迟告警（ConnectionDelayTime）',
                                        data: data,
                                        symbol: 'none',
                                        smooth:true
                                    }
                                ]
                            };
                            myChart.setOption(option);
                            myChart.hideLoading();
                        }else if(alarmType == "jvm"){
                            option = {
                                xAxis: {
                                    data: date,
                                },
                                series: [
                                    {
                                        name:'jvm内存剩余告警（HeapFreePercent）',
                                        data: data,
                                        symbol: 'none',
                                        smooth:true
                                    }
                                ]
                            };
                            myChart.setOption(option);
                            myChart.hideLoading();
                        }else if(alarmType == "thread"){
                            option = {
                                xAxis: {
                                    data: date,
                                },
                                series: [
                                    {
                                        name:'线程独占告警（HoggingThreadCount）',
                                        data: data,
                                        symbol: 'none',
                                        smooth:true
                                    }
                                ]
                            };
                            myChart.setOption(option);
                            myChart.hideLoading();
                        }else if(alarmType == "weblogic"){
                            option = {
                                xAxis: {
                                    data: date,
                                },
                                series: [
                                    {
                                        name:'weblogic在关闭告警',
                                        data: data,
                                        smooth:false,
                                        symbol: 'emptyCircle',
                                        symbolSize : 8,
                                    }
                                ]
                            };
                            myChart.setOption(option);
                            myChart.hideLoading();
                        }
                    }else{
                        $("#msgText").html("参数异常");
                        $('#myModal').modal('show');
                    }
                }
            });
        }

        //获取addDayCount天后的日期
        function getDateStr(addDayCount){
            var dd = new Date();
            dd.setDate(dd.getDate()+addDayCount);
            var y = dd.getFullYear();
            var m = (dd.getMonth()+1)<10?"0"+(dd.getMonth()+1):(dd.getMonth()+1);//获取当前月份的日期，不足10补0
            var d = dd.getDate()<10?"0"+dd.getDate():dd.getDate(); //获取当前几号，不足10补0
            return y+"-"+m+"-"+d;
        }

        function formatDate(nS) {
            var datetime = new Date(parseInt(nS));
            var year = datetime.getFullYear(),
                month = (datetime.getMonth() + 1 < 10) ? '0' + (datetime.getMonth() + 1):datetime.getMonth() + 1,
                day = datetime.getDate() < 10 ? '0' +  datetime.getDate() : datetime.getDate(),
                hour = datetime.getHours() < 10 ? '0' + datetime.getHours() : datetime.getHours(),
                min = datetime.getMinutes() < 10 ? '0' + datetime.getMinutes() : datetime.getMinutes(),
                sec = datetime.getSeconds() < 10 ? '0' + datetime.getSeconds() : datetime.getSeconds();
            return year + '-' + month + '-' + day + ' ' + hour + ':' + min + ':' + sec;
        }
    </script>
</head>
<body>
    <form action="">
        <div style="margin: 10px 10px 10px 10px">

            <div class="form-group">
                <div style="margin-bottom: 5px; ">
                    <div style="display: inline-block">
                        <label for="starttime" class="control-label pull-left" style="margin: 5px 0px 0px 10px;">开始时间：</label>
                        <input type="text" name="starttime" class="form-control" style="width: 160px;" id="starttime" onclick="WdatePicker({doubleCalendar:false,dateFmt:'yyyy-MM-dd HH:mm:ss',autoPickDate:true,maxDate:'#F{$dp.$D(\'endtime\')||\'%y-%M-%d %H:%m:%s\'}'});" />
                    </div>
                    <div style="display: inline-block">
                        <label for="endtime" class="control-label pull-left" style="margin: 5px 0px 0px 10px;">结束时间：</label>
                        <input type="text" name="endtime" class="form-control" style="width: 160px;" id="endtime" onclick="WdatePicker({doubleCalendar:false,minDate:'#F{$dp.$D(\'starttime\')}',maxDate:'%y-%M-%d 23:59:59',dateFmt:'yyyy-MM-dd HH:mm:ss',autoPickDate:true});" />
                    </div>
                    <div style="display: inline-block">
                        <label for="hostip" class="control-label pull-left" style="margin: 5px 0px 0px 10px;">IP：</label>
                        <select name="hostip" class="form-control" id="hostip" style="width: 160px;">
                            <option value="">---请选择---</option>
                        </select>
                    </div>
                    <div style="display: inline-block">
                        <label for="port" class="control-label pull-left" style="margin: 5px 0px 0px 10px;">端口：</label>
                        <select name="port" class="form-control" id="port" style="width: 80px;">
                            <option value="">请选择</option>
                        </select>
                    </div>
                    <div style="display: inline-block">
                        <label for="alarmType" class="control-label pull-left" style="margin: 5px 0px 0px 10px;">告警类型：</label>
                        <select name="alarmType" class="form-control" id="alarmType" style="width: 160px;">
                            <option value="">---请选择---</option>
                            <option value="jdbc">JDBC延迟告警</option>
                            <option value="jvm">jvm内存剩余告警</option>
                            <option value="weblogic">weblogic在关闭告警</option>
                            <option value="thread">线程独占告警</option>
                        </select>
                    </div>
                    <div style="display: inline-block">
                        <button type="button" class="btn btn-primary"
                                id="searchBtn" onclick="search()">检索</button>
                    </div>
                </div>
            </div>
            <div class="col-sm-12">
                <div id="alarmTrend" style="width: 1200px;height:600px;"></div>
            </div>
        </div>
    </form>

    <!-- 提示框 -->
    <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                        &times;
                    </button>
                    <h4 class="modal-title" id="myModalLabel">
                        提示
                    </h4>
                </div>
                <div class="modal-body">
                    <span id="msgText"></span>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭
                    </button>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
