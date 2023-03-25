1. Install docker in your machine.
2. Open "secure-password-engine" directory in administrative terminal.
3. Run the command:
    docker compose --env-file ./.env up -d
  
  or if you need compile log
  
1. docker_buildkit=0 docker compose --env-file ./.env up -d


# TO BUILD RUN "docker compose --env-file ./.env build"