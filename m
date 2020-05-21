Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF11D1DD630
	for <lists+io-uring@lfdr.de>; Thu, 21 May 2020 20:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729505AbgEUSpO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 May 2020 14:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728551AbgEUSpO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 May 2020 14:45:14 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A08FC061A0F
        for <io-uring@vger.kernel.org>; Thu, 21 May 2020 11:45:14 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id n18so3769192pfa.2
        for <io-uring@vger.kernel.org>; Thu, 21 May 2020 11:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VzUhwqsTRNYQVRj0Je00ouwOAoUZY2ycQI8CYqrRS50=;
        b=pClf40YBb08EniLgIq+M7ZGL6N+ikjY0F/Ap3h9EgP2Ogd2Ytx2LKBWWCiMqVHOcer
         2Hgp0FXKaq8JcNhamxWowL8f157ZMfA1spfbf2TFJAJLQokIhGi1pfKEXwTLC4QEob6c
         9GbcG62PodqNvaOYRWDYXQ5cA0FwhqQ92UkbhSm6kfdeq+0InAg90xBKuw9caNuHUwPk
         tpjLLdCim07v23FKz8OgK/vqfssFZu8NK0nnl/fe8hnU0dkpOe2cNYZzDc+9ZXRDunm/
         G7UCvAFLpD+h9bTzpE4B9TOqCK3aIh0e9F1Cyd5qSKEQFVau+0iwPSib8dcyYt4t055Y
         koyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VzUhwqsTRNYQVRj0Je00ouwOAoUZY2ycQI8CYqrRS50=;
        b=FeB1NlyCZoN9yl2ItyUTGPQ9qpt1f704sO5XD6E6ZJFo5cg1uTxAXO+6bdqF7oCec5
         FMtOYn/sHfgfbjMAioNP8M0+fYW1EAgLDTZiPoSdfPxWlu4LQcdjz66pQG/NcxRdvcSk
         5nmq7W+LMSKkhV7jatkSfmzPOdiZ+Jb9XcsdKAgWHnH2Fy9xMW2C7894NBhd1VzUj3t3
         BmBJZEPzCvTWH8CJxgGbpM/DWVU0RfbftXoy6rGRzEMP0EmvFxe3Jn8UHPla6ylLtxFy
         r5r3kTLQYx/OHZmIy5ftoo6YHANnnLheGG4PRvwBHRzz57MKbP+HGBWD+B4plLqAx52x
         l0Aw==
X-Gm-Message-State: AOAM531dhIHwq0peY6lYHiPGJIi9ldKppgen5iUwwGKLpKWMA+B2SK4a
        4oemWZDG6igmqaeZYeo/3vEKUA==
X-Google-Smtp-Source: ABdhPJyQJRLZQ4lxBc5cKa47VqO8BJkbhursAaFtFme46hV97A0Q5b9zsp0O9be9ooXXVZnW4Ktevw==
X-Received: by 2002:aa7:9096:: with SMTP id i22mr112832pfa.250.1590086713698;
        Thu, 21 May 2020 11:45:13 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:f02d:fa41:676:76e9? ([2605:e000:100e:8c61:f02d:fa41:676:76e9])
        by smtp.gmail.com with ESMTPSA id 19sm4972461pjl.52.2020.05.21.11.45.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 May 2020 11:45:13 -0700 (PDT)
Subject: Re: io_uring vs CPU hotplug, was Re: [PATCH 5/9] blk-mq: don't set
 data->ctx and data->hctx in blk_mq_alloc_request_hctx
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>, io-uring@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
References: <20200520011823.GA415158@T590> <20200520030424.GI416136@T590>
 <20200520080357.GA4197@lst.de>
 <8f893bb8-66a9-d311-ebd8-d5ccd8302a0d@kernel.dk>
 <448d3660-0d83-889b-001f-a09ea53fa117@kernel.dk>
 <87tv0av1gu.fsf@nanos.tec.linutronix.de>
 <2a12a7aa-c339-1e51-de0d-9bc6ced14c64@kernel.dk>
 <87eereuudh.fsf@nanos.tec.linutronix.de> <20200521022746.GA730422@T590>
 <87367tvh6g.fsf@nanos.tec.linutronix.de> <20200521092340.GA751297@T590>
 <87pnaxt9nv.fsf@nanos.tec.linutronix.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <15f9f975-1baf-dc90-5730-00df08829523@kernel.dk>
Date:   Thu, 21 May 2020 12:45:11 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <87pnaxt9nv.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/21/20 12:39 PM, Thomas Gleixner wrote:
> Ming,
> 
> Ming Lei <ming.lei@redhat.com> writes:
>> On Thu, May 21, 2020 at 10:13:59AM +0200, Thomas Gleixner wrote:
>>> Ming Lei <ming.lei@redhat.com> writes:
>>>> On Thu, May 21, 2020 at 12:14:18AM +0200, Thomas Gleixner wrote:
>>>> - otherwise, the kthread just retries and retries to allocate & release,
>>>> and sooner or later, its time slice is consumed, and migrated out, and the
>>>> cpu hotplug handler will get chance to run and move on, then the cpu is
>>>> shutdown.
>>>
>>> 1) This is based on the assumption that the kthread is in the SCHED_OTHER
>>>    scheduling class. Is that really a valid assumption?
>>
>> Given it is unlikely path, we can add msleep() before retrying when INACTIVE bit
>> is observed by current thread, and this way can avoid spinning and should work
>> for other schedulers.
> 
> That should work, but pretty is something else
> 
>>>
>>> 2) What happens in the following scenario:
>>>
>>>    unplug
>>>
>>>      mq_offline
>>>        set_ctx_inactive()
>>>        drain_io()
>>>        
>>>    io_kthread()
>>>        try_queue()
>>>        wait_on_ctx()
>>>
>>>    Can this happen and if so what will wake up that thread?
>>
>> drain_io() releases all tag of this hctx, then wait_on_ctx() will be waken up
>> after any tag is released.
> 
> drain_io() is already done ...
> 
> So looking at that thread function:
> 
> static int io_sq_thread(void *data)
> {
> 	struct io_ring_ctx *ctx = data;
> 
>         while (...) {
>               ....
> 	      to_submit = io_sqring_entries(ctx);
> 
> --> preemption
> 
> hotplug runs
>    mq_offline()
>       set_ctx_inactive();
>       drain_io();
>       finished();
> 
> --> thread runs again
> 
>       mutex_lock(&ctx->uring_lock);
>       ret = io_submit_sqes(ctx, to_submit, NULL, -1, true);
>       mutex_unlock(&ctx->uring_lock);
> 
>       ....
> 
>       if (!to_submit || ret == -EBUSY)
>           ...
>       	  wait_on_ctx();
> 
> Can this happen or did drain_io() already take care of the 'to_submit'
> items and the call to io_submit_sqes() turns into a zero action ?
> 
> If the above happens then nothing will wake it up because the context
> draining is done and finished.

Again, this is mixing up io_uring and blk-mq. Maybe it's the fact that
both use 'ctx' that makes this confusing. On the blk-mq side, the 'ctx'
is the per-cpu queue context, for io_uring it's the io_uring instance.

io_sq_thread() doesn't care about any sort of percpu mappings, it's
happy as long as it'll keep running regardless of whether or not the
optional pinned CPU is selected and then offlined.

-- 
Jens Axboe

