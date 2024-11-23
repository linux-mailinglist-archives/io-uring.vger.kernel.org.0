Return-Path: <io-uring+bounces-4999-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F5999D66D8
	for <lists+io-uring@lfdr.de>; Sat, 23 Nov 2024 01:36:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E4CCF28182D
	for <lists+io-uring@lfdr.de>; Sat, 23 Nov 2024 00:36:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A74323BE;
	Sat, 23 Nov 2024 00:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pz+SmA3C"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C64920E3
	for <io-uring@vger.kernel.org>; Sat, 23 Nov 2024 00:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732322159; cv=none; b=dGLnqr6fRgaxi6/R8Kbebbc9dlgj97gBapqRIgoOzowJg6gSg9Ri2NHPmsYywIse4/cp0gMYUcZZ5+blJhv7tJbui7qHaYeIIvnzogksU02+OP8QjhIUJEeay2os6vh2Q7IOY+Rt1tWqXs+YWM4jr+QI9DY5r0VTE6Lba4h2ihc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732322159; c=relaxed/simple;
	bh=Q23qB6RUYLYuFF8LcezBhpJ6ez8i9a5x361nwB89yGs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=myq3Y/+CWzXYWvuoBS2/5L1V9TdTvSWBIyDyIXpsvBLAfbfxdyVF1z7dqS/dhkQqSXYSLtji5khoBGa3QSc5GSGbEA+V0TPFbqwnZpVtB0QEyqiV1Sb6bJ2FgS5sy1u32ErM7lqpQ1kHIpm6M431Akz2ga5biLYFFNyK6WtaYbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Pz+SmA3C; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a9aa8895facso438171566b.2
        for <io-uring@vger.kernel.org>; Fri, 22 Nov 2024 16:35:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732322156; x=1732926956; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SSiCoNUMyVsuoJS9eXcq8z67gZGIDt3/VrkLO4ePI80=;
        b=Pz+SmA3CKwSblq2jDudnIJIO+1jKCncmhEPKJfsfuZQMY95RVYtPz03NztXr867NAu
         jwDERi79rpHTOalTdi4keSzrDIYjwJTMPAP2FDmgcleZfIhMgL8oqwjOjiDZR+W+At6A
         QPMvkOQvpPTTf88bQha/NqP22zcaS+aPIPMKs9BAGcl/C952gQf5LNK5q46unau3rhyu
         blU+2L7FdzIo7KMaoOGH+7FAZnhQBT0XkHbAf88+CsdjVwWxuHObQpPYPY3HfxneviTh
         g9SNq2Qmr8nIFtJVwl2SaaVdDKWHUDn3kMiu2oAMBsf95EmUQKnySKcIQMDxl5VPo4JG
         PD+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732322156; x=1732926956;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SSiCoNUMyVsuoJS9eXcq8z67gZGIDt3/VrkLO4ePI80=;
        b=QEIQbaviuGzRmvclGzKpvYJ4nySgDRsPQmXQhEA52rYZWKh0I57aWsdjN112Y+0THf
         DSvVt7cg1xYOdidOuTTrWLQy+74m5thxWLi6un7TVW/EiHT1nE7xcivK6++Kv1UBumxZ
         K4EEb7d+C9yv77vZ0oaQ6OcS3pJPNbim/gP0NKPLyriX+fHS2OREqlkwf1uC7bnrChtp
         6BjswEL9QXX+DN+Eo/M8KlgcpFDGuJ8tAjKfEHlVyr4GLMvqIId3zV+peIkAOWiALG8x
         JSHahBLDDkSfJ3qUVRL4bQbYSaYioa72mfBBnWRdre725rnW1Ty9fErsYyZ0R6nIPbJl
         Muqg==
X-Forwarded-Encrypted: i=1; AJvYcCWTLsONIVt1ItCoR8uCZe73gzdrDYU7HODg6AL90hj93BeV6ReD1XKptlIq/6GscLObqPbvCmXung==@vger.kernel.org
X-Gm-Message-State: AOJu0YxI+6RFemx3OflFZg1duawQiADvWJVDHklFO3lhdFihLDFsSVgb
	28Sj4mBpB/9JqFiuhU3sP1FcQ1KlIVFnOVbTLnZm7CDzyIsI6cINGWPdCA==
X-Gm-Gg: ASbGnct+e0Lvk9nRSS8ya/kwj3fDO0HaLSkq03RLv/M4/XT3ToY9PdxwZWTVeRRrykm
	02dM7ICVOGa8e3KgUeZZ93KtE4C2VaegS6D+k02kFpNInlbtHOV/Vw9ChR22RPKIX4Uw3cji7sG
	mEeTwWA6/wlBVNI86hfoaVNLhoZoRUPj1yDRZXmML4RRt5sOWrpjBJKdDv08BxDqzP7313PgpgE
	xtzUlFLTl13GNCSRjrZ0ZLhJbTSQk/oA1P3fCrs4iBwjRBfawSju2e/ifTjug==
X-Google-Smtp-Source: AGHT+IHYFafDblW6rQ7BIZMhggEDe2g9y0jhbNVswuU63vXYQxwNYmUBY90Lo5Bobg2ZvkxhFJzjOA==
X-Received: by 2002:a17:906:bfea:b0:aa1:e050:89 with SMTP id a640c23a62f3a-aa50997d270mr379442866b.25.1732322155416;
        Fri, 22 Nov 2024 16:35:55 -0800 (PST)
Received: from [192.168.42.180] ([148.252.140.238])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa50b5b7077sm155536366b.174.2024.11.22.16.35.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Nov 2024 16:35:55 -0800 (PST)
Message-ID: <c95b6e96-d16e-4713-a7e3-a98abdda0afa@gmail.com>
Date: Sat, 23 Nov 2024 00:36:47 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] io_uring: replace defer task_work llist with
 io_wq_work_list
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20241122161645.494868-1-axboe@kernel.dk>
 <20241122161645.494868-3-axboe@kernel.dk>
 <f0c124b6-9a38-45ed-86ac-b219a51917e9@gmail.com>
 <988485cb-a8da-4113-bcd5-3c1d1b2ab24f@kernel.dk>
 <dd280b03-aa0d-478d-b5b0-36646c0c8fcb@gmail.com>
 <0c964cee-98cd-4783-983e-b39505519316@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <0c964cee-98cd-4783-983e-b39505519316@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/22/24 17:44, Jens Axboe wrote:
> On 11/22/24 10:25 AM, Pavel Begunkov wrote:
>> On 11/22/24 17:11, Jens Axboe wrote:
>>> On 11/22/24 10:07 AM, Pavel Begunkov wrote:
>>>> On 11/22/24 16:12, Jens Axboe wrote:
>>>> ...
>>>>>     static inline void io_req_local_work_add(struct io_kiocb *req,
>>>>>                          struct io_ring_ctx *ctx,
>>>>> -                     unsigned flags)
>>>>> +                     unsigned tw_flags)
>>>>>     {
>>>>> -    unsigned nr_wait, nr_tw, nr_tw_prev;
>>>>> -    struct llist_node *head;
>>>>> +    unsigned nr_tw, nr_tw_prev, nr_wait;
>>>>> +    unsigned long flags;
>>>>>           /* See comment above IO_CQ_WAKE_INIT */
>>>>>         BUILD_BUG_ON(IO_CQ_WAKE_FORCE <= IORING_MAX_CQ_ENTRIES);
>>>>>           /*
>>>>> -     * We don't know how many reuqests is there in the link and whether
>>>>> -     * they can even be queued lazily, fall back to non-lazy.
>>>>> +     * We don't know how many requests are in the link and whether they can
>>>>> +     * even be queued lazily, fall back to non-lazy.
>>>>>          */
>>>>>         if (req->flags & (REQ_F_LINK | REQ_F_HARDLINK))
>>>>> -        flags &= ~IOU_F_TWQ_LAZY_WAKE;
>>>>> +        tw_flags &= ~IOU_F_TWQ_LAZY_WAKE;
>>>>>     -    guard(rcu)();
>>>>
>>>> protects against ctx->task deallocation, see a comment in
>>>> io_ring_exit_work() -> synchronize_rcu()
>>>
>>> Yeah that's just an editing mistake.
>>>
>>>>> +    spin_lock_irqsave(&ctx->work_lock, flags);
>>>>> +    wq_list_add_tail(&req->io_task_work.work_node, &ctx->work_list);
>>>>> +    nr_tw_prev = ctx->work_items++;
>>>>
>>>> Is there a good reason why it changes the semantics of
>>>> what's stored across adds? It was assigning a corrected
>>>> nr_tw, this one will start heavily spamming with wake_up()
>>>> in some cases.
>>>
>>> Not sure I follow, how so? nr_tw_prev will be the previous count, just
>>> like before. Except we won't need to dig into the list to find it, we
>>> have it readily available. nr_tw will be the current code, or force wake
>>> if needed. As before.
>>
>> The problem is what it stores, not how and where. Before req->nr_tw
>> could've been set to IO_CQ_WAKE_FORCE, in which case following
>> requests are not going to attempt waking up the task, now work_items
>> is just a counter.
>>
>> Let's say you've got a bunch of non-lazy adds coming close to each
>> other. The first sets IO_CQ_WAKE_FORCE and wakes the task, and
>> others just queue themselves in the list. Now, every single one
>> of them will try to wake_up() as long as ->cq_wait_nr is large
>> enough.
> 
> If we really care about the non-lazy path as much, we can just use the

Well, it's all linked requests, some of sendzc notif until
I optimise it, maybe something else?

> same storing scheme as we did in req->nr_tw, except in ->work_items
> instead. Not a big deal imho.

Yes please. It wouldn't be great sneaking them in the same
commit either way.

-- 
Pavel Begunkov

