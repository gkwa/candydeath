set quiet := true

projects := "firejester openlace"

default:
    just --list

run: clean
    for project in {{ projects }}; do just process-project $project; done

format:
    prettier --config=.prettierrc.json --write .
    cue fmt *.cue
    just --unstable --fmt

process-project PROJECT:
    cue import --force --package=main --path='input:' {{ PROJECT }}/.goreleaser.yaml >{{ PROJECT }}/.goreleaser.cue
    cue eval --force schema.cue {{ PROJECT }}/.goreleaser.cue --expression=output --out=yaml --outfile={{ PROJECT }}/.goreleaser-updated.yaml
    cue eval --force schema.cue {{ PROJECT }}/.goreleaser.cue --concrete >/dev/null

clean-project PROJECT:
    rm -f {{ PROJECT }}/.goreleaser-updated.yaml
    rm -f {{ PROJECT }}/.goreleaser.cue

clean:
    for project in {{ projects }}; do just clean-project $project; done