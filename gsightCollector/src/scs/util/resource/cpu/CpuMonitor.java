package scs.util.resource.cpu;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.LineNumberReader;

import scs.pojo.RDTMetricesBean;   

public class CpuMonitor {
	private static CpuMonitor cpuMonitor=null;
	private CpuMonitor(){}
	public synchronized static CpuMonitor getInstance() {
		if (cpuMonitor == null) {  
			cpuMonitor = new CpuMonitor();
		}  
		return cpuMonitor;
	} 

	/**
	 * 监控指定cores的llc和内存带宽使用
	 * @param cores 中括号代表分组  
	 * all:[0-5,6] 输出1组
	 * all:'[0,2,20-21],[5]' 输出2组
	 * all:0-5  输出6组
	 * @return float[5]={IPC MISSES LLC[KB] MBL[MB/s] MBR[MB/s]}
	 */
	public RDTMetricesBean getContainerRDTMetricesUsage(int durationTime, String coreStr){
		RDTMetricesBean rmBean=new RDTMetricesBean();
		float[] RDTMetricesList=new float[5];
		String[] datas=new String[6];
		int count=0;
		try {
			String line = null,err;
			Process process = Runtime.getRuntime().exec("pqos -t "+durationTime+" -m all:"+"["+coreStr+"]");
			System.out.println(("pqos -t "+durationTime+" -m all:"+"["+coreStr+"]"));
			BufferedReader br = new BufferedReader(new InputStreamReader(process.getErrorStream()));
			InputStreamReader isr = new InputStreamReader(process.getInputStream());
			LineNumberReader input = new LineNumberReader(isr); 
			while (((err = br.readLine()) != null||(line = input.readLine()) != null)) {
				if(err==null){
					if(line.contains("E")||line.contains("C")){
						continue;
					} else {
						datas=line.trim().split("\\s+");
						if (datas.length==6){
							RDTMetricesList[0]+=Float.parseFloat(datas[1]);
							RDTMetricesList[1]+=Float.parseFloat(datas[2].replace("k",""));
							RDTMetricesList[2]+=Float.parseFloat(datas[3]);
							RDTMetricesList[3]+=Float.parseFloat(datas[4]);
							RDTMetricesList[4]+=Float.parseFloat(datas[5]);
							count++;
							System.out.println(count+" "+line);
						}
					}
				}else{
					System.out.println(err);
				}
			}  
//			for (int i=0;i<result.length;i++){
//				System.out.println("avg="+(result[i]/count));
//			}
			rmBean.setIpc(RDTMetricesList[0]/count);
			rmBean.setLlc(RDTMetricesList[2]/count/1024f);
			rmBean.setMemBandwidth((RDTMetricesList[3]+RDTMetricesList[4])/count);
		
		}catch (IOException e){
			e.printStackTrace();
		} 
		return rmBean;
	}

}
