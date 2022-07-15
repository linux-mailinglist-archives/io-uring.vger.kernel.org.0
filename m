Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A18C5576881
	for <lists+io-uring@lfdr.de>; Fri, 15 Jul 2022 22:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231536AbiGOUuo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Jul 2022 16:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbiGOUun (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Jul 2022 16:50:43 -0400
Received: from sonic302-28.consmr.mail.ne1.yahoo.com (sonic302-28.consmr.mail.ne1.yahoo.com [66.163.186.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B06590
        for <io-uring@vger.kernel.org>; Fri, 15 Jul 2022 13:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1657918241; bh=3IntVoZ1ZP4kljQWhbi8gsdzdYXhXVpc0k6RFJ+q9Jw=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=HPTyhntHFjIe7izG75BTFzxDSTT1Q/Qgbmw4Jom/VnLP9rNZE0WljjhokRPlLNJzF11LLTSLP485ffxhATtVGdzSlPOFuCyFC8uWtS4xckmXXPVFJwtgLBkSKSaf6+rh9NNkwB7XvkKvdCqOX9z022jy4e458P5ya5VFgoPa4ufkYNuh2t782ZUpyjSnTcTWx1ZStLmo+rNcXS7wS7DCxyhFjR9wdS81OI6P9dOpBFYNlpZeX7WunQp3lYrQ3+zA0tW81hMl7mp/BMQ89z6QmrHQsdJY/DPgP9h6jmtui4/2SOfUYFMRQRg6FRBi/i0hXueap10o2J0uPg9Sy52wpg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1657918241; bh=v2a3olcnfYse/8EOMCl2bFaAtvDt8LWocJqpWCWShyR=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=o+part5a2OFA4kuXcRMc5e2xfl0ioC5GAfZLM14N53fAStwX/V/rPZjRhESzxyNOIEgL0wi5Gmm7MaRvZXPub4ugVjsJxr1pc2/25liWFa77CKI8WPp7U0pUKG0AfroqfHaPQ/hlKkgnodNgQKOGer+nKMkqgO95f9BCfMC7fmeFp4EW+FHb6aIeznP/k0NO/zyQk5r7d6IcV6EdxrwJfLVAv2Y94A9DCfnAGpFApilYJiBIPbHczYxGAKtalyHQK+h3KLhpHgYeYi0i1Mo825On/nYa2iCVrmdk0c4JnYulOevjg4Atog5QA3ebvV0JvaTOmo4b7RXjJdzEgcDqbQ==
X-YMail-OSG: KH8kFYsVM1nMDEWQUIYk6urQaYAcMHGlVaFfrSVYwiljycemj9IgQzNykjydMD1
 BR9R1.J7f_MWwrfLgVuxBCsfywlT.ntuWrkifRe8KKzV.YiFELLtOHQ0tvNmtM1ludUUyhTWL1S9
 qZuU9eLLrJWVRfY7U45lMBHi6w8a5R7D7sUhEr29.gj9NH2F1VbP_KxrieKAZBLfxXuCM8u9Vx1v
 iDG_R98YYa5n8woIEiIQGj2yg0icTLiAEW26iAyW0W611FguZJbkBfCgPz6thn4SnFcRchL4ser6
 nZLG5vvUA__3GdOg9joA81657Vst2z.B67SBa8lnOSQ5sL8eC9QAXxpP_O4axeCs_bnQ.DgG7RcE
 iT4cz1Hp1JUGpZ1FS8FVEN5dCKuf0fhxhzhCasVS_pomMuEj8w05SFGSCfctn9RXrO1OfLNABwmD
 neo7f7qUSXwHPhIMo9K_hDO9VFZOUHQM3T.y4R.69vm0kN2JgbNiYsr_Ps9RMqUxqes7QltjQZFS
 GXrFYnMK5HPMv11T_TG1OayEHWmbSf0YqkdOrapeG2KibjlH_zUSh96SxSJ7yyeEaqvXJF2avD7s
 i7ef69P_n5jYe5gtbsEbU06b3r9huP7hl_0Susa6pSev2Fsalcm9ycDrqmsn0B.S7x3L.vOGxK.j
 U3hFXI93YwCudxlK_OCBECqvEWYeeyjOknQK.zRb224JDmRVkEplrGWdGUqe7feLt3iyIVaijGi0
 pgRdMpqpLiUoBLIp0smxobw6ga1ZXudZqWL3PKvuYxKDytSm2D4htWt.a0x9ezXFlUNQVON1quw_
 NWJZxvkAHl5LlxDy6EnvXTAPX3OZTDco6NnTE0AmkeiIMHWoZg.zXr38vxmd1xmfx419ovi2ZRqM
 G10irusOcZkUegqW_bwrf.p4nsvrbtyScO4t7eaY9jfuKGrMlADB0odFhZmw5dcFf8k7SFpTrxE2
 t0Uk3PNR.axCiUs6OF3aYT5F1cBpVn1TkdGhUO.KtkYzkSDe3yUT8jagBMMFsptgB4TENn6egEjB
 DtKAvHzEXYRH2yMNPyJgADh.LlZ.OZijUK2UC.Qe1V2jnB90Xgc73QoAfUBV69B8.nXf7uCbFSnE
 2KQWW9NuBHb8OpW1Yg7pV_KyEPfyhVl2vi8Cy4tZoh56wv5sQN5Om1lPBenBegXKawTXHxU4xmIH
 Cnbnt2dOGejzVPDhysQMVW36uFRf51Cv7njP0yVfjxAmPTgJigDZEf_HH.R7qKqPnvWJeUd2H8DA
 Jy83saiTC6pHPMEuR4ycoqFMeUr6cuOt5HLd_.SU6zKtNt7GWJoPUELJLO4BNRWaAxGwoIyTOzhN
 QjJXFxuRZ4QT0HiEy_T0ohAcxhurky9ZGgcX3a_wlpQhf4VZhPnmdBJiuKsBkT7VNUecqrwYrpsX
 T.2NY48sR7qp77HifOxS3oQoxOnYkqN1dOIIe2icsMsf4tUgXm09B_exxv8wSIEZ3ZtyrzUntuVo
 zpUgK8nE1Invnof1m8BtONwo39cSX6uAHt1wDbkxTIsF6H6D_8ZQetnvCACrk.G9tpzqHPyqNcQl
 GKc_FSBjGkXNXRzbxcQduZrg6_gXAoMDzp7TRys.s.uuCcJWwKCr0S.9Wd7bAg.HpZqy9QfCpM_P
 FiRiXFDk1hxk.jPiwgeiPKED4pVX6WsO9g0EdCl.rVelgnzDjajVqCI1jkh02m09Qd4ZUbW2vYUj
 _asZyzjJRsKD6Fd77ugcKJmN70dM64s6mpFGJGP3mmGERL4yMUcCm4cBIb_cN_nFK8nQGExL7K8f
 LN4YWjgTbyx8nueqvO8zsNYq9bBF28YHVfMEOfr.7lZf5lvhMUdiL84KssNpsckQkz09RWs7itQx
 YeJyCfeITjdFegReSa.6CkQgyLk5KiTy5ler.ScNw3wej6Z1DLAIgBB3IbMKQ..PHZC0EUubdlap
 shJSsm3m0Sp3oAhknOKrZ2rZ.OEXX_mAybCG90LCepVzIah88f1odX4xgr9JUVoUtXkGM9YvjgC3
 Ubg5mUF2mMD6dGk11anOD03N_2vA6mID7fgg18ZOpEv9hOysSsoqSSciKX6ol42ja_JD1XQ5yR9F
 qtJ5eA3JDmwrfWibC5bp0mhOahCFt5oKOsW8H.elF4ng3SHDuqQ2W4YZGZbHoA6yXzQsCMGxmWux
 nMu02DQFZV9T2.aJ52fLET3aE_5uj_pkbmeCu6DunCq9oniR84DFnMx7712s64FjlT01EKK6B9YT
 EpOmnkom1NLlk2_v2KAWet4hna4DfXD71hbM2U90sUCLEnKT_QNwBceeBEM_S9oq2ZUy9ztSbHZC
 2mvz8kZPzO0aTkmCp3PrjiG7BG19kSaia6531m8s314bjATRLug--
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic302.consmr.mail.ne1.yahoo.com with HTTP; Fri, 15 Jul 2022 20:50:41 +0000
Received: by hermes--production-gq1-56bb98dbc7-8vq2m (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 8f8e719523f4d478154192ec87a78ca5;
          Fri, 15 Jul 2022 20:50:37 +0000 (UTC)
Message-ID: <566af35b-cebb-20a4-99b8-93184f185491@schaufler-ca.com>
Date:   Fri, 15 Jul 2022 13:50:34 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] lsm,io_uring: add LSM hooks to for the new uring_cmd file
 op
Content-Language: en-US
To:     Paul Moore <paul@paul-moore.com>,
        Luis Chamberlain <mcgrof@kernel.org>
Cc:     axboe@kernel.dk, joshi.k@samsung.com,
        linux-security-module@vger.kernel.org, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        a.manzanares@samsung.com, javier@javigon.com,
        casey@schaufler-ca.com
References: <20220714000536.2250531-1-mcgrof@kernel.org>
 <CAHC9VhSjfrMtqy_6+=_=VaCsJKbKU1oj6TKghkue9LrLzO_++w@mail.gmail.com>
 <YtC8Hg1mjL+0mjfl@bombadil.infradead.org>
 <CAHC9VhQMABYKRqZmJQtXai0gtiueU42ENvSUH929=pF6tP9xOg@mail.gmail.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <CAHC9VhQMABYKRqZmJQtXai0gtiueU42ENvSUH929=pF6tP9xOg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.20407 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/15/2022 11:46 AM, Paul Moore wrote:
> On Thu, Jul 14, 2022 at 9:00 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
>> On Wed, Jul 13, 2022 at 11:00:42PM -0400, Paul Moore wrote:
>>> On Wed, Jul 13, 2022 at 8:05 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
>>>> io-uring cmd support was added through ee692a21e9bf ("fs,io_uring:
>>>> add infrastructure for uring-cmd"), this extended the struct
>>>> file_operations to allow a new command which each subsystem can use
>>>> to enable command passthrough. Add an LSM specific for the command
>>>> passthrough which enables LSMs to inspect the command details.
>>>>
>>>> This was discussed long ago without no clear pointer for something
>>>> conclusive, so this enables LSMs to at least reject this new file
>>>> operation.
>>>>
>>>> [0] https://lkml.kernel.org/r/8adf55db-7bab-f59d-d612-ed906b948d19@schaufler-ca.com
>>> [NOTE: I now see that the IORING_OP_URING_CMD has made it into the
>>> v5.19-rcX releases, I'm going to be honest and say that I'm
>>> disappointed you didn't post the related LSM additions
>> It does not mean I didn't ask for them too.
>>
>>> until
>>> v5.19-rc6, especially given our earlier discussions.]
>> And hence since I don't see it either, it's on us now.
> It looks like I owe you an apology, Luis.  While my frustration over
> io_uring remains, along with my disappointment that the io_uring
> developers continue to avoid discussing access controls with the LSM
> community, you are not the author of the IORING_OP_URING_CMD.   You
> are simply trying to do the right thing by adding the necessary LSM
> controls and in my confusion I likely caused you a bit of frustration;
> I'm sorry for that.
>
>> As important as I think LSMs are, I cannot convince everyone
>> to take them as serious as I do.
> Yes, I think a lot of us are familiar with that feeling unfortunately :/
>
>>> While the earlier discussion may not have offered a detailed approach
>>> on how to solve this, I think it was rather conclusive in that the
>>> approach used then (and reproduced here) did not provide enough
>>> context to the LSMs to be able to make a decision.
>> Right...
>>
>>> There were similar
>>> concerns when it came to auditing the command passthrough.  It appears
>>> that most of my concerns in the original thread still apply to this
>>> patch.
>>>
>>> Given the LSM hook in this patch, it is very difficult (impossible?)
>>> to determine the requested operation as these command opcodes are
>>> device/subsystem specific.  The unfortunate result is that the LSMs
>>> are likely going to either allow all, or none, of the commands for a
>>> given device/subsystem, and I think we can all agree that is not a
>>> good idea.
>>>
>>> That is the critical bit of feedback on this patch, but there is more
>>> feedback inline below.
>> Given a clear solution is not easily tangible at this point
>> I was hoping perhaps at least the abilility to enable LSMs to
>> reject uring-cmd would be better than nothing at this point.
> Without any cooperation from the io_uring developers, that is likely
> what we will have to do.  I know there was a lot of talk about this
> functionality not being like another ioctl(), but from a LSM
> perspective I think that is how we will need to treat it.
>
>>>> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
>>>> ---
>>>>  include/linux/lsm_hook_defs.h | 1 +
>>>>  include/linux/lsm_hooks.h     | 3 +++
>>>>  include/linux/security.h      | 5 +++++
>>>>  io_uring/uring_cmd.c          | 5 +++++
>>>>  security/security.c           | 4 ++++
>>>>  5 files changed, 18 insertions(+)
>>> ...
>>>
>>>> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
>>>> index 0a421ed51e7e..5e666aa7edb8 100644
>>>> --- a/io_uring/uring_cmd.c
>>>> +++ b/io_uring/uring_cmd.c
>>>> @@ -3,6 +3,7 @@
>>>>  #include <linux/errno.h>
>>>>  #include <linux/file.h>
>>>>  #include <linux/io_uring.h>
>>>> +#include <linux/security.h>
>>>>
>>>>  #include <uapi/linux/io_uring.h>
>>>>
>>>> @@ -82,6 +83,10 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
>>>>         struct file *file = req->file;
>>>>         int ret;
>>>>
>>>> +       ret = security_uring_cmd(ioucmd);
>>>> +       if (ret)
>>>> +               return ret;
>>>> +
>>>>         if (!req->file->f_op->uring_cmd)
>>>>                 return -EOPNOTSUPP;
>>>>
>>> In order to be consistent with most of the other LSM hooks, the
>>> 'req->file->f_op->uring_cmd' check should come before the LSM hook
>>> call.
>> Sure.
>>
>>> The general approach used in most places is to first validate
>>> the request and do any DAC based access checks before calling into the
>>> LSM.
>> OK.
>>
>> Let me know how you'd like to proceed given our current status.
> Well, we're at -rc6 right now which means IORING_OP_URING_CMD is
> happening and it's unlikely the LSM folks are going to be able to
> influence the design/implementation much at this point so we have to
> do the best we can.  Given the existing constraints, I think your
> patch is reasonable (although please do shift the hook call site down
> a bit as discussed above), we just need to develop the LSM
> implementations to go along with it.
>
> Luis, can you respin and resend the patch with the requested changes?
>
> Casey, it looks like Smack and SELinux are the only LSMs to implement
> io_uring access controls.  Given the hook that Luis developed in this
> patch, could you draft a patch for Smack to add the necessary checks?

Yes. I don't think it will be anything more sophisticated than the
existing "Brutalist" Smack support. It will also be tested to the
limited extent my resources and understanding of io_uring allow.

I am seriously concerned that without better integration between
LSM and io_uring development I'm going to end up in the same place
that led to Al Viro's comment regarding the Smack fcntl hooks:

	"I think I have an adequate flame, but it won't fit
	the maillist size limit..."

That came about because my understanding of fnctl() was incomplete.
I know a lot more about fnctl than I do about io_uring. I would
really like io_uring to work well in a Smack environment. It saddens
me that there isn't any reciporicol interest. But enough whinging.
On to the patch.

> I'll do the same for SELinux.  My initial thinking is that all we can
> really do is check the access between the creds on the current task
> (any overrides will have already taken place by the time the LSM hook
> is called) with the io_uring_cmd:file label/creds; we won't be able to
> provide much permission granularity for all the reasons previously
> discussed, but I suspect that will be more of a SELinux problem than a
> Smack problem (although I suspect Smack will need to treat this as
> both a read and a write, which is likely less than ideal).
>
> I think it's doubtful we will have all of this ready and tested in
> time for v5.19, but I think we can have it ready shortly after that
> and I'll mark all of the patches for -stable when I send them to
> Linus.
>
> I also think we should mark the patches with a 'Fixes:' line that
> points at the IORING_OP_URING_CMD commit, ee692a21e9bf ("fs,io_uring:
> add infrastructure for uring-cmd").
>
> How does that sound to everyone?
>
