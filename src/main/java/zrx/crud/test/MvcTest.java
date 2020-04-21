package zrx.crud.test;

import com.github.pagehelper.PageInfo;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;
import zrx.crud.bean.Employee;

import java.util.List;

/**
 *  使用spring模块提供的测试请求功能,测试CRUD请求的准确性
 * */
@RunWith(value = SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration(locations = {"classpath:applicationContext.xml","file:src/main/webapp/WEB-INF/dispatcherServlet-servlet.xml"})
public class MvcTest {
    //传入springMvc的ioc
    @Autowired
    WebApplicationContext context;
    //虚拟的mvc请求，获取到处理结果
    MockMvc mockMvc;

    @Before
    public void initMockMvc(){
        mockMvc=MockMvcBuilders.webAppContextSetup(context).build();
    }

    @Test
    public void testPage() throws Exception {
        //模拟请求拿到返回值
        MvcResult result =mockMvc.perform(MockMvcRequestBuilders.get("/emps").param("pn","1")).andReturn();
        //模拟成功之后，请求域中有pageInfo,可以取出pageInfo进行验证
        MockHttpServletRequest request = result.getRequest();
        PageInfo in= (PageInfo) request.getAttribute("pageInfo");
        //System.out.println(in);

         System.out.println("当前页码："+in.getPageNum());
        System.out.println("总页码："+in.getPages());
        System.out.println("总记录数："+in.getTotal());
        int[] nums=in.getNavigatepageNums();
        for (int i:nums){
            System.out.print(" "+i);
        }
        System.out.println(" ");
        //获取员工数据
        List<Employee> list=in.getList();
        for (Employee employee:list){
            System.out.println("ID:"+employee.getdId()+"==>Name"+employee.getEmpName());
        }
    }
}
