package scs.pojo;

import java.io.Serializable;

import scs.util.tools.DataFormats;

/**
 * Application 微架构指标
 * @author DELL
 *
 */
public class AppMetricesBean implements Serializable{
	private static final long serialVersionUID = 1L;
	
	private DataFormats dataFormats;
	private long contextSwitch;
	private long l1InstructionMPKI;
	private long l1DataMPKI;
	private long l2MPKI;
	private long tlbDataMPKI;
	private long tlbInstructionMPKI;
	private long branchMPKI;
	private long l3MPKI;
	private float mlp; 
	
	private float cpuUtilRate;
	private float memUtilRate;
	private float memBandwidth; //MB/s
	private float llc; 		//MB
	private float ipc; 
	private float diskIO; 	//MB/s
	private float networkIO; //MB/s
	
	public AppMetricesBean(){
		this.dataFormats=DataFormats.getInstance();
	}

	public long getContextSwitch() {
		return contextSwitch;
	}

	public long getL1InstructionMPKI() {
		return l1InstructionMPKI;
	}

	public long getL1DataMPKI() {
		return l1DataMPKI;
	}

	public long getL2MPKI() {
		return l2MPKI;
	}

	public long getTlbDataMPKI() {
		return tlbDataMPKI;
	}

	public long getTlbInstructionMPKI() {
		return tlbInstructionMPKI;
	}

	public long getBranchMPKI() {
		return branchMPKI;
	}

	public long getL3MPKI() {
		return l3MPKI;
	}

	public float getMlp() {
		return mlp;
	}

	public float getCpuUtilRate() {
		return cpuUtilRate;
	}

	public float getMemUtilRate() {
		return memUtilRate;
	}

	public float getMemBandwidth() {
		return memBandwidth;
	}

	public float getLlc() {
		return llc;
	}

	public float getIpc() {
		return ipc;
	}

	public float getDiskIO() {
		return diskIO;
	}

	public float getNetworkIO() {
		return networkIO;
	}

	public void setContextSwitch(long contextSwitch) {
		this.contextSwitch = contextSwitch;
	}

	public void setL1InstructionMPKI(long l1InstructionMPKI) {
		this.l1InstructionMPKI = l1InstructionMPKI;
	}

	public void setL1DataMPKI(long l1DataMPKI) {
		this.l1DataMPKI = l1DataMPKI;
	}

	public void setL2MPKI(long l2mpki) {
		l2MPKI = l2mpki;
	}

	public void setTlbDataMPKI(long tlbDataMPKI) {
		this.tlbDataMPKI = tlbDataMPKI;
	}

	public void setTlbInstructionMPKI(long tlbInstructionMPKI) {
		this.tlbInstructionMPKI = tlbInstructionMPKI;
	}

	public void setBranchMPKI(long branchMPKI) {
		this.branchMPKI = branchMPKI;
	}

	public void setL3MPKI(long l3mpki) {
		l3MPKI = l3mpki;
	}

	public void setMlp(float mlp) {
		this.mlp = mlp;
	}

	public void setCpuUtilRate(float cpuUtilRate) {
		this.cpuUtilRate = dataFormats.subFloat(cpuUtilRate, 4);
	}

	public void setMemUtilRate(float memUtilRate) {
		this.memUtilRate = dataFormats.subFloat(memUtilRate, 4);
	}

	public void setMemBandwidth(float memBandwidth) {
		this.memBandwidth = dataFormats.subFloat(memBandwidth, 2);
	}

	public void setLlc(float llc) {
		this.llc = dataFormats.subFloat(llc, 2);
	}

	public void setIpc(float ipc) {
		this.ipc = ipc;
	}

	public void setDiskIO(float diskIO) {
		this.diskIO = dataFormats.subFloat(diskIO, 2);
	}

	public void setNetworkIO(float networkIO) {
		this.networkIO = dataFormats.subFloat(networkIO, 2);
	}

	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append("AppMetricesBean [contextSwitch=");
		builder.append(contextSwitch);
		builder.append(", l1InstructionMPKI=");
		builder.append(l1InstructionMPKI);
		builder.append(", l1DataMPKI=");
		builder.append(l1DataMPKI);
		builder.append(", l2MPKI=");
		builder.append(l2MPKI);
		builder.append(", tlbDataMPKI=");
		builder.append(tlbDataMPKI);
		builder.append(", tlbInstructionMPKI=");
		builder.append(tlbInstructionMPKI);
		builder.append(", branchMPKI=");
		builder.append(branchMPKI);
		builder.append(", l3MPKI=");
		builder.append(l3MPKI);
		builder.append(", mlp=");
		builder.append(mlp);
		builder.append(", cpuUtilRate=");
		builder.append(cpuUtilRate);
		builder.append(", memUtilRate=");
		builder.append(memUtilRate);
		builder.append(", memBandwidth=");
		builder.append(memBandwidth);
		builder.append(", llc=");
		builder.append(llc);
		builder.append(", ipc=");
		builder.append(ipc);
		builder.append(", diskIO=");
		builder.append(diskIO);
		builder.append(", networkIO=");
		builder.append(networkIO);
		builder.append("]");
		return builder.toString();
	} 
	
}
