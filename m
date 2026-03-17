Return-Path: <io-uring+bounces-12719-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eL8CIC+suGkdhgEAu9opvQ
	(envelope-from <io-uring+bounces-12719-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 02:19:43 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DE91C2A2810
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 02:19:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7F988301B713
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 01:18:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57616311587;
	Tue, 17 Mar 2026 01:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ONUGHa/O"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A9C2D8798
	for <io-uring@vger.kernel.org>; Tue, 17 Mar 2026 01:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773710301; cv=none; b=rANB+mfuHHNxETRqjad5KYeU+W2EvoFJ6riLnWKajbC0WfoBtdNmomFBLAQ2wHlIr+UUxqgxFpTtm6MRyNIX6ZgAgNoJcyIhgLT0zCo52YKKK7vv36WZi1429Zkn3LwxthdOEwyWRdO12L80AXeNqVWiDqxZFVqWeHV0Y7XYNtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773710301; c=relaxed/simple;
	bh=0FjZpOv4R0PBxe2gd36K0mI3jJpqMD7qbaICMz7hyU0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VRoSlNV0/N7UjH0nOezYs5cUOtORsH0Kts140ZHsQD2kVEYvg1fpPJsOJ1WErMSE8CvfUmsL1YxOvrIvTlIfbkTiDLYpTb/yJJoLFFIeUcyIsfss2OnP6OtFedvB36t1UsaKEihIqERopim9I2XIUee3idvpcBroRSwlt9NGzGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ONUGHa/O; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-467161c4a1cso1840767b6e.3
        for <io-uring@vger.kernel.org>; Mon, 16 Mar 2026 18:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773710297; x=1774315097; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=c5OTWCqR5cLs0VCjzLx8iHeEjL5OYgtyCP7y6MhZm1Y=;
        b=ONUGHa/ONrme3VI4QFLDfJoUV5OR9x8WxQfZ/mSMD9EwU+AbaJJNGRydqHjMwq3W/u
         d5w6a+d2oquctAT943LE37so8+P4R2Hshmb80zyBGBtTbHPaSn6nI0YRnsZXpcZ9I+3j
         OqA7wXv5l+1vlW4I9iDZ2a1dH08vpUYcb6VhPE+VzH/OMZJiFW1ntYIHGJd6fXVSpfjL
         xhJiUSfMrPL9W55cY/SpAOT92yaOw3oo61+NeWhSHeQsoqh+/R/ekKd0wd9I2hg2w3zG
         9VzYXVG7HpKLYWjGmtsA5C6UZFXUhq6HcejY8f0lSHLGHSlw4KJqdWW4zIu9gbnq0u9T
         HAcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773710297; x=1774315097;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c5OTWCqR5cLs0VCjzLx8iHeEjL5OYgtyCP7y6MhZm1Y=;
        b=GYi3njsCZg3nto9nNkIwZWxCwt6I3Ksh9RRQ0sA9Be0hzKOZfwTIPtUikxfE/+YT8H
         A4Ye3ZBkVXXOyTFbqZzI94xK3Yz7jU4+2/7fDaLYl6SA6CY9iOmd/F6paD0VHpA5rjnk
         WI0whWwdRhGSj3v/LkvS+rSYYLt7ucuh3DgyxrQsntLbAC+dJVhMTPaVQWoMh1qKCPjC
         FDUHNY20/7fMnRCjdS8MTzBG0G5gVm9y6hC6EcFfKzbK9U3uM+iUBKvvNB5mNq47LV7D
         RUpFqsNuJUL9jOOfIG0gQ4p0W31UqOD6Bxrcu0PVlOCaC5hCVPQkcQUf4xvHTM5U0vxx
         F46A==
X-Forwarded-Encrypted: i=1; AJvYcCVVqnbTmmT/eWbZNO5UVppyJehmdejZjScZt8HQANjHhb97pZxo9FvCWNfNyc+IOP3xbHpkKZHbmg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyyhIAmTZBf0Ace0w3qYu+Sl5fEyca/SI1GOsTdAVnPKlFhhkRn
	bCrjoP4psz7mayY7tTdFErDikNIsenEqyeVppnvDWYIlNQRl4MGDqzB/JVEyrByI3h+O9ATXDPD
	OX9tgMj8=
X-Gm-Gg: ATEYQzwTcr3rwxg4pTEETsGgiwodtgwAhb7aOupRH3Ly1v4vpWuAwU9n8T/cCOJdVdZ
	4u2RfnEGk0V30C5g4psKT1QH08KHnQiRL9X8NgdaaQnv8lO9lSQRObUpjHi8i9zO4KhjoJ/vwsE
	KKF5tLrAtpN0mzo8p5pizQYh5jGc/cP/cstMTfkmUurtqRo82idy3TPhOlZh19NLlZnPqTww/zL
	L7iGWbPDJYlZD75BpKsWHcts66LSea01SnUMl3v8GUfiCVbf3ZrqCqu3BHHXWDKg+NfV1J3IOCu
	HMPATmJ+Kpax0s4bm7+M8aCwLraOXOdRqYCDfZo620R2ZutwydFJeqvWZXhjt/asIv48zm/VX8g
	pmf4+1RszEoO/RCqhdQ9WWy0FHgRoLApp0n07C07z0TOurqsT2zsbOIYlDknZBZMmdnvCAdAmkX
	alPbEHmOIlS5FZgnmlfldljs0GmU4pdh2tBG5Qze3+Ef2dXYIvVnNAXjsxFZXPuRLpJ6NWSFAuR
	5AQtJIOIA==
X-Received: by 2002:a05:6808:15a2:b0:467:1c6b:ee14 with SMTP id 5614622812f47-46757550237mr8106450b6e.33.1773710297147;
        Mon, 16 Mar 2026 18:18:17 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-467342c0382sm10993569b6e.10.2026.03.16.18.18.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Mar 2026 18:18:16 -0700 (PDT)
Message-ID: <54f95b7a-45de-4353-9308-12cd64dbe894@kernel.dk>
Date: Mon, 16 Mar 2026 19:18:15 -0600
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
 <d6e64251-2025-438c-92d6-71b44927b437@kernel.dk>
 <hzb3i37w6isn7gx7jqc223fmznxxjmqvlxke2rdb3lb43htifq@j45xx427nppc>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <hzb3i37w6isn7gx7jqc223fmznxxjmqvlxke2rdb3lb43htifq@j45xx427nppc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	TAGGED_FROM(0.00)[bounces-12719-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCPT_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:mid,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: DE91C2A2810
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/16/26 5:13 PM, Daniel Hodges wrote:
> On Mon, Mar 16, 2026 at 04:17:05PM -0600, Jens Axboe wrote:
>> On 3/16/26 6:49 AM, Daniel Hodges wrote:
>>> On Sat, Mar 14, 2026 at 10:54:15AM -0600, Jens Axboe wrote:
>>>> On 3/14/26 7:50 AM, Daniel Hodges wrote:
>>>>> On Thu, Mar 13, 2026 at 01:07:37PM +0000, Daniel Hodges wrote:
>>>>>> Performance (virtme-ng VM, single-socket, msg_size sweep 64B-32KB):
>>>>>>
>>>>>>   Point-to-point latency (64B-32KB messages):
>>>>>>     io_uring unicast: 597-3,185 ns/msg (within 1.5-2.5x of pipe for small msgs)
>>>>>
>>>>> Benchmark sources used to generate the numbers in the cover letter:
>>>>>
>>>>>   io_uring IPC modes (broadcast, multicast, unicast):
>>>>>     https://gist.github.com/hodgesds/fbcd8bb8497bc0ec2bf1f95244a984fe#file-io_uring_ipc_bench-c
>>>>>
>>>>>   IPC comparison (pipes, unix sockets, shm+eventfd):
>>>>>     https://gist.github.com/hodgesds/fbcd8bb8497bc0ec2bf1f95244a984fe#file-ipc_comparison_bench-c
>>>>
>>>> Thanks for sending these, was going to ask you about them. I'll take a
>>>> look at your patches Monday.
>>>>
>>>> -- 
>>>> Jens Axboe
>>>
>>> No rush, thanks for taking the time!
>>
>> I took a look - and I think it's quite apparent that it's a AI vibe
>> coded patch. Hence my first question is, do you have a specific use case
>> in mind? Or phrased differently, was this done for a specific use case
>> you have and want to pursue, or was it more of a "let's see if we can do
>> this and what it'd look like" kind of thing?
>>
>> I have a lot of comments on the patch itself, but let's establish the
>> motivation here first.
>>
>> -- 
>> Jens Axboe
> 
> I've been helping Alexandre prototype a D-Bus broker replacement that
> scales better on large machines. Here's some docs/benchmarks:
> https://github.com/fiorix/sbus/blob/main/sbus-broker/docs/analysis.md
> 
> The idea for this RFC by trying to come up with a design if D-Bus was to
> be built from the ground so that it could scale on large machines. D-Bus
> was built because the kernel never really had a broadcast/multicast
> solution for IPC and kdbus demonstrated that moving dbus into the kernel
> wasn't viable either. So that's where I sort of landed on the idea of
> what if io_uring could be used for this type of IPC.
> 
> There isn't a working io_uring backed D-Bus implementation yet as
> it would require features that aren't in this patch such a handling
> credentials etc. I fully acknowledge I had AI help in working on this,
> but if this idea make sense I would appreciate some human direction. If
> it seems like it could be feasible from your pespective I would like to
> try to give it a proper attempt. Thanks!

OK, thanks for the explanation! I do think it makes sense to do, and
starting with the basic mechanism first makes sense. I haven't read your
link yet, but I suppose that had details on what else would be needed
feature wise on top of the base?

-- 
Jens Axboe

