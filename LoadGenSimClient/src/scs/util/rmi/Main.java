package scs.util.rmi; 
 
import java.io.IOException; 
import scs.util.driver.ExecDriver;
import scs.util.loadGen.GenSimQpsDriver;
import scs.util.repository.Repository; 

public class Main {
	public static void main(String[] args) throws InterruptedException, IOException {
		new Main().startExper(args);
	}

	/**
	 * 
	 * @param args
	 * @throws InterruptedException
	 * @throws NumberFormatException
	 * @throws IOException
	 */
	public void startExper(String[] args)throws InterruptedException, NumberFormatException, IOException {
		if(args.length!=11){
			System.out.println(args.length);
			System.out.println("[maxSimQPS(>0) simQpsPeekRate(0,1] simQpsRemainInterval(s) "
					+ "systemRunTime(s) serviceId(int+) concurrency(int+) recordLatency({true|false}) realQpsFilePath(/xxx/xx.txt) resultFilePath(/xxx/xx/) rmiServerIp rmiServerPort]"); //7-10
			System.out.println(""); //7-10
		}else{
			Repository.maxSimQPS=Integer.parseInt(args[0].trim());
			if (Repository.maxSimQPS < 0){
				System.out.println("Error: maxSimQPS < 0");
				System.exit(0);
			}
			
			Repository.simQpsPeekRate=Float.parseFloat(args[1].trim());
			if (Repository.simQpsPeekRate <=0 || Repository.simQpsPeekRate > 1){
				System.out.println("Error: simQpsPeekRate should be (0,1]");
				System.exit(0);
			}
		
			Repository.simQpsRemainInterval=Integer.parseInt(args[2].trim());
			if (Repository.simQpsRemainInterval < 0){
				System.out.println("Error: simQpsRemainInterval should > 0)");
				System.exit(0);
			}
			
			Repository.systemRunTime=Integer.parseInt(args[3].trim());
			if (Repository.systemRunTime < 0){
				System.out.println("Error: systemRunTime should > 0)");
				System.exit(0);
			}
			
			Repository.serviceId=Integer.parseInt(args[4].trim());
			
			Repository.concurrency=Integer.parseInt(args[5].trim());
			
			if (args[6].trim()!=null && args[6].trim().equals("true")){
				Repository.recordLatency=true;
			} 
			
			Repository.realQpsFilePath=args[7].trim();
			
			Repository.resultFilePath=args[8].trim();
			
			Repository.loaderRmiUrl="rmi://"+args[9].trim()+":"+args[10].trim()+"/load";
			Repository.setupRmiConnection();
			
			try {
				GenSimQpsDriver.getInstance().genSimRPSList(Repository.maxSimQPS, Repository.realQpsFilePath, Repository.simQpsPeekRate);
				
				new ExecDriver().webServerRealLoadMixed(Repository.systemRunTime, Repository.simQpsRemainInterval, Repository.serviceId, Repository.concurrency);
			} catch (IOException e) {
				e.printStackTrace();
			}
		} 
	}


}
