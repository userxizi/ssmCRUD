package zrx.crud.test;

import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import zrx.crud.bean.Department;
import zrx.crud.bean.Employee;
import zrx.crud.dao.DepartmentMapper;
import zrx.crud.dao.EmployeeMapper;

import java.util.UUID;

/**
 * dao层的测试
 * 1.导入springTest模块
 * 2.@ContextConfiguration：指定spring配置文件的位置
 * */
@RunWith(value = SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class MapperTest {
    /**
     * 测试DepartmentMapper
     * */
    @Autowired
    private DepartmentMapper departmentMapper;

    @Autowired
    private EmployeeMapper employeeMapper;

    @Autowired
    SqlSession sqlSession;

    @Test
    public void testCRUD(){
//        1.创建spring IOC 容器
//        ClassPathXmlApplicationContext ioc=new ClassPathXmlApplicationContext("applicationContext.xml");
//        2.从容器中获取mapper
//        DepartmentMapper bean=ioc.getBean(DepartmentMapper.class);
        System.out.println(departmentMapper);



        //部门插入
        //departmentMapper.insertSelective(new Department(null,"开发部门"));
        //departmentMapper.insertSelective(new Department(null,"测试部门"));

        //员工的插入
        //employeeMapper.insertSelective(new Employee(null,"张三","男","123456789@qq.com",1));

        EmployeeMapper mapper=sqlSession.getMapper(EmployeeMapper.class);
        for (int i=0;i<1000;i++){
            //生成uuid，并且截取0-5位置
            String uuid=UUID.randomUUID().toString().substring(0,5)+i;
            mapper.insertSelective(new Employee(null,uuid,"男",uuid+"zrx@qq.com",1));
        }
        System.out.println("执行完成");
    }

}
