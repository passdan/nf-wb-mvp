# Nextflow on Workbench - Minimal working example
Minimal pipeline test for nextflow on workbench with docker/singularity/apptainer containers.

## Pipeline:
- QC with `fastqc` on 9x paired-end yeast samples (3x 3 replicates)
- Clean data with `fastp` trimming
- Create `salmon` index
- Quantify trimmed reads against `salmon` index

## Prepare for processing
1. Create artifact registry for your workbench/GCP project
2. Upload docker containers to Artifact Registry
3. Run this pipleine with:

```
nextflow run main.nf -profile workbench
```