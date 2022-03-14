Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFCFF4D8B4D
	for <lists+io-uring@lfdr.de>; Mon, 14 Mar 2022 19:05:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233434AbiCNSG7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Mar 2022 14:06:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234504AbiCNSG6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Mar 2022 14:06:58 -0400
Received: from sonic301-38.consmr.mail.ne1.yahoo.com (sonic301-38.consmr.mail.ne1.yahoo.com [66.163.184.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E444C3AA7A
        for <io-uring@vger.kernel.org>; Mon, 14 Mar 2022 11:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1647281147; bh=V8wALTuxvfKsBLLcBn9+uIKkwPv0fSFIjOuvpLvb8xI=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=ea28V9pbi1/u5Jv5RuMoBMcxTHMQbLt/GCd1n1JkQstmCF/q9jZ/LEJdUx0MtXH5npv8LoAdZ9m2FGpqfogHREyRJOHdbIfqkwLIlSfONRYNiwgaUtTBKH9R/27HGuoeVDlvBO+zrW55lmr6NfiP6Sm1yGPIQlMNPcGi3knuNX3Z5IbY8GopDu+3SxMSDLnAlKW72bc0wHuzoMa45CubZWVQ8gpwn6Ro0QVnqCSeJEVLWQTQHCf1NrfoMIt5sq4tqSxIyBUyBhZiFqTeMZ0ybqducVgdtoIdSQrBgMgPczWjmge83ojyNM1NmqUgV/zWEnoCSTM0YJc/JmbjM6LWtw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1647281147; bh=Hwc6/DSRm/jZizJXkUFVCepytIi27GnjSRQX+VxdAXe=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=rwm97zaRtncDHA/seL6DwNQktGBTtkKDHO5nA4dPvp8Ce1PxChca3Ln1lAkTIuX77eOqMNpGIJ9+vT21LNkQJQCZiICBTlER5tEhajE0QdNf8KHYyUBJM3R6yLy/UrxWXTJx3dcWth0La9CIraUC22PDGtvyGtVLnduehbfz7xyDRoqDiI7bvtcU0izmy2fUyppazxINNA2e3zDmUPwIk90dpI2hkcZ0kOWqliJV/g0tESZpYCld3PHv2W6zP8Yh5l5/RX4wTn/x6ZdGuJuL81edEPXNh14GrRaqKtVpCsnGzg3zG/As7mDWgV3Q+j1r5iXh7XqCF01dA6B2kxHdMA==
X-YMail-OSG: .k0gT.cVM1m.ioCRBtJ7cO9SS7CeGaRJfUK.VUgN8jitHRGNP9j_0XECvdh5ndd
 fw0CYC0nHCl3wK7UDyp65QE2A3HQqw5WqbIy27Dvexgm4yEZJZ8e5SDxhqkEoOENS_40UFsXgdLs
 WgaEuOONDge23o9gMCqkbXT8yE2GogAfZXRGaAMFZCFn55E4rpswLmKKI0BqbFy6rc.IT.jNegC9
 gL1fMNNuitOYZllMFBlHoqbubelDDM.XTZia.Lqb6M4HCsNEzrQCPiBQ.dMknbXd_.e92vRhhSqj
 0N4SforFsZmkrEOET6WKJApu4X2yGUk6ZoDHWWOCunPLwaAFOckEy3c7CSrMIRMJhOvCPtMvSusJ
 Xzebd2Kztp3r2IufKthxn8FKPmDe_EFME1VnKlbz6G5ymi1BXLu6ZmKSDOCfUTf34jkqDPZMoCN6
 jhW.a4bWaQnF_n6QJu8AHPkPtbjqYQioK9Blon26XFJFFgZXsTKJO8Gtj75olpiNGNHAn3hWNNxm
 0VotJH5dPjNR.0J_.xOv64SBfT8n7wQZreg4EhojuZK8O77kI6DGXYxjVLhF4OUIX3lXgI5H8P2J
 m2l2LT2NtDgM5fl0x1hiAftTN1sOzu732BSuWRafid6pPOaEgudS7lwksArlvQ1CyBahHPd0qLux
 fJKN1QHYSkgTRj5AUfpV7_8m5VaI_blQCsxDTmFdtiHCXHye2JVJYYODjBSsMAkQBw36TkwcE_B5
 kI7lFBs3yXgiTz.RcsdqzqiZBdN_vOTjmVEJshIBz1ivTU2ZTvlCyfUTDbqZ3W.DTcuPhbxRVVsL
 n_DXwEwxaQA5eq.rCLYzLFmtOtxA8OvSP6BHuHS4SIvi88_6ste7ifQ7ecPN4LheEuPv0ONfnpXk
 LKzNYNsQCh1U6wVtPoSfpuHQiYQhyS2E2hn6stZ5WooWecr5QtKWaFq_gdX5wE6gsUTIhe.Mw4dj
 YHFpxdZEwgKKOOs3OXtFdDB.V1nTtniYpojt26.YbJykwx41u1NZf6J7RCUwOB_Z73N2p3qDB8lx
 x.FUs6wkTa3mfqGMrtMrmJRV7hZmjgvm0yZkoUaup_mrMFPFD8UOeoDuGHQ41WNNBn4ZpNbvXDqi
 mLkI3NPjDu1Wvu0ALAhepW_ig.zW3MH5_O9lgW.zzBjBBcjDH9ZT0rY479dV6CE6I1qQQa54sK0p
 7oT9EOPbEwA2y_4XZUVhOBPYrRmRJnTERRN9sMpYZR8YDnTUJvdLXzTbeuLbxkitvsuVhuNgfdaM
 44Dx9wwLgE6yb.V.xoP9_UYyOE9odQxlYnb_a0FhruiJAtu1WoOQe8cqvUs.pHizYKSlsNtkZquk
 NkW4RHFAw2CZAb4noA7vSOng.FhdYQKsulMWSkGKH0hsHejiWZdCMRiJUQ7R8X38Kc.yDl_UoO45
 Lnb1q_lXAG8ZrXy0bWksUJcjYX9j..AaM6ZRpbVxZ68SG.e4l3_GIbd5HdDABXAYXeFLNr0QzVup
 oBiQbII14gLIPG9PX3.eC4WFVfjVtyZRQPpEapnXytMD26S5CmEImRwhvIael7ZUb8Ofc_6KzKBA
 i.D8vgM65pfNocOszS726NN3g573KbSbatyVTIGGZkE12CESf8jIWsDQ.oEr9Xhz6U.e381hNDhO
 W7XJ3PKenNh.Dm7ij7GZmK0pLu5oJuliTFsj70sEvpWjDTtQALY9LwmtyhaHPnTlrKnUqdv__QyJ
 sgscXPicOlCJXhEJrvw4vSrZVCtwazBMJj8HDa5NOxzWBqk5OOxe.B4iD6Cc2VIcSCrqqx7P82xw
 5yWSySc8ZOi9nmixRfycI9qbCKX6cqqFb2r76BOk6g65J4uC6juCoGyRD855eH_8Exe4PtWoXvw0
 UIyJw3cjyo8K74X21ebVv22YyN6kBe5RHcc2wPX_7vIEBvCT_9fELvbrYrJBk5SZ3XcFXGnuNbOW
 qPksg0NWdnyH9ZpT1IcMH5lESCLoJ4FAku6HybIpnmW0vmIBW43B62spOP7H4awjmfxfBhOhTtfp
 KOv75OOITDDxVWo8Bx6L4lagPubT6ZzHUkChlQGMB1Hb4.ndC5CJJCoiUx9I3NdeIRZRxpEH0hnP
 .oO3AFoqM3sT0K7kCuQnhBSKAkczULATjBtrA1u1CjZ72D7w9SM3HAZQCLsm9difuU2MSLbduK6V
 3FdgxaDrrgHGY7cTWqOymYD9O86HbeP3U30aulBtbx49VDWzvxqvVJUiJjVsWVIQZe1x63Uc_oxj
 hkpIhG3hAPTYuCVJg5Hgs0w--
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic301.consmr.mail.ne1.yahoo.com with HTTP; Mon, 14 Mar 2022 18:05:47 +0000
Received: by kubenode540.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 2562d2b35665b249c48437f427993a3d;
          Mon, 14 Mar 2022 18:05:42 +0000 (UTC)
Message-ID: <8adf55db-7bab-f59d-d612-ed906b948d19@schaufler-ca.com>
Date:   Mon, 14 Mar 2022 11:05:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 03/17] io_uring: add infra and support for
 IORING_OP_URING_CMD
Content-Language: en-US
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>, Paul Moore <paul@paul-moore.com>,
        Kanchan Joshi <joshi.k@samsung.com>, jmorris@namei.org,
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
 <92938b01-1746-af70-b325-e098488d8cdf@schaufler-ca.com>
 <Yi9uIqu4MMJzglqC@bombadil.infradead.org>
From:   Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <Yi9uIqu4MMJzglqC@bombadil.infradead.org>
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

On 3/14/2022 9:32 AM, Luis Chamberlain wrote:
> On Mon, Mar 14, 2022 at 09:25:35AM -0700, Casey Schaufler wrote:
>> On 3/11/2022 9:11 AM, Luis Chamberlain wrote:
>>> On Thu, Mar 10, 2022 at 07:43:04PM -0700, Jens Axboe wrote:
>>>> On 3/10/22 6:51 PM, Luis Chamberlain wrote:
>>>>> On Tue, Mar 08, 2022 at 08:50:51PM +0530, Kanchan Joshi wrote:
>>>>>> From: Jens Axboe <axboe@kernel.dk>
>>>>>>
>>>>>> This is a file private kind of request. io_uring doesn't know what's
>>>>>> in this command type, it's for the file_operations->async_cmd()
>>>>>> handler to deal with.
>>>>>>
>>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>>> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
>>>>>> ---
>>>>> <-- snip -->
>>>>>
>>>>>> +static int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
>>>>>> +{
>>>>>> +	struct file *file = req->file;
>>>>>> +	int ret;
>>>>>> +	struct io_uring_cmd *ioucmd = &req->uring_cmd;
>>>>>> +
>>>>>> +	ioucmd->flags |= issue_flags;
>>>>>> +	ret = file->f_op->async_cmd(ioucmd);
>>>>> I think we're going to have to add a security_file_async_cmd() check
>>>>> before this call here. Because otherwise we're enabling to, for
>>>>> example, bypass security_file_ioctl() for example using the new
>>>>> iouring-cmd interface.
>>>>>
>>>>> Or is this already thought out with the existing security_uring_*() stuff?
>>>> Unless the request sets .audit_skip, it'll be included already in terms
>>>> of logging.
>>> Neat.
>>>
>>>> But I'd prefer not to lodge this in with ioctls, unless
>>>> we're going to be doing actual ioctls.
>>> Oh sure, I have been an advocate to ensure folks don't conflate async_cmd
>>> with ioctl. However it *can* enable subsystems to enable ioctl
>>> passthrough, but each of those subsystems need to vet for this on their
>>> own terms. I'd hate to see / hear some LSM surprises later.
>>>
>>>> But definitely something to keep in mind and make sure that we're under
>>>> the right umbrella in terms of auditing and security.
>>> Paul, how about something like this for starters (and probably should
>>> be squashed into this series so its not a separate commit) ?
>>>
>>> >From f3ddbe822374cc1c7002bd795c1ae486d370cbd1 Mon Sep 17 00:00:00 2001
>>> From: Luis Chamberlain <mcgrof@kernel.org>
>>> Date: Fri, 11 Mar 2022 08:55:50 -0800
>>> Subject: [PATCH] lsm,io_uring: add LSM hooks to for the new async_cmd file op
>>>
>>> io-uring is extending the struct file_operations to allow a new
>>> command which each subsystem can use to enable command passthrough.
>>> Add an LSM specific for the command passthrough which enables LSMs
>>> to inspect the command details.
>>>
>>> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
>>> ---
>>>    fs/io_uring.c                 | 5 +++++
>>>    include/linux/lsm_hook_defs.h | 1 +
>>>    include/linux/lsm_hooks.h     | 3 +++
>>>    include/linux/security.h      | 5 +++++
>>>    security/security.c           | 4 ++++
>>>    5 files changed, 18 insertions(+)
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index 3f6eacc98e31..1c4e6b2cb61a 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -4190,6 +4190,11 @@ static int io_uring_cmd_prep(struct io_kiocb *req,
>>>    	struct io_ring_ctx *ctx = req->ctx;
>>>    	struct io_uring_cmd *ioucmd = &req->uring_cmd;
>>>    	u32 ucmd_flags = READ_ONCE(sqe->uring_cmd_flags);
>>> +	int ret;
>>> +
>>> +	ret = security_uring_async_cmd(ioucmd);
>>> +	if (ret)
>>> +		return ret;
>>>    	if (!req->file->f_op->async_cmd)
>>>    		return -EOPNOTSUPP;
>>> diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
>>> index 819ec92dc2a8..4a20f8e6b295 100644
>>> --- a/include/linux/lsm_hook_defs.h
>>> +++ b/include/linux/lsm_hook_defs.h
>>> @@ -404,4 +404,5 @@ LSM_HOOK(int, 0, perf_event_write, struct perf_event *event)
>>>    #ifdef CONFIG_IO_URING
>>>    LSM_HOOK(int, 0, uring_override_creds, const struct cred *new)
>>>    LSM_HOOK(int, 0, uring_sqpoll, void)
>>> +LSM_HOOK(int, 0, uring_async_cmd, struct io_uring_cmd *ioucmd)
>>>    #endif /* CONFIG_IO_URING */
>>> diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
>>> index 3bf5c658bc44..21b18cf138c2 100644
>>> --- a/include/linux/lsm_hooks.h
>>> +++ b/include/linux/lsm_hooks.h
>>> @@ -1569,6 +1569,9 @@
>>>     *      Check whether the current task is allowed to spawn a io_uring polling
>>>     *      thread (IORING_SETUP_SQPOLL).
>>>     *
>>> + * @uring_async_cmd:
>>> + *      Check whether the file_operations async_cmd is allowed to run.
>>> + *
>>>     */
>>>    union security_list_options {
>>>    	#define LSM_HOOK(RET, DEFAULT, NAME, ...) RET (*NAME)(__VA_ARGS__);
>>> diff --git a/include/linux/security.h b/include/linux/security.h
>>> index 6d72772182c8..4d7f72813d75 100644
>>> --- a/include/linux/security.h
>>> +++ b/include/linux/security.h
>>> @@ -2041,6 +2041,7 @@ static inline int security_perf_event_write(struct perf_event *event)
>>>    #ifdef CONFIG_SECURITY
>>>    extern int security_uring_override_creds(const struct cred *new);
>>>    extern int security_uring_sqpoll(void);
>>> +extern int security_uring_async_cmd(struct io_uring_cmd *ioucmd);
>>>    #else
>>>    static inline int security_uring_override_creds(const struct cred *new)
>>>    {
>>> @@ -2050,6 +2051,10 @@ static inline int security_uring_sqpoll(void)
>>>    {
>>>    	return 0;
>>>    }
>>> +static inline int security_uring_async_cmd(struct io_uring_cmd *ioucmd)
>>> +{
>>> +	return 0;
>>> +}
>>>    #endif /* CONFIG_SECURITY */
>>>    #endif /* CONFIG_IO_URING */
>>> diff --git a/security/security.c b/security/security.c
>>> index 22261d79f333..ef96be2f953a 100644
>>> --- a/security/security.c
>>> +++ b/security/security.c
>>> @@ -2640,4 +2640,8 @@ int security_uring_sqpoll(void)
>>>    {
>>>    	return call_int_hook(uring_sqpoll, 0);
>>>    }
>>> +int security_uring_async_cmd(struct io_uring_cmd *ioucmd)
>>> +{
>>> +	return call_int_hook(uring_async_cmd, 0, ioucmd);
>> I don't have a good understanding of what information is in ioucmd.
>> I am afraid that there may not be enough for a security module to
>> make appropriate decisions in all cases. I am especially concerned
>> about the modules that use path hooks, but based on the issues we've
>> always had with ioctl and the like I fear for all cases.
> As Paul pointed out, this particular LSM hook would not be needed if we can
> somehow ensure users of the cmd path use their respective LSMs there. It
> is not easy to force users to have the LSM hook to be used, one idea
> might be to have a registration mechanism which allows users to also
> specify the LSM hook, but these can vary in arguments, so perhaps then
> what is needed is the LSM type in enum form, and internally we have a
> mapping of these. That way we slowly itemize which cmds we *do* allow
> for, thus vetting at the same time a respective LSM hook. Thoughts?

tl;dr - Yuck.

I don't see how your registration mechanism would be easier than
getting "users of the cmd path" to use the LSM mechanism the way
everyone else does. What it would do is pass responsibility for
dealing with LSM to the io_uring core team. Experience has shown
that dealing with the security issues after the fact is much
harder than doing it up front, even when developers wail about
the burden. Sure, LSM is an unpleasant interface/mechanism, but
so is locking, and no one gets away without addressing that.
My $0.02.

>
>    Luis
