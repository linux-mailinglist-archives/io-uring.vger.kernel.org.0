Return-Path: <io-uring+bounces-3484-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 562A4996F78
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 17:16:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D78B71F22F54
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 15:16:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8049B1E32A4;
	Wed,  9 Oct 2024 15:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BWXZoE5G"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B20611E2858;
	Wed,  9 Oct 2024 15:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728486562; cv=none; b=E9NsG2BGFcq0Fadh3scm3FS8cjpq0qbOsx/bCQTu2geRjK7G370DY1kQYJMTcls8XfE/IOjDKqK0RtX/CYs9mJuyOFU0IqU1ruBKVML0WMhQMDhDdxc2aH86UimerrmFSm3g4nFqP/xg9V/8BgqyFrM+FQgPk3TXVwfJfjYhg14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728486562; c=relaxed/simple;
	bh=uZ54pFJFj2Zw5++BAwzxrD1pPCNO78w1kVIh8QZQNKE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=TMy457X+QxrI2QhIxj5wUjFmkhYe097Zg67BAWUfEmdabBnS1oFs/M/ALJhy5oWSQtQXYu9bbcQ7Rh1IVrEJN3Ep2zkRwAAX3paOSy6nA1CcCeOtXALFNfm6Hrape+sYgvlnHjb6XGW3kxVB+ntMY+cpkKXkHSE7aRQXWPBtAkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BWXZoE5G; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5c721803a89so9200010a12.1;
        Wed, 09 Oct 2024 08:09:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728486559; x=1729091359; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bmUH5PMMwAviPX/hS45SXtDc5E8JnW6EI8zoJlvVa9Y=;
        b=BWXZoE5GjGuQfp2Gjqy+IArZ5/Tu3J70Mkg/oXf68poLoixRQ8qJLxEH4njqF873wF
         rVea9JbkbhMnz+eVzp1u7HBfyXZlCswWvHanVov+oL3TcG3fQtF4nAUiK9/GxFVOfPv0
         lsQRUhGq2cnEZlTsMkd3RVCuGOSMdW4g/tWxviGKeIbBmaOYWTYDQJwQ6tQ/YSWDQ5Dx
         asqD58dYH5nRlX5EYChSMFvgJCsWkCTP5f5rW27llP8ppQ+s9UUwOv2jUKeOsbFVbxHl
         Bt/RZXqVjyTpcLSnITIzxsY5glkzd0fohUxgsCQBK3wkvFGBTJBILJZ6xKvm0V2gC80k
         3Nmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728486559; x=1729091359;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bmUH5PMMwAviPX/hS45SXtDc5E8JnW6EI8zoJlvVa9Y=;
        b=RGbiHkRAkXEQoz5ssAlTxPztOLgWJfXfpdDv4e8ug6VJuP9AlCgMJpT5J4a9UUyZL6
         2WKexV27yJ3JdCbwbQ0EU+GKpT4vBHvcPSKK0gkDPFk0fH6vW3+P09tveQ7rN2cG2mjm
         hca/nfho/vXPScl86hcoIWjTqMxGRIrh4I9Mhm6oBA8RYsIZDEMZskYPrT+KJC36PudU
         8j3gXR7BMZjPz8OfbbT600Jf4dRDT1aKVV529hL+61O0Q9qeo5A9OAufdNYH+uoaTvqH
         XtinU/2tnk/+oHYgw5pHimQoHyH/eu/sTnvOo44PVSHrh44aygdGT6mbjmxx9duRtD1r
         nKoQ==
X-Forwarded-Encrypted: i=1; AJvYcCVrS1W1KL3A+Ai/v0E7RCV30e324LAd7RNVLxSVeZIAoQi8J2MLnrdfWk79PiShkVsgOmen8XtR@vger.kernel.org, AJvYcCWjZ9naIRd1uz7BRqSL2cdrTQzvzusN80xHVO+4okHS0mnxIqaz0r5OusHnzZESraIQ56rWeSdn6Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YyVfsQ0hsVP6/D5NTLPgMWwaIMwUonCRdT+/TEV5BOxJqmT6x4x
	J6ycBiiNh5N6fHzdFF9xXeIaZ2HusC/7iobOil/ecAXTwrFCpNnx
X-Google-Smtp-Source: AGHT+IEIPjqDJmZg0ggkHNedah9G0DG3VbybrFkehxyodEqoC/A9W4Pwg/M5uMhotxyQLMLlUOKKhw==
X-Received: by 2002:a05:6402:3815:b0:5c3:d18e:fc27 with SMTP id 4fb4d7f45d1cf-5c91d722a8emr2191089a12.33.1728486558878;
        Wed, 09 Oct 2024 08:09:18 -0700 (PDT)
Received: from [192.168.42.207] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c92b5663cfsm309094a12.8.2024.10.09.08.09.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2024 08:09:17 -0700 (PDT)
Message-ID: <6e20af86-8b37-4e84-8ac9-ab9f8c215d00@gmail.com>
Date: Wed, 9 Oct 2024 16:09:53 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 08/15] net: add helper executing custom callback from
 napi
To: Joe Damato <jdamato@fastly.com>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <20241007221603.1703699-9-dw@davidwei.uk> <ZwWxQjov3Zc_oeiR@LQ3V64L9R2>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZwWxQjov3Zc_oeiR@LQ3V64L9R2>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/8/24 23:25, Joe Damato wrote:
> On Mon, Oct 07, 2024 at 03:15:56PM -0700, David Wei wrote:
>> From: Pavel Begunkov <asml.silence@gmail.com>
> 
> [...]
> 
>> However, from time to time we need to synchronise with the napi, for
>> example to add more user memory or allocate fallback buffers. Add a
>> helper function napi_execute that allows to run a custom callback from
>> under napi context so that it can access and modify napi protected
>> parts of io_uring. It works similar to busy polling and stops napi from
>> running in the meantime, so it's supposed to be a slow control path.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> Signed-off-by: David Wei <dw@davidwei.uk>
> 
> [...]
> 
>> diff --git a/net/core/dev.c b/net/core/dev.c
>> index 1e740faf9e78..ba2f43cf5517 100644
>> --- a/net/core/dev.c
>> +++ b/net/core/dev.c
>> @@ -6497,6 +6497,59 @@ void napi_busy_loop(unsigned int napi_id,
>>   }
>>   EXPORT_SYMBOL(napi_busy_loop);
>>   
>> +void napi_execute(unsigned napi_id,
>> +		  void (*cb)(void *), void *cb_arg)
>> +{
>> +	struct napi_struct *napi;
>> +	bool done = false;
>> +	unsigned long val;
>> +	void *have_poll_lock = NULL;
>> +
>> +	rcu_read_lock();
>> +
>> +	napi = napi_by_id(napi_id);
>> +	if (!napi) {
>> +		rcu_read_unlock();
>> +		return;
>> +	}
>> +
>> +	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
>> +		preempt_disable();
>> +	for (;;) {
>> +		local_bh_disable();
>> +		val = READ_ONCE(napi->state);
>> +
>> +		/* If multiple threads are competing for this napi,
>> +		* we avoid dirtying napi->state as much as we can.
>> +		*/
>> +		if (val & (NAPIF_STATE_DISABLE | NAPIF_STATE_SCHED |
>> +			  NAPIF_STATE_IN_BUSY_POLL))
>> +			goto restart;
>> +
>> +		if (cmpxchg(&napi->state, val,
>> +			   val | NAPIF_STATE_IN_BUSY_POLL |
>> +				 NAPIF_STATE_SCHED) != val)
>> +			goto restart;
>> +
>> +		have_poll_lock = netpoll_poll_lock(napi);
>> +		cb(cb_arg);
> 
> A lot of the above code seems quite similar to __napi_busy_loop, as
> you mentioned.
> 
> It might be too painful, but I can't help but wonder if there's a
> way to refactor this to use common helpers or something?
> 
> I had been thinking that the napi->state check /
> cmpxchg could maybe be refactored to avoid being repeated in both
> places?

Yep, I can add a helper for that, but I'm not sure how to
deduplicate it further while trying not to pollute the
napi polling path.

-- 
Pavel Begunkov

