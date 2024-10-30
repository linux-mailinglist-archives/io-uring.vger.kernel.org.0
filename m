Return-Path: <io-uring+bounces-4244-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 605A19B6E27
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 21:52:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 24A7E280291
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 20:52:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11CFF1CBE9D;
	Wed, 30 Oct 2024 20:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="AaQn5EhV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764CA19CC24
	for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 20:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730321572; cv=none; b=cb7JxvRTs8Ok9V8bIXZ+926TR6UQBjAgEQKzpD0JEcptAbqMWr4fWUGnNFCJN+aLX0AV2/Uee0a62YxipH9k93yC6VxV1Ix5faXkqwaF08fPqkDIz7Fjf128czYF4NG1HrxTrILlGcXgGPFV4NshfytMmg2+f0AJZ5WCnUq+v+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730321572; c=relaxed/simple;
	bh=y6fCFd1lIbVrtGivXNHYv4Jh/t0Yse5bY8qjGbakLoo=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Okwpkr0Xttqd2G2avOE/NTfUrnpqpMyU6ZTgUKKbcQjhTeku7Y51XtS3etkC+OkO2hNfiqZH4tZzrLkBhtVl2vc8yohNh2hdSk+9ARTBxBa581drx6LBkeRefIdAFQ6f1FuuZtzdlUTBdwx2VXU18uwC9V5hI/brKNhl6ldU/Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=AaQn5EhV; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-83ab21c269eso8720439f.2
        for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 13:52:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730321567; x=1730926367; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=b4R0qlW4oc/5QJ7WFJiavSlLVQbzLiS3J/fUFoR82Jo=;
        b=AaQn5EhVqDCWv2ZJAtI/3G5FrAwZAEmqxA88xHh/J0OOzoy9jNU9Z9ym+DJugF/Fe8
         HAV7BcUWjhFaUYCfW1nwVJrko0IuX5dukvYOpZXAg253vd2j3DlPqeNxV6sKZs1QLjFm
         s8jrhiEz84DPJg/5+CUEXRzmY0sqbYtZZJCXqC8QYGdfyqKXLNaPMC/Gs4DlKGiGxpki
         yFRSBd83DXMWLYVf6RlGNSj/qKUa6dkpHz6m72Byc6gPxET0c49INy8kDzHAxcEBBZ9a
         tZwNeFGjNxdhTYEJD+J7++t9U+z8RK5ORsCxMMfSinPoiBsBW5nQ4xKYAWN5LRYnngF4
         yOEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730321567; x=1730926367;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b4R0qlW4oc/5QJ7WFJiavSlLVQbzLiS3J/fUFoR82Jo=;
        b=eGS9DjvShpuCLJLYfdGPqlxgB/mklgN5qJav7O7tbqTrkBgOiS7aVprXzTdncX4XGA
         BuV5UYV/ewC5u1HmkLvg/9EWEUnIs6kmJYS28LkT50rM0FZYDTJmscqIWP0T9L87wF+w
         1G0QsAJGpj6u/adyPev18De+VoaHuP6DaLWu3SdDyBt56biPBPSsN7ub7B8xjoPM2Y8D
         nfIlU4MwryF9xwPkowbXk93glk4crRuYWjXdjhhDcAWSNIJI71LwwtJ/4NhlVObmtE9e
         v1YYvkFvn6+UvQqjhovRPnS4rBphldE3y1t8xA4hoTTRIjw3UhtK6njCkbiLEg3ITLGY
         91FQ==
X-Gm-Message-State: AOJu0Yzqs9zBC5wEL6E/sfNYnyxOaQvGbs9a8trAMzp2uDCQM3+8Qb3t
	n6bQ38R8uVAqnr9gePHKlP0FCqvhMLNgR7rCNr+KPoppc1lmh8K8VmXEL3X7D3ZR6deWftWuZrC
	TN6Q=
X-Google-Smtp-Source: AGHT+IGWTMCLhSAQdgKQBBDuoGLutdGfUOnFd95iIQXgiwBlsVrEWSr/8uU/pAgJqiWe1A617njvFA==
X-Received: by 2002:a05:6602:3419:b0:83a:d646:9c0a with SMTP id ca18e2360f4ac-83b1c4c2891mr1747001739f.11.1730321567456;
        Wed, 30 Oct 2024 13:52:47 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc72784db5sm3082580173.148.2024.10.30.13.52.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Oct 2024 13:52:46 -0700 (PDT)
Message-ID: <dee73a98-795d-438f-a62b-7d8bea150d32@kernel.dk>
Date: Wed, 30 Oct 2024 14:52:46 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] io_uring/rsrc: add last-lookup cache hit to
 io_rsrc_node_lookup()
From: Jens Axboe <axboe@kernel.dk>
To: Jann Horn <jannh@google.com>
Cc: io-uring <io-uring@vger.kernel.org>
References: <db316d73-cb32-4f7f-beb0-68f253f5e0c5@kernel.dk>
 <CAG48ez1291n=0yi3PvT0V0YXxwtP9rUbXMghYsFdkia1Op8Mzw@mail.gmail.com>
 <eb449a55-f1de-4bab-a068-0cbfdd84267c@kernel.dk>
Content-Language: en-US
In-Reply-To: <eb449a55-f1de-4bab-a068-0cbfdd84267c@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/30/24 2:25 PM, Jens Axboe wrote:
> On 10/30/24 11:20 AM, Jann Horn wrote:
>> On Wed, Oct 30, 2024 at 5:58?PM Jens Axboe <axboe@kernel.dk> wrote:
>>> This avoids array_index_nospec() for repeated lookups on the same node,
>>> which can be quite common (and costly). If a cached node is removed from
>>
>> You're saying array_index_nospec() can be quite costly - which
>> architecture is this on? Is this the cost of the compare+subtract+and
>> making the critical path longer?
> 
> Tested this on arm64, in a vm to be specific. Let me try and generate
> some numbers/profiles on x86-64 as well. It's noticeable there as well,
> though not quite as bad as the below example. For arm64, with the patch,
> we get roughly 8.7% of the time spent getting a resource - without it's
> 66% of the time. This is just doing a microbenchmark, but it clearly
> shows that anything following the barrier on arm64 is very costly:
> 
>   0.98 ?       ldr   x21, [x0, #96]
>        ?     ? tbnz  w2, #1, b8
>   1.04 ?       ldr   w1, [x21, #144]
>        ?       cmp   w1, w19
>        ?     ? b.ls  a0
>        ? 30:   mov   w1, w1
>        ?       sxtw  x0, w19
>        ?       cmp   x0, x1
>        ?       ngc   x0, xzr
>        ?       csdb
>        ?       ldr   x1, [x21, #160]
>        ?       and   w19, w19, w0
>  93.98 ?       ldr   x19, [x1, w19, sxtw #3]
> 
> and accounts for most of that 66% of the total cost of the micro bench,
> even though it's doing a ton more stuff than simple getting this node
> via a lookup.

Ran some x86-64 testing, and there's no such effect on x86-64. So mostly
useful on archs with more expensive array_index_nospec(). There's
obviously a cost associated with it, but it's more of an even trade off
in terms of having the extra branch vs the nospec indexing. Which means
at that point you may as well not add the extra cache, as this
particular case always hits it, and hence it's a best case kind of test.

-- 
Jens Axboe

