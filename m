Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE283E883F
	for <lists+io-uring@lfdr.de>; Wed, 11 Aug 2021 04:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232299AbhHKCwG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Aug 2021 22:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231812AbhHKCwF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Aug 2021 22:52:05 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C24AFC061765
        for <io-uring@vger.kernel.org>; Tue, 10 Aug 2021 19:51:42 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id a20so819452plm.0
        for <io-uring@vger.kernel.org>; Tue, 10 Aug 2021 19:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=e85ojSaiIVjal3bsYM8q4OvF6ZBVlMxFadBj2rR3fC4=;
        b=Xu+/TdqHz31WewRv1l+fWI6IyV875qMMYe/KKjOFnsoCQYcDCjTq8AARwhSxnBKyjs
         gr9zuOKarlPTDzdyhp7rMQUuWEkolAf/cMVEwNKv2OBaFTwuNbiMVdOWZni+O6po5cXs
         66mxR1z2UJi4Gi9TLIo2Stv1vZthXryfj3lfB/gS7kVOq2GylLcrMQi0bn/5GGiTepV8
         TPyOhWzA74UkEKY5zLY1VWeL06UNOr6cLMRqLE6Oq+e2RZ6cXWgdprr03Ntfxisqfwtw
         4suCC1vHpsFTB+UgO/afatN4eIWVJWj2EpzhijwsCuAFpRzkiYkWiPMJUYdIqhVlxfJ9
         BxUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=e85ojSaiIVjal3bsYM8q4OvF6ZBVlMxFadBj2rR3fC4=;
        b=sBV011AR65OFrsXUzXwQNFy+b2unFT2n7gGNL3y8fMVZowYhsMfYvj1XxZ4Zc8m252
         JExTgW+PX8006dhLae9rP6BeVxuG9wDJPmZZfUEn5uJdbbiMrp1253UIPvO3ksSgZUMB
         4XgnoXU/mLQN26Kx81+NzkNMVXSYS9jENZ7WKYux5B3+/GXdaHgvfr8hdZALKf3KWDoX
         AQGiUok9PqyQtS4j3Aev0Nsey5nMjJCYbamyupomlOABeWMcltgenoHfeBUeBhPk/Q5b
         EQiuhI5LKSm5/VpEKHUiAw4BgnfaOM/vz4DIUnOsCfGYVB5Ob7vVA9NBInExbEuRzJ7x
         FAOQ==
X-Gm-Message-State: AOAM533GBO2sWKytVS6AXqzUwVBzjD5lcqg927Ch6Qqu+JSIj8QrdejH
        XAd7J6Vq0XN9MTSugnJnB9p5bQ==
X-Google-Smtp-Source: ABdhPJw+pVVEfLT34l9VMSNNvfM/Tbsyd96wg+stykewjsN1RffQMZclL9K9Jhc2VmbVY7Pcr2OG9w==
X-Received: by 2002:a65:5c89:: with SMTP id a9mr318004pgt.433.1628650302278;
        Tue, 10 Aug 2021 19:51:42 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id on15sm4390666pjb.19.2021.08.10.19.51.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 19:51:41 -0700 (PDT)
Subject: Re: [PATCH 1/2] io_uring: clear TIF_NOTIFY_SIGNAL when running task
 work
To:     Nadav Amit <nadav.amit@gmail.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     Olivier Langlois <olivier@trillion01.com>,
        io-uring@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20210808001342.964634-1-namit@vmware.com>
 <20210808001342.964634-2-namit@vmware.com>
 <fdd54421f4d4e825152192e327c838d035352945.camel@trillion01.com>
 <A4DC14BA-74CA-41DB-BE08-D7B693C11AE0@gmail.com>
 <bbd25a42-eac0-a8f9-0e54-3c8c8e9894fd@gmail.com>
 <FD8FD9BD-1E94-4A84-88EB-3A1531BCF556@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1bf56100-e904-65b5-bbb8-fa313d85b01a@kernel.dk>
Date:   Tue, 10 Aug 2021 20:51:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <FD8FD9BD-1E94-4A84-88EB-3A1531BCF556@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/10/21 8:33 PM, Nadav Amit wrote:
> 
> 
>> On Aug 10, 2021, at 2:32 PM, Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 8/10/21 9:28 AM, Nadav Amit wrote:
>>>
>>> Unfortunately, there seems to be yet another issue (unless my code
>>> somehow caused it). It seems that when SQPOLL is used, there are cases
>>> in which we get stuck in io_uring_cancel_sqpoll() when tctx_inflight()
>>> never goes down to zero.
>>>
>>> Debugging... (while also trying to make some progress with my code)
>>
>> It's most likely because a request has been lost (mis-refcounted).
>> Let us know if you need any help. Would be great to solve it for 5.14.
>> quick tips: 
>>
>> 1) if not already, try out Jens' 5.14 branch
>> git://git.kernel.dk/linux-block io_uring-5.14
>>
>> 2) try to characterise the io_uring use pattern. Poll requests?
>> Read/write requests? Send/recv? Filesystem vs bdev vs sockets?
>>
>> If easily reproducible, you can match io_alloc_req() with it
>> getting into io_dismantle_req();
> 
> So actually the problem is more of a missing IO-uring functionality
> that I need. When an I/O is queued for async completion (i.e., after
> returning -EIOCBQUEUED), there should be a way for io-uring to cancel
> these I/Os if needed.

There's no way to cancel file/bdev related IO, and there likely never
will be. That's basically the only exception, everything else can get
canceled pretty easily. Many things can be written on why that is the
case, and they have (myself included), but it boils down to proper
hardware support which we'll likely never have as it's not a well tested
path. For other kind of async IO, we're either waiting in poll (which is
trivially cancellable) or in an async thread (which is also easily
cancellable). For DMA+irq driven block storage, we'd need to be able to
reliably cancel on the hardware side, to prevent errant DMA after the
fact.

None of this is really io_uring specific, io_uring just suffers from the
same limitations as others would (or are).

> Otherwise they might potentially never complete, as happens in my
> use-case.

If you see that, that is most certainly a bug. While bdev/reg file IO
can't really be canceled, they all have the property that they complete
in finite time. Either the IO completes normally in a "short" amount of
time, or a timeout will cancel it and complete it in error. There are no
unbounded execution times for uncancellable IO.

> AIO has ki_cancel() for this matter. So I presume the proper solution
> would be to move ki_cancel() from aio_kiocb to kiocb so it can be used
> by both io-uring and aio. And then - to use this infrastructure.

There is no infrastructure, I'm fraid. ki_cancel() is just a random hook
that nobody (outside of USB gadget??) ever implemented or used.

> But it is messy. There is already a bug in the (few) uses of
> kiocb_set_cancel_fn() that blindly assume AIO is used and not
> IO-uring. Then, I am not sure about some things in the AIO code. Oh
> boy. I’ll work on an RFC.

ki_cancel is a non-starter, it doesn't even work for the single case
that it's intended for, and I'm actually surprised it hasn't been
removed yet. It's one of those things that someone added a hook for, but
never really grew into something that is useful.

-- 
Jens Axboe

