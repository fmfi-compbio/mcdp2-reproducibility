#!/bin/bash

set -e

# downloading T2T ENCODE data

mkdir -p encode_data
cd encode_data
wget --tries=10 --retry-on-host-error --recursive --no-parent -nd 'https://hgdownload.soe.ucsc.edu/hubs/GCA/009/914/755/GCA_009914755.4/bbi/GCA_009914755.4_T2T-CHM13v2.0.encode/peaks/'
rm index.html* robots.txt

mv epithelial_cell_of_prostate_male.CTCF.chm13v2.0.bb2 epithelial_cell_of_prostate_male_2.CTCF.chm13v2.0.bb

temp_file='tmp_file.bed'
for f in *.bb; do
  target=$(echo $f | sed -r 's|.bb|.bed|')
  bigBedToBed "$f" "$temp_file"
  cut -f1,2,3 < "$temp_file" > "$target"
done
rm *.bb
rm "$temp_file"
rename 's/_/-/g' *.bed
cd -

# downloading RepeatMasker data

mkdir -p repeat_data
cd repeat_data
wget 'https://hgdownload.soe.ucsc.edu/hubs/GCA/009/914/755/GCA_009914755.4/bbi/GCA_009914755.4_T2T-CHM13v2.0.t2tRepeatMasker/chm13v2.0_rmsk.bb' -O repeats_all.bb
bigBedToBed repeats_all.bb repeats_all.bed
rm repeats_all.bb
cd -

cd repeat_data

cat repeats_all.bed | egrep $'^\w*\t\w*\t\w*[^#]*\#(SINE)' | python ../../../scripts/repeatmasker_to_bed.py > sine.bed
cat repeats_all.bed | egrep $'^\w*\t\w*\t\w*[^#]*\#(LINE)' | python ../../../scripts/repeatmasker_to_bed.py > line.bed
cat repeats_all.bed | egrep $'^\w*\t\w*\t\w*[^#]*\#(LTR)' | python ../../../scripts/repeatmasker_to_bed.py > ltr.bed
cat repeats_all.bed | egrep $'^\w*\t\w*\t\w*[^#]*\#(DNA)' | python ../../../scripts/repeatmasker_to_bed.py > dna.bed
cat repeats_all.bed | egrep $'^\w*\t\w*\t\w*[^#]*\#(Simple_repeat)' | python ../../../scripts/repeatmasker_to_bed.py > simple.bed
cat repeats_all.bed | egrep $'^\w*\t\w*\t\w*[^#]*\#(Low_complexity)' | python ../../../scripts/repeatmasker_to_bed.py > low-complexity.bed
cat repeats_all.bed | egrep $'^\w*\t\w*\t\w*[^#]*\#(Satellite)' | python ../../../scripts/repeatmasker_to_bed.py > satellite.bed
cat repeats_all.bed | egrep $'^\w*\t\w*\t\w*[^#]*\#(rRna|scRNA|snRNA|srpRNA|tRNA)' | python ../../../scripts/repeatmasker_to_bed.py > rna.bed
cat repeats_all.bed | egrep $'^\w*\t\w*\t\w*[^#]*\#(RC|Retroposon)' | python ../../../scripts/repeatmasker_to_bed.py > other.bed
cat repeats_all.bed | egrep $'^\w*\t\w*\t\w*[^#]*\#(Unknown)' | python ../../../scripts/repeatmasker_to_bed.py > unknown.bed

python repeatmasker_to_bed.py < repeats_all.bed > repeats_all_reduced.bed
cd -

# create `experiments.tsv`

target='experiments.tsv'

printf 'label\tsubset\tsuperset\tquery\tchromosome_lengths\n' > $target
for encode in encode_data/*.bed; do
  for repeat in repeat_data/*.bed; do
    echo $repeat | grep 'repeats_all' -q && continue
    echo "encode: $encode, repeat: $repeat"
    label_encode=$(basename $encode .bed)
    label_repeat=$(basename $repeat .bed)
    label="${label_repeat},${label_encode}"
    echo $label
    printf '%s\t%s\t%s\t%s\t%s\n' "$label" "$repeat" "repeat_data/repeats_all_reduced.bed" "$encode" "t2t_sizes.txt" >> $target
  done
done
