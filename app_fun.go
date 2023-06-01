package version

import (
	"fmt"
	"strings"
)

func APPVersion() string {
	return Version
}
func APPVersionEx() string {
	return fmt.Sprintf("%s(%s) %s", Version, BuildDate, Commit)
}
func APPDevInfo() string {
	return APPVersionEx() + "\n" + APPBuildInfo()
}

func APPBuildInfo() string {
	return fmt.Sprintf("%s %s %s", CommitId, Author, BranchName)
}

func IsDev() bool {
	return strings.EqualFold(Version, "dev")
}
