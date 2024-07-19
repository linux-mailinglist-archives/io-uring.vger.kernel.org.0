Return-Path: <io-uring+bounces-2532-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C2C3937CD0
	for <lists+io-uring@lfdr.de>; Fri, 19 Jul 2024 21:03:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B572D1F2177D
	for <lists+io-uring@lfdr.de>; Fri, 19 Jul 2024 19:03:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E1EB148304;
	Fri, 19 Jul 2024 19:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="QJFsuFpM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F3D147C89
	for <io-uring@vger.kernel.org>; Fri, 19 Jul 2024 19:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721415817; cv=none; b=X/DAjQrdjV6EQai7z2XBvjURr7vBlFh0+Lw4e8noFGpWTYCQqS82n3YGuRff0f8yz+dTF1ajB3KladFC6JwbJ79y7bsQUnOdo4fuicv6aRoXJYcGmauXoZEh9fmbqTs4kKJ3Fc/WO++YulMQYpaXXABtD3H0caYFrFfIZwChyeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721415817; c=relaxed/simple;
	bh=pMTDfzpCZXPgz5OqREcL7RtcEB8BhQFFrXJAqdK98nk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nAkHzmcWzPKOUR3KhRU9tidasGU2Mn95OCEo4yEAMrxlAQaaMppBLloU94bo/nb4R94NGfXaPABGDev9NI9/Sw9NYMerWPjZiJTU1eDVI65ld3SECRMPZLnEyfoSxYN7FgUUqC70pj+T7DebbdtMQzaYnEuVD0jngla8q0vHEn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=QJFsuFpM; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-810ca166fd4so10771639f.1
        for <io-uring@vger.kernel.org>; Fri, 19 Jul 2024 12:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1721415814; x=1722020614; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1cJ3nujP92wGCaS8wrcvZLk7tX2f2wnmqeR4tNSdaew=;
        b=QJFsuFpMie1ybm0JYWzjyBEnt/TfBX6oksdD/ALfWTkxyWAgdTaMaSzzVMUVmf08OQ
         U48Rm6xZ6kOYMxE2dQAta3eKNi7o2LTAQZ8QcfU7E0tJ30DfX5+kcevA2NaipdllZdh+
         jrgIH8fxd7Y/kxyNappjc8rOQ2ayCqhvxxPopuOSy36gTcpPdBMv+mpKBHLS8mjpCbad
         l/uRJY81/awyLyO7cEuFSEJDDXbovv+trj1/5Sm8uqOiv9Df9p7LP4S4hxbDPt+toib4
         KNJqOtf2l3EO/lQRA5DG5eHjs+mrkYz+ShnhVaJVr7u64rVSP4SgI/jqNo8ISmVn5wSr
         DmLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721415814; x=1722020614;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1cJ3nujP92wGCaS8wrcvZLk7tX2f2wnmqeR4tNSdaew=;
        b=LYoxjcSKS43XQlXfe2VVjvJiGBgm2LlptxIrUHYDglW2104GIYaYxlvfL1C4qi+6R1
         8pY7j4f38X5aniih9E4/ajZR6EPn4mQp3eqyAbH/3qKWH4wdYLCaN+aVJ3fJkRj/19cT
         arKpEO4rnSqStp5iZs1PSzAnvKz0ZnVkP4sLw+5po2krWtuX4iXhlDae2r2XtdZ5hCyD
         hVcwTMqpddk3OBRgnpUqNEacokj/ZBqWloIUisIpwLh21wy1H2m2GiXgzDYQccy2NSkc
         NDlRyJCBKwSSUY04MK8t2iVQAByrC0lPfeUemI1UrzTjobLmJRionpUWfS5ZiJI93T2L
         x9IQ==
X-Forwarded-Encrypted: i=1; AJvYcCX//LmkxuBRfWonHzJxm8AvKNu6dWXRIrTD5tUZieAZyPR8qdm6c7hCPuRv4rl5nGKmdIxY5uQvah4nfBfEm41JKkcst1CjWyc=
X-Gm-Message-State: AOJu0YwCiGYdTm0S+1AxODrSZtEaOxlp4u2IuiuPo29SzPm6RSgXNz16
	aEugJ6glbyYAwqMdgYcUYKGzz6/NUdBvA9ZGpOu6C4FYHH3NLwRLRlL2zVe4Wys=
X-Google-Smtp-Source: AGHT+IHW9lEL+oRST+LKLcLCjBpQgopnnESxVZwRdkHitdIZv7jCpbyhIgblbVfAYqK749KnBZNyHw==
X-Received: by 2002:a05:6e02:1a6e:b0:397:75a:39bd with SMTP id e9e14a558f8ab-398e67c4942mr4414845ab.3.1721415814111;
        Fri, 19 Jul 2024 12:03:34 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-79f0bb06d1asm620203a12.53.2024.07.19.12.03.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jul 2024 12:03:33 -0700 (PDT)
Message-ID: <2ee61a18-595e-4dda-a8c4-061c5a4803e0@kernel.dk>
Date: Fri, 19 Jul 2024 13:03:31 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: CVE-2024-41001: io_uring/sqpoll: work around a potential audit
 memory leak
To: Wang Zhaolong <wangzhaolong1@huawei.com>, cve@kernel.org,
 linux-kernel@vger.kernel.org, linux-cve-announce@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, io-uring@vger.kernel.org
References: <2024071253-CVE-2024-41001-7879@gregkh>
 <18634c7e-b234-ac02-20f8-4d5426733679@huawei.com>
 <4457af52-01a2-be1b-9d13-486b6bd8e579@huawei.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <4457af52-01a2-be1b-9d13-486b6bd8e579@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/18/24 8:41 AM, Wang Zhaolong wrote:
> Hello,
> 
> I think a possible reason for the leak scenario is:
> 
> When `audit_context->dummy` is 0. __audit_sockaddr() allocates sockaddr.
> 
> In the below process, audit_reset_context() return early. ctx->sockaddr
> is not released.
> 
>   io_issue_sqe
>     audit_uring_entry
>       __audit_uring_entry
>         ctx->dummy -- set dummy as non-zero
>     def->issue()
>     audit_uring_exit
>       __audit_uring_exit
>         audit_reset_context
> 
> static void audit_reset_context(struct audit_context *ctx)
> {
>     ......
>     /* if ctx is non-null, reset the "ctx->context" regardless */
>     ctx->context = AUDIT_CTX_UNUSED;
>     if (ctx->dummy)
>         return;
> 
>     ......
>     kfree(ctx->sockaddr);
>     ......
> }
> 
> The `audit_uring_entry(IORING_OP_NOP);` statement initializes the 'dummy' once at the
> beginning to ensure that ctx->sockaddr is allocated and deallocated in pairs later
> in the process.
> 
> According to the above analysis, I think the fixes tag should be
> 5bd2182d58e9 ("audit,io_uring,io-wq: add some basic audit support to io_uring")

It was introduced with the changes to the above commit, where you could
end up calling prep (which does the move_addr_to_kernel()) before audit
was ready for it. This is the call trace shown in the commit as well.
Which I _think_ is:

Fixes: f482aa986527 ("audit, io_uring, io-wq: Fix memory leak in io_sq_thread() and io_wqe_worker()")

but I'd have to double check. In any case, it's a leak on the audit
side.

-- 
Jens Axboe


