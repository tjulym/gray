package scs.pojo;

import java.util.ArrayList;
import java.util.List;
/**
 * 任务信息实体类
 * @author yanan
 * 包含任务类型,任务所在容器,任务资源占用等
 */
public class ContainerBean {
	private String taskType; //所属任务类型
	private String containerName; //容器名称
	private String pid;//pid名称 
	private List<Integer> logicCoreList; //分配的cpu cores
	private String logicCoreStr;
	private int memoryLimit; //分配的内存大小 单位:MB 
	
	public String getTaskType() {
		return taskType;
	}
	public void setTaskType(String taskType) {
		this.taskType = taskType;
	}
	public String getContainerName() {
		return containerName;
	}
	public void setContainerName(String containerName) {
		this.containerName = containerName;
	}
	public String getPid() {
		return pid;
	}
	public void setPid(String pid) {
		this.pid = pid;
	}
	public List<Integer> getLogicCoreList() {
		return logicCoreList;
	}
	public void setLogicCoreList(List<Integer> logicCoreList) {
		this.logicCoreList = logicCoreList;
	}
	public String getLogicCoreStr() {
		return logicCoreStr;
	}
	public void setLogicCoreList(String cpuStr) {
		 List<Integer> list=new ArrayList<Integer>();
		if(cpuStr!=null&&cpuStr.contains(",")){//解析包含','的cpu字符串
			String[] cpus=cpuStr.split(",");
			for(int i=0;i<cpus.length;i++){
				list.add(Integer.parseInt(cpus[i])); 
			}
		}else if(cpuStr!=null&&cpuStr.contains("-")){//解析包含'-'的cpu字符串
			String[] cpus=cpuStr.split("-");
			int start=Integer.parseInt(cpus[0]);
			int end=Integer.parseInt(cpus[1]);
			for(int i=start;i<=end;i++){ 
				list.add(i);
			}
		}
		this.logicCoreStr=cpuStr;
		this.logicCoreList = list;
	}
	public int getMemoryLimit() {
		return memoryLimit;
	}
	public void setMemoryLimit(int memoryLimit) {
		this.memoryLimit = memoryLimit;
	}
	 
	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append("ContainerBean [taskType=");
		builder.append(taskType);
		builder.append(", containerName=");
		builder.append(containerName);
		builder.append(", pid=");
		builder.append(pid);
		builder.append(", logicCoreList=");
		builder.append(logicCoreList);
		builder.append(", memoryLimit=");
		builder.append(memoryLimit);
		builder.append("]");
		return builder.toString();
	}
	
	 

	 
}	
