
.PHONY: deps

deps:
	pip install -q -r requirements.txt

# Run ansible in local mode so that it runs the emr module in the
# local python which is likely necessary since that is where the
# proper version of boto is installed.
provision.emr: deps
	ansible-playbook --connection local -i 'localhost,' batch/provision.yml -e "$$EXTRA_VARS"

terminate.emr: deps
	ansible-playbook --connection local -i 'localhost,' batch/terminate.yml -e "$$EXTRA_VARS"

inventory.refresh:
	./plugins/ec2.py --refresh-cache 2>/dev/null >/dev/null

users.update: deps inventory.refresh
	ansible-playbook -u "$$REMOTE_USER" infrastructure/users.yml -e "$$EXTRA_VARS"
