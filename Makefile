.PHONY: deploy
deploy:
	gcloud beta run deploy random \
		--source=${PWD} \
		--project=pubcrawler-11f6c \
		--platform managed \
		--allow-unauthenticated

.PHONY: publish
publish:
	cd app && \
	flutter pub global run peanut && \
	git push origin --set-upstream gh-pages