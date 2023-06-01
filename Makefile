all: build

APP				:= version
APP_GIT			:= version
DOCKER_IMAGE		:= baicailin/$(APP)
GO_MOD			:= gitee.com/lyhuilin/version
VERSION      	:= $(shell git describe --tags --abbrev=0)
COMMIT       	:= $(shell git rev-parse --short HEAD)
BUILD_DATE   	:= `date +%FT%T%z`
COMMIT_ID		:= `git log |head -n 1| awk '{print $2;}'`
AUTHOR			:= `git log |head -n 3| grep Author| awk '{print $2;}'`
BRANCH_NAME		:= `git branch | awk '/\*/ { print $2; }'`
LD_FLAGS     := "-s -w -X '$(GO_MOD).Version=$(VERSION)' -X '$(GO_MOD).Commit=$(COMMIT)' -X '$(GO_MOD).BuildDate=$(BUILD_DATE)'  -X '$(GO_MOD).Author=$(AUTHOR)'  -X '$(GO_MOD).BranchName=$(BRANCH_NAME)'  -X '$(GO_MOD).CommitId=$(COMMIT_ID)' "
DEB_IMG_ARCH 	:= amd64

init:
	mkdir -p ./cmd/$(APP)

linux-amd64:
	@ CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags=$(LD_FLAGS) -o ./cmd/$(APP)/$(APP)-$@  ./cmd/$(APP)/

darwin-amd64:
	@ CGO_ENABLED=0 CC=clang  GOOS=darwin GOARCH=amd64 go build -buildmode=pie -ldflags=$(LD_FLAGS) -o ./cmd/$(APP)/$(APP)-$@  ./cmd/$(APP)/

windows:
	@CGO_ENABLED=0 CC=x86_64-w64-mingw32-gcc GOOS=windows GOARCH=amd64 go build -buildmode=pie -ldflags=$(LD_FLAGS) -o ./cmd/$(APP)/$(APP).exe ./cmd/$(APP)/
windows-amd64:
	@CGO_ENABLED=0 CC=x86_64-w64-mingw32-gcc GOOS=windows GOARCH=amd64 go build -buildmode=pie -ldflags=$(LD_FLAGS) -o ./cmd/$(APP)/$(APP)-$@  ./cmd/$(APP)/

build: darwin-amd64 windows

run:
	@ LOG_DATE_TIME=1 DEBUG=1 RUN_MIGRATIONS=1 go run  -ldflags=$(LD_FLAGS) ./cmd/$(APP)/

clean:
	@ rm -f db.kns $(APP)-* $(APP) $(APP)*.rpm $(APP)*.deb ./cmd/$(APP)/$(APP)*.exe ./cmd/$(APP)/$(APP)-* ./cmd/$(APP)/*.kns  ./cmd/$(APP)/$(APP)
	@ rm -rf ./conf ./log ./upload

gitinit:	
	git init
	git add .
	git commit -m "第一次提交"
	git remote add gitee git@gitee.com:lyhuilin/$(APP_GIT).git
	git remote add github git@github.com:clin003/$(APP_GIT).git
	git push -u gitee main
	git push -u github main
	git tag "v0.0.1"
	git push --tags  -u gitee main
	git push --tags  -u github main
	
gitpush:	
	git push -u gitee main
	git push -u github main	
	git push --tags  -u gitee main
	git push --tags  -u github main
		
docker-image:
	curl -o cacert.pem https://curl.se/ca/cacert.pem
	docker build -t $(DOCKER_IMAGE):$(VERSION) -t $(DOCKER_IMAGE):latest -f Dockerfile .  && \
	docker push $(DOCKER_IMAGE):latest && \
	docker push $(DOCKER_IMAGE):$(VERSION)

docker-images:
	curl -o cacert.pem https://curl.se/ca/cacert.pem
	docker buildx build \
		--platform linux/amd64,linux/arm64,linux/arm/v7,linux/arm/v6 \
		--file Dockerfile \
		--tag $(DOCKER_IMAGE):latest \
		--tag $(DOCKER_IMAGE):$(VERSION) \
		--push .
