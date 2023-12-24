package com.sankuai.mdp.thriftclientsnapshot.service.impl;

import com.sankuai.mdp.thriftapisnapshot.entity.User;
import com.sankuai.mdp.thriftapisnapshot.entity.UserService;
import org.apache.thrift.TException;
import org.apache.thrift.protocol.TBinaryProtocol;
import org.apache.thrift.transport.TSocket;
import org.apache.thrift.transport.TTransport;
import org.apache.thrift.transport.TTransportException;

/**
 * @projectName: thrift-api-snapshot
 * @package: com.sankuai.mdp.thriftclientsnapshot.service.impl
 * @className: SimpleClient
 * @author: fangjiayueyuan
 * @description: TODO
 * @date: 2023/12/17 21:58
 * @version: 1.0
 */
public class SimpleClient {
    public static void main(String[] args) {
        TTransport transport = null;
        try {
            transport = new TSocket("localhost", 9090);
            TBinaryProtocol protocol = new TBinaryProtocol(transport);
            UserService.Client client = new UserService.Client(protocol);
            transport.open();
            User result = client.getById(1);
            System.out.println("Result:" + result);
        } catch (TTransportException e) {
            e.printStackTrace();
        } catch (TException e) {
            throw new RuntimeException(e);
        } finally {
            if (transport != null) {
                transport.close();
            }
        }
    }
}
