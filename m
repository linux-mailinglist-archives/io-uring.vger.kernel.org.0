Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBC1A3E50F9
	for <lists+io-uring@lfdr.de>; Tue, 10 Aug 2021 04:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234336AbhHJCJQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 22:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232947AbhHJCJM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 22:09:12 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1032CC0613D3
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 19:08:51 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id n11so11877991wmd.2
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 19:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:subject:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=sw6A6X1l9yulmnchiRIEU0bwN9NMl28vNWX3L3/91o8=;
        b=AJBxP1H3EkIZB7Up+hyOvpFYFQNzJNZ0XjCOG8mUBI7L3Oc198J/bomfpcVh5gni24
         HL3bMpLwuomDXMopjlwFZeipJtakh6N2YP5G9Ln2KCtxjVavsAtjbR70XvI/4t3VYPrD
         /QMUvZvxf597L+e0DVcnV7K7eHRfpzGCFEj+I1+ulNJsI1tIjvHRfVLkgQIZKW8gMoow
         LDGJERdQCd6hpCWXBvUbtLjl3T9AHRzZvDU/aQIrdnEFF9g22a/k46u9QCUzxrx00ODG
         6F9lIZ06AaRBzvMx/XiYukF6V/SfePSXmLvTDzG2xnvdHvtnUiSIG/GQaUu84r8w30JC
         3tjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sw6A6X1l9yulmnchiRIEU0bwN9NMl28vNWX3L3/91o8=;
        b=DZ/Gu0uOO2Ww8MNSZMKeCf61uC5Krz5489isgKIwAqhabULXuo5xPp80d6+f6aNdiV
         KqWqoDIJNxfWZ0u/l7Q9VrPR4S4RTwYutaZNa9Mb/fF0WSDT9VvqueLnu/XUP6eTWZ82
         vx8JXmSFHWY3Ep9PcEl5f9UUX5O4aOZvlUBUZh40M506q8n2LbeLbbt3BarCIhgv/ybc
         oOsmNdF5TV95fc6jDRgCkhuxuOqITVrZvTLQwzMFaMINPAn6grV5OETxaxbEYgGzoGEb
         LfikyNFzmLyljvoXg0wguobVAHagW/DYp6EdLgnoEg12O4My+Ck3LH5fqLuVXhp4iqkZ
         1bdA==
X-Gm-Message-State: AOAM531DJpheabo3k5w5dWM0Hk7+DjbKqdJl6jdSmXDKb+bs4N8lmJM7
        V9jMTVvOKUUYSkMW0aafQPLu865sxcE=
X-Google-Smtp-Source: ABdhPJx4CzE0a75DnNmcNTadr/4tq2JdXp8jqAnQcaM0lgI0CKucxhkVxVDY6JP42hc9yekrt2pwng==
X-Received: by 2002:a1c:5404:: with SMTP id i4mr1959635wmb.80.1628561329534;
        Mon, 09 Aug 2021 19:08:49 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.236.119])
        by smtp.gmail.com with ESMTPSA id g12sm21289972wri.49.2021.08.09.19.08.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Aug 2021 19:08:49 -0700 (PDT)
To:     Jens Axboe <axboe@fb.com>, io-uring <io-uring@vger.kernel.org>
References: <27997f97-68cc-63c3-863b-b0c460bc42c0@fb.com>
 <d6f7a325-62ef-ec7f-053d-411354d177f2@gmail.com>
 <4f310c1a-2630-75ba-1692-cc7d12c11fc0@fb.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH] io_uring: be smarter about waking multiple CQ ring
 waiters
Message-ID: <f2750712-e191-6ce1-2a7b-2eea0bc036cd@gmail.com>
Date:   Tue, 10 Aug 2021 03:08:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <4f310c1a-2630-75ba-1692-cc7d12c11fc0@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/10/21 2:55 AM, Jens Axboe wrote:
> On 8/9/21 7:42 PM, Pavel Begunkov wrote:
>> On 8/6/21 9:19 PM, Jens Axboe wrote:
>>> Currently we only wake the first waiter, even if we have enough entries
>>> posted to satisfy multiple waiters. Improve that situation so that
>>> every waiter knows how much the CQ tail has to advance before they can
>>> be safely woken up.
>>>
>>> With this change, if we have N waiters each asking for 1 event and we get
>>> 4 completions, then we wake up 4 waiters. If we have N waiters asking
>>> for 2 completions and we get 4 completions, then we wake up the first
>>> two. Previously, only the first waiter would've been woken up.
>>>
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>
>>> ---
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index bf548af0426c..04df4fa3c75e 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -1435,11 +1435,13 @@ static inline bool io_should_trigger_evfd(struct io_ring_ctx *ctx)
>>>  
>>>  static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
>>>  {
>>> -	/* see waitqueue_active() comment */
>>> -	smp_mb();
>>> -
>>> -	if (waitqueue_active(&ctx->cq_wait))
>>> -		wake_up(&ctx->cq_wait);
>>> +	/*
>>> +	 * wake_up_all() may seem excessive, but io_wake_function() and
>>> +	 * io_should_wake() handle the termination of the loop and only
>>> +	 * wake as many waiters as we need to.
>>> +	 */
>>> +	if (wq_has_sleeper(&ctx->cq_wait))
>>> +		wake_up_all(&ctx->cq_wait);
>>>  	if (ctx->sq_data && waitqueue_active(&ctx->sq_data->wait))
>>>  		wake_up(&ctx->sq_data->wait);
>>>  	if (io_should_trigger_evfd(ctx))
>>> @@ -6968,20 +6970,21 @@ static int io_sq_thread(void *data)
>>>  struct io_wait_queue {
>>>  	struct wait_queue_entry wq;
>>>  	struct io_ring_ctx *ctx;
>>> -	unsigned to_wait;
>>> +	unsigned cq_tail;
>>>  	unsigned nr_timeouts;
>>>  };
>>>  
>>>  static inline bool io_should_wake(struct io_wait_queue *iowq)
>>>  {
>>>  	struct io_ring_ctx *ctx = iowq->ctx;
>>> +	unsigned tail = ctx->cached_cq_tail + atomic_read(&ctx->cq_timeouts);
>>
>> Seems, adding cq_timeouts can be dropped from here and iowq.cq_tail
> 
> Good point, we can drop it at both ends.
> 
>>>  	/*
>>>  	 * Wake up if we have enough events, or if a timeout occurred since we
>>>  	 * started waiting. For timeouts, we always want to return to userspace,
>>>  	 * regardless of event count.
>>>  	 */
>>> -	return io_cqring_events(ctx) >= iowq->to_wait ||
>>
>> Don't we miss smp_rmb() previously provided my io_cqring_events()?
> 
> For? We aren't reading any user modified pats.

I was rather thinking about who provides the barrier for userspace,
but that should be indeed on the userspace, and the function is
called from arbitrary CPU/context anyway.

>>
>>> +	return tail >= iowq->cq_tail ||
>>
>> tails might overflow
> 
> Indeed, I actually did fix this one before committing it.

Great

-- 
Pavel Begunkov
