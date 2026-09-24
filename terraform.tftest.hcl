mock_provider "aws" {
}

run "rejects_neither_associated_gateway_id_nor_proposal_id" {
  command = plan

  variables {
    dx_gateway_id = "dx-gw-12345"
  }

  expect_failures = [var.proposal_id]
}

run "rejects_both_associated_gateway_id_and_proposal_id" {
  command = plan

  variables {
    dx_gateway_id                       = "dx-gw-12345"
    associated_gateway_id               = "tgw-12345"
    proposal_id                         = "proposal-12345"
    associated_gateway_owner_account_id = "123456789012"
  }

  expect_failures = [var.proposal_id]
}

run "rejects_proposal_id_without_owner_account_id" {
  command = plan

  variables {
    dx_gateway_id = "dx-gw-12345"
    proposal_id   = "proposal-12345"
  }

  expect_failures = [var.associated_gateway_owner_account_id]
}

run "rejects_owner_account_id_without_proposal_id" {
  command = plan

  variables {
    dx_gateway_id                       = "dx-gw-12345"
    associated_gateway_id               = "tgw-12345"
    associated_gateway_owner_account_id = "123456789012"
  }

  expect_failures = [var.associated_gateway_owner_account_id]
}

run "same_account_association_passes_through" {
  command = plan

  variables {
    dx_gateway_id         = "dx-gw-12345"
    associated_gateway_id = "tgw-12345"
    allowed_prefixes      = ["10.0.0.0/16"]
  }

  assert {
    condition     = aws_dx_gateway_association.resource.dx_gateway_id == "dx-gw-12345"
    error_message = "dx_gateway_id should pass through unchanged."
  }

  assert {
    condition     = aws_dx_gateway_association.resource.associated_gateway_id == "tgw-12345"
    error_message = "associated_gateway_id should pass through unchanged."
  }

  assert {
    condition     = aws_dx_gateway_association.resource.proposal_id == null
    error_message = "proposal_id should be null for a same-account association."
  }

  assert {
    condition     = toset(aws_dx_gateway_association.resource.allowed_prefixes) == toset(["10.0.0.0/16"])
    error_message = "allowed_prefixes should pass through unchanged."
  }
}

run "cross_account_proposal_accept_passes_through" {
  command = plan

  variables {
    dx_gateway_id                       = "dx-gw-12345"
    proposal_id                         = "proposal-12345"
    associated_gateway_owner_account_id = "123456789012"
  }

  assert {
    condition     = aws_dx_gateway_association.resource.proposal_id == "proposal-12345"
    error_message = "proposal_id should pass through unchanged."
  }

  assert {
    condition     = aws_dx_gateway_association.resource.associated_gateway_owner_account_id == "123456789012"
    error_message = "associated_gateway_owner_account_id should pass through unchanged."
  }
}

run "readme_same_account_example" {
  command = plan

  variables {
    dx_gateway_id         = "dx-gw-12345"
    associated_gateway_id = "tgw-12345"
  }
}

run "readme_cross_account_example" {
  command = plan

  variables {
    dx_gateway_id                       = "dx-gw-12345"
    proposal_id                         = "proposal-12345"
    associated_gateway_owner_account_id = "123456789012"
  }
}
