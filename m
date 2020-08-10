Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD376240813
	for <lists+io-uring@lfdr.de>; Mon, 10 Aug 2020 17:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbgHJPCF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 10 Aug 2020 11:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbgHJPCF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 10 Aug 2020 11:02:05 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E1A7C061787
        for <io-uring@vger.kernel.org>; Mon, 10 Aug 2020 08:02:05 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id u128so5526666pfb.6
        for <io-uring@vger.kernel.org>; Mon, 10 Aug 2020 08:02:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XXTc852665Y5dsLYW5XRosX8Q2COZS7MKbDS43FkS30=;
        b=MESL5CjpRPvBFz/14o9/AiUlXs7gSim5mtMQugG52UnmT9tzzotQQbu3esXv6LyG9g
         3TyuQRolRJJrasyqQkHOQIVxdIvU505Rv8RYW3lo70MQtxFeiS7CcuBcxLw+tVlJy4Ld
         40Go64bNywUSGfXAJt13pZKUu9FgFuOooCTvJYekkzH4Zs2gXdbbu4G+/SQYKSrpX4mu
         /GsD+P3BXXkNiN8yZyOUVvxGBN5AB5Q9/eS6oG5+o5LxNjtpuFBp7gCxmBzhfUMZzhf2
         2gG1RtgmjLg7Cp17ngLVNTGGQul3c0qmCQdTecTzXUjN5ypkvgPCkqSqLVJVK+ub6CK4
         52JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XXTc852665Y5dsLYW5XRosX8Q2COZS7MKbDS43FkS30=;
        b=V5TT60jdt7Pn0P0OWza3Np74Q0roAofhWqNjNxfs6S9PjESLdpR5TLaDdYPco8RQ27
         r1ZME8dbKgtC9Zj17SB8UBEyr0CLHqclVH+piGMvpnTkiZzptjITqfEhK/ZpgHtbptKI
         m23apAm76wDiImdScOfvCeLYh9ekwEC/W/JPw2JCnuPUjEdWWRFt26cd4Fh80LlBuuVY
         lI73AiEj413aKGkc/NTBGZhRoVliBiP9AWhZDnAnsu+NC8gqLKlFHyoHkHd4F3EkR/co
         Kru0iy/4zpVoZSGbcwgOjZ29tK0rcTIK8CQlNT8DRnX0taHN0j0vWqgKN4Bh9rR/K1xK
         ySfQ==
X-Gm-Message-State: AOAM532HFD8oyF3mdvJXk3bmypi5Rn7nWmH0548biV+KjgrC9Q1lHw96
        5Z7P63lge9xHqh9eKKZYBraI0CLJ+pk=
X-Google-Smtp-Source: ABdhPJxwrh+6JvNDZxTyh7vjjwNGKcs9GzGsyeI8TCmU9ARzqmrq54fToqMpxAcuvYdwrhoaMMDAWw==
X-Received: by 2002:a63:955c:: with SMTP id t28mr21574439pgn.18.1597071724094;
        Mon, 10 Aug 2020 08:02:04 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id g129sm22287622pfb.33.2020.08.10.08.02.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2020 08:02:03 -0700 (PDT)
Subject: Re: [PATCH 2/2] io_uring: use TWA_SIGNAL for task_work if the task
 isn't running
To:     peterz@infradead.org
Cc:     io-uring@vger.kernel.org, stable@vger.kernel.org,
        Josef <josef.grieb@gmail.com>
References: <20200808183439.342243-1-axboe@kernel.dk>
 <20200808183439.342243-3-axboe@kernel.dk>
 <20200810114256.GS2674@hirez.programming.kicks-ass.net>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a6ee0a6d-5136-4fe9-8906-04fe6420aad9@kernel.dk>
Date:   Mon, 10 Aug 2020 09:02:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200810114256.GS2674@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/10/20 5:42 AM, peterz@infradead.org wrote:
> On Sat, Aug 08, 2020 at 12:34:39PM -0600, Jens Axboe wrote:
>> An earlier commit:
>>
>> b7db41c9e03b ("io_uring: fix regression with always ignoring signals in io_cqring_wait()")
>>
>> ensured that we didn't get stuck waiting for eventfd reads when it's
>> registered with the io_uring ring for event notification, but we still
>> have a gap where the task can be waiting on other events in the kernel
>> and need a bigger nudge to make forward progress.
>>
>> Ensure that we use signaled notifications for a task that isn't currently
>> running, to be certain the work is seen and processed immediately.
>>
>> Cc: stable@vger.kernel.org # v5.7+
>> Reported-by: Josef <josef.grieb@gmail.com>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  fs/io_uring.c | 22 ++++++++++++++--------
>>  1 file changed, 14 insertions(+), 8 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index e9b27cdaa735..443eecdfeda9 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -1712,21 +1712,27 @@ static int io_req_task_work_add(struct io_kiocb *req, struct callback_head *cb)
>>  	struct io_ring_ctx *ctx = req->ctx;
>>  	int ret, notify = TWA_RESUME;
>>  
>> +	ret = __task_work_add(tsk, cb);
>> +	if (unlikely(ret))
>> +		return ret;
>> +
>>  	/*
>>  	 * SQPOLL kernel thread doesn't need notification, just a wakeup.
>> -	 * If we're not using an eventfd, then TWA_RESUME is always fine,
>> -	 * as we won't have dependencies between request completions for
>> -	 * other kernel wait conditions.
>> +	 * For any other work, use signaled wakeups if the task isn't
>> +	 * running to avoid dependencies between tasks or threads. If
>> +	 * the issuing task is currently waiting in the kernel on a thread,
>> +	 * and same thread is waiting for a completion event, then we need
>> +	 * to ensure that the issuing task processes task_work. TWA_SIGNAL
>> +	 * is needed for that.
>>  	 */
>>  	if (ctx->flags & IORING_SETUP_SQPOLL)
>>  		notify = 0;
>> -	else if (ctx->cq_ev_fd)
>> +	else if (READ_ONCE(tsk->state) != TASK_RUNNING)
>>  		notify = TWA_SIGNAL;
>>  
>> -	ret = task_work_add(tsk, cb, notify);
>> -	if (!ret)
>> -		wake_up_process(tsk);
>> -	return ret;
>> +	__task_work_notify(tsk, notify);
>> +	wake_up_process(tsk);
>> +	return 0;
>>  }
> 
> Wait.. so the only change here is that you look at tsk->state, _after_
> doing __task_work_add(), but nothing, not the Changelog nor the comment
> explains this.
> 
> So you're relying on __task_work_add() being an smp_mb() vs the add, and
> you order this against the smp_mb() in set_current_state() ?
> 
> This really needs spelling out.

I'll update the changelog, it suffers a bit from having been reused from
the earlier versions. Thanks for checking!

-- 
Jens Axboe

