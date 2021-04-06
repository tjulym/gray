package scs.util.rmi;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CountDownLatch;
import scs.pojo.TwoTuple;
import scs.util.collector.ContainerMetricesCollectThread;
import scs.util.collector.PerfMetricesCollectThread;
import scs.util.collector.RDTMetricesCollectThread;
import scs.util.repository.Repository;
import scs.util.utilitization.ResultRecord;

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


		//new Test().collectSoloRun(args);
		new Test().collectColocationIpc(args);

	}
	public void collectSoloRun(String[] args){
		if(args.length!=7){
			System.out.println("containerNameStr(,) durationTime(ms) resultFilePath ip port requestRate serviceType");
			System.out.println("jar -jar xxx.jar LC.xxxx,LC.xxxx,LC.xxxx,BE.xxxx 50000 /home/tank/result/");
			System.exit(0);
		}

		String containersNameStr=args[0];
		if(containersNameStr==null||containersNameStr.equals("x")){
			/*containersNameStr="LC.k8s_solr_sdc-solr-1_sdc-solr_577698f2-d992-4384-b672-c6a178baf57f_0,"
			+ "LC.k8s_solr_sdc-solr-0_sdc-solr_096c3fbc-8057-4a00-818c-c54257cc8f81_0,"
			+ "BE.k8s_solr_sdc-solr-2_sdc-solr_dc71349b-d181-4c30-9492-24fa9258c940_0";*/
			containersNameStr="LC.k8s_workflow-sdc_workflow-sdc-68bf5bb89b-nsnzt_sdc-socialnetwork-func_5737da17-5776-4ff8-a7d1-5f40707c1a95_0,LC.k8s_upload-unique-id-sdc_upload-unique-id-sdc-96bf586d4-nwzkb_sdc-socialnetwork-func_c5235ae5-18e9-420b-a2ff-4923fbb30128_0,LC.k8s_upload-media-sdc_upload-media-sdc-5c85584784-zp7df_sdc-socialnetwork-func_47e1badc-244a-4e30-a84b-e0085e679f1c_0,LC.k8s_compose-and-upload-sdc_compose-and-upload-sdc-77655f8744-js7xs_sdc-socialnetwork-func_6213db99-aed6-422b-a647-5d67e7bafaeb_0,LC.k8s_compose-post-sdc_compose-post-sdc-69444cf7f6-qpdvm_sdc-socialnetwork-func_b837ceb9-4205-4d8f-a709-288b769bae31_0,LC.k8s_upload-creator-sdc_upload-creator-sdc-575b558cb-tjx6c_sdc-socialnetwork-func_7e1bf29f-b0ed-4744-9cd8-bb121d1104a5_0,LC.k8s_upload-home-timeline-sdc_upload-home-timeline-sdc-56bc74f9d8-8ljbq_sdc-socialnetwork-func_d1d50455-80c8-4fc5-9749-6e5a1b5e51ee_0,LC.k8s_get-followers-sdc_get-followers-sdc-67c77bf84d-npttk_sdc-socialnetwork-func_94ce0ea0-3290-406c-aa55-7b95c58a2567_0,LC.k8s_get-user-id-sdc_get-user-id-sdc-5bdb45b5bd-fjlqn_sdc-socialnetwork-func_d4900a38-a416-4c53-9d49-1197c35c2452_0,LC.k8s_upload-urls-sdc_upload-urls-sdc-696d98f48-nrhsn_sdc-socialnetwork-func_41528b4c-bc76-450e-8f02-e6b4692e0742_0,LC.k8s_upload-text-sdc_upload-text-sdc-76f555bf8d-nr4lw_sdc-socialnetwork-func_fc87de81-6fa0-4673-a84c-30a448567dc4_0,LC.k8s_upload-user-mentions-sdc_upload-user-mentions-sdc-854fd6896d-49fxx_sdc-socialnetwork-func_ab531cdc-5a0a-45f5-b516-54e4d6a3ef6d_0,LC.k8s_upload-user-timeline-sdc_upload-user-timeline-sdc-594f5df7d8-qdzhb_sdc-socialnetwork-func_01eda713-bc9f-4c57-96fc-b5d74cb12da1_0,LC.k8s_workflow-sdc_workflow-sdc-68bf5bb89b-jnczs_sdc-socialnetwork-func_e5107344-4c82-4340-98fd-b06a33e8e0e5_0,LC.k8s_workflow-sdc_workflow-sdc-68bf5bb89b-wsx67_sdc-socialnetwork-func_9afafc44-6ca6-44e6-9077-7d26566963d2_0,LC.k8s_workflow-sdc_workflow-sdc-68bf5bb89b-p88xt_sdc-socialnetwork-func_f65d660e-9c07-4ef7-b7b4-2db9f1a1894f_0,LC.k8s_workflow-sdc_workflow-sdc-68bf5bb89b-hh9cm_sdc-socialnetwork-func_ac21e5b8-1ae7-4e48-98e2-ef8f70a54acb_0,LC.k8s_post-storage-sdc_post-storage-sdc-7f8464cd6d-wh77p_sdc-socialnetwork-func_93221e6a-84a0-40b8-b490-4cb2ebd48b16_0,LC.k8s_post-storage-mongodb_post-storage-mongodb-744f95dc75-wvxlj_sdc-socialnetwork-db_e03160e5-efcb-4ce3-ad60-78e836ccc0dd_0,LC.k8s_user-timeline-mongodb_user-timeline-mongodb-dc66b6ccb-lrzqc_sdc-socialnetwork-db_4a568705-45b3-4721-8be1-6791aab95be8_0,LC.k8s_user-timeline-redis_user-timeline-redis-776d7d984-j9jc2_sdc-socialnetwork-db_32c05ffc-f5b1-4a0e-b017-9f21f78d0509_0,LC.k8s_user-mongodb_user-mongodb-5fdc8846f4-b2rwn_sdc-socialnetwork-db_534564fb-5a93-4d64-a73a-9e4d427c4bfe_0,LC.k8s_user-memcached_user-memcached-648b669976-fxqxj_sdc-socialnetwork-db_3a0d3694-0e0e-4534-8a41-4db4106811f4_0,LC.k8s_social-graph-mongodb_social-graph-mongodb-d9dd698f9-78tfs_sdc-socialnetwork-db_faa8d376-8d9c-489b-aaab-76aeeb21b442_0,LC.k8s_home-timeline-redis_home-timeline-redis-65c7d947b4-d6q9k_sdc-socialnetwork-db_b7c68710-e648-4bbb-95e3-ab4ab0f09a5e_0,LC.k8s_compose-post-redis_compose-post-redis-f9dff49d6-6x2kk_sdc-socialnetwork-db_25aa051a-bb8a-4bd8-88fe-8243346a347f_0";
		}


		int durationTime=Integer.parseInt(args[1].trim());
		Repository.resultFilePath=args[2].trim();
		if(Repository.resultFilePath==null||Repository.resultFilePath.equals("x")){
			Repository.resultFilePath="/home/tank/yanan/";
		}
		

		Repository.loaderRmiUrl="rmi://"+args[3].trim()+":"+args[4].trim()+"/load";
		Repository.loaderRmiUrl="rmi://192.168.1.129:22222/load";
		//Repository.setupRmiConnection();

		Repository.lcQPS=Integer.parseInt(args[5].trim());
		Repository.serviceType=Integer.parseInt(args[6].trim());

		String[] containerList=containersNameStr.replaceAll(" ","").split(",");
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

		/**
		 * RDT monitor
		 */
		Map<String,String> typeCoreMap=new HashMap<String, String>();
		for(String containerName:Repository.containerMap.keySet()){
			String containerType=Repository.containerMap.get(containerName).getTaskType();
			String containerCpuCoreStr=Repository.containerMap.get(containerName).getLogicCoreStr().trim();
			if(containerCpuCoreStr==null||containerCpuCoreStr.equals("")){
				System.out.println(containerName+"is not yet being binded CPU cores");
				//				if(containerType.equals("LC"))
				//					typeCoreMap.put(containerType, "0-9");
				//				else
				//					typeCoreMap.put(containerType, "20-29");
				//				continue;
				System.exit(0);
			}
			typeCoreMap.put(containerType, Repository.containerMap.get(containerName).getLogicCoreStr());
		}
		for(String containerType:typeCoreMap.keySet()){
			Repository.flag++;
			Thread thread=new Thread(new RDTMetricesCollectThread(typeCoreMap.get(containerType), durationTime, begin, containerType));
			thread.start();
		}
		/**
		 * docker monitor
		 */
		Repository.flag++;
		Thread thread=new Thread(new ContainerMetricesCollectThread(containerSpaceStr.toString(), durationTime, begin));
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
				Repository.instructionMap.put(containerType, 0L);
			}else{
				List<String> pidList=pidMap.get(containerType);
				pidList.add(pid);
			}
		}
		for(String containerType: pidMap.keySet()){
			Repository.flag++;
			Thread thread2=new Thread(new PerfMetricesCollectThread(pidMap.get(containerType), durationTime, begin, containerType));
			thread2.start();
		}

		begin.countDown();

		while(Repository.flag>0){
			try {
				Thread.sleep(1000);
			} catch(InterruptedException e){
				e.printStackTrace();
			}
		}

		Repository.SYSTEM_RUN_FLAG=false;
		/**
		 * record result
		 */
		new ResultRecord().record();
	}
	public void collectColocationIpc(String[] args){
		if(args.length!=4){
			System.out.println("containerNameStr(,) durationTime(ms) resultFilePath QPS");
			System.out.println("jar -jar xxx.jar LC.xxxx,LC.xxxx,LC.xxxx,BE.xxxx 50000 /home/tank/result/");
			System.exit(0);
		}

		String containersNameStr=args[0];
		if(containersNameStr==null||containersNameStr.equals("x")){
			/*containersNameStr="LC.k8s_solr_sdc-solr-1_sdc-solr_577698f2-d992-4384-b672-c6a178baf57f_0,"
			+ "LC.k8s_solr_sdc-solr-0_sdc-solr_096c3fbc-8057-4a00-818c-c54257cc8f81_0,"
			+ "BE.k8s_solr_sdc-solr-2_sdc-solr_dc71349b-d181-4c30-9492-24fa9258c940_0";*/
			containersNameStr=
					"LC.k8s_upload-unique-id-sdc_upload-unique-id-sdc-96bf586d4-nwzkb_sdc-socialnetwork-func_c5235ae5-18e9-420b-a2ff-4923fbb30128_0,"
					+ "LC.k8s_upload-media-sdc_upload-media-sdc-5c85584784-zp7df_sdc-socialnetwork-func_47e1badc-244a-4e30-a84b-e0085e679f1c_0,"
					+ "LC.k8s_compose-and-upload-sdc_compose-and-upload-sdc-77655f8744-js7xs_sdc-socialnetwork-func_6213db99-aed6-422b-a647-5d67e7bafaeb_0,"
					+ "LC.k8s_compose-post-sdc_compose-post-sdc-69444cf7f6-qpdvm_sdc-socialnetwork-func_b837ceb9-4205-4d8f-a709-288b769bae31_0,"
					+ "LC.k8s_upload-creator-sdc_upload-creator-sdc-575b558cb-tjx6c_sdc-socialnetwork-func_7e1bf29f-b0ed-4744-9cd8-bb121d1104a5_0,"
					+ "LC.k8s_upload-home-timeline-sdc_upload-home-timeline-sdc-56bc74f9d8-8ljbq_sdc-socialnetwork-func_d1d50455-80c8-4fc5-9749-6e5a1b5e51ee_0,"
					+ "LC.k8s_get-followers-sdc_get-followers-sdc-67c77bf84d-npttk_sdc-socialnetwork-func_94ce0ea0-3290-406c-aa55-7b95c58a2567_0,"
					+ "LC.k8s_get-user-id-sdc_get-user-id-sdc-5bdb45b5bd-fjlqn_sdc-socialnetwork-func_d4900a38-a416-4c53-9d49-1197c35c2452_0,"
					+ "LC.k8s_upload-urls-sdc_upload-urls-sdc-696d98f48-nrhsn_sdc-socialnetwork-func_41528b4c-bc76-450e-8f02-e6b4692e0742_0,"
					+ "LC.k8s_upload-text-sdc_upload-text-sdc-76f555bf8d-nr4lw_sdc-socialnetwork-func_fc87de81-6fa0-4673-a84c-30a448567dc4_0,"
					+ "LC.k8s_upload-user-mentions-sdc_upload-user-mentions-sdc-854fd6896d-49fxx_sdc-socialnetwork-func_ab531cdc-5a0a-45f5-b516-54e4d6a3ef6d_0,"
					+ "LC.k8s_upload-user-timeline-sdc_upload-user-timeline-sdc-594f5df7d8-qdzhb_sdc-socialnetwork-func_01eda713-bc9f-4c57-96fc-b5d74cb12da1_0,"
					+ "LC.k8s_post-storage-sdc_post-storage-sdc-7f8464cd6d-wh77p_sdc-socialnetwork-func_93221e6a-84a0-40b8-b490-4cb2ebd48b16_0,"
					+ "LC.k8s_user-timeline-mongodb_user-timeline-mongodb-dc66b6ccb-lrzqc_sdc-socialnetwork-db_4a568705-45b3-4721-8be1-6791aab95be8_0,"
					+ "LC.k8s_user-timeline-redis_user-timeline-redis-776d7d984-j9jc2_sdc-socialnetwork-db_32c05ffc-f5b1-4a0e-b017-9f21f78d0509_0,"
					+ "LC.k8s_user-memcached_user-memcached-648b669976-fxqxj_sdc-socialnetwork-db_3a0d3694-0e0e-4534-8a41-4db4106811f4_0,"
					+ "LC.k8s_compose-post-redis_compose-post-redis-f9dff49d6-6x2kk_sdc-socialnetwork-db_25aa051a-bb8a-4bd8-88fe-8243346a347f_0";
		}


		int durationTime=Integer.parseInt(args[1].trim());
		Repository.resultFilePath=args[2].trim();
		if(Repository.resultFilePath==null||Repository.resultFilePath.equals("x")){
			Repository.resultFilePath="/home/tank/yanan/";
		}
		

		Repository.lcQPS=Integer.parseInt(args[3].trim());

		String[] containerList=containersNameStr.replaceAll(" ","").split(",");
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
				Repository.instructionMap.put(containerType, 0L);
			}else{
				List<String> pidList=pidMap.get(containerType);
				pidList.add(pid);
			}
		}
		for(String containerType: pidMap.keySet()){
			Repository.flag++;
			Thread thread2=new Thread(new PerfMetricesCollectThread(pidMap.get(containerType), durationTime, begin, containerType));
			thread2.start();
		}

		begin.countDown();

		while(Repository.flag>0){
			try {
				Thread.sleep(1000);
			} catch(InterruptedException e){
				e.printStackTrace();
			}
		}

		Repository.SYSTEM_RUN_FLAG=false;
		/**
		 * record result
		 */
		new ResultRecord().IpcRecord();
	}

}
