Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7486E347C
	for <lists+io-uring@lfdr.de>; Sun, 16 Apr 2023 01:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbjDOXR5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Apr 2023 19:17:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjDOXR5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Apr 2023 19:17:57 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2ADB269A
        for <io-uring@vger.kernel.org>; Sat, 15 Apr 2023 16:17:51 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id gw13so12009086wmb.3
        for <io-uring@vger.kernel.org>; Sat, 15 Apr 2023 16:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681600670; x=1684192670;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S8Ad65/24k33EceRdX9NVRsSl7CTilimFOqZF6zUWgE=;
        b=X2zFJNDZhXNIaAutBg1uVbY3IRn3rfQ41cfCHTzeUIdJHdqu2XM9uuANqgpoRcwC2k
         7colH0umkel5ojnJ6Fn41GYrMb/5WK124TBHp7FBynlfgYS2C06jyT4y02qffNNXjui5
         O48CjdCxXtsu8n0hC7xKNHWvdMCWIobfh3Cf3f7MsKpWQLILf8ocQNvlBAYN6HcNMCkl
         qaKqn93piomc/bUGjUETY2dQcXwVfZbCv22vRkJwMyD8/4wjB3XYrQ8x2yGhQl2amTsE
         3+wmR+Q0xp1c6qSbWUzL67ghVDcZFoceBfpEi3AZBvMWEGFzHfSv4ZgA5RQVHx6xu3Yy
         EB1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681600670; x=1684192670;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S8Ad65/24k33EceRdX9NVRsSl7CTilimFOqZF6zUWgE=;
        b=Txcu3rEL8ixXElOBKcsCuQiswtv0l0HS5qgnP1DZ3TBRquOjBAF2LrqNxWC4gcgC+X
         4HOEbDAsnhjLkY0fc073xqKvlUVaydNhT3IfxJ2J8pkaDL2EDOveMlPWP78jRFAEIMY5
         c+rGYKbSKYpWmqsBW71UkkRSANEpLzM9RL5FLH+JQZSr5KVN/RFFyU5ole/c+RKpqIlQ
         2AX5UCu6SZo3hTRjS7ccNRz91RNKDpZKbnR7YvNuhNonf/S8BOKBlsNHYUG60a+9VU/l
         lWKVQzJBlfrRx8aUcmuqI2zAdTKRmjAIv0suKR02Po4XHqQoxjykD3mrq/FkJd8gaIT9
         mvUw==
X-Gm-Message-State: AAQBX9fmzfpH35r7yU9nP6mpjEMAYNcPkNflGiEkV5h/0shIbhBMLNx5
        RDm3E+uftSiNMmjoYgU/Jew=
X-Google-Smtp-Source: AKy350aKWeZqiOSqw4YT6CZA1eaFblKcRBXS6jzWAk8SWNdRrNIqgPt0fMBb8QhlUoIN6oX8FjWJ9Q==
X-Received: by 2002:a7b:c4c1:0:b0:3ed:ec34:f1 with SMTP id g1-20020a7bc4c1000000b003edec3400f1mr7349194wmk.35.1681600669651;
        Sat, 15 Apr 2023 16:17:49 -0700 (PDT)
Received: from [192.168.8.100] (188.28.98.134.threembb.co.uk. [188.28.98.134])
        by smtp.gmail.com with ESMTPSA id j15-20020a5d564f000000b002f7780eee10sm3994189wrw.59.2023.04.15.16.17.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Apr 2023 16:17:49 -0700 (PDT)
Message-ID: <40e9fc19-7dc4-fe5e-ec08-66af269d5b03@gmail.com>
Date:   Sun, 16 Apr 2023 00:15:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH] io_uring: complete request via task work in case of
 DEFER_TASKRUN
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Kanchan Joshi <joshi.k@samsung.com>
References: <20230414075313.373263-1-ming.lei@redhat.com>
 <68ddddc0-fb0e-47b4-9318-9dd549d851a1@gmail.com>
 <ZDlay1++tidiKv+n@ovpn-8-21.pek2.redhat.com>
 <9d5d57ec-c76a-754b-1f33-7557b2443d5c@gmail.com>
 <ZDl0gXfxR+W9luej@ovpn-8-21.pek2.redhat.com>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZDl0gXfxR+W9luej@ovpn-8-21.pek2.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/14/23 16:42, Ming Lei wrote:
> On Fri, Apr 14, 2023 at 04:07:52PM +0100, Pavel Begunkov wrote:
>> On 4/14/23 14:53, Ming Lei wrote:
>>> On Fri, Apr 14, 2023 at 02:01:26PM +0100, Pavel Begunkov wrote:
>>>> On 4/14/23 08:53, Ming Lei wrote:
>>>>> So far io_req_complete_post() only covers DEFER_TASKRUN by completing
>>>>> request via task work when the request is completed from IOWQ.
>>>>>
>>>>> However, uring command could be completed from any context, and if io
>>>>> uring is setup with DEFER_TASKRUN, the command is required to be
>>>>> completed from current context, otherwise wait on IORING_ENTER_GETEVENTS
>>>>> can't be wakeup, and may hang forever.
>>>>
>>>> fwiw, there is one legit exception, when the task is half dead
>>>> task_work will be executed by a kthread. It should be fine as it
>>>> locks the ctx down, but I can't help but wonder whether it's only
>>>> ublk_cancel_queue() affected or there are more places in ublk?
>>>
>>> No, it isn't.
>>>
>>> It isn't triggered on nvme-pt just because command is always done
>>> in task context.
>>>
>>> And we know more uring command cases are coming.
>>
>> Because all requests and cmds but ublk complete it from another
>> task, ublk is special in this regard.
> 
> Not sure it is true, cause it is allowed to call io_uring_cmd_done from other
> task technically. And it could be more friendly for driver to not limit
> its caller in the task context. Especially we have another API of
> io_uring_cmd_complete_in_task().

I agree that the cmd io_uring API can do better.


>> I have several more not so related questions:
>>
>> 1) Can requests be submitted by some other task than ->ubq_daemon?
> 
> Yeah, requests can be submitted by other task, but ublk driver doesn't
> allow it because ublk driver has not knowledge when the io_uring context
> goes away, so has to limit requests submitted from ->ubq_daemon only,
> then use this task's information for checking if the io_uring context
> is going to exit. When the io_uring context is dying, we need to
> abort these uring commands(may never complete), see ublk_cancel_queue().
> 
> The only difference is that the uring command may never complete,
> because one uring cmd is only completed when the associated block request
> is coming. The situation could be improved by adding API/callback for
> notifying io_uring exit.

Got it. And it sounds like you can use IORING_SETUP_SINGLE_ISSUER
and possibly IORING_SETUP_DEFER_TASKRUN, if not already.


>> Looking at
>>
>> static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
>> {
>>      ...
>>      if (ubq->ubq_daemon && ubq->ubq_daemon != current)
>>         goto out;
>> }
>>
>> ublk_queue_cmd() avoiding io_uring way of delivery and using
>> raw task_work doesn't seem great. Especially with TWA_SIGNAL_NO_IPI.
> 
> Yeah, it has been in my todo list to kill task work. In ublk early time,

I see

> task work just performs better than io_uring_cmd_complete_in_task(), but
> the gap becomes pretty small or even not visible now.

It seems a bit strange, non DEFER_TASKRUN tw is almost identical to what
you do, see __io_req_task_work_add(). Maybe it's extra callbacks on the
execution side.

Did you try DEFER_TASKRUN? Not sure it suits your case as there are
limitations, but the queueing side of it, as well as execution and
waiting are well optimised and should do better.


>> 2) What the purpose of the two lines below? I see how
>> UBLK_F_URING_CMD_COMP_IN_TASK is used, but don't understand
>> why it changes depending on whether it's a module or not.
> 
> task work isn't available in case of building ublk as module.

Ah, makes sense now, thanks

>> 3) The long comment in ublk_queue_cmd() seems quite scary.
>> If you have a cmd / io_uring request it hold a ctx reference
>> and is always allowed to use io_uring's task_work infra like
>> io_uring_cmd_complete_in_task(). Why it's different for ublk?
> 
> The thing is that we don't know if there is io_uring request for the
> coming blk request. UBLK_IO_FLAG_ABORTED just means that the io_uring
> context is dead, and we can't use io_uring_cmd_complete_in_task() any
> more.

Roughly got it, IIUC, there might not be a (valid) io_uring
request backing this block request in the first place because of
this aborting thing.


>>>> One more thing, cmds should not be setting issue_flags but only
>>>> forwarding what the core io_uring code passed, it'll get tons of
>>>> bugs in no time otherwise.
>>>
>>> Here io_uring_cmd_done() is changed to this way recently, and it
>>> could be another topic.
>>
>> And it's abused, but as you said, not particularly related
>> to this patch.
>>
>>
>>>> static void ublk_cancel_queue(struct ublk_queue *ubq)
>>>> {
>>>>       ...
>>>>       io_uring_cmd_done(io->cmd, UBLK_IO_RES_ABORT, 0,
>>>>                         IO_URING_F_UNLOCKED);
>>>> }
>>>>
>>>> Can we replace it with task_work? It should be cold, and I
>>>> assume ublk_cancel_queue() doesn't assume that all requests will
>>>> put down by the end of the function as io_uring_cmd_done()
>>>> can offload it in any case.
>>>
>>> But it isn't specific for ublk, any caller of io_uring_cmd_done()
>>> has such issue since io_uring_cmd_done() is one generic API.
>>
>> Well, fair enough, considering that IO_URING_F_UNLOCKED was
>> just added (*still naively hoping it'll be clean up*)
> 
> IMO, it is reasonable for io_uring_cmd_done to hide any io_uring
> implementation details, even the task context concept, but not
> sure if it is doable.

I agree that there should be a function doing the right thing
without extra flags, i.e. completing via tw, and there should
also be a helper for more advanced performant cases like when
we know the context.

-- 
Pavel Begunkov
