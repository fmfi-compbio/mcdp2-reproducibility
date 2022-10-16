# Telomere-associated repeats (TAR) vs histone modifications

## Getting TARs

```shell
wget 'https://hgdownload.soe.ucsc.edu/hubs/GCA/009/914/755/GCA_009914755.4/bbi/GCA_009914755.4_T2T-CHM13v2.0.t2tRepeatMasker/chm13v2.0_rmsk.bb' -O all_repeats.bb 
bigBedToBed all_repeats.bb all_repeats.bed
egrep 'TAR1' all_repeats.bed > tars.bed
cat tars.bed | python ../02-repeats-vs-encode/repeatmasker_to_bed.py > tars_simple.bed
```

### Splitting TARs into telomeric and non-telomeric TARs

Telomeric TAR will be defined as an interval that touches the first or last 20kb of a chrosomome.

```shell
python split_tars.py tars_simple.bed ../02-repeats-vs-encode/t2t_sizes.txt 20000 > tars_simple_nontelo.bed
```


## Getting histone modifications

Using `../02-repeats-vs-encode/` data.

