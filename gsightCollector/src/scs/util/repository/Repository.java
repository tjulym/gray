package scs.util.repository;

import java.net.MalformedURLException;
import java.rmi.Naming;
import java.rmi.NotBoundException;
import java.rmi.RemoteException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import scs.pojo.AppMetricesBean;
import scs.pojo.ContainerBean;
import scs.pojo.TwoTuple;
import scs.util.resource.DockerService;
import scs.util.rmi.LoadInterface;

/**
 * 系统静态仓库类
 * 通过静态变量的形式为系统运行中需要用到的数据提供内存型存储
 * 包括一些系统参数，应用运行数据，控制标志等
 * @author yanan
 *
 */
public class Repository{ 
	private DockerService dService=DockerService.getInstance();
	public static LoadInterface loader=null;
	private static Repository repository=null;
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
	public static boolean SYSTEM_RUN_FLAG=false;//控制系统各个线程的标志 
	
	public static int flag=0;
	public static Map<String, ContainerBean> containerMap=new HashMap<String, ContainerBean>();//<key=ContainerName, value=ContainerBean>
	public static Map<String, AppMetricesBean> appFinalMetricsMap=new HashMap<String, AppMetricesBean>();//<key="LC", value=AppMetricesBean>
	
	public static String loaderRmiUrl="http://192.168.1.129:8080";
	public static String resultFilePath="";
	public static int lcQPS=0;
	public static int serviceType=0;
	
	/**
	 * 静态块
	 */
	static { 
		//readProperties();// 读取配置文件
		//init(); //初始化工作,配置文件 只读取一次
	}

	/**
	 * 读取配置文件的参数
	 */
//	private static void readProperties(){
//		Properties prop = new Properties();
//		//InputStream is = Repository.class.getResourceAsStream("/sys.properties");
//		try {
//			InputStream is = new FileInputStream(new File("/home/tank/sdcloud/result/sys.properties"));
//			prop.load(is);
//		} catch (IOException e) {
//			e.printStackTrace();
//		}
//	}

	/**
	 * 初始化函数
	 */
//	private static void init(){
//		//System.out.println(Thread.currentThread().getName()+" init finished");
//	}
 
	public void updateContainerMap(String containerName, ContainerBean bean){
		containerMap.put(containerName, bean);
		System.out.println("Repository: init ContainerMap put "+bean.toString());
	}
	/**
	 * 根据输入的container字符串查询container的信息,生成注册
	 * @param list=ArrayList<TwoTuple<String,String>> <<"LC","ContainerName1">,<"BE","ContainerName2">>
	 */
	public void registerContainerInfo(ArrayList<TwoTuple<String,String>> list){
		dService.getContainerInfo(list);
		for(TwoTuple<String,String> item: list){
			if(!appFinalMetricsMap.containsKey(item.first)){
				appFinalMetricsMap.put(item.first, new AppMetricesBean());
				System.out.println("Repository: init AppFinalMetricsMap put key="+item.first);
			}
		}
	}

//	public void updateAppMetricsMap(String containerType, AppMetricesBean bean){
//		appFinalMetricsMap.put(containerType, bean);
//		System.out.println("Repository: updateAppMetricsMap put "+bean.toString());
//	}
	
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
