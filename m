Return-Path: <io-uring+bounces-12707-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yHeQL1KCuGltfAEAu9opvQ
	(envelope-from <io-uring+bounces-12707-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 23:21:06 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 252B22A1684
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 23:21:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F3F94309BEA8
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 22:17:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A687369239;
	Mon, 16 Mar 2026 22:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="NjtKflbg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0795336492C
	for <io-uring@vger.kernel.org>; Mon, 16 Mar 2026 22:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773699429; cv=none; b=qfSczmAlHqWQrCbQ50sogaAOvKxbTsqKNHcoLHjh385BEsDjhQPAB8TpoDAgsbDO/nUaSpAYb1c+PJkzbM+BVP3c7GNVmPpJfjIAzbqOKcrbhxJ64muF/57C2qWNY3tINT8CT3fgHrcGwGWEF6gCAA+us3aY7Vod4JG8qDN84UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773699429; c=relaxed/simple;
	bh=enCKl4JoDRs3oDPtdd9EAc4YeO4w4T0MndBJ8MrjBv0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UC+y3RC4gG+iwni7YFMUchF4kRI/Uy43Yu2+oMPLijGY0Ew7Sascm9vnmdYuyf/s7uOVLJJpy4ZlZGJH/Shnv/w/UfID2U86W1QxUTCWKsQXLOeLsWtFAUIuGvsD+4gm5t7FnX7jHQrq2kT09J43+z5MFom+HKuH4gHoUWyWY5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=NjtKflbg; arc=none smtp.client-ip=209.85.160.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-40438e0cba6so3209544fac.1
        for <io-uring@vger.kernel.org>; Mon, 16 Mar 2026 15:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773699427; x=1774304227; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=a6fuuEZ7EcJ7R7+49HTEzTakwBpU5KjCOPwarkE0KwI=;
        b=NjtKflbgqTGUNgAZaLe0bI5WxIqTNirZZJNCCsMEeHql+JKy0PTrKROfqgIpK/xA7h
         upES4BflY3kUUgiaZsQKB2OLBWBZE+Pm/c/3KXNXoyEubu0QqG9gIZ6wX56EX7FfNwqZ
         2ZpcQ19R/w2Xm5qCNQnBaH3rx8R1WSyDqyqC7CsEGMWhoNi8Ds7T3p1pBhm8VTVcNSZY
         zIbVA7fC8QDzDNynlic5ns+OTsQwC66/uVAq0NlwmzhUUC0TQh1KVZHzV/Buq7SMfzqZ
         aDjss0bj+AcYUkUxbCoDcKTKUAwf0nYEoLnobNWy8hHBumqvCVtN4C2zw0RcIgm5uVdm
         +H1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773699427; x=1774304227;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a6fuuEZ7EcJ7R7+49HTEzTakwBpU5KjCOPwarkE0KwI=;
        b=TnWHf4qbbQgbJn6PLBFLs+GN2H3W1Y9zuMM9v0dt64aSkTjrgDaeu8TRXIYv6WDxlp
         KU7XDG3TrIEUJzPZL+dcWXCz7Mkv4p4TFh5ctHG0gInfbuhwC4nm0ijNMIwFR2ye3qsZ
         EqB+/wuRTj/iWDbocu8Y4cn9siM26aPs7XV+4vY0d4nOf4ncbi45RmHG/B5ANIH80EGj
         H1Qvlt3HMH8lpMwBjwsqcM7iBmkI4+XlGj3+hQPzYL9V2hKtn3Fj5hsH7yk02TeeHk/y
         NxffPs28B+jXAKYTtnO0ABQwHM+Vufb6Fqh5X5PMGDXlKiblaOJRcbuk5yz/Be28rWV7
         V7Mg==
X-Forwarded-Encrypted: i=1; AJvYcCVZpsX485KOX9tNd8l6Hw/TAyQ4HYLS5EikTyhnkk/svF2fAu8C62mKBiILyZ9R+G+5gjqNXMAxcQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+Iv+ALK9AHIL+C67Zz3rQPXte7rnFIfsmBiOwRZcVOc4BwS1h
	NqNFe88yxwSgNsC+sJQUv4goDE4kO9hO+3YJ973TlIeX1qn4KVxeR3c+UwmxngITrdJQh8LPz0w
	CWyUClew=
X-Gm-Gg: ATEYQzxFWWHan3TMoitPY8wXG7Cll2MG4WzrBG8Wha6JCrvaxOQVNzZXHV6SUqf6UlP
	2YlGLsdRs+rEkjEvPauc6z6p95ESnCKqcK5kXleAKBK2kBeK4lFu9P5t8mO2fgDyJTSbL8jCvTx
	TzZJoWb8dlZ+MFWhnTFoEhLBCNmw4QsmRQTNLX0g6UyRF521mE09RnsMCPrH+fbtBH1TGsnziWq
	UtUvnJoBaentFW+qOz+HoclhaFyZKfmKMLMK0JoXQLqL1hrDGmMebVyZn94FJYD69xWNI+AMqCk
	KtKLRGIT8aDPYbZB9+kfy9j5pZspGLmb8SbQho3ybrXlaznf4SMg1jpUfijsMDnqHkK8hRrhZoh
	+YhKUPnVk2o7hfHMwFiC+/xF6XsY/lzO/7fQx8fL+4kDbVnWQ2k7LUyoUV0yO1R1ntEDzuPcQIk
	gb8//Ky0fJzUltj+kQN2zFeksABcrvnMZimPN8VM4amA2sG0KicZUSSAAlKf9fSXRw5Z7pda/JJ
	bW1Voi6rQ==
X-Received: by 2002:a05:6871:a84f:b0:40e:f9c9:ad40 with SMTP id 586e51a60fabf-417b902f16cmr7789786fac.10.1773699426861;
        Mon, 16 Mar 2026 15:17:06 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-417a2372b13sm14336484fac.10.2026.03.16.15.17.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Mar 2026 15:17:06 -0700 (PDT)
Message-ID: <d6e64251-2025-438c-92d6-71b44927b437@kernel.dk>
Date: Mon, 16 Mar 2026 16:17:05 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/2] io_uring: add IPC channel infrastructure
To: Daniel Hodges <daniel@danielhodges.dev>
Cc: Daniel Hodges <git@danielhodges.dev>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260313130739.23265-1-git@danielhodges.dev>
 <20260314135053.3334-1-git@danielhodges.dev>
 <873d56d8-6c1c-447f-ae70-870417c6de5a@kernel.dk>
 <wmy46klrmmxuspo4xttbz2kqzbtopavlsvxutjqxioqsihp7x2@n3uiq6hr6gjr>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <wmy46klrmmxuspo4xttbz2kqzbtopavlsvxutjqxioqsihp7x2@n3uiq6hr6gjr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	TAGGED_FROM(0.00)[bounces-12707-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 252B22A1684
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/16/26 6:49 AM, Daniel Hodges wrote:
> On Sat, Mar 14, 2026 at 10:54:15AM -0600, Jens Axboe wrote:
>> On 3/14/26 7:50 AM, Daniel Hodges wrote:
>>> On Thu, Mar 13, 2026 at 01:07:37PM +0000, Daniel Hodges wrote:
>>>> Performance (virtme-ng VM, single-socket, msg_size sweep 64B-32KB):
>>>>
>>>>   Point-to-point latency (64B-32KB messages):
>>>>     io_uring unicast: 597-3,185 ns/msg (within 1.5-2.5x of pipe for small msgs)
>>>
>>> Benchmark sources used to generate the numbers in the cover letter:
>>>
>>>   io_uring IPC modes (broadcast, multicast, unicast):
>>>     https://gist.github.com/hodgesds/fbcd8bb8497bc0ec2bf1f95244a984fe#file-io_uring_ipc_bench-c
>>>
>>>   IPC comparison (pipes, unix sockets, shm+eventfd):
>>>     https://gist.github.com/hodgesds/fbcd8bb8497bc0ec2bf1f95244a984fe#file-ipc_comparison_bench-c
>>
>> Thanks for sending these, was going to ask you about them. I'll take a
>> look at your patches Monday.
>>
>> -- 
>> Jens Axboe
> 
> No rush, thanks for taking the time!

I took a look - and I think it's quite apparent that it's a AI vibe
coded patch. Hence my first question is, do you have a specific use case
in mind? Or phrased differently, was this done for a specific use case
you have and want to pursue, or was it more of a "let's see if we can do
this and what it'd look like" kind of thing?

I have a lot of comments on the patch itself, but let's establish the
motivation here first.

-- 
Jens Axboe

