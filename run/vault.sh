#!/bin/bash -e

. /etc/profile.d/vault.sh 

systemctl enable vault
systemctl start vault 

until curl -fs -o /dev/null localhost:8200/v1/sys/init; do
  echo "Waiting for Vault to start..."
  sleep 1
done

init=$(curl -fs localhost:8200/v1/sys/init | jq -r .initialized)

if [ "$init" == "false" ]; then
  echo "Initializing Vault"
  install -d -m 0755 -o vault -g vault /etc/vault
  vault operator init -key-shares=1 -key-threshold=1 | tee /etc/vault/vault-init.txt
else
  echo "Vault is already initialized"
fi

sealed=$(curl -fs localhost:8200/v1/sys/seal-status | jq -r .sealed)
unseal_key=$(awk '{ if (match($0,/Unseal Key 1: (.*)/,m)) print m[1] }' /etc/vault/vault-init.txt)
root_token=$(awk '{ if (match($0,/Initial Root Token: (.*)/,m)) print m[1] }' /etc/vault/vault-init.txt)

echo $unseal_key > /etc/vault/unseal-key.txt 
echo $root_token > /etc/vault/root-token.txt

if [ "$sealed" == "true" ]; then
  echo "Unsealing Vault"
  vault operator unseal $unseal_key 
else
  echo "Vault is already unsealed"
fi

vault login $root_token 
vault secrets enable -version=2 kv 
vault kv put kv/bcl/database database=broadleaf username=broadleaf password=ech9Weith4Phei7W 
