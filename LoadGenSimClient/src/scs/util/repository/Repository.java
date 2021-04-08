package scs.util.repository;

import java.net.MalformedURLException;
import java.rmi.Naming;
import java.rmi.NotBoundException;
import java.rmi.RemoteException;

import scs.util.rmi.LoadInterface;

/**
 * 系统静态仓库类
 * 通过静态变量的形式为系统运行中需要用到的数据提供内存型存储
 * 包括一些系统参数，应用运行数据，控制标志等
 * @author yanan
 *
 */
public class Repository{
	 
	private static Repository repository=null; 
	public static LoadInterface loader=null;
	private Repository(){}
	
	public synchronized static Repository getInstance() {
		if (repository == null) {
			repository = new Repository();
		}
		return repository;
	}  
	/**
	 * 控制信号
	 */
	public static boolean SYSTEM_RUN_FLAG=true;//控制系统各个线程的标志 
	public static boolean recordLatency=false;
	public static boolean recordUtility=false;
	/**
	 * 运行变量
	 */
	public static String loaderRmiUrl="rmi://192.168.1.129:8080/load";
	public static String resultFilePath="/home/tank/simLoad/result/";//数据采集结果的存放目录
	/**
	 * 产生模拟负载的参数
	 */
	public static int maxSimQPS=0;
	public static float simQpsPeekRate=0;
	public static String realQpsFilePath="";
	/**
	 * 发送负载的参数
	 */
	public static int simQpsRemainInterval=0;
	public static int systemRunTime=0;
	public static int serviceId=0;
	public static int concurrency=0;
	 
	
	/**
	 * 静态块
	 */
	 
	
	 
	/**
	 * 建立loader与agent直接的rmi连接
	 */
	public static void setupRmiConnection(){
		try {
			Repository.loader=(LoadInterface) Naming.lookup(loaderRmiUrl);
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (RemoteException e) {
			e.printStackTrace();
		} catch (NotBoundException e) {
			e.printStackTrace();
		}
		if(loader!=null){
			System.out.println(loaderRmiUrl +"建立连接 success");
		}else{
			System.out.println(loaderRmiUrl +"建立连接 fail");
		}
	}

}
