package scs.util.resource.perf;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.LineNumberReader;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.Map;

import scs.pojo.PerfMetricesBean;
import scs.util.repository.Repository;


public class PerfMonitor {
	private static PerfMonitor perfMonitor=null;
	private PerfMonitor(){}
	public synchronized static PerfMonitor getInstance() {
		if (perfMonitor == null) {
			perfMonitor = new PerfMonitor();
		}  
		return perfMonitor;
	}
	
	private static Map<String, String> Metrics = new LinkedHashMap<String, String>(){
		private static final long serialVersionUID = 1L;
		{
			put("instructions", "INS");
			put("context-switches","contextSwitch");
			put("l1d_pend_miss.pending_cycles", "mlpc"); //MLP
			put("L1-dcache-load-misses", "l1DataMPKI");
			put("L1-icache-load-misses", "l1InstructionMPKI");
			put("dTLB-load-misses", "tlbDataMPKI");
			put("iTLB-load-misses", "tlbInstructionMPKI");
			put("branch-misses", "branchMPKI");
			put("l1d_pend_miss.pending", "mlp");
			put("l2_rqsts.miss", "l2MPKI"); //L2
			put("cycles", "IPC");
//			put("LLC-load-misses", "l3MPKI"); //L3
		}
	};
	public long INS;
	public long contextSwitch;
	public long l1InstructionMPKI;
	public long l1DataMPKI;
	public long l2MPKI;
	public long tlbDataMPKI;
	public long tlbInstructionMPKI;
	public long branchMPKI;
//	public long l3MPKI;
	public long mlp;
	public long mlpc;
	public long IPC;

	/**
	 * 查询Perf检测数据
	 * @param Pids 进程pid数组
	 * @param duration 运行时间
	 * @return
	 */


	private String processCmd(ArrayList<String> Pids, int duration, int index){
		String perf = "perf stat -p ";
		for(String Pid: Pids){
			perf = String.format(perf + "%s,", Pid);
		}
		perf = perf.substring(0,perf.length()-1) + " ";



		int metricIndex = 0;
		for(String me: Metrics.keySet()){
		    if(metricIndex%2==index)
		        perf = perf + "-e" + me + " ";
		    metricIndex++;
		}
		perf = String.format(perf + "sleep %s", duration);
		//System.out.println(perf);
		return perf;
	}

	private String contains(String result) {
		for(String metric: Metrics.keySet()){
			if(result.contains(metric)) return metric;
		}
		return "";
	}

	public PerfMetricesBean getPerfMetricesInfo(ArrayList<String> Pids, int duration, String containerType){
		PerfMetricesBean amb = new PerfMetricesBean();
		Process process;

		// 处理命令
		for(int i = 0 ; i < 2 ; i ++){
			String perf = processCmd(Pids, duration/2 , i);
			String[] cmd= new String[]{"/bin/sh","-c", perf};
			try {
				System.out.println(perf);
				// 执行命令
				process = Runtime.getRuntime().exec(cmd);
				process.waitFor();
				InputStreamReader ir = new InputStreamReader(process.getErrorStream());
				LineNumberReader input = new LineNumberReader(ir);
				String result = "";
				// 处理输出
				while ((result = input.readLine()) != null) {
					//System.out.println(result);
					String metric = contains(result);
					if(!metric.equals("")){
						String param = Metrics.get(metric);
						long data = Long.valueOf(result.split(metric)[0].
								replace(" ","").
								replace(",",""));
						Field f = this.getClass().getField(param);
						f.set(this, data);
						String newStr = param.substring(0, 1).toUpperCase() + param.substring(1);

						if(metric.equals("l1d_pend_miss.pending")) {
							Method set = PerfMetricesBean.class.getMethod("set" + newStr, float.class);
							set.invoke(amb, (float)data / mlpc);
						} else if(metric.equals("cycles")){
							Method set = PerfMetricesBean.class.getMethod("set" + newStr, float.class);
							set.invoke(amb, (float)INS/data);
						} else if(!metric.equals("instructions")&&!metric.equals("l1d_pend_miss.pending_cycles")){
							Method set = PerfMetricesBean.class.getMethod("set"+newStr, long.class);
							if(metric.equals("context-switches"))
								set.invoke(amb, data);
							else{
								//System.out.println(newStr + " " + (data * 1000)/INS);
								set.invoke(amb, (data * 1000)/INS);
							}
						}
					}
				}
			} catch (IOException | InterruptedException | NoSuchFieldException |
					IllegalAccessException | NumberFormatException |
					NoSuchMethodException | InvocationTargetException e) {
				e.printStackTrace();
			}
		}
		Repository.instructionMap.put(containerType, INS);
		return amb;
	}


}
