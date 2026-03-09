Return-Path: <io-uring+bounces-12605-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wItLDqMer2neOAIAu9opvQ
	(envelope-from <io-uring+bounces-12605-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 20:25:23 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id B18E523FCC3
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 20:25:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 878C93031AFE
	for <lists+io-uring@lfdr.de>; Mon,  9 Mar 2026 19:22:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8262B363089;
	Mon,  9 Mar 2026 19:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="KdK0MGBS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E1B3624CB
	for <io-uring@vger.kernel.org>; Mon,  9 Mar 2026 19:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773084137; cv=none; b=hSLH2izTLLu3CaKUulIi14yEAzUkYuRbrmR09bY7zdwBENIStQ7ZNLP2wJCrA3ONrHsI+5CSmEyPw8ukSLC725lLPGQ48njHsgU7GkOPeX1p7JFlaTRh//umWsBlkdA37U96yd1lqtuC30ILCWuIzYicdGfi7GTVScn+5pXzNj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773084137; c=relaxed/simple;
	bh=K33C35wIJwlEe0O28qdG8S3iT8DnmYdO70VzMhsnxkI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mf9qpjjtJfJtY4JwiTFaCOJf6C1syIt3VXp7m+rRuThM79LpiO/dkJYbp5DLyerhINLy1iCEMn/I4A5L8xaOuc+WIuqMasVwmFgoJMC5IutF8uUjo4h3WLwm912j/DjmYEXhtJAo2LNjBQMwFSqZopMqMRQYGsdxJDmoF5uu3gY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=KdK0MGBS; arc=none smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-67ba53110e7so902747eaf.3
        for <io-uring@vger.kernel.org>; Mon, 09 Mar 2026 12:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773084133; x=1773688933; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8HpMZuPtWn0eUEVrzM2c3iQaTLyHyl2pOMpUueDCTiw=;
        b=KdK0MGBSsU0aezqy95UPKFdIsUFQBIDGZ95lbPC2eul8Is+w1ij0YWIiXL4bjbVwQa
         sgQEPQnrLrxPYOMPnrpfLfZat3mv117tPNTKFMQ3GRgolh1vEsozqEuDyLGXyYq0F/d9
         JCChMz4ttWCrmBXNe9WIQgMKWc10vk1qFm7ovZXRRWMZa+SDfKIeIDoQatVSX+cD1Mt8
         NDQ4PiAIWABskS4Fm0D6iudNdOpq22RLJ06IPL7IurDUSMkX813ruw2KJKYIb1uI0Wvx
         KXZdSFhHpWGnPMXFI+T6D1mX53KwTsVu87iW4DWXU5S2hwFohsjUR7/KpehMuQs2RM+S
         GJgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773084133; x=1773688933;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8HpMZuPtWn0eUEVrzM2c3iQaTLyHyl2pOMpUueDCTiw=;
        b=Udj+LqOO37fHTcnyfkTosF42Jh20gooo8cP+rgjhdjNHOoE81bDgbwaW2NuQUVCoej
         P9kexIJU3duC/VJKHHyOyUFIWpPbGgdbj+Q/Jm6YZJbcDFt58lh+ycTPSEbhaFxwU7u3
         HIEvmOEvoMUUn1BK72V6YOLgxuQWeztre0IjdbgZh91MpOnCmrBKFueYEFoI/+FBEw8P
         hKEaMUK3FLVGMLh+26dX5UaguxCakXWohiJtsVV4tfjnWKUz8YL2uDb/0ljzpVzP+orT
         wug/RHxqhbkZbQDQ1T6y2NuQ32OaPgOQx2rpouF3XUfEfjOXGhKY0uuUmqnM0dBO998x
         2daw==
X-Forwarded-Encrypted: i=1; AJvYcCXivZ1OCZRFsclpDwzt+14bnl1k07470jiOpa/T64gwepts5LURaExR+lCnaah1/XwdLOnK0OBfuA==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywzlr09sCtPAKPKRvLtlRO6MTeOGmd4fTddJd8wv5dphPVygsFZ
	Zkv2fRIcIZS932wmuYQfDXxY5dXpSTybxgC9qYWt8bE4pt45d0D8kqLPoq46HE05YdM=
X-Gm-Gg: ATEYQzyYJecJa5OiCVTCXF0xp5ZoFcFFoIu5SRCZYpijCXx6tvzmriifumi5q9iYZUQ
	Zt10WnX8HTBUFOQiF54rJgUCPztpasJMOBCATZxaj2W4Hv3pr3YTItvZthu6JlAZOj4JPGWnGO6
	0P2DdhMZwlX2oiZ7u+ewC79s0UV0xrD6Ggttd3+JV18LzjCc48wmjRptc2f2kAd83or45dFhRhd
	8Cgu23+maG8tSAiRX3FepCaCEMibhN4VCY5q8CwOqHV2QFoDWYh4xHGdRgAJdWh229R1FLUJYut
	5d5MpX21xnVIK/ycy58I04OPyKsPhhFlS1F6cMjc8SKw4CS5kGw4fVibwGYkAh/jqZciUZEqany
	FABmqGyXAZZFSVJBq2xrWu079Jymz0ZsqPnZ72U0Bxf8OHCek5AAUpIy9ARja40OJLlCgANw5y6
	TGSvHMvLXTrHfPb+JFLfujBNZizk2aGqGP3GUweg3QsWI7XriuQYIlOiM4mGC3lL0IPQw8M1xDa
	U579rQ7pQ==
X-Received: by 2002:a4a:dd04:0:b0:67b:a77a:e679 with SMTP id 006d021491bc7-67ba77ae8b4mr3618797eaf.31.1773084132972;
        Mon, 09 Mar 2026 12:22:12 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-67bac14b8c1sm3851538eaf.10.2026.03.09.12.22.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2026 12:22:11 -0700 (PDT)
Message-ID: <aabe81fa-299e-4b86-be57-933b1f7ce32a@kernel.dk>
Date: Mon, 9 Mar 2026 13:22:10 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] io_uring/register.c: fix NULL pointer dereference in
 io_register_resize_rings
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: Hao-Yu Yang <naup96721@gmail.com>, security@kernel.org,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CAHk-=wi-24g2yzRTHwJ-kD1RqK0TvuPBr0VzvuQVVzR83ddgsw@mail.gmail.com>
 <42AD516A-B078-40A5-94EE-80739B9883E7@kernel.dk>
 <453563bb-8dda-471a-901a-30ba9ff3f9c8@kernel.dk>
 <e9a7152d-3be9-44c2-8626-75ca9da7d408@kernel.dk>
 <CAHk-=wgqyb7M3LZK=+mZOmrS2YDfvh-WKeMeTDCXsoMMkLXfPw@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHk-=wgqyb7M3LZK=+mZOmrS2YDfvh-WKeMeTDCXsoMMkLXfPw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B18E523FCC3
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12605-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com,kernel.org,vger.kernel.org];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-0.997];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:mid,kernel.dk:email,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

On 3/9/26 1:03 PM, Linus Torvalds wrote:
> On Mon, 9 Mar 2026 at 11:35, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> --- a/io_uring/register.c
>> +++ b/io_uring/register.c
>> @@ -575,6 +575,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
>>          * ctx->mmap_lock as well. Likewise, hold the completion lock over the
>>          * duration of the actual swap.
>>          */
>> +       smp_store_release(&ctx->in_resize, 1);
>>         mutex_lock(&ctx->mmap_lock);
>>         spin_lock(&ctx->completion_lock);
> 
> The store-release doesn't actually make sense here. It just says "this
> store is visible after all previous stores".
> 
> It can still be delayed arbitraritly, and migrate down into the locked
> regions, and be visible to other cpus much later.
> 
> On x86, getting a lock will be a full memory barrier, but that's not
> true everywhere else: locks keep things *inside* the locked region
> inside the lock, but don't stop things *outside* the locked region
> from moving into it.
> 
> End result: the smp_store_release does nothing. You should use a write
> barrier (or a smp_store_mb(), but that's expensive).
> 
> But even *that* won't work - because the irq can already be running on
> another CPU, and maybe it already tested 'in_resize', and saw a zero,
> and then did that
> 
>      atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
> 
> afterwards.
> 
>> @@ -647,6 +648,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
>>         if (ctx->sq_data)
>>                 io_sq_thread_unpark(ctx->sq_data);
>>
>> +       smp_store_release(&ctx->in_resize, 0);
> 
> On the release side, the store_release would make sense - the store is
> visible to others after all the other stores are done (including,
> obviously, the new 'rings' calue)
> 
> But see above. This just doesn't *work*, because the irq - running on
> another cpu - will do the flag test and the cts->rings access as two
> separate operations.
> 
> All these semantics means that 'in_resize' needs to basically be a lock.
> 
> You can then use 'trylock()' in irq context *around* the whole
> sequence of using ctx->rings, to avoid disabling interrupts.

Agree - I think Pavel's suggestion to use an rcu protected pointer and
have the resize sync rcu is probably better though. As mentioned, resize
can be expensive, it's not a hot path operation. the local_work_add()
path is extremely hot, however.

I'll take a look with fresh eyes tomorrow.

-- 
Jens Axboe

