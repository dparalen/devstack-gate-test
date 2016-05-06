# This is used to do various updates after the /opt/stack/old and /opt/stack/new directories have been setup
# This file will be sourced in
#
# This is setup for stable/mitaka

errexit=$(set +o | grep errexit)
set -o errexit
xtrace=$(set +o | grep xtrace)
set -o xtrace

echo "****: Fetching the grenade patch"
# https://review.openstack.org/#/c/241018/ Support TEMPEST_REGEX environment variable
(cd /opt/stack/new/grenade; git fetch https://review.openstack.org/openstack-dev/grenade refs/changes/18/241018/4 && git cherry-pick FETCH_HEAD)
(cd /opt/stack/old/grenade; git fetch https://review.openstack.org/openstack-dev/grenade refs/changes/18/241018/4 && git cherry-pick FETCH_HEAD)

echo "***: Fetching the devstack-gate TEMPEST_REGEX patch"
# https://review.openstack.org/#/c/241044/ Send DEVSTACK_GATE_TEMPEST_REGEX to grenade jobs
(cd /opt/stack/new/devstack-gate; git fetch https://review.openstack.org/openstack-infra/devstack-gate refs/changes/44/241044/3 && git cherry-pick FETCH_HEAD)

echo "***: Fetching: Archive Ironic VM nodes console logs for 'old' patch"
# https://review.openstack.org/#/c/290171/ Archive Ironic VM nodes console logs for 'old'
(cd /opt/stack/new/devstack-gate; git fetch https://review.openstack.org/openstack-infra/devstack-gate refs/changes/71/290171/1 && git cherry-pick FETCH_HEAD)
(cd /home/jenkins/workspace/testing/devstack-gate; git fetch https://review.openstack.org/openstack-infra/devstack-gate refs/changes/71/290171/1 && git cherry-pick FETCH_HEAD)

echo "***: Fetching the Ironic disable cleaning patch"
# https://review.openstack.org/#/c/309115/
(cd /opt/stack/old/ironic; git fetch https://git.openstack.org/openstack/ironic refs/changes/15/309115/1 && git cherry-pick FETCH_HEAD)

echo "***: Fix ovs-vsctl executed in worlddump.py failed issue"
# https://review.openstack.org/#/c/311055/
(cd /opt/stack/new/devstack; git fetch https://review.openstack.org/openstack-dev/devstack refs/changes/55/311055/1 && git cherry-pick FETCH_HEAD)

echo "***: Export the 'short_source' function"
# https://review.openstack.org/#/c/313132/
(cd /opt/stack/old/devstack; git fetch https://git.openstack.org/openstack-dev/devstack refs/changes/32/313132/5 && git cherry-pick FETCH_HEAD)
(cd /opt/stack/new/devstack; git fetch https://git.openstack.org/openstack-dev/devstack refs/changes/32/313132/5 && git cherry-pick FETCH_HEAD)

echo "***: Stop using git:// and be nice to people behind proxy servers"
# https://review.openstack.org/#/c/313123/
(cd /opt/stack/old/ironic-python-agent; git fetch https://git.openstack.org/openstack/ironic-python-agent refs/changes/23/313123/1 && git cherry-pick FETCH_HEAD)

echo "***: Allow creating floating ip address with Neutron enabled"
# https://review.openstack.org/#/c/313600/
(cd /opt/stack/new/grenade; git fetch https://git.openstack.org/openstack-dev/grenade refs/changes/00/313600/1 && git cherry-pick FETCH_HEAD)
(cd /opt/stack/old/grenade; git fetch https://git.openstack.org/openstack-dev/grenade refs/changes/00/313600/1 && git cherry-pick FETCH_HEAD)


# Prep the pip cache for the stack user, which is owned by the 'jenkins' user at this point
if [ -d /opt/git/pip-cache/ ]
then
    ARGS_RSYNC="-rlptDH"
    sudo -u jenkins mkdir -p ~stack/.cache/pip/
    sudo -u jenkins rsync ${ARGS_RSYNC} --exclude=selfcheck.json /opt/git/pip-cache/ ~stack/.cache/pip/
fi

# old stable/liberty patches
# echo "***: Fetching the proxy server patch for stable/liberty"
# # https://review.openstack.org/283375 Add support for proxy servers during image build
# (cd /opt/stack/old/ironic-python-agent; git fetch https://review.openstack.org/openstack/ironic-python-agent refs/changes/75/283375/1 && git cherry-pick FETCH_HEAD)

# echo "***: Keep the console logs for all boots"
# # https://review.openstack.org/#/c/293748/ Keep the console logs for all boots
# (cd /opt/stack/old/devstack; git fetch https://review.openstack.org/openstack-dev/devstack refs/changes/48/293748/2 && git cherry-pick FETCH_HEAD)

$xtrace
$errexit
