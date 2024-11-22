Return-Path: <io-uring+bounces-4987-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 148C49D6382
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 18:45:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A1039B29AB7
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 17:44:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BB851DFDAA;
	Fri, 22 Nov 2024 17:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="DsrSq4DG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986D61DF961
	for <io-uring@vger.kernel.org>; Fri, 22 Nov 2024 17:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732297467; cv=none; b=Aqtw5Bja3AET3y134P2mI7PXg+TZkw8tcsUcAHoypDXe3pRGEFiJ1qQgqxEuswWLbpWVOker3xL1XqxSqYd6+Xu4Ij6eEZ+8NmtzLj+Q0WoqUMtRiypdLZeVbmqI1Y30uRT8mkNJdsd6pjzeV3xkhdN7yWmR7G/OpsjHdjPLw/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732297467; c=relaxed/simple;
	bh=j6G2fHdNNAylb+5OP0ZMLpWJfA6CkS8uo/1O57sA1tc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=WXqBXCIj651mMXonTy6P1p/PNQ0gNqD6BdTTOycshWwV0CZGlTIDBGSafoA1E7bp5khfc2bzFEYxt6oMqbYf0kXtvVEOe7Tg7+W53HdlfDX6SBwoPOoJqaP2Z7kQyWt9bsy8RKLY5zKCchmZf8fNSyv/jKvYmntcFaI2IVLFnts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=DsrSq4DG; arc=none smtp.client-ip=209.85.160.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-29678315c06so1378431fac.1
        for <io-uring@vger.kernel.org>; Fri, 22 Nov 2024 09:44:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732297462; x=1732902262; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yOAka99DTHWzGKpvkBaSjSnYN13kBy/yeK3JI4yE4BU=;
        b=DsrSq4DG85xWe7EQdqi6hSwPGvRlE2BljVjQKKm0pkoUfA5MTRmfeaxgy+ObP76Iyr
         O4l/L3/+85z8qkEYx6H/BNRlgsaoBllmTPA8rW8bcykfRgPL8nHD6bv+uGZGLzUYbzXi
         aGY52tttYfVBVPW4gVWf3FwG0OHO8KpbBImsxlTYL2pRcrLRwIZZVBRgRzEAsLDd6tJd
         7/lY6eg9kNqDnVdo6q0bVdRPkwCVrf3tIJXVG21Ix93VIxZ0Y6V1Dp2uqv/UhpC3rzKL
         l9YYfCOkp0IAFaNhQt6godkUQIqc5R3lUGWsH+U96PrW3IrqV2kPPx8RehCwL191lyBo
         SL6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732297462; x=1732902262;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yOAka99DTHWzGKpvkBaSjSnYN13kBy/yeK3JI4yE4BU=;
        b=AVnKkKA/kYDjMiIUnnkGTlhqOfQBgjrBFhpDBxJbUCcXWEeUnAcn94fs3WJ26qbSO4
         RV+fu4VubFkI4/QNsSh3iVDKYE35e0q21uIu8CSA3jSivFef+BPSi90nVIO2+yGnv6xO
         4xVfMfiDDUCR+Pyo1tpuqnMd++dNTwRyFy2t6aGFFCaSuqJFroeQN0GqjcZlthmGNBAB
         E04akw0WHcX1C6p9aplGferYFcE3JHxd/94IBrV1XlV0f3CHMCbUy+Ft/dP+SDhx6kxT
         sr/pIk+pGeiiGIKSiUY9943Tc7kWQfNlfOUPjo4PQeE7i9QoHeJEnegcFk5orcmgbyH3
         MN7Q==
X-Forwarded-Encrypted: i=1; AJvYcCUuXPW4F+/xIpzES/SzSDaKqngRM518Z4WRkbeUtdCrO5iNgbdA7k2mbUiFLPQcf/s521xJmBI4zw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyrwVut0K5s/GvQ8kA+2Oqk1lrPrr/m4YEdIsw4aZPY/1MIHiEt
	N/urSZaNoDhay0yICbGdWllxVIzsCgL8UNKP+Gb7cWMYL+vqrcFGshLs4CVec1gX0mRyMdJwvUx
	ux5k=
X-Gm-Gg: ASbGncuTOOI675ziVinZ2OzLuiJ5rVUpCCDqo3KEA9lOBLjfvpUHwhnbSs2tYQ5WQ7y
	abQlPszaSsXJbTTNu2qhsSG26rjUGv+mNmk0QLw1ppAUeASVsF7syu7FQKuM3JiZGqHZ4m+v4lu
	JD1zeGX1HhewFyu3DdUfuVePOtbnxxpcZMH6q8VXDVy5VxxM8ykNCsCDY0l/vugYLFfU4D349pE
	TSGLdPxrBqnq/+bh/YtZwWKnm/+0jdNVEpuwXfvr4iyow==
X-Google-Smtp-Source: AGHT+IGOjNWf1p0vwnkPaWiWRgfInkJKMHIclgqe0xItagY2uYHmqas8wJM0dMMZgzC2qfwOcIROZQ==
X-Received: by 2002:a05:6870:8e19:b0:261:22a4:9235 with SMTP id 586e51a60fabf-29720dfb763mr4047110fac.32.1732297462587;
        Fri, 22 Nov 2024 09:44:22 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5f069878417sm474419eaf.37.2024.11.22.09.44.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Nov 2024 09:44:21 -0800 (PST)
Message-ID: <0c964cee-98cd-4783-983e-b39505519316@kernel.dk>
Date: Fri, 22 Nov 2024 10:44:21 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] io_uring: replace defer task_work llist with
 io_wq_work_list
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20241122161645.494868-1-axboe@kernel.dk>
 <20241122161645.494868-3-axboe@kernel.dk>
 <f0c124b6-9a38-45ed-86ac-b219a51917e9@gmail.com>
 <988485cb-a8da-4113-bcd5-3c1d1b2ab24f@kernel.dk>
 <dd280b03-aa0d-478d-b5b0-36646c0c8fcb@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <dd280b03-aa0d-478d-b5b0-36646c0c8fcb@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/22/24 10:25 AM, Pavel Begunkov wrote:
> On 11/22/24 17:11, Jens Axboe wrote:
>> On 11/22/24 10:07 AM, Pavel Begunkov wrote:
>>> On 11/22/24 16:12, Jens Axboe wrote:
>>> ...
>>>>    static inline void io_req_local_work_add(struct io_kiocb *req,
>>>>                         struct io_ring_ctx *ctx,
>>>> -                     unsigned flags)
>>>> +                     unsigned tw_flags)
>>>>    {
>>>> -    unsigned nr_wait, nr_tw, nr_tw_prev;
>>>> -    struct llist_node *head;
>>>> +    unsigned nr_tw, nr_tw_prev, nr_wait;
>>>> +    unsigned long flags;
>>>>          /* See comment above IO_CQ_WAKE_INIT */
>>>>        BUILD_BUG_ON(IO_CQ_WAKE_FORCE <= IORING_MAX_CQ_ENTRIES);
>>>>          /*
>>>> -     * We don't know how many reuqests is there in the link and whether
>>>> -     * they can even be queued lazily, fall back to non-lazy.
>>>> +     * We don't know how many requests are in the link and whether they can
>>>> +     * even be queued lazily, fall back to non-lazy.
>>>>         */
>>>>        if (req->flags & (REQ_F_LINK | REQ_F_HARDLINK))
>>>> -        flags &= ~IOU_F_TWQ_LAZY_WAKE;
>>>> +        tw_flags &= ~IOU_F_TWQ_LAZY_WAKE;
>>>>    -    guard(rcu)();
>>>
>>> protects against ctx->task deallocation, see a comment in
>>> io_ring_exit_work() -> synchronize_rcu()
>>
>> Yeah that's just an editing mistake.
>>
>>>> +    spin_lock_irqsave(&ctx->work_lock, flags);
>>>> +    wq_list_add_tail(&req->io_task_work.work_node, &ctx->work_list);
>>>> +    nr_tw_prev = ctx->work_items++;
>>>
>>> Is there a good reason why it changes the semantics of
>>> what's stored across adds? It was assigning a corrected
>>> nr_tw, this one will start heavily spamming with wake_up()
>>> in some cases.
>>
>> Not sure I follow, how so? nr_tw_prev will be the previous count, just
>> like before. Except we won't need to dig into the list to find it, we
>> have it readily available. nr_tw will be the current code, or force wake
>> if needed. As before.
> 
> The problem is what it stores, not how and where. Before req->nr_tw
> could've been set to IO_CQ_WAKE_FORCE, in which case following
> requests are not going to attempt waking up the task, now work_items
> is just a counter.
> 
> Let's say you've got a bunch of non-lazy adds coming close to each
> other. The first sets IO_CQ_WAKE_FORCE and wakes the task, and
> others just queue themselves in the list. Now, every single one
> of them will try to wake_up() as long as ->cq_wait_nr is large
> enough.

If we really care about the non-lazy path as much, we can just use the
same storing scheme as we did in req->nr_tw, except in ->work_items
instead. Not a big deal imho.

-- 
Jens Axboe

