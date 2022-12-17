package scs.util.collector;

import java.util.ArrayList;
import java.util.concurrent.CountDownLatch;

import scs.pojo.AppMetricesBean;
import scs.pojo.PerfMetricesBean;
import scs.util.repository.Repository;
import scs.util.resource.perf.PerfMonitor;  
/**
 * 请求发送线程,发送请求并记录时间
 * @author yanan
 *
 */
public class PerfMetricesCollectThread extends Thread{
	private ArrayList<String> pidList;
	private int durationTime;//2000ms
	private CountDownLatch begin;
	private PerfMonitor perfMonitor;
	private String containerType;

	/**
	 * 初始化方法
	 */ 	
	public PerfMetricesCollectThread(ArrayList<String> pidList, int durationTime, CountDownLatch begin, String containerType){
		this.pidList=pidList;
		this.durationTime=durationTime;
		this.begin=begin;
		this.containerType=containerType;
		this.perfMonitor=PerfMonitor.getInstance();
	}
	@Override
	public void run(){
		System.out.println("PerfMetricesCollectThread start for pidList="+pidList.toString()+"...");
		int timeLength=durationTime/1000;
		try {
			begin.await();
		} catch (InterruptedException e1) {
			e1.printStackTrace();
		}

		/**
		 * 获取指标信息
		 */
		PerfMetricesBean pBean=perfMonitor.getPerfMetricesInfo(pidList, timeLength);
		/**
		 * 统计信息
		 */

		synchronized (Repository.appFinalMetricsMap.get(containerType)){
			AppMetricesBean amBean=Repository.appFinalMetricsMap.get(containerType);
			amBean.setContextSwitch(pBean.getContextSwitch());
			amBean.setL1InstructionMPKI(pBean.getL1InstructionMPKI());
			amBean.setL1DataMPKI(pBean.getL1DataMPKI());
			amBean.setL2MPKI(pBean.getL2MPKI());
			amBean.setTlbDataMPKI(pBean.getTlbDataMPKI());
			amBean.setTlbInstructionMPKI(pBean.getTlbInstructionMPKI());
			amBean.setBranchMPKI(pBean.getBranchMPKI());
			//amBean.setL3MPKI(pBean.getL3MPKI());
			amBean.setMlp(pBean.getMlp());

			System.out.println("PerfMetricesCollectThread: update appFinalMetricsMap"+containerType+" "+amBean.toString());
		}
		
		
		

		Repository.flag--;
		System.out.println("PerfMetricesCollectThread finished for pidList="+pidList.toString()+"...");


	}
}


