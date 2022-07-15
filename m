Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 365CE576A56
	for <lists+io-uring@lfdr.de>; Sat, 16 Jul 2022 01:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbiGOXDd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Jul 2022 19:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbiGOXDc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Jul 2022 19:03:32 -0400
Received: from sonic302-28.consmr.mail.ne1.yahoo.com (sonic302-28.consmr.mail.ne1.yahoo.com [66.163.186.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C18957239
        for <io-uring@vger.kernel.org>; Fri, 15 Jul 2022 16:03:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1657926210; bh=7acY8nY5PAfn8wFPIYdKjJZmWT6XwXpnZPJryEnknQU=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=bjI/R/Nzqf7t5jVzfrTWss803jTTGmPcQPrJcaXsIRK13L8MAhfXi6nWJaCOL3RBjFbgwvxwKCweuX+fq+AaDaSDd4PfhRIi7EPp/2xlLhGEQV4xmHnvkRniDhxJGCdzVD9n+bdxwy19x+n1gcEqNKQNbyXlTAa7ZITvdMmNMbYhJ/bHLkEGHI1aoPkv/+cNf1OehGavq8ZJpY9BXA1QPVVS/9QC0ls4eP1NloiGmnPNx0aDwvQN2AKEQ/90MnHnCjwouMbhFNNK4pEXSI4pwZOEcxQw7iTMBuHU1Z9kItPWQlfmakAUJ0LX3kpJZKJW0N3jyk5FgC4g7bBqxTW03A==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1657926210; bh=ibkZ3YMejSaM4Tbkifc0stTOuOVQZ6XKuNR+rVLHs11=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=YuWqzb6pgeat8u8Z61jj/5wLNr3A+hi7Za2C/bGj/VgeB+4WVf1RQWj+BdWhbHUfbr4oi2TzfXmpCUFxBDloP0HqLDbDvpGrfeR5TB2WbEUzIZ3sxqphMqFser9d0O1y/VPD9YGRAswtv5fWp5yQ/CcRClfY4m+JqDK/prh3WpOXllTjQCaLIOmTm6OrARngx1CLemw8lDTJF/yG+O8Sxl8rZHN7ZoQMSh53f6mau043+t4x81jjcioe2upk2rQPp9nrPR/oGFO9OHLEDRr6YZshQrGQTCrfPbc3myDzMfuKBH4c2xfbiSe+4VIImP5+cPznXWWhkC1pwzxxVI7MxQ==
X-YMail-OSG: fsC3LvAVM1kqdcGDU_SEzLV5KAzsNcxA49TI2xJShOT5nGl0zZxt6LzE9mt5dEM
 dYHil.8yP_dKNCXHop6HUbgC.JYZjQBGMUZyAscHHuV2Fd3rtfJReATsf4xw_3Cu21EvvKJ6LvuR
 GPieMLf8c6HvIglYnkpPW5RwfQgYgsZfkCkwZVJjaQWz5nFK1C.LD7s8xHEOYmjzMsj_DQEIqzLp
 YuU0vQl_Q5_TAMSc66kRsQGyCsRiEXqxVTMFG3fALespU.2Zcwf9oQFbz.1_RDmlyMd6wTWHRP6G
 PqdM4frMlceBFdtQtOjD7ZAkypZl119Okt4tAsOMZ.2ESkl4_zDp.OTA1aYTHJJCgkyXxoH7AXaX
 XOTcAcZT7hpIe_HQ4gCNLwOjrHCLtTloJvGcO5Q4sbS5aHwYIfO_jpkCdbokDRqIs0iFXYgBhZXA
 lu8Yz9HhxuzFNsTEPcdTI_XC1iC6fK43VSynQ5nvMmpQVfS12WGzJuYITX1I7oPcRC4dcDX7vIQY
 fDKMvFI30C4hvgrlseWzw.mstT37_9s38_WdLB4gmjq78il1vbi.caTnGyPgB7IGDYZXI8HG3Idj
 qRj6LujOA2VfNxUpthv7WYYZmORKbb9blXvepP.QaC6v_87p1AW1wB_tuQWNLsFNawowvFp7Wlue
 rxBini2ZohmfhMqjOjyNTrefomNEyWKFkdwQqHSK5zCX_CiGo6xZm6WyHwdEMH4zxloKQFt_MsVa
 DgcaTDjhsQfA24Cc.4UU0ohVrZmirp9GC0vsSynQMsGvCL21TI3e4WFbnxGbnKwl6Oichh613TBb
 .CwpSjbqBZb6T6H.jdI1KnPa2xua9ncSbBiNcLUzHSJdlquPIeomn2hveVtntJHg16kKRjS0MrkY
 z1ikDqwE1I9qMjdzFxr47rPBRpnMelDInFcaf8XuWyuMR3a9Pjdfzw8QUUQ2ZtXHA5svHd0WqKJr
 vhvn.eBQgL7UyZz.ad8OpkFPXLJvA9beVhiSpZZB.JbVV4cI3mzQtmlcfPw2EksiYULoAXAKTK77
 vpm4C4pAn5Pe7.0oHTWsqRvKoD2EDZGURkUxxCm429Mm50TUruqEPlVeym.11l5YEUOrQ6mqY0TW
 tGH8txLKGYNA0WcEcjLwciXeDeFRXeA0zlN13MpQrQT2Wp91eqIEWxrg9yE4MYUF_X1lkPLPOH7l
 v88mCHgbNKjFoJJa516AZbOV2brg5hru87v213GfKUNIHiPvEQpzuBKtLCyMi2DaOIa8.Jft..kZ
 Oa7Ar0qp4Sd3bfgF_5PtbjlcKbAsVenpTWPeFVc2oBL5oF30lM_ZCFoJypkNjEsCFv_ApxPialOP
 8FvjPC8FO5tXIqlM9YgpEFRsTMtLuCYuE7MSiDAeOEACwPHXijw3QiRW_hgY8yr26UxgrimaJNGh
 3WFjBo4OJnfauEVqAbXBjo.gxrvmkTotalzERXIZhTC2sUwG1Ch6o2Ad1_pQ382vK68OxUjVgP36
 udSNuidlmee8Ct9xVlABzpHWehPWU5yms5v5.W1_7Ugbm2vLhm4QHelmJzM4sHUfLb5Hlfm1CaM3
 E72fGYyHf3gsMplQk368sqcI9tLTvTxeMA40H7D_HAHt4v9QRIzJ1x.F7UqZ_wZWuy8cvaCHuPr3
 WUggTqivXnpPP172HQW8N4Nz0r0x.THPRLSia2.KLUJXc9mLAbyagIVYIH4da2HlPFvG7qUg3pIn
 U6lWpqF5xwuR3soDEwPCC2.mb4QtCB_EeJ33Eu1oqcpZg626lKuUgx6KzbrZ3FMosIdoVPAKj6MN
 IhqS90WbfxCwR3TfrcVGRLVSLNNmQACzRLemtK.C66MBvzul2khKMAlviC1OhOV0GCo9moioKEZQ
 Ljwipy6uEpKdv0X1ADWTrrBWFjGzvVdRnpNKEbE2gYDz49f_xDTEbNZFvrd3Z6Ht9LnD1iZB291L
 OCRQmEUiRV.lE13ItpvnPDaOIfB6mah4hEBjvfMg1Wt5XtVjCywY2WtwEpXMuiELRuR6IIZ2_XxV
 qBEbw5329FPmEmhojbxijIajLvQKWH07acQcol5hzloSt0GuPULIbtKRtnAaQ5M6LiWzljoOqHnX
 DcKTg3g82lYE50d.bUcnxH59sFg5L.e6QHT35gM4grx7eNzlerPZNceQqX.EtJs2Y1YTfu1dh_tT
 q6FBQ8Dtjkzyv3g2hYtFa0SiifiNiJ1A1..umZdM4qWFYaB_wphcPaYq3mvfJ9iQ1fhwk0Wn2ZhX
 uA7YSDu_9N7PYb73LjK8kDxpuzcSMnVaV8y4VgdMWu5QnD3WFPtWHoB7cNnoWhmA85.nZ72LyIO2
 4Fg7WLKGVSm.cqVgSdqakKg37
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic302.consmr.mail.ne1.yahoo.com with HTTP; Fri, 15 Jul 2022 23:03:30 +0000
Received: by hermes--production-gq1-56bb98dbc7-5q5vp (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 5cb88f1fd4f551ec8deb39651e90b07d;
          Fri, 15 Jul 2022 23:03:25 +0000 (UTC)
Message-ID: <e9cd6c3a-0658-c770-e403-9329b8e9d841@schaufler-ca.com>
Date:   Fri, 15 Jul 2022 16:03:24 -0700
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
        a.manzanares@samsung.com, javier@javigon.com
References: <20220714000536.2250531-1-mcgrof@kernel.org>
 <CAHC9VhSjfrMtqy_6+=_=VaCsJKbKU1oj6TKghkue9LrLzO_++w@mail.gmail.com>
 <YtC8Hg1mjL+0mjfl@bombadil.infradead.org>
 <CAHC9VhQMABYKRqZmJQtXai0gtiueU42ENvSUH929=pF6tP9xOg@mail.gmail.com>
 <566af35b-cebb-20a4-99b8-93184f185491@schaufler-ca.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <566af35b-cebb-20a4-99b8-93184f185491@schaufler-ca.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.20407 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/15/2022 1:50 PM, Casey Schaufler wrote:
> On 7/15/2022 11:46 AM, Paul Moore wrote:
>> On Thu, Jul 14, 2022 at 9:00 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
>>> On Wed, Jul 13, 2022 at 11:00:42PM -0400, Paul Moore wrote:
>>>> On Wed, Jul 13, 2022 at 8:05 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
>>>>> io-uring cmd support was added through ee692a21e9bf ("fs,io_uring:
>>>>> add infrastructure for uring-cmd"), this extended the struct
>>>>> file_operations to allow a new command which each subsystem can use
>>>>> to enable command passthrough. Add an LSM specific for the command
>>>>> passthrough which enables LSMs to inspect the command details.
>>>>>
>>>>> This was discussed long ago without no clear pointer for something
>>>>> conclusive, so this enables LSMs to at least reject this new file
>>>>> operation.
>>>>>
>>>>> [0] https://lkml.kernel.org/r/8adf55db-7bab-f59d-d612-ed906b948d19@schaufler-ca.com
>>>> [NOTE: I now see that the IORING_OP_URING_CMD has made it into the
>>>> v5.19-rcX releases, I'm going to be honest and say that I'm
>>>> disappointed you didn't post the related LSM additions
>>> It does not mean I didn't ask for them too.
>>>
>>>> until
>>>> v5.19-rc6, especially given our earlier discussions.]
>>> And hence since I don't see it either, it's on us now.
>> It looks like I owe you an apology, Luis.  While my frustration over
>> io_uring remains, along with my disappointment that the io_uring
>> developers continue to avoid discussing access controls with the LSM
>> community, you are not the author of the IORING_OP_URING_CMD.   You
>> are simply trying to do the right thing by adding the necessary LSM
>> controls and in my confusion I likely caused you a bit of frustration;
>> I'm sorry for that.
>>
>>> As important as I think LSMs are, I cannot convince everyone
>>> to take them as serious as I do.
>> Yes, I think a lot of us are familiar with that feeling unfortunately :/
>>
>>>> While the earlier discussion may not have offered a detailed approach
>>>> on how to solve this, I think it was rather conclusive in that the
>>>> approach used then (and reproduced here) did not provide enough
>>>> context to the LSMs to be able to make a decision.
>>> Right...
>>>
>>>> There were similar
>>>> concerns when it came to auditing the command passthrough.  It appears
>>>> that most of my concerns in the original thread still apply to this
>>>> patch.
>>>>
>>>> Given the LSM hook in this patch, it is very difficult (impossible?)
>>>> to determine the requested operation as these command opcodes are
>>>> device/subsystem specific.  The unfortunate result is that the LSMs
>>>> are likely going to either allow all, or none, of the commands for a
>>>> given device/subsystem, and I think we can all agree that is not a
>>>> good idea.
>>>>
>>>> That is the critical bit of feedback on this patch, but there is more
>>>> feedback inline below.
>>> Given a clear solution is not easily tangible at this point
>>> I was hoping perhaps at least the abilility to enable LSMs to
>>> reject uring-cmd would be better than nothing at this point.
>> Without any cooperation from the io_uring developers, that is likely
>> what we will have to do.  I know there was a lot of talk about this
>> functionality not being like another ioctl(), but from a LSM
>> perspective I think that is how we will need to treat it.
>>
>>>>> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
>>>>> ---
>>>>>  include/linux/lsm_hook_defs.h | 1 +
>>>>>  include/linux/lsm_hooks.h     | 3 +++
>>>>>  include/linux/security.h      | 5 +++++
>>>>>  io_uring/uring_cmd.c          | 5 +++++
>>>>>  security/security.c           | 4 ++++
>>>>>  5 files changed, 18 insertions(+)
>>>> ...
>>>>
>>>>> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
>>>>> index 0a421ed51e7e..5e666aa7edb8 100644
>>>>> --- a/io_uring/uring_cmd.c
>>>>> +++ b/io_uring/uring_cmd.c
>>>>> @@ -3,6 +3,7 @@
>>>>>  #include <linux/errno.h>
>>>>>  #include <linux/file.h>
>>>>>  #include <linux/io_uring.h>
>>>>> +#include <linux/security.h>
>>>>>
>>>>>  #include <uapi/linux/io_uring.h>
>>>>>
>>>>> @@ -82,6 +83,10 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
>>>>>         struct file *file = req->file;
>>>>>         int ret;
>>>>>
>>>>> +       ret = security_uring_cmd(ioucmd);
>>>>> +       if (ret)
>>>>> +               return ret;
>>>>> +
>>>>>         if (!req->file->f_op->uring_cmd)
>>>>>                 return -EOPNOTSUPP;
>>>>>
>>>> In order to be consistent with most of the other LSM hooks, the
>>>> 'req->file->f_op->uring_cmd' check should come before the LSM hook
>>>> call.
>>> Sure.
>>>
>>>> The general approach used in most places is to first validate
>>>> the request and do any DAC based access checks before calling into the
>>>> LSM.
>>> OK.
>>>
>>> Let me know how you'd like to proceed given our current status.
>> Well, we're at -rc6 right now which means IORING_OP_URING_CMD is
>> happening and it's unlikely the LSM folks are going to be able to
>> influence the design/implementation much at this point so we have to
>> do the best we can.  Given the existing constraints, I think your
>> patch is reasonable (although please do shift the hook call site down
>> a bit as discussed above), we just need to develop the LSM
>> implementations to go along with it.
>>
>> Luis, can you respin and resend the patch with the requested changes?
>>
>> Casey, it looks like Smack and SELinux are the only LSMs to implement
>> io_uring access controls.  Given the hook that Luis developed in this
>> patch, could you draft a patch for Smack to add the necessary checks?
> Yes. I don't think it will be anything more sophisticated than the
> existing "Brutalist" Smack support. It will also be tested to the
> limited extent my resources and understanding of io_uring allow.
>
> I am seriously concerned that without better integration between
> LSM and io_uring development I'm going to end up in the same place
> that led to Al Viro's comment regarding the Smack fcntl hooks:
>
> 	"I think I have an adequate flame, but it won't fit
> 	the maillist size limit..."
>
> That came about because my understanding of fnctl() was incomplete.
> I know a lot more about fnctl than I do about io_uring. I would
> really like io_uring to work well in a Smack environment. It saddens
> me that there isn't any reciporicol interest. But enough whinging.
> On to the patch.

There isn't (as of this writing) a file io_uring/uring_cmd.c in
Linus' tree. What tree does this patch apply to?

