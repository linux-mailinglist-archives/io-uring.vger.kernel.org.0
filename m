Return-Path: <io-uring+bounces-4986-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BBEF9D6303
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 18:24:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D0D67282663
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 17:24:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1507E154BFB;
	Fri, 22 Nov 2024 17:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TEpXJuUA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B82815B10E
	for <io-uring@vger.kernel.org>; Fri, 22 Nov 2024 17:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732296290; cv=none; b=f2QeLKolg7jpimTOXRxqcoKRN3aev1My6KXBbcdfHVlkzLUjROBLdlQ9CKmj08rN/nJIfmHk7ARAstTW9bTbDKxct8ei8Y0ns0VF7NbNyzwGcOPjNQgQ8sgWUDKnAGHxEsehgGmoqv5SP44JwoqJONlyCwx+Rfo1Z5L/FXaMHe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732296290; c=relaxed/simple;
	bh=B820RUCZwOOlQAGZy4Ytx9OD/eE3dHljfa2D7OZ8k40=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=tGyc5V2r1sINYD8EEhCAnlY1TyowXcCsdAGSWYHq3oa16mOVg4CXRTRhXnD5pDgue1o6WD0LNnBgid86Hkr4fh8ww+acw0uaMsQiVNYjkv8tssd80l0Lz/HAgEJbNBIvRIV7O59rEpO6GVxAkLie6Z6/J3LLoa0BFGrCkoK9IN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TEpXJuUA; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5cf6f367f97so2684208a12.0
        for <io-uring@vger.kernel.org>; Fri, 22 Nov 2024 09:24:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732296286; x=1732901086; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vjYzxkMiNvsuqfFzX+aVIS0XTw2Uo9I9m/n+1pChCTk=;
        b=TEpXJuUALP1EI1V5GBE/pO8o6uVgCPNLTA3me2kf9s8ckJIypCFN9p0JN+bIgaxAcC
         ZhhzqtLplQ3aUA/LKcl1lOB0lOcnZpHiQ6ck6in5mr0f7MWvyKB5qG6tf8f+oC7cGS5S
         XF79lBMLngwfwEsvVvfN5Dpaom/0g9dE3IIkThkGsyG+2KB+C7hmOAnDAFBpI4YV20Jc
         PePTAGeBAIDq6qagj3sLltMfCXOP6QKi1yB8OfSlSxca5FYJE0qvvvbKG3iqZoph9lcR
         u+q3UbkpdVTCk36ovEaNRs7bmP1xkOxe7kNDiyHn8gwAAKhrsTjcVnRQKcd8tQpj8fS8
         4qJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732296286; x=1732901086;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vjYzxkMiNvsuqfFzX+aVIS0XTw2Uo9I9m/n+1pChCTk=;
        b=CwQyMp422GANykqJmF5smz/U8wSbnbJEnhSk+wEDmOR5qIBaQf2/RPxD/GokMbHcWK
         bk9C97cegY3TqmS+LdsXTrxAKlcVmJfyDxpmgib/u/sBmoC9dyFjaa2lJxyM/FQDnot9
         UrO2cgP94+VB2SM1ssKo9BgGu81h6YLcBapd2KAYlWQCn0viGTYf29RTN7m4bmH3I5qt
         egliuUAF/6UiatF3snM93Bq+agR8Iq4f4aaFQCJqs3CMnLsmZHLlLev1PJBxyB1tGSN7
         p1youES1cg1BtaPNacFCfNAz3qYfUIhkPuun6QmUceNCKQOHzleVFldwZIoZScDk2UJ2
         nPfQ==
X-Forwarded-Encrypted: i=1; AJvYcCV1C+GgHW5jMlgu+jx1L5HDND8rURzWKWP/FpKL2omLqSpqW7RyB09930GNTFSk22UzuM3WInmghw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzEvTb2Ak5Gd2cn3EOxvhaPssiIbOrSmRAFCSBAj33IqpQ7Mmx0
	Np56KtojRP2WAzM3qIx+jcE0GLmrZyC0ckDS468rUQYc1Nxrum1m
X-Gm-Gg: ASbGncs78y16pza17i4bv6T47p3uFb/EwLUDq9j5WfxgmMkEJ3JwyA20HY76QTtiokF
	XmmKaVPhRIk2UltR23iGD8GfgAkT9BtdAH05kwGfGX2z+cc3LJgVcnLGMQpE2SWXlR2+SeRffY5
	+z8dQZCjs+863j4cNWpS5XqFOkTCWThqh2HU/mq9o4W5cWuI+8I1DAd/IlKxZ3ers3us/exgryw
	CTV7VFn/2kR82F0dCYXks0fTl/UAuCxyAF1lBjhG/YYpf+z1k55tHD9DB51Fg==
X-Google-Smtp-Source: AGHT+IG5Fj2rdwoBu6/KbpuEefR4R+ojSCdYzQuZrV6ZDXb48siA1cVtJ8e+ktZ+uDaH0tt0hohSxw==
X-Received: by 2002:a05:6402:4491:b0:5cf:a20:527c with SMTP id 4fb4d7f45d1cf-5d0206951e4mr2514741a12.21.1732296286306;
        Fri, 22 Nov 2024 09:24:46 -0800 (PST)
Received: from [192.168.42.180] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d01d41a382sm1107043a12.72.2024.11.22.09.24.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Nov 2024 09:24:45 -0800 (PST)
Message-ID: <dd280b03-aa0d-478d-b5b0-36646c0c8fcb@gmail.com>
Date: Fri, 22 Nov 2024 17:25:40 +0000
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
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <988485cb-a8da-4113-bcd5-3c1d1b2ab24f@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/22/24 17:11, Jens Axboe wrote:
> On 11/22/24 10:07 AM, Pavel Begunkov wrote:
>> On 11/22/24 16:12, Jens Axboe wrote:
>> ...
>>>    static inline void io_req_local_work_add(struct io_kiocb *req,
>>>                         struct io_ring_ctx *ctx,
>>> -                     unsigned flags)
>>> +                     unsigned tw_flags)
>>>    {
>>> -    unsigned nr_wait, nr_tw, nr_tw_prev;
>>> -    struct llist_node *head;
>>> +    unsigned nr_tw, nr_tw_prev, nr_wait;
>>> +    unsigned long flags;
>>>          /* See comment above IO_CQ_WAKE_INIT */
>>>        BUILD_BUG_ON(IO_CQ_WAKE_FORCE <= IORING_MAX_CQ_ENTRIES);
>>>          /*
>>> -     * We don't know how many reuqests is there in the link and whether
>>> -     * they can even be queued lazily, fall back to non-lazy.
>>> +     * We don't know how many requests are in the link and whether they can
>>> +     * even be queued lazily, fall back to non-lazy.
>>>         */
>>>        if (req->flags & (REQ_F_LINK | REQ_F_HARDLINK))
>>> -        flags &= ~IOU_F_TWQ_LAZY_WAKE;
>>> +        tw_flags &= ~IOU_F_TWQ_LAZY_WAKE;
>>>    -    guard(rcu)();
>>
>> protects against ctx->task deallocation, see a comment in
>> io_ring_exit_work() -> synchronize_rcu()
> 
> Yeah that's just an editing mistake.
> 
>>> +    spin_lock_irqsave(&ctx->work_lock, flags);
>>> +    wq_list_add_tail(&req->io_task_work.work_node, &ctx->work_list);
>>> +    nr_tw_prev = ctx->work_items++;
>>
>> Is there a good reason why it changes the semantics of
>> what's stored across adds? It was assigning a corrected
>> nr_tw, this one will start heavily spamming with wake_up()
>> in some cases.
> 
> Not sure I follow, how so? nr_tw_prev will be the previous count, just
> like before. Except we won't need to dig into the list to find it, we
> have it readily available. nr_tw will be the current code, or force wake
> if needed. As before.

The problem is what it stores, not how and where. Before req->nr_tw
could've been set to IO_CQ_WAKE_FORCE, in which case following
requests are not going to attempt waking up the task, now work_items
is just a counter.

Let's say you've got a bunch of non-lazy adds coming close to each
other. The first sets IO_CQ_WAKE_FORCE and wakes the task, and
others just queue themselves in the list. Now, every single one
of them will try to wake_up() as long as ->cq_wait_nr is large
enough.

-- 
Pavel Begunkov

