Return-Path: <io-uring+bounces-11860-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cBwNFjrzcGk+awAAu9opvQ
	(envelope-from <io-uring+bounces-11860-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 21 Jan 2026 16:39:38 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id CD1C75954B
	for <lists+io-uring@lfdr.de>; Wed, 21 Jan 2026 16:39:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A4A75AC8426
	for <lists+io-uring@lfdr.de>; Wed, 21 Jan 2026 15:18:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 297AF4DA525;
	Wed, 21 Jan 2026 14:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="kAKiXTat"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f68.google.com (mail-ot1-f68.google.com [209.85.210.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A42104D90A1
	for <io-uring@vger.kernel.org>; Wed, 21 Jan 2026 14:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769007496; cv=none; b=FaXUmkScRcLnpZ5mgv7sc0sEOMnb+3krJhVi9PoZB67FWlXyxjG0bW41qPqrMhd2sliBAI36JfcTn2AnKILM8k9HmSCHJn78er8KPunUqhl1k6WEcemECsfnwTeLDdbGKe+v+QZT0cuKn5yrkp41t3+7wMhoaKX6C7d2UnMcob4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769007496; c=relaxed/simple;
	bh=FhRF4TprwvtpTNTyA7ahJyGZxuy3UAIoj1FV/RjFo1w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kdBextlUfztOL47NCcU1GyiDVP4A3TQzlQhFKGW9qrjTEQ5BvOiE61fKnkjf2dphplPsFd+23D91i5yca4gqNH4L5DfD617HCVfwWyrdWSzvBGArPKhLirjIKRhJubHKv8XqorCznHYPyBYrRxCkuNuHBp7fApGYxTgho48a7TM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=kAKiXTat; arc=none smtp.client-ip=209.85.210.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f68.google.com with SMTP id 46e09a7af769-7cfcb5b1e2fso4058597a34.3
        for <io-uring@vger.kernel.org>; Wed, 21 Jan 2026 06:58:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769007491; x=1769612291; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZMSymaMx0zUSENRKlkjeR2DpFwBjeuqiJTkmHDD+xpM=;
        b=kAKiXTatDKxpAxSiH9fd+b/rCdVJrZ1OHPDsk/LYiasSz3OQRyR6DaC/L+IL+BufxJ
         nidRxsfO8DQH+obMq3qIEjDNepxBkJm2dMklRkV4X1Oa9/7zJwoHju1I4JPaSosHunjd
         Fsmv7pEqJV4wbiZUaUxP0MxSEkJp7yaIHJNyaBTdkCEZhNsGVq/zaZavG8aqUvcUBSlG
         ImsCZmEGbGybh8JNQeAzi8AV4FXuTdGM2tQ7TCRISGiJW4aMoCeRXE9Z4Zl7d1cERrBM
         w30gq+3eZZ6LTPQAAAp1h6TtvT9EyDvLftrfiLeh1ij6pFxFR1KAQrlNioLKoysFxIve
         dpQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769007491; x=1769612291;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZMSymaMx0zUSENRKlkjeR2DpFwBjeuqiJTkmHDD+xpM=;
        b=Xq/J1ZpYBfQwDtvi6R072VvAXYaCBa7ZsNG07H/leAjOvQINxSzor7U6mn9MIlua1O
         z9Xbya+W89Ef1u44RYUp6T2781bUbxxBd6d+sRmV9oCPHu0+BGk9NvBATL4CqR9z2ElB
         f157njZoYk549WShvxFsq2R1ZYb6EWDpYf5coUFU/V/WWfNVPe16KgiScOCUNpUC655O
         0s+i0Tp8RzGYu3UelzbhzF0of0WtR7ODZPu72eXf1RwrKnWq2k+xA/lBE5NlhEbqtrcv
         cBEr987uT8B7sS9k5owiyder4KPQxZZGyZKICr2CM+2DawNzsw94mUdJ+uNCtKxhWGTX
         TOPQ==
X-Gm-Message-State: AOJu0YwtXRjBRm3aspaGLGOVaFXWNuR9024Pmr5Ru6I1dpq/3XlkmCdb
	gRHVxWViYS0Un/+qNpx7pTkzinuGNeeL4d2NH5FzeqT00eMG8B5k22gELs0fQmFcw3g=
X-Gm-Gg: AZuq6aLSiKQj6YEHkdIUgzPszQxXXi0t6Twuijad6HuCf4tTFUGH3b72snlbvEKK+Dy
	imikkQ+y+GmWCk3C7wL0ozQcFcgVWpGyF96ZDMiTwth/ohl3AJUw7eTdJtVMbkoe3ONXIhwH/vZ
	YG8ytqvIOHqsDa4rL+6odRr/O1nRkDv7v9q9yNTmGflDzGyXRlzaaLxr5xnAfkX3ifoyurvUixl
	ydi7ntYwP6+ZAy4/D9p0BcD0CZvKEgXnE8POCLOOnhb4U7hGTX7+ihtbl3rtUHjEEZrsHxmMCoi
	UKKyO0V0V+CwmTGZ+ZUO1XAoSVbYAAXehMYfZXTzMR4EGS5ggkrvSR93sMqZ4tAdaZYHOOAlvJY
	i7TYw3nWkbxqlnrFZvCmvZKB6eS5rpcwc1FzsVq3+K0hm+kr6eS7SSWjuiDm4Fif8o1+WpUcYMo
	UFw2mNwMN08qAg0V1dNJJG+elhHRYCTSXCgScf+BGElZdr6J0lK0wipju/zLYp2GGfbAk0
X-Received: by 2002:a05:6830:82ea:b0:7cf:f7c1:d9ac with SMTP id 46e09a7af769-7cff7c1da6dmr8425940a34.9.1769007491402;
        Wed, 21 Jan 2026 06:58:11 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cfdf2a5f6dsm10709783a34.20.2026.01.21.06.58.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jan 2026 06:58:10 -0800 (PST)
Message-ID: <2fcf583a-f521-4e8d-9a89-0985681ca85b@kernel.dk>
Date: Wed, 21 Jan 2026 07:58:10 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring/rsrc: fix RLIMIT_MEMLOCK bypass by removing
 cross-buffer accounting
To: Pavel Begunkov <asml.silence@gmail.com>,
 Yuhao Jiang <danisjiang@gmail.com>
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
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2be71481-ac35-4ff2-b6a9-a7568f81f728@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-11860-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	RCPT_COUNT_FIVE(0.00)[5];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo,kernel.dk:mid,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: CD1C75954B
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 1/20/26 2:45 PM, Pavel Begunkov wrote:
> On 1/20/26 17:03, Jens Axboe wrote:
>> On 1/20/26 5:05 AM, Pavel Begunkov wrote:
>>> On 1/20/26 07:05, Yuhao Jiang wrote:
> ...
>>>>
>>>> I've been implementing the xarray-based ref tracking approach for v3.
>>>> While working on it, I discovered an issue with buffer cloning.
>>>>
>>>> If ctx1 has two buffers sharing a huge page, ctx1->hpage_acct[page] = 2.
>>>> Clone to ctx2, now both have a refcount of 2. On cleanup both hit zero
>>>> and unaccount, so we double-unaccount and user->locked_vm goes negative.
>>>>
>>>> The per-context xarray can't coordinate across clones - each context
>>>> tracks its own refcount independently. I think we either need a global
>>>> xarray (shared across all contexts), or just go back to v2. What do
>>>> you think?
>>>
>>> The Jens' diff is functionally equivalent to your v1 and has
>>> exactly same problems. Global tracking won't work well.
>>
>> Why not? My thinking was that we just use xa_lock() for this, with
>> a global xarray. It's not like register+unregister is a high frequency
>> thing. And if they are, then we've got much bigger problems than the
>> single lock as the runtime complexity isn't ideal.
> 
> 1. There could be quite a lot of entries even for a single ring
> with realistic amount of memory. If lots of threads start up
> at the same time taking it in a loop, it might become a chocking
> point for large systems. Should be even more spectacular for
> some numa setups.

I already briefly touched on that earlier, for sure not going to be of
any practical concern.

> 2. Most likely it'll further relax accounting (i.e. one way
> road), and I don't believe that's the right thing. Could even
> be unexpected if consolidated w/o any explicit communication
> b/w rings (like buffer cloning).

Well the aim is to make the accounting actually correct.

> 3. Map keys will need to be {page, user, mm}, so I suspect
> impl is not going to be exactly trivial either way. Maybe some
> nested xarrays + something for counting middle layer entries.

Honestly I think the xarray just needs to go into struct user_struct.

-- 
Jens Axboe

