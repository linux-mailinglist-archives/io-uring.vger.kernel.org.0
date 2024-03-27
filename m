Return-Path: <io-uring+bounces-1245-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EC3D888E9B8
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 16:48:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 741661F348CB
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 15:48:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8CD845BE9;
	Wed, 27 Mar 2024 15:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="dWn3YEGE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4773F84D31
	for <io-uring@vger.kernel.org>; Wed, 27 Mar 2024 15:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711554345; cv=none; b=qMRUSWG4H0KWVzBUwpVJSJWFiVvp6izvZYdEQDtQEGcOyGCIDLYTInHAZ8y9lPOrqvj5AfhS+n5UDazC7X6+WfEBPMiC4dXfhxBcDS8/ADNIuprWEjnTnMmLKAvpHiB9L6KqiT/jesNUWsrgJ7w27D+tUHfMfKHfW7yxfMPhU48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711554345; c=relaxed/simple;
	bh=fsDi1W2KTBJNW7A7tYK1xFEqga/Rcvt1+2Es6m8TITw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=au5cWfhm+93oqEn1jlCQuYKcHc15pHxxcJ4g+kqyO6IaVW9Z6GKSX/TIFiP2rzQB0bChb+D3TOmf9fyBmB06vqsj26oFQzlXcbp7Qds+xgR+OCRYwdkHDIVi4k0Z8HdPoTIf/YL+tXo0NWw1AW2oEwRk0M5gW86c74P2/4cGKBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=dWn3YEGE; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1dde24ec08cso7236705ad.1
        for <io-uring@vger.kernel.org>; Wed, 27 Mar 2024 08:45:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711554341; x=1712159141; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eEs4ZfiipmJVLC4z1ZS49Lyn4jfvVa/dtP9tAta76dQ=;
        b=dWn3YEGEb7cvSG12sE3n8ymHm9iiDSoKsHuYK+lyVuNsEScB8hJVYPOaGGuz8t2FZ3
         tGMjvM1vO0AKxt1bDnmbokR+/t27WQqFfwN92dISrkRH3VA/4/TuOVNcc3N1TgZRSSXV
         ZWVeEq8FVPv+Vg5wTLntQpL+atBeHwdf/vOr5LupDXwfReQQM1k+kHfNbn5yZnupz0LH
         ZS2AhjVQc/zmqHWDGI9XkcM09/HnqOpM7dbBgh64tZkF1DJYRW8tHmHKyt/AIyhLQAYO
         qM2tdiPR/aJ/zNG6iCNSu/jxdknKu9OpJy2I9zUHW/J5/68vLieWVSQ3xFI9YxGj51oq
         h6xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711554341; x=1712159141;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eEs4ZfiipmJVLC4z1ZS49Lyn4jfvVa/dtP9tAta76dQ=;
        b=OiGbOgfvx926i/bLEbhFUUJnk4cSoqYW/dOO03HtMHJxGvF/ovuB7rU8jU1zObtmEf
         OPAGayW4btT4fxXnIi/P0uZ6eoAdyK6690GJtCwy6zlz76KfmcTZOPDWDcdoslYOM9MV
         6N1Eo5CGuR3zhm6TP7gOBs0284Qktg1xgh352LN3+ffYtJSgHsaAxEUm05PtM8uKIEin
         AK2G18Li+k31PQH+8aTPfVYBtro4zyaDFa8gY55hHNGRg2V127kQBzeP7BjNqrUz/lVT
         aQtiWDMulEGJSUPef4dha35lsl2fvyPia1/2NzkPW5iaHrH2obLm0rAIhqzhDnquznyk
         TykQ==
X-Forwarded-Encrypted: i=1; AJvYcCV1mXCiDVo5LfuX67+JzEQZ+410oXugUbO98TaDyh6qS0MNWU+KU5GlyvRe+S7qTvExRKTSMTxpc38ae3y46mXIZaQZBF8KWXQ=
X-Gm-Message-State: AOJu0YzlEb3pO3tkgJr+vZjLEhFYCzC1JYrVfNG7a0bHV9ewyTcJ540H
	F06fWqkdY/d+UHO2l/jKRIn+L8yVsy1CrIX/AxXk1Szuq8sghXUqZQfoUIRmP0bDPElQbst+Pad
	M
X-Google-Smtp-Source: AGHT+IH45On9bIt4gbYw83Kt3EXhOCeWnMaUuAdLAO3+4bzYYO2AGkK+W5L1+YqWMbcEUY41EuvZtg==
X-Received: by 2002:a17:902:aa87:b0:1dd:667f:bf1b with SMTP id d7-20020a170902aa8700b001dd667fbf1bmr106801plr.0.1711554341408;
        Wed, 27 Mar 2024 08:45:41 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:122::1:2343? ([2620:10d:c090:600::1:5ff4])
        by smtp.gmail.com with ESMTPSA id m6-20020a170902bb8600b001e10b6f45dasm1723113pls.295.2024.03.27.08.45.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Mar 2024 08:45:40 -0700 (PDT)
Message-ID: <7662a22e-caeb-4ffd-a4ee-482ff809e628@kernel.dk>
Date: Wed, 27 Mar 2024 09:45:40 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] io_uring: switch deferred task_work to an
 io_wq_work_list
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20240326184615.458820-1-axboe@kernel.dk>
 <20240326184615.458820-3-axboe@kernel.dk>
 <22f87633-9efa-4cd2-ab5d-e6d225b28ad5@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <22f87633-9efa-4cd2-ab5d-e6d225b28ad5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/27/24 7:24 AM, Pavel Begunkov wrote:
> On 3/26/24 18:42, Jens Axboe wrote:
>> Lockless lists may be handy for some things, but they mean that items
>> are in the reverse order as we can only add to the head of the list.
>> That in turn means that iterating items on the list needs to reverse it
>> first, if it's sensitive to ordering between items on the list.
>>
>> Switch the DEFER_TASKRUN work list from an llist to a normal
>> io_wq_work_list, and protect it with a lock. Then we can get rid of the
>> manual reversing of the list when running it, which takes considerable
>> cycles particularly for bursty task_work additions.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>   include/linux/io_uring_types.h |  11 ++--
>>   io_uring/io_uring.c            | 117 ++++++++++++---------------------
>>   io_uring/io_uring.h            |   4 +-
>>   3 files changed, 51 insertions(+), 81 deletions(-)
>>
>> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
>> index aeb4639785b5..e51bf15196e4 100644
>> --- a/include/linux/io_uring_types.h
>> +++ b/include/linux/io_uring_types.h
>> @@ -329,7 +329,9 @@ struct io_ring_ctx {
>>        * regularly bounce b/w CPUs.
> 
> ...
> 
>> -static inline void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
>> +static inline void io_req_local_work_add(struct io_kiocb *req, unsigned tw_flags)
>>   {
>>       struct io_ring_ctx *ctx = req->ctx;
>> -    unsigned nr_wait, nr_tw, nr_tw_prev;
>> -    struct llist_node *head;
>> +    unsigned nr_wait, nr_tw;
>> +    unsigned long flags;
>>         /* See comment above IO_CQ_WAKE_INIT */
>>       BUILD_BUG_ON(IO_CQ_WAKE_FORCE <= IORING_MAX_CQ_ENTRIES);
>>         /*
>> -     * We don't know how many reuqests is there in the link and whether
>> +     * We don't know how many requests is there in the link and whether
>>        * they can even be queued lazily, fall back to non-lazy.
>>        */
>>       if (req->flags & (REQ_F_LINK | REQ_F_HARDLINK))
>> -        flags &= ~IOU_F_TWQ_LAZY_WAKE;
>> -
>> -    head = READ_ONCE(ctx->work_llist.first);
>> -    do {
>> -        nr_tw_prev = 0;
>> -        if (head) {
>> -            struct io_kiocb *first_req = container_of(head,
>> -                            struct io_kiocb,
>> -                            io_task_work.node);
>> -            /*
>> -             * Might be executed at any moment, rely on
>> -             * SLAB_TYPESAFE_BY_RCU to keep it alive.
>> -             */
>> -            nr_tw_prev = READ_ONCE(first_req->nr_tw);
>> -        }
>> -
>> -        /*
>> -         * Theoretically, it can overflow, but that's fine as one of
>> -         * previous adds should've tried to wake the task.
>> -         */
>> -        nr_tw = nr_tw_prev + 1;
>> -        if (!(flags & IOU_F_TWQ_LAZY_WAKE))
>> -            nr_tw = IO_CQ_WAKE_FORCE;
> 
> Aren't you just killing the entire IOU_F_TWQ_LAZY_WAKE handling?
> It's assigned to IO_CQ_WAKE_FORCE so that it passes the check
> before wake_up below.

Yeah I messed that one up, did fix that one yesterday before sending it
out.

>> +        tw_flags &= ~IOU_F_TWQ_LAZY_WAKE;
>>   -        req->nr_tw = nr_tw;
>> -        req->io_task_work.node.next = head;
>> -    } while (!try_cmpxchg(&ctx->work_llist.first, &head,
>> -                  &req->io_task_work.node));
>> +    spin_lock_irqsave(&ctx->work_lock, flags);
>> +    wq_list_add_tail(&req->io_task_work.node, &ctx->work_list);
>> +    nr_tw = ++ctx->work_items;
>> +    spin_unlock_irqrestore(&ctx->work_lock, flags);
> 
> smp_mb(), see the comment below, and fwiw "_after_atomic" would not
> work.

For this one, I think all we need to do is have the wq_list_empty()
check be fully stable. If we read:

nr_wait = atomic_read(&ctx->cq_wait_nr);

right before a waiter does:

atomic_set(&ctx->cq_wait_nr, foo);
set_current_state(TASK_INTERRUPTIBLE);

then we need to ensure that the "I have work" check in
io_cqring_wait_schedule() sees the work. The spin_unlock() has release
semantics, and the current READ_ONCE() for work check sbould be enough,
no?

>>       /*
>>        * cmpxchg implies a full barrier, which pairs with the barrier
>> @@ -1289,7 +1254,7 @@ static inline void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
>>        * is similar to the wait/wawke task state sync.
>>        */
>>   -    if (!head) {
>> +    if (nr_tw == 1) {
>>           if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
>>               atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
>>           if (ctx->has_evfd)
>> @@ -1297,13 +1262,8 @@ static inline void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
>>       }
>>         nr_wait = atomic_read(&ctx->cq_wait_nr);
>> -    /* not enough or no one is waiting */
>> -    if (nr_tw < nr_wait)
>> -        return;
>> -    /* the previous add has already woken it up */
>> -    if (nr_tw_prev >= nr_wait)
>> -        return;
>> -    wake_up_state(ctx->submitter_task, TASK_INTERRUPTIBLE);
>> +    if (nr_tw >= nr_wait)
>> +        wake_up_state(ctx->submitter_task, TASK_INTERRUPTIBLE);
> 
> IIUC, you're removing a very important optimisation, and I
> don't understand why'd you do that. It was waking up only when
> it's changing from "don't need to wake" to "have to be woken up",
> just once per splicing the list on the waiting side.
> 
> It seems like this one will keep pounding with wake_up_state for
> every single tw queued after @nr_wait, which quite often just 1.

Agree, that was just a silly oversight. I brought that back now.
Apparently doesn't hit anything here, at least not to the extent that I
saw it in testing. But it is a good idea and we should keep that, so
only the first one over the threshold attempts the wake.

-- 
Jens Axboe


