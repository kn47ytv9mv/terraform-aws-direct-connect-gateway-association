# terraform-aws-direct-connect-gateway-association

Terraform module associating a Direct Connect gateway with a VPC's
virtual private gateway or a Transit Gateway, in any region.

## Cost

This association carries no charge of its own — it is what routes
traffic between the gateway and a VPC once a real Direct Connect
connection exists, but the billing (per-port-hour, per-GB transfer)
happens on the connection and virtual interface, not here. See AWS's
[Direct Connect pricing](https://aws.amazon.com/directconnect/pricing/)
page for current rates.

## Design

Two mutually exclusive ways to associate, matching the two real AWS
flows — enforced with a `validation` block, not left to a runtime
error:

- **Same account:** set `associated_gateway_id` directly to the VPC's
  virtual private gateway or Transit Gateway ID. Use this when the
  Direct Connect gateway and the gateway being associated are owned by
  the same account.
- **Cross account:** leave `associated_gateway_id` null, and instead
  set `proposal_id` (from
  [`terraform-aws-direct-connect-gateway-association-proposal`](https://github.com/kn47ytv9mv/terraform-aws-direct-connect-gateway-association-proposal),
  created by the account that owns the VPC gateway or Transit Gateway)
  and `associated_gateway_owner_account_id` (that same account's ID).
  This resource then runs in the account that owns the Direct Connect
  gateway, accepting the proposal.

Like the gateway itself, this association needs no physical Direct
Connect connection or virtual interface to exist first — a real
`terraform apply`/`terraform destroy` fully exercises it against
AWS's control-plane APIs alone, no hardware involved.

## Usage

Same-account association with a Transit Gateway:

```hcl
module "association" {
  source = "kn47ytv9mv/direct-connect-gateway-association/aws"

  dx_gateway_id         = module.gateway.id
  associated_gateway_id = module.transit_gateway.id
}
```

Or directly from this repository, accepting a cross-account proposal:

```hcl
module "association" {
  source = "github.com/kn47ytv9mv/terraform-aws-direct-connect-gateway-association"

  dx_gateway_id                       = module.gateway.id
  proposal_id                         = "proposal-12345"
  associated_gateway_owner_account_id = "123456789012"
}
```

## Requirements

| Name | Version |
|---|---|
| terraform | >= 1.9 |
| aws | ~> 6.61 |

## Providers

| Name | Version |
|---|---|
| aws | ~> 6.61 |

## Inputs

| Name | Description | Default | Required |
|---|---|---|---|
| dx_gateway_id | The ID of the Direct Connect gateway to associate. | `null` | no |
| associated_gateway_id | The ID of the VPC's virtual private gateway or a Transit Gateway to associate, when it is owned by the same account as dx_gateway_id. Mutually exclusive with proposal_id — leave null when accepting a cross-account association instead. | `null` | no |
| proposal_id | The ID of a terraform-aws-direct-connect-gateway-association-proposal to accept, for an association with a VPC's virtual private gateway or Transit Gateway owned by a different account. Pair with associated_gateway_owner_account_id. Mutually exclusive with associated_gateway_id. | `null` | no |
| associated_gateway_owner_account_id | Account ID that owns the gateway named in proposal_id. Required together with proposal_id; leave null for a same-account association (associated_gateway_id). | `null` | no |
| allowed_prefixes | CIDR blocks to advertise over this association. If null, AWS defaults to the VPC's own CIDR blocks for a virtual private gateway, or requires an explicit list for a Transit Gateway. | `null` | no |

## Outputs

| Name | Description |
|---|---|
| id | The ID of the Direct Connect gateway association. |
| dx_gateway_association_id | The ID of the association itself, distinct from the association resource's own id. |
| associated_gateway_type | Whether the associated gateway is a virtual private gateway or a Transit Gateway. |
| transit_gateway_attachment_id | The ID of the underlying Transit Gateway attachment, when associated_gateway_type is 'transitGateway'. Null for a virtual private gateway association. |

## License

MIT — see [LICENSE.md](LICENSE.md).
