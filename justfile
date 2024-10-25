default:
    @just --list

format:
    prettier --config=.prettierrc.json --write .
    cue fmt *.cue
    just --unstable --fmt

process-project PROJECT:
    cue import --force --package=main --path='input:' {{ PROJECT }}/.goreleaser.yaml >{{ PROJECT }}/.goreleaser.cue
    cue eval schema.cue {{ PROJECT }}/.goreleaser.cue --expression=output --out=yaml --outfile={{ PROJECT }}/.goreleaser-updated.yaml
    diff --unified --ignore-all-space {{ PROJECT }}/.goreleaser.yaml {{ PROJECT }}/.goreleaser-updated.yaml || exit 0

clean-project PROJECT:
    rm -f {{ PROJECT }}/.goreleaser-updated.yaml
    rm -f {{ PROJECT }}/.goreleaser.cue

test: clean
    just process-project firejester
    just process-project openlace

clean:
    just clean-project firejester
    just clean-project openlace
