cfg = rs.config()
printjson(cfg)
cfg.members[0].host = "HOST_IP:SERVICE_PORT"
printjson(rs.reconfig(cfg))
