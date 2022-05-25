<#ftl output_format="HTML">
<#import "/spring.ftl" as spring />
<#import "../shared/default.ftl" as default/>
<#import "../shared/account.ftl" as account/>

<!DOCTYPE html>
<html lang="en">
<@default.head title="Account security - STAs" />

<body class="min-vh-100">
<@default.navbar account="active"/>

<div class="container-fluid container-lg my-3">
    <div class="row">
        <div class="col-md-3">
            <@account.sidebar accountSecurity="active"/>
        </div>
        <div class="col-md-9 animate__animated animate__fadeIn animate__faster">
            <div class="container mt-2">
                <div class="fs-4 user-select-none"><@default.icon name="security"/>
                    Account security
                </div>
                <div class="container px-0">
                    <div class="card mt-3">
                        <div class="card-body">
                            <h6>Change your password</h6>
                            <form action="<@spring.url "/account/security/update-password"/>" method="post">
                                <@default.csrfInput/>
                                <#if isCurrentPasswordDisabled??>
                                    <div class="text-danger fw-bold fs-6">
                                        Please set up a new password for your account
                                    </div>
                                </#if>
                                <div class="form-floating mt-3">
                                    <@account.formElement path="changePasswordForm.currentPassword" label="Current password" type="password" attrb=(isCurrentPasswordDisabled??)?then("disabled","") placeholder="Current password" bindValue=false />
                                </div>
                                <div class="form-floating mt-3">
                                    <@account.formElement path="changePasswordForm.newPassword" label="New password" type="password" attrb="required" placeholder="New password" bindValue=false/>
                                </div>
                                <div class="form-floating mt-3">
                                    <input class="form-control" name="confirmNewPassword" id="confirmNewPassword"
                                           required
                                           placeholder="Confirm password" type="password"/>
                                    <label class="form-label text-muted" for="confirmNewPassword">Confirm
                                        password</label>
                                    <span class="invalid-feedback" id="confirmNewPasswordFeedback"></span>
                                </div>
                                <div class="mt-3">
                                    <input class="btn btn-outline-primary" value="Save" type="submit">
                                </div>
                            </form>
                        </div>
                    </div>
                    <div class="card mt-3">
                        <div class="card-body">
                            <h6 class="mb-0">
                                Two-factor authentication
                                <span class="form-check-inline form-switch mx-2 mb-1">
                                      <input class="form-check-input" type="checkbox" role="switch"
                                             ${(twoFactorState!false)?then("checked","")}
                                             id="twoFactorSwitch" aria-label="Two-factor authentication">
                                </span>
                            </h6>
                            <#if twoFactorSecret??>
                                <div class="card-text">
                                    Scan this QR code with your authenticator app (e.g. Google Authenticator).
                                    <br>
                                    If you can't scan the QR code, click the button below it to reveal the secret then
                                    enter it in the authenticator app.
                                </div>
                                <div class="text-danger fw-bold">The secret will disappear if you refresh or leave this
                                    page
                                </div>
                                <div class="card text-center mt-3" style="width: 256px;">
                                    <div class="ratio ratio-1x1">
                                        <img src="${twoFactorSecretQR!""}" class="img-fluid rounded" width="256"
                                             alt="QR Code">
                                    </div>
                                    <button class="btn btn-primary rounded-0 rounded-bottom" id="revealSecretButton">
                                        Reveal secret
                                    </button>
                                </div>
                            </#if>
                        </div>
                    </div>
                    <div class="card mt-3 w-100">
                        <div class="card-body">
                            <h6>Delete account</h6>
                            <button class="btn btn-outline-danger mt-2" id="accountDeleteBtn">Delete my account</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="twoFactorModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Two-factor authentication</h5>
            </div>
            <div class="modal-body">
                <div>Open the two-factor authenticator (TOTP) app on your mobile device to view your authentication
                    code.
                </div>
                <form id="form2fa" action="<@spring.url "/account/security/update-2fa"/>" method="post">
                    <@default.csrfInput/>
                    <input type="hidden" id="twoFactorState" value="${(twoFactorState!false)?c}" name="state"/>
                    <div class="form-floating my-3">
                        <input class="form-control" type="text" name="code" id="twoFactorCode"
                               placeholder="Authentication code" required/>
                        <label class="form-label text-muted" for="twoFactorCode">Authentication code</label>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-bs-dismiss="modal">Cancel</button>
                <input class="btn btn-danger" type="submit" value="Verify and turn off" form="form2fa"/>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="revealSecretModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Two-factor authentication secret</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div>Copy the following code and paste it into your TOTP app</div>
                <code class="user-select-all">${twoFactorSecret!""}</code>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="accountDeleteModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header pb-0">
                <h5 class="modal-title">Delete account</h5>
            </div>
            <div class="modal-body">
                <form id="formDelete" action="<@spring.url "/account/security/delete"/>" method="post">
                    <@default.csrfInput/>
                    <div>Are you sure you want to delete your account?</div>
                    <#if (twoFactorState!false)>
                        <div class="mt-2">Enter your 2FA code to confirm</div>
                        <div class="form-floating mb-3 mt-1">
                            <input class="form-control" type="text" name="code2FA" id="accountDeleteCode2FA"
                                   placeholder="Authentication code" required/>
                            <label class="form-label text-muted" for="accountDeleteCode2FA">Authentication code</label>
                        </div>
                    </#if>
                </form>
                <div class="text-danger fw-bold">
                    This will delete all your data, including your portfolio.
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-bs-dismiss="modal">Cancel</button>
                <input class="btn btn-danger" type="submit" value="Delete my account" form="formDelete"/>
            </div>
        </div>
    </div>
</div>


<@account.confirmPasswordScript passwordId="newPassword" confirmPasswordId="confirmNewPassword" confirmPasswordFeedbackId="confirmNewPasswordFeedback"/>
<@default.scripts />
<@default.toast />
<script>
    (() => {
        const twoFactorSwitch = document.getElementById("twoFactorSwitch");
        const twoFactorSecret = "${twoFactorSecret!""}";
        const twoFactorForm = document.getElementById("form2fa");
        const twoFactorState = document.getElementById("twoFactorState");
        const twoFactorModal = document.getElementById("twoFactorModal")
        const revealSecretModal = document.getElementById("revealSecretModal")
        const revealSecretButton = document.getElementById("revealSecretButton");

        twoFactorSwitch.addEventListener("click", () => {
            const switchState = twoFactorSwitch.checked;
            twoFactorState.value = switchState;
            if (switchState)
                return twoFactorForm.submit();
            if (twoFactorSecret) {
                document.getElementById("twoFactorCode").value = twoFactorSecret
                return twoFactorForm.submit();
            }
            let modal = new bootstrap.Modal(twoFactorModal);
            twoFactorModal.addEventListener("shown.bs.modal", () => document.getElementById("twoFactorCode").focus());
            twoFactorModal.addEventListener("hide.bs.modal", () => twoFactorState.value = twoFactorSwitch.checked = !switchState);
            modal.show(null);
        });

        if (revealSecretButton) {
            revealSecretButton.addEventListener("click", () => {
                let modal = new bootstrap.Modal(revealSecretModal);
                modal.show(null);
            });
        }
    })()
</script>
<script>
    (() => {
        const accountDeleteBtn = document.getElementById("accountDeleteBtn");
        const accountDeleteModal = document.getElementById("accountDeleteModal");
        accountDeleteBtn.addEventListener("click", () => {
            let modal = new bootstrap.Modal(accountDeleteModal);
            accountDeleteModal.addEventListener("shown.bs.modal", () => document.getElementById("accountDeleteCode2FA").focus());
            modal.show(null);
        })
    })()
</script>
</body>
</html>