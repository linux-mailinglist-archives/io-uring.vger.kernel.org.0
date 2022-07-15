Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEF75576A60
	for <lists+io-uring@lfdr.de>; Sat, 16 Jul 2022 01:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbiGOXF2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Jul 2022 19:05:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231644AbiGOXF1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Jul 2022 19:05:27 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B3138B49A
        for <io-uring@vger.kernel.org>; Fri, 15 Jul 2022 16:05:26 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id s27so5624080pga.13
        for <io-uring@vger.kernel.org>; Fri, 15 Jul 2022 16:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=2OCb/AjcvIH/i3CSjl/5wUiBq9s4xh1r7FaSKY2F5ag=;
        b=DwYYhmRPz2mpTb5dQaE+gHME2xLphwFVBpA1iw8adSenrkBbdmYCdY67Z9+xKbJgcM
         OupMuQxKwNe0AGQHKnVEeUhThV9Y21Ukw1Ge1oAowPMAUjkRD1ylCdeSMNlkU9G9RAlh
         qVk/JWR00g3U+ulOy162JnhojAitaGTjTeatEaakJagPB0IYJzyCKrqsZxSWrXLt/RlD
         VrFbv1j6eGhCP8G1m7VK3bwMK+RDkCjC4s0MdjLX17BjxccRSXTWV0/9m9P8AhPBXtk+
         nfMi5j6z5EEosKyNmgqPqYsDvOxPN0V8kE+p8eXmqtfEJS4Xi0UhSl1H2RwRSEZKdIRQ
         Z9PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2OCb/AjcvIH/i3CSjl/5wUiBq9s4xh1r7FaSKY2F5ag=;
        b=W3KlIfUYQOCMkOhyQUsK3Sk+/W+z89eJzfybKwoaOw2zP86ZFgqD+6jPKNcXfV3eyQ
         P3JtNLWNdZbcCLWcyfBp991u3YXRtE3SHYlXxOg9SnbI39gxL5u0Qs1TdHhWJsKJAE8r
         EaNooRH5do6gaqPFK3X+PW6TFG2LaIOSFqw2gU1AHLtpvBoDkuHPPsK9Op3SV1IPuuvf
         pP9DuwAQUGCYNwbau7bFFQKemtRsNcxvJ37Ghxw7zkUxU9adEfS/YRiWo4x0chQlN1Al
         nBH/RzZN6DNxKk7CUzXcEB+f6sWXDwgiVCwSjcXvcQGBMak9CS9l812ZVVC2vPsg+PCW
         KBsQ==
X-Gm-Message-State: AJIora9mw6OunmNX8a0uP/XDKaAdx5Kt9Jw3+eqDqFlR7IPHsmyX5lXJ
        XAAXDuJZqglDydW9MQm4AAmUVA==
X-Google-Smtp-Source: AGRyM1v0/NMsRi7HgV6tbdxxgF8E1kjSFzz2pS4Hf2zbLAvJN7nRSa4DN5/iC9OJyKn0wKjoAkFHtQ==
X-Received: by 2002:a05:6a00:1806:b0:52a:ec5b:2263 with SMTP id y6-20020a056a00180600b0052aec5b2263mr16587221pfa.1.1657926325503;
        Fri, 15 Jul 2022 16:05:25 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id f4-20020aa79684000000b0052ab764fa78sm4387946pfk.185.2022.07.15.16.05.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Jul 2022 16:05:24 -0700 (PDT)
Message-ID: <4588f798-54d6-311a-fcd2-0d0644829fc2@kernel.dk>
Date:   Fri, 15 Jul 2022 17:05:23 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] lsm,io_uring: add LSM hooks to for the new uring_cmd file
 op
Content-Language: en-US
To:     Casey Schaufler <casey@schaufler-ca.com>,
        Paul Moore <paul@paul-moore.com>,
        Luis Chamberlain <mcgrof@kernel.org>
Cc:     joshi.k@samsung.com, linux-security-module@vger.kernel.org,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, a.manzanares@samsung.com,
        javier@javigon.com
References: <20220714000536.2250531-1-mcgrof@kernel.org>
 <CAHC9VhSjfrMtqy_6+=_=VaCsJKbKU1oj6TKghkue9LrLzO_++w@mail.gmail.com>
 <YtC8Hg1mjL+0mjfl@bombadil.infradead.org>
 <CAHC9VhQMABYKRqZmJQtXai0gtiueU42ENvSUH929=pF6tP9xOg@mail.gmail.com>
 <566af35b-cebb-20a4-99b8-93184f185491@schaufler-ca.com>
 <e9cd6c3a-0658-c770-e403-9329b8e9d841@schaufler-ca.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <e9cd6c3a-0658-c770-e403-9329b8e9d841@schaufler-ca.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/15/22 5:03 PM, Casey Schaufler wrote:
> On 7/15/2022 1:50 PM, Casey Schaufler wrote:
>> On 7/15/2022 11:46 AM, Paul Moore wrote:
>>> On Thu, Jul 14, 2022 at 9:00 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
>>>> On Wed, Jul 13, 2022 at 11:00:42PM -0400, Paul Moore wrote:
>>>>> On Wed, Jul 13, 2022 at 8:05 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
>>>>>> io-uring cmd support was added through ee692a21e9bf ("fs,io_uring:
>>>>>> add infrastructure for uring-cmd"), this extended the struct
>>>>>> file_operations to allow a new command which each subsystem can use
>>>>>> to enable command passthrough. Add an LSM specific for the command
>>>>>> passthrough which enables LSMs to inspect the command details.
>>>>>>
>>>>>> This was discussed long ago without no clear pointer for something
>>>>>> conclusive, so this enables LSMs to at least reject this new file
>>>>>> operation.
>>>>>>
>>>>>> [0] https://lkml.kernel.org/r/8adf55db-7bab-f59d-d612-ed906b948d19@schaufler-ca.com
>>>>> [NOTE: I now see that the IORING_OP_URING_CMD has made it into the
>>>>> v5.19-rcX releases, I'm going to be honest and say that I'm
>>>>> disappointed you didn't post the related LSM additions
>>>> It does not mean I didn't ask for them too.
>>>>
>>>>> until
>>>>> v5.19-rc6, especially given our earlier discussions.]
>>>> And hence since I don't see it either, it's on us now.
>>> It looks like I owe you an apology, Luis.  While my frustration over
>>> io_uring remains, along with my disappointment that the io_uring
>>> developers continue to avoid discussing access controls with the LSM
>>> community, you are not the author of the IORING_OP_URING_CMD.   You
>>> are simply trying to do the right thing by adding the necessary LSM
>>> controls and in my confusion I likely caused you a bit of frustration;
>>> I'm sorry for that.
>>>
>>>> As important as I think LSMs are, I cannot convince everyone
>>>> to take them as serious as I do.
>>> Yes, I think a lot of us are familiar with that feeling unfortunately :/
>>>
>>>>> While the earlier discussion may not have offered a detailed approach
>>>>> on how to solve this, I think it was rather conclusive in that the
>>>>> approach used then (and reproduced here) did not provide enough
>>>>> context to the LSMs to be able to make a decision.
>>>> Right...
>>>>
>>>>> There were similar
>>>>> concerns when it came to auditing the command passthrough.  It appears
>>>>> that most of my concerns in the original thread still apply to this
>>>>> patch.
>>>>>
>>>>> Given the LSM hook in this patch, it is very difficult (impossible?)
>>>>> to determine the requested operation as these command opcodes are
>>>>> device/subsystem specific.  The unfortunate result is that the LSMs
>>>>> are likely going to either allow all, or none, of the commands for a
>>>>> given device/subsystem, and I think we can all agree that is not a
>>>>> good idea.
>>>>>
>>>>> That is the critical bit of feedback on this patch, but there is more
>>>>> feedback inline below.
>>>> Given a clear solution is not easily tangible at this point
>>>> I was hoping perhaps at least the abilility to enable LSMs to
>>>> reject uring-cmd would be better than nothing at this point.
>>> Without any cooperation from the io_uring developers, that is likely
>>> what we will have to do.  I know there was a lot of talk about this
>>> functionality not being like another ioctl(), but from a LSM
>>> perspective I think that is how we will need to treat it.
>>>
>>>>>> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
>>>>>> ---
>>>>>>  include/linux/lsm_hook_defs.h | 1 +
>>>>>>  include/linux/lsm_hooks.h     | 3 +++
>>>>>>  include/linux/security.h      | 5 +++++
>>>>>>  io_uring/uring_cmd.c          | 5 +++++
>>>>>>  security/security.c           | 4 ++++
>>>>>>  5 files changed, 18 insertions(+)
>>>>> ...
>>>>>
>>>>>> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
>>>>>> index 0a421ed51e7e..5e666aa7edb8 100644
>>>>>> --- a/io_uring/uring_cmd.c
>>>>>> +++ b/io_uring/uring_cmd.c
>>>>>> @@ -3,6 +3,7 @@
>>>>>>  #include <linux/errno.h>
>>>>>>  #include <linux/file.h>
>>>>>>  #include <linux/io_uring.h>
>>>>>> +#include <linux/security.h>
>>>>>>
>>>>>>  #include <uapi/linux/io_uring.h>
>>>>>>
>>>>>> @@ -82,6 +83,10 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
>>>>>>         struct file *file = req->file;
>>>>>>         int ret;
>>>>>>
>>>>>> +       ret = security_uring_cmd(ioucmd);
>>>>>> +       if (ret)
>>>>>> +               return ret;
>>>>>> +
>>>>>>         if (!req->file->f_op->uring_cmd)
>>>>>>                 return -EOPNOTSUPP;
>>>>>>
>>>>> In order to be consistent with most of the other LSM hooks, the
>>>>> 'req->file->f_op->uring_cmd' check should come before the LSM hook
>>>>> call.
>>>> Sure.
>>>>
>>>>> The general approach used in most places is to first validate
>>>>> the request and do any DAC based access checks before calling into the
>>>>> LSM.
>>>> OK.
>>>>
>>>> Let me know how you'd like to proceed given our current status.
>>> Well, we're at -rc6 right now which means IORING_OP_URING_CMD is
>>> happening and it's unlikely the LSM folks are going to be able to
>>> influence the design/implementation much at this point so we have to
>>> do the best we can.  Given the existing constraints, I think your
>>> patch is reasonable (although please do shift the hook call site down
>>> a bit as discussed above), we just need to develop the LSM
>>> implementations to go along with it.
>>>
>>> Luis, can you respin and resend the patch with the requested changes?
>>>
>>> Casey, it looks like Smack and SELinux are the only LSMs to implement
>>> io_uring access controls.  Given the hook that Luis developed in this
>>> patch, could you draft a patch for Smack to add the necessary checks?
>> Yes. I don't think it will be anything more sophisticated than the
>> existing "Brutalist" Smack support. It will also be tested to the
>> limited extent my resources and understanding of io_uring allow.
>>
>> I am seriously concerned that without better integration between
>> LSM and io_uring development I'm going to end up in the same place
>> that led to Al Viro's comment regarding the Smack fcntl hooks:
>>
>> 	"I think I have an adequate flame, but it won't fit
>> 	the maillist size limit..."
>>
>> That came about because my understanding of fnctl() was incomplete.
>> I know a lot more about fnctl than I do about io_uring. I would
>> really like io_uring to work well in a Smack environment. It saddens
>> me that there isn't any reciporicol interest. But enough whinging.
>> On to the patch.
> 
> There isn't (as of this writing) a file io_uring/uring_cmd.c in
> Linus' tree. What tree does this patch apply to?

It's the for-5.20 tree. See my reply to the v2 of the patch, including
suggestions on how to stage it.

-- 
Jens Axboe

