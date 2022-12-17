package scs.util.collector;

import java.util.concurrent.CountDownLatch;

import scs.pojo.AppMetricesBean;
import scs.pojo.RDTMetricesBean;
import scs.util.repository.Repository;
import scs.util.resource.cpu.CpuMonitor;  
/**
 * 请求发送线程,发送请求并记录时间
 * @author yanan
 *
 */
public class RDTMetricesCollectThread extends Thread{
	private String containerCoreStr;
	private int durationTime;//2000ms
	private CountDownLatch begin;
	private CpuMonitor cpuMonitor;
	private String containerType; 

	/**
	 * 初始化方法
	 */ 	
	public RDTMetricesCollectThread(String containerCoreStr, int durationTime, CountDownLatch begin, String containerType){
		this.containerCoreStr=containerCoreStr;
		this.durationTime=durationTime;
		this.begin=begin;
		this.containerType=containerType;
		this.cpuMonitor=CpuMonitor.getInstance();
	}
	@Override
	public void run(){
		System.out.println("RDTMetricesCollectThread start for type="+containerType+" coreStr="+containerCoreStr+"...");
		int timeLength=durationTime/1000;
		try {
			begin.await();
		} catch (InterruptedException e1) {
			e1.printStackTrace();
		}

		/**
		 * 获取指标信息
		 */
		RDTMetricesBean rBean=cpuMonitor.getContainerRDTMetricesUsage(timeLength, containerCoreStr);
		/**
		 * 统计信息
		 */

		synchronized (Repository.appFinalMetricsMap.get(containerType)){
			AppMetricesBean amBean=Repository.appFinalMetricsMap.get(containerType);
			amBean.setMemBandwidth(rBean.getMemBandwidth());
			amBean.setLlc(rBean.getLlc());
			amBean.setIpc(rBean.getIpc());

			System.out.println("ContainerMetricesCollectThread: update appFinalMetricsMap"+containerType+" "+amBean.toString());
		}

		Repository.flag--;
		System.out.println("RDTMetricesCollectThread finished for type="+containerType+" coreStr="+containerCoreStr+"...");


	}
}


