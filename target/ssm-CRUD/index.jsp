<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" import="java.util.*" language="java" pageEncoding="utf-8" isELIgnored="false" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<meta http-equiv="content-type" content="text/html;charset=UTF-8">
<head>
    <title>员工列表</title>
    <%
        String path = request.getContextPath();
        String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path;
        pageContext.setAttribute("APP_PATH",basePath);
//        request.getScheme()       获取协议
//        request.getServerName()   获取地址
//        request.getServerPort()   获取端口号
    %>
    <%--  web路径：
                 不以/开始的相对路径，找资源，以当前资源路径为基准（容易出问题）
                 以/开始的相对路径，找资源，以服务器的路径为标准：
                        http://localhost:8080/crud
    --%>
    <%-- jQuery (Bootstrap 的所有 JavaScript 插件都依赖 jQuery，所以必须放在前边) --%>
    <script type="text/javascript" src="${APP_PATH}/static/js/jquery-3.1.1.js"></script>
    <script type="text/javascript" src="${APP_PATH}/static/js/jquery-3.1.1.min.js"></script>
    <%--  引入bootstrap样式  --%>
    <link href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
    <%-- 加载 Bootstrap 的所有 JavaScript 插件。你也可以根据需要只加载单个插件。 --%>
    <script src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
</head>
<body>

<!--员工添加的模态框 -->
<div class="modal fade" id="empAddModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">员工添加</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">员工姓名</label>
                        <div class="col-sm-10">
                            <input type="text" name="empName" class="form-control" id="empName_add_input" placeholder="员工姓名">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">邮箱地址</label>
                        <div class="col-sm-10">
                            <input type="text" name="email" class="form-control" id="email_add_input" placeholder="email@bosszrx.com">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">性别</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender1_add_input" value="男" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2_add_input" value="女"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">部门名称</label>
                        <div class="col-sm-6">
                            <%--  部门提交id即可  --%>
                            <select class="form-control" name="dId">

                            </select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
            </div>
        </div>
    </div>
</div>

<!--员工修改的模态框 -->
<div class="modal fade" id="empUpdateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" >员工修改</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">员工姓名</label>
                        <div class="col-sm-10">
                            <p class="form-control-static" id="empName_update_static"></p>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">邮箱地址</label>
                        <div class="col-sm-10">
                            <input type="text" name="email" class="form-control" id="email_update_input" placeholder="email@bosszrx.com">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">性别</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender1_update_input" value="男" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2_update_input" value="女"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">部门名称</label>
                        <div class="col-sm-6">
                            <%--  部门提交id即可  --%>
                            <select class="form-control" name="dId">

                            </select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_update_btn">保存</button>
            </div>
        </div>
    </div>
</div>


<%--搭建显示页面--%>
<div class="container">
    <%--  标题行  --%>
    <div class="row">
        <div class="col-lg-12">
            <h1>SSM-CRUD</h1>
        </div>
    </div>
    <%--  按钮   --%>
    <div class="row">
        <div class="col-lg-4 col-lg-offset-8">
            <button class="btn btn-primary" id="emp_Add_modal_btn">新增</button>
            <button class="btn btn-danger" id="emp_delete_all_btn">多选删除</button>
        </div>
    </div>
    <%--  显示表格数据   --%>
    <div class="row">
        <table class="table table-hover" id="emps_table">
            <thead>
                <tr>
                    <th>
                        <input type="checkbox" id="check_all">
                    </th>
                    <th>编号</th>
                    <th>员工名称</th>
                    <th>性别</th>
                    <th>邮箱</th>
                    <th>部门名称</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>

            </tbody>
        </table>
    </div>
    <%--  显示分页信息   --%>
    <div class="row">
        <%-- 分页文字信息 --%>
        <div class="col-lg-6" id="page_info_area">
        </div>
        <%-- 分页条信息 --%>
        <div class="col-lg-6" id="page_nav_area">
        </div>
    </div>
</div>

<script type="text/javascript">
    //全局变量，用于全局调用数据
    var totalRecord,currentNum;

    $(function () {
       to_page(1);
    });

    function to_page(pn) {
        $.ajax({
            url:"${APP_PATH}/emps",
            data:"pn="+pn,
            type:"get",
            dataType:"json",
            success:function (result) {
                //console.log(result);
                //解析并显示员工数据
                build_emps_table(result);
                //解析并显示分页信息
                build_page_info(result);
                //解释显示分页条数据
                build_page_nav(result);
            }
        });
    }

    //创建表里的字段和数据
    function build_emps_table(result) {
        //清空table表格数据
        $("#emps_table tbody").empty();

        var emps=result.extend.pageInfo.list;
        $.each(emps,function (index,item) {
            var checkBoxTd=$("<td><input type='checkbox' class='check_item'/></td>");
            var empIdTd=$("<td></td>").append(item.empId);
            var empNameTd=$("<td></td>").append(item.empName);
            var empGenderTd=$("<td></td>").append(item.gender);
            var empEmailTd=$("<td></td>").append(item.email);
            var deptNameId=$("<td></td>").append(item.department.deptName);

            var editBtn=$("<button></button>").addClass("btn btn-primary btn-sm edit_btn")
                .append($("<span></span>").addClass("glyphicon glyphicon-pencil")).append("编辑");
            //为编辑按钮添加一个自定义的属性，来表示当前id
            editBtn.attr("edit-id",item.empId);

            var deltBtn=$("<button></button>").addClass("btn btn-danger btn-sm delete_btn")
                .append($("<span></span>").addClass("glyphicon glyphicon-trash")).append("删除");
            //为删除按钮添加一个自定义的属性，来表示当前id
            deltBtn.attr("del-id",item.empId);
            var btnTd=($("<td></td>")).append(editBtn).append(" ").append(deltBtn);
            $("<tr></tr>")
                .append(checkBoxTd)
                .append(empIdTd)
                .append(empNameTd)
                .append(empGenderTd)
                .append(empEmailTd)
                .append(deptNameId)
                .append(btnTd)
                .appendTo("#emps_table tbody");
        });
    }
    //解析显示分页信息
    function build_page_info(result) {
        //分页之前清空信息
        $("#page_info_area").empty();
        //当前页，总 页，总 条记录
        $("#page_info_area").append("当前页"+result.extend.pageInfo.pageNum
                                    +"总"+result.extend.pageInfo.pages+"页"
                                    +"总"+result.extend.pageInfo.total+"条记录");
        totalRecord=result.extend.pageInfo.total;
        currentNum=result.extend.pageInfo.pageNum;
    }
    //解释显示分页条数据
    function build_page_nav(result) {
        //清空分页条数据信息
        $("#page_nav_area").empty();
        var ul=$("<ul></ul>").addClass("pagination");

        //构建元素
        var firstPageLi=$("<li></li>").append($("<a></a>").append("首页").attr("href","#"));
        var prePageLi=$("<li></li>").append($("<a></a>").append("&laquo;"));
        //判断是否有前一页
        if (result.extend.pageInfo.hasPreviousPage==false){
            firstPageLi.addClass("disabled");
            prePageLi.addClass("disabled");
        }else{
            //给元素绑定单击翻页事件
            firstPageLi.click(function () {
                //首页单击事件
                to_page(1);
            });
            prePageLi.click(function () {
                //下一页单击事件
                to_page(result.extend.pageInfo.pageNum-1);
            });
        }



        //构建元素
        var nextPageLi=$("<li></li>").append($("<a></a>").append("&raquo;"));
        var lastPageLi=$("<li></li>").append($("<a></a>").append("尾页").attr("href","#"));
        //判断是否有下一页
        if (result.extend.pageInfo.hasNextPage==false){
            nextPageLi.addClass("disabled");
            lastPageLi.addClass("disabled");
        }else {
            //给元素绑定单击翻页事件
            nextPageLi.click(function () {
                //尾页单击事件
                to_page(result.extend.pageInfo.pageNum+1);
            });
            lastPageLi.click(function () {
                //上一页单击事件
                to_page(result.extend.pageInfo.pages);
            });
        }



        //添加首页和上一页的提示
        ul.append(firstPageLi).append(prePageLi)
        //遍历给ui中添加页码
        $.each(result.extend.pageInfo.navigatepageNums,function (index,item) {
            var numLi=$("<li></li>").append($("<a></a>").append(item));
            //判断是不是当前正在遍历的页码
            if (result.extend.pageInfo.pageNum==item){
                numLi.addClass("active");
            }
            numLi.click(function () {
                to_page(item);
            });
            ul.append(numLi);
        });
        //添加下一页和末页的提示
        ul.append(nextPageLi).append(lastPageLi);

        //把ui 加入到nav标签中
        var  navEle=$("<nav></nav>").append(ul);
        navEle.appendTo("#page_nav_area");
    }

    //点击新增弹出模态框
    $("#emp_Add_modal_btn").click(function () {
        //清除表单数据（表单完全重置，包括样式和数据）
        reset_from("#empAddModal form");
        //发送ajax请求，查出部门信息，显示在下拉列表中
        getDepts("#empAddModal select");

        //弹出模态框
        $("#empAddModal").modal({
            backdrop:"static"
        });
    });

    //清空表单数据和样式，重置表单
    function reset_from(ele) {
        //重置表单内容
        $(ele)[0].reset();
        //清空表单样式
        $(ele).find("*").removeClass("has-error has-success");
        $(ele).find(".help-block").text("");
    }

    //查出所有的部门信息并且显示在下拉列表中
    function getDepts(ele) {
        //清空之前下拉列表的值
        $(ele).empty();
        $.ajax({
            url:"${APP_PATH}/depts",
            type:"get",
            dataType:"json",
            success:function (result) {
                //部门数据
                //console.log(result.extend.depts.deptId);
                //1: {deptId: 2, deptName: "测试部门"}
                $.each(result.extend.depts,function() {
                    var optionEle=$("<option></option>").append(this.deptName).attr("value",this.deptId);
                    //alert(this.deptId);
                    optionEle.appendTo(ele);
                });
            }
        });
    }

    //点击保存按钮
    $("#emp_save_btn").click(function () {
        //1.模态框中的数据进行校验交给服务器进行保存
        //1.1 前端进行校验
        if (!validate_add_form()){
            return false;
        }
        //1.2.发送ajax请求保存员工，加入服务器保存
        $.ajax({
            url:"${APP_PATH}/emp",
            //把表单的元素 通过jquery的方法快速封装成一个字符串
            data:$("#empAddModal form").serialize(),
            type:"POST",
            dataType:"json",
            success:function (result) {
                //alert(result.msg);
                //判断后端校验的结果是否成功
                if (result.code==100){
                    //员工保存成功：1.关闭模态框并且来到尾页显示刚才保存的数据
                    $("#empAddModal").modal('hide');
                    to_page(totalRecord);
                }else {
                    //校验失败，显示失败信息
                    console.log(result);
                    //有那个字段的错误信息就给那个字段提示错误信息
                    //alert(result.extend.errorsFields.email);
                    //alert(result.extend.errorsFields.empName);
                    if (undefined!=result.extend.errorsFields.email){
                        //邮箱不是undefined，显示错误信息
                        show_validate_msg("#email_add_input","error","邮箱格式不正确，请从新填写");
                    }
                    if (undefined!=result.extend.errorsFields.empName){
                        //姓名不是undefined，显示错误信息
                        show_validate_msg("#empName_add_input","error","用户名必须是2-5位中文，或者4-16位英文或者数字");
                    }
                }

            }
        });
    });

    //校验表单数据
    function validate_add_form(){
        //1.拿到需要校验的数据源，使用正则表达式进行校验
        //1.1校验用户名
        var empName=$("#empName_add_input").val();
        var regName=/(^[a-zA-Z0-9_-]{4,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
        if(!regName.test(empName)){
            //alert("用户名必须是2-5位中文，或者4-16位英文或者数字");
            show_validate_msg("#empName_add_input","error","用户名必须是2-5位中文，或者4-16位英文或者数字");
            return false;
        }else {
            show_validate_msg("#empName_add_input","success","");
        };

        //1.2校验邮箱
        var email=$("#email_add_input").val();
        var regEmail= /^([a-zA-Z0-9_.-]+)@([da-z.-]+).([a-z.]{2,6})$/;
        if (!regEmail.test(email)){
            //alert("邮箱格式不正确，请从新填写");
            show_validate_msg("#email_add_input","error","邮箱格式不正确，请从新填写");
            return false;
        }else {
            show_validate_msg("#email_add_input","success","");
        };
        return true;
    }

    //显示校验结果的提示
    function show_validate_msg(ele,status,msg) {
        //清除上一次的状态
        $(ele).parent().removeClass();
        $(ele).next("span").text("");
        if ("success"==status){
            $(ele).parent().addClass("has-success");
            $(ele).next().text(msg);
        }else if ("error"==status){
            $(ele).parent().addClass("has-error");
            $(ele).next("span").text(msg);
        }
    }

    //员工姓名的重复性校验
    $("#empName_add_input").change(function () {
        //发送ajax请求，校验用户名是否可用
        var empName=$("#empName_add_input").val();
        $.ajax({
            url:"${APP_PATH}/checkUser",
            data:"empName="+empName,
            type:"get",
            dataType:"json",
            success:function (result) {
                if (result.code==100){
                    show_validate_msg("#empName_add_input","success","用户名可用");
                }else {
                    show_validate_msg("#empName_add_input","error",result.extend.va_msg);
                }
            }
        });
    });

    /**
     * 编辑按钮的点击事件
     *      由于按钮的创建在绑定点击事件之后，所以不能使用click方法
     *      可用使用 on() 方法代替
     *      参数 1 ：需要绑定的是生命事件
     *          2： 需要绑定的是那个元素
     *          3： 绑定的方法是什么
     * */
    $(document).on("click",".edit_btn",function () {
        //alert("edit_btn");
        //1.查出部门信息，并且显示部门列表
        getDepts("#empUpdateModal select");
        //2.查出员工信息，显示员工信息
        getEmp($(this).attr("edit-id"));
        //3.把员工id传递给更新按钮
        $("#emp_update_btn").attr("edit-id",$(this).attr("edit-id"));
        //4.弹出模态框
        $("#empUpdateModal").modal({
            backdrop:"static"
        });
        //4.更新员工信息
    });

    //查询员工信息
    function getEmp(id) {
        $.ajax({
            url:"${APP_PATH}/emp/"+id,
            type:"get",
            dataType:"json",
            success:function (result) {
              //console.log(result);
                //拿到对应的参数放入模态框中
                var empData=result.extend.emp;
                //员工姓名存值
                $("#empName_update_static").text(empData.empName);
                //员工邮箱存值
                $("#email_update_input").val(empData.email);
                //员工性别存值，由于是单选按钮，可用使用数组传值
                $("#empUpdateModal input[name=gender]").val([empData.gender]);
                //下拉列表存值，也是使用数组传值
                $("#empUpdateModal select").val(empData.dId)
            }
        });
    }

    //点击更新更新员工
    $("#emp_update_btn").click(function() {
        //1.验证邮箱是否合法
        var email=$("#email_update_input").val();
        var regEmail= /^([a-zA-Z0-9_.-]+)@([da-z.-]+).([a-z.]{2,6})$/;
        if (!regEmail.test(email)){
            //alert("邮箱格式不正确，请从新填写");
            show_validate_msg("#email_update_input","error","邮箱格式不正确，请从新填写");
            return false;
        }else {
            show_validate_msg("#email_update_input","success","");
        };
        //发送ajax请求，保存更新的信息
        $.ajax({
            url:"${APP_PATH}/emp/"+$(this).attr("edit-id"),
            type:"PUT",
            data:$("#empUpdateModal form").serialize(),
            dataType:"json",
            success:function (result) {
                //alert(result.msg);
                //1.关闭对话框
                $("#empUpdateModal").modal("hide");
                //2.回到页面
                to_page(currentNum);
            }
        });
    });

    //删除按钮的点击删除员工事件
    $(document).on("click",".delete_btn",function () {
       //1.弹出是否确认删除对话框
        var empName=$(this).parents("tr").find("td:eq(2)").text();
        var empId= $(this).attr("del-id");
        if (confirm("是否删除【"+empName+"】?")){
            //确认之后发送ajax请求删除即可
            $.ajax({
                url:"${APP_PATH}/emp/"+empId,
                type:"DELETE",
                dataType:"json",
                success:function (result) {
                   alert(result.msg);
                   to_page(currentNum);
                }
            });
        };
    });

    //全选  全不选
    $("#check_all").click(function () {
        /**
         * attr获取checked是undefined 一般用来获取自定义的值
         * prop获取的是true或false    一般修改或获取dom原生属性
         *
         * */
        $(".check_item").prop("checked",$(this).prop("checked"));
    });

    //给每一个checkbox复选按钮 绑定事件
    $(document).on("click",".check_item",function () {
        //判断当前选中的元素是否是全部
        var flag=$(".check_item:checked").length==$(".check_item").length;
        $("#check_all").prop("checked",flag);
    });

    //给多选删除绑定事件
    $("#emp_delete_all_btn").click(function () {
        //遍历找到每一个被选中的选择框
        var empNames="";
        var del_idstr="";
        $.each($(".check_item:checked"),function () {
            //员工姓名的字符串
            empNames +=$(this).parents("tr").find("td:eq(2)").text()+",";
            //员工id的字符串
            del_idstr +=$(this).parents("tr").find("td:eq(1)").text()+"-";
        });
        //去除del_idstr中多余的逗号
        empNames=empNames.substring(0,empNames.length-1);
        //去除empNames中多余的逗号
        del_idstr=del_idstr.substring(0,empNames.length-1);
        if (confirm("确认删除【"+empNames+"】?")){
            //确认则发送ajax请求删除
            $.ajax({
                url:"${APP_PATH}/emp/"+del_idstr,
                type:"DELETE",
                dataType:"json",
                success:function (result) {
                    alert(result.msg);
                    to_page(currentNum);
                }
            });
        }
    });
</script>
</body>
</html>
