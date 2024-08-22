Return-Path: <io-uring+bounces-2901-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5912295BB81
	for <lists+io-uring@lfdr.de>; Thu, 22 Aug 2024 18:15:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7A1981C212A5
	for <lists+io-uring@lfdr.de>; Thu, 22 Aug 2024 16:15:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DB821CCEC2;
	Thu, 22 Aug 2024 16:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="XYS3WtoJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB0A1CDFAB
	for <io-uring@vger.kernel.org>; Thu, 22 Aug 2024 16:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724343258; cv=none; b=eiYTLOnvyFvxvHNaL9RyPXFOGkyqGU+u5autznBYXbgS0PRNZYgJyXQrw7m72djdOGT6tkLik4hqNhAVD5Xiq96uf3xSj01ElRl9zWwnrnugdJqpTjAblk+qxIY2Tp7+PNxsH6W3enGygkjfSp05DwTKTCDfj6p/MMvBcwg3lK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724343258; c=relaxed/simple;
	bh=HftOkJZlphR6iKX3EDZYT0X0nZ87Pv4J3f62iel4HAk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gndYQHijO8Dv/b9V5y/XqUUckNTAS5g9rBZJJ3V/jZz4eihx8T3dNfvecvJRtiAbw4EOSKO3cXv8JH4QVRV/hAZwRJsp226YCSoZGCNcr+vt12pObecMOi4v4cCaAARBmKRL4vT2shAMkFzSt36OSfqDujf5HSxofpifC8dnSVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=XYS3WtoJ; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-81f8f01981aso39297539f.2
        for <io-uring@vger.kernel.org>; Thu, 22 Aug 2024 09:14:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724343254; x=1724948054; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=z1Pl40xfySgwTbIz3Or5XYixJICXC5aMWXA3gfC0HBc=;
        b=XYS3WtoJ/tgw39MKAyC4csc3dFdagHZv0uVla7IbZpR/gQMO6reoaFjCFqun0/dayg
         JN7CK90QeF4ZJmtu/VaZfc3c5akWQZprZxTUGeyycgwS4JCcW0DGmDDXZzQPPTQ01w8z
         O9UjbXXaOinZscDZKJlv2qorVbv0AI9DruKd51pGuDxlICdCXxbS0a5WbvsyoXZogp7m
         N760DqtTBwy0W/5hUoSnimRAG9itkxItNrfe5ZfvnhKMsNq7sgmUhYGdW2qu3tcexSj7
         dQfxq+44PRWVW+Fx3/imafF1bdEZlHfqr+h3GbyH3sFqZ5yjJ4kIr3M7b6gGABPWii/P
         bpLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724343254; x=1724948054;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z1Pl40xfySgwTbIz3Or5XYixJICXC5aMWXA3gfC0HBc=;
        b=TiKaeneCOdkeE4BDInzX2u3O1GyoBbtFI9A3Bqz8fbo43Oqp0Up5R9j7FrF2c5nSHJ
         PaNayE5zxo26XpOS9kEEMi6gBtG0uUshqbQJNtN2JUwEWO06mqYiAOnbK/qfQ39dXHKb
         ck9IEoeHm/qRSgTstGYnbQQjYbw3tVZMK5SoKlUnsVyusF5y5Er2+QdRPJBaGBJczCqV
         ylhsq+h2tRFxluSYtyUB9JjCR1sSljVNsrctOTdhuPocOGDqxHBvt6d3UZUKoNbrC8w9
         NEKI6Sm4OvD1zKjcdjWGNeeWVsNgtELeYCpkYz0vvUsKBelCoJO2M/+n5hQjSfZPi1rn
         qRSQ==
X-Forwarded-Encrypted: i=1; AJvYcCV2dwd81RaN+YUgJSryo6Jab8VYX5Q2OzHvYuthtJqo5Q4/7/O3hOKUdl1qXFwJKpY4U8Af+0mLsg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwOrnST3Nf3L4aYBo1WAcShJtxcCRVu6qF8ecTuP+9aI2m6IKWK
	YxxbbLtNlKpLyM9YjR1W89DSZUTEi9fNkNOvlBkyo8ertyH0coErEuvk6axdp+r6sMUaLFLarPQ
	1
X-Google-Smtp-Source: AGHT+IHghGocS2dqqTL81mmMyq7VAaeB/DeOWXSwb74P4vMXLHtNriXTR3KqOAkzFWpn6fEcnuXC/A==
X-Received: by 2002:a05:6602:1612:b0:7fc:89ed:c17e with SMTP id ca18e2360f4ac-825a59e5b8bmr341693639f.12.1724343253674;
        Thu, 22 Aug 2024 09:14:13 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ce70f7e0casm545222173.72.2024.08.22.09.14.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Aug 2024 09:14:13 -0700 (PDT)
Message-ID: <2e9b16b9-e22e-40c4-99d8-80169dc657c9@kernel.dk>
Date: Thu, 22 Aug 2024 10:14:12 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] io_uring: add support for batch wait timeout
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: dw@davidwei.uk
References: <20240821141910.204660-1-axboe@kernel.dk>
 <20240821141910.204660-5-axboe@kernel.dk>
 <ca995b4b-9dc3-4035-88ac-a22c690f09d0@gmail.com>
 <fbb24fa4-3efe-4344-a4b9-982710e9454b@kernel.dk>
 <3087dde9-4dc4-4ed2-a0ed-4b60cf1e0cbe@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <3087dde9-4dc4-4ed2-a0ed-4b60cf1e0cbe@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/22/24 10:06 AM, Pavel Begunkov wrote:
> On 8/22/24 16:37, Jens Axboe wrote:
>> On 8/22/24 7:46 AM, Pavel Begunkov wrote:
>>> On 8/21/24 15:16, Jens Axboe wrote:
> ...
>>>>          if (ext_arg->sig) {
>>>> @@ -2484,14 +2544,16 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
>>>>            unsigned long check_cq;
>>>>              if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
>>>> -            atomic_set(&ctx->cq_wait_nr, nr_wait);
>>>> +            /* if min timeout has been hit, don't reset wait count */
>>>> +            if (!READ_ONCE(iowq.hit_timeout))
>>>
>>> Why read once? You're out of io_cqring_schedule_timeout(),
>>> timers are cancelled and everything should've been synchronised
>>> by this point.
>>
>> Just for consistency's sake.
> 
> Please drop it. Sync primitives tell a story, and this one says
> that it's racing with something when it's not. It's always hard to
> work with code with unnecessary protection. If it has to change in
> the future the first question asked would be why read once is there,
> what does it try to achieve / protect and if it's safe to kill it.
> It'll also hide real races from sanitizers.

Sure I don't disagree, I'll kill it.

-- 
Jens Axboe


