Return-Path: <io-uring+bounces-6175-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EC9CA222AD
	for <lists+io-uring@lfdr.de>; Wed, 29 Jan 2025 18:19:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0B36B16489B
	for <lists+io-uring@lfdr.de>; Wed, 29 Jan 2025 17:19:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBE841DF728;
	Wed, 29 Jan 2025 17:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="p3i6sA6c"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891211DF739
	for <io-uring@vger.kernel.org>; Wed, 29 Jan 2025 17:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738171141; cv=none; b=L3/KsHcYRYw28NQL93nbJhOrmngVBQY7K9ajdN1MkjXMK9pQGSRzL0+8cw5HN+jj0SRoXsPsII34Gh6WyD4GNrEz+O7Rkd2N0p1Z3NuADkRfxnn600Hj/EilqsCaT3SNVq+e6KLZGYbyK9PS4aLHroK+OHqi9w5I5b9riFcf8Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738171141; c=relaxed/simple;
	bh=Qpo6BXmmCgcP1UMtDbKBtggpRFeozLB6csiR+6/ekDg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=BYoceyZ8AR34Az8C/74nGHA1Ae1KS3l8/xGEbhetmJBnWuRMn8mU+hHFWfkfU5oWQlzuTCoa8hJTqy7tRzjKNSFa1bxnZJtW0+rIHyYztPnW5s1myL2rDsD8fxHlqvFNLHAe0CCbup1RmeiV67WWg0knrCMhQM3zdCeMODUiVdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=p3i6sA6c; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3cf880d90bdso25878835ab.3
        for <io-uring@vger.kernel.org>; Wed, 29 Jan 2025 09:18:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738171138; x=1738775938; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4YrXDkFbxkCXefK8GrhGms9vWROL/OmV/z1ZfdXAhr4=;
        b=p3i6sA6cWNwwCBfAH7j1HHUGQIXiI3pp3FDstczWkSoOoyCPEg5oaLLc4DZ/jz1ph5
         xGEqB/hIsKpRZBlRF5egjtDy3kpxymJoflFwB8Y+lZB4kge2PkiON4LTfImMu6XJJrBc
         91nI2ohIpfvSL4Ih/uJL9V+JSM5XPuaShOGvhv9kZirIBtQMo/Xtu7b6a5Or0P54KtON
         seWBYhROOVzJwWe87SoJGWqkL0UtbQcPbGuQ1kvZaL4F+6wvWPWy/OlkEq151pE5f6Fk
         4v87Xe7w62W+6R6C3qjaw0r81iRK8P1puLiimCNpXSTjvlPA0CMzDHW2XuRBO6oS5SIW
         oCpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738171138; x=1738775938;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4YrXDkFbxkCXefK8GrhGms9vWROL/OmV/z1ZfdXAhr4=;
        b=rbGWDCQcwkMxj6v6WCbZXcrmVJXDbCYupWNJeLiZM0VxAwg7TnXdo6GPV9udHS+5AT
         yB0CpBs26X8yYiXACOj5qDNIMN6E/fSu3bw4ic1/zk3ON+PdUcB1f3w68/ZfjkH2ARZP
         nYBggn32zEn42nAV4a/Ceqofuaz5GesFGGhwknYNA8v1/fv19LHx2f8x+vzyla8/2e90
         4i7GQx1Je7aO+yLF2SmslghaOGfBsmEacxK2lfp93lTJr7sXfYueM/BD0VW/Y8WXrVUV
         BUsqWG5ZgnONMwd2XhCLBuIB3+tMKWfcC6yIlQ4ZJT0BKyEJAwSBBMWUmJvS88Zuo8gi
         2bjw==
X-Forwarded-Encrypted: i=1; AJvYcCVG77aZseReIVHE6PobrjNPa4CtZu+L+0IHXVJIDomgi6muxwrn8Bi1ngESmFjqZWGR+jL2IXAzew==@vger.kernel.org
X-Gm-Message-State: AOJu0YxzcdkbuNftXUrYcZks7+eXPHHHcmzUcrFIIp6IpRBwSwG3JpkR
	q651CL8w+lepB+/aiBDNk5QsMjyt8rkKC4+5zY4QHSNhcMxebRSlTn/McwG1i+Bmm7WZLACJeGp
	G
X-Gm-Gg: ASbGncvHAvk/48JyIcKzPXu6S3y3re2LcTadcAkLDST46IURoX6upgdmO58PbjBQteb
	Jerw0ROaJ7+fTi720z8uVlceYxjyvCYwxqSqLaAPiLIVgwG88Wq8V8UDfoiJRBJ8aWlpb0IpAzj
	Oh4JvjCkSqEwtcbU1zy8DyT/l5Sat08HJbgs3/GW69+sNo59zEttjxq/uCaJBPQQYVgTYOZoJfq
	iXwJ/Y4V5ePXUComedecxevoJkqcvhPxb1evi3dSpag/9fmw1rBenCJ0JJ3kkIbE+YG6yPV0DyU
	Ycgs3xXIuZE=
X-Google-Smtp-Source: AGHT+IHzD6Z9zQTAbpRMyRN6aKAFeOBmR4VIDzNJqwIftFhVzzSg0ywN1LPugVYxNQ//Xxd7QaB03g==
X-Received: by 2002:a05:6e02:2611:b0:3cf:c9ad:46a5 with SMTP id e9e14a558f8ab-3cffe470194mr33172525ab.16.1738171138583;
        Wed, 29 Jan 2025 09:18:58 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3cfc743439asm38294065ab.20.2025.01.29.09.18.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jan 2025 09:18:57 -0800 (PST)
Message-ID: <7f046e6e-bb9d-4e72-9683-2cdfeabf51bc@kernel.dk>
Date: Wed, 29 Jan 2025 10:18:56 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] Various io_uring micro-optimizations (reducing lock
 contention)
To: Max Kellermann <max.kellermann@ionos.com>, asml.silence@gmail.com,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250128133927.3989681-1-max.kellermann@ionos.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250128133927.3989681-1-max.kellermann@ionos.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/28/25 6:39 AM, Max Kellermann wrote:
> While optimizing my io_uring-based web server, I found that the kernel
> spends 35% of the CPU time waiting for `io_wq_acct.lock`.  This patch
> set reduces contention of this lock, though I believe much more should
> be done in order to allow more worker concurrency.
> 
> I measured these patches with my HTTP server (serving static files and
> running a tiny PHP script) and with a micro-benchmark that submits
> millions of `IORING_OP_NOP` entries (with `IOSQE_ASYNC` to force
> offloading the operation to a worker, so this offload overhead can be
> measured).
> 
> Some of the optimizations eliminate memory accesses, e.g. by passing
> values that are already known to (inlined) functions and by caching
> values in local variables.  These are useful optimizations, but they
> are too small to measure them in a benchmark (too much noise).
> 
> Some of the patches have a measurable effect and they contain
> benchmark numbers that I could reproduce in repeated runs, despite the
> noise.
> 
> I'm not confident about the correctness of the last patch ("io_uring:
> skip redundant poll wakeups").  This seemed like low-hanging fruit, so
> low that it seemed suspicious to me.  If this is a useful
> optimization, the idea could probably be ported to other wait_queue
> users, or even into the wait_queue library.  What I'm not confident
> about is whether the optimization is valid or whether it may miss
> wakeups, leading to stalls.  Please advise!

That last patch is the only one that needs a bit more checking, so I'd
suggest we just ignore that one for now. We're in the middle of the
merge window anyway, so all of this would have to wait for the 6.15
merge window anyway - iow, plenty of time.

The other patches look pretty straight forward to me. Only thing that
has me puzzled a bit is why you have so much io-wq activity with your
application, in general I'd expect 0 activity there. But Then I saw the
forced ASYNC flag, and it makes sense. In general, forcing that isn't a
great idea, but for a benchmark for io-wq it certainly makes sense.

I'll apply 1-7 once 6.14-rc1 is out and I can kick off a
for-6.15/io_uring branch. Thanks!

-- 
Jens Axboe

