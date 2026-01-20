Return-Path: <io-uring+bounces-11842-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WCUEBr3Zb2n8RwAAu9opvQ
	(envelope-from <io-uring+bounces-11842-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 20:38:37 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 776F24A965
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 20:38:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4797AA28FDD
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 17:03:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABDDB34BA54;
	Tue, 20 Jan 2026 17:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="FqNKzHDi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f193.google.com (mail-oi1-f193.google.com [209.85.167.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A4A346FA6
	for <io-uring@vger.kernel.org>; Tue, 20 Jan 2026 17:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768928627; cv=none; b=Wudt94R/cFzmoyJxv+VpmZ2WO8iTwheIOJEgAoZ+HoCA+J38u6GCoDjBlAcR4LEG6Xz4zsc9IN91RAJCdhUWhK2YwBUacRmWcnXDBt+2zgYKB+3roDrujH6JAhpETTAyXRDNQy94whL7axQ1zuV3QcAtVBN7Mo8+5RUbYaMqqCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768928627; c=relaxed/simple;
	bh=pJjxoJ8ZV0RDeAQzTE88gBAR7M4kAsbQDew/ase9Cvo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r8J2TkE0DB8RvPzvi9RhzrS7ccgoHS8rUW8a7segHzd4LfHH+LxOZbksqmRsdM1ODz2Dw0p+lbHwZGIWXgg/EBBVwpYKrjFb9mfdOjorHBxL5ch4HElp84YjpRpBAqh6NeKEF85p0z2mIdYbGSCOTYHNtmr+NPUHBF1CHHPzj9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=FqNKzHDi; arc=none smtp.client-ip=209.85.167.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f193.google.com with SMTP id 5614622812f47-45c86087949so2026784b6e.2
        for <io-uring@vger.kernel.org>; Tue, 20 Jan 2026 09:03:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768928624; x=1769533424; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Vf1OjI+ofEbUEpptjhVbn5HMY4y4Bo5wpFAmArgvbwA=;
        b=FqNKzHDijEyd9bY1auA+X5cH7+Lu7SdvyQTuw3Kv5NG36xjLrgaG11B3vhn9QyBGi9
         Xdf1cq6fG8fXaPT4rnDfPQ6By3nHWqy49DqPcURjwdSfwShfAHS8aQMV2Wnn+UNGyJcF
         ftsQZh4VWbj0QJxOmSxC35JFJ0OkB3ZOIKgKvnEbwqVn52Q0mf3DbOXWTcq8X9+LB6oe
         ti0DVRSJMrms2uZfvBygm1Mavmg6uHT5FI+Eiuqt+wQ7q4raBeguCjg4uU/99dPPJIMm
         yDVNbZ8PhWgHkktPYNraJR4dAbatvslI4Om7HBkQ5QhoGuK1aMs8xLAag0KiPHGy/qTG
         6y1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768928624; x=1769533424;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Vf1OjI+ofEbUEpptjhVbn5HMY4y4Bo5wpFAmArgvbwA=;
        b=vvdMJcfUPr51SnVP7h1FxxCYPCRFAAibv29sMS3i0L3f/D///bwE9EUheEj4ptEcLQ
         kN6wNTxquOWVlWCAJSHAvAnOYRxxv36bF+ybdJxGLV0zSWv8gOsI7+WYxLTgYIWqzzz7
         tyfTO5E8wmNKuokvKhLfEPnEFAiPMfEU0WVXWV/GZfDQe3c3NPW4H72pPJPy+slizG06
         JTtXNjZZWyg0j2BMOMdQHJ7AIByJhEtp86xbrC3cpsXDTRfyb44ztfUQl4i+yp06Dvp0
         xcaWUnfgsaQhV/lYjnIwJQxhzZIXUFEy2BqN/BrGFp4HzkrImJDDfnj//Amv9ZKGNf1k
         /Xow==
X-Gm-Message-State: AOJu0Yyn1qR4bdCD4/TBp4M/cnXAe5ERgkyYj4jhOaugrA4S/LNghmle
	AvYY8S/2XO6k3kTzy/TGEEmHkt7vVzjr2C9OQyh9Hv7h/rVUWwlO/6fSYRNxyaQ5/WndGVoS30z
	WrwErcpFgdQ==
X-Gm-Gg: AY/fxX7BMIiB4U/amR+ipGDdHg4kzSEth/4tNFsVbhq5JgQ/kYZJIhzMUHqriinpEzT
	4GaAWWgGbpJraxFZMiTuJhDBopiw+E8OHM8o4bkqyzC4Mn3IySq8ZXkQXoX5UOQhDCzi49JzQfT
	mc+X09eb/U9Ig3pD5lhVuyQ0bw8vtvoBrGleAnU4dOkrF3THM1XfhadMKiOXRmt5HOKWKJJBs/i
	nmnN7WkedfEFPn5zFnK6Pwz4ycZe1/cavJwjs6IXBl57d6+3KoQmfMnBxaRkfwtLlCM6xw7n5Rp
	TuHnlgdQcZ5MYIMXab8q030Mw8qR0e5pUR/FzXv4sIBKfW/LErWri3vMtNR/B22pq7nS1zzEc3U
	8Jjf6J2peU0sPp3vR2d+DAZNt/4EhPzjiaZg/6mbWPnmJs0NYoi3aujqUp8jnNr5nMYh9Dvo+A/
	c2rpGMTzs5cs60kTVFPDqRZdYULDGsLFrpKuDmPfMoDe8JQlkfAo6NJ9/7UcMXFSdN+8uTXTDpk
	IhiNI8=
X-Received: by 2002:a05:6808:2206:b0:45c:9b88:d368 with SMTP id 5614622812f47-45c9d85901bmr5710863b6e.39.1768928624213;
        Tue, 20 Jan 2026 09:03:44 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45c9dff95a2sm7114917b6e.11.2026.01.20.09.03.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jan 2026 09:03:43 -0800 (PST)
Message-ID: <8c6a9114-82e9-416e-804b-ffaa7a679ab7@kernel.dk>
Date: Tue, 20 Jan 2026 10:03:42 -0700
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
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <d8d28435-2a89-4b25-925e-14fdb346839b@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
	TAGGED_FROM(0.00)[bounces-11842-lists,io-uring=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 776F24A965
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 1/20/26 5:05 AM, Pavel Begunkov wrote:
> On 1/20/26 07:05, Yuhao Jiang wrote:
>> Hi Jens,
>>
>> On Mon, Jan 19, 2026 at 5:40 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> On 1/19/26 4:34 PM, Yuhao Jiang wrote:
>>>> On Mon, Jan 19, 2026 at 11:03 AM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>
>>>>> On 1/19/26 12:10 AM, Yuhao Jiang wrote:
>>>>>> The trade-off is that memory accounting may be overestimated when
>>>>>> multiple buffers share compound pages, but this is safe and prevents
>>>>>> the security issue.
>>>>>
>>>>> I'd be worried that this would break existing setups. We obviously need
>>>>> to get the unmap accounting correct, but in terms of practicality, any
>>>>> user of registered buffers will have had to bump distro limits manually
>>>>> anyway, and in that case it's usually just set very high. Otherwise
>>>>> there's very little you can do with it.
>>>>>
>>>>> How about something else entirely - just track the accounted pages on
>>>>> the side. If we ref those, then we can ensure that if a huge page is
>>>>> accounted, it's only unaccounted when all existing "users" of it have
>>>>> gone away. That means if you drop parts of it, it'll remain accounted.
>>>>>
>>>>> Something totally untested like the below... Yes it's not a trivial
>>>>> amount of code, but it is actually fairly trivial code.
>>>>
>>>> Thanks, this approach makes sense. I'll send a v3 based on this.
>>>
>>> Great, thanks! I think the key is tracking this on the side, and then
>>> a ref to tell when it's safe to unaccount it. The rest is just
>>> implementation details.
>>>
>>> -- 
>>> Jens Axboe
>>>
>>
>> I've been implementing the xarray-based ref tracking approach for v3.
>> While working on it, I discovered an issue with buffer cloning.
>>
>> If ctx1 has two buffers sharing a huge page, ctx1->hpage_acct[page] = 2.
>> Clone to ctx2, now both have a refcount of 2. On cleanup both hit zero
>> and unaccount, so we double-unaccount and user->locked_vm goes negative.
>>
>> The per-context xarray can't coordinate across clones - each context
>> tracks its own refcount independently. I think we either need a global
>> xarray (shared across all contexts), or just go back to v2. What do
>> you think?
> 
> The Jens' diff is functionally equivalent to your v1 and has
> exactly same problems. Global tracking won't work well.

Why not? My thinking was that we just use xa_lock() for this, with
a global xarray. It's not like register+unregister is a high frequency
thing. And if they are, then we've got much bigger problems than the
single lock as the runtime complexity isn't ideal.

-- 
Jens Axboe


