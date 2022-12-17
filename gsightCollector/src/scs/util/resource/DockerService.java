package scs.util.resource;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.LineNumberReader;
import java.text.NumberFormat;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;
import scs.pojo.ContainerBean;
import scs.pojo.ContainerMetricesBean;
import scs.pojo.TwoTuple;
import scs.util.repository.Repository;
import scs.util.resource.net.NetMonitor;
/**
 * docker调用接口
 * @author yanan
 *
 */

public class DockerService {
	private NumberFormat percentInstance = NumberFormat.getPercentInstance();
	private NetMonitor netMonitor=NetMonitor.getInstance();
	
	private static DockerService service=null;
	private DockerService(){}
	
	public synchronized static DockerService getInstance() {
		if (service == null) {  
			service = new DockerService();
		}  
		return service;
	} 
	/**
	 * 获取容器的各项信息
	 * pid 网卡名称 CPU绑定 内存大小
	 * @param containerNamesList 容器名称数组 ArrayList<TwoTuple<String,String>> e.g., {<LC,?>,<BE,?>}
	 * @return 封装的实体类数组
	 */
	public void getContainerInfo(ArrayList<TwoTuple<String,String>> containerNamesList){
		JSONObject jsonObject;
		int length=containerNamesList.size();
		for(int i=0;i<length;i++){
			jsonObject = getContainerConfig(containerNamesList.get(i).second);//查询容器资源使用信息,返回json格式
			ContainerBean bean=new ContainerBean();
			bean.setTaskType(containerNamesList.get(i).first);
			bean.setContainerName(containerNamesList.get(i).second);
			bean.setPid(jsonObject.get("Pid").toString());
			bean.setLogicCoreList(jsonObject.get("CpusetCpus").toString()); 
			bean.setMemoryLimit((int)(Long.parseLong(jsonObject.get("Memory").toString())>>20));
			//System.out.println(bean.toString());
			Repository.getInstance().updateContainerMap(bean.getContainerName(), bean);
		}
	}
	/**
	 * 获取容器资源信息
	 * 包括cpu mem pid等信息
	 * @param containerName
	 * @return
	 */
	private JSONObject getContainerConfig(String containerName){
		JSONObject obj=null;
		try { 
			String[] cmd = {"/bin/sh","-c","docker inspect --format='{{json .HostConfig}}' "+containerName}; 
			String line = null,err;
			Process process = Runtime.getRuntime().exec(cmd);
			BufferedReader br = new BufferedReader(new InputStreamReader(process.getErrorStream()));
			InputStreamReader isr = new InputStreamReader(process.getInputStream());
			LineNumberReader input = new LineNumberReader(isr);
			while (((err = br.readLine()) != null||(line = input.readLine()) != null)) {
				if(err==null){
					obj=JSONObject.fromObject(line);
				}else{
					System.out.println(err);
				}
			}  
			cmd[2] = "docker inspect --format='{{.State.Pid}}' "+containerName;
			process = Runtime.getRuntime().exec(cmd);
			br = new BufferedReader(new InputStreamReader(process.getErrorStream()));
			isr = new InputStreamReader(process.getInputStream());
			input = new LineNumberReader(isr);
			while (((err = br.readLine()) != null||(line = input.readLine()) != null)) {
				if(err==null){
					obj.put("Pid",line);
				}else{
					System.out.println(err);
				}
			}  
		}catch (IOException e) { 
			e.printStackTrace();
		} 
		return obj; 
	}
 
	/**
	 * 获取docker stats的统计信息
	 * @param containersNameStr 空格分隔
	 * @return Map<String, ContainerMetricesBean> key为containerType e.g., "LC" "BE"
	 */
	public Map<String, ContainerMetricesBean> getContainerResourceUsage(String containersNameStr){
		Map<String, ArrayList<ContainerMetricesBean>> tempMetricesMap = new HashMap<String, ArrayList<ContainerMetricesBean>>();
		Map<String, ContainerMetricesBean> metricesMap = new HashMap<String,ContainerMetricesBean>();
		try {  
			String[] cmd = {"/bin/sh","-c","docker stats "+containersNameStr+" --no-stream --format '{{.Name}}:{{.CPUPerc}}:{{.MemUsage}}:{{.MemPerc}}:{{.NetIO}}:{{.BlockIO}}'"}; 
			String line = null,err;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
			Process process = Runtime.getRuntime().exec(cmd);
			BufferedReader br = new BufferedReader(new InputStreamReader(process.getErrorStream()));
			InputStreamReader isr = new InputStreamReader(process.getInputStream());
			LineNumberReader input = new LineNumberReader(isr); 
			while (((err = br.readLine()) != null||(line = input.readLine()) != null)) {
				if(err==null){
					ContainerMetricesBean record = new ContainerMetricesBean();
					System.out.println(line);
					String[] split = line.split(":");

					record.setCollectTime(System.currentTimeMillis());
					record.setContainerName(split[0]);
					record.setCpuUsageRate(percentInstance.parse(split[1]).floatValue());

					String mem = split[2].split("\\s")[0];
					if ("K".equalsIgnoreCase(mem.substring(mem.length() - 3, mem.length() - 2))) {
						mem = mem.substring(0, mem.length() - 3);
						record.setMemUsageAmount(Float.parseFloat(mem) / 1024f);
					} else if ("G".equalsIgnoreCase(mem.substring(mem.length() - 3, mem.length() - 2))) {
						mem = mem.substring(0, mem.length() - 3);
						record.setMemUsageAmount(Float.parseFloat(mem) * 1024f);
					} else if ("M".equalsIgnoreCase(mem.substring(mem.length() - 3, mem.length() - 2))) {
						mem = mem.substring(0, mem.length() - 3);
						record.setMemUsageAmount(Float.parseFloat(mem));
					} else {
						mem = mem.substring(0, mem.length() - 1);
						record.setMemUsageAmount(Float.parseFloat(mem) / 1024f / 1024f);
					}
					record.setMemUsageRate(percentInstance.parse(split[3]).floatValue());

					/*
					 * 采集容器io使用
					 */
					String[] ioArray = split[5].split("/");
					if (ioArray[0].trim().endsWith("MB")) {
						record.setIoInput(
								Float.parseFloat(ioArray[0].trim().substring(0, ioArray[0].trim().length() - 2)));
					} else if (ioArray[0].trim().endsWith("kB")) {
						record.setIoInput(
								Float.parseFloat(ioArray[0].trim().substring(0, ioArray[0].trim().length() - 2)) / 1024f);
					} else if (ioArray[0].trim().endsWith("GB")) {
						record.setIoInput(
								Float.parseFloat(ioArray[0].trim().substring(0, ioArray[0].trim().length() - 2)) * 1024f);
					} else if (ioArray[0].trim().endsWith("B") && !(ioArray[0].trim().endsWith("GB")
							|| ioArray[0].trim().endsWith("kB") || ioArray[0].trim().endsWith("MB"))) {
						record.setIoInput(
								Float.parseFloat(ioArray[0].trim().substring(0, ioArray[0].trim().length() - 1))
								/ 1024f / 1024f);
					}
					if (ioArray[1].trim().endsWith("MB")) {
						record.setIoOutput(
								Float.parseFloat(ioArray[1].trim().substring(0, ioArray[1].trim().length() - 2)));
					} else if (ioArray[1].trim().endsWith("kB")) {
						record.setIoOutput(
								Float.parseFloat(ioArray[1].trim().substring(0, ioArray[1].trim().length() - 2)) / 1024f);
					} else if (ioArray[1].trim().endsWith("GB")) {
						record.setIoOutput(
								Float.parseFloat(ioArray[1].trim().substring(0, ioArray[1].trim().length() - 2)) * 1024f);
						;
					} else if (ioArray[1].trim().endsWith("TB")) {
						record.setIoOutput(
								Float.parseFloat(ioArray[1].trim().substring(0, ioArray[1].trim().length() - 2))* 1024f * 1024f);
					} else if (ioArray[1].trim().endsWith("PB")) {
						record.setIoOutput(
								Float.parseFloat(ioArray[1].trim().substring(0, ioArray[1].trim().length() - 2))* 1024f * 1024f * 1024f);
					} else if (ioArray[1].trim().endsWith("B") && !(ioArray[1].trim().endsWith("GB")
							|| ioArray[1].trim().endsWith("kB") || ioArray[1].trim().endsWith("MB"))) {
						record.setIoOutput(
								Float.parseFloat(ioArray[1].trim().substring(0, ioArray[1].trim().length() - 1))/ 1024f / 1024f);
					} 

					float[] containerNetInfoStream = netMonitor.getContainerNetInfoStream(Repository.containerMap.get(record.getContainerName()).getPid());
					record.setNetInput(containerNetInfoStream[0]);
					record.setNetOutput(containerNetInfoStream[1]);

					//System.out.println(record.toString());

					String containerType=Repository.containerMap.get(record.getContainerName()).getTaskType();
					if(tempMetricesMap.containsKey(containerType)){
						ArrayList<ContainerMetricesBean> list=tempMetricesMap.get(containerType);
						list.add(record);
					} else {
						ArrayList<ContainerMetricesBean> list=new ArrayList<ContainerMetricesBean>();
						list.add(record);
						tempMetricesMap.put(containerType, list);
					}

				}else{
					System.out.println(err);
				}
			}  

		}catch (IOException e) { 
			e.printStackTrace();
		} catch (ParseException e) {
			e.printStackTrace();
		} 
		
		/**
		 * summation for each container
		 */
		float cpuUsageRateSum=0,
				memUsageRateSum=0,
				memUsageAmountSum=0,
				netInputSum=0,netOutputSum=0,
				ioInputSum=0,ioOutputSum=0;
		for(String key: tempMetricesMap.keySet()){   //"LC" "BE"
			ArrayList<ContainerMetricesBean> list=tempMetricesMap.get(key);
			if(!list.isEmpty()){
				cpuUsageRateSum=0;memUsageRateSum=0;
				memUsageAmountSum=0;
				netInputSum=0;netOutputSum=0;
				ioInputSum=0;ioOutputSum=0;
				for (ContainerMetricesBean item: list){
					cpuUsageRateSum+=item.getCpuUsageRate();
					memUsageRateSum+=item.getMemUsageRate();
					memUsageAmountSum+=item.getMemUsageAmount();
					netInputSum+=item.getNetInput();
					netOutputSum+=item.getNetOutput();
					ioInputSum+=item.getIoInput();
					ioOutputSum+=item.getIoOutput();
					//System.out.println(item.toString());
				}
				ContainerMetricesBean cmBean=new ContainerMetricesBean();
				cmBean.setCollectTime(list.get(0).getCollectTime());
				cmBean.setCpuUsageRate(cpuUsageRateSum);
				cmBean.setMemUsageRate(memUsageRateSum);
				cmBean.setMemUsageAmount(memUsageAmountSum);
				cmBean.setNetInput(netInputSum);
				cmBean.setNetOutput(netOutputSum);
				cmBean.setIoInput(ioInputSum);
				cmBean.setIoOutput(ioOutputSum);
				metricesMap.put(key, cmBean);
			}
		}
		return metricesMap; 
	} 
	/**
	 * 刷新所有容器的Mem资源设置,使之生效
	 * @param containerList 容器列表
	 * @return
	 */
	public int refreshContainerMemResource(List<ContainerBean> containerList){
		for(ContainerBean container:containerList){
			updateContainerResource(container.getContainerName(),"-m "+container.getMemoryLimit()+"m");//更新容器的内存限制
		}
		return 1;
	}
	/**
	 * 刷新所有容器的Mem资源设置,使之生效
	 * @param container 容器
	 * @return
	 */
	public int refreshContainerMemResource(ContainerBean container){
		updateContainerResource(container.getContainerName(),"-m "+container.getMemoryLimit()+"m");//更新容器的内存限制
		return 1;
	}
	/**
	 * docker exec执行容器里的命令
	 * @param containerName 容器名称
	 * @param command 执行的命令
	 * @return 无返回值
	 */
	public void execVoidCommand(String containerName,String command){
		String[] cmd = {"/bin/sh","-c","docker exec -d "+containerName+" "+command}; 
		String err;
		try {
			Process process = Runtime.getRuntime().exec(cmd); 
			BufferedReader br = new BufferedReader(new InputStreamReader(process.getErrorStream()));
			InputStreamReader isr = new InputStreamReader(process.getInputStream());
			LineNumberReader input = new LineNumberReader(isr); 
			while (((err = br.readLine()) != null||(input.readLine()) != null)) {
				if(err==null){
					//System.out.println(line);
				}else{
					System.out.println(err);
				}
			}

		}catch (IOException e) { 
			e.printStackTrace();
		}  
	}
	/**
	 * docker exec执行容器里的命令
	 * @param containerName 容器名称
	 * @param command 执行的命令
	 * @return 返回执行的结果字符串
	 */
	public String execCommand(String containerName,String command){
		String result="";
		String[] cmd = {"/bin/sh","-c","docker exec -t "+containerName+" "+command};
		String err = null,line = null;
		try {
			Process process = Runtime.getRuntime().exec(cmd);
			BufferedReader br = new BufferedReader(new InputStreamReader(process.getErrorStream()));
			InputStreamReader isr = new InputStreamReader(process.getInputStream());
			LineNumberReader input = new LineNumberReader(isr);
			while (((err = br.readLine()) != null||(line = input.readLine()) != null)) {
				if(line==null){
					result=err;
				}else{
					result=line;
				}
			}
		}catch (IOException e) {
			e.printStackTrace();
		}
		return result;
	}
	/**
	 * 暂停容器执行
	 * @param containerName 容器名称
	 * @return 执行状态
	 */
	public int pauseContainer(String containerName){ 
		String[] cmd = {"/bin/sh","-c","docker pause "+containerName}; 
		//System.out.println("docker pause "+containerName);
		String err;
		try { 
			Process process = Runtime.getRuntime().exec(cmd); 
			BufferedReader br = new BufferedReader(new InputStreamReader(process.getErrorStream()));
			InputStreamReader isr = new InputStreamReader(process.getInputStream());
			LineNumberReader input = new LineNumberReader(isr); 
			while (((err = br.readLine()) != null||(input.readLine()) != null)) {
				if(err==null){
					//System.out.println(line);
				}else{
					System.out.println(err);
				}
			}

		}catch (IOException e) { 
			e.printStackTrace();
			return 0;
		}  
		return 1;
	}
	/**
	 * 继续容器的执行
	 * @param containerName 容器名称
	 * @return 执行状态
	 */
	public int unPauseContainer(String containerName){

		String[] cmd = {"/bin/sh","-c","docker unpause "+containerName}; 
		//System.out.println("docker unpause "+containerName);
		String err;
		try { 
			Process process = Runtime.getRuntime().exec(cmd); 
			BufferedReader br = new BufferedReader(new InputStreamReader(process.getErrorStream()));
			InputStreamReader isr = new InputStreamReader(process.getInputStream());
			LineNumberReader input = new LineNumberReader(isr); 
			while (((err = br.readLine()) != null||(input.readLine()) != null)) {
				if(err==null){
					//System.out.println(line);
				}else{
					System.out.println(err);
				}
			}

		}catch (IOException e) { 
			e.printStackTrace();
			return 0;
		} 
		return 1;
	}
	
	private int updateContainerResource(String containerName,String command){  
		String[] cmd = {"/bin/sh","-c","docker update "+command+" "+containerName}; 
		//System.out.println("docker update "+command+" "+containerName);
		try { 
			String err;
			Process process = Runtime.getRuntime().exec(cmd); 
			BufferedReader br = new BufferedReader(new InputStreamReader(process.getErrorStream()));
			InputStreamReader isr = new InputStreamReader(process.getInputStream());
			LineNumberReader input = new LineNumberReader(isr); 
			while (((err = br.readLine()) != null||(input.readLine()) != null)) {
				if(err==null){
					//System.out.println(line);
				}else{
					System.out.println(err);
				}
			}
	
		}catch (IOException e) { 
			e.printStackTrace();
			return 0;
		}  
		return 1;
	}

}
