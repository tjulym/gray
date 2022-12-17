package scs.util.rmi;

import java.util.*;
import java.util.concurrent.CountDownLatch;
import scs.pojo.TwoTuple;
import scs.util.collector.ContainerMetricesCollectThread;
import scs.util.collector.PerfMetricesCollectThread;
import scs.util.collector.RDTMetricesCollectThread;
import scs.util.load.HttpRealLoadThread;
import scs.util.repository.Repository;
import scs.util.repository.ResultRecord;

public class Test {

	public static void main(String[] args) {

		//		NOTE:  Mixed use of MSR and kernel interfaces to manage
		//	       CAT or CMT & MBM may lead to unexpected behavior.
		//	TIME 2021-03-15 13:02:42
		//	    CORE         IPC      MISSES     LLC[KB]   MBL[MB/s]   MBR[MB/s]
		//	     0-5        0.45         12k       160.0         0.0         0.0
		//	TIME 2021-03-15 13:02:43
		//	    CORE         IPC      MISSES     LLC[KB]   MBL[MB/s]   MBR[MB/s]
		//	     0-5        0.98         12k      7360.0        58.0        85.2
		// TODO Auto-generated method stub

		if(args.length!=3){
			System.out.println("containerNameStr(,) durationTime(ms) resultFilePath ip port requestRate serviceType");
			System.out.println("jar -jar xxx.jar LC.xxxx,LC.xxxx,LC.xxxx,BE.xxxx 50000 /home/tank/result/");
			System.exit(0);
		}
		
		String containersNameStr=args[0];
//		containersNameStr="LC.k8s_solr_sdc-solr-1_sdc-solr_577698f2-d992-4384-b672-c6a178baf57f_0,"
//				+ "LC.k8s_solr_sdc-solr-0_sdc-solr_096c3fbc-8057-4a00-818c-c54257cc8f81_0,"
//				+ "BE.k8s_solr_sdc-solr-2_sdc-solr_dc71349b-d181-4c30-9492-24fa9258c940_0";

		int durationTime=Integer.parseInt(args[1].trim());
		Repository.resultFilePath=args[2].trim();
//		Repository.resultFilePath="/home/tank/yanan/";
		
//		Repository.loaderRmiUrl="rmi://"+args[3].trim()+":"+args[4].trim()+"/load";
//		Repository.loaderRmiUrl="rmi://192.168.1.129:8080/load";
//		Repository.setupRmiConnection();
		
//		Repository.lcQPS=Integer.parseInt(args[5].trim());
//		Repository.serviceType=Integer.parseInt(args[6].trim());
		
		
		
		String[] containerList=containersNameStr.split(",");
		ArrayList<TwoTuple<String,String>> list=new ArrayList<TwoTuple<String,String>>();
		StringBuilder containerSpaceStr=new StringBuilder();
		for(String item: containerList){
			String[] strings=item.split("\\.");
			list.add(new TwoTuple<String, String>(strings[0],strings[1]));
			containerSpaceStr.append(strings[1]).append(" ");
		}

		Repository.getInstance().registerContainerInfo(list);

		/**
		 * prepare start loadGen sleep 30s
		 */
		Repository.SYSTEM_RUN_FLAG=true;
//		Thread loadThread=new Thread(new HttpRealLoadThread(Repository.loader, Repository.lcQPS, Repository.serviceType, 0));
//		loadThread.start();
//		try {
//			Thread.sleep(40000);
//		} catch (InterruptedException e1) {
//			e1.printStackTrace();
//		}
		
		
		CountDownLatch begin=new CountDownLatch(1);
		List<Thread> threads = new LinkedList<>();
		/**
		 * RDT monitor
		 */
		Map<String,String> typeCoreMap=new HashMap<String, String>();
		for(String containerName:Repository.containerMap.keySet()){
			String containerType=Repository.containerMap.get(containerName).getTaskType();
			String containerCpuCoreStr=Repository.containerMap.get(containerName).getLogicCoreStr().trim();
			if(containerCpuCoreStr==null||containerCpuCoreStr.equals("")){
				System.out.println(containerName+"is not yet being binded CPU cores");
				if(containerType.equals("LC"))
					typeCoreMap.put(containerType, "0-9");
				else
					typeCoreMap.put(containerType, "20-29");
				continue;
				//System.exit(0);
			}
			typeCoreMap.put(containerType, Repository.containerMap.get(containerName).getLogicCoreStr());
		}
		for(String containerType:typeCoreMap.keySet()){
			Repository.flag++;
			Thread thread=new Thread(new RDTMetricesCollectThread(typeCoreMap.get(containerType), durationTime, begin, containerType));
			threads.add(thread);
			thread.start();
		}
		/**
		 * docker monitor
		 */
		Repository.flag++;
		Thread thread=new Thread(new ContainerMetricesCollectThread(containerSpaceStr.toString(), durationTime, begin));
		threads.add(thread);
		thread.start();


		/**
		 * Perf monitor
		 */
		Map<String, ArrayList<String>> pidMap=new HashMap<String, ArrayList<String>>();
		for(String containerName:Repository.containerMap.keySet()){
			String containerType=Repository.containerMap.get(containerName).getTaskType();
			String pid=Repository.containerMap.get(containerName).getPid();
			if(!pidMap.containsKey(containerType)){
				ArrayList<String> pidList=new ArrayList<String>();
				pidList.add(pid);
				pidMap.put(containerType, pidList);
			}else{
				List<String> pidList=pidMap.get(containerType);
				pidList.add(pid);
			}
		}
		for(String containerType: pidMap.keySet()){
			Repository.flag++;
			Thread thread2=new Thread(new PerfMetricesCollectThread(pidMap.get(containerType), durationTime, begin, containerType));
			threads.add(thread2);
			thread2.start();
		}

		begin.countDown();

		for(Thread t: threads){
			try {
				t.join();
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}

//		while(Repository.flag>0){
//			try {
//				Thread.sleep(1000);
////				System.out.println(Repository.flag);
//			} catch(InterruptedException e){
//				e.printStackTrace();
//			}
//		}

		Repository.SYSTEM_RUN_FLAG=false;
		/**
		 * record result
		 */
		new ResultRecord().record();


	}  

}
