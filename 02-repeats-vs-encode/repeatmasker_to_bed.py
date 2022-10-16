import fileinput
import logging

import argh


def repeatmasker_to_bed():
    logging.basicConfig(level=logging.INFO)
    CHROM_COLNUM = 0
    CHROMSTART_COLNUM = 1
    CHROMEND_COLNUM = 2
    THICKSTART_COLNUM = 6
    THICKEND_COLNUM = 7
    BLOCKCOUNT_COLNUM = 9
    BLOCKSIZES_COLNUM = 10
    BLOCKSTARTS_COLNUM = 11
    with fileinput.input() as f:
        for line in f:
            if len(line.strip()) == 0:
                continue
            row = line.strip().split("\t")
            chrom = row[CHROM_COLNUM]
            chromStart = int(row[CHROMSTART_COLNUM])
            chromEnd = int(row[CHROMEND_COLNUM])
            logging.debug(f"{chrom=}, {chromStart=}")
            if len(row) > BLOCKSTARTS_COLNUM:
                # parse the individual blocks into separate records
                blockstarts = list(map(int, row[BLOCKSTARTS_COLNUM].split(",")))
                blocksizes = list(map(int, row[BLOCKSIZES_COLNUM].split(",")))
                logging.debug(f"{blockstarts=}, {blocksizes=}")
                for start, size in zip(blockstarts, blocksizes):
                    if 0 <= start and size >=0 and start + size <= chromEnd - chromStart:
                        print(f"{chrom}\t{chromStart+start}\t{chromStart+start+size}")
            else:
                raise ValueError("No blocks are present!")


def main():
    argh.dispatch_command(repeatmasker_to_bed)


if __name__ == "__main__":
    main()
