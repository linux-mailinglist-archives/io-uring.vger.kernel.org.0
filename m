Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0E803D3ED7
	for <lists+io-uring@lfdr.de>; Fri, 23 Jul 2021 19:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231979AbhGWQwW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Jul 2021 12:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbhGWQwW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Jul 2021 12:52:22 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7660BC061757
        for <io-uring@vger.kernel.org>; Fri, 23 Jul 2021 10:32:55 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id r5so2205046ilc.13
        for <io-uring@vger.kernel.org>; Fri, 23 Jul 2021 10:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5M958zdX9geS/u2H/YZsFoj5TvVRmO6Wg409po08/mU=;
        b=YcTfH+rYbdgeIXg0QBd8fGyTputCo3lqix79WGZw8baWHvvyPGr+q5iXOBuUCEoYKL
         8zy6XSGQXPqOZmw/hlWrRe+YTVK1w5ptEYosMnicYsjnmhUlh6fR/v1b9Sp1urxBOUIe
         WwbuEX+y/JZmLQ4NO7awUaeFw9cqmSJAdSbFCrYTXNnKR8gdVNXNB0XorVC/xsvKHQrQ
         SDfb8oLP8ePqKtzHymn1AMR2Jl+goWGI1qycsJbgcBWJ9H6BgcVjwFYAHYt4AHzMETGt
         PMmpG/Lphys+/0PT9k85N/P51rcthaEM7buclrGvvB26huJN4E7JgFXba5W9Rnpi90ph
         9m4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5M958zdX9geS/u2H/YZsFoj5TvVRmO6Wg409po08/mU=;
        b=s+t2t/K/K4ooyjuiRUpE4GOaAMdIDh6U854sWAVw+27J9ldqQpoJMaQD4qWeMYCcH4
         mM/gjGBjCTukyc7uzPxfoC5ntLZDetflrC22++ODQs6C20aGVRlPcpaAtuh+Q0NKhKcX
         /5Y3L5BUfTzqIbOtx6kWizCKzfBHWB5H7dFWWYp7VT22u1KLq93AntpV/RmqnkrHKdK3
         gAfCZsqc3p3W5p8rCBcKWw6Akxi5bkrEgGjxOfFBY+ZUiM7I1SdfbcUHsc9l0rXKgspB
         pkZr+kkNM1CblJqgF/OUanYmIgg/UEgFRLfrjEuk+YfvrjcUPJgJdf6KHvU6xtXsYoWw
         vBWw==
X-Gm-Message-State: AOAM530XBDQYUK+YVVLBN6BcHDsKZyQXU0Zcf1jETeMa/Mt7IfZQGCk6
        /4gAQr0bJ0X+Gay5qC1y6zytCA==
X-Google-Smtp-Source: ABdhPJwhTskMqkvJG0ZMzPKJi2gwwNXNNhp5/dcfBRQ60JGBeNkWBq0lh2qKaruH64V+RzlRtLCxxQ==
X-Received: by 2002:a92:d3c7:: with SMTP id c7mr4127169ilh.59.1627061574692;
        Fri, 23 Jul 2021 10:32:54 -0700 (PDT)
Received: from [192.168.1.10] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id u12sm5670209iog.54.2021.07.23.10.32.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jul 2021 10:32:54 -0700 (PDT)
Subject: Re: [PATCH 3/3] io_uring: refactor io_sq_offload_create()
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <cover.1618916549.git.asml.silence@gmail.com>
 <939776f90de8d2cdd0414e1baa29c8ec0926b561.1618916549.git.asml.silence@gmail.com>
 <YPnqM0fY3nM5RdRI@zeniv-ca.linux.org.uk>
 <57758edf-d064-d37e-e544-e0c72299823d@kernel.dk>
 <YPn/m56w86xAlbIm@zeniv-ca.linux.org.uk>
 <a85df247-137f-721c-6056-a5c340eed90e@kernel.dk>
 <YPoI+GYrgZgWN/dW@zeniv-ca.linux.org.uk>
 <8fb39022-ba21-2c1f-3df5-29be002014d8@kernel.dk>
 <YPr4OaHv0iv0KTOc@zeniv-ca.linux.org.uk>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c09589ed-4ae9-c3c5-ec91-ba28b8f01424@kernel.dk>
Date:   Fri, 23 Jul 2021 11:32:53 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YPr4OaHv0iv0KTOc@zeniv-ca.linux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/23/21 11:11 AM, Al Viro wrote:
> On Fri, Jul 23, 2021 at 10:17:27AM -0600, Jens Axboe wrote:
>> On 7/22/21 6:10 PM, Al Viro wrote:
>>> On Thu, Jul 22, 2021 at 05:42:55PM -0600, Jens Axboe wrote:
>>>
>>>>> So how can we possibly get there with tsk->files == NULL and what does it
>>>>> have to do with files, anyway?
>>>>
>>>> It's not the clearest, but the files check is just to distinguish between
>>>> exec vs normal cancel. For exec, we pass in files == NULL. It's not
>>>> related to task->files being NULL or not, we explicitly pass NULL for
>>>> exec.
>>>
>>> Er...  So turn that argument into bool cancel_all, and pass false on exit and
>>> true on exec? 
>>
>> Yes
>>
>>> While we are at it, what happens if you pass io_uring descriptor
>>> to another process, close yours and then have the recepient close the one it
>>> has gotten?  AFAICS, io_ring_ctx_wait_and_kill(ctx) will be called in context
>>> of a process that has never done anything io_uring-related.  Can it end up
>>> trying to resubmit some requests?> 
>>> I rather hope it can't happen, but I don't see what would prevent it...
>>
>> No, the pending request would either have gone to a created thread of
>> the original task on submission, or it would be sitting in a
>> ready-to-retry state. The retry would attempt to queue to original task,
>> and either succeed (if still alive) or get failed with -ECANCELED. Any
>> given request is tied to the original task.
> 
> Hmm...  Sure, you'll be pushing it to the same io_wqe it went through originally,
> but you are still in context of io_uring_release() caller, aren't you?
> 
> So you call io_wqe_wake_worker(), and it decides that all threads are busy,
> but ->nr_workers is still below ->max_workers.  And proceeds to
> 	create_io_worker(wqe->wq, wqe, acct->index);
> which will create a new io-worker thread, but do that in the thread group of
> current, i.e. the caller of io_uring_release().  Looks like we'd get
> an io-worker thread with the wrong parent...
> 
> What am I missing here?

I think there's two main cases here:

1) Request has already been issued by original task in some shape or form.
   This is the case I was mentioning in my previous reply.

2) Request has not been seen yet, this would be a new submit.

For case #2, let's say you pass the ring to another task, there are entries
in the SQ ring that haven't been submitted yet. Will these go under the new
task? Yes they would - you've passed the ring to someone else at that point.

For case #1, by definition the request has already been issued and is
assigned to the task that did that. This either happens from the syscall
itself, or from task_work which is also run from that original task.

For your particular case, it's either an original async queue (hasn't
been done on this task before), in which case it will create a thread
from the right task. The other option is that we decide to async requeue
from async context for some odd reason, and we're already in the right
context at that point to create a new thread (which should not even
happen, as the same thread is now available).

I don't see a case where this wouldn't work as expected. However, I do
think we could add a WARN_ON_ONCE (or similar) and reject any attempt
to io_wq_enqueue() from the wrong context as a proactive measure to
catch any bugs in testing rather than later.

Outside of that, we're not submitting off release, only killing anything
pending. The only odd case there is iopoll, but that doesn't resubmit
here.

-- 
Jens Axboe

