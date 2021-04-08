package scs.util.loadGen;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import scs.util.tools.FileOperation;

public class GenSimQpsDriver {
  
	private static GenSimQpsDriver driver=null;
	public List<Integer> simRPSList=null;
	private GenSimQpsDriver(){
		this.simRPSList=new ArrayList<Integer>();
	}
	
	public synchronized static GenSimQpsDriver getInstance() {
		if (driver == null) {  
			driver = new GenSimQpsDriver();
		}  
		return driver;
	}
	/**
	 * 根据真实的负载换算成对应的模拟负载 并储存在Repository类中
	 * @param maxSimQPS 模拟负载的最大QPS
	 * @param filePath 真实负载数据的路径
	 * @param maxRealLoadRate 真实负载的最大负载率 0-1
	 * @throws IOException
	 */
	public void genSimRPSList(int maxSimQPS,String realQpsFilePath,Float simQpsPeekRate) throws IOException{
		List<Double> realRPSList=this.getRealRPSList(realQpsFilePath);
		double maxRealRPS=0;
		for(double item:realRPSList){
			maxRealRPS=item>maxRealRPS?item:maxRealRPS;//计算负载中最大值
		}
		//maxRealRPS=(int)(maxRealRPS/simQpsPeekRate);//根据负载最大比例进行换算 一般规定最大值为最大负载的0.9
		int size=realRPSList.size();
		for(int i=0;i<size;i++){
			simRPSList.add((int)(realRPSList.get(i)/maxRealRPS*maxSimQPS*simQpsPeekRate));
		}
		if(simRPSList.size()>0){
			System.out.println("simQPS generating finished, len="+simRPSList.size()+" realQpsFilePath="+realQpsFilePath+" maxSimQPS="+maxSimQPS+" simQpsPeekRate="+simQpsPeekRate);
		}
	}
	/**
	 * 读取文件 获取真实的rps负载数据
	 * @param filePath
	 * @return
	 * @throws IOException
	 */
	private List<Double> getRealRPSList(String filePath) throws IOException{
		FileOperation fo=new FileOperation();
		return fo.readDoubleFile(filePath);
	}
}
