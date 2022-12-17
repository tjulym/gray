package scs.pojo;
 
/**
 * RDT 指标监控
 * @author DELL
 *
 */
public class RDTMetricesBean {
	private float ipc;
	private float llc;
	private float memBandwidth;
	
	public float getIpc() {
		return ipc;
	}
	public float getLlc() {
		return llc;
	}
	public float getMemBandwidth() {
		return memBandwidth;
	}
	public void setIpc(float ipc) {
		this.ipc = ipc;
	}
	public void setLlc(float llc) {
		this.llc = llc;
	}
	public void setMemBandwidth(float memBandwidth) {
		this.memBandwidth = memBandwidth;
	}
}
