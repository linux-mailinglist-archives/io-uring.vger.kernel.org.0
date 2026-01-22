Return-Path: <io-uring+bounces-11882-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QEZzCyUQcmksawAAu9opvQ
	(envelope-from <io-uring+bounces-11882-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 22 Jan 2026 12:55:17 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id D3AC16643E
	for <lists+io-uring@lfdr.de>; Thu, 22 Jan 2026 12:55:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D9CD2907F8B
	for <lists+io-uring@lfdr.de>; Thu, 22 Jan 2026 11:45:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2748743E49C;
	Thu, 22 Jan 2026 11:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HhLiMYfp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com [209.85.221.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 722F040F8D5
	for <io-uring@vger.kernel.org>; Thu, 22 Jan 2026 11:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769082216; cv=none; b=pFhBIHJQXKYSxWX8545tpSVMBhaZWscVnKZsYcFaxm84A2fW3b4y2nF2CFqk42nPxHJhSMvt+De+YnsvDvjC69VtZ6yH6LXmNaVk36nw2ICUmI9OBpA9k88pVvS2aZwrqTgI8t8nQ9oAU8ebS4xjwExPw4dCNooqR0ry1xeP2GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769082216; c=relaxed/simple;
	bh=F41KeYoTPX1xryCYyrjJBC6quQJkQA8gOyh0i4b/oQ4=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=Fk8ifZ9ttyiHRVMXErWng2Gq2WcAuE7TdtBHmnprr1gMIUzLBgazg4D5UQg4dMSRAsZPOyW3DtiinlQyHMMWHg7MkMsuCGymokLfoMl3AxVNCNgmLB+gu0jNnimGsjP2PygCyrtJ83vks4HTkurY+imtjzO3sYE8G7jbCjbJ4XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HhLiMYfp; arc=none smtp.client-ip=209.85.221.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f67.google.com with SMTP id ffacd0b85a97d-42fed090e5fso583782f8f.1
        for <io-uring@vger.kernel.org>; Thu, 22 Jan 2026 03:43:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769082213; x=1769687013; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4HpEyOC6PJWGGCRXO6diXKKa/2BXf2R4DS4i3pG5vnY=;
        b=HhLiMYfpVekH0/ua43LJafJwNLFcyyqm8QlDnSmGBL31MtrJDQpCzE9t+OxuL2peyT
         HB63bWXBta/gXSjZurr6WLluqHt61qkUH7uPSOY1dUYjjjoUDFag0AbVDlTEoaGzwuwu
         ewpyVEe7SWMTL9QfFTUMhE3mptNMKie2O1UXv5NM4b6zRwI6HXdMzYRAM7J9Ufg6Y0Rm
         1rZRhxLZTWt4/SI1pYL26u1G7beaU3qDT2xH8zc72Dcuewqt1DvdEQP+BhMKUQGQmcJL
         FxUOLspxo5eeh51UHgKu6hmdSksMJ9ftPsFBF8ijkUwmcqYJUfJpJio57exbBIjTmRg2
         Ft4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769082213; x=1769687013;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4HpEyOC6PJWGGCRXO6diXKKa/2BXf2R4DS4i3pG5vnY=;
        b=DheZw0r99HbgvsKyexPkBKbeoaSiJ0Et12/XaEephtDl2KCatg9L9p3Y93G6GEsAf5
         +m4g0hCv7kb/TrWtU9dZuhRq4zQcM40/Ee6tPRQ6AhzYZEHWRgtvFIHFBiU0C9aMETze
         JjgdX1VAETgSb2ZEvhYDyX7e5gL8txoGT8Rn6doiBLL5aYvs4woMo91lqt8n+Y+Ab8Hz
         Cd7AQdpJyQ2NFLPTQLDbYp9Xqr+1wf1yjTUuMvBWSVA7BZu711PBk3ZwwZIlrPsqoHqO
         Mf15biyV2KftqmDBdA7pvW54gbiAYx52G3inXm67VP+asQMf5jfC3v0MzUsBtalIGyfM
         JVqw==
X-Gm-Message-State: AOJu0Yx1jgo9HxRr0f8DltbEbeRae6eyD91ZO9JTFXHdxa1S8rV7B3jk
	SKH+wA+yLHdqEt5OUivVKMghkHAkP8+USZTYgBEx91r2B/ZMn6Og8b7e
X-Gm-Gg: AZuq6aIzPiUhcygzCFKsvEZTWPHmRW2oWKTEKcH5b1h27VeML+sgIACO4Q3HY+vDXrK
	ZKiuA94OqUBpAlSmFh48RRm7JYImzyo/JKXbSAvNltRz6sfwpboivi52PRCOXyRlsmjIQBNjjSy
	x/teFNlNB/Nbo7bcaUGxMxE1zim5VnlWNRLo4+bVUbpKm7gvGZJbDl+cPBPFN18ux4dFgaeB0Sl
	hlABSLm3G6hxGjR36ljdy0DtZccKKw6p0Iv9S/jXiNlBTrJ2wZ70ai5kEEQT2iSEZT9OzEzXaEM
	XfMJJGIGzFvSoKoAVNqkOZL9AhdvAxCJVrq5kDO1eTSSnuHKj2HAyZNMlBZZI2qQ/dMcMqZEZP6
	dUuMrX47fi/dEbyYBuPEZnzGZOnTwjfabs0z4CCcQL3B7yxTq925eAXQlmFJ084AU+lJXsY5+TG
	0EZxse5DsYgybIuhyX2GnML0d3Xkwkp4x5bQVU+GRqZRCxoTx4d1Yy3qUp6RBREX/uqCUC1QUEv
	CUBTLP2rIhKKCUYOwiUM334LBoq8kLng+04cKB/1XIVtfc=
X-Received: by 2002:a05:6000:2502:b0:430:f3ab:56a1 with SMTP id ffacd0b85a97d-43569bcb6d7mr31529951f8f.42.1769082212593;
        Thu, 22 Jan 2026 03:43:32 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:46c4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43569921f6esm43811271f8f.4.2026.01.22.03.43.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jan 2026 03:43:31 -0800 (PST)
Message-ID: <d2fc2ff2-98d9-49f8-af95-968100174d55@gmail.com>
Date: Thu, 22 Jan 2026 11:43:28 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH v2] io_uring/rsrc: fix RLIMIT_MEMLOCK bypass by removing
 cross-buffer accounting
To: Jens Axboe <axboe@kernel.dk>, Yuhao Jiang <danisjiang@gmail.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260119071039.2113739-1-danisjiang@gmail.com>
 <bc2e8ec1-8809-4603-9519-788cfff2ae12@kernel.dk>
 <CAHYQsXTHfRKBuTDYWus9r5jDLO2WLBeopt4_bGH_vVm=0z7mWw@mail.gmail.com>
 <2919f3c5-2510-4e97-ab7f-c9eef1c76a69@kernel.dk>
 <CAHYQsXQK4nKu+fcni71__=V241RN=QxUHrvNQMQtPMzeL_z=BA@mail.gmail.com>
 <d8d28435-2a89-4b25-925e-14fdb346839b@gmail.com>
 <8c6a9114-82e9-416e-804b-ffaa7a679ab7@kernel.dk>
 <2be71481-ac35-4ff2-b6a9-a7568f81f728@gmail.com>
 <2fcf583a-f521-4e8d-9a89-0985681ca85b@kernel.dk>
Content-Language: en-US
In-Reply-To: <2fcf583a-f521-4e8d-9a89-0985681ca85b@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-11882-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_TO(0.00)[kernel.dk,gmail.com];
	MIME_TRACE(0.00)[0:+];
	DMARC_POLICY_ALLOW(0.00)[gmail.com,none];
	DKIM_TRACE(0.00)[gmail.com:+];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:helo,dfw.mirrors.kernel.org:rdns]
X-Rspamd-Queue-Id: D3AC16643E
X-Rspamd-Action: no action

On 1/21/26 14:58, Jens Axboe wrote:
> On 1/20/26 2:45 PM, Pavel Begunkov wrote:
>> On 1/20/26 17:03, Jens Axboe wrote:
>>> On 1/20/26 5:05 AM, Pavel Begunkov wrote:
>>>> On 1/20/26 07:05, Yuhao Jiang wrote:
>> ...
>>>>>
>>>>> I've been implementing the xarray-based ref tracking approach for v3.
>>>>> While working on it, I discovered an issue with buffer cloning.
>>>>>
>>>>> If ctx1 has two buffers sharing a huge page, ctx1->hpage_acct[page] = 2.
>>>>> Clone to ctx2, now both have a refcount of 2. On cleanup both hit zero
>>>>> and unaccount, so we double-unaccount and user->locked_vm goes negative.
>>>>>
>>>>> The per-context xarray can't coordinate across clones - each context
>>>>> tracks its own refcount independently. I think we either need a global
>>>>> xarray (shared across all contexts), or just go back to v2. What do
>>>>> you think?
>>>>
>>>> The Jens' diff is functionally equivalent to your v1 and has
>>>> exactly same problems. Global tracking won't work well.
>>>
>>> Why not? My thinking was that we just use xa_lock() for this, with
>>> a global xarray. It's not like register+unregister is a high frequency
>>> thing. And if they are, then we've got much bigger problems than the
>>> single lock as the runtime complexity isn't ideal.
>>
>> 1. There could be quite a lot of entries even for a single ring
>> with realistic amount of memory. If lots of threads start up
>> at the same time taking it in a loop, it might become a chocking
>> point for large systems. Should be even more spectacular for
>> some numa setups.
> 
> I already briefly touched on that earlier, for sure not going to be of
> any practical concern.

Modest 16 GB can give 1M entries. Assuming 50ns-100ns per entry for the
xarray business, that's 50-100ms. It's all serialised, so multiply by
the number of CPUs/threads, e.g. 10-100, that's 0.5-10s. Account sky
high spinlock contention, and it jumps again, and there can be more
memory / CPUs / numa nodes. Not saying that it's worse than the
current O(n^2), I have a test program that borderline hangs the
system.

Look, I don't care what it'd be, whether it stutters or blows up the
kernel, I only took a quick look since you pinged me and was asking
"why not". If you don't want to consider my reasoning, as the
maintainer you can merge whatever you like, and it'll be easier for
me as I won't be wasting more time.

-- 
Pavel Begunkov


