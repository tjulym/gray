//package scs.util.test;
//
//import java.io.File;
//import java.io.FileWriter;
//import java.io.IOException;
//import java.util.ArrayList;
//import java.util.HashMap;
//import java.util.List;
//import java.util.Map;
//
//import org.omg.CORBA.SystemException;
//import org.omg.CosNaming.NamingContextExtPackage.StringNameHelper;
//
//import scs.pojo.TwoTuple;
//import scs.util.repository.Repository;
//import scs.util.tools.FileOperation;
// 
//
//public class Test {
//
//	public static void main(String[] args) throws IOException {
//		System.out.println("sdfea".split("#").length);
//	}
////		Map<String,String> map=new HashMap<String,String>();
////		//FileWriter writer=new FileWriter("C:\\Users\\DELL\\Desktop\\school.txt");
////		List<String> schoolList=new FileOperation().readStringFile("C:\\Users\\DELL\\Desktop\\school.txt");
////		String flag="双一流";
////		// TODO Auto-generated method stub
////		FileWriter writer=new FileWriter("C:\\Users\\DELL\\Desktop\\benShuo.csv");
////		List<String> list=new FileOperation().readStringFile("C:\\Users\\DELL\\Desktop\\test1.csv");
////		for(String item:list){
////			flag="非双一流";
////			String[] splits=item.split(",");
////			if((splits[0].trim().equals(splits[1].trim()))&&!(splits[2].trim().equals(splits[0].trim()))){
////				System.out.println(item);
////				for(String school:schoolList){
////					if(school.contains(splits[0])){
////						flag="双一流";
////						break;
////					}
////				}
////				writer.write(item+",1,"+flag+"\n");
////			}
////			
////			 
////		}
////		for(String item:list){
////			flag="非双一流";
////			String[] splits=item.split(",");
////			if((splits[0].trim().equals(splits[2].trim()))&&!(splits[1].trim().equals(splits[0].trim()))){
////				System.out.println(item);
////				for(String school:schoolList){
////					if(school.contains(splits[0])){
////						flag="双一流";
////						break;
////					}
////				}
////				writer.write(item+",2,"+flag+"\n");
////			}
////			 
////		}
////		for(String item:list){
////			flag="非双一流";
////			String[] splits=item.split(",");
////			if((splits[1].trim().equals(splits[2].trim()))&&!(splits[1].trim().equals(splits[0].trim()))){
////				System.out.println(item);
////				for(String school:schoolList){
////					if(school.contains(splits[0])){
////						flag="双一流";
////						break;
////					}
////				}
////				writer.write(item+",3,"+flag+"\n");
////			}
////			 
////		}
////		for(String item:list){
////			flag="非双一流";
////			String[] splits=item.split(",");
////			if((splits[0].trim().equals(splits[2].trim()))&&(splits[1].trim().equals(splits[0].trim()))){
////				System.out.println(item);
////				for(String school:schoolList){
////					if(school.contains(splits[0])){
////						flag="双一流";
////						break;
////					}
////				}
////				writer.write(item+",4,"+flag+"\n");
////			}
////			 
////		}
////		for(String item:list){
////			flag="非双一流";
////			String[] splits=item.split(",");
////			if((!splits[0].trim().equals(splits[2].trim()))&&(!splits[1].trim().equals(splits[0].trim()))&&(!splits[1].trim().equals(splits[2].trim()))){
////				System.out.println(item);
////				for(String school:schoolList){
////					if(school.contains(splits[0])){
////						flag="双一流";
////						break;
////					}
////				}
////				writer.write(item+",5,"+flag+"\n");
////			}
////			 
////		}
////		writer.flush();
////		writer.close();
////	}
//		
//		
////		int systemSocketNum=2;
////		int systemSocketCpuCoreNum=20;
////		int systemLogicalThreadPercore=2;
////		
////			for(int socketIndex=0;socketIndex<systemSocketNum;socketIndex++){
////				ArrayList<TwoTuple<Integer, Integer>> socketCpuList=new ArrayList<TwoTuple<Integer,Integer>>();
////				for(int cpuCoreIndex=0;cpuCoreIndex<systemSocketCpuCoreNum;cpuCoreIndex++){
////					socketCpuList.add(new TwoTuple<Integer, Integer>(cpuCoreIndex, cpuCoreIndex+systemSocketCpuCoreNum*systemLogicalThreadPercore));
////					System.out.println(cpuCoreIndex+socketIndex*systemSocketCpuCoreNum+" "+ (cpuCoreIndex+systemSocketCpuCoreNum*systemLogicalThreadPercore+socketIndex*systemSocketCpuCoreNum));
////				}
////			}
//			
//			
//	
//
//}
