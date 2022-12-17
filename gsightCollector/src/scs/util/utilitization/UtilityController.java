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
public class UtilityController extends Thread{
	private final int SLEEP_TIME=3000;
	
	private int beProductNum=0;
	private int beMaxCount;
	
	public UtilityController(int beMaxCount){
		this.beMaxCount=beMaxCount;
	}
	
	DataFormats dataFormats=DataFormats.getInstance();
	DateFormats dateFormats=DateFormats.getInstance();
	@Override
	public void run(){
//		try {
//			FileWriter writer = new FileWriter(Repository.resultFilePath+Repository.isSameThreshold+"_"+Repository.nodeName+"_"+Repository.beName+"_"+Repository.setRequestIntensity+"_EMU_"+"_"+dateFormats.getNowDate1()+".txt");
//				//int logicCpuCores=Repository.CPU_INFO.getLogicCoreNumsPerSocket()*Repository.CPU_INFO.getSocketNums();//所有逻辑核心数=每个socket的逻辑核心数*socket数量
//			
//			float lcEMU=dataFormats.subFloat(Repository.setRequestIntensity*1.0f/Repository.maxRequestIntensity,2);//计算lc的EMU
//			float beEMU,totalEMU=0.0f;
//			
//			while(Repository.SYSTEM_RUN_FLAG){
//				Thread.sleep(SLEEP_TIME);
//				
//				beProductNum=this.getBeProductNum();
//				lcEMU=dataFormats.subFloat(Repository.setRequestIntensity*1.0f/Repository.maxRequestIntensity,2);//计算lc的EMU
//				beEMU=dataFormats.subFloat((float)beProductNum*1.0f/beMaxCount, 2);
//				totalEMU=lcEMU+beEMU;
//				writer.write(lcEMU+"\t"+beEMU+"\t"+totalEMU+"\t"
//						+Repository.LC_TASK.getAvgCpuUsageRate()*100+"\t"+Repository.BE_TASK.getAvgCpuUsageRate()*100+"\t"+Repository.systemAvgCpuUsagePerc+"\t"
//						+Repository.systemAvgMemBwUsageRate+"\t"
//						+Repository.systemTDPUsagePerc+"\t"
//						+(Repository.lcAvgNetBwUsagePerc+Repository.beAvgNetBwUsagePerc)+"\t"
//						+Repository.sloViolateCounter+"\t"
//						+Repository.BE_TASK.getLlcWayNums()+"\t"+Repository.BE_TASK.getBindLogicCoreNum()+"\t"
//						+Repository.BE_TASK.getCopy()+"\t"
//						+beProductNum+"\t"
//						+"\n");
//				writer.flush();
//			}
//			writer.close();
//			System.out.println(Thread.currentThread().getName()+" 程序结束");
//		} catch (IOException e1) {
//			e1.printStackTrace();
//		}catch (InterruptedException e) {
//			e.printStackTrace();
//		}
	}
}
