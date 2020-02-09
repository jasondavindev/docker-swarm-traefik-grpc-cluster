export CLUSTER_DNS=domain.local
export CLUSTER_NETWORK=cluster_network
export CLUSTER_WORKERS=1

function create_machines {
  docker-machine create -d virtualbox manager
  create_workers
  docker-machine ls
}

function create_workers {
  for i in $(seq 1 $CLUSTER_WORKERS); do
    docker-machine create -d virtualbox "machine${i}"
  done
}

function cluster_token {
  export CLUSTER_TOKEN=$(docker-machine ssh manager "docker swarm join-token manager -q")
}

function set_master_ip {
  export MASTER_IP=$(docker-machine ip manager)
}

function start_cluster {
  set_master_ip
  docker-machine ssh manager "docker swarm init --listen-addr=${MASTER_IP} --advertise-addr=${MASTER_IP}"

  cluster_token
  join_workers
}

function join_workers {
  for i in $(seq 1 $CLUSTER_WORKERS); do
    docker-machine ssh "machine${i}" "docker swarm join \
      --token=${CLUSTER_TOKEN} \
      --listen-addr=$(docker-machine ip machine${i}) \
      --advertise-addr=$(docker-machine ip machine${i}) \
      ${MASTER_IP}:2377"
  done
}

function join_master {
  eval $(docker-machine env manager)
}

function create_network {
  HAS_NETWORK=$(docker network ls|grep -o cluster_network || echo "false")

  if [ $HAS_NETWORK == "false" ]; then
    echo "Creating network"
    docker network create --attachable -d overlay ${CLUSTER_NETWORK}
  else
    echo "Network already exists"
  fi
}

function create_host {
  set_master_ip
  HAS_HOST=$(cat /etc/hosts|grep $MASTER_IP || echo "false")

  if [ "$HAS_HOST" != "false" ]; then
    sudo sed -i "s/${MASTER_IP}.*/${MASTER_IP} ${CLUSTER_DNS}/g" /etc/hosts
  fi
}

function start_deploy {
  join_master
  create_network
  docker stack deploy -c docker-compose.yml local_cluster && docker service ls
}

function rm_deploy {
  join_master
  docker stack rm local_cluster && docker service ls
}

function leave_master {
  eval $(docker-machine env -u)
}
