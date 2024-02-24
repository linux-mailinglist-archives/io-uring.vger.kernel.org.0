Return-Path: <io-uring+bounces-700-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5541C8626DB
	for <lists+io-uring@lfdr.de>; Sat, 24 Feb 2024 19:56:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2B953B21D71
	for <lists+io-uring@lfdr.de>; Sat, 24 Feb 2024 18:56:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B51023F9E7;
	Sat, 24 Feb 2024 18:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="KaGb5IDj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812DE3A1A6
	for <io-uring@vger.kernel.org>; Sat, 24 Feb 2024 18:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708800955; cv=none; b=fg7yxOGPhQtQFAlC2T64mtZBXHlgZ9AsegT/otp7WpQGmC4kEdv/SwiJp7Ofdl27MIRl8Uy+sHg+FpSWEj1djQMjAZ8OrNAtpXOzR7oQJLliP469DGwxXmFEYxTuhObFT2zRTQrcEA+tGdOTjZC6HW+625iFdwHG/dXYPZkFpRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708800955; c=relaxed/simple;
	bh=6dSZNzT2pdn+JXS95pxMcc4wGBWmnpAKmlhNiAiGxJs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=tYVZKjFWs/21qzWHr5B0hShb2BV2vOX6mkEDN24UjcHuwC7d8xPTwejShu++TQtoECai+lUPIuxoQP3EMBzuPxTv0zUZWsM+XKkPoPM9Z7vzzfZmxNBdDJh6TCnmOW1FBLXT0HD4V0qBocC13vO/s4jKJuaZElkd0cO/zfYASvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=KaGb5IDj; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-5cfb8126375so649453a12.1
        for <io-uring@vger.kernel.org>; Sat, 24 Feb 2024 10:55:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708800953; x=1709405753; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AEEJVO+YStEe4EcuO1MnZJHhDqX7j2SDjHrltgqvFco=;
        b=KaGb5IDjeIR14Qz0Uy9uPx6F397clYAkUPQWA0cD1Az3Hjx4CsP8BN7I0UGOCAWvzc
         xi39BjcgBFM7proKhofHsBvWN5VkhpvqyW5jK5hA8aKgrgdfmRM3XKlUI/p80l9DPqqD
         mT2Ke7hRKLq+V4wWdnUoqloFfh1fj4GKUhL24g0DHvClxEdsW30qejvcMEfhUrP7g5jB
         QQ0K9xtpMl7zAYpCfjqpM+rN8p8vkxGwzbASdxbCoWoQtaP4c1vDBwKlTMQM9jvr0Eaw
         t+QZZ1632EaqChjDyxrYKE6YOQpjzW3tnIW4bbL9yWfoxEfQ5u15f/GMJdC+Yd2VFXHs
         SY6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708800953; x=1709405753;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AEEJVO+YStEe4EcuO1MnZJHhDqX7j2SDjHrltgqvFco=;
        b=R9C2oZekqGyQlbWVNnGmdwLJvTSe9sdiKRhNZiFNWQkX8R7vOT6tH9XSqm9MJzwLHX
         O4Nugqtfva0tXLSWnw7d9jzQEwufrwD16kXCqLB0l2ryuurUuIsOSBhHddeTwAgEFSOO
         zfzhObDipm1Yj9e4KMDuDQ315ATxpafjrcvjjdi2PsyM9NFP3GgAwHcNbCCEYFLzOnS9
         BwVTi8TudaUReCLSfkB2QHnexfYH5SYpgk0iE7VF6ZQrfq2wdVzAS/0fTRmWBw2fBvBC
         WSIQf/fEwC07EhhI9K2h39cCQXxZzGN3fQJlxqG52Zy2Z7OahOXrjASShW59z5iFLNJ1
         eZ+Q==
X-Forwarded-Encrypted: i=1; AJvYcCXR0RSTJMVEnrVQl/xbR8g4i8AYUbifq6iexPa0/cpB2ukTXe5Cj9yjXarbKeBXeRMjF6yZVPhcz6lMDe2qvRbRu3zdB6qbomU=
X-Gm-Message-State: AOJu0Yw3D9a7SHfVK9Tka5ed7HVM+4IsJ8jUq4W5xpqRh5fls2dkyxMT
	yt4Elpr7wC898ExM1BWqLTdBwOy+BZU09APgJVusAjgh2D9sUWLm2heuBuS4e1s=
X-Google-Smtp-Source: AGHT+IEf4Y+8zNMTat01v6+09ImN8Ve9bpPXDDobhBA6OpY+FQuKMBX+KPFEHHCcfTwzErutb9liLQ==
X-Received: by 2002:a17:902:ecc8:b0:1db:de99:9e96 with SMTP id a8-20020a170902ecc800b001dbde999e96mr3633551plh.2.1708800952743;
        Sat, 24 Feb 2024 10:55:52 -0800 (PST)
Received: from ?IPV6:2600:380:7472:2249:6d10:d981:9c6f:5d24? ([2600:380:7472:2249:6d10:d981:9c6f:5d24])
        by smtp.gmail.com with ESMTPSA id pq1-20020a17090b3d8100b0029aa70d6819sm804772pjb.38.2024.02.24.10.55.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Feb 2024 10:55:52 -0800 (PST)
Message-ID: <cf1f03ce-352b-4a61-a595-d595413bc831@kernel.dk>
Date: Sat, 24 Feb 2024 11:55:50 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/4] io_uring: only account cqring wait time as iowait
 if enabled for a ring
Content-Language: en-US
To: David Wei <dw@davidwei.uk>, Pavel Begunkov <asml.silence@gmail.com>,
 io-uring@vger.kernel.org
References: <20240224050735.1759733-1-dw@davidwei.uk>
 <678382b5-0448-4f4d-b7b7-8df7592d77a4@gmail.com>
 <2106a112-35ca-4e02-a501-546f8d734103@davidwei.uk>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2106a112-35ca-4e02-a501-546f8d734103@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/24/24 10:20 AM, David Wei wrote:
>> I don't believe it's a sane approach. I think we agree that per
>> cpu iowait is a silly and misleading metric. I have hard time to
>> define what it is, and I'm sure most probably people complaining
>> wouldn't be able to tell as well. Now we're taking that metric
>> and expose even more knobs to userspace.
>>
>> Another argument against is that per ctx is not the right place
>> to have it. It's a system metric, and you can imagine some system
>> admin looking for it. Even in cases when had some meaning w/o
>> io_uring now without looking at what flags io_uring has it's
>> completely meaningless, and it's too much to ask.> 
>> I don't understand why people freak out at seeing hi iowait,
>> IMHO it perfectly fits the definition of io_uring waiting for
>> IO / completions, but at this point it might be better to just
>> revert it to the old behaviour of not reporting iowait at all.
> 
> Irrespective of how misleading iowait is, many tools include it in its
> CPU util/load calculations and users then use those metrics for e.g.
> load balancing. In situations with storage workloads, iowait can be
> useful even if its usefulness is limited. The problem that this patch is
> trying to resolve is in mixed storage/network workloads on the same
> system, where iowait has some usefulness (due to storage workloads)
> _but_ I don't want network workloads contributing to the metric.
> 
> This does put the onus on userspace to do the right thing - decide
> whether iowait makes sense for a workload or not. I don't have enough
> kernel experience to know whether this expectation is realistic or not.
> But, it is turned off by default so if userspace does not set it (which
> seems like the most likely thing) then iowait accounting is off just
> like the old behaviour. Perhaps we need to make it clearer to storage
> use-cases to turn it on in order to get the optimisation?

Personally I don't care too much about per-ctx iowait, I don't think
it's an issue at all. Fact is, most workloads that do storage and
networking would likely use a ring for each. And if they do mix, then
just pick if you care about iowait or not. Long term, would the toggle
iowait thing most likely just go away? Yep it would. But it's not like
it's any kind of maintenance burden. tldr - if we can do cpufreq
boosting easily on waits without adding iowait to the mix, then that'd
be great and we can just do that. If not, let's add the iowait toggle
and just be done with it.

>> And if we want to save the cpu freq iowait optimisation, we
>> should just split notion of iowait reporting and iowait cpufreq
>> tuning.
> 
> Yeah, that could be an option. I'll take a look at it.

It'd be trivial to do, only issue I see is that it'd require another set
of per-runqueue atomics to count for short waits on top of the
nr_iowaits we already do. I doubt the scheduling side will be receptive
to that.

-- 
Jens Axboe


