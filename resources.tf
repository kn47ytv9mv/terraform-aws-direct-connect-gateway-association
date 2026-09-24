resource "aws_dx_gateway_association" "resource" {
  dx_gateway_id                       = var.dx_gateway_id
  associated_gateway_id               = var.associated_gateway_id
  proposal_id                         = var.proposal_id
  associated_gateway_owner_account_id = var.associated_gateway_owner_account_id
  allowed_prefixes                    = var.allowed_prefixes
}

output "id" {
  description = "The ID of the Direct Connect gateway association."
  value       = aws_dx_gateway_association.resource.id
}

output "dx_gateway_association_id" {
  description = "The ID of the association itself, distinct from the association resource's own id."
  value       = aws_dx_gateway_association.resource.dx_gateway_association_id
}

output "associated_gateway_type" {
  description = "Whether the associated gateway is a virtual private gateway or a Transit Gateway."
  value       = aws_dx_gateway_association.resource.associated_gateway_type
}

output "transit_gateway_attachment_id" {
  description = "The ID of the underlying Transit Gateway attachment, when associated_gateway_type is 'transitGateway'. Null for a virtual private gateway association."
  value       = aws_dx_gateway_association.resource.transit_gateway_attachment_id
}
