import argh


def split_tars(tars_filename, chrom_filename, distance):
    """Output only those lines in `tars_filename` that are further than `distance` from the chromosome ends in file
    `chrom_filename`. """
    distance = int(distance)
    with open(chrom_filename) as f:
        lengths = dict()
        for line in f:
            if len(line.strip()) > 0:
                row = line.strip().split("\t")
                lengths[row[0]] = int(row[1])

    with open(tars_filename) as f:
        for line in f:
            if len(line.strip()) > 0:
                row = line.strip().split("\t")
                chr, begin, end = row[0], int(row[1]), int(row[2])
                if begin > distance and end < lengths[chr] - distance:
                    print(line.strip())


def main():
    argh.dispatch_command(split_tars)


if __name__ == "__main__":
    main()

