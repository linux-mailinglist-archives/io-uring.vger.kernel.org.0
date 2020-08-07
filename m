Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 521E023F492
	for <lists+io-uring@lfdr.de>; Fri,  7 Aug 2020 23:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbgHGVuF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 Aug 2020 17:50:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726015AbgHGVuF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Aug 2020 17:50:05 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE41C061756
        for <io-uring@vger.kernel.org>; Fri,  7 Aug 2020 14:50:05 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id q17so1788893pls.9
        for <io-uring@vger.kernel.org>; Fri, 07 Aug 2020 14:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CBsTNem9MFWskVvzHQzyx9mrHA5c1xZpC50BFpkQVXE=;
        b=M09o2ph3+EM04VvVluYZnqhj4OpTkqP6BcWT9jqVws94qYKCtpgL8Av64uQ6RJ9v2B
         3Agn9A6c43J3KfUvD7ZuYy5w1B3lmBII2ww9kC0lXPjVtsTHk322wXEt+Wslz+hX8rRO
         DAqURC3n21aU37glAOnp02xFRaDazzY8cuQPP4bPgkJ0vyzv9jwQvQK5P5PJxnEDK/3o
         L9umZviu13ra5gaNndjIcZvmPNWGkCxXkutVpU+R50XyDzkgSUyZbWIaUdLKs3O/Bcib
         rTXqzfbDpXBpI0P1tN4ZeJGzzRoYJJBjHkb8+UuEDA38e2bTcAV2CBI7sbwJMBi1s41J
         P4YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CBsTNem9MFWskVvzHQzyx9mrHA5c1xZpC50BFpkQVXE=;
        b=F2PUqGFCnLQrrLYz516W3Xxx6xcxk9jUF0DZb44THkvZdMa/4PecnwLijzDwwgDa4c
         4GnfdWr7cUzKzQAVB3TNCjQKk3kjeD+l8CqF84icrrbaDmNBpsjnzcq8dAgaUcoqq1LB
         mJcDYErJHA9s3nkEwKML7bqUsezt2fw0LKdGvXji+T/WuakkpIxa0rMm7zvFw98YLFbb
         51E/E6Tv2+tJAf1n6+z+tqUYRNGLcClc07Ps3PngJmxNyTorgqsNeoK517OT9YNAexak
         km/wc7s+tZFY6Hk4fHQACk3vs7SHbozikJRie0pL/Ndc8PsEN2BeulgEZXWmkaFj+j0M
         v1cw==
X-Gm-Message-State: AOAM532BRScbbiFI5yRWMl0xpazN3SZgh47E9vJrObd6vIxTiS5funx5
        ouaBWYNSxoUiwazvCCmK3+CCB6s+TL8=
X-Google-Smtp-Source: ABdhPJzmD+RhqnqWA3k9os7JS9CWhWmcdDzkcu3z0aG+gkVyeuBjdRqnFAw7eoqABrzDZU06hYq2og==
X-Received: by 2002:a17:902:7787:: with SMTP id o7mr14400758pll.327.1596837004493;
        Fri, 07 Aug 2020 14:50:04 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id b26sm15456727pff.54.2020.08.07.14.50.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Aug 2020 14:50:03 -0700 (PDT)
Subject: Re: [PATCH v2] io_uring: use TWA_SIGNAL for task_work if the task
 isn't running
To:     Jann Horn <jannh@google.com>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <ba5b8ee4-2c6f-dec7-97f2-d02c8b3fe3f8@kernel.dk>
 <CAG48ez3dX8aK2m918fxAZGaOf5h9QV6X+Z5LMzJV2yZO8+bsvg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3b4ad90f-59b3-b279-fcee-419bd370f470@kernel.dk>
Date:   Fri, 7 Aug 2020 15:50:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAG48ez3dX8aK2m918fxAZGaOf5h9QV6X+Z5LMzJV2yZO8+bsvg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/7/20 12:00 PM, Jann Horn wrote:
> On Fri, Aug 7, 2020 at 6:56 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
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
>>
>> ---
>>
>> This isn't perfect, as it'll use TWA_SIGNAL even for cases where we
>> don't absolutely need it (like task waiting for completions in
>> io_cqring_wait()), but we don't have a good way to tell right now. We
>> can probably improve on this in the future, for now I think this is the
>> best solution.
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index e9b27cdaa735..b4300a61f231 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -1720,7 +1720,7 @@ static int io_req_task_work_add(struct io_kiocb *req, struct callback_head *cb)
>>          */
>>         if (ctx->flags & IORING_SETUP_SQPOLL)
>>                 notify = 0;
>> -       else if (ctx->cq_ev_fd)
>> +       else if (ctx->cq_ev_fd || (tsk->state != TASK_RUNNING))
>>                 notify = TWA_SIGNAL;
>>
>>         ret = task_work_add(tsk, cb, notify);
> 
> I don't get it. Apart from still not understanding the big picture:
> 
> What guarantees that the lockless read of tsk->state is in any way
> related to the state of the remote process by the time we reach
> task_work_add()? And why do we not need to signal in TASK_RUNNING
> state (e.g. directly before the remote process switches to
> TASK_INTERRUPTIBLE or something like that)?

Yeah it doesn't, the patch doesn't cover the racy case. As far as I can
tell, we've got two ways to do it:

1) We split the task_work_add() into two parts, one adding the work and
   one doing the signaling. Then we could do:

int notify = TWA_RESUME;

__task_work_add(tsk, cb);

if (ctx->flags & IORING_SETUP_SQPOLL)
	notify = 0;
else if (ctx->cq_ev_fd || (tsk->state != TASK_RUNNING))
	notify = TWA_SIGNAL;

__task_work_signal(tsk, notify);

2) We imply that behavior in task_work_add() itself, if TWA_SIGNAL is
used, making TWA_SIGNAL imply "use signal wakeup IFF task is not
running". Or add a TWA_SIGNAL_NOT_RUNNING for that behavior.

I kind of like the first approach.

> Even if this is correct, it would still be nice if you could add a big
> comment that explains the precise semantics this is attempting to
> provide. As far as I understand so far, the goal is to trigger -EINTR
> returns from certain syscalls, or something like that? But I don't
> understand whether that's indeed what's going on, or which syscalls
> precisely this is attempting to make return -EINTR.

The point is if the original task is currently looping (or just waiting)
in the kernel on another event, it still gets a chance to process the
task work. The completion it's waiting for may be dependent on getting
that task work run.

The test case for this one is kicking off a thread that waits on the
completion event, while the main task is waiting for the thread to exit.

Agree it needs a comment, I'll add one.

> (Also, lockless reads of concurrently changing variables should be
> written with READ_ONCE().)

Good point.

-- 
Jens Axboe

