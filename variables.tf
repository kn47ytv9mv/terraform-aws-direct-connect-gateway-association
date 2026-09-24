variable "dx_gateway_id" {
  default     = null
  description = "The ID of the Direct Connect gateway to associate."
}

variable "associated_gateway_id" {
  default     = null
  description = "The ID of the VPC's virtual private gateway or a Transit Gateway to associate, when it is owned by the same account as dx_gateway_id. Mutually exclusive with proposal_id — leave null when accepting a cross-account association instead."
}

variable "proposal_id" {
  default     = null
  description = "The ID of a terraform-aws-direct-connect-gateway-association-proposal to accept, for an association with a VPC's virtual private gateway or Transit Gateway owned by a different account. Pair with associated_gateway_owner_account_id. Mutually exclusive with associated_gateway_id."

  validation {
    condition     = (var.associated_gateway_id != null) != (var.proposal_id != null)
    error_message = "Exactly one of associated_gateway_id (same-account association) or proposal_id (cross-account, accepting a terraform-aws-direct-connect-gateway-association-proposal) is required."
  }
}

variable "associated_gateway_owner_account_id" {
  default     = null
  description = "Account ID that owns the gateway named in proposal_id. Required together with proposal_id; leave null for a same-account association (associated_gateway_id)."

  validation {
    condition     = (var.proposal_id != null) == (var.associated_gateway_owner_account_id != null)
    error_message = "associated_gateway_owner_account_id is required together with proposal_id, and not used otherwise."
  }
}

variable "allowed_prefixes" {
  default     = null
  description = "CIDR blocks to advertise over this association. If null, AWS defaults to the VPC's own CIDR blocks for a virtual private gateway, or requires an explicit list for a Transit Gateway."
}
