package scs.util.driver;
 
import scs.util.repository.Repository;  
/**
 * 请求发送线程,发送请求并记录时间
 * @author yanan
 *
 */
public class TimerThread extends Thread{

	private final int SLEEP_TIME=10000;//2000ms
	private int EXECUTE_TIME=600000;//2000ms
	  
	/**
	 * 初始化方法
	 */ 	
	public TimerThread(int EXECUTE_TIME){
		this.EXECUTE_TIME=EXECUTE_TIME*1000;
	}
	@Override
	public void run(){ 
		Repository.SYSTEM_RUN_FLAG=true;
		long start=System.currentTimeMillis();
		while(true){
			if((System.currentTimeMillis()-start)>EXECUTE_TIME){
				Repository.SYSTEM_RUN_FLAG=false;
				break;
			}
			try {
				Thread.sleep(SLEEP_TIME);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
	}
}


