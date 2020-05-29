SHELL=/bin/bash
HEROKU=$(shell cat .heroku 2>/dev/null)

heroku-setup:
ifeq ($(HEROKU),)
	echo "Creating Heroku app & saving name to .heroku..."
	heroku create -t stripe-sa --json | jq .name | sed 's/\"//g' > .heroku
else
	echo "Adding git remote for $(HEROKU)..."
	heroku git:remote -a $(HEROKU)
endif

deploy:
ifeq ($(HEROKU),)
	echo "Run 'make heroku-setup' first."
else
	git push heroku master
endif

open:
ifeq ($(HEROKU),)
	echo "Run 'make heroku-setup' first."
else
	heroku open -a $(HEROKU)
endif
