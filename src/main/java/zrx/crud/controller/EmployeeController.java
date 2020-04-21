package zrx.crud.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;
import zrx.crud.bean.Employee;
import zrx.crud.bean.Msg;
import zrx.crud.service.EmployeeService;

import javax.validation.Valid;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 处理员工的增删改查请求
 * */
@Controller
public class EmployeeController {

    @Autowired
    EmployeeService employeeService;

    //员工姓名是否重复查询
    @ResponseBody
    @RequestMapping(value = "/checkUser")
    public Msg checkUser(@RequestParam("empName") String empName){
        //先判断用户名是否是合法的表达式
        String regx="(^[a-zA-Z0-9_-]{4,16}$)|(^[\\u2E80-\\u9FFF]{2,5})";
        if (!empName.matches(regx)){
            return Msg.fail().add("va_msg","用户名必须是2-5位中文，或者4-16位英文或者数字");
        }
        //判断数据库用户名校验是否重复
        boolean b= employeeService.checkUser(empName);
        if (b){
            return Msg.success();
        }else {
            return Msg.fail().add("va_msg","用户名不可用");
        }
    }

    //员工姓名查询是否重复
    //支持JSR303校验
    //需要导入hibernate-validator
    @ResponseBody
    @RequestMapping(value = "/emp",method = RequestMethod.POST)
    public Msg saveEmp(@Valid Employee employee, BindingResult result){
        Map<String,String> map=new HashMap<String, String>();
        if (result.hasErrors()){
            //后端校验失败，在模态框中显示校验失败信息
            List<FieldError> fieldError = result.getFieldErrors();
            for (FieldError f:fieldError){
                System.out.println("错误的字段名"+f.getField());
                System.out.println("错误信息"+f.getDefaultMessage());
                map.put(f.getField(),f.getDefaultMessage());
            }
            return Msg.fail().add("errorsFields",map);
        }
        employeeService.saveEmp(employee);
        return Msg.success();
    }

    //使用ajax返回 需要导入jackson包
    @ResponseBody
    @RequestMapping("/emps")
    public Msg getEmpsWithJson(@RequestParam(value ="pn",defaultValue ="1")Integer pn){
        //引入pageHelper分页插件，进行分页查询
        //在查询之前调用分页查询 参数 页码 每一页的大小
        PageHelper.startPage(pn,5);
        //startPage后紧跟的是分页查询
        List<Employee> emps= employeeService.getAll();
        //使用PageInfo包装查询后的结果，只需要将PageInfo交给页面就行
        //PageInfo里面封装了详细的分页信息，包括我们查询出来的数据 可以传入连续显示的页数
        PageInfo page=new PageInfo(emps,5);
        //return page;
        return Msg.success().add("pageInfo",page);
    }

    //@RequestMapping("/emps")
    public String getEmps(@RequestParam(value = "pn",defaultValue = "1")Integer pn,Model model){
        //引入pageHelper分页插件，进行分页查询
        //在查询之前调用分页查询 参数 页码 每一页的大小
        PageHelper.startPage(pn,5);
        //startPage后紧跟的是分页查询
        List<Employee> emps= employeeService.getAll();
        //使用PageInfo包装查询后的结果，只需要将PageInfo交给页面就行
        //PageInfo里面封装了详细的分页信息，包括我们查询出来的数据 可以传入连续显示的页数
        PageInfo page=new PageInfo(emps,5);
        //使用Model传输数据到页面
        model.addAttribute("pageInfo",page);
        return "list";
    }

    //根据id查询员工
    @ResponseBody
    @RequestMapping(value = "/emp/{id}",method = RequestMethod.GET)
    public Msg getEmp(@PathVariable("id") Integer id){
       Employee employee=employeeService.getEmp(id);
       return Msg.success().add("emp",employee);
    }

    /**
     * 员工更新保存
     *      1.要想发送PUT方式的请求
     *             需要在web.xml中配置上HttpPutFormContentFilter
     *                  HttpPutFormContentFilter：作用是将请求体中的数据解析成员工map
     *                  request被重新包装，request.getParameter()被重写，就可以自己从map中取出数据
     * */
    @ResponseBody
    @RequestMapping(value = "/emp/{empId}",method = RequestMethod.PUT)
    public Msg saveEmp(Employee employee){
        employeeService.updateEmp(employee);
        return Msg.success();
    }

    //单个或者批量删除员工
    @ResponseBody
    @RequestMapping(value = "/emp/{ids}",method = RequestMethod.DELETE)
    public Msg deleteEmp(@PathVariable("ids") String ids){
        if (ids.contains("-")){
            //批量删除
            //把传过来的id字符串分割成id数组
            List<Integer> del_ids=new ArrayList<>();
            String[] str_ids=ids.split("-");
            for (String id:str_ids){
                del_ids.add(Integer.parseInt(id));
            }
            employeeService.deleteBatch(del_ids);
        }else {
            //单个删除把ids转化为int类型即可
            Integer id=Integer.parseInt(ids);
            employeeService.deleteEmp(id);
        }
        return Msg.success();
    }
}
