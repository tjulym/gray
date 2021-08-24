package util.test;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.LineNumberReader;
import java.rmi.RemoteException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;


public class GsightScheduler {

	final static int funcSize=26;
	final static int serverNum=2;
	static int[][] placement=new int[funcSize][serverNum];
	static int serverConsumed=0;
	
	public static void main(String[] args) {
		GsightScheduler scheduler=new GsightScheduler();
		//scheduler.display();
		ArrayList<ServerBean> serverList=new ArrayList<ServerBean>();
		serverList.add(new ServerBean(0, "", 0.1f));
		serverList.add(new ServerBean(1, "", 0.2f)); 
		ArrayList<FunctionBean> funcList=new ArrayList<FunctionBean>();
		for(int i=0;i<funcSize;i++){
			funcList.add(new FunctionBean("", (float)Math.random()*0.5f, i, 0));

		}
		scheduler.scheduler(serverNum, serverList, funcList);
		//		String result=scheduler.display();
		//		System.out.println(result);
	}

	private void scheduler(int serverNum, ArrayList<ServerBean> serverList, ArrayList<FunctionBean> funcList){
		if(funcList.size()<=0){
			System.out.println("all function are scheduled");
			return;
		}

		int min=0;
		int max=funcList.size();
		int mid=max;
		boolean violation=false;

		Collections.sort(serverList, new Comparator<ServerBean>() {
			@Override
			public int compare(ServerBean a, ServerBean b) {
				//descending order
				return (int)(b.getAvailRate()-a.getAvailRate());
			}
		});

		Collections.sort(funcList, new Comparator<FunctionBean>() {
			@Override
			public int compare(FunctionBean a, FunctionBean b) {
				//descending order
				return (int)(b.getUsageRate()-a.getUsageRate());
			}
		});

		while(min<max){
			for(FunctionBean item:funcList){
				item.setPlacement(0);
			}
			violation=predict(mid, serverList, funcList);
			if(violation){
				max=mid;
			}else{
				break;
			}
			mid=(int) Math.floor((max+min)/2.0f);
		}
		if(funcList.size()>=(mid+1)){
			serverNum=serverNum-serverList.size();
			if(serverNum<=0){
				System.out.println("no available server");
				return;
			}
			serverConsumed+=serverList.size();
			ServerBean serverBean=new ServerBean(serverConsumed,"",1.0f);
			serverList=new ArrayList<ServerBean>();
			serverList.add(serverBean);
			funcList.get(mid).setPlacement(serverList.get(0).getServerId());
		}
		for(int i=0;i<(mid);i++){
			//System.out.println(mid+" "+funcList.size()); 
			placement[funcList.get(i).getFunctionId()][funcList.get(i).getPlacement()]=1;
		}
		for(int i=0;i<(mid);i++){
			funcList.remove(0);
		}
		scheduler(serverNum, serverList, funcList);
	}
	private boolean predict(int mid, ArrayList<ServerBean> serverList, ArrayList<FunctionBean> funcList){
		if(mid==0){
			return true;
		}
		String schedulerResult="";
		boolean violation=false;
		for(int i=0;i<mid;i++){
			funcList.get(i).setPlacement(serverList.get(0).getServerId());
			schedulerResult+=funcList.get(i).getFunctionId()+":"+serverList.get(0).getServerId()+",";
			//System.out.println(funcList.get(i).getFunctionId()+" "+serverList.get(0).getServerId());
			float availRate=serverList.get(0).getAvailRate()-funcList.get(i).getUsageRate();
			serverList.get(0).setAvailRate(availRate);
			Collections.sort(serverList, new Comparator<ServerBean>() {
				@Override
				public int compare(ServerBean a, ServerBean b) {
					//descending order
					return (int)(b.getAvailRate()-a.getAvailRate());
				}
			});
		}
		/*
		 * calling the python module for prediction
		 */
		schedulerResult=schedulerResult.substring(0,schedulerResult.length()-1);
		//System.out.println(schedulerResult);
		try {
			String result=executeCommand("python model.py "+schedulerResult);
			if(result.equals("true"))
				violation=true;
		} catch (RemoteException e) {
			e.printStackTrace();
		}
		double math=Math.random();
		if(math>0.5){
			violation=true;
		}else{
			violation=false;
		}
		return violation;
	}


	private String executeCommand(String command) throws RemoteException {
		System.out.println(command);
		String result="";
		try {  
			String line = null,err;
			Process process = Runtime.getRuntime().exec(command); 
			BufferedReader br = new BufferedReader(new InputStreamReader(process.getErrorStream()));
			InputStreamReader isr = new InputStreamReader(process.getInputStream());
			LineNumberReader input = new LineNumberReader(isr); 
			while (((err = br.readLine()) != null||(line = input.readLine()) != null)) {
				if (err==null) {
					result+=line;
					System.out.println(line);
				} else {
					result+=err;
					System.out.println(err);
				}
			}  
		}catch (IOException e) {
			e.printStackTrace();
		}
		return result;
	}
	
	private String display(){
		StringBuilder result=new StringBuilder();
		System.out.print("-------------");
		for (int i=0;i<funcSize;i++){
			System.out.println();
			for (int j=0;j<serverNum;j++){
				System.out.print(placement[i][j]+" ");
			}
		}
		System.out.println();
		System.out.println("-------------");
		for (int i=0;i<funcSize;i++){
			for (int j=0;j<serverNum;j++){
				if(placement[i][j]==1){
					result.append(j).append(" ");
				}
			}
		}
		return result.toString();
	}
}

class FunctionBean {
	private String functionName;
	private float usageRate;
	private int functionId;
	private int placement;

	public FunctionBean(String functionName, float usageRate, int functionId, int placement) {
		super();
		this.functionName = functionName;
		this.usageRate = usageRate;
		this.functionId = functionId;
		this.placement = placement;
	}

	public String getFunctionName() {
		return functionName;
	}
	public float getUsageRate() {
		return usageRate;
	}
	public void setFunctionName(String functionName) {
		this.functionName = functionName;
	}
	public void setUsageRate(float usageRate) {
		this.usageRate = usageRate;
	}
	public int getFunctionId() {
		return functionId;
	}
	public int getPlacement() {
		return placement;
	}
	public void setFunctionId(int functionId) {
		this.functionId = functionId;
	}
	public void setPlacement(int placement) {
		this.placement = placement;
	}
	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append("FunctionBean [functionName=");
		builder.append(functionName);
		builder.append(", usageRate=");
		builder.append(usageRate);
		builder.append(", functionId=");
		builder.append(functionId);
		builder.append(", placement=");
		builder.append(placement);
		builder.append("]");
		return builder.toString();
	}
}
class ServerBean {
	private int serverId;
	private String serverName;
	private float availRate;

	public ServerBean(int serverId, String serverName, float availRate) {
		super();
		this.serverId = serverId;
		this.serverName = serverName;
		this.availRate = availRate;
		System.out.println("create new server id="+serverId);
	}

	public int getServerId() {
		return serverId;
	}
	public void setServerId(int serverId) {
		this.serverId = serverId;
	}
	public String getServerName() {
		return serverName;
	}
	public float getAvailRate() {
		return availRate;
	}
	public void setServerName(String serverName) {
		this.serverName = serverName;
	}
	public void setAvailRate(float availRate) {
		this.availRate = availRate;
	}

}

