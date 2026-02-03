Return-Path: <io-uring+bounces-12032-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AJ6WL9ECgmmYNgMAu9opvQ
	(envelope-from <io-uring+bounces-12032-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 03 Feb 2026 15:14:41 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 212EEDA714
	for <lists+io-uring@lfdr.de>; Tue, 03 Feb 2026 15:14:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0BDC33141987
	for <lists+io-uring@lfdr.de>; Tue,  3 Feb 2026 14:09:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 527093A4F5F;
	Tue,  3 Feb 2026 14:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="kyQpPd5y"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f65.google.com (mail-ot1-f65.google.com [209.85.210.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD4A3A1D0C
	for <io-uring@vger.kernel.org>; Tue,  3 Feb 2026 14:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770127787; cv=none; b=NlvZeLTCq2iXjFhXjKq9FiPfbHPwESHwkbuTKw65zBpLglv2xklMstOKIGoxOjzb/XFLUPF4FQlAuoa0lYvVOWFjXW3wYClgEoS0ZFopy/dwRPbgLuyfhypJRW4BTOxRMr9XVRHANdyjDRwHtNdBV2OHY5umxwdYnLzWqwmGZI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770127787; c=relaxed/simple;
	bh=zIFBmAHAM/Irb9G0R8j7pSNsL+gtf2im3LHa47NKC7c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YVxF+IuSB+5ziRbGCvLvrCXQbupy6LJqXaE0u6idQNw8DX7W7OjPwhC63aaWLZnwGl6YOnovMwc6HyS7iRF7azLe1jIMdju92v4e28BY4eispipOcci+Nhj4GlIaUkS7cJ8Q/HgFsheOF5iWsD8ekV6xium4mylwTAzQ6iT18/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=kyQpPd5y; arc=none smtp.client-ip=209.85.210.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f65.google.com with SMTP id 46e09a7af769-7d1851d85daso2409221a34.1
        for <io-uring@vger.kernel.org>; Tue, 03 Feb 2026 06:09:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1770127784; x=1770732584; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BOwWE96OyTi1XljgPB9IwZgSnzcIgyGl9oDHpcAgOM4=;
        b=kyQpPd5yxkIQng5Yeg52/d02H61Ic9n89ClG62rbkKNAYJKW8SIx46sFoZUEXNyfTH
         O8fhE83s2bvOh19UPqgLYz9Jah9SCG18SS7ZHUHWB2DEPAWEr7FhyhlfYrnALgTyzDr/
         G2F+Gcp++Gain0wAPTpfw0QRJ+583QjGH6pGp9N/BUyNJmtf7djD6qKg8EToNL6hoX42
         cy4qrbrU627Q/8GLesu3/cMDROzAWafgI1+0FZiHkZNj+xDCoXhi3VznZOGgKHxZZ35T
         53r72yl8VsUS189NxPzKAESR5Q5UrRnCe+T9ITk+J4DAMFzc0D/ijIlQ0F+PuPE5Z8Xx
         AqAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770127784; x=1770732584;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BOwWE96OyTi1XljgPB9IwZgSnzcIgyGl9oDHpcAgOM4=;
        b=nM1jFA9XM4GKWWARi8KgGziy4Yqrd4xiwYwDbWWIjW9zIC7mYyB548eq4cl72QZ3Tv
         5t4Mi5y1bAPs8X47112LCMtbjPicTjJHI6NLd5QNc76wk2XyBDDllmECUeJIArjZDk+X
         9C4uVMNvnUN0NsDTaw3BTWUH5UDQBZk5qekhPk+MxkI4NAeObgFHqNgD9X04HSbsER34
         ZGxXdc6p4fau8Q3KNVCTV1K42s8p5b1GO8+qUr2uFf7EPmpGmwGuqu2n0tXyeh1Py9nk
         7ZEik7mAwOMXcMYjq97cJGI4h4BxzYyR3YtOaRjRoqLgQCWod8MEB+gvO9HFssMPWw9P
         /+PA==
X-Forwarded-Encrypted: i=1; AJvYcCUeJHUHkOfBSyH3APidqUnwax0neUZ8cH9EDZJ/8PGnMngHmykU+LQUqmPPlGFaoY9qd9s1ob640A==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7gvDKMtyrWlx9JXJ63LvKMUKcmOnAfWpWydc4mEOV8lO08Ie6
	bU/79kuH9nFEmXzA51Xs1T2JnVN69mQLBuyugV7Oa1nMKfTEE14sXmnB6iBHvz89qo8=
X-Gm-Gg: AZuq6aIFhrFScRt2vQH5nW4pupnJkst6HVZTg57f0UEixUSGpyFZvMkl9hHhdwygGYN
	Ix/OiCmDzc8xqy5ViAY7OH2oDGxlW9ieaGyiJwlsuXCBd4WLCMnGK6yBLdIFlxhBPEvlcwwYhuC
	IXsk3zL3TIhYuK7AEhzj0jpTcqS+o3FfKr+vIzmKJxJRCmAubUbke33r5hvOsZZsj4SEmAp2Nd/
	GzbCB0fxFXXR18SicF0gelQOeuIRSNQ13L+LFpv16wXIqquwIPJcQuCS9JorZEz6YstyIfruOIz
	77GSb8U6cMGhz915OnRYCAkzrVDyJrCwOiFmrQLBJp0+VbZUeIQVJp5U8xUhLwE3PbpJbZXLTc5
	PZn17tiPKExGH6G6D7q/HBLYHLcKtvQ9auCs3eZoAxwocdMdZqPr7igS1ss7tP6X47yb3cC7H+c
	TWbRVaUq0Zd8oLW3TylALqa9fPJsgCTCYoubLLg6gJ5Ue71tXX+eBfpS7aBORmS1s5Bj015TMhH
	ye2tOil
X-Received: by 2002:a05:6830:358e:b0:7cf:d1b7:7b28 with SMTP id 46e09a7af769-7d1a5262f45mr8162612a34.4.1770127784126;
        Tue, 03 Feb 2026 06:09:44 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d2eb466648sm5422483a34.25.2026.02.03.06.09.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Feb 2026 06:09:43 -0800 (PST)
Message-ID: <0b9539f3-d30e-47ba-b577-8b65855a05a0@kernel.dk>
Date: Tue, 3 Feb 2026 07:09:42 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 0/2] io_uring/io-wq: let workers exit when unused
To: Li Chen <me@linux.beauty>
Cc: Pavel Begunkov <asml.silence@gmail.com>,
 io-uring <io-uring@vger.kernel.org>,
 linux-kernel <linux-kernel@vger.kernel.org>
References: <20260202143755.789114-1-me@linux.beauty>
 <17d76cc4-b186-4290-9eb4-412899c32880@kernel.dk>
 <19c20ef1e4d.70da0b662392423.5502964729064267874@linux.beauty>
 <147b6420-ad85-46b0-a8e6-3cb9265e4b15@kernel.dk>
 <19c22785df1.288e39fb101919.2611884700541801815@linux.beauty>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <19c22785df1.288e39fb101919.2611884700541801815@linux.beauty>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12032-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	TO_DN_ALL(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 212EEDA714
X-Rspamd-Action: no action

On 2/3/26 12:47 AM, Li Chen wrote:
> Hi Jens,
> 
> > If you still want a test, I'm happy to write it. Since you've already
>  > > tweaked/applied the v1 series, I can send the test as a standalone
>  > > follow-up patch (no v2).
>  > > 
>  > > If kselftest is preferred, I'll base it on the same CRIU-style workload:
>  > > spawn iou-wrk-* via io_uring, quiesce/close the last ring, and check the
>  > > worker exits within a short timeout.
>  > 
>  > That sounds like the right way to do the test. Preferably a liburing
>  > test/ case would be better, we don't do a lot of in-kernel selftests so
>  > far. But liburing has everything.
> 
> Thanks for your suggestion. I just adapted my local test program to
> liburing and posted the liburing PR here:
> https://github.com/axboe/liburing/pull/1529

Thanks, merged!

-- 
Jens Axboe

