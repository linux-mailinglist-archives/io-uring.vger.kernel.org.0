Return-Path: <io-uring+bounces-2815-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B2E8495596E
	for <lists+io-uring@lfdr.de>; Sat, 17 Aug 2024 21:44:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2C5331F21A13
	for <lists+io-uring@lfdr.de>; Sat, 17 Aug 2024 19:44:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3A5912DD88;
	Sat, 17 Aug 2024 19:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UJQHM7EA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D35F7F7CA
	for <io-uring@vger.kernel.org>; Sat, 17 Aug 2024 19:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723923846; cv=none; b=VvgSllXnKo3Xj1E3yaSG+4aJWRkzrq2912OWuDsmuGCb9EpSsEAjh172UjmrQSJHeElNqjDCtRl2Q9Qbp1VfRcVdKqlUzrDbqVO8TDhni9yFYejFmtmfYeYmaQaIIjw4RMcCEPk4ZXhxTLP44yqRA/A8W3b21JAtAdQ1AziqzKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723923846; c=relaxed/simple;
	bh=TdwOqfcMmNQDcyr/jU6gWXHu3ho/p1mKCh3dvd+BOV8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Umdhixs7DaFcD8gn26TGcjVW3nB1TObcRiW4ElEr+dItmHYY6Dw5oK5VfLl0BACq5UuD35XRFmhnILPuDSSK1qFp+reazk0w4OfTmeZ+N09edJIOHUMC+XAqINiUS1aK6WixAwWdqzaI+MR8v2F79maS/XAlZjZrJ0MawfbPcYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UJQHM7EA; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a83597ce5beso458768766b.1
        for <io-uring@vger.kernel.org>; Sat, 17 Aug 2024 12:44:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723923844; x=1724528644; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HsZ9yoi1F0UI6wnD97zjkId2BnKCa+jCNGGdHjiO+1o=;
        b=UJQHM7EAsEcNpdcazmH2Jk6ec15MnA0ZE/aHwRAoc/7nt+jxb5YH1NPvIvofiEnFay
         kqPUujevI+nz62NSHsloFUPLCDXglOqo8z2GSR+LUqa8ygTFSToELDPmM8h0wp0OFDU4
         65xRZd2m+JK14ZP3Df+Y0SJF1QO+hNaWh+eGFpWeOrGkTUK+JNusf54YbssQEb72vq+y
         F+YxG9CjD2NRHwl/lT9aJmKHhCpHTlTa2Vl6lQZNfBf61nY660shg2iQpnuUiSz+jVgQ
         TdEysaMXCl5tKL5f8WYDTw/th8h9boHLi9gEdx6ZBYeRGtd6cRHzmTjJ+9bXjAcAFJOZ
         DqNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723923844; x=1724528644;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HsZ9yoi1F0UI6wnD97zjkId2BnKCa+jCNGGdHjiO+1o=;
        b=vNG6rScnjmfNomZWwRMtXAoEyGQCj3xtEg9UcF+LvXqAiYYerQVGnGfAXfdMc4jtZz
         2dAHxb8NE+zoqEDR1iaS1WAdeoqVU6rajFEu7V30LSy5ukIIZLDKO6vCasmvl9Ht6TzU
         8vjPESBgoKUOHcDRpypNyDejfGBpyUN+w2QrGv46G/UFv7eAf2g6gl6FpyChSy1EyvkM
         6Z074Ekqtt9bkdoCNV7RMW7mmgc/SQYGrwwq3jU5c3i4NtK2Q+Oi7F+QIwOIvBhaWn97
         LEFuJnAZAReifhxuATrpOOc3cGzQAQcY0ooD4IHgR2fhNw+NT6UxLF2pP3HwHre9adup
         Muwg==
X-Forwarded-Encrypted: i=1; AJvYcCXtmEe1Vn4V8/FRQTR6GnT/eZ74Ltp4IyzTjN5vxSOC1JOJQKXfXLzs/x5Qc9pj8P9Je7avqRZoXMwGRYq6dfj9dxKYFd0vPJQ=
X-Gm-Message-State: AOJu0YzLH6uHErXhLK4tSpcnbOJ9mPKBPXoiArWBxRRytaubc7242Isl
	zNyEVW4iUvAL8G0i595iJL8wEzZ0nBTVaeINplt+Ojf6sHhCLMC09ZqMLA==
X-Google-Smtp-Source: AGHT+IHgZtRJhoDRhzVeVan2d2h6Dua5ORg/6/3GyJhRRrh5gJRccDtdJTIuZCAKZKxRxaKktsjsHw==
X-Received: by 2002:a17:907:3fa4:b0:a72:64f0:552e with SMTP id a640c23a62f3a-a8394e34235mr618496166b.19.1723923843220;
        Sat, 17 Aug 2024 12:44:03 -0700 (PDT)
Received: from [192.168.8.113] ([185.69.144.74])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a83839344cdsm436743466b.114.2024.08.17.12.44.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Aug 2024 12:44:02 -0700 (PDT)
Message-ID: <ab4252f1-90e3-4abf-b4fb-0b318edc05bd@gmail.com>
Date: Sat, 17 Aug 2024 20:44:37 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring: add IORING_ENTER_NO_IOWAIT to not set
 in_iowait
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
References: <20240816223640.1140763-1-dw@davidwei.uk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240816223640.1140763-1-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/16/24 23:36, David Wei wrote:
> io_uring sets current->in_iowait when waiting for completions, which
> achieves two things:
> 
> 1. Proper accounting of the time as iowait time
> 2. Enable cpufreq optimisations, setting SCHED_CPUFREQ_IOWAIT on the rq

"achieve" is not the right word, nobody wanted 1. and it's not
"proper accounting" but rather an unfortunate side effect.

> For block IO this makes sense as high iowait can be indicative of
> issues. But for network IO especially recv, the recv side does not
> control when the completions happen.
> 
> Some user tooling attributes iowait time as CPU utilisation i.e. not
> idle, so high iowait time looks like high CPU util even though the task
> is not scheduled and the CPU is free to run other tasks. When doing
> network IO with e.g. the batch completion feature, the CPU may appear to
> have high utilisation.

How "batch completion" came into the picture? It elevates
iowait for any net apps, we have enough reports about it.


> This patchset adds a IOURING_ENTER_NO_IOWAIT flag that can be set on
> enter. If set, then current->in_iowait is not set. By default this flag

A worthwhile change but for _completely_ different reasons. So, first,
it's v3, not v2, considering the patchset from a couple month ago. And
since in essence nothing has changed, I can only repeat same points I
made back then.

The description reads like the flag's purpose is to change accounting,
and I'm vividly oppose any user exposed (per ring) toggle doing that.
We don't want the overhead, it's a very confusing feature, and not even
that helpful. iowait is monitored not by the app itself but by someone
else outside, likely by a different person, and even before trying to
make sense of numbers the monitor would need to learn first whether
_any_ program uses io_uring and what flags the application writer
decided to pass, even more fun when io_uring is used via a 3rd party
library.

Exactly same patches could make sense if you flip the description
and say "in_iowait is good for perfomance in some cases but
degrades power consumption for others, so here is a way to tune
performance", (just take Jamal's numbers). And that would need to
clearly state (including man) that the iowait statistic is a side
effect of it, we don't give it a thought, and the time accounting
aspect may and hopefully will change in the future.

Jens, can you remind what happened with separating iowait stats
vs the optimisation? I believed you sent some patches

> is not set to maintain existing behaviour i.e. in_iowait is always set.
> This is to prevent waiting for completions being accounted as CPU
> utilisation.

For accounting, it's more reasonable to keep it disabled by
default, so we stop getting millions complaints per day about
high iowait.

> Not setting in_iowait does mean that we also lose cpufreq optimisations
> above because in_iowait semantics couples 1 and 2 together. Eventually
> we will untangle the two so the optimisations can be enabled
> independently of the accounting.
> 
> IORING_FEAT_IOWAIT_TOGGLE is returned in io_uring_create() to indicate
> support. This will be used by liburing to check for this feature.
> Signed-off-by: David Wei <dw@davidwei.uk>
> ---
> v2:
>   - squash patches into one
>   - move no_iowait in struct io_wait_queue to the end
>   - always set iowq.no_iowait
> 
> ---
>   include/uapi/linux/io_uring.h | 2 ++
>   io_uring/io_uring.c           | 7 ++++---
>   io_uring/io_uring.h           | 1 +
>   3 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 48c440edf674..3a94afa8665e 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -508,6 +508,7 @@ struct io_cqring_offsets {
>   #define IORING_ENTER_EXT_ARG		(1U << 3)
>   #define IORING_ENTER_REGISTERED_RING	(1U << 4)
>   #define IORING_ENTER_ABS_TIMER		(1U << 5)
> +#define IORING_ENTER_NO_IOWAIT		(1U << 6)

Just curious, why did we switch from a register opcode to an
ENTER flag?


-- 
Pavel Begunkov

