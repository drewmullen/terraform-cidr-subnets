locals {
  cidr_netmask = tonumber(split("/", var.base_cidr_block)[1])
  unique_subnet = length(var.networks) == 1 && tonumber(var.networks[0].netmask - local.cidr_netmask) == 0 ? true : false
  networks_netmask_to_bits = [for i, v in var.networks: { "name" = v.name, "new_bits" = tonumber(v.netmask - local.cidr_netmask) } ]
  name_prefixes = toset([ for name, _ in local.addrs_by_name: split(var.separator, name)[0] ])

  addrs_by_idx  = local.unique_subnet ? [var.base_cidr_block] : cidrsubnets(var.base_cidr_block, local.networks_netmask_to_bits[*].new_bits...)
  addrs_by_name = { for i, n in local.networks_netmask_to_bits : n.name => local.addrs_by_idx[i] if n.name != null }
  network_objs = [for i, n in local.networks_netmask_to_bits : {
    name       = n.name
    netmask    = var.networks[i].netmask
    bits       = n.new_bits
    cidr_block = n.name != null ? local.addrs_by_idx[i] : tostring(null)
  }]
}
