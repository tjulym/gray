package scs.util.resource.net;
 
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.LineNumberReader;
  
public class NetMonitor { 

	private static NetMonitor netMonitor=null;
	private NetMonitor(){ 
	}
	public synchronized static NetMonitor getInstance() {
		if (netMonitor == null) {
			netMonitor = new NetMonitor();
		}  
		return netMonitor;
	} 
	/**
	 * 查询对应网卡的丢包状态
	 * @param netCard 网卡名称
	 * @return float[3]={droped,overLimit,requeue}
	 */
	public long[] getDropOverLimit(String netCard){
		long[] result=new long[5];
		String[] cmd = {"/bin/sh","-c","tc -s qdisc ls dev "+netCard}; 
//		System.out.println("tc -s qdisc ls dev "+netCard);
		try {
			String line = null,err;
			Process process = Runtime.getRuntime().exec(cmd); 
			BufferedReader br = new BufferedReader(new InputStreamReader(process.getErrorStream()));
			InputStreamReader isr = new InputStreamReader(process.getInputStream());
			LineNumberReader input = new LineNumberReader(isr); 
			while (((err = br.readLine()) != null||(line = input.readLine()) != null)) {
				if(err==null){ 
					if(line.trim().startsWith("S")){ 
						break;
					}
				}else{
					System.out.println(err);
				}
			}   
			String[] split=line.trim().split(" ");
			result[0]=Long.parseLong(split[1]);
			result[1]=Long.parseLong(split[3]);
			result[2]=Long.parseLong(split[6].substring(0,split[6].length()-1));
			result[3]=Long.parseLong(split[8]);
			result[4]=Long.parseLong(split[10].substring(0,split[10].length()-1));
		}catch (IOException e) { 
			e.printStackTrace();
		}
		return result; 
	}
	/**
	 * 根据pid获取网卡信息
	 * @param pid
	 * @return
	 */
	public float[] getContainerNetInfoStream(String pid){
		float[] netIO = new float[2];
		String cmd = "cat /proc/"+pid+"/net/dev";
		try { 
			String err,line = null;
			Process process = Runtime.getRuntime().exec(cmd); 
			BufferedReader br = new BufferedReader(new InputStreamReader(process.getErrorStream()));
			InputStreamReader isr = new InputStreamReader(process.getInputStream());
			LineNumberReader input = new LineNumberReader(isr); 
			while (((err = br.readLine()) != null||(line = input.readLine()) != null)) {
				if(err==null){
					if(line.contains("eth0")){
						System.out.println(line);
						String[] netSplit = line.split("\\s+");
						netIO[0] = Float.parseFloat(netSplit[2]) / 1024f / 1024f;
						netIO[1] = Float.parseFloat(netSplit[10]) / 1024f / 1024f;
						break;
					} 
				}else{
					System.out.println(err);
				}
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
		return netIO;
	}
	/**
	 * 监控网卡的接收和转发速率 
	 * @param netCard 网卡名称
	 * @return float[] 0:Rx 1:Tx
	 */
	/*public float[] getRxTxSpeed(String netCard) {
		float[] result=new float[2];
		try {
			long t1 = this.sigar.getNetInterfaceStat(netCard).getTxBytes();
			long r1 = this.sigar.getNetInterfaceStat(netCard).getRxBytes();

			Thread.sleep(1000);
			long t2 = this.sigar.getNetInterfaceStat(netCard).getTxBytes();
			long r2 = this.sigar.getNetInterfaceStat(netCard).getRxBytes();
			result[0]=(r2-r1)/1024.0f;
			result[1]=(t2-t1)/1024.0f;

			System.out.println(result[0]+" "+result[1]);
		} catch (SigarException | InterruptedException e) {
			e.printStackTrace();
		}
		return result;
	}*/

}
