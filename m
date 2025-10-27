Return-Path: <io-uring+bounces-10236-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id C83E7C0EE27
	for <lists+io-uring@lfdr.de>; Mon, 27 Oct 2025 16:17:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 760A44FFD27
	for <lists+io-uring@lfdr.de>; Mon, 27 Oct 2025 15:10:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50DDD1F5820;
	Mon, 27 Oct 2025 15:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="gMxpHuoD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D1E75695
	for <io-uring@vger.kernel.org>; Mon, 27 Oct 2025 15:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761577831; cv=none; b=keEq/sl+1M5wXg6JGJoszKHtwt50wW2VPNHdCvhBVzG7pb8QF5/eEpGCclDyPk1+Qn1Bt5yQfY/w1RDgvOnYPru/3OdEJrCui4Yqi2vfkmsgUINS4Wc8kWOD/YQ0PuxcCwKkXVOUc/WsVizHoBvc1uDKEsFb8YNhGadm7FpuOrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761577831; c=relaxed/simple;
	bh=kqofIg89nc5Z32IB2dr/5ahmgNeRwPpcxCLz+3QcxA4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e0OUH3CxNO3noRQjFvESlqK+HW6o06XKSpWxfbOZIPuSYg4HWoq+pixEyzzZx2UY11Yxj7C9UEUi+K8O9DIZXtxWTqj89MZ1BX4q3bNMwVJQk6BQ28ECBkLLb2Ebn7eHSD3P56aZ7/fHaJ6OFTvJEZiTijdNODEb+MY7rdbuOvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=gMxpHuoD; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-34003f73a05so1683884a91.1
        for <io-uring@vger.kernel.org>; Mon, 27 Oct 2025 08:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1761577829; x=1762182629; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lyxrirk+6tjDBtbmJu3GhvQyRi0O9TS3VoH7obQDPgI=;
        b=gMxpHuoD2hh3XbWPT6/x+X7Nn0aswz6FxuHds0Di2p1m7yw9b06r0lvnBrrfXUqOe3
         TohBVQxsXjn2iQ0nQ2bDylMM5NZOWNaw7BdDA7mqAQb0HT/QZNc10av5+k1EzHB0eBav
         Np+PdghGztTdayUaE0TEOSO4h1X6DqzdrgMG+t67zgqetKUUoTXAansDv/cc4iaUgFe+
         QJ/Jyvm0LDzi36vfU5cEkLpZfiheOxP7JYdxNusvuF2Ss9FTIgclH0lZZSK52fV/k8Wu
         1/y4a6DrLpcJxzg9OcIajME/mI0UJRjkpkK/o6XrTkGmgbIFdJcExtKN6mb+w3npPmD+
         4tJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761577829; x=1762182629;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lyxrirk+6tjDBtbmJu3GhvQyRi0O9TS3VoH7obQDPgI=;
        b=OFIbATjAFiBJpsUJwPTy08HsZXVhDgy0wStkBlJKJwd8zeznfpr4X9EBM1FV4lgvE8
         Y29rrzBuFLkq1mXFNFuObm+ZVSVxO6O3AOxf2m3n0UmmMlcf+Tlkfg/ceh5LBS7lqLpl
         nXQ9j0oRJ6mYvkxfz045vv1aXbffjCAWMWIzRGy9j9Z2zfjdZKk2f6HYs82qOf8nJ/gp
         E/47gRZstCUNjCmK9MXk6BldhWQVLFeqHV4KwYdcpz4XKv6NjRbGDFBhfz0EtlSEIXBl
         V5npLdNF5QEDoGNDpwtHWlNZExiRQRe9/qbT4qHPvf2L7moIR6guC4xLeh+6BvgAMM2E
         O3Tw==
X-Forwarded-Encrypted: i=1; AJvYcCUIYikQ6cCA70HsL8igKsdevKKg9yyz5JvO6qD3CilXsBBLgd3MWtm1bKzIWoVO9OSLkvJKr7qoFg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9RVkMnKOp4tGJu/IA0jU4fBZOGYIahbQ9QZub7ZTFC9mg1Rso
	bq2NTPny7PZIlLCqqefUTv3rWom5K1YitQgfaYcnJ7Og5+TsU7u3PHue1+3UvR/lv9c=
X-Gm-Gg: ASbGncsfCry8Obn6MvXw9Cvs4SIL8fET0+rKSMVpZwlgxWmHJss8zRZC3kVUn3ZxPqf
	CT4hDZ9/DSeimgjlk3ZyUQed7J1j/l2FWwXi2JGP0kbxkJG+EQiXfWrT2TzIxUX8eyt8J2AD6li
	fyeH2hmI1PvaPtamRIjoG50FPa6wfZDG7vCCeaMlIApR1dkRPK7GfWwZNHCPjwY+krj8hzbmx/r
	8nSdMuFsS3c//svRLUDBsbF6TbGQwfRFs9OvVonIvlww/ZhTAnpfycC2zaSgLsKMEE0+UZrF+Wu
	QalIafqXRA48D/l2pvkZPazDU1lL1y2tbiCAQZe3+82XP7MyWhrl3nomwvqT5IEFJZkb8suuelI
	CvnxYoIo2aC1f4AQ/2RGt8e/6PX+VZs9pVdONXvNJyR0xvKzEhQUDm3AwR7ricBpZlr6SmyhQQP
	/plIjCYrAVjn/VHKvhSYhoD0LO/FNN0O63cScM9zc=
X-Google-Smtp-Source: AGHT+IHcidZucLYAPn70DfrrmAT01Hh/eHmgzrlMaLiS7elvN97pNgYPBo5zW7jQaNtOY1fy2mYVig==
X-Received: by 2002:a17:90b:1c04:b0:330:b9e8:32e3 with SMTP id 98e67ed59e1d1-34025c65a32mr477193a91.12.1761577828748;
        Mon, 27 Oct 2025 08:10:28 -0700 (PDT)
Received: from [192.168.86.109] ([136.27.45.11])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33fed73b5bbsm8870070a91.7.2025.10.27.08.10.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 08:10:28 -0700 (PDT)
Message-ID: <03daf5d3-2019-4fc0-b032-8d24ad61d7c0@davidwei.uk>
Date: Mon, 27 Oct 2025 08:10:27 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] io_uring/zcrx: share an ifq between rings
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
References: <20251026173434.3669748-1-dw@davidwei.uk>
 <20251026173434.3669748-4-dw@davidwei.uk>
 <309cb5ce-b19a-47b8-ba82-e75f69fe5bb3@gmail.com>
 <60f630cf-0057-4675-afcd-2b4e46430a44@gmail.com>
Content-Language: en-US
From: David Wei <dw@davidwei.uk>
In-Reply-To: <60f630cf-0057-4675-afcd-2b4e46430a44@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025-10-27 04:47, Pavel Begunkov wrote:
> On 10/27/25 10:20, Pavel Begunkov wrote:
>> On 10/26/25 17:34, David Wei wrote:
>>> Add a way to share an ifq from a src ring that is real i.e. bound to a
>>> HW RX queue with other rings. This is done by passing a new flag
>>> IORING_ZCRX_IFQ_REG_SHARE in the registration struct
>>> io_uring_zcrx_ifq_reg, alongside the fd of the src ring and the ifq id
>>> to be shared.
>>>
>>> To prevent the src ring or ifq from being cleaned up or freed while
>>> there are still shared ifqs, take the appropriate refs on the src ring
>>> (ctx->refs) and src ifq (ifq->refs).
>>>
>>> Signed-off-by: David Wei <dw@davidwei.uk>
>>> ---
>>>   include/uapi/linux/io_uring.h |  4 ++
>>>   io_uring/zcrx.c               | 74 ++++++++++++++++++++++++++++++++++-
>>>   2 files changed, 76 insertions(+), 2 deletions(-)
>>>
[...]
>>> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
>>> index 569cc0338acb..7418c959390a 100644
>>> --- a/io_uring/zcrx.c
>>> +++ b/io_uring/zcrx.c
[...]
>>> @@ -734,6 +797,13 @@ void io_shutdown_zcrx_ifqs(struct io_ring_ctx *ctx)
>>>           if (xa_get_mark(&ctx->zcrx_ctxs, index, XA_MARK_0))
>>>               continue;
>>> +        /*
>>> +         * Only shared ifqs want to put ctx->refs on the owning ifq
>>> +         * ring. This matches the get in io_share_zcrx_ifq().
>>> +         */
>>> +        if (ctx != ifq->ctx)
>>> +            percpu_ref_put(&ifq->ctx->refs);
>>
>> After you put this and ifq->refs below down, the zcrx object can get
>> destroyed, but this ctx might still have requests using the object.
>> Waiting on ctx refs would ensure requests are killed, but that'd
>> create a cycle.
> 
> Another concerning part is long term cross ctx referencing,
> which is even worse than pp locking it up. I mentioned
> that it'd be great to reverse the refcounting relation,
> but that'd also need additional ground work to break
> dependencies.

Yeah, Jens said the same. I did refactoring to break the dep, so now
rings take refs on ifqs that have an independent lifetime.
io_shutdown_zcrx_ifqs() is gone, and all cleanup is done after ctx->refs
drops to 0 in io_unregister_zcrx_ifqs(). From each ring's perspective,
the ifq remains alive until all of its requests are done, and the last
ring frees the ifq. I'll send it a bit later today.


