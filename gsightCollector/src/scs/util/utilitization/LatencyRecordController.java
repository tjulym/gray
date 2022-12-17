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
/*		try {
			FileWriter writer = new FileWriter(Repository.resultFilePath+Repository.isSameThreshold+"_"+Repository.nodeName+"_"+Repository.beName+"_"+Repository.setRequestIntensity+"_Latency_"+"_"+dateFormats.getNowDate1()+".txt");
			while(Repository.lcLatencyTarget<1){
				Thread.sleep(SLEEP_TIME);
			}
			writer.write(Repository.lcLatencyTarget+"\n");
			writer.flush();
			
			int i=0;
			while(Repository.SYSTEM_RUN_FLAG){
				Thread.sleep(SLEEP_TIME);
				i++;
				if(i==72000){
					break;
				}
				writer.write(controlDriver.getLcCurLatency()
						+"\n");
				if(i%10==0){
					writer.flush();
				}
			}
			writer.close();
			System.out.println(Thread.currentThread().getName()+" 程序结束");
		} catch (IOException e1) {
			e1.printStackTrace();
		}catch (InterruptedException e) {
			e.printStackTrace();
		}*/
	}
}
