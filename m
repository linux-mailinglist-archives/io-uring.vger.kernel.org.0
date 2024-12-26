Return-Path: <io-uring+bounces-5608-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 45D1B9FCC1B
	for <lists+io-uring@lfdr.de>; Thu, 26 Dec 2024 18:01:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C542218828F1
	for <lists+io-uring@lfdr.de>; Thu, 26 Dec 2024 17:01:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05B577F7FC;
	Thu, 26 Dec 2024 17:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="tHYTnSrR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 297ED13D891
	for <io-uring@vger.kernel.org>; Thu, 26 Dec 2024 17:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735232495; cv=none; b=B+9dG+V5NgJuPE8ADjO41Ys1m/8CIjXWvHCZ7xrVvAxJzD7plEFal50tU4/nuJUJQ/4e5hX+WggHPgnGq9OfSuJBBNIGN1MieObAVf75+0/SegAzD6MobVNxrBXMpLx8umjtiwTa1h99blbxmDG5eedkzmJDPDtWXngfFCjQxLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735232495; c=relaxed/simple;
	bh=l5Orn3PX4mqDneZSu2j0R0MePqTm1Xj96u+vYI25Q+I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r8DnDyTTAuTGXnjR0cLAO/y/nze/msY81X4PNFN1lmFmwtcMnWTleneQlomzePf4RYDH462Y+2pOnNETgDJm63y86TJuMjgrC8Luq7GTjYpjnB5vyxsG9QSQ4LUkrCXvXtVzpr/0VHI18onEVjw+e7iBC2OJBttUj5fu8TWdZIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=tHYTnSrR; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-21a1e6fd923so5076865ad.1
        for <io-uring@vger.kernel.org>; Thu, 26 Dec 2024 09:01:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1735232491; x=1735837291; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HnZYTjOSbAiVdsDDecXP13lw0RuVCo4tPFLHYgjjdic=;
        b=tHYTnSrRyw8KtdsbZvMlCH490QDJG5XXEsjcRmclcIgXzujZw69vutou5kdE6UcPC3
         yEd9CJxW+Khl8EnAn/nH9RfCxeKczBkw3Yxrj3opy2rB3LB5nI6dYZlbDmF9DLsqG/Ef
         nXfsBZ3lFudMpR6Wvt0uK9f5VRQ3lZPfe4q6YIj/sagwVLkB/BKFnJE3yP3xi0Ih7nW3
         2t9IW7Ra0wLOwPBHR6IPIYQV0dCEFqHaP+cXQBgZIlUwolBKeDArug1EOYBfyRS2pA7K
         EytxIoqy5kMyGK4vxc7xIBl+Zs4BNGIPcJ7awekZ9sC9EjImbAJGuBB449gqvJOo3vyX
         U5xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735232491; x=1735837291;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HnZYTjOSbAiVdsDDecXP13lw0RuVCo4tPFLHYgjjdic=;
        b=dHh3Xu/q1ba2SgswI9nd46vjxNyIyMHIvOJqXUMhMS0sZf3MJi0sZuW7ZwTb0tTNeX
         6m7MqQic5Zgv5iAycwORt3QvTXnPIpHzFMoa/BApRWWKZ1ZN0+/DCJ4WePf2uqeDiPqn
         AcKgE/6y1qJ07/UtTKETBe2LX6CAK9MFQ6o2xz2bK5/JYOW5GiLxkWvfpTAqVf2Hb8uE
         Y8o2Z9cSiwVTgNLeaUv/e48C/m9eeDHYwRTBqzkRPNtoG9f+V040mtg584qLjSfnSQjL
         aG4aysCbak3Ag0YsrZP8me9SHfdvqb6noITZ5es/xvCrn/NI4T+caBCZ82nowOuUok1x
         frvQ==
X-Forwarded-Encrypted: i=1; AJvYcCUG4LDCPm2SdtTMhNEuHFf650eSFaLtx2W4ar4J6yey+IwWUX7gFz2G5ywfh70EwmxdTuFBhx9Pdw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0IZB6FRUhmXT4/qNC8W8IxPoj96UyhT19DCn96vBQMoMWoEeB
	G41Th3Wz8ah0fSbNYzi8M8rNh/XQBIOC7BNsnY4sDfVnoYXPVSS5Qilip2Ol9maOzrMCpNWyTa2
	A
X-Gm-Gg: ASbGncupQ3jjUZ7w0/smekIvI3KRDsQMpePZXi3WIpYcGx12ufxI2kTt534kUIkwogn
	ZiMCs63XGX8/TUv1ECDD6t5BsR4tOikC+iQTvnVzC/Rj5nEz2rKkacBMnxq1tFsSv/HAUSJPTsl
	ZEtQX7azDVkJgeTxZTYer7UQLYz4KsyW3F601E451IVZd3fOzYr1SWyt6uG27L+0bxzWCloa/IZ
	Vwr0xD2WiqD/sSx9ZeJaTVWuYqJXkL9slRXsw++jYUm3jHynPmYNg==
X-Google-Smtp-Source: AGHT+IHzBi9eQd0h+2qgwRz+urrHBnQQnt5NgdBFImDEjmcVYFmYOQjQy1Zy+7mHHXwxR/IpP5II5Q==
X-Received: by 2002:a05:6a00:44cc:b0:725:df1a:275 with SMTP id d2e1a72fcca58-72abdeb7016mr37754052b3a.23.1735232491332;
        Thu, 26 Dec 2024 09:01:31 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72aad8fb941sm13122560b3a.160.2024.12.26.09.01.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Dec 2024 09:01:30 -0800 (PST)
Message-ID: <39435dbf-7c37-49d4-af10-e773ab3eb0a0@kernel.dk>
Date: Thu, 26 Dec 2024 10:01:29 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/sqpoll: fix sqpoll error handling races
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: Kun Hu <huk23@m.fudan.edu.cn>
References: <0f2f1aa5729332612bd01fe0f2f385fd1f06ce7c.1735231717.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <0f2f1aa5729332612bd01fe0f2f385fd1f06ce7c.1735231717.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/26/24 9:49 AM, Pavel Begunkov wrote:
> BUG: KASAN: slab-use-after-free in __lock_acquire+0x370b/0x4a10 kernel/locking/lockdep.c:5089
> Call Trace:
> <TASK>
> ...
> _raw_spin_lock_irqsave+0x3d/0x60 kernel/locking/spinlock.c:162
> class_raw_spinlock_irqsave_constructor include/linux/spinlock.h:551 [inline]
> try_to_wake_up+0xb5/0x23c0 kernel/sched/core.c:4205
> io_sq_thread_park+0xac/0xe0 io_uring/sqpoll.c:55
> io_sq_thread_finish+0x6b/0x310 io_uring/sqpoll.c:96
> io_sq_offload_create+0x162/0x11d0 io_uring/sqpoll.c:497
> io_uring_create io_uring/io_uring.c:3724 [inline]
> io_uring_setup+0x1728/0x3230 io_uring/io_uring.c:3806
> ...
> 
> Kun Hu reports that the SQPOLL creating error path has UAF, which
> happens if io_uring_alloc_task_context() fails and then io_sq_thread()
> manages to run and complete before the rest of error handling code,
> which means io_sq_thread_finish() is looking at already killed task.

Might be worth mentioning that this is only really a fault injection
thing. But ouside of that, looks fine to me - thanks!

-- 
Jens Axboe


