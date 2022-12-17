package scs.util.repository;

import java.io.FileWriter;
import java.io.IOException;

import scs.pojo.AppMetricesBean;
import scs.util.tools.DataFormats;
import scs.util.tools.DateFormats;

public class ResultRecord{
	DataFormats dataFormats=DataFormats.getInstance();
	DateFormats dateFormats=DateFormats.getInstance();

	public void record(){
		try {
			StringBuilder builder = new StringBuilder();
			for(String containerType:Repository.appFinalMetricsMap.keySet()){
				AppMetricesBean amBean=Repository.appFinalMetricsMap.get(containerType);
				FileWriter writer = new FileWriter(Repository.resultFilePath+"metrices_"+containerType+"_lcQps_"+Repository.lcQPS+"_"+dateFormats.getNowDate1()+".csv");
				builder.setLength(0);
				builder.append(amBean.getContextSwitch());
				builder.append(",");
				builder.append(amBean.getL1InstructionMPKI());
				builder.append(",");
				builder.append(amBean.getL1DataMPKI());
				builder.append(",");
				builder.append(amBean.getL2MPKI());
				builder.append(",");
				builder.append(amBean.getTlbDataMPKI());
				builder.append(",");
				builder.append(amBean.getTlbInstructionMPKI());
				builder.append(",");
				builder.append(amBean.getBranchMPKI());
				builder.append(",");
//				builder.append(amBean.getL3MPKI());
//				builder.append(",");
				builder.append(amBean.getMlp());
				builder.append(",");
				builder.append(amBean.getCpuUtilRate());
				builder.append(",");
				builder.append(amBean.getMemUtilRate());
				builder.append(",");
				builder.append(amBean.getMemBandwidth());
				builder.append(",");
				builder.append(amBean.getLlc());
				builder.append(",");
				builder.append(amBean.getIpc());
				builder.append(",");
				builder.append(amBean.getDiskIO());
				builder.append(",");
				builder.append(amBean.getNetworkIO());
				builder.append("\n");
				writer.write(builder.toString());
				writer.flush();
				writer.close();
			}
		} catch (IOException e1) {
			e1.printStackTrace();
		} 
	}
}
