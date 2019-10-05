# PBC 311 Infrastructure as a Service

## Prerequisites

* Ansible (tested with 2.8.5)
* Python (tested with 3.6.8)
* AWS CLI (tested with 1.16.253)
* AWS CLI Credentials export to environment

## Execution

```bash
export ANSIBLE_PYTHON_INTERPRETER=/usr/bin/python3
export ANSIBLE_HOST_KEY_CHECKING=False
export POSTGRES_PW=mydbpassword
ansible-playbook -i hosts/local.ini pbc311.yml
```
