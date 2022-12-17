package scs.util.resource.perf;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.LineNumberReader;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Map.Entry;

import scs.pojo.PerfMetricesBean;


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
			put("L1-dcache-load-misses", "l1DataMPKI");
			put("L1-icache-load-misses", "l1InstructionMPKI");
			put("dTLB-load-misses", "tlbDataMPKI");
			put("iTLB-load-misses", "tlbInstructionMPKI");
			put("branch-misses", "branchMPKI");
			put("l1d_pend_miss.pending", "mlpl");
			put("l1d_pend_miss.pending_cycles", "mlp"); //MLP
			put("l2_rqsts.miss", "l2MPKI"); //L2
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
	public long mlpl;


	private String processCmd(ArrayList<String> Pids, int duration){
		String perf = "perf stat -p ";
		for(String Pid: Pids){
			perf = String.format(perf + "%s,", Pid);
		}
		perf = perf.substring(0,perf.length()-1) + " ";
		for(String me: Metrics.keySet()){
			perf = perf + "-e" + me + " ";
		}
		perf = String.format(perf + "sleep %s", duration);
		System.out.println(perf);
		return perf;
	}


	public PerfMetricesBean getPerfMetricesInfo(ArrayList<String> Pids, int duration){
		PerfMetricesBean amb = new PerfMetricesBean();
		Process process;

		// 处理命令
		String perf = processCmd(Pids, duration);

		String[] cmd= new String[]{"/bin/sh","-c", perf};
		try {
			// 执行命令
			process = Runtime.getRuntime().exec(cmd);
			process.waitFor();
			InputStreamReader ir = new InputStreamReader(process.getErrorStream());
			LineNumberReader input = new LineNumberReader(ir);
			String result = "";
			Iterator<Entry<String, String>> iterator = Metrics.entrySet().iterator();
			Entry<String, String> entry = iterator.next();

			// 处理输出
			while ((result = input.readLine()) != null) {
				String metric = entry.getKey();
				String param = entry.getValue();

				if(result.contains(metric)){
					// 得到数据
					System.out.println(result);
					long data = 0;
					try {
						data = Integer.valueOf(result.split(metric)[0].
								replace(" ","").
								replace(",",""));
					}catch (NumberFormatException e){
						System.out.println("Not counted");
					}
					Field f = this.getClass().getField(param);
					f.set(this, data);
					String newStr = param.substring(0, 1).toUpperCase() + param.substring(1);

					if(metric.equals("l1d_pend_miss.pending_cycles")){
						Method set = PerfMetricesBean.class.getMethod("set"+newStr, float.class);
						if(mlpl == 0){
							set.invoke(amb, 0);
						}else{
							set.invoke(amb, data/mlpl);
						}
					}else if(!metric.equals("instructions")&&!metric.equals("l1d_pend_miss.pending")){
						Method set = PerfMetricesBean.class.getMethod("set"+newStr, long.class);
						if(metric.equals("context-switches"))
							set.invoke(amb, data);
						else
							set.invoke(amb, (data * 1000)/INS);
					}

					if(iterator.hasNext())
						entry = iterator.next();
				}
			}
		} catch (IOException | InterruptedException | NoSuchFieldException |
				IllegalAccessException |
				NoSuchMethodException | InvocationTargetException e) {
			e.printStackTrace();
		}
		return amb;
	}

}
