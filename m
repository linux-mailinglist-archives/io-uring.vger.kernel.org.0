Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC46B4D8904
	for <lists+io-uring@lfdr.de>; Mon, 14 Mar 2022 17:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242979AbiCNQ0x (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Mar 2022 12:26:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242978AbiCNQ0w (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Mar 2022 12:26:52 -0400
Received: from sonic301-38.consmr.mail.ne1.yahoo.com (sonic301-38.consmr.mail.ne1.yahoo.com [66.163.184.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A42AB7E6
        for <io-uring@vger.kernel.org>; Mon, 14 Mar 2022 09:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1647275140; bh=0IRWw6p4Yid78lEQbf1VLJjRHwgvJhi0t8gill2Vp34=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=XLqdeZnv0Xcl4+CI+2CG2D0xhzZswms5XriCfJp+cV1dY4wiScN1nMqB/QYYAB2gRJxP7vsZfLUdJX2PXBc+Vba8WurgY51QCD/TmJDHLNtRpTBxDu1YciXJ2LSrjhqycf/XkCQntRT3nZGlcohK9m42vLqW4N9dnQY9c5655Zk0G1S0ujM6IgBsNGkfYg0gANoIJM/GmdcDsuVtL+Bi+t+AEJwGCrMwc+NhWq2NRS0E7Z7EYJtumBkouYOj47nKp6BuVHiaJ7Q4ZAzmki1LGCwXlQ8TjccTXUIOHNL3MMV8W18fvjuL5GMp/kTAaNhm/H+TDCRXD1IuUc1d+E/yRA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1647275140; bh=kxfKlgeNHvsS1ogV3c7jBcio/sEX1DRxmPPY8pqSSgk=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=i3en1NTTMOsTQaZtfFx5GtD0vqOQONLu/TWuXCbw/7J0MutlZmILIm7Cog1jzpXQcCEWZT04Nz/EPWopiY0O1hfXkI9lqkkk3goc5kj6rPkkkK3bo+U7/gFvbA+EJoq9ibgusYp1oySI5SBgkppjfIKifBxONJ1kdPiu4BfbatJwwNKCpgyAYg9Frb2AHAvzT3nXik6cwUdNbJhCd5FjOxBfKaU5hNzT5VzqTvQaInN2tCi8D4X3T4FckfWfUiIL8nKL5NHegoXxyhBinchvkBz7luOCWOujXQxsld97SRvG6TeOti0y6oKWJbcbvArOtKiwHnO73zfUEwK8x8elEQ==
X-YMail-OSG: 8r2jJ1QVM1mpwVVWklQYlxPyiWcV6ePuKBeXEDwWp6v594OkMGq.7jk02br71zR
 88KakxLYVyRf14Q3NOwbohjsHDK5coMOdWjRuUwz99pQ1MJ9lkkhtdP2Wmu.APtSdKK8m2er.nas
 NGA1DvXRF94kMOX6.jkhokL9P2Ji935jW9ZnIAPaV91aRI0uXLrqX1C98dV6MrHUYZ525FZgPCOv
 q5dg9hYhP4ODRHwgGvbveH6OSaW80zglcv_VdqPm4WSSAglbwIPlJCRE2txeUx.QJPCT3LvJhWuP
 cbXcy6MqbaIxNido9jgRUNqjwhpvlRyzxDutfWTUGZTAd6A11DYp7SNSuO48W1U3NYa.AQbo9EjR
 wvXDtzhS_1iDgKvDQbyas9zskGGZJhne_TGrRx9_vbkKvEUbkRZ9MSKgjtZ_eDsESpTD8e3oahqS
 qgTU4B0yq.piscvckAOV32ovV2QS54n6LqstdjVlYKowEiIdgfEvY02Mc_8A1pl0LJN6c1d0pEmO
 wbPS0ZlaJCafllSdRSLx4z6GUPykjdRm61fQS6VkdMLn_5f9daKK8CVb3eqtYA.4hyb_lSzV4tNV
 6zOYMcd.4Zlsmh0KhpnqSioF1GqjgHGm6VrjKmJU3PSs_3UXMVMp5dQPnRGE1A8kecuMntaNNAzL
 SoXKr3xJvgwxCSnsF9924qM9IN9iLBb91_1c2k7BEqWRt0Aq1095cu8inp0wQEsOlKCPBU9heHpV
 5Ou4rZIUS06bxMCol.tskrjAPuMhbgGMUifqzYm.SZ3lPhrm1DU2nE63rdEOGnO_qMOC4RlGRkds
 Mv5b_NWHVAqTJs9z6CLSjXqFZGYK_unYCsgIqDSjqG53H96MsDHbyQhYLRbJS9Vni1wBfWbjtQeu
 M81vkLj4eniYBxGs1LojLswyeOh7l08HVMc_3BDQl93iocr4rGUP6HqPJQL4wMwFbWxwe22._esU
 3j_yGFeotUoQRK2pyOkP_ZJ4Syrhzq6z2gE42lc430PLxZy4n4dhOZF9D6oY7R_.LoEclEBrP.Wd
 z8RrcQeDXtFv_VHsJLNIqp622nC3IJ2QZVpV_WG0OEgD4.4sCF_wb03RnNDqp3YtScHrK0MLPfmE
 MmVKkpXGHcr2A0iQrZzJsSZvls1jZkpwmNMoQs1kDyX1CNdwJmUWeZh1XIMdUpvsSpyd6WTpO6rG
 Bey0ZsfdIgvzGwHQ83l_JbFkvzpaaYNsJNIjV9woYoKWCc_FtU8rqlO80ydDosNhaEqAmU8wq8m7
 dWlkxf.m35VsyA0sIuPK3Zq8C0MnZYzftfJpSqB4t5j4pIKwWjyJss2yMIVnvohLDxj96v6vh_MW
 a_1dEjEYKVc9bCdJ5Awt77hcsp9i5q525GhvcnB1JUp2fllPyfX8w6hjh2LeRSwzjdI._j8fE2cK
 6xuHHKVPGZrN.ngteMJLM4RqReok_eiNtIX0s6MSKYMjkh8RXDVi1bgPF0n49cMAg7SjFu5BVsX6
 czwKOSCmZW7CkD_kVUzrOvX1epAcTGEkbKcQn.58uQIeECSb1UuG0GJQVgCn_wOkoiwK7.s9asm_
 HxKcb713GHynDP4MZ39FcAylgsaHRFfQw4rMQONlqYIJT.ZjK3C9c3ncu4Mti6HAhervsAp_Y6OR
 mHK4KGMkm9Bg.e30UeiI9yDnYCGLxS_WuNlFJoxQgPSU3Vs0OlciqqvyL1vxx_hsp91axXQpAw3k
 CNqr2AjEq9RLfdaEqVGwtbjtspVOrTjfHYvY4ZsGkF11DMtwm0d46EfB2fMjjwu_D9gCybJ9pQkv
 XwEwpioLWR7OiMK4FLOhfg6ZlXpGtU7ce.FgG8E_W9K0xcW6I06NOxQC63U4OGvx5neSyBvJyodS
 d9KWUNrhs2YvAwjhb1rDzRCo_PpIALM0cgAhu6EziC7NbxR.9OHvoSmravaYLuOl5dZbE8N7ZSZf
 _dhV6pqJKmodQN2SjcCA4bITfvwdFuoTQu7Z4aoYI1PcrsMkAnR5tpwtq3ecoL5KO5Q3k5t4Ofrz
 VDB_YBaC5oMjfcmA_U1AiuHOjTl2vaS9Dm3e8rOOiXFbzsREhRuTgV8UdaCZOZ5Kl3TNZsyowutA
 5TfemE2ixdVpfONR.gIAeRR8EwyQrLz2gYhGmKuoz9nz85riGlCHFQML33OrMU0IcYa_9pvLJzkO
 Am6uF0LmdFfDllJDsKxaRAlhsjUVZOdp0BmwlVP4oFTulJnTY8yiR1LXukjZVJY3wBW0LvPI8WRW
 H_U94AtBiWrJZdt0gOBtvV3U-
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic301.consmr.mail.ne1.yahoo.com with HTTP; Mon, 14 Mar 2022 16:25:40 +0000
Received: by kubenode540.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID e25f059b4720e62133e2e8c96baedb05;
          Mon, 14 Mar 2022 16:25:37 +0000 (UTC)
Message-ID: <92938b01-1746-af70-b325-e098488d8cdf@schaufler-ca.com>
Date:   Mon, 14 Mar 2022 09:25:35 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 03/17] io_uring: add infra and support for
 IORING_OP_URING_CMD
Content-Language: en-US
To:     Luis Chamberlain <mcgrof@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Paul Moore <paul@paul-moore.com>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, jmorris@namei.org,
        serge@hallyn.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        linux-security-module@vger.kernel.org, hch@lst.de,
        kbusch@kernel.org, asml.silence@gmail.com,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, sbates@raithlin.com,
        logang@deltatee.com, pankydev8@gmail.com, javier@javigon.com,
        a.manzanares@samsung.com, joshiiitr@gmail.com,
        anuj20.g@samsung.com, Casey Schaufler <casey@schaufler-ca.com>
References: <20220308152105.309618-1-joshi.k@samsung.com>
 <CGME20220308152658epcas5p3929bd1fcf75edc505fec71901158d1b5@epcas5p3.samsung.com>
 <20220308152105.309618-4-joshi.k@samsung.com>
 <YiqrE4K5TWeB7aLd@bombadil.infradead.org>
 <e3bfd028-ece7-d969-f47c-1181b17ac919@kernel.dk>
 <YiuC1fhEiRdo5bPd@bombadil.infradead.org>
From:   Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <YiuC1fhEiRdo5bPd@bombadil.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.19878 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/11/2022 9:11 AM, Luis Chamberlain wrote:
> On Thu, Mar 10, 2022 at 07:43:04PM -0700, Jens Axboe wrote:
>> On 3/10/22 6:51 PM, Luis Chamberlain wrote:
>>> On Tue, Mar 08, 2022 at 08:50:51PM +0530, Kanchan Joshi wrote:
>>>> From: Jens Axboe <axboe@kernel.dk>
>>>>
>>>> This is a file private kind of request. io_uring doesn't know what's
>>>> in this command type, it's for the file_operations->async_cmd()
>>>> handler to deal with.
>>>>
>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
>>>> ---
>>> <-- snip -->
>>>
>>>> +static int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
>>>> +{
>>>> +	struct file *file = req->file;
>>>> +	int ret;
>>>> +	struct io_uring_cmd *ioucmd = &req->uring_cmd;
>>>> +
>>>> +	ioucmd->flags |= issue_flags;
>>>> +	ret = file->f_op->async_cmd(ioucmd);
>>> I think we're going to have to add a security_file_async_cmd() check
>>> before this call here. Because otherwise we're enabling to, for
>>> example, bypass security_file_ioctl() for example using the new
>>> iouring-cmd interface.
>>>
>>> Or is this already thought out with the existing security_uring_*() stuff?
>> Unless the request sets .audit_skip, it'll be included already in terms
>> of logging.
> Neat.
>
>> But I'd prefer not to lodge this in with ioctls, unless
>> we're going to be doing actual ioctls.
> Oh sure, I have been an advocate to ensure folks don't conflate async_cmd
> with ioctl. However it *can* enable subsystems to enable ioctl
> passthrough, but each of those subsystems need to vet for this on their
> own terms. I'd hate to see / hear some LSM surprises later.
>
>> But definitely something to keep in mind and make sure that we're under
>> the right umbrella in terms of auditing and security.
> Paul, how about something like this for starters (and probably should
> be squashed into this series so its not a separate commit) ?
>
> >From f3ddbe822374cc1c7002bd795c1ae486d370cbd1 Mon Sep 17 00:00:00 2001
> From: Luis Chamberlain <mcgrof@kernel.org>
> Date: Fri, 11 Mar 2022 08:55:50 -0800
> Subject: [PATCH] lsm,io_uring: add LSM hooks to for the new async_cmd file op
>
> io-uring is extending the struct file_operations to allow a new
> command which each subsystem can use to enable command passthrough.
> Add an LSM specific for the command passthrough which enables LSMs
> to inspect the command details.
>
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>   fs/io_uring.c                 | 5 +++++
>   include/linux/lsm_hook_defs.h | 1 +
>   include/linux/lsm_hooks.h     | 3 +++
>   include/linux/security.h      | 5 +++++
>   security/security.c           | 4 ++++
>   5 files changed, 18 insertions(+)
>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 3f6eacc98e31..1c4e6b2cb61a 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -4190,6 +4190,11 @@ static int io_uring_cmd_prep(struct io_kiocb *req,
>   	struct io_ring_ctx *ctx = req->ctx;
>   	struct io_uring_cmd *ioucmd = &req->uring_cmd;
>   	u32 ucmd_flags = READ_ONCE(sqe->uring_cmd_flags);
> +	int ret;
> +
> +	ret = security_uring_async_cmd(ioucmd);
> +	if (ret)
> +		return ret;
>   
>   	if (!req->file->f_op->async_cmd)
>   		return -EOPNOTSUPP;
> diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
> index 819ec92dc2a8..4a20f8e6b295 100644
> --- a/include/linux/lsm_hook_defs.h
> +++ b/include/linux/lsm_hook_defs.h
> @@ -404,4 +404,5 @@ LSM_HOOK(int, 0, perf_event_write, struct perf_event *event)
>   #ifdef CONFIG_IO_URING
>   LSM_HOOK(int, 0, uring_override_creds, const struct cred *new)
>   LSM_HOOK(int, 0, uring_sqpoll, void)
> +LSM_HOOK(int, 0, uring_async_cmd, struct io_uring_cmd *ioucmd)
>   #endif /* CONFIG_IO_URING */
> diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
> index 3bf5c658bc44..21b18cf138c2 100644
> --- a/include/linux/lsm_hooks.h
> +++ b/include/linux/lsm_hooks.h
> @@ -1569,6 +1569,9 @@
>    *      Check whether the current task is allowed to spawn a io_uring polling
>    *      thread (IORING_SETUP_SQPOLL).
>    *
> + * @uring_async_cmd:
> + *      Check whether the file_operations async_cmd is allowed to run.
> + *
>    */
>   union security_list_options {
>   	#define LSM_HOOK(RET, DEFAULT, NAME, ...) RET (*NAME)(__VA_ARGS__);
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 6d72772182c8..4d7f72813d75 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -2041,6 +2041,7 @@ static inline int security_perf_event_write(struct perf_event *event)
>   #ifdef CONFIG_SECURITY
>   extern int security_uring_override_creds(const struct cred *new);
>   extern int security_uring_sqpoll(void);
> +extern int security_uring_async_cmd(struct io_uring_cmd *ioucmd);
>   #else
>   static inline int security_uring_override_creds(const struct cred *new)
>   {
> @@ -2050,6 +2051,10 @@ static inline int security_uring_sqpoll(void)
>   {
>   	return 0;
>   }
> +static inline int security_uring_async_cmd(struct io_uring_cmd *ioucmd)
> +{
> +	return 0;
> +}
>   #endif /* CONFIG_SECURITY */
>   #endif /* CONFIG_IO_URING */
>   
> diff --git a/security/security.c b/security/security.c
> index 22261d79f333..ef96be2f953a 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -2640,4 +2640,8 @@ int security_uring_sqpoll(void)
>   {
>   	return call_int_hook(uring_sqpoll, 0);
>   }
> +int security_uring_async_cmd(struct io_uring_cmd *ioucmd)
> +{
> +	return call_int_hook(uring_async_cmd, 0, ioucmd);

I don't have a good understanding of what information is in ioucmd.
I am afraid that there may not be enough for a security module to
make appropriate decisions in all cases. I am especially concerned
about the modules that use path hooks, but based on the issues we've
always had with ioctl and the like I fear for all cases.

> +}
>   #endif /* CONFIG_IO_URING */
