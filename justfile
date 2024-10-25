set quiet := true

default:
    just --list

run: (process "firejester") (process "openlace")

format:
    prettier --config=.prettierrc.json --write .
    cue fmt *.cue
    just --unstable --fmt

process PROJECT: clean
    cue import --force --package=main --path='input:' {{ PROJECT }}/.goreleaser.yaml >{{ PROJECT }}/.goreleaser.cue
    cue eval --force schema.cue {{ PROJECT }}/.goreleaser.cue --expression=output --out=yaml --outfile={{ PROJECT }}/.goreleaser-updated.yaml
    cue eval --force schema.cue {{ PROJECT }}/.goreleaser.cue --concrete >/dev/null

clean:
    rm -f */.goreleaser.cue
    rm -f */.goreleaser-updated.yaml
