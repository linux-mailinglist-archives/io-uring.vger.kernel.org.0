Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28687574098
	for <lists+io-uring@lfdr.de>; Thu, 14 Jul 2022 02:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiGNAiv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Jul 2022 20:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbiGNAis (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Jul 2022 20:38:48 -0400
Received: from sonic316-27.consmr.mail.ne1.yahoo.com (sonic316-27.consmr.mail.ne1.yahoo.com [66.163.187.153])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88838AE6D
        for <io-uring@vger.kernel.org>; Wed, 13 Jul 2022 17:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1657759126; bh=wG1xFGVNB4SOuRBXcrjQvRDalMrzfmPrcIqzxNH92uo=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=Fy55l1kKv6FQPpjGHxuPgOC0B/18iySLKwQL13SfZ4WwGRDn02d3kcbMLtasl9kWnwLN+zMbU2LxuNhqqbBxJ2bVJRd7UwcdJg76QRIapr6gLY3zfEKFTI4uEJAPtKF7SRc2JCbdE1zSpwvPQIWmCBCFHb+gwJU3c4vswUW2q2Qghhd06cG9H8Kcmd6WhTfRLR5gBVCAVlPiiIL+enwmMQjwU5SWcdh4VkJk3LKcmG1tz4kK8DiP2N7nxNNB4V+DwoRWA2DBVrLtGpJ6CqSpr1Wwlu5+v8v1VHNvXVx6TeE85uB0WsT5ORUQyew7axBrr6Wq6KhrXexLP5y5chF03w==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1657759126; bh=fwxTiIqxVPT00uELFE02K+q8SlFewLSVr6p9GrDXMAa=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=hxl007yFf5Tss+y6El1bwKT4kx8/SbEi6LnzycwbIdW5TssYD1JTF+LxqDRhUZKt0yVP7oovduVesUrX+yUqboG5vzpu91XNJOAwF2JciHcEbtlQdBsm7fk7Dv8Av6L2a/M3805qeEdiNprweaAlbpvkex2y0llbGIIjqmXPU4xiWvzSsqTiKa1krj2d7/aoNGXhwQf6WnT7tv2XWsavu9kRsLCBAmom6/apFnqd+4lR1QrGM+yQdz3DxVZBCRuym4aT9IwIZuduznFFC/JlWSvblBxMkZ0Qkro1TY/qhOEVenFly09gLg5k5kWzZoeOGbwOEuzZG/Ao3TDYou62Dw==
X-YMail-OSG: bGKfVt4VM1lMSRYZ.Sgy1fySQSsyiy5.HohuAAgJb.gTvJ525YVsVKtdA8wJCsV
 rRwBRkPX.yYNWem09LVPHffBD_ccwejGslf4Hb8LiO5KjSg7m5PvMiobwx1yD2N4t.aYHChH36La
 wikYJsNJtiuDxsf6UBOsyqwXnNYKSqNCyT6n1bNJjH2anaQSHWblX9KAAjIjX6ThLRBypo1okgAt
 qoLG_B7YbAtAJiC2Q6HlyjlPBrPBG52Rg3N9fmMQ79vKencUjbH2upfiQ7.Uj43_eHs20vdf0K7k
 pBZIHVYb776.nIs2EKIO1OdETWo.6fZuncJcG58OSPGVw4PhUV.O_ePYzukOojGwKSzvn_dd7OT9
 lfRAORp2YgvxCN7Ry9Ly9yd5Wug0_Emn.G7sTLhVdy3CW9AutHxQSjfUDAwR1Mc4hmN8.EzBVrd0
 Xcg44WRlYS4CBYHTh92k6pkh69IoGEKy44e66ikRBQxYsZQ9OWw1FJLYWFtnoFEKWDV1IVZePey_
 a13iuGkvS0lGgvZMU_AzpCTInU80PVEhUCX2lGcLehjYMx4keSet1tvuI8I.sJo1yDfXZ5XV_MFt
 53Ait11.mbbbKYhg_Kzs3wlIMt3j6arxjLB9wGa5A9QhOxjV.w.Nkoc9O3yRQ1ROQr0yFQrfy.c4
 ayhKFd1dS23X3RvN30ynOPcopQ0B.OYo3g7698iZY4ZGriQXcWR5VRPt1e5dKQjJLS2ky7jfQNk1
 NBzpNvcWEWljEb8KClsGKVmAKAg6B8VvQgu.sxlLDj8wpTdlD3rcK58GeGvLmWUaaojm9h62QhZ0
 k2lM3gtodW3p4vJV8MXr4IAeT7zCrj5tHftOMLlppvg9dk.5NiCnX1badXIPizeKKwezd3VjSWQD
 _G2kOnkiMJqywjMN9mjrlJzlwtr2Y3RUHH4F5cSC6lccma8q6qvmCvw29UOy1NfzOZfGUY0TzErC
 0vOgI7VjJRgzpRvdH05npVtkue8CHmCs_s4VMqa6J.0534aUJ2J63yrEPZ3ZqzWHJ_81fMw39U_D
 6nthPYm_U2JQTCk5Wc3HLdLNq4vG0bRqmEd6AjN.GZ8mkTMAfdF7ILZ0MDop_QY1XCOD2OJeD0Q1
 4mPKOxrc5q5boksYfm.UP2sPIDiDXsrZgkVfktazwhvVyDuaHt2EyAnwvbI129ZPACXyef5n46Zf
 Xkl6PvolW.AHvAN8uWXyL75oLJL8cxHm.g.dLfk8y.1vBKS4vaGSnLaIh9oQqdq6F5HzK_OvzLuu
 nFuY2Gu4ZdGjdCY0T39sW4Ohnz9R7y8dpfipDnSC.0F09tlcFEoW4sVTaVUEKNM_wAIUofbVU4ev
 f7JANv6v3lEMJY_E.nZwnoIJOZ3opqKos2SCN03gQhFBlN0RKVekUeg0tDRsT90zOWUwpW9jE0A2
 YQMRalNw3iDEL8zaCPpiFeIgR6M9SDLVXnaBXsmqtr5VVYSp_.nrp9avQe7IMTXsSxX9q_vdY9Tb
 IUIIeJAP4_aBiK0FD2Bbtz_ludlv2krGNhPiRIOX9tTpEOgZ5VwUhEzC5lMNvlPd0B0cZnNAnwMx
 fOLeqvR2VnJI5W8dBwIecZrviApSPhUlURK.Gg84Sx8Yf9bmgmEXsDbFISlmZuxYl.8p1TC86JvB
 Wtj8jgyC77HXe_dO1AzTRSzkY70JTBmjTOQTtesGmc2dr6GjpLY6BenY2OqyjBig6sfggADgej3a
 MuSIPhoHx3HEQOQaP_lH.QzIZ1TDilyUFNAYPjtYSvgtwvLTgpQKVkZagi.OsaY2wmdSJ_2ypsAP
 qRliAFxqoHPOEXwmElY3mA30r0qPZDW5PiKZ8zM4sU0f4y7qRBJ_njQv6c9dlVIpEtFlfEJ_4OYJ
 6yWmt6vTnNpT2ruiJX1GCnvoKhia2xp50h5QE9s_VlbMIuilTf6s2i9ZzTVRk3IZz2ze0JnpkK8x
 jkC284qEN_ISb6nWTvTqvD6umnTyTlgo_MjDM9z6hLuqCoJBVb3OD1Ig9Nkg30Pv0VFW4jUtxMCC
 aGfVBZhWHI_voVDtNl4nSTEPZrlD5.Aq1uVMVB_SMxXSouESdvIQ_JFVscc2VpPvSdTuDAPoPNLw
 sMSv.28vrybIV0IbHaGQgUVViiChEBchpgejxdeOMuE9ioZdjRdsJbxLJpbDQvCfTObvkdXierWB
 2LYYTq8DHKQQVOmIf98bv2Eo.xss6ibfL4l0lZcM17NL8Pz3rozDxuWDesx9.Z2HpIjdBKoKqdls
 TMwCrwId_ja1WOwUhzzqY00zzl5B9rnboQUova_o-
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic316.consmr.mail.ne1.yahoo.com with HTTP; Thu, 14 Jul 2022 00:38:46 +0000
Received: by hermes--production-gq1-56bb98dbc7-b6h6x (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 82f9e831ef0984ad8d95da45e90a312d;
          Thu, 14 Jul 2022 00:38:43 +0000 (UTC)
Message-ID: <30dee52c-80e7-f1d9-a2e2-018e7761b8ea@schaufler-ca.com>
Date:   Wed, 13 Jul 2022 17:38:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] lsm,io_uring: add LSM hooks to for the new uring_cmd file
 op
Content-Language: en-US
To:     Luis Chamberlain <mcgrof@kernel.org>, axboe@kernel.dk,
        paul@paul-moore.com, joshi.k@samsung.com,
        linux-security-module@vger.kernel.org, io-uring@vger.kernel.org
Cc:     linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        a.manzanares@samsung.com, javier@javigon.com,
        casey@schaufler-ca.com
References: <20220714000536.2250531-1-mcgrof@kernel.org>
From:   Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <20220714000536.2250531-1-mcgrof@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.20407 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/13/2022 5:05 PM, Luis Chamberlain wrote:
> io-uring cmd support was added through ee692a21e9bf ("fs,io_uring:
> add infrastructure for uring-cmd"), this extended the struct
> file_operations to allow a new command which each subsystem can use
> to enable command passthrough. Add an LSM specific for the command
> passthrough which enables LSMs to inspect the command details.
>
> This was discussed long ago without no clear pointer for something
> conclusive, so this enables LSMs to at least reject this new file
> operation.

tl;dr - Yuck. Again.

You're passing the complexity of uring-cmd directly into each
and every security module. SELinux, AppArmor, Smack, BPF and
every other LSM now needs to know the gory details of everything
that might be in any arbitrary subsystem so that it can make a
wild guess about what to do. And I thought ioctl was hard to deal
with.

Look at what Paul Moore did for the existing io_uring code.
Carry that forward into your passthrough implementation.
No, I don't think that waving security away because we haven't
proposed a fix for your flawed design is acceptable. Sure, we
can help.

>
> [0] https://lkml.kernel.org/r/8adf55db-7bab-f59d-d612-ed906b948d19@schaufler-ca.com
>
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  include/linux/lsm_hook_defs.h | 1 +
>  include/linux/lsm_hooks.h     | 3 +++
>  include/linux/security.h      | 5 +++++
>  io_uring/uring_cmd.c          | 5 +++++
>  security/security.c           | 4 ++++
>  5 files changed, 18 insertions(+)
>
> diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
> index eafa1d2489fd..4e94755098f1 100644
> --- a/include/linux/lsm_hook_defs.h
> +++ b/include/linux/lsm_hook_defs.h
> @@ -406,4 +406,5 @@ LSM_HOOK(int, 0, perf_event_write, struct perf_event *event)
>  #ifdef CONFIG_IO_URING
>  LSM_HOOK(int, 0, uring_override_creds, const struct cred *new)
>  LSM_HOOK(int, 0, uring_sqpoll, void)
> +LSM_HOOK(int, 0, uring_cmd, struct io_uring_cmd *ioucmd)
>  #endif /* CONFIG_IO_URING */
> diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
> index 91c8146649f5..b681cfce6190 100644
> --- a/include/linux/lsm_hooks.h
> +++ b/include/linux/lsm_hooks.h
> @@ -1575,6 +1575,9 @@
>   *      Check whether the current task is allowed to spawn a io_uring polling
>   *      thread (IORING_SETUP_SQPOLL).
>   *
> + * @uring_cmd:
> + *      Check whether the file_operations uring_cmd is allowed to run.
> + *
>   */
>  union security_list_options {
>  	#define LSM_HOOK(RET, DEFAULT, NAME, ...) RET (*NAME)(__VA_ARGS__);
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 4d0baf30266e..421856919b1e 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -2053,6 +2053,7 @@ static inline int security_perf_event_write(struct perf_event *event)
>  #ifdef CONFIG_SECURITY
>  extern int security_uring_override_creds(const struct cred *new);
>  extern int security_uring_sqpoll(void);
> +extern int security_uring_cmd(struct io_uring_cmd *ioucmd);
>  #else
>  static inline int security_uring_override_creds(const struct cred *new)
>  {
> @@ -2062,6 +2063,10 @@ static inline int security_uring_sqpoll(void)
>  {
>  	return 0;
>  }
> +static inline int security_uring_cmd(struct io_uring_cmd *ioucmd)
> +{
> +	return 0;
> +}
>  #endif /* CONFIG_SECURITY */
>  #endif /* CONFIG_IO_URING */
>  
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index 0a421ed51e7e..5e666aa7edb8 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -3,6 +3,7 @@
>  #include <linux/errno.h>
>  #include <linux/file.h>
>  #include <linux/io_uring.h>
> +#include <linux/security.h>
>  
>  #include <uapi/linux/io_uring.h>
>  
> @@ -82,6 +83,10 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
>  	struct file *file = req->file;
>  	int ret;
>  
> +	ret = security_uring_cmd(ioucmd);
> +	if (ret)
> +		return ret;
> +
>  	if (!req->file->f_op->uring_cmd)
>  		return -EOPNOTSUPP;
>  
> diff --git a/security/security.c b/security/security.c
> index f85afb02ea1c..ad7d7229bd72 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -2655,4 +2655,8 @@ int security_uring_sqpoll(void)
>  {
>  	return call_int_hook(uring_sqpoll, 0);
>  }
> +int security_uring_cmd(struct io_uring_cmd *ioucmd)
> +{
> +	return call_int_hook(uring_cmd, 0, ioucmd);
> +}
>  #endif /* CONFIG_IO_URING */
