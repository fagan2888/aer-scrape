# Main Workflow - aer-scrape
# Contributors: @lachlandeer

import glob, os

# --- Importing Configuration Files --- #

configfile: "config.yaml"

# --- User defined Variables --- #

AER_WEB = "https://www.aeaweb.org/journals/aer/issues"

# --- Build Rules --- #
rule get_aer_article_lengths:
    input:
        dynamic(config["out_article_links"] + "{aer_links}.pickle")

rule aer_article_links:
    input:
        script = config["src_scraper"] + "get_article_links.py",
        links  = config["out_links"]   + "aer_issues.pickle"
    params:
        out_path = config["out_article_links"]
    output:
        links = dynamic(config["out_article_links"] + "{aer_links}.pickle")
    log:
        config["log"] + "aer_article_links.txt"
    shell:
        "python {input.script} \
            --issues {input.links} \
            --outpath {params.out_path} &> {log}"

rule aer_issues:
    input:
        script = config["src_scraper"] + "scrape_aer_issues.py"
    params:
        link = AER_WEB
    output:
        issue_links = config["out_links"] + "aer_issues.pickle"
    log:
        config["log"] + "aer_issues.txt"
    shell:
        "python {input.script} \
            --website {params.link} \
            --outData {output.issue_links} \
            > {log}"
