from fabric.api import *
from fabric.contrib.files import exists
import time

vars = {
    # 'tomcat_version': '6.0.36'
}

env.forward_agent = True
env.key_filename = '~/.vagrant.d/insecure_private_key'


def dev():
    """ Use development server settings """
    servers = ['vagrant@127.0.0.1:2222']
    env.hosts = servers
    return servers


def prod():
    """ Use production server settings """
    servers = []
    env.hosts = servers
    return servers


def stage():
    """ Use staging server settings """
    servers = []
    env.hosts = servers
    return servers


def all():
    """ Use all servers """
    env.hosts = dev() + prod() + stage()


def init():
    """ Initialize the geoportal application """
    pass


def _set_environment():
    run('')


def run_test_fvs():
    run('/usr/local/bin/fvs /usr/local/apps/growth-yield-batch/testdata/7029_CT60/')


def run_test_batch():
    run('/usr/local/bin/fvsbatch --purge /usr/local/apps/growth-yield-batch/testdata/')


def restart_services():
    """
    Not sure exactly why but puppet leaves the services in a bad state
    celeryd is not chdired to /var/celery and celeryflower doesnt pick up tasks.
    This is a band-aid to "fix" the issue
    """
    run('sudo service celeryd restart && sudo supervisorctl stop all && sudo supervisorctl start all')
