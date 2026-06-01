.PHONY: release

release:
	./scripts/build-release.sh

# Cross-build example:
# GOOS=linux GOARCH=amd64 make release
