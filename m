Return-Path: <io-uring+bounces-1244-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E1B5188E710
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 15:48:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9865F1F28AD1
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 14:48:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 561A913E056;
	Wed, 27 Mar 2024 13:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FWQU6pRH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9928712CDBF
	for <io-uring@vger.kernel.org>; Wed, 27 Mar 2024 13:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711546741; cv=none; b=ojl4obacOUnkUAaQe6aPLMgMAT/OSKHHonCXjaAhiCzVUp7tj8yey7Cq9lwasxCkeiRYAqK2I+oMiP5SzhnUrI7VRytOJcgNB+U6ZtxC1fmDJEpn02M2ckAQWJLRpyUhgRYg+1JifHw4bKt7FuiM26gHVsaPf7TCpoKJmRerKGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711546741; c=relaxed/simple;
	bh=qEv3WfXVYwfPcIwgn5BdsTEM/DGJakFlA/pc5M7llk0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=fP7mXpAkZ3q5ODIzH9jRn7eW5GZ7VGZipJzmf9UKOGr3glM3I3IuaW1sUbKeWnzDmFoVVSdVgivNZbPNImO6U4wmWIUoa9xszX5kU8ad7sGTU1XkOu00hJfh9Kw3hzLBg6YyuWfnBrWvujXJfMfblCqtpAPxR+tGvi3dwpVlAVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FWQU6pRH; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-41488f9708fso22342985e9.3
        for <io-uring@vger.kernel.org>; Wed, 27 Mar 2024 06:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711546738; x=1712151538; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=e0G4wYm2kkEwpFvVU4Lg/fsX4bBlRQ3hh4e4CEfKJgw=;
        b=FWQU6pRHthCpL0vtNG0nynVRfiVgmkO9V7H1Cczg1mWCUgOimQWZACc+3+kv3g9XU0
         jDXm3Q8CssWjhz135aTnZYqL0OwO9W/elwh5K42wo762mILVtJ8TyJtW8y3Z9ZlMJ3Pi
         wGrWgpx5l1itFd5eVbSLzl2Ck8p6cA7vgxSgRFNghGhDmSBbl5Hu9eqVjVa0N3Qcee+T
         90Gsqwnys6qJ5UTDweneFsPM79/GQgTcOZNJ8kKqjT5g+94jJyazCYLkEAXDljum7Ow9
         8aDmltgEl53z/II90RPo4VUkicL+GB9H8EwtrbmeDFQ3EoYopNetWhZQ7cXeh6DeFLpl
         FEmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711546738; x=1712151538;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e0G4wYm2kkEwpFvVU4Lg/fsX4bBlRQ3hh4e4CEfKJgw=;
        b=ZFxGv4qTtiMsbEUTof86u0yi0MgNgaxRI5mhuqRUpZqwHOUgwTGs+OSFIvuSVpuVIS
         5p2MhbvhziG9qMRM+UWx3zX5JUYLcg3NiV6hMrR17o5bRNJsRl3bx/V6EJLM9xG5d45u
         7G1BSx551K3OAsWYD6xxqe3wbtDXbiA1M+kEEnoBuZWtCcHFZPOmH7pjrtUn8cOBKizE
         lwlWZWpriH6FfURxkljiFU34oVmJxRiislSwQorP1bceoAvjfrRaYglpEJ/u/S6ksfy7
         DF0S4Z2yEwOHFHVusY8kFxGfOdWtMH9DvsC1Y5ZL2PYgaoMHVruo6Glg/psbJCXnUunP
         WJLg==
X-Forwarded-Encrypted: i=1; AJvYcCU9O7GuShL99MF6kXygm2NFOe2xMVWB6DThCcwtIDVQ6mN8vtk7fbJobAlY/csNg0zK1TBKdVPsDqC4gp12rrThZnBmq9sk+Dg=
X-Gm-Message-State: AOJu0YwL/I+QtrGynhoSDnEVHVIx9Yh19h6RGgF+yH/yHwkbcKGylJCt
	8Y98O2x4WkGjT6fikBBQBHUnc/d+zhf/EDO+bjTRHSBt8sKF+9KlAnJrlP2c
X-Google-Smtp-Source: AGHT+IHYbO3YaaOdiJiEhsscRim+IjH2+FZERwIvIi/X/1cKDFQjLsGMCDmf5W1sCTwOL8bd1TfEGA==
X-Received: by 2002:a05:6000:1a4e:b0:33e:4d34:f40f with SMTP id t14-20020a0560001a4e00b0033e4d34f40fmr1969599wry.46.1711546737641;
        Wed, 27 Mar 2024 06:38:57 -0700 (PDT)
Received: from [192.168.8.100] ([85.255.233.105])
        by smtp.gmail.com with ESMTPSA id k13-20020adff5cd000000b0033ec9936909sm14930415wrp.39.2024.03.27.06.38.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Mar 2024 06:38:57 -0700 (PDT)
Message-ID: <03e57f18-1565-46a4-a6b1-d95be713bfb2@gmail.com>
Date: Wed, 27 Mar 2024 13:33:58 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHSET 0/4] Use io_wq_work_list for task_work
Content-Language: en-US
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20240326184615.458820-1-axboe@kernel.dk>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240326184615.458820-1-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/26/24 18:42, Jens Axboe wrote:
> Hi,
> 
> This converts the deferred, normal, and fallback task_work to use a
> normal io_wq_work_list, rather than an llist.
> 
> The main motivation behind this is to get rid of the need to reverse
> the list once it's deleted and run. I tested this basic conversion of
> just switching it from an llist to an io_wq_work_list with a spinlock,
> and I don't see any benefits from the lockless list. And for cases where
> we get a bursty addition of task_work, this approach is faster as it
> avoids the need to iterate the list upfront while reversing it.

I'm curious how you benchmarked it including accounting of irq/softirq
where tw add usually happens?

One known problem with the current list approach I mentioned several
times before is that it peeks at the previous queued tw to count them.
It's not nice, but that can be easily done with cmpxchg double. I
wonder how much of an issue is that.

> And this is less code and simpler, so I'd prefer to go that route.

I'm not sure it's less code, if you return optimisations that I
believe were killed, see comments to patch 2, it might turn out to
be even bulkier and not that simpler.


>   include/linux/io_uring_types.h |  13 +--
>   io_uring/io_uring.c            | 175 ++++++++++++++++-----------------
>   io_uring/io_uring.h            |   8 +-
>   io_uring/sqpoll.c              |   8 +-
>   io_uring/tctx.c                |   3 +-
>   5 files changed, 102 insertions(+), 105 deletions(-)
> 

-- 
Pavel Begunkov

