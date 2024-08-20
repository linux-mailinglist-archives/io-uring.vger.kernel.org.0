Return-Path: <io-uring+bounces-2848-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 28B66958FC5
	for <lists+io-uring@lfdr.de>; Tue, 20 Aug 2024 23:36:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CFA6F1F21F10
	for <lists+io-uring@lfdr.de>; Tue, 20 Aug 2024 21:36:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1948918FDAB;
	Tue, 20 Aug 2024 21:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="GFFYP2ko"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD3045008
	for <io-uring@vger.kernel.org>; Tue, 20 Aug 2024 21:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724189771; cv=none; b=hJs40Vc54w3ZRfFbYO1jcS+w245fkz8lUgi5cgcViTLmvRj/AOrspemPiLQdhvQfujYmf6fFQpKwiN4aPPn3YMieoDi0mDeGPYfA2zlu4ZD4lprwzyXrrkBqAgPc6OEtYqIm/cAUjy5IpDPS6AxlkINNQ9cM9NL6SVeuF1NPbqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724189771; c=relaxed/simple;
	bh=iOJhVC5beQ5SPJu3AkCiT8fw91FuVLLt6oWrJivyI4g=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=LUlrK+EGrEJNkk/NbSik3Tq6hdnelWz9/hQP/+anaUDczj5JQX6uUO8PcTIcXrDdzn0bbocFfgLnFNfkufAREcgNo0D4GraO+THPLEK/iI8Lsuh1dkNp0MYRbBqMMLyMbjq8BOFISu/vE0YXEBkeBIC5TfGA4+P83zhFP8uzgiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=GFFYP2ko; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-70d23caf8ddso4915625b3a.0
        for <io-uring@vger.kernel.org>; Tue, 20 Aug 2024 14:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724189768; x=1724794568; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bB0m4nySV4nrv0bQ4RJJFyMb7n9+9vQTAuu/Oj99j98=;
        b=GFFYP2kooC3DDFV4AzqTyczMe7ApRcHcg4Gb8cBbGN7/md76M0kCLWYThw23TYeRYe
         TjScMr4N+mjDOTjrPHiqanP/tkEswBKPCk/zNKOzzL/AdpEi5cy+SK1/kjP2DSmuJLtg
         HqmD7dxGOz+0utMAQqL8t9ktE6UipWb78IzAFqzcYcGeLt7mxS8m7jIieUkwhirmldzF
         0xaZRvHG6h3bh4Wd+XqeiO2ICFLEx3Iw8gnXTQifDXyB0Ie3FvKUW+kxNWWFviPCV3fb
         FBJ6DQsWzZEvtp5Lafs6zCV76d9T8ip8LHznGGWCfCXPA/ytzkiUJ8aD3MRorDEw5sRf
         y9Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724189768; x=1724794568;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bB0m4nySV4nrv0bQ4RJJFyMb7n9+9vQTAuu/Oj99j98=;
        b=GrPa+zZefDbrCGZp3X3LXsDEMtSGWr2egZWyz/n7LZbl71gd1gzfFW6Tu7Jd/S/Fg1
         HpDVmYSqxHyMIIClxbk2nmcAlzXtt/w6eP1rMikf8Pbc94sG8M2wfdDJzmoycKV25y1C
         JtRu1EW0XpZNt1P9gg0l5BU53io6NwgWc5zWk1HTaCpmTVfNyU9FrEVgcg6kuMd9BzVE
         cekAXu83JJbGzx8rfllEg78AU9LRbyieuCCaxrhFZKNKcRNXjzIXnGOtTCsiuZdu6To6
         k95di80e8zRA+sdDX4nKmIljmOEmfGd4rPtgkUpGPw/Z/3zIQqfKvqQwpuEecSbY3Gvg
         YjIw==
X-Forwarded-Encrypted: i=1; AJvYcCVIsijZiVjkGbDZG2ZE6LqzRVURAtCZ/uTwTdPCY/9quvUTzffVJpKz6pjohiMZDTb8m6G74kljLw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwCvOizSkVE4yOkl2MTsNM2vC6LfDoAqGJSHZm8P8le5okfA7IH
	agMX8OGwoysJfN4WXgd2sD7dOM52JNTO3uEU9FYaJRcCUf723FhxeLtQMS92HpG0MP+3O80qZwz
	q
X-Google-Smtp-Source: AGHT+IFGfJG9Kmutyb74oRetB/asZxuE4S10D25P0OQnbkP2Gu3ypuwRBzwTdld22ghlKvahC8GesA==
X-Received: by 2002:a05:6a20:9e4e:b0:1c4:b8a1:6d54 with SMTP id adf61e73a8af0-1cad8145eeamr842850637.36.1724189767986;
        Tue, 20 Aug 2024 14:36:07 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d5eb8ccd3esm80716a91.7.2024.08.20.14.36.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Aug 2024 14:36:07 -0700 (PDT)
Message-ID: <4b152237-fed6-4f14-a4cc-a93f8ec32369@kernel.dk>
Date: Tue, 20 Aug 2024 15:36:06 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] io_uring: add support for batch wait timeout
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org
References: <20240819233042.230956-1-axboe@kernel.dk>
 <20240819233042.230956-5-axboe@kernel.dk>
 <c9d18b99-96a8-4c86-abe0-0535f395ccc6@davidwei.uk>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <c9d18b99-96a8-4c86-abe0-0535f395ccc6@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/20/24 3:10 PM, David Wei wrote:
>> +/*
>> + * Doing min_timeout portion. If we saw any timeouts, events, or have work,
>> + * wake up. If not, and we have a normal timeout, switch to that and keep
>> + * sleeping.
>> + */
>> +static enum hrtimer_restart io_cqring_min_timer_wakeup(struct hrtimer *timer)
>> +{
>> +	struct io_wait_queue *iowq = container_of(timer, struct io_wait_queue, t);
>> +	struct io_ring_ctx *ctx = iowq->ctx;
>> +
>> +	/* no general timeout, or shorter, we are done */
>> +	if (iowq->timeout == KTIME_MAX ||
>> +	    ktime_after(iowq->min_timeout, iowq->timeout))
>> +		goto out_wake;
>> +	/* work we may need to run, wake function will see if we need to wake */
>> +	if (io_has_work(ctx))
>> +		goto out_wake;
>> +	/* got events since we started waiting, min timeout is done */
>> +	if (iowq->cq_min_tail != READ_ONCE(ctx->rings->cq.tail))
>> +		goto out_wake;
>> +	/* if we have any events and min timeout expired, we're done */
>> +	if (io_cqring_events(ctx))
>> +		goto out_wake;
> 
> How can ctx->rings->cq.tail be modified if the task is sleeping while
> waiting for completions? What is doing the work?

Good question. If we have a min_timeout of <something> and a batch count
of <something>, ideally we don't want to wake the task to process when a
single completion comes in. And this is how we handle DEFER_TASKRUN, but
for anything else, the task will wake and process items. So it may have
woken up to process an item and posted a completion before this timeout
triggers. If that's the case, and min_timeout has expired (which it has
when this handler is called), then we should wake up and return.

-- 
Jens Axboe


