# Nextflow on Workbench - Minimal working example
Minimal pipeline run for nextflow on workbench with pulled dockerhub containers and google-batch executor.

## Pipeline:
- QC with `fastqc` on 9x paired-end yeast samples (3x 3 replicates)
- Clean data with `fastp` trimming
- Create `salmon` index
- Quantify trimmed reads against `salmon` index

## Prepare for processing
1. Modify the `nextflow.config` file with your bucket name and project IDs
2. Run this pipleine with:

```
wb nextflow run main.nf -profile workbench
```
N.b. Test data is set in the main.nf pipeline parameters

## Outputs
The `results` folder should contain:
```
results
-- alignment
-- fastqc
-- fastp-logs
