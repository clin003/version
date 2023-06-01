golang app开发版本信息

引用模块
```bash
go get gitee.com/lyhuilin/version
#或
go get github.com/clin003/version
```

使用
```golang
package main

import (
	"fmt"

	"gitee.com/lyhuilin/version"
)

func main() {
	fmt.Println(version.APPVersion())
	fmt.Println(version.APPVersionEx())
	fmt.Println(version.APPDevInfo())
}
```

Makefile中用脚本参数
```

APP_GIT		:= app_git
APP          := app
DOCKER_IMAGE := baicailin/app
GO_MOD		:= gitee.com/lyhuilin/version
VERSION      := $(shell git describe --tags --abbrev=0)
COMMIT       := $(shell git rev-parse --short HEAD)
BUILD_DATE   := `date +%FT%T%z`
COMMIT_ID	:= `git log |head -n 1| awk '{print $2;}'`
AUTHOR		:= `git log |head -n 3| grep Author| awk '{print $2;}'`
BRANCH_NAME	:= `git branch | awk '/\*/ { print $2; }'`
LD_FLAGS     := "-s -w -X '$(GO_MOD).Version=$(VERSION)' -X '$(GO_MOD).Commit=$(COMMIT)' -X '$(GO_MOD).BuildDate=$(BUILD_DATE)'  -X '$(GO_MOD).Author=$(AUTHOR)'  -X '$(GO_MOD).BranchName=$(BRANCH_NAME)'  -X '$(GO_MOD).CommitId=$(COMMIT_ID)' "
DEB_IMG_ARCH := amd64

```

docker中用编译参数

```

  -X 'gitee.com/lyhuilin/version.Version=`git describe --tags --abbrev=0`' -X 'gitee.com/lyhuilin/version.Commit=`git rev-parse --short HEAD`' -X 'gitee.com/lyhuilin/version.BuildDate=`date +%FT%T%z`'   -X 'gitee.com/lyhuilin/version.Author=`git log |head -n 3| grep Author| awk '{print $2;}'`'  -X 'gitee.com/lyhuilin/version.BranchName=`git branch | awk '/\*/ { print $2; }'`'  -X 'gitee.com/lyhuilin/version.CommitId=`git log |head -n 1| awk '{print $2;}'`' 


```