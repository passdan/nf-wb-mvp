#!/usr/bin/env nextflow

process FASTQC {
    publishDir "results/fastqc", mode: "copy"

    input:
        tuple val(ID), path(reads)

    output:
        path("${ID}_fastqc")

    script:
    """
    mkdir ${ID}_fastqc
    fastqc ${reads} -o ${ID}_fastqc
    """
}

process FASTP {
    input:
     tuple val(ID), path(reads)

    output:
        tuple val(ID), path("${ID}_trim_{R1,R2}.fastq.gz")

    script:
    """
    fastp --in1 ${reads[0]} --in2 ${reads[1]} \
          --out1 ${ID}_trim_R1.fastq.gz --out2 ${ID}_trim_R2.fastq.gz
    """
}

process SALMON_INDEX {
    debug true

    input:
        path(transcriptome)

    output:
        path("index")

    script:
    """
    salmon index \
            --threads $task.cpus \
            -t ${transcriptome} \
            -i index
    """
}

process SALMON_QUANT {
    publishDir "results/alignment", mode: "copy"
    input:
        each index
        tuple val(ID), path(reads)

    output:
        path("${ID}_salmon")

    script:
    """
    salmon quant \
            --threads $task.cpus \
            --libType=U \
            -i ${index} \
            -1 ${reads[0]} -2 ${reads[1]} \
            -o ${ID}_salmon
    """
}

workflow {
    params.input = "${baseDir}/data/reads/*{1,2}.fq.gz"
    params.transcriptome = "${baseDir}/data/refs/Saccharomyces_cerevisiae.R64-1-1.cdna.all.fa"

    log.info """\
        T E S T   W O R K B E N C H   P I P E L I N E
        ===================================
        transcriptome: ${params.transcriptome}
        reads        : ${params.input}
        """

    reads_ch = channel.fromFilePairs(params.input, checkIfExists: true)
    transcriptome_ch = channel.fromPath(params.transcriptome, checkIfExists: true)

    // QC stages
    FASTQC(reads_ch)
    trimmed_reads = FASTP(reads_ch)

    // alignment stages
    index = SALMON_INDEX(transcriptome_ch)
    SALMON_QUANT(index, trimmed_reads)
    
}
