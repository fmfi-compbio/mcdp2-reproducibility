# Scalability experiments: repeats vs ENCODE

## Prepare all data

```shell
bash prepare_all_data.sh
```

## ENCODE data

ENCODE peaks are here: [link](https://hgdownload.soe.ucsc.edu/hubs/GCA/009/914/755/GCA_009914755.4/bbi/GCA_009914755.4_T2T-CHM13v2.0.encode/peaks/)

## Repeats data from RepeatMasker

Repeats are here: [link](https://hgdownload.soe.ucsc.edu/hubs/GCA/009/914/755/GCA_009914755.4/bbi/GCA_009914755.4_T2T-CHM13v2.0.t2tRepeatMasker/chm13v2.0_rmsk.bb)

To determine repeat types:

```shell
cd repeat_data
cat repeats_all.bed | cut -f4 | sed -rn 's|.*\#([^/]*)(/.*)?|\1|p' | sort | uniq > repeat_types.txt
cd -
```

Repeat labels:

* DNA
* DNA?
* LINE
* Low_complexity
* LTR
* Satellite
* Simple_repeat
* SINE
* snRNA
* srpRNA
* tRNA
* rRNA
* scRNA
* RC
* Retroposon
* Unknown

Types:

- sine: `SINE` (SINE - Short Interspersed Nuclear Element)
- line: `LINE` (LINE - Long Interspersed Nuclear Element)
- ltr: `LTR` (LTR - Long Terminal Repeat)
- dna: `DNA` (DNA - DNA Transposon)
- simple: `Simple_repeat` (Simple - Single Nucleotide Stretches and Tandem Repeats)
- low-complexity: `Low_complexity` (Low_complexity - Low Complexity DNA)
- satellite: `Satellite`  (Satellite - Satellite Repeats)
- rna: `rRna|scRNA|snRNA|srpRNA|tRNA`  (RNA - RNA Repeats (including RNA, tRNA, rRNA, snRNA, scRNA, srpRNA))
- other: `RC|Retroposon`  (Other - Other Repeats (including class RC - Rolling Circle))
- unknown: `Unknown`  (Unknown - Unknown Classification)
