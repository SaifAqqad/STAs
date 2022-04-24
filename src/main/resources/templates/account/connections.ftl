<#ftl output_format="HTML">
<#import "/spring.ftl" as spring />
<#import "../shared/default.ftl" as default/>
<#import "../shared/account.ftl" as account/>

<!DOCTYPE html>
<html lang="en">
<@default.head title="Connections - STAs" />

<body>
<@default.navbar account="active"/>

<div class="container-fluid container-md my-3">
    <div class="row">
        <div class="col-sm-3">
            <@account.sidebar accountConnections="active"/>
        </div>
        <div class="col-sm-9">
            <div class="container mt-2">
                <div class="fs-4">Connections</div>
                <div class="container px-0">
                    <div class="card mt-3">
                        <div class="card-body">
                            <div class="d-flex align-items-center justify-content-between">
                                <div class="fs-4">
                                    <span class="iconify-inline" data-icon="ant-design:google-outlined" data-width="38"></span>
                                    <span class="align-text-bottom">Google</span>
                                </div>
                                <#if service_google??>
                                    <a class="h-50 btn btn-danger align-baseline"
                                       href="<@spring.url "/account/connections/disconnect/google"/>">Disconnect</a>
                                <#else>
                                    <a class="h-50 btn btn-primary align-baseline"
                                       href="<@spring.url "/connect/google?redirectUri=" + springMacroRequestContext.requestUri/>">Connect</a>
                                </#if>
                            </div>
                        </div>
                    </div>
                    <div class="card mt-3">
                        <div class="card-body">
                            <div class="d-flex align-items-center justify-content-between">
                                <div class="fs-4">
                                    <span class="iconify-inline" data-icon="mdi:github" data-width="38"></span>
                                    <span class="align-text-bottom ">GitHub</span>
                                </div>
                                <#if service_github??>
                                    <a class="h-50 btn btn-danger align-baseline"
                                       href="<@spring.url "/account/connections/disconnect/github"/>">Disconnect</a>
                                <#else>
                                    <a class="h-50 btn btn-primary align-baseline"
                                       href="<@spring.url "/connect/github?redirectUri=" + springMacroRequestContext.requestUri/>">Connect</a>
                                </#if>
                            </div>
                        </div>
                    </div>
                    <div class="card mt-3">
                        <div class="card-body">
                            <div class="d-flex align-items-center justify-content-between">
                                <div class="fs-4">
                                    <span class="iconify-inline" data-icon="mdi:linkedin" data-width="38"></span>
                                    <span class="align-text-bottom">Linkedin</span>
                                </div>
                                <#if service_linkedin??>
                                    <a class="h-50 btn btn-danger align-baseline"
                                       href="<@spring.url "/account/connections/disconnect/linkedin"/>">Disconnect</a>
                                <#else>
                                    <a class="h-50 btn btn-primary align-baseline"
                                       href="<@spring.url "/connect/linkedin?redirectUri=" + springMacroRequestContext.requestUri/>">Connect</a>
                                </#if>
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