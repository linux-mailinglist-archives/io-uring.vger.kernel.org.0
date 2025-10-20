Return-Path: <io-uring+bounces-10071-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BFFBBF2D95
	for <lists+io-uring@lfdr.de>; Mon, 20 Oct 2025 20:01:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 1030D4E6321
	for <lists+io-uring@lfdr.de>; Mon, 20 Oct 2025 18:01:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 484D111CBA;
	Mon, 20 Oct 2025 18:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="LGAoI/7v"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA1C18871F
	for <io-uring@vger.kernel.org>; Mon, 20 Oct 2025 18:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760983282; cv=none; b=HDnyCA4QzIHfmdfs57+p0f3MLLZQMGC587fdHog0BbekxUedUU+vLMYpHO3EXpJxw/Z4aJ5lX9eHI6xm4P5grOjW8MyYhkjIxr6CtO6hcBgt4PjFQE3q36aiWYbhM0ZgoKRwQLLtOOnSV5JhhqaouTX96BiMwV3oms3Oxs23+To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760983282; c=relaxed/simple;
	bh=wzLirNWM35QUYWVegI6ER8m/qxDzBydQmIidpgsVuXo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=JM6ZTjkD0Z09L+N+L9gkSBqaapXOQudtbjXPfq5hSofS+IXicECGP5UNKwEHnSS6yfyrVhmlU5wrP5IwKmd+Or/DbLsmBJyY8DgSY85T7tQkY9AnwVFRfEP3gO8wbSx3rjb8UpwC0T4X++PFnOBGvoz5EB7GScwHGTzV7bgfFFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=LGAoI/7v; arc=none smtp.client-ip=209.85.161.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-651c77805d6so2022735eaf.0
        for <io-uring@vger.kernel.org>; Mon, 20 Oct 2025 11:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1760983278; x=1761588078; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+8U5RWiVnoYw8vEBWmiZklHd0VJn91LgvnzjsyfzIZQ=;
        b=LGAoI/7vY8oo2O6MG+fUMk5raC5/iEUNClH/HilkorVM2LP9FAggwwBJXnmuPu+ysq
         Vz6rLbhTzZMaiyGsaA+OcmXV7OL9xyZj4ZSKkvUf6N9JJ5lpM1ApeHj44REi94bIwbGB
         jKkRvUxkdeydzQjzzkxCRH+aP3gkLHkt5lcdJfmCK4WeHddu61L+12jTuGnP+CSZgzp3
         7TDHpQQ2wvKthSnPIxqqMG9xvtdZUwg1D3VoMC01PSl7iqXKwIoGOr4wetPGpXCF4Ld8
         aKuly0KtvLAD8X1M7VSYbb+Tn9mxTkpCWFStJRIVNDO4EbwUFlIVYLEujxuIbvUAt+XM
         yRZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760983278; x=1761588078;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+8U5RWiVnoYw8vEBWmiZklHd0VJn91LgvnzjsyfzIZQ=;
        b=IS+kEmRFVvUhSvAVO2c5agQnF8pBghtglVVlgucW74KivUxpZXHhXvpfQO7QrUVrgo
         LvWAOA+I+KGJ5GQOTg3A3HhJcobst8+zESabmAI5QF1gWprCbEC7OkPFx8Q3uQD6796s
         bnwboibKaZ/3cRhO1Ht1fSgmiHBpdOtd1ycjorOn9tUYgQYnkSci54Opo2G6aczIDimn
         PpuSoFpKAs1FjfeHaUp51u5XBOhttmp57bC0F0EuSe/yqx2pBU3GLiQrBipqrHvaKIrE
         s91o5NuN0rohvtCqL19JJaZc4VH/XXPkpDxJl+p6Tr8pHHWkaz+J5ZcCUco2rxyhWCQ3
         uvyA==
X-Forwarded-Encrypted: i=1; AJvYcCUYbZFfr5oODyU9ClT2ZpVYVZ4WDnS0cWo+FijIeq3yU2TbkPSkSoRGzs/nyrpk77fMNy2yZXldSQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyjqPDj/5GrAfR+xbu0sk5pNGeOEoJINne8Z9HVlcW1VvJyYcNU
	qHu98CjOu5/UAxn2ao8Es40sx00vr+YohNaGMA0Wn+Ul2ctR39YngIOwy2YaI9GmQdyD1WONkTp
	dP7gG+cY=
X-Gm-Gg: ASbGnct4lrCGWxW56lM0bYXHL++FKC8juTFwOzY/aqOszFRjkffricPxTq+EQgHruRH
	9mKrhNc4vH1FvWJ3dITzix8k2Qpfj4SYHi3/18TlqNOGDeBtk3TPcbgWV6aTQfbu69A4rMAffUs
	f6XaoTNyGzhxGZcHbEVbfeLSXmq7ulJPcWtAhSr6uz2z2x84hpBmuQQJoGF10w1HJllEE7HUUwv
	5c1lyx4YeELk1r7B730tn3XqRyMwAlWZsvAR8qCgU/YMwhq0U5G/NyphzU1Drr0wBuTVc02B1Nk
	i9qpSHmX+mQQQYvGe9fp9uoGTcqfPDoH9htsApBRdhiyljQ1m2Ky8poheCIFtqtcBa8j4WOcxU8
	+Byy+A1EVG9A08mzQpoJZz0gqQwE3x2iCdIMdtp4u3lLoW0ptygAMXZHFItPhsELc+LWdf1iRzU
	OeX8uRkmI=
X-Google-Smtp-Source: AGHT+IHpN1RSPDemGDOf0E13zGhR1LutwRGV3p/3uCdr6yrN+9S1AjC/uQp8gJ4nrZyIUymwGxzzMA==
X-Received: by 2002:a05:6808:1a03:b0:441:8f74:fb7 with SMTP id 5614622812f47-443a31537f9mr6341829b6e.52.1760983277985;
        Mon, 20 Oct 2025 11:01:17 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5a8a973e11esm3190401173.35.2025.10.20.11.01.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 11:01:17 -0700 (PDT)
Message-ID: <12e1e244-4b85-4916-83ab-3358b83d8c3c@kernel.dk>
Date: Mon, 20 Oct 2025 12:01:16 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring: move zcrx into a separate branch
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <989528e611b51d71fb712691ebfb76d2059ba561.1755461246.git.asml.silence@gmail.com>
 <175571404643.442349.8062239826788948822.b4-ty@kernel.dk>
 <64a4c560-1f81-49da-8421-7bf64bb367a0@gmail.com>
 <7a8c84a4-5e8f-4f46-a8df-fbc8f8144990@kernel.dk>
 <b10cb42e-0fb5-4616-bb44-db3e7172ccdc@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <b10cb42e-0fb5-4616-bb44-db3e7172ccdc@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/20/25 11:41 AM, Pavel Begunkov wrote:
> On 10/20/25 18:07, Jens Axboe wrote:
>> On 10/17/25 6:37 AM, Pavel Begunkov wrote:
>>> On 8/20/25 19:20, Jens Axboe wrote:
>>>>
>>>> On Sun, 17 Aug 2025 23:43:14 +0100, Pavel Begunkov wrote:
>>>>> Keep zcrx next changes in a separate branch. It was more productive this
>>>>> way past month and will simplify the workflow for already lined up
>>>>> changes requiring cross tree patches, specifically netdev. The current
>>>>> changes can still target the generic io_uring tree as there are no
>>>>> strong reasons to keep it separate. It'll also be using the io_uring
>>>>> mailing list.
>>>>>
>>>>> [...]
>>>>
>>>> Applied, thanks!
>>>
>>> Did it get dropped in the end? For some reason I can't find it.
>>
>> A bit hazy, but I probably did with the discussions on the netdev side
>> too as they were ongoing.
> 
> The ones where my work is maliciously blocked with a good email
> trace to prove that? How is that relevant though?

I have no horse in that game so don't know which thread(s) that is (nor
does it sound like I need to know), I just recall Mina and/or someone
else having patches for this too. Hence I dropped it to get everyone
come to an agreement on what the appropriate entry would be.

FWIW, I don't think there's much point to listing a separate branch.
It's all supposed to go upstream to the main tree sooner rather than
later, once it's ready. And since it's basically just you working on the
zcrx bits, there's no risk of conflicts. If there was a conflict, then
yeah we'd just resolve it and route things appropriately. But it also
doesn't really matter to me what's listed in there, as long as things
are on the list as well. And iirc the netdev side was the same, they
just want to ensure they see patches for zcrx. For me, the entry was
more about ensuring you get CC'ed on relevant patches.

Which is why I figured that you and the netdev side would discuss this
and come up with an entry that everybody was happy with, then we can get
that upstream.

-- 
Jens Axboe

