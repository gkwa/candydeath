package main

#Config: {
	before: {
		hooks: [...string]
	}
	builds: [...{
		env?: [...string]
		goos?: [...string]
		main?: string
		goarch?: [...string]
		binary?: string
		id?:     string
	}]
	archives: [...{
		format?:        string
		name_template?: string
		format_overrides?: [...{
			goos?:   string
			format?: string
		}]
	}]
	checksum: {
		name_template: string
	}
	snapshot: {
		name_template: string
	}
	changelog: {
		sort: string
		filters: {
			exclude: [...string]
		}
	}
}

input: #Config

output: {
	before:   input.before
	builds:   input.builds
	archives: input.archives
	checksum: input.checksum
	snapshot: {
		version_template: input.snapshot.name_template
	}
	changelog: input.changelog
}
