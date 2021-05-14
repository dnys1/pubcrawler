.PHONY: deploy
deploy:
	gcloud beta run deploy random \
		--source=$PWD \
		--project=pubcrawler-11f6c \
		--platform managed \
		--allow-unauthenticated