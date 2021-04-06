package scs.util.load;

import java.rmi.RemoteException;

import scs.util.repository.Repository;
import scs.util.rmi.LoadInterface;  
/**
 * 生成真实负载的线程
 * @author yanan
 *
 */
public class HttpRealLoadThread extends Thread{

	LoadInterface loader;
	int intervalTime;
	int requestRate;
	int serviceType;
	int concurrency;
	/**
	 * 初始化方法
	 */ 	
	public HttpRealLoadThread(LoadInterface loader, int requestRate, int serviceType, int concurrency){
		this.loader=loader;
		this.requestRate=requestRate;
		this.serviceType=serviceType;
		this.concurrency=concurrency;
	}
	@Override
	public void run(){
		try {
			System.out.println("--------sim load requests thread started--------- ");
			loader.execStopHttpLoader(serviceType);//关闭负载发生器
			Thread.sleep(3000);//睡眠5秒钟等待生效
			System.out.println("loader initially closed");
			
			Thread thread=new Thread(new StartHttpThread(serviceType, concurrency)); //异步开启负载发生器
			thread.start();
			Thread.sleep(3000);//睡眠5秒钟等待生效
			System.out.println("loader initially started, default QPS=1");
		
			loader.setIntensity(requestRate,serviceType); //设置QPS
			
			while(Repository.SYSTEM_RUN_FLAG){
				Thread.sleep(1000);
			}
			/**
			 * 实验结束
			 */
			loader.execStopHttpLoader(serviceType);
			System.out.println("--------sim load requests thread stoped---------");
 
		} catch (RemoteException e) {
			e.printStackTrace();
		} catch (InterruptedException e) {
			e.printStackTrace();
		}

	}

	class StartHttpThread extends Thread{
		private int serviceType;
		private int concurrency;

		/**
		 * 初始化方法
		 */ 	
		public StartHttpThread(int serviceType, int concurrency){
			this.serviceType=serviceType;
			this.concurrency=concurrency;
		}
		@Override
		public void run(){
			try {
				loader.execStartHttpLoader(serviceType, concurrency);
			} catch (RemoteException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
}


