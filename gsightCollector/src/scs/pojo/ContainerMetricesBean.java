package scs.pojo;

public class ContainerMetricesBean {
    private String containerName;
    private float cpuUsageRate;
    private float memUsageRate;
    private float memUsageAmount;
    private float netInput;
    private float ioInput;
    private float ioOutput;
    private float netOutput;
    private long collectTime;

    public String getContainerName() {
        return containerName;
    }

    public void setContainerName(String containerName) {
        this.containerName = containerName == null ? null : containerName.trim();
    }

    public float getCpuUsageRate() {
        return cpuUsageRate;
    }

    public void setCpuUsageRate(float cpuUsageRate) {
        this.cpuUsageRate = cpuUsageRate;
    }

    public float getMemUsageRate() {
        return memUsageRate;
    }

    public void setMemUsageRate(float memUsageRate) {
        this.memUsageRate = memUsageRate;
    }

    public float getMemUsageAmount() {
        return memUsageAmount;
    }

    public void setMemUsageAmount(float memUsageAmount) {
        this.memUsageAmount = memUsageAmount;
    }

    public float getNetInput() {
        return netInput;
    }

    public void setNetInput(float netInput) {
        this.netInput = netInput;
    }

    public float getIoInput() {
        return ioInput;
    }

    public void setIoInput(float ioInput) {
        this.ioInput = ioInput;
    }

    public float getIoOutput() {
        return ioOutput;
    }

    public void setIoOutput(float ioOutput) {
        this.ioOutput = ioOutput;
    }

    public float getNetOutput() {
        return netOutput;
    }

    public void setNetOutput(float netOutput) {
        this.netOutput = netOutput;
    }

    public long getCollectTime() {
        return collectTime;
    }

    public void setCollectTime(long collectTime) {
        this.collectTime = collectTime;
    }

	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append("TableContainerresourceusage [containerName=");
		builder.append(containerName);
		builder.append(", cpuUsageRate=");
		builder.append(cpuUsageRate);
		builder.append(", memUsageRate=");
		builder.append(memUsageRate);
		builder.append(", memUsageAmount=");
		builder.append(memUsageAmount);
		builder.append("MB, netInput=");
		builder.append(netInput);
		builder.append("MB, netOutput=");
		builder.append(netOutput);
		builder.append("MB, ioInput=");
		builder.append(ioInput);
		builder.append("MB, ioOutput=");
		builder.append(ioOutput);
		builder.append("MB, collectTime=");
		builder.append(collectTime);
		builder.append("ms]");
		return builder.toString();
	}
 
}