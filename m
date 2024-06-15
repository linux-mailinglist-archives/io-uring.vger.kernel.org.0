Return-Path: <io-uring+bounces-2223-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C48E909505
	for <lists+io-uring@lfdr.de>; Sat, 15 Jun 2024 02:23:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6424F1F21A53
	for <lists+io-uring@lfdr.de>; Sat, 15 Jun 2024 00:23:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 933CC623;
	Sat, 15 Jun 2024 00:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="yoMB8Eib"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88BFE10F7
	for <io-uring@vger.kernel.org>; Sat, 15 Jun 2024 00:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718410985; cv=none; b=GVB5hQbVyi2fBGj+DXBnZUrr8R6og8wxzcd74yzY++8hJn+tQ4AyAlIFhJkw4jNkromw5O3TWUYhlRoOG5490v7qYG62vNtcdBC5uDgc92q4mVOW8snJESf3ip+6QJFE+HCpEvCIhQAd8uPnV0MZQmnAaMdOak9RgZ21w2f7bL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718410985; c=relaxed/simple;
	bh=7lbsOhmL6p69TZ7S1n8TOOfncXpG9udWytreeNTWz3c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vo+Nv0b5EiRQm1loOBH9mCCxXpW1LnPauIuba2Xz4Ik0RHe3oPt0OTvTZM48qiUnMiQn7auFHOG11c4o47hnMobGVRUw3bOn8IeVNJcV/LesDhBbhkMJsX5ue07gKphdwOmqXSZBczjAhAb872SPU337wXNFATQm5qKmC7EgYhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=yoMB8Eib; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2c1b39ba2afso462917a91.2
        for <io-uring@vger.kernel.org>; Fri, 14 Jun 2024 17:23:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1718410980; x=1719015780; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bTzYGT3AelkUuTDJMOfOtlwLUm+xa6Xo4LR+c4zH88U=;
        b=yoMB8Eibhqx/pTmm5fZ0FeSboe6+U7OlMY93JTxeKlIj8Px838eBApmgnDOsbX9c1w
         bIhtcWMzjmirMhrWOg9PS8WtPFWkRd9swetUZYproHgKa2ME3NOD1H334FJYrE9VOY+7
         L2gvl7z8B5iPgOwOwWtoMWtVniWU2UXsZnoYOP65yp68fpwXfgozNiZ3DAgC/7sLYC/G
         5J4r2jYM5dLWS++9qFvo0L/XTh8y9zGdvNbXJcc1RTXqa1e/N5jmYmitA+O+8PvDx+DA
         5osDQFOGv+vI8CgZMYiHBgSpCzxPZ4jDPBYS1k0uVQbGHcU4Cq3KLO+LBuEzApnRq4CR
         vJog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718410980; x=1719015780;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bTzYGT3AelkUuTDJMOfOtlwLUm+xa6Xo4LR+c4zH88U=;
        b=Axp8m/P0LeIt1WcHKbfwxF4YAsBeaYQ5n0RFxvkZ6lHet+wi3b7Fm2t+vvbo24Pc/E
         XugyfvEfRif2v2sy32KlIL4EntfJl6+1GVpkRnXLxEc+7vu/YF1xBHQ4x/2MQ2lARlzD
         LuZWQ7gpPjyn7s2yd+ex2iHvgsoVmwmY2r5Gyz20FPIjJy4IxDB0Ps9C8v46F6bt9RjF
         ptS2XXLkmvn6+uOMnKWhncdSKooM330ulI0mHFm71kO578glRi2mhujETu6Z1kYNJ/EF
         Jl2cGGGPcrVDjn5TzTKoyqlVQCPR/FV9ftYh/iuX3fAPmAUXDKrrarMOWyW6EeCD2NoS
         4uGw==
X-Gm-Message-State: AOJu0YypdVmW+g7dsmi/0okm9I/pozdIZfDw2HaCgLNAo722F80p9ZCc
	B9tD8hw53QEhr8ParS944VAgn9PSj1KCNfl1KjszscMzr+dOHqMPETbFBWIE3Ac=
X-Google-Smtp-Source: AGHT+IGaY+vgDWvbFuANjMxAkF6yiIx8lNrRziHACe+DV6S2rS2NnqfRaT38MCKuV8Uy+htt/ch8hg==
X-Received: by 2002:a05:6a21:9988:b0:1b8:622a:cf74 with SMTP id adf61e73a8af0-1bae8414973mr4744838637.6.1718410980434;
        Fri, 14 Jun 2024 17:23:00 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f855ee83cesm38310975ad.133.2024.06.14.17.22.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jun 2024 17:22:59 -0700 (PDT)
Message-ID: <8058db6a-4255-4843-8b7f-8c30aa277b26@kernel.dk>
Date: Fri, 14 Jun 2024 18:22:58 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] io_uring fixes for 6.10-rc4
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: io-uring <io-uring@vger.kernel.org>
References: <ae3d160d-6886-47a3-9179-de6becf0af38@kernel.dk>
 <CAHk-=wiMPR5nuVp416xpwFFBb_wcdg-eRDsGQpkDv91bQkMoTQ@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHk-=wiMPR5nuVp416xpwFFBb_wcdg-eRDsGQpkDv91bQkMoTQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/14/24 12:29 PM, Linus Torvalds wrote:
> On Fri, 14 Jun 2024 at 09:06, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> - Ensure that the task state is correct before attempting to grab a
>>   mutex
> 
> This code is horrid.
> 
> That code *also* does
> 
>                 schedule();
>                 __set_current_state(TASK_RUNNING);
> 
> which makes no sense at all. If you just returned from schedule(), you
> *will* be running.

Yeah agree, not sure why that __set_current_state() is after schedule(),
that's obviously not needed.

> The reason you need that
> 
>                         __set_current_state(TASK_RUNNING);
> 
> in the *other* place is the very fact that you didn't call schedule at
> all after doing a
> 
>                 prepare_to_wait(&ctx->rsrc_quiesce_wq, &we, TASK_INTERRUPTIBLE);
> 
> So the bug was that the code had the __set_current_state() in exactly
> the wrong place.
> 
> But the fix didn't remove the bogus one, so it all looks entirely like
> voodoo.

I'll kill that other redundant one.

-- 
Jens Axboe


