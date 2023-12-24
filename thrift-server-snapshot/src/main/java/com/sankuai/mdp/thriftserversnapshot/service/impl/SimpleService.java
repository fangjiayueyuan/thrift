package com.sankuai.mdp.thriftserversnapshot.service.impl;

import com.sankuai.mdp.thriftapisnapshot.entity.UserService;
import org.apache.thrift.protocol.TBinaryProtocol;
import org.apache.thrift.server.TServer;
import org.apache.thrift.server.TSimpleServer;
import org.apache.thrift.transport.TServerSocket;
import org.apache.thrift.transport.TServerTransport;
import org.apache.thrift.transport.TTransportException;

/**
 * @projectName: thrift-api-snapshot
 * @package: com.sankuai.mdp.thriftserversnapshot.service.impl
 * @className: SimpleService
 * @author: fangjiayueyuan
 * @description: TODO
 * @date: 2023/12/17 21:59
 * @version: 1.0
 */
public class SimpleService {
    public static void main(String[] args) {
        try{
            TServerTransport serverTransport = new TServerSocket(9090);
            UserService.Processor processor = new UserService.Processor(new UserServiceImpl());
            TBinaryProtocol.Factory protocolFactory = new TBinaryProtocol.Factory();
            TSimpleServer.Args targs = new TSimpleServer.Args(serverTransport);
            targs.processor(processor);
            targs.protocolFactory(protocolFactory);
            TServer server = new TSimpleServer(targs);
            server.serve();
        } catch (TTransportException e) {
            throw new RuntimeException(e);
        }
    }
}
