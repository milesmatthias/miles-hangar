SHELL=/bin/bash
HEROKU=$(shell cat .heroku 2>/dev/null)

heroku-sync:
ifeq ($(HEROKU),)
	echo "Creating Heroku app & saving name to .heroku..."
	heroku create --json | jq .name | sed 's/\"//g' > .heroku
else
	echo "Adding git remote for $(HEROKU)..."
	heroku git:remote -a $(HEROKU)
endif

deploy:
	git push heroku master
