Return-Path: <io-uring+bounces-2855-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C620959041
	for <lists+io-uring@lfdr.de>; Wed, 21 Aug 2024 00:08:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 71F501F218FB
	for <lists+io-uring@lfdr.de>; Tue, 20 Aug 2024 22:08:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A78B158A37;
	Tue, 20 Aug 2024 22:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y5PdjFeR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146871E86E
	for <io-uring@vger.kernel.org>; Tue, 20 Aug 2024 22:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724191697; cv=none; b=uMQY8OqHUkhWhdWHkJ1huRKBQGLoPDQ6HDtEE1ZoflU8Lohu+rYABusEQcIlV6vfn7Qv2NvjghIofd3L95S9wcr7oweMy9IPdNGMv1MVHd901NL2DUPYQJkuLvA2Yhxn5Nev+pIdGuMRppcFd8SCbWxK/1nDh2hiZC6iSlHkOzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724191697; c=relaxed/simple;
	bh=QZVbwVhxf64MitTYhnpveisLGOofEXwsJU5m57wxB58=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=RIillezbG5hOf/2CqMVm+k70UfJfCBJzoY4CK1lBJd6Ub03ElDWJTzCgxa/QHhI/T9uIlO0Ek5jel99jo2hbD/7VQlazg0VNeO5hpaSv05LqY0LBfuDNjEuOO/5kRg72B5wrWlhkhtnOlzlC8V1xH+dwS2oz6P6fS6RJ3HSV/6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y5PdjFeR; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a86464934e3so195662166b.3
        for <io-uring@vger.kernel.org>; Tue, 20 Aug 2024 15:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724191694; x=1724796494; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=634xHUZ86p0ddg9kR/fofU6qDWK65fPgYXwJHymF7zw=;
        b=Y5PdjFeRJJgZoYy7vqVnhNKiDc52EMu8rLUT6V9ZAGoSKq3qYKfGOmfBiitHo6RPKl
         nUX45LUWUbNFZ1BiF5FWS89KMCtPJ8pLRN26VVXGOGW4GcDuueiMw3zyB6E2e5rWElm6
         5Xvoi6y3ywTc9EBREesTaqmv7kqhtWgwfWNoftqtcbPPsSlcyXgMQe2faetTyf7n1smN
         kEatG698uLwkGnxqo690N4RVAUkDeYmu6ukYl4TJDijEGcgNIOcolS5Y1SmdCF/HCZ5h
         hwrSkXjIuqucpndfiwQwpc7WT8Kgj0kv2BBurT/Ru8sbPmUOt3AKprIeaP6pqFJQNpKq
         WlYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724191694; x=1724796494;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=634xHUZ86p0ddg9kR/fofU6qDWK65fPgYXwJHymF7zw=;
        b=ZFJ2b+4iL9rcPozSZ3ea/yXV8Z3kU54thOu79CTMntw9lp0eLXiGbq+97necrLzWcM
         NwQ+z1EQhIkSXbmuLd66BSDn91g1AxXTyEn0ySSDzIgunYS9gvwDFJBjROPJdwKQ7tus
         6SEM4ebLn3qvcAvsC3gB4/mpml/uFQ3mHUMw/xRHmZw4KARol0wNO7be2VmYkppeqhjH
         x6TTzJy8W2gkVNhcvulo8yNn2mdEhenodwul9FPP1Y49T1AwcWaE+BLd+jeyIUbx73VM
         omA+OqE4o/7RRelOGV6t/+fB7BxS5UpmRzeniSN1ZZ9IC4Ef6qRxS2UHe0awK9kQqmpP
         k+UA==
X-Forwarded-Encrypted: i=1; AJvYcCVmo12GJVBHpFvjoQ9qPVZQuIp5sD3dwTDM8I2lK9Cb5c8bJie2G+82uDBHJq/ZtgunMu0raXGCPg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzxtGTE8hJ9uCDxUG66l2Oxxm2J9/o7L2ht+u/E9yCrdfpnpusN
	Asx+bLar73nokbsiwcWs65pXiFOcAih9rAEFSmxKxRG8Zgf96Ybw
X-Google-Smtp-Source: AGHT+IFw1ch9HwxF3gGtHdQz8IUwRRoqCnvl6OXm+lsmzEwob94kPgW7DOFScm0JWMuhFe/wTAvCrw==
X-Received: by 2002:a17:907:f198:b0:a7d:3ab9:6a5d with SMTP id a640c23a62f3a-a866f902df7mr31589766b.69.1724191694045;
        Tue, 20 Aug 2024 15:08:14 -0700 (PDT)
Received: from [192.168.42.254] ([148.252.128.6])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a83838c687csm807206066b.9.2024.08.20.15.08.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Aug 2024 15:08:13 -0700 (PDT)
Message-ID: <7faceb92-5a29-421b-a6fc-7dbad9074584@gmail.com>
Date: Tue, 20 Aug 2024 23:08:42 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] io_uring: add support for batch wait timeout
To: Jens Axboe <axboe@kernel.dk>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org
References: <20240819233042.230956-1-axboe@kernel.dk>
 <20240819233042.230956-5-axboe@kernel.dk>
 <c9d18b99-96a8-4c86-abe0-0535f395ccc6@davidwei.uk>
 <4b152237-fed6-4f14-a4cc-a93f8ec32369@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <4b152237-fed6-4f14-a4cc-a93f8ec32369@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/20/24 22:36, Jens Axboe wrote:
> On 8/20/24 3:10 PM, David Wei wrote:
>>> +/*
>>> + * Doing min_timeout portion. If we saw any timeouts, events, or have work,
>>> + * wake up. If not, and we have a normal timeout, switch to that and keep
>>> + * sleeping.
>>> + */
>>> +static enum hrtimer_restart io_cqring_min_timer_wakeup(struct hrtimer *timer)
>>> +{
>>> +	struct io_wait_queue *iowq = container_of(timer, struct io_wait_queue, t);
>>> +	struct io_ring_ctx *ctx = iowq->ctx;
>>> +
>>> +	/* no general timeout, or shorter, we are done */
>>> +	if (iowq->timeout == KTIME_MAX ||
>>> +	    ktime_after(iowq->min_timeout, iowq->timeout))
>>> +		goto out_wake;
>>> +	/* work we may need to run, wake function will see if we need to wake */
>>> +	if (io_has_work(ctx))
>>> +		goto out_wake;
>>> +	/* got events since we started waiting, min timeout is done */
>>> +	if (iowq->cq_min_tail != READ_ONCE(ctx->rings->cq.tail))
>>> +		goto out_wake;
>>> +	/* if we have any events and min timeout expired, we're done */
>>> +	if (io_cqring_events(ctx))
>>> +		goto out_wake;
>>
>> How can ctx->rings->cq.tail be modified if the task is sleeping while
>> waiting for completions? What is doing the work?
> 
> Good question. If we have a min_timeout of <something> and a batch count
> of <something>, ideally we don't want to wake the task to process when a
> single completion comes in. And this is how we handle DEFER_TASKRUN, but
> for anything else, the task will wake and process items. So it may have
> woken up to process an item and posted a completion before this timeout
> triggers. If that's the case, and min_timeout has expired (which it has
> when this handler is called), then we should wake up and return.
Also, for !DEFER_TASKRUN, it can be iowq or another user thread sharing
the ring.

-- 
Pavel Begunkov

