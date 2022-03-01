<#ftl output_format="HTML">
<#import "/spring.ftl" as spring />
<#import "../shared/default.ftl" as default/>
<#import "../shared/account.ftl" as account/>

<!DOCTYPE html>
<html lang="en">
<@default.head title="Connections - STAs" />

<body>
<@default.navbar account="active"/>

<div class="container-fluid mt-3">
    <div class="row">
        <div class="col-sm-3">
            <@account.sidebar accountConnections="active"/>
        </div>
        <div class="col-sm-9">
            <div class="container mt-2">
                <h4>Connections</h4>
                <div class="container">
                    <div class="card mt-3">
                        <div class="card-body">
                            <div class="d-flex align-items-center justify-content-between">
                                <div class="fs-4">
                                    <span class="iconify-inline" data-icon="mdi:github" data-width="38"></span>
                                    <span class="align-text-bottom ">GitHub</span>
                                </div>
                                <a class="h-50 btn btn-primary align-baseline visually-hidden" href="<@spring.url "/"/>">Connect</a>
                                <a class="h-50 btn btn-danger align-baseline" href="<@spring.url "/"/>">Disconnect</a>
                            </div>
                            <span class="card-subtitle text-muted">Connected: SaifAqqad</span>
                        </div>
                    </div>
                    <div class="card mt-3">
                        <div class="card-body">
                            <div class="d-flex align-items-center justify-content-between">
                                <div class="fs-4">
                                    <span class="iconify-inline" data-icon="mdi:linkedin" data-width="38"></span>
                                    <span class="align-text-bottom">Linkedin</span>
                                </div>
                                <a class="h-50 btn btn-primary align-baseline" href="<@spring.url "/"/>">Connect</a>
                            </div>
                        </div>
                    </div>
                    <div class="card mt-3">
                        <div class="card-body">
                            <div class="d-flex align-items-center justify-content-between">
                                <div class="fs-4">
                                    <span class="iconify-inline" data-icon="mdi:google" data-width="38"></span>
                                    <span class="align-text-bottom">Google</span>
                                </div>
                                <a class="h-50 btn btn-primary align-baseline" href="<@spring.url "/"/>">Connect</a>
                            </div>
                        </div>
                    </div>
                    <div class="card mt-3">
                        <div class="card-body">
                            <div class="d-flex align-items-center justify-content-between">
                                <div class="fs-4">
                                    <span class="iconify-inline" data-icon="mdi:facebook" data-width="38"></span>
                                    <span class="align-text-bottom">Facebook</span>
                                </div>
                                <a class="h-50 btn btn-primary align-baseline" href="<@spring.url "/"/>">Connect</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<@default.scripts />
<@default.toast />
</body>
</html>