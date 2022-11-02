rule antares_gene_quantif:
    input:
        "out/r/tidy_featureCounts/subread/featureCounts_-O_-t_exon_-g_merge_gene_id_name_gtf-GRCm38-merge-attr-retrieve-ensembl_bam-GRCm38-SRP057486_raw.tsv",
        "out/r/tidy_featureCounts/subread/featureCounts_-O_-t_exon_-g_merge_gene_id_name_gtf-Rnor6-merge-attr-retrieve-ensembl_bam-Rnor6-SRP056481_raw.tsv",
        "out/r/tidy_featureCounts/subread/featureCounts_-O_-t_exon_-g_merge_gene_id_name_gtf-Rnor6-merge-attr-retrieve-ensembl_bam-Rnor6-SRP131063_raw.tsv",
        "out/r/tidy_featureCounts/subread/featureCounts_-O_-t_exon_-g_merge_gene_id_name_gtf-Rnor6-merge-attr-retrieve-ensembl_bam-Rnor6-SRP084288_raw.tsv",


rule antares_transcript_quantif_A:
    """
    Aim:
        Test Salmon on RNA-Seq datasets of interest.
        Note '-l A' is used to check the strandedeness of the library.
        TODO: Consistency has to be checked for all samples in each dataset
        TODO: adjust GRCh38 into Ratnor or GRCm38
    """
    input:
        GRCm38_SRP057486 = expand("out/salmon/quant_fastq_se_-l_A_--validateMappings_--numGibbsSamples_20_--gcBias_salmon-index-GRCm38-ensembl-r102/sickle/se_-t_sanger_-q_20/sra-tools/fastq-dump_se/{srr}/quant.sf", srr=list(pandas.read_excel('../mw-antares/out/py/retrieve_sra_metadata/SRP057486.xlsx', index_col=0).accession)),
        Rnor6_SRP056481 = expand("out/salmon/quant_fastq_se_-l_A_--validateMappings_--numGibbsSamples_20_--gcBias_salmon-index-Rnor6-ensembl-r102/sickle/se_-t_sanger_-q_20/sra-tools/fastq-dump_se/{srr}/quant.sf", srr=list(pandas.read_excel('../mw-antares/out/py/retrieve_sra_metadata/SRP056481.xlsx', index_col=0).accession)),
        Rnor6_SRP131063 = expand("out/salmon/quant_fastq_pe_-l_A_--validateMappings_--numGibbsSamples_20_--gcBias_salmon-index-Rnor6-ensembl-r102/sickle/pe_-t_sanger_-q_20/sra-tools/fastq-dump_pe/{srr}/quant.sf", srr=list(pandas.read_excel('../mw-antares/out/py/retrieve_sra_metadata/SRP131063.xlsx', index_col=0).accession)),
        Rnor6_SRP084288 = expand("out/salmon/quant_fastq_pe_-l_A_--validateMappings_--numGibbsSamples_20_--gcBias_salmon-index-Rnor6-ensembl-r102/sickle/pe_-t_sanger_-q_20/sra-tools/fastq-dump_pe/{srr}/quant.sf", srr=list(pandas.read_excel('../mw-antares/out/py/retrieve_sra_metadata/SRP084288.xlsx', index_col=0).accession))


rule retrieve_cel:
    shell:
        """
        wget out/wget/https://www.ncbi.nlm.nih.gov/geo/download/?acc=GSE56028&format=file

        """
