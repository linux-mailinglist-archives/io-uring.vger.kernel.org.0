Return-Path: <io-uring+bounces-4933-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 63DAE9D5072
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 17:05:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DDCD41F21D48
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 16:05:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37E8E487A7;
	Thu, 21 Nov 2024 16:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="cnmNMMok"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2EE155CBF
	for <io-uring@vger.kernel.org>; Thu, 21 Nov 2024 16:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732205145; cv=none; b=AqQVu3QaEMmk9dtA+hUJhtWdxKF+Zr6T59jZQmThi1f35g7hDBzwv9edwXBHgaEH2nqZSVCz4MMG5dSkpi5uBei9wolzUK5gGGossScmnltqJ6cTqWQF/9BciLQ1L1+5TA3nmBfic5taITrxPovnp13V1LqNWsZMs9NZpyjtktI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732205145; c=relaxed/simple;
	bh=uQ+snqmo+uJfLiZciN3DtHYvFDFuKZ4nAqGr0LANN60=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=f+2dHIhsfRCnpowFiVpVGf+NqIBF2vBqynoOYwLbgV8F7NMjQ96yAZaNLtRXox4DjS4mAieOy/4xhrOWUm2Gl/tpvQHo9zssrAi0ThZ+rw2aJtDwOg44g6MoYViH3Ilbif3TRXbXp8Gppo7ixxytz0dUDKduGGF8D+NSJSEDUKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=cnmNMMok; arc=none smtp.client-ip=209.85.160.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-295cee3a962so717321fac.3
        for <io-uring@vger.kernel.org>; Thu, 21 Nov 2024 08:05:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732205140; x=1732809940; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=exZPhSVfKFX+Bl2JbKHzMUzH6gqoDfmAkXWzC382iac=;
        b=cnmNMMok0W0WxhLBpnzmnKFfhyyWQJfR3guXe181wICxfGXEAClCwJvEfYKNowntgS
         rSvA6lBsZlbwS5lQl4QT6Oj6HMc5eKqDjO+ofD2MZ9ZsMOuuk7cVmxz9WzcNqBURfaMR
         31/VFxmwJfL29UP2sXCiPBbm+/skHQiEoSpuDxgBiR/uVriPPjwGuorvKM0E73kKb+ey
         xji+DpUQN9nJt6iixWY0ntQfvitT+C2Ls3GF8nNspWjezv1qGOTz7lQ5NciGi/q85qvA
         YQZUh00k/VdWnpEtcPftTksZXcx7E8zWNshQA/FEES0P6hBeEAUzEVp+u4Ybrllzvgf5
         X0ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732205140; x=1732809940;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=exZPhSVfKFX+Bl2JbKHzMUzH6gqoDfmAkXWzC382iac=;
        b=SKNdP3TPsSb6oKsfjoZD5nF6Ojgxy0Ed3ZGePH/BFg6AxapAFIkQTQ0xwjVG+52lBV
         oZmN4qOqaDw+1Gut+SsOdQhHyaGSlWzTNt83DFOe0q3WMAVyNq+Rz79m9tZFWPResoPB
         mHPOzQJjNYiGZtYoGw3YgiGpVDVMMxAbZC0aRNlEiPt6DLczCsC7Oj558o2kNGbrDCjQ
         znU3VwrWJk1oOs4fshHG6Cjsvd86JSyWrdbmEmYYY0F5A7gvcBGoAX6eLqe8u1BjMU6y
         4WRwSeErY5Fto6w3K786hyMyxuoeNZYCVEAa3H/WJ1OmeHqbrdQ7gNebYKrri6JgUWeb
         cpjw==
X-Forwarded-Encrypted: i=1; AJvYcCUH6RFFKraxrmT31rsyE9W/lRig0bShwz//pS+5qs6MBwFMj5GSkzmk5bJsK41dY3y0CXiElLy8JA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyiEDUk7MfQCi3T7RY1P2B3C+HAZnm/mnKrpRrirFb0b4wXt0Sl
	BtPfnBTlc2pkY349cHj2gGxpKOXyoNMrb/J4yOqy1nmG7XxIb3jkm1G5w9RqhMQ=
X-Gm-Gg: ASbGncsHCUkh8ikzvkfKY1oqDujOHdV05/2gGQeQ/vPGY3++n84x8C9OKtLuZOtjX6P
	4EfCAERx4JpWE2bts4U6KsqOWz38ezpwnTDu6/CwTemBVnTEvuNrdXtbZsttSs+G+soBnzojfZH
	X250Uxv3htoZh3ENgQGT21crvqZlZx+FqditZvaJiJTFya7hqg/QwYCZjQpAH1TBvFoCid5se/E
	F7bQRmKU1vRsUdqHEf83t7srh5/vozeMsgPH9V3zsKF+g==
X-Google-Smtp-Source: AGHT+IFh9fb+HRcxYpj5n8BoWYKIM+s7ym07QQZltfuFI86065WBJbh9L+Xn+Q1/T8VOVfo532PXCA==
X-Received: by 2002:a05:6870:9123:b0:277:d9f6:26f6 with SMTP id 586e51a60fabf-296d9bb710cmr7628653fac.12.1732205139794;
        Thu, 21 Nov 2024 08:05:39 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-29719e8e8ddsm62113fac.52.2024.11.21.08.05.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2024 08:05:39 -0800 (PST)
Message-ID: <727c08cc-41ee-4b46-bf66-67ad773eb3e4@kernel.dk>
Date: Thu, 21 Nov 2024 09:05:37 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH next v1 2/2] io_uring: limit local tw done
To: Pavel Begunkov <asml.silence@gmail.com>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org
References: <20241120221452.3762588-1-dw@davidwei.uk>
 <20241120221452.3762588-3-dw@davidwei.uk>
 <f32b768f-e4a4-4b8c-a4f8-0cdf0a506713@gmail.com>
 <95470d11-c791-4b00-be95-45c2573c6b86@kernel.dk>
 <614ce5a4-d289-4c3a-be5b-236769566557@gmail.com>
 <b7170b8e-9346-465b-be60-402c8f125e54@kernel.dk>
 <66fa0bfd-13aa-4608-a390-17ea5f333940@gmail.com>
 <9859667c-0fbf-4aa5-9779-dae91a9c128b@kernel.dk>
 <3e6a574c-27ae-47f4-a3e3-2be2c385f89b@kernel.dk>
 <e0753760-2a91-406f-8b06-98528cf6defa@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <e0753760-2a91-406f-8b06-98528cf6defa@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/21/24 9:00 AM, Pavel Begunkov wrote:
> On 11/21/24 15:22, Jens Axboe wrote:
>> On 11/21/24 8:15 AM, Jens Axboe wrote:
>>> I'd rather entertain NOT using llists for this in the first place, as it
>>> gets rid of the reversing which is the main cost here. That won't change
>>> the need for a retry list necessarily, as I think we'd be better off
>>> with a lockless retry list still. But at least it'd get rid of the
>>> reversing. Let me see if I can dig out that patch... Totally orthogonal
>>> to this topic, obviously.
>>
>> It's here:
>>
>> https://lore.kernel.org/io-uring/20240326184615.458820-3-axboe@kernel.dk/
>>
>> I did improve it further but never posted it again, fwiw.
> It's nice that with sth like that we're not restricted by space and be
> smarter about batching, e.g. splitting nr_tw into buckets. However, the
> overhead of spinlock could be very hard if there is contention. With

This is true, but it's also equally true for the llist - if you have
contention on adding vs running, then you'll be bouncing the cacheline
regardless. With the spinlock, you also have the added overhead of the
IRQ disabling.

> block it's more uniform which CPU tw comes from, but with network it
> could be much more random. That's what Dylan measured back than, and
> quite a similar situation that you've seen yourself before is with
> socket locks.

I'm sure he found the llist to be preferable, but that was also before
we had to add the reversing. So not so clear cut anymore, may push it
over the edge as I bet there was not much of a difference before. At
least when I benchmarked this back in March, it wasn't like llist was
a clear winner.

> Another option is to try out how a lockless list (instead of stack)
> with double cmpxchg would perform.

I did ponder that and even talked to Paul about it as well, but I never
benchmarked that one. I can try and resurrect that effort. One annoyance
there is that we need arch support, but I don't think it's a big deal as
the alternative is just to fallback to spinlock + normal list if it's
not available.

-- 
Jens Axboe

