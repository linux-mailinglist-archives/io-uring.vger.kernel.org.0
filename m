Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 862FD5F6FF7
	for <lists+io-uring@lfdr.de>; Thu,  6 Oct 2022 23:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232098AbiJFVLv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Oct 2022 17:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231778AbiJFVLu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Oct 2022 17:11:50 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F696B0B20
        for <io-uring@vger.kernel.org>; Thu,  6 Oct 2022 14:11:49 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id y17so1622547ilq.8
        for <io-uring@vger.kernel.org>; Thu, 06 Oct 2022 14:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DNXMPcCvyb4tDQhefwCaZ0RhAMU1/HBjRRwB/lPyQ+o=;
        b=mN6ufcOwGltl76v9hRwZwz/RL0Kaqogk8mtV1aZCD9kRPryj4M0DRUF+Vl+HJlotWt
         vFy/Nyf/tA4ThpELcrD245tZg1EKefEQuR0zGJK7edUzYy0izBGveDrNabDYO0jERptZ
         ZAoE2yzN7ZQbzKSIyq7VrzuZTLZ/X4bbgHnJOcbCizjpDhrD4AeEcmR+5PLf0YXv01gT
         EICi8rdywEh/lNmNtrRaBXgObNqqAn9Y590sW/nke78/t7gUhBkMHEbww1/DsmxldfHx
         0tuSs5aKWjYvzPrAgOBReMua4RABmvE6GqmPPlqzo/NREST8oz3WmCI3242q6VfI8mI5
         jZUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DNXMPcCvyb4tDQhefwCaZ0RhAMU1/HBjRRwB/lPyQ+o=;
        b=Bkvo/YlgZ9pMX25Ae0yGfh4MoM494h3nk0j5HUaPoy4o9GEnDCggfKITeukCgybNkT
         ULwrZc124R+vDGhQVQXNE08IoWb50/4qRSl7RNPTVUTbY6HBDyqD2dSjTizpAoKG6Mj2
         ldDxsGO7kIviPp4zE73YJ+uaHCS6NuMwyzGom7XDaeh59DCf4grSX4Ctr7+lPjJJD6Vn
         VrlG8z8/Wl/BEcrTawxxSrUAKd24efhi9PfOirBGREOAqKWKS8oj63SWHgwf4xfY3BQV
         S606Y8vyJGZV6NI6wM6HrRWICpe8enWRMvfb5EW7grUxd50Qf96Hw2ULCSnXWGICd1hT
         ROQQ==
X-Gm-Message-State: ACrzQf0Vl4srl4xL5xSpmm9Xv+DMDuWyWhrScam2gVomeUuAU7aOwOfq
        l08tXJYKlzYTb+T8WwSFByHvyQ==
X-Google-Smtp-Source: AMsMyM6TzSCCRMk+QkMl3OZoplEYGSd6ed5FAgTQVax4P0Klb9Q160q0qEsDQ0Y4h93CV/6THyqdtw==
X-Received: by 2002:a05:6e02:156c:b0:2f5:b1bc:3a50 with SMTP id k12-20020a056e02156c00b002f5b1bc3a50mr780805ilu.71.1665090708583;
        Thu, 06 Oct 2022 14:11:48 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id w10-20020a056638378a00b0035aea8cce87sm165870jal.141.2022.10.06.14.11.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Oct 2022 14:11:47 -0700 (PDT)
Message-ID: <9aa96c39-31a2-e650-a228-4d743c06112b@kernel.dk>
Date:   Thu, 6 Oct 2022 15:11:46 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH 1/1] io_uring: optimise locking for local tw with
 submit_wait
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Dylan Yudaken <dylany@fb.com>
References: <281fc79d98b5d91fe4778c5137a17a2ab4693e5c.1665088876.git.asml.silence@gmail.com>
 <0dbacebb-48bc-4254-6ad5-c00e6d54de8b@kernel.dk>
 <dce342ce-644c-5bcf-3d18-c313cd21887f@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <dce342ce-644c-5bcf-3d18-c313cd21887f@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/6/22 3:09 PM, Pavel Begunkov wrote:
> On 10/6/22 21:59, Jens Axboe wrote:
>> On 10/6/22 2:42 PM, Pavel Begunkov wrote:
>>> Running local task_work requires taking uring_lock, for submit + wait we
>>> can try to run them right after submit while we still hold the lock and
>>> save one lock/unlokc pair. The optimisation was implemented in the first
>>> local tw patches but got dropped for simplicity.
>>>
>>> Suggested-by: Dylan Yudaken <dylany@fb.com>
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> ---
>>>   io_uring/io_uring.c | 12 ++++++++++--
>>>   io_uring/io_uring.h |  7 +++++++
>>>   2 files changed, 17 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>> index 355fc1f3083d..b092473eca1d 100644
>>> --- a/io_uring/io_uring.c
>>> +++ b/io_uring/io_uring.c
>>> @@ -3224,8 +3224,16 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
>>>               mutex_unlock(&ctx->uring_lock);
>>>               goto out;
>>>           }
>>> -        if ((flags & IORING_ENTER_GETEVENTS) && ctx->syscall_iopoll)
>>> -            goto iopoll_locked;
>>> +        if (flags & IORING_ENTER_GETEVENTS) {
>>> +            if (ctx->syscall_iopoll)
>>> +                goto iopoll_locked;
>>> +            /*
>>> +             * Ignore errors, we'll soon call io_cqring_wait() and
>>> +             * it should handle ownership problems if any.
>>> +             */
>>> +            if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
>>> +                (void)io_run_local_work_locked(ctx);
>>> +        }
>>>           mutex_unlock(&ctx->uring_lock);
>>>       }
>>>   diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
>>> index e733d31f31d2..8504bc1f3839 100644
>>> --- a/io_uring/io_uring.h
>>> +++ b/io_uring/io_uring.h
>>> @@ -275,6 +275,13 @@ static inline int io_run_task_work_ctx(struct io_ring_ctx *ctx)
>>>       return ret;
>>>   }
>>>   +static inline int io_run_local_work_locked(struct io_ring_ctx *ctx)
>>> +{
>>> +    if (llist_empty(&ctx->work_llist))
>>> +        return 0;
>>> +    return __io_run_local_work(ctx, true);
>>> +}
>>
>> Do you have pending patches that also use this? If not, maybe we
>> should just keep it in io_uring.c? If you do, then this looks fine
>> to me rather than needing to shuffle it later.
> 
> No, I don't. I'd argue it's better as a helper because at least it
> hides always confusing bool argument, and we'd also need to replace
> a similar one in io_iopoll_check(). Add we can stick must_hold there
> for even more clarity. But ultimately I don't care much.

I really don't feel that strongly about it either, let's just keep
it the way it is.

-- 
Jens Axboe


