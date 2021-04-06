package scs.pojo;

public class ContainerStatisticsBean {

	private float cpuUsageRate;
	private float memUsageRate;
	private float memUsageAmount;
	private float netInputBegin;
	private float netInputEnd;
	private float netOutputBegin;
	private float netOutputEnd;
	private float ioInputBegin;
	private float ioInputEnd;
	private float ioOutputBegin;
	private float ioOutputEnd;
	private int statisticsCounter;
	private long collectTimeBegin;
	private long collectTimeEnd;

	public ContainerStatisticsBean() {
	}

	public float getCpuUsageRate() {
		return cpuUsageRate;
	}
	public float getMemUsageRate() {
		return memUsageRate;
	}
	public float getMemUsageAmount() {
		return memUsageAmount;
	}
	public float getNetInputBegin() {
		return netInputBegin;
	}

	public float getNetInputEnd() {
		return netInputEnd;
	}

	public float getNetOutputBegin() {
		return netOutputBegin;
	}

	public float getNetOutputEnd() {
		return netOutputEnd;
	}

	public float getIoInputBegin() {
		return ioInputBegin;
	}

	public float getIoInputEnd() {
		return ioInputEnd;
	}

	public float getIoOutputBegin() {
		return ioOutputBegin;
	}

	public float getIoOutputEnd() {
		return ioOutputEnd;
	}
	public void setNetInputBegin(float netInputBegin) {
		this.netInputBegin = netInputBegin;
	}

	public void setNetInputEnd(float netInputEnd) {
		this.netInputEnd = netInputEnd;
	}

	public void setNetOutputBegin(float netOutputBegin) {
		this.netOutputBegin = netOutputBegin;
	}

	public void setNetOutputEnd(float netOutputEnd) {
		this.netOutputEnd = netOutputEnd;
	}

	public void setIoInputBegin(float ioInputBegin) {
		this.ioInputBegin = ioInputBegin;
	}

	public void setIoInputEnd(float ioInputEnd) {
		this.ioInputEnd = ioInputEnd;
	}

	public void setIoOutputBegin(float ioOutputBegin) {
		this.ioOutputBegin = ioOutputBegin;
	}

	public void setIoOutputEnd(float ioOutputEnd) {
		this.ioOutputEnd = ioOutputEnd;
	}

	public int getStatisticsCounter() {
		return statisticsCounter;
	}
	public long getCollectTimeBegin() {
		return collectTimeBegin;
	}
	public long getCollectTimeEnd() {
		return collectTimeEnd;
	}
	public void setCpuUsageRate(float cpuUsageRate) {
		this.cpuUsageRate = cpuUsageRate;
	}
	public void setMemUsageRate(float memUsageRate) {
		this.memUsageRate = memUsageRate;
	}
	public void setMemUsageAmount(float memUsageAmount) {
		this.memUsageAmount = memUsageAmount;
	}
	public void setStatisticsCounter(int statisticsCounter) {
		this.statisticsCounter = statisticsCounter;
	}
	public void setCollectTimeBegin(long collectTimeBegin) {
		this.collectTimeBegin = collectTimeBegin;
	}
	public void setCollectTimeEnd(long collectTimeEnd) {
		this.collectTimeEnd = collectTimeEnd;
	}

	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append("ContainerStatisticsBean [cpuUsageRate=");
		builder.append(cpuUsageRate);
		builder.append(", memUsageRate=");
		builder.append(memUsageRate);
		builder.append(", memUsageAmount=");
		builder.append(memUsageAmount);
		builder.append(", netInputBegin=");
		builder.append(netInputBegin);
		builder.append(", netInputEnd=");
		builder.append(netInputEnd);
		builder.append(", netOutputBegin=");
		builder.append(netOutputBegin);
		builder.append(", netOutputEnd=");
		builder.append(netOutputEnd);
		builder.append(", ioInputBegin=");
		builder.append(ioInputBegin);
		builder.append(", ioInputEnd=");
		builder.append(ioInputEnd);
		builder.append(", ioOutputBegin=");
		builder.append(ioOutputBegin);
		builder.append(", ioOutputEnd=");
		builder.append(ioOutputEnd);
		builder.append(", statisticsCounter=");
		builder.append(statisticsCounter);
		builder.append(", collectTimeBegin=");
		builder.append(collectTimeBegin);
		builder.append(", collectTimeEnd=");
		builder.append(collectTimeEnd);
		builder.append("]");
		return builder.toString();
	}

 




}