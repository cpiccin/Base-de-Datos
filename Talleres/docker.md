levanto el container
```
docker compose up -d
```
está ok? 
```
docker ps
```
para copiar un archivo local al container
```
docker cp <path_origen_local> <container_id>:<path_destino_en_container>
```
está? 
```
docker exec -it <container_id> bash
cd <path_destino_en_container>
ls
```

chau
```
docker compose down
```
