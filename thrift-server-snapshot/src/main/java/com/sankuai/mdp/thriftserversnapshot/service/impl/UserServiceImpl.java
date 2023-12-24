package com.sankuai.mdp.thriftserversnapshot.service.impl;

import com.sankuai.mdp.thriftapisnapshot.entity.User;
import com.sankuai.mdp.thriftapisnapshot.entity.UserService;
import org.apache.thrift.TException;

/**
 * @projectName: thrift-api-snapshot
 * @package: com.sankuai.mdp.thriftserversnapshot.service.impl
 * @className: UserServiceImpl
 * @author: fangjiayueyuan
 * @description: TODO
 * @date: 2023/12/17 21:33
 * @version: 1.0
 */
public class UserServiceImpl implements UserService.Iface{
    @Override
    public User getById(int id) throws TException {
        System.out.println("-----调用getById-----");
        User user = new User();
        user.setId(id);
        user.setName("dog");
        user.setAge(18);
        return user;
    }

    @Override
    public boolean isExist(String name) throws TException {
        return false;
    }
}
