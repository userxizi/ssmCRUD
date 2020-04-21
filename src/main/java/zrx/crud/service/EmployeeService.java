package zrx.crud.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import zrx.crud.bean.Employee;
import zrx.crud.bean.EmployeeExample;
import zrx.crud.dao.EmployeeMapper;


import java.util.List;

@Service
public class EmployeeService {
    @Autowired
    EmployeeMapper employeeMapper;

    //查询用户名是否重复 true 代表可用 fasle：不可用
    public boolean checkUser(String empName){
        EmployeeExample example=new EmployeeExample();
        EmployeeExample.Criteria criteria= example.createCriteria();
        criteria.andEmpNameEqualTo(empName);
        long count=employeeMapper.countByExample(example);
        return count==0;
    }

    //查询所有员工
    public List<Employee> getAll(){
        List<Employee> employees=employeeMapper.selectByExampleWithDept(null);
        return employees;
    }
    //保存员工
    public void saveEmp(Employee employee){
        employeeMapper.insertSelective(employee);
    }

    //根据id查询员工
    public Employee getEmp(Integer id){
        Employee employee = employeeMapper.selectByPrimaryKey(id);
        return employee;
    }
    //根据id修改员工
    public void updateEmp(Employee employee) {
        employeeMapper.updateByPrimaryKeySelective(employee);
    }
    //根据id删除员工
    public void deleteEmp(Integer id) {
        employeeMapper.deleteByPrimaryKey(id);
    }

    public void deleteBatch(List<Integer> ids) {
        EmployeeExample example=new EmployeeExample();
        EmployeeExample.Criteria criteria = example.createCriteria();
        criteria.andEmpIdIn(ids);
        employeeMapper.deleteByExample(example);
    }
}
