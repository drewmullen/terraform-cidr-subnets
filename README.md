# Terraform CIDR Subnets Module

This is a module is a modified version of [terraform-cidr-subnets](https://github.com/hashicorp/terraform-cidr-subnets) to be used in a few modules I'm working on. There is 1 major modification to the origin and 1 added feature. Documentation is sparse for now but will be improved at a later date. All other features of the original module should still work except explicitly passing `new_bits` which is now `netmask`.

## Netmask instead of bits

In many situations, customers prefer to use netmask instead of bits. This is quite a simple change from the original post because new_bits = netmask - `base_cidr_block` cidr. You can generate networks using similar syntax:

```hcl
base_cidr_block = "10.0.100.0/16"

networks = [
  {
      name = "foo"
      netmask = 24
  },
  {
      name = "bar"
      netmask = 24
  },
  {
      name = "beep"
      netmask = 24
  },
  {
      name = "boop"
      netmask = 24
  },
]
```

Output:
```
networks = tolist([
  {
    "bits" = 8
    "cidr_block" = "10.0.0.0/24"
    "name" = "foo"
    "netmask" = 24
  },
  {
    "bits" = 8
    "cidr_block" = "10.0.1.0/24"
    "name" = "bar"
    "netmask" = 24
  },
  {
    "bits" = 8
    "cidr_block" = "10.0.2.0/24"
    "name" = "beep"
    "netmask" = 24
  },
  {
    "bits" = 8
    "cidr_block" = "10.0.3.0/24"
    "name" = "boop"
    "netmask" = 24
  },
])
```

## Grouping outputs

Additionally, we include a feature to group outputs by providing a prefix and a separator (default is `/`). If you prefix the name of your ranges using a separator, they will be grouped in a new output. If no separator is provided, no grouped output will be provided (overrides this feature):

```hcl
base_cidr_block = "10.0.100.0/16"

networks = [
    {
        name = "public/foo"
        netmask = 24
    },
    {
        name = "public/bar"
        netmask = 24
    },
    {
        name = "private/beep"
        netmask = 24
    },
    {
        name = "private/boop"
        netmask = 24
    },
]
```

Output:

```hcl
grouped_by_separator = {
  "private" = {
    "beep" = "10.0.2.0/24"
    "boop" = "10.0.3.0/24"
  }
  "public" = {
    "bar" = "10.0.1.0/24"
    "foo" = "10.0.0.0/24"
  }
}
```
