This key is used to access the "demo" shell account on the servers. You can use it like this:

    ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ${path.root}/files/ssh/id_ecdsa demo@IP_ADDRESS
    