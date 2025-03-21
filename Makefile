opentofu-fmt:
	@tofu fmt -check -recursive bootstrap/
	@tofu fmt -check -recursive infrastructure/
