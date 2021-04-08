faas build -f DeathstarBench/compose-and-upload-sdc.yml
faas deploy -f DeathstarBench/compose-and-upload-sdc.yml

faas build -f DeathstarBench/compose-post-sdc.yml
faas deploy -f DeathstarBench/compose-post-sdc.yml

faas build -f DeathstarBench/db-op.yml
faas deploy -f DeathstarBench/db-op.yml

faas build -f DeathstarBench/follow-user-sdc.yml
faas deploy -f DeathstarBench/follow-user-sdc.yml

faas build -f DeathstarBench/get-followers-sdc.yml
faas deploy -f DeathstarBench/get-followers-sdc.yml

faas build -f DeathstarBench/get-user-id-sdc.yml
faas deploy -f DeathstarBench/get-user-id-sdc.yml

faas build -f DeathstarBench/login-sdc.yml
faas deploy -f DeathstarBench/login-sdc.yml

faas build -f DeathstarBench/namespaces.yml
faas deploy -f DeathstarBench/namespaces.yml

faas build -f DeathstarBench/post-storage-sdc.yml
faas deploy -f DeathstarBench/post-storage-sdc.yml

faas build -f DeathstarBench/read-home-timeline-sdc.yml
faas deploy -f DeathstarBench/read-home-timeline-sdc.yml

faas build -f DeathstarBench/read-user-timeline-sdc.yml
faas deploy -f DeathstarBench/read-user-timeline-sdc.yml

faas build -f DeathstarBench/unfollow-user-sdc.yml
faas deploy -f DeathstarBench/unfollow-user-sdc.yml

faas build -f DeathstarBench/upload-creator-sdc.yml
faas deploy -f DeathstarBench/upload-creator-sdc.yml

faas build -f DeathstarBench/upload-home-timeline-sdc.yml
faas deploy -f DeathstarBench/upload-home-timeline-sdc.yml

faas build -f DeathstarBench/upload-media-sdc.yml
faas deploy -f DeathstarBench/upload-media-sdc.yml

faas build -f DeathstarBench/upload-text-sdc.yml
faas deploy -f DeathstarBench/upload-text-sdc.yml

faas build -f DeathstarBench/upload-unique-id-sdc.yml
faas deploy -f DeathstarBench/upload-unique-id-sdc.yml

faas build -f DeathstarBench/upload-urls-sdc.yml
faas deploy -f DeathstarBench/upload-urls-sdc.yml

faas build -f DeathstarBench/upload-user-mentions-sdc.yml
faas deploy -f DeathstarBench/upload-user-mentions-sdc.yml

faas build -f DeathstarBench/upload-user-timeline-sdc.yml
faas deploy -f DeathstarBench/upload-user-timeline-sdc.yml

faas build -f DeathstarBench/workflow-sdc.yml
faas deploy -f DeathstarBench/workflow-sdc.yml

faas build -f FunctionBench/cnnimageclassification.yml
faas deploy -f FunctionBench/cnnimageclassification.yml

faas build -f FunctionBench/dd.yml
faas deploy -f FunctionBench/dd.yml

faas build -f FunctionBench/featureextract.yml
faas deploy -f FunctionBench/featureextract.yml

faas build -f FunctionBench/featuregeneration.yml
faas deploy -f FunctionBench/featuregeneration.yml

faas build -f FunctionBench/featurereduce.yml
faas deploy -f FunctionBench/featurereduce.yml

faas build -f FunctionBench/floatoperation.yml
faas deploy -f FunctionBench/floatoperation.yml

faas build -f FunctionBench/imageprocessing.yml
faas deploy -f FunctionBench/imageprocessing.yml

faas build -f FunctionBench/iperf3.yml
faas deploy -f FunctionBench/iperf3.yml

faas build -f FunctionBench/jsondumpsloads.yml
faas deploy -f FunctionBench/jsondumpsloads.yml

faas build -f FunctionBench/linpack.yml
faas deploy -f FunctionBench/linpack.yml

faas build -f FunctionBench/matmul.yml
faas deploy -f FunctionBench/matmul.yml

faas build -f FunctionBench/modeltraining.yml
faas deploy -f FunctionBench/modeltraining.yml

faas build -f FunctionBench/rnngeneratecharacter.yml
faas deploy -f FunctionBench/rnngeneratecharacter.yml

faas build -f FunctionBench/videoprocessing.yml
faas deploy -f FunctionBench/videoprocessing.yml

faas build -f ServerlessBench/case1-alu.yml
faas deploy -f ServerlessBench/case1-alu.yml

faas build -f ServerlessBench/case1-key-downloader.yml
faas deploy -f ServerlessBench/case1-key-downloader.yml

faas build -f ServerlessBench/case1-together.yml
faas deploy -f ServerlessBench/case1-together.yml

faas build -f ServerlessBench/case3-chained.yml
faas deploy -f ServerlessBench/case3-chained.yml

faas build -f ServerlessBench/case3-nested.yml
faas deploy -f ServerlessBench/case3-nested.yml

faas build -f ServerlessBench/case4-extract-image-metadata.yml
faas deploy -f ServerlessBench/case4-extract-image-metadata.yml

faas build -f ServerlessBench/case4-handler.yml
faas deploy -f ServerlessBench/case4-handler.yml

faas build -f ServerlessBench/case4-store-image-metadata.yml
faas deploy -f ServerlessBench/case4-store-image-metadata.yml

faas build -f ServerlessBench/case4-thumbnail.yml
faas deploy -f ServerlessBench/case4-thumbnail.yml

faas build -f ServerlessBench/case4-transform-metadata.yml
faas deploy -f ServerlessBench/case4-transform-metadata.yml

faas build -f ServerlessBench/case4-wage-analysis-merit-percent.yml
faas deploy -f ServerlessBench/case4-wage-analysis-merit-percent.yml

faas build -f ServerlessBench/case4-wage-analysis-realpay.yml
faas deploy -f ServerlessBench/case4-wage-analysis-realpay.yml

faas build -f ServerlessBench/case4-wage-analysis-result.yml
faas deploy -f ServerlessBench/case4-wage-analysis-result.yml

faas build -f ServerlessBench/case4-wage-analysis-total.yml
faas deploy -f ServerlessBench/case4-wage-analysis-total.yml

faas build -f ServerlessBench/case4-wage-db-writer.yml
faas deploy -f ServerlessBench/case4-wage-db-writer.yml

faas build -f ServerlessBench/case4-wage-fillup.yml
faas deploy -f ServerlessBench/case4-wage-fillup.yml

faas build -f ServerlessBench/case4-wage-format.yml
faas deploy -f ServerlessBench/case4-wage-format.yml

faas build -f ServerlessBench/case4-wage-insert.yml
faas deploy -f ServerlessBench/case4-wage-insert.yml

faas build -f ServerlessBench/case5-head-bigparam.yml
faas deploy -f ServerlessBench/case5-head-bigparam.yml

faas build -f ServerlessBench/case5-head.yml
faas deploy -f ServerlessBench/case5-head.yml

faas build -f ServerlessBench/case5-tail-bigparam.yml
faas deploy -f ServerlessBench/case5-tail-bigparam.yml

faas build -f ServerlessBench/case5-tail.yml
faas deploy -f ServerlessBench/case5-tail.yml

faas build -f TPC-W/cnnimageclassification.yml
faas deploy -f TPC-W/cnnimageclassification.yml

faas build -f TPC-W/dd.yml
faas deploy -f TPC-W/dd.yml

faas build -f TPC-W/featureextract.yml
faas deploy -f TPC-W/featureextract.yml

faas build -f TPC-W/featuregeneration.yml
faas deploy -f TPC-W/featuregeneration.yml

faas build -f TPC-W/featurereduce.yml
faas deploy -f TPC-W/featurereduce.yml

faas build -f TPC-W/floatoperation.yml
faas deploy -f TPC-W/floatoperation.yml

faas build -f TPC-W/imageprocessing.yml
faas deploy -f TPC-W/imageprocessing.yml

faas build -f TPC-W/iperf3.yml
faas deploy -f TPC-W/iperf3.yml

faas build -f TPC-W/jsondumpsloads.yml
faas deploy -f TPC-W/jsondumpsloads.yml

faas build -f TPC-W/linpack.yml
faas deploy -f TPC-W/linpack.yml

faas build -f TPC-W/matmul.yml
faas deploy -f TPC-W/matmul.yml

faas build -f TPC-W/modeltraining.yml
faas deploy -f TPC-W/modeltraining.yml

faas build -f TPC-W/rnngeneratecharacter.yml
faas deploy -f TPC-W/rnngeneratecharacter.yml

faas build -f TPC-W/videoprocessing.yml
faas deploy -f TPC-W/videoprocessing.yml