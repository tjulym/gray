package scs.util.controller;
  
import scs.util.driver.TimerThread;
import scs.util.repository.Repository; 
import scs.util.utilitization.LatencyRecordController;
import scs.util.utilitization.UtilityController; 
/**
 * 所有资源的控制驱动
 * 被各个维度资源的监控线程所调用
 * 同时负责合法性校验,防止资源分配错误
 * @author yanan
 *
 */
public class ControlDriver { 
	private static ControlDriver controlDriver=null;
	
	private ControlDriver(){}
	public synchronized static ControlDriver getInstance() {
		if(controlDriver == null) {
			controlDriver = new ControlDriver();
		}
		return controlDriver;
	}

	/**
	 * 资源控制开启函数
	 * @param controlLevel 资源控制等级,1 2 3 4依次开启cpu mem net freq资源控制,后面的级别涵盖前面的级别
	 */
	public static void start(int systemRunTime){
			Thread timeThread=new Thread(new TimerThread(systemRunTime));
			timeThread.start(); 
			
			if(Repository.recordLatency==true){
				Thread latencyRecordController=new Thread(new LatencyRecordController());
				latencyRecordController.start();
			}
			if(Repository.recordUtility==true){
				Thread utilityController=new Thread(new UtilityController());
				utilityController.start();
			}
	}
 
}
