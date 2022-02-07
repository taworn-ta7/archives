'use strict';
const errors = {
	timeout: "timeout",
	invalidToken: "invalid token",
	requirePermissions: "require permissions",
	invalidUsernamePassword: "invalid username/password",
	userIsUnregistered: "user is unregistered",
	userIsDisabledByAdmin: "user is disabled by admin",
	notJson: "not JSON",
	notFound: "not found",
	deleted: "deleted",
	alreadyExists: "already exists",
	duplicate: "duplicate",
	noUploadFile: "no upload file",
	uploadFileIsNotType: "upload file is not type",
	uploadFileIsTooLarge: "upload file is too large",
	validationFailed: "validation failed",
}
module.exports = errors;
