package scs.util.driver;

import java.io.IOException;
import scs.util.controller.ControlDriver;
import scs.util.loadGen.HttpRealLoadThread;
import scs.util.repository.Repository;
import scs.util.rmi.LoadInterface;
/**
 * 干扰表征实验
 * @author yanan
 *
 */
public class ExecDriver {
	 
	private LoadInterface loader=null;
	/**
	 * 构造方法
	 */
	public ExecDriver(){
		loader=Repository.loader;
	} 

	/**
	 * webserver在真实负载下的混部控制实验
	 * @param controlLevel
	 * @param execTime
	 * @param BeMaxCount
	 * @throws InterruptedException
	 * @throws IOException
	 */
	public void webServerRealLoadMixed(int systemRunTime, int simQpsRemainInterval, int serviceType, int concurrency) throws InterruptedException, IOException{
		Thread realLoadThread=new Thread(new HttpRealLoadThread(loader, simQpsRemainInterval, serviceType, concurrency));
		realLoadThread.start();
		Thread.sleep(5000);//睡眠5秒钟等待生效
		ControlDriver.start(systemRunTime);
	}

}
