image_name=my-container
image_tag=latest
git_repo_name=my-first-cicd

test_result="Hello first docker project !!!"

all: build run

build:
	@docker build -t $(image_name):$(image_tag) .

run:
	@docker run -it --rm $(image_name):$(image_tag)

tests:
	@sh runtests.sh $(image_name):$(image_tag)
	

push:
	@docker push $(image_name):$(image_tag)
tag_latest:
	@docker tag $(image_name):$(image_tag) $(image_name):latest
push_latest:
	@docker push $(image_name):latest


git.init:
	@git init .
	@git remote add origin ssh://git-codecommit.us-east-1.amazonaws.com/v1/repos/$(git_repo_name)


git.add-and-commit:
	@git add -A
	@git commit -m "commit $(shell date +"%T")"

git.push:
	@GIT_SSH_COMMAND="ssh -F $(PWD)/.ssh_config" git push --set-upstream origin master

git.clean:
	@rm -Rf .git || true


aws.upload-ssh-key:
	@sh ../upload-ssh-public-key.sh
