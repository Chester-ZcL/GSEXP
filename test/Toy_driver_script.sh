#!/bin/bash

tool_dir=$(dirname $(pwd))
dir=$(pwd)


eff_sample=300
upper=0.9
lower=0.1

${tool_dir}/GSP \
SigFreq \
-i ${dir}/Toy.vcf \
-o ${dir}/Toy_fixed_ref.txt \
-p ${dir}/Toy_pop_label.txt \
-t 2 \
--flip \
--var-type biSNP \
--min-total-sample ${eff_sample} \
--min-depth 10 \
--min-sample 3 \
--group-num 1 \
--tar-lower ${upper} --ref-upper ${lower} 

${tool_dir}/GSP \
SigLh \
-i ${dir}/Toy.vcf \
-o ${dir}/Toy_ml_ref.txt \
-p ${dir}/Toy_pop_label.txt \
-t 2 \
--flip \
--var-type biSNP \
--lh-thres -0.0031 \
--min-total-sample ${eff_sample} \
--min-depth 10 \
--min-sample 3 \
--group-num 1 \


${tool_dir}/Postprocessing ${dir} Toy_fixed_ref
${tool_dir}/Postprocessing ${dir} Toy_ml_ref

echo "====================================================="
echo "Number of signature discovered with the adaptive discovery module:"
echo $(($(wc -l<${dir}/Toy_ml_ref_filtered_300.txt)-1))
echo "-----------------------------------------------------"
echo "Number of signature discovered with the fixed-frequency based discovery module:"
echo $(($(wc -l<${dir}/Toy_fixed_ref_filtered_300.txt)-1))
echo "====================================================="

