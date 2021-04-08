package scs.util.utilitization; 

import java.io.FileWriter;
import java.io.IOException; 

import scs.util.repository.Repository;
import scs.util.tools.DataFormats;
import scs.util.tools.DateFormats;  

/**
 * 记录EMU的线程类
 * @author yanan
 *
 */
public class LatencyRecordController extends Thread{
	private final int SLEEP_TIME=1000;

	DataFormats dataFormats=DataFormats.getInstance();
	DateFormats dateFormats=DateFormats.getInstance();
	@Override
	public void run(){
		try {
			
			FileWriter writer = new FileWriter(Repository.resultFilePath+"Latency_99th_s" + Repository.serviceId +"_m"+ Repository.maxSimQPS+"_r"+Repository.simQpsPeekRate+"_i"+Repository.simQpsRemainInterval+"_d"+dateFormats.getNowDate1()+".txt");
			FileWriter writer1 = new FileWriter(Repository.resultFilePath+"Latency_avg_s" + Repository.serviceId +"_m"+ Repository.maxSimQPS+"_r"+Repository.simQpsPeekRate+"_i"+Repository.simQpsRemainInterval+"_d"+dateFormats.getNowDate1()+".txt");
			
			FileWriter writer2 = new FileWriter(Repository.resultFilePath+"TotalServiceRate_avg_s" + Repository.serviceId +"_m"+ Repository.maxSimQPS+"_r"+Repository.simQpsPeekRate+"_i"+Repository.simQpsRemainInterval+"_d"+dateFormats.getNowDate1()+".txt");
				
			int i=0;
			while(Repository.SYSTEM_RUN_FLAG){
				Thread.sleep(SLEEP_TIME);
				i++;
				if(i==72000){
					break;
				}
				writer.write(Repository.loader.getRealPerSecLatency(Repository.serviceId, "99th")+"\n");
				writer1.write(Repository.loader.getRealPerSecLatency(Repository.serviceId, "avg")+"\n");
				writer2.write(
						Repository.loader.getTotalRequestCount(Repository.serviceId)+"\t"+
					    Repository.loader.getTotalQueryCount(Repository.serviceId)+"\t"+
						Repository.loader.getTotalAvgServiceRate(Repository.serviceId)+
						"\n");
				if(i%10==0){
					writer.flush();
					writer1.flush();
					writer2.flush();
				}
			}
			writer.close();
			writer1.close();
			writer2.close();
		} catch (IOException e1) {
			e1.printStackTrace();
		}catch (InterruptedException e) {
			e.printStackTrace();
		} 
	}


}
