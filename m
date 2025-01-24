Return-Path: <io-uring+bounces-6111-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B3860A1B388
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2025 11:33:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B78FC3A92DC
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2025 10:33:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30EFD1CDA04;
	Fri, 24 Jan 2025 10:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PZy0joCs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 510131CDA01;
	Fri, 24 Jan 2025 10:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737714783; cv=none; b=IWhSpoUYCQUlcQ/ho93Ztm9E7Z4l7ODwnNdGYSelavxQQzj/55nbuMOnDaUOhT/AcxZBBztCJmblIbdoI/PM7996uXZ5ZPuZJ/e+kYToJQ3YqyKanrmWdoMKzsnZG+BngvrYag8vjCkgAUArRPkFYQltWBQWK4zEg7+C+faIMCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737714783; c=relaxed/simple;
	bh=8axQrrGMHiL3eQFWzhxZnpffZ4V3yNIfs662kh3BDpE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZQD/ZmwtLQwQ2TTxUsCvFQpUAWHb1lBTYWoAhnDNWUbWnemgwlILD5TejH3CIW/T//MsRslYY5pltBl+uMZrDhdWfLxPIjCnyUL56ia5Hp7O6Fj/0yxt7OE83uo/5D61tM8BSfag8JEPtZiDlAtLAuPzRa0ZTRf9TzwXTZaor0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PZy0joCs; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5d4e2aa7ea9so3628132a12.2;
        Fri, 24 Jan 2025 02:33:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737714780; x=1738319580; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=k6EDJaIcbkXZEeUcwvwxCuXiJHi7KYMC5Mo0eFKKxs4=;
        b=PZy0joCslrxXDPwtU417lIjJ6N2j2cuS8Ilo9IOMJQ0YrKInWOLJ7V6SHSoIJ1t6Bf
         4M8sFQfZRz7mqB3vzSauCERe7AZ0nCuzUaoSGiQdQfa+J/WBwgD4DUorwCVfxf6p5spC
         LM2Av1y8kxcnBqIuwrXT0mI0QxB3QCUi+aHKN65kYFhnwfdBfeyyXjpDxu/J1rCzRwpo
         tOY13QK17iwGcyAiDK/uupPoniWhp9b5IutgKY2cmyZCDXyM7bf8+7vjHoMbBtBjVT/B
         OHj/a1j/PoSCQlJsQbTimNJvgrHVbclQhSuLkeOTHUAhNy2HzoNdlVM5AS+cIv1VtQVq
         UC7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737714780; x=1738319580;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k6EDJaIcbkXZEeUcwvwxCuXiJHi7KYMC5Mo0eFKKxs4=;
        b=onx5XHVyeYStKLqK7Ris0vINS0cWbezSXFpdw/J9Lud36XxuE2JdRTsgFq/sk+/BS1
         TU9O9luAiQzQGa+QPf+wWv7aUpaLHtFDtdViMLOnXbW/1LCrkfY0fuq/Y5DyUlwAd9D+
         xY4K1guUG7dRjLURwfDedLZwltu2dFxaDg7I3hl0lO8i0SPMUI0cLOLAZe+Kx7nSrAdo
         r5nYhigTl1rgZvbcTRc5qQgmIDifaHpD24YzEduTspiQDklT2iy7mSRyqvJ0tDPHCI6Y
         OokkwA/aSMZ58EQIoJ/Cs5jsrJZEdHGDrMaknIlRADVao7yiD+EoOax5F/qTN+XZVo9E
         bg5w==
X-Forwarded-Encrypted: i=1; AJvYcCWCx5xt7SkzB85dw1ZWBNXBM4vkXBLerI8R739rO3h8wRtOpJuMkMmCF1HTFk8f+SjeVlvwfmkKJ8u2//rc@vger.kernel.org, AJvYcCWoPUtohFmZP7yg85G+y99AZXyws32t+WwzeJHOEtQMEdtJ7IJPawVxtuNSOdvtxwt1lQHAtU/OGQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzXQNfGdP6rrSISejxtbyD+KBwE9lk9ymWTbzpd98cP/UAkbc49
	Fu5z0UwR3PXCp0phDvC+I5T+q7lYfN1AO4VgqJkxYXyKzAno5+xN
X-Gm-Gg: ASbGncvHrTISXmXxJ1TCvQKVgOxEUBX02d8V0Y9PMLmQO0y+WDFB2G7RMKNJT6VgsX9
	72bjenSX/C2mRetz6CWi4vjHD8suIU2yBWhUQsz6lYM/rq9DH6pZuMUdXj0DYPW4rfCcYxxD+4L
	qFqmTuIfwEXcDiXj5OaRtRjGl7StS3Z2/oYroDrmP6r+m/tBPWcRm4n6kz9QfhykrpyyTwDZT/6
	f2DYpOEW8KQJJwf8mIQ3BYwtyQyZwxGfWkyQ6Z561xbfNMZVQv6AA4Cb1Pka8Rabd4aVxnJDm5F
	Epm2u2CIi6sVuUA=
X-Google-Smtp-Source: AGHT+IGmZ6mjtjHGEsKRqrQ9z8gi/MOxMI4EPFwm88h7HKV8BSpMckLTfLQXtMRMRxY+IuA2gliR3g==
X-Received: by 2002:a17:906:6a25:b0:aaf:afb3:ad63 with SMTP id a640c23a62f3a-ab38b44e0e2mr2678162066b.43.1737714779308;
        Fri, 24 Jan 2025 02:32:59 -0800 (PST)
Received: from [192.168.8.100] ([148.252.147.156])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab6760ab311sm107296066b.97.2025.01.24.02.32.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jan 2025 02:32:58 -0800 (PST)
Message-ID: <a29ad9ab-15c2-4788-a839-009ca6fdd00f@gmail.com>
Date: Fri, 24 Jan 2025 10:33:30 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Bug#1093243: Upgrade to 6.1.123 kernel causes mariadb hangs
To: Salvatore Bonaccorso <carnil@debian.org>
Cc: Xan Charbonnet <xan@charbonnet.com>, 1093243@bugs.debian.org,
 Jens Axboe <axboe@kernel.dk>, Bernhard Schmidt <berni@debian.org>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <173706089225.4380.9492796104667651797.reportbug@backup22.biblionix.com>
 <dde09d65-8912-47e4-a1bb-d198e0bf380b@charbonnet.com>
 <Z5KrQktoX4f2ysXI@eldamar.lan>
 <fa3b4143-f55d-4bd0-a87f-7014b0fad377@gmail.com>
 <Z5MkJ5sV-PK1m6_H@eldamar.lan>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Z5MkJ5sV-PK1m6_H@eldamar.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/24/25 05:24, Salvatore Bonaccorso wrote:
> HI Pavel, hi Jens,
> 
> On Thu, Jan 23, 2025 at 11:20:40PM +0000, Pavel Begunkov wrote:
>> On 1/23/25 20:49, Salvatore Bonaccorso wrote:
>>> Hi Xan,
>>>
>>> On Thu, Jan 23, 2025 at 02:31:34PM -0600, Xan Charbonnet wrote:
>>>> I rented a Linode and have been trying to load it down with sysbench
>>>> activity while doing a mariabackup and a mysqldump, also while spinning up
>>>> the CPU with zstd benchmarks.  So far I've had no luck triggering the fault.
>>>>
>>>> I've also been doing some kernel compilation.  I followed this guide:
>>>> https://www.dwarmstrong.org/kernel/
>>>> (except that I used make -j24 to build in parallel and used make
>>>> localmodconfig to compile only the modules I need)
>>>>
>>>> I've built the following kernels:
>>>> 6.1.123 (equivalent to linux-image-6.1.0-29-amd64)
>>>> 6.1.122
>>>> 6.1.121
>>>> 6.1.120
>>>>
>>>> So far they have all exhibited the behavior.  Next up is 6.1.119 which is
>>>> equivalent to linux-image-6.1.0-28-amd64.  My expectation is that the fault
>>>> will not appear for this kernel.
>>>>
>>>> It looks like the issue is here somewhere:
>>>> https://www.kernel.org/pub/linux/kernel/v6.x/ChangeLog-6.1.120
>>>>
>>>> I have to work on some other things, and it'll take a while to prove the
>>>> negative (that is, to know that the failure isn't happening).  I'll post
>>>> back with the 6.1.119 results when I have them.
>>>
>>> Additionally please try with 6.1.120 and revert this commit
>>>
>>> 3ab9326f93ec ("io_uring: wake up optimisations")
>>>
>>> (which landed in 6.1.120).
>>>
>>> If that solves the problem maybe we miss some prequisites in the 6.1.y
>>> series here?
>>
>> I'm not sure why the commit was backported (need to look it up),
>> but from a quick look it does seem to miss a barrier present in
>> the original patch.
> 
> Ack, this was here for reference:
> https://lore.kernel.org/stable/57b048be-31d4-4380-8296-56afc886299a@kernel.dk/
> 
> Xan Charbonnet was able to confirm in https://bugs.debian.org/1093243#99 that
> indeed reverting the commit fixes the mariadb related hangs.

Thanks for narrowing it down. Xan, can you try this change please?
Waiters can miss wake ups without it, seems to match the description.

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 9b58ba4616d40..e5a8ee944ef59 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -592,8 +592,10 @@ static inline void __io_cq_unlock_post_flush(struct io_ring_ctx *ctx)
  	io_commit_cqring(ctx);
  	spin_unlock(&ctx->completion_lock);
  	io_commit_cqring_flush(ctx);
-	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
+	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN)) {
+		smp_mb();
  		__io_cqring_wake(ctx);
+	}
  }
  
  void io_cq_unlock_post(struct io_ring_ctx *ctx)

-- 
Pavel Begunkov


