Return-Path: <io-uring+bounces-11328-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C344CEA1E2
	for <lists+io-uring@lfdr.de>; Tue, 30 Dec 2025 17:01:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 44F10300532A
	for <lists+io-uring@lfdr.de>; Tue, 30 Dec 2025 16:01:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE82631ED89;
	Tue, 30 Dec 2025 16:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="oicLNbGz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502AD2E0401
	for <io-uring@vger.kernel.org>; Tue, 30 Dec 2025 16:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767110512; cv=none; b=RGMV7LFtDXUr9RvdWkfWopChBLIUY4KKVJc5TG/uWEHs8gOasAy3EtH9OOkPIZA6+xaJDcHGRsdLO1eFhOv7icwKJ+L+Xf5Q+Sxou4A2+iEtIV2dmxKaTUyOKshb9VdgOLB++7726OXTj6Ou+UutTJmv/uvfvgNTr0gRRmCZbFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767110512; c=relaxed/simple;
	bh=Czoa0Kp+hY6TKaw7SoJcHPtP79La43NnipreUMbv00s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H4P+rJR5fdN8pPgUIBsMIeWOerhcV4o10syChNEJJ+fnPlWA6/4HHQEM4Pa3nu7M+qzXnYnVjrVgkjWkxkaGPw+gAZEHGV2sdVbdb5OAu8Yz/e7xhUuj4rUtR4kjlu7zGbTnCaAWbVtrc4QfibjevB/YxPIKpY/81gC2a3MUpoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=oicLNbGz; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7c78d30649aso6831235a34.2
        for <io-uring@vger.kernel.org>; Tue, 30 Dec 2025 08:01:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1767110509; x=1767715309; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TcsmC9rFND+k/Zu82FdBSgGWIRL+xP3ul4I6+BnHQr4=;
        b=oicLNbGzbNGC2mLsoPGozoACZaQdNyh41OgadGF9MNrlVpcuXdq+p7bsIuTZnbAV2w
         1pnagqax9Z2tD3gzGai1XuVnVmR64T7TQD/xkhLYDmQWamgMgNI+6UeWBguE5dr0ntP5
         VVBgqYmgl6nKWwHnOJNxs3N+go9c82jUDJX3ndStVnTSKis5jPdhcFukh5oVqetJdtdE
         TB4nBng2DnMTaYD0oQ32PepegWCTSjaAmqTtWo0YvtXr0ugXlmGXC+MeIKIsqRYCw5Ly
         EEQGxYIhsIcv++w284C46IqRLkdhqtGKugsb1apklJG/3+fmt0w3FM8JiwL95cpBzrF6
         z5Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767110509; x=1767715309;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TcsmC9rFND+k/Zu82FdBSgGWIRL+xP3ul4I6+BnHQr4=;
        b=fmYlc8LRan+/MQ69BVm6ppbbZ0MbrVgY+ZikkOJDQunHqfTJ7Jo+iVm4tN5L42nfLf
         t/+qAgKwRHjsS2aTfxLdAHS/ihJs9ArQepRCdvstpV3OoTGCs9KtEyvMN7pdDdburzdX
         v2BUTKIO/pUAV4TphDH+vwW/EH4KJMyIllRDMl8Uyf4oXiKGZc9DXJGqwS/ktCKKX2Qj
         uJmcpBrPwP7GrTtTzk4gjz/830W7rQ6mfKa8iuTEN3275lTUez2V5+NIGLQTdtie1VUa
         10Vh0HoWZeMLZXMnnhYwKHTO5jPxTTUaZ4Pl3Gx4c636bqf9hPgQgkZWZFruTkgYO/hH
         vxlA==
X-Gm-Message-State: AOJu0YwCLmgtn5U8nFYQbmODJUAxdJYr2Na3G1WiyAuigswM6SzvILD0
	bHcrgeUGbmYMmKiCwoFXJ/bULgJ3+EZK0gYYdFU6KfVPt3c99sbILvcV8U4DfIvWEq0=
X-Gm-Gg: AY/fxX69WnzTgQQajCig7+Wi+xQMkigulVB5CqFIV+mef9TuJZ1MD0J8v0p5TjsuR8g
	xjcQwOOUtksdMSBMyqzpyJRzZM797unMQThcvrDZg5YOdeKK8nheTht6P6iqdWYesrp0FYsM0RW
	hNJqrEtdRdg8bOSx8d83J1bh2wGYNcxYsWDBLO1kZ/I8EY093EvQmY5hEs6ZbFTmFvih12sMYT8
	0UZHyGViw3vV1Qjd848gZ9FU7vXFcxvqmETuTULKEprL2TXlmxkCm5toDje7ipES5bOEjOiaFfT
	qQheaU2Ovh2lsv3rB/CKZdVKvL6P7VP9OVFlGd/PYbnpwbXWLcKqeW2UpNmv1uOqFLTlksHD3UI
	2FyiWxQMxqPbzxSlG+kAKOIlVLsGwocZOrbWpcl03PmPaM684ity6TtPhXFxO9SMAblqPHweHjO
	guqbYw8aeP
X-Google-Smtp-Source: AGHT+IEw08M+6Y7r9kqQYjCzGYu60U7ro1MnIP6UINE9Aq1Z2cmf7ihI84cze00Pb6YN3X72eA3v7w==
X-Received: by 2002:a05:6830:3690:b0:7c7:80e5:245f with SMTP id 46e09a7af769-7cc66a17d42mr20905042a34.30.1767110508772;
        Tue, 30 Dec 2025 08:01:48 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cc667563ffsm22947043a34.13.2025.12.30.08.01.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Dec 2025 08:01:47 -0800 (PST)
Message-ID: <d2e534de-f478-4dc6-8f17-a080275c2c5f@kernel.dk>
Date: Tue, 30 Dec 2025 09:01:46 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: make overflowing cqe subject to OOM
To: Alexandre Negrel <alexandre@negrel.dev>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20251229201933.515797-1-alexandre@negrel.dev>
 <a8a832b9-bfa6-4c1e-bdcc-a89467add5d1@kernel.dk>
 <5YHjvAsQKKhRWwp95PB0tGlW7nmplpjVW0b5mruoUD73qmg89ntObcPe63oCPf1mhBUh-Y3ARNMcPueF2dUttoWCyWv_KiG3VMIbguuOJHY=@negrel.dev>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <5YHjvAsQKKhRWwp95PB0tGlW7nmplpjVW0b5mruoUD73qmg89ntObcPe63oCPf1mhBUh-Y3ARNMcPueF2dUttoWCyWv_KiG3VMIbguuOJHY=@negrel.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/30/25 7:50 AM, Alexandre Negrel wrote:
>> I'm assuming the issue here is that memcg will look at __GFP_HIGH
>> somehow and allow it to proceed?
> 
> Exactly, the allocation succeed even though it exceed cgroup limits.
> After digging through try_charge_memcg(), it seems that OOM killer
> isn't involved unless __GFP_DIRECT_RECLAIM bit is set (see
> gfpflags_allow_blocking).
> 
> https://github.com/torvalds/linux/blob/8640b74557fc8b4c300030f6ccb8cd078f665ec8/mm/memcontrol.c#L2329
> https://github.com/torvalds/linux/blob/8640b74557fc8b4c300030f6ccb8cd078f665ec8/include/linux/gfp.h#L38
> 
>> In any case, then below should then do the same. Can you test?
> 
> I tried it and it seems to fix the issue but in a different way.
> try_charge_memcg now returns -ENOMEM and the allocation failed. The
> completion queue entry is "dropped on the floor" in
> io_cqring_add_overflow.
>
> So I see 3 options here:
> * use GFP_NOWAIT if dropping CQE is ok

We're utterly out of memory at that point, so something has to give. We
can't invent memory out of thin air. Hence dropping the event, and
logging it as such, is imho the way to go. Same thing would've happened
with GFP_ATOMIC, just a bit earlier in the process.

It's worth noting that this is extreme circumstances - the kernel is
completely out of memory, and this will cause various spurious failures
to complete syscalls or other events. Additionally, this is the non
DEFER_TASKRUN case, which is what people should be using anyway.

> * allocate using GFP_KERNEL_ACCOUNT without holding the lock then adding
>   overflowing entries while holding the completion_lock (iterating twice over
>   compl_reqs)

Only viable way to do that would be to allocate it upfront, which is a
huge waste of time for the normal case where the CQ ring isn't
overflowing. We should not optimize for the slow/broken case, where
userspace overflows the ring.

> * charge memory after releasing the lock. I don't know if this is possible but
>   doing kfree(kmalloc(1, GFP_KERNEL_ACCOUNT)) after releasing the lock does the
>   job (even though it's dirty).

And that's definitely a no-go as well.

-- 
Jens Axboe

