Return-Path: <io-uring+bounces-11836-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wF2eOahbcGm8XgAAu9opvQ
	(envelope-from <io-uring+bounces-11836-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 21 Jan 2026 05:52:56 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CC2D513BA
	for <lists+io-uring@lfdr.de>; Wed, 21 Jan 2026 05:52:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 12DC3862760
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 12:07:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F7CE38BDD4;
	Tue, 20 Jan 2026 12:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e5hRf789"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com [209.85.128.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B9A427A0A
	for <io-uring@vger.kernel.org>; Tue, 20 Jan 2026 12:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768910716; cv=none; b=DAvwDKb2L0YlzbcUoDeWrXhYElmyhgXJoIpoVXbvcChboKOHbhM/mvVuoKK++60yAgC43nG+KsXa8TwF0PVp33IyStHsNYvKDkmeb0uGlnEqdzGAfEwinDL8SBk2I2NVC9aqMDUWarSrvikW8eS8YFJOcw/olPtcPBPLMIftwPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768910716; c=relaxed/simple;
	bh=1SUJOIbcpKZ97vROXHZbc4uywvg5mICVVTFXnu+8N0E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m7/J+jdITVZNDlwRGOv8XRaPDpTXc5NKX3c93ijJ46K34g8tX7i3qR6stExn8TyfhCRRKDVC3PiS934KSZWy+HWKej/YV4IeF3lO4YVIjsqsU+swZ6jbS7c89DPI9474GyDnvr5nz3RpjV5/i7XfHxu3Rx5iaMB/SAw/teNi0+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e5hRf789; arc=none smtp.client-ip=209.85.128.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f67.google.com with SMTP id 5b1f17b1804b1-4801bbbdb4aso27005165e9.1
        for <io-uring@vger.kernel.org>; Tue, 20 Jan 2026 04:05:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768910713; x=1769515513; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JckE27aaTC/MenhzlCHYt+N31ilQSZiKPy2PxHLLEmg=;
        b=e5hRf789+sDFQRo4cko4z9oRXrlGElRU7lc3q4NIGtOKRke9YROX5TAjFeOGYG6zAW
         3afOnjx6LtmlHGG8SnjkSYi60DZlm+xWEtNPl5XHhbOigMUkNQXq9Vkjk2/KUM83xdJe
         Qr2vyCN7NhlYNZEXAyhadErhC5U7UxK8mu7qesPXXLphqQgmkfTwyKPcv0UgmLCtO3+w
         g+K5+owI/G78G9+Buz9UkqF9jdtxHHto+udzSPwkkLdMvZ/B4qq3NFxDUjuyQaQUStO9
         Qm1FFIHgeC/RgGVPEBVFXfQbTnr+LDxjUuqkJSa9bwCJKjns+s+IcSIgwoq0ffvymAIB
         DKoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768910713; x=1769515513;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JckE27aaTC/MenhzlCHYt+N31ilQSZiKPy2PxHLLEmg=;
        b=cd73ZvskDC0/I2aB9TH1PEd8tUv2RTFzjAvmDHGEX9LfPQp4JTQBcynMppfoGeSRNR
         xg9f8v1PhQDPQfyL/AZKRztX8BNYrieRBWqxVK2aS8ExvjjCLrt9C0JXgoceslau+Y4b
         rHJ4ccAqoJJ/v6cYwDFAVWD70C/lJ0N2u/ttetqspRxsywx60ghZxTvGMe8ei75KU+1D
         2nn92JP3nu/1+f0nwhJJr3s1eV7AmNOsFd+TiT9fKI1n54+qLObnc1KSClrPG9k7mqKM
         x6lHDv9lHkkhnJ8RdEIEzhS2mQl/bzwzeiOJyhS6xHFAZlLyvzWoqyXjUCThLPPhT91L
         3WBA==
X-Gm-Message-State: AOJu0YwD/CbZI480qEYyoVQsOaxla2avMjwomxddyqEOTt6puhkXXjyL
	tiHLEDkCSF5DfWV4KnIeNRhYnbpeT3Diwx3c2woSLnZsKrf92E8Aopx4
X-Gm-Gg: AY/fxX6TM8Vbask2F0IUES/+fwel9majR2fPi8j/2EztKzPcXWdrkq3recWhMtw6WKU
	i9zP7JoVMAQG7+6Fjy1+xyqKA6PD1hFyDHYcRwGoyX+JPjMVtkz6ynwVjtUVS4d6sJ2lFKUWgcm
	W7ooGaefEuE20q/aYjawGEXH+nFIaBpjEVfX0azQKv6UemJmzdARroD0/FGVuydr0xmR25SqYRL
	3/Ys5fVXRkqzlwtyLxVOEutBXkJkFU22yruvBP19IFJoZXIsHfI5MQ9dJ7K9e2bYGdHYfwUwZ3T
	bJcupiDQVu6KQh+T9605Z+f3h446PNHgCs8YGb1zXcn4ocpD5f59zSkPq2g5TAWI3llZzXZg0bx
	4HCetJwKlO9W4uPbGdbFUuln4i1zgrIoEx8VZWOzujL7j6aBbhHlBbPzMNZ61ZgkbvXtPc2j+E6
	htSnwxvsPrKpk9t538coTCaAxfxVOba9MFz23aeKxFTNTQ+zQ3IJpfT0AQpn6U5wPoX5isYmj8F
	32fKSA02DRHiRXwhcqqYlsfgFCbUH7lz75BDfxEWgAmDNEH7YZnOBqGYnX8HkH7
X-Received: by 2002:a05:600c:8b6c:b0:46e:2815:8568 with SMTP id 5b1f17b1804b1-4801e66fcc5mr167787885e9.10.1768910712480;
        Tue, 20 Jan 2026 04:05:12 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47f4289b789sm302284295e9.1.2026.01.20.04.05.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jan 2026 04:05:11 -0800 (PST)
Message-ID: <d8d28435-2a89-4b25-925e-14fdb346839b@gmail.com>
Date: Tue, 20 Jan 2026 12:05:09 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring/rsrc: fix RLIMIT_MEMLOCK bypass by removing
 cross-buffer accounting
To: Yuhao Jiang <danisjiang@gmail.com>, Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260119071039.2113739-1-danisjiang@gmail.com>
 <bc2e8ec1-8809-4603-9519-788cfff2ae12@kernel.dk>
 <CAHYQsXTHfRKBuTDYWus9r5jDLO2WLBeopt4_bGH_vVm=0z7mWw@mail.gmail.com>
 <2919f3c5-2510-4e97-ab7f-c9eef1c76a69@kernel.dk>
 <CAHYQsXQK4nKu+fcni71__=V241RN=QxUHrvNQMQtPMzeL_z=BA@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHYQsXQK4nKu+fcni71__=V241RN=QxUHrvNQMQtPMzeL_z=BA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-11836-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,kernel.dk];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: 5CC2D513BA
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 1/20/26 07:05, Yuhao Jiang wrote:
> Hi Jens,
> 
> On Mon, Jan 19, 2026 at 5:40 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 1/19/26 4:34 PM, Yuhao Jiang wrote:
>>> On Mon, Jan 19, 2026 at 11:03 AM Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> On 1/19/26 12:10 AM, Yuhao Jiang wrote:
>>>>> The trade-off is that memory accounting may be overestimated when
>>>>> multiple buffers share compound pages, but this is safe and prevents
>>>>> the security issue.
>>>>
>>>> I'd be worried that this would break existing setups. We obviously need
>>>> to get the unmap accounting correct, but in terms of practicality, any
>>>> user of registered buffers will have had to bump distro limits manually
>>>> anyway, and in that case it's usually just set very high. Otherwise
>>>> there's very little you can do with it.
>>>>
>>>> How about something else entirely - just track the accounted pages on
>>>> the side. If we ref those, then we can ensure that if a huge page is
>>>> accounted, it's only unaccounted when all existing "users" of it have
>>>> gone away. That means if you drop parts of it, it'll remain accounted.
>>>>
>>>> Something totally untested like the below... Yes it's not a trivial
>>>> amount of code, but it is actually fairly trivial code.
>>>
>>> Thanks, this approach makes sense. I'll send a v3 based on this.
>>
>> Great, thanks! I think the key is tracking this on the side, and then
>> a ref to tell when it's safe to unaccount it. The rest is just
>> implementation details.
>>
>> --
>> Jens Axboe
>>
> 
> I've been implementing the xarray-based ref tracking approach for v3.
> While working on it, I discovered an issue with buffer cloning.
> 
> If ctx1 has two buffers sharing a huge page, ctx1->hpage_acct[page] = 2.
> Clone to ctx2, now both have a refcount of 2. On cleanup both hit zero
> and unaccount, so we double-unaccount and user->locked_vm goes negative.
> 
> The per-context xarray can't coordinate across clones - each context
> tracks its own refcount independently. I think we either need a global
> xarray (shared across all contexts), or just go back to v2. What do
> you think?

The Jens' diff is functionally equivalent to your v1 and has
exactly same problems. Global tracking won't work well. You can try
to double account clones, or wrap it all together with the xarray
into an object that you share b/w rings on clone. Just make sure
it's protected right.

-- 
Pavel Begunkov


