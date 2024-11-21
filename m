Return-Path: <io-uring+bounces-4923-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FB299D4EAC
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 15:29:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4888AB26F6A
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 14:29:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8268C1D79BE;
	Thu, 21 Nov 2024 14:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h7GRWfzd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2A92AE96
	for <io-uring@vger.kernel.org>; Thu, 21 Nov 2024 14:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732199340; cv=none; b=FgEpbetgVxfaF1t2N7C2qnR15M3zw9dj41z+MN1tlS4sG6HVJ5/LHvjW/JcMdoLpIn7BoB85VUQrpVvmZOUjQf8RtRLP6sswLiw3lvquIvkL5XnmeN45Bt7r0upO7wZfeKdP98LonFhjzWDZuTiGaGly/gS062IFb69lZ6ZByFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732199340; c=relaxed/simple;
	bh=H09+rNdqC+GjKTkZCw8z4NLFY9pw0PeCMd1rf8Rb5i8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Pk9CEE1c1owy5u9pjz50BoioWm4eZXUJxGsIGsJH0eZVzsSkGiy5OUTcuLh+OkMWzmUNCTvbbaB6gKCrY4QaHKpTcuuH+gQDnIN7oSaA68mspQwCG+NJAucbaudjQL/vElKBdNnjuwTDvINY3cdxibVJ2Wa244OM8iFlu1NRZhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h7GRWfzd; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2fb5740a03bso10848261fa.1
        for <io-uring@vger.kernel.org>; Thu, 21 Nov 2024 06:28:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732199337; x=1732804137; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u8rqsGsb4UqP2WheSe1B9YKaPgUEukHVLIdnXsSOVPU=;
        b=h7GRWfzdDjluwDor2pGA2ggmDi+gs+XtQTeL+3wtAtL3tX4MZVUU0PIqfgUsxfH8vd
         8p0OlYHw4qmyID8gI+MZWUfhxfnOCT7CBvQ5L3AbGyi94RM3JBOthp/Kp8or1gfx9jEZ
         83/3gCiiPPlwUmWbJAxqL+Ax7G7WRinn4X2j6IUXiMpwcYWxUQlpyZKtLQaGR9Xx+cqW
         c1ikzcs6L4I87wuOTfRnjg9t7+ZH+x+fJXfMI4BdUCXfra+MPsDmCVCDCe//NOPiwQIU
         0ppKqA+9NArBa3T+jL4LO+fGCt/oS2pDRySzrm6W5lgH0Ptk/24OC+901yDWhir9aja5
         l1cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732199337; x=1732804137;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u8rqsGsb4UqP2WheSe1B9YKaPgUEukHVLIdnXsSOVPU=;
        b=HZjG9nizuz8wzNpqon5ll+L3XiJcBDjXzGhHrXpfnuUIHSM9iTckSGT/jvfZ/N57M/
         sYP05Sz/hZSJzhHz6X0r7fklXqgss88QmTUieF7bRMDgVr6HNtUoEm2jyRVW1vIMTpJW
         SvgQseE6BwxS7U7cRACTIqxxFLB+ovAU9zuCYXx6roM5AKSJjRDwAlFaHybKezh8wNsz
         rBl84wxMJkrkxlxILWNDETUzWuPu7umg8qQYGxkZj6TscQJRbZGhjkNPU714LfKOezv+
         NlUze0dO0OmMxHzRn7t+Ld0iV0GVrEj1zTk5BF3Z54WTV8nggjUsm4EvX2NHjsUFvcNI
         3VAQ==
X-Forwarded-Encrypted: i=1; AJvYcCXJGZP6FuAO2RSBWl9hjDGao6YI7e/qTzZhT4Th+jrEnh6T/ZmdHdzA1kj6PlN/eGVb22uNkKdU9Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz09b3I/hx/19F2AKUEtRnZ6D+7W/0MqfByNmnUIh3hTGVDL7sH
	yu68plm/V8r/D8LX7xNeEkBXWktQxIZGDW9gnLK/scGwNlEPu19aJ62ywA==
X-Gm-Gg: ASbGncvsySKDydbMq9GPZY5Mb9XwXhxyA6y3r5/X0OcEFFkUL9jX5vF1rhqICFmZ8PV
	tG/LvB1Ei5mtZe+08BoWtx3GLCJUwDlcPo9CzzNVsu48TUgDNWz6MnDE+Py6+/k7PBYW0nkVknv
	F7qXjWWVGty4gzahMaTZlEz2GrM4IPzAemswUsSxv6PClhXD+9HfRB9xkkRUa7UgyYcGjIgrSEX
	xyTxaGGt5ZYz/mDk1gODFpRbgQUaBJOHysBobqw5liP8VlXvDhXXgk51Q6EIA==
X-Google-Smtp-Source: AGHT+IEr3Y9l0hCtPEKP9A14Bo2KuP60ie0w1jHnoBQ5htQ5g3aoiYDFi5Kkv23gLb8MWc77jeva7A==
X-Received: by 2002:a2e:bd0e:0:b0:2fb:5f9d:c296 with SMTP id 38308e7fff4ca-2ff8db65cfdmr39029781fa.4.1732199336473;
        Thu, 21 Nov 2024 06:28:56 -0800 (PST)
Received: from [192.168.42.195] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cff442a162sm1906913a12.0.2024.11.21.06.28.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2024 06:28:56 -0800 (PST)
Message-ID: <1d98f35c-d338-4852-ac8c-b5262c0020ac@gmail.com>
Date: Thu, 21 Nov 2024 14:29:48 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH next v1 2/2] io_uring: limit local tw done
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
References: <20241120221452.3762588-1-dw@davidwei.uk>
 <20241120221452.3762588-3-dw@davidwei.uk>
 <f32b768f-e4a4-4b8c-a4f8-0cdf0a506713@gmail.com>
 <4d71017c-8a88-40bb-a643-0efb92413d3d@davidwei.uk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <4d71017c-8a88-40bb-a643-0efb92413d3d@davidwei.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/21/24 00:52, David Wei wrote:
> On 2024-11-20 15:56, Pavel Begunkov wrote:
>> On 11/20/24 22:14, David Wei wrote:
...
>> One thing that is not so nice is that now we have this handling and
>> checks in the hot path, and __io_run_local_work_loop() most likely
>> gets uninlined.
>>
>> I wonder, can we just requeue it via task_work again? We can even
>> add a variant efficiently adding a list instead of a single entry,
>> i.e. local_task_work_add(head, tail, ...);
> 
> That was an early idea, but it means re-reversing the list and then
> atomically adding each node back to work_llist concurrently with e.g.
> io_req_local_work_add().
> 
> Using a separate retry_llist means we don't need to concurrently add to
> either retry_llist or work_llist.
> 
>>
>> I'm also curious what's the use case you've got that is hitting
>> the problem?
>>
> 
> There is a Memcache-like workload that has load shedding based on the
> time spent doing work. With epoll, the work of reading sockets and
> processing a request is done by user, which can decide after some amount
> of time to drop the remaining work if it takes too long. With io_uring,
> the work of reading sockets is done eagerly inside of task work. If
> there is a burst of work, then so much time is spent in task work
> reading from sockets that, by the time control returns to user the
> timeout has already elapsed.

Interesting, it also sounds like instead of an arbitrary 20 we
might want the user to feed it to us. Might be easier to do it
with the bpf toy not to carve another argument.

-- 
Pavel Begunkov

