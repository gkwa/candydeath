set quiet := true

projects := "firejester openlace"

default:
    just --list

run: clean process-all

process-all:
    for project in {{ projects }}; do \
        cue import --force --package=main --path='input:' $project/.goreleaser.yaml >$project/.goreleaser.cue && \
        cue eval --force schema.cue $project/.goreleaser.cue --expression=output --out=yaml --outfile=$project/.goreleaser-updated.yaml && \
        cue eval --force schema.cue $project/.goreleaser.cue --concrete >/dev/null; \
    done

clean:
    for project in {{ projects }}; do \
        rm -f $project/.goreleaser-updated.yaml && \
        rm -f $project/.goreleaser.cue; \
    done