package main

// Input schema - allows snapshot.name_template since that's what we're converting from
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
		name_template: string // Required in input since we need it for conversion
	}
	changelog: {
		sort: string
		filters: {
			exclude: [...string]
		}
	}
}

// Validate input against the schema
input: #Config

// Transform input to output, preserving all fields except converting snapshot.name_template to version_template
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
