package scs.util.collector;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.CountDownLatch;

import scs.pojo.AppMetricesBean;
import scs.pojo.ContainerMetricesBean;
import scs.pojo.ContainerStatisticsBean;
import scs.util.repository.Repository;
import scs.util.resource.DockerService;  
/**
 * 请求发送线程,发送请求并记录时间
 * @author yanan
 *
 */
public class ContainerMetricesCollectThread extends Thread{

	private final int SLEEP_TIME=1000;//2000ms
	private String containersNameStr;
	private int durationTime;//2000ms
	private CountDownLatch begin;
	private DockerService dService;

	/**
	 * 初始化方法
	 */ 	
	public ContainerMetricesCollectThread(String containersNameStr, int durationTime, CountDownLatch begin){
		this.containersNameStr=containersNameStr;
		this.durationTime=durationTime;
		this.begin=begin;
		this.dService=DockerService.getInstance();
	}
	@Override
	public void run(){
		System.out.println("ContainerMetricesCollectThread start...");
		int timeLength=durationTime/1000;
		try {
			begin.await();
		} catch (InterruptedException e1) {
			e1.printStackTrace();
		}

		/**
		 * 获取指标信息
		 */
		float cpuUsageRateSum=0,
				memUsageRateSum=0,
				memUsageAmountMax=0,
				netInputBegin=0,netInputEnd=0,netOutputBegin=0,netOutputEnd=0,
				ioInputBegin=0,ioInputEnd=0,ioOutputBegin=0,ioOutputEnd=0;
		long collectTimeBegin=0,collectTimeEnd=0;
		int statisticsCounter=0;

		Map<String, ContainerStatisticsBean> tempMetricesMap=new HashMap<String, ContainerStatisticsBean>();

		for(int i=0;i<timeLength;i++){
			Map<String, ContainerMetricesBean> combinedMetricesMap=dService.getContainerResourceUsage(containersNameStr);
			for(String key:combinedMetricesMap.keySet()){
				ContainerMetricesBean metricesBean=combinedMetricesMap.get(key);
				if(!tempMetricesMap.containsKey(key)){
					cpuUsageRateSum=0;
					cpuUsageRateSum+=metricesBean.getCpuUsageRate();
					memUsageRateSum=0;
					memUsageRateSum+=metricesBean.getMemUsageRate();
					memUsageAmountMax=0;
					memUsageAmountMax=metricesBean.getMemUsageAmount();
					statisticsCounter=0;
					statisticsCounter++;
					netInputBegin=metricesBean.getNetInput();
					netOutputBegin=metricesBean.getNetOutput();
					ioInputBegin=metricesBean.getIoInput();
					ioOutputBegin=metricesBean.getIoOutput();
					collectTimeBegin=metricesBean.getCollectTime();

					ContainerStatisticsBean statisticsBean=new ContainerStatisticsBean();
					statisticsBean.setCpuUsageRate(cpuUsageRateSum);
					statisticsBean.setMemUsageRate(memUsageRateSum);
					statisticsBean.setMemUsageAmount(memUsageAmountMax);
					statisticsBean.setStatisticsCounter(statisticsCounter);
					statisticsBean.setNetInputBegin(netInputBegin);
					statisticsBean.setNetOutputBegin(netOutputBegin);
					statisticsBean.setIoInputBegin(ioInputBegin);
					statisticsBean.setIoOutputBegin(ioOutputBegin);
					statisticsBean.setCollectTimeBegin(collectTimeBegin);
					tempMetricesMap.put(key, statisticsBean);
				} else {
					ContainerStatisticsBean statisticsBean=tempMetricesMap.get(key);
					cpuUsageRateSum=statisticsBean.getCpuUsageRate();
					cpuUsageRateSum+=metricesBean.getCpuUsageRate();
					memUsageRateSum=statisticsBean.getMemUsageRate();
					memUsageRateSum+=metricesBean.getMemUsageRate();
					memUsageAmountMax=metricesBean.getMemUsageAmount()>statisticsBean.getMemUsageAmount()?metricesBean.getMemUsageAmount():statisticsBean.getMemUsageAmount();
					statisticsCounter=statisticsBean.getStatisticsCounter();
					statisticsCounter++;
					netInputEnd=metricesBean.getNetInput();
					netOutputEnd=metricesBean.getNetOutput();
					ioInputEnd=metricesBean.getIoInput();
					ioOutputEnd=metricesBean.getIoOutput();
					collectTimeEnd=metricesBean.getCollectTime();

					statisticsBean.setCpuUsageRate(cpuUsageRateSum);
					statisticsBean.setMemUsageRate(memUsageRateSum);
					statisticsBean.setMemUsageAmount(memUsageAmountMax);
					statisticsBean.setStatisticsCounter(statisticsCounter);
					statisticsBean.setNetInputEnd(netInputEnd);
					statisticsBean.setNetOutputEnd(netOutputEnd);
					statisticsBean.setIoInputEnd(ioInputEnd);
					statisticsBean.setIoOutputEnd(ioOutputEnd);
					statisticsBean.setCollectTimeEnd(collectTimeEnd);
				}
			}
			try {
				Thread.sleep(SLEEP_TIME);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		/**
		 * 统计信息
		 */

		for(String key:tempMetricesMap.keySet()){
			synchronized (Repository.appFinalMetricsMap.get(key)) {
				AppMetricesBean amBean=Repository.appFinalMetricsMap.get(key);
				ContainerStatisticsBean item=tempMetricesMap.get(key);
				amBean.setCpuUtilRate(item.getCpuUsageRate()/item.getStatisticsCounter());
				amBean.setMemUtilRate(item.getMemUsageRate()/item.getStatisticsCounter());
				float timeSeconds=(item.getCollectTimeEnd()-item.getCollectTimeBegin())/1000;
				float networkInputIO=(item.getNetInputEnd()-item.getNetInputBegin())/timeSeconds;
				float networkOutputIO=(item.getNetOutputEnd()-item.getNetOutputBegin())/timeSeconds;
				//System.out.println(item.toString());
				amBean.setNetworkIO(networkInputIO>networkOutputIO?networkInputIO:networkOutputIO);				
				
				float ioInputIO=(item.getIoInputEnd()-item.getIoInputBegin())/timeSeconds;
				float ioOutputIO=(item.getIoOutputEnd()-item.getIoOutputBegin())/timeSeconds;
				amBean.setDiskIO(ioInputIO>ioOutputIO?ioInputIO:ioOutputIO);
				System.out.println("ContainerMetricesCollectThread: update appFinalMetricsMap"+key+" "+amBean.toString());
			}
		}

		Repository.flag--;
		System.out.println("ContainerMetricesCollectThread finished...");


	}
}


