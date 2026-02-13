Return-Path: <io-uring+bounces-12203-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UA+NLF6Tj2mTRgEAu9opvQ
	(envelope-from <io-uring+bounces-12203-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 13 Feb 2026 22:10:54 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 050CD139900
	for <lists+io-uring@lfdr.de>; Fri, 13 Feb 2026 22:10:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AFF163026C27
	for <lists+io-uring@lfdr.de>; Fri, 13 Feb 2026 21:10:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3ABA626E6FA;
	Fri, 13 Feb 2026 21:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="wAe7NIGH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B2B26A1B9
	for <io-uring@vger.kernel.org>; Fri, 13 Feb 2026 21:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771017052; cv=none; b=gtbrCOtpAcwwhCK4k69WmZAc41zIsre9rlfsZDKE/WzAXIawhlAozGMNVs6Ste8aRb89txB6hVbB2Ovt8MWr2NmcD3KbN8eGN3Na/c7iTdFTvrhSdozpGBv/Hkw+9VAdSaNi3Vn6rCcTUigcaH/SyyXnrIv4KaBLkN7PiDzs08M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771017052; c=relaxed/simple;
	bh=HmEfdsjzVIHETI47D+JEYRayYU5MK87avPS77ilaDGg=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=jPAE/GL+S2eYCwNk83JlLn/XzDyG/S4Fm32ZO1ujR6dUacr/dDOFglXv4/vkiT0+mcC9dikgxm3FchxyNofsQEIs+3GjPAxbnblIlLROdaFPtMgvDl1zGOP55rLxKrJplAVTMIEStMqWe0f82TguO16WzOHN4JzTY9/ysTrDbrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=wAe7NIGH; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7d4c9537f90so418002a34.0
        for <io-uring@vger.kernel.org>; Fri, 13 Feb 2026 13:10:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1771017049; x=1771621849; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pGkCwWWp/FPqK28ijtGke74sI3QcTgk3m1OKgHdqNm4=;
        b=wAe7NIGHoclNkQnEcfAtl0r4e+vvKrapTqSL5TALMPlsDrhmL6mLGkjV9MgMwpcP+3
         2laqVmuPmCyTbGs8W5cyml7i3u7YiafuryuC8t8JKbNyzRFPLJxTkEn7UE3/AwtHCX0m
         bFJpROh2wmCoJfsOk6UMVGvMBxB5UtMn0EucFu3Sy/FTj0yuiZykSnuNcSq0j+jn93mG
         iN+k1lLLJGrtSg7Bvx+/rJ+akiVOcnpijeBZQzjwwq5yBfoNnmYKxFw6NRCDcpLwLm0+
         EoFTNvEn3au2og73/9OVrWXsMva0IvX9wKivFFkvA3h0YMIuvGZ12zrMVq2pr1dxAbV4
         UyOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771017049; x=1771621849;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pGkCwWWp/FPqK28ijtGke74sI3QcTgk3m1OKgHdqNm4=;
        b=HZcZOvjWNgfL4HEzELgV07N56EX1BQcGiFFPxf7YpPp9L6lhtfYxlZsV4X39yM1Jph
         FnkAcOCQMEg0elyj+iChTpyLEu8pVJK7w4mWT5reXabWr15qmwJl0afsYskooEOtPx45
         HL5J1tZB5IsZoJ+yTvrECQ3PRTvFfmCy8brvaHnm4a1hZZFfEP2mfX+2neZaNSDFGfw1
         0JjXP9mT76yClxT9G/vEj81i5Ql98twqjpsRKycQEDWY8mej3U4Htj6wQq6XMr7BbZhl
         M8TZVFP+yz9MvMuHIk5fTNtIWakKpbPzRjYdjdenDlYSBpG60dIYCWO3oBrNZc5DKyge
         3V1w==
X-Gm-Message-State: AOJu0YxFzDQlAjtcgvOl5CTZ3VnahrvWAj6RwVQ6T71A3fStMy6B0yf5
	hDJUVWR0ceUncoIT3FDkeCOn8uLkLVcFf3MDaJXzUNbgq9gDpfFm+4eEs+j/MqMcHPf4rK3aDB4
	Id+Q19B8=
X-Gm-Gg: AZuq6aIW/b4NJeKPQovwdvBzuJqo+zTvslxdhHzBHk7orIoXCejkvAhwgrrsWcHrgNd
	cwzk2k5mR06fEK+HUB+5T3HwyLEiz2zEHLJJXarP64DoZqUx22VDkuN5KtjzxXHnL/7i/NCKrjg
	yi2/to1OrDUlJxATpU9Nc5O4JSq1ZbUzxKWoafbX0KOdsqKUOTxy5Ir4a+kZhq5QgMvSxjOSTiO
	0nb0B00DnIO8HwAO9M2xF8937/RF3Yp0LtTcOr2f3O/yk3z0zRRsUqJYoBPNIgdSgHbx6ALLGMz
	TVg3BsPwqIQCA/U7VjA9x5e1q1j0SyDhbMuFhwvNUNLosMjHl76gKZebxt8aMcpk5NDvBBu0J7D
	bzE6viM7sXJyDS0omMjjEehqumaJ9u5IwCEqiZOn2mq2hXo8qpzT4+dU6Fvqj8KG44ZhUAFgtzo
	aUTwLq8n0B0iKKSTaBUVX3SXLP1Zit6+VSZfTeWEF2y0OTmuC0KCA8ovR0I8BEAwWhELXweX3F2
	NX6DvNq
X-Received: by 2002:a05:6830:3152:b0:7d4:4d52:efcc with SMTP id 46e09a7af769-7d4c4a62bf8mr2142190a34.14.1771017048759;
        Fri, 13 Feb 2026 13:10:48 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d4a76f9483sm7346026a34.20.2026.02.13.13.10.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Feb 2026 13:10:48 -0800 (PST)
Message-ID: <00bc96d8-c304-412c-b176-1b30ff0847af@kernel.dk>
Date: Fri, 13 Feb 2026 14:10:47 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing] src/Makefile: Fix missing bpf_filter.h
 installation
From: Jens Axboe <axboe@kernel.dk>
To: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc: io-uring Mailing List <io-uring@vger.kernel.org>,
 GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
References: <20260213210548.851503-1-ammarfaizi2@gnuweeb.org>
 <177101682427.298850.12069195780298295812.b4-ty@kernel.dk>
Content-Language: en-US
In-Reply-To: <177101682427.298850.12069195780298295812.b4-ty@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12203-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCPT_COUNT_THREE(0.00)[3];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel-dk.20230601.gappssmtp.com:dkim,m2max:email]
X-Rspamd-Queue-Id: 050CD139900
X-Rspamd-Action: no action

On 2/13/26 2:07 PM, Jens Axboe wrote:
> 
> On Sat, 14 Feb 2026 04:05:48 +0700, Ammar Faizi wrote:
>> After a "make install" command, liburing.h fails to compile because
>> bpf_filter.h is not copied to the destination include directory:
>>
>>     In file included from .github/workflows/test_build.c:1:
>>     /usr/include/liburing.h:21:10: fatal error: liburing/io_uring/bpf_filter.h: No such file or directory
>>     21 | #include "liburing/io_uring/bpf_filter.h"
>>         |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>     compilation terminated.
>>
>> [...]
> 
> Applied, thanks!
> 
> [1/1] src/Makefile: Fix missing bpf_filter.h installation
>       commit: 364a7b561fa13cffdd7771978dc5509ec4d9d7f9

Thanks, I missed that!

BTW, for the future, for:

Fixes: 46b5c4d66232dcadd0f46c875e6fabce3b3dea85 ("src/include/liburing.h: add bpf_filter.h header")

shorten the sha to 12 chars, we don't need the full sha.

For your ~/.gitconfig:

[core]
	abbrev = 12
[pretty]
	fixes = Fixes: %h (\"%s\")
[alias]
	fixes = log -1 --format=fixes

and then you can just do:

axboe@m2max ~/gi/liburing (master)> git fixes 46b5c4d66232dcadd0f46c875e6fabce3b3dea85
Fixes: 46b5c4d66232 ("src/include/liburing.h: add bpf_filter.h header")

and it gives you the right format.

-- 
Jens Axboe

