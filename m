Return-Path: <io-uring+bounces-12678-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wGAiKsWStWnL2AAAu9opvQ
	(envelope-from <io-uring+bounces-12678-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 14 Mar 2026 17:54:29 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FE7F28DF9D
	for <lists+io-uring@lfdr.de>; Sat, 14 Mar 2026 17:54:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 4F03B300809A
	for <lists+io-uring@lfdr.de>; Sat, 14 Mar 2026 16:54:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DB722F83A2;
	Sat, 14 Mar 2026 16:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="w8gKFBw+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C80B317155
	for <io-uring@vger.kernel.org>; Sat, 14 Mar 2026 16:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773507262; cv=none; b=PxZdE5Q4oGqUCarch0H/59isA9fkZUvQ89+f0vbAEl1LK3MP/KrbS8hcwsC82rdK5ysbpu2lMXxXILaonDZZiOPDJjWx4PdefVEvBFSVyBLbYT8zV82wduokOzWqZYpwsJqGe4VufBoz+Z5SefNM0jYYN6ZLTkZ9T9inbPsjhjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773507262; c=relaxed/simple;
	bh=b0WuRAZQPl8ssICxxMhSrAGzbuivYnlvB+Ia/wc35SI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=r1UfiA38XgCrAeJWqK2VPwgeGUWGvUtWhTSGimg7WiJKV5R+1dxRQbOZ+Pa10Aed0sDxRKMatjh8xyYZrbKyAIi1x/849bL9kQP6cNpPHzJi1WTeVvoxzj5xl1YomEDp8YD92wsM8Iqy6HS3w0k10S09JlB0uOK8A1OaIG9zYCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=w8gKFBw+; arc=none smtp.client-ip=209.85.160.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-4042905015cso2058027fac.0
        for <io-uring@vger.kernel.org>; Sat, 14 Mar 2026 09:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773507258; x=1774112058; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=K4Q2IftdZ/YgAqwlPIXor7LPiABMDkoe4/Jz8Of/72k=;
        b=w8gKFBw+dTfOOnAGxANE4rDfziKMT4sNctaOyDaRnEyeJPYLrJNvDvt9RR0BmJ9Gbw
         YgkLros8ODzeoEkl5+K/sOS7E5NVp8Ldmww7zqLIecC6WMeZdDGygArIhdh6VU21bGPr
         t3IwFY5AWSEjgYKZLWfrm05+/ItcQy0LLMSXHxCERpo+2Esi5RnS+5siJXRdmCmtchZz
         0chwsHAwjYBnAUAUUv7ByIz/4/1TDDK+gFjrfrEVWT3Vc3MOfjDd7+RhbaXRsBQjOCes
         REYC8/ZFQ+x0wzqQepy4AJKSkVBGeFlkCB/IeAtpU4ebcVfUeasVrvEpPiv1AVS/jHWM
         JUFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773507258; x=1774112058;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K4Q2IftdZ/YgAqwlPIXor7LPiABMDkoe4/Jz8Of/72k=;
        b=pX37f0dRu4IWMZNQukQz9SXUlysVWxR8gxgsPosG7KiSe5OuYFrz+0c98gWPJp81wU
         54xWJPZs3oVama6jrkkEtS/i+AR87bvD0BzyVB0ApjSKbcwEsyxicxUUYj/2YQ75IqZI
         Ps6Y0UCjBkGQSfXIWxPsOAUqZ2immLYEEoGgL0/A+XZH5i0kKo19iAd/FYXtLgwan4At
         TqlPEZTrSnjJaYaxkxQT4L/AFLblRDStBu87J7FVE1v/3UBapRpRPgIats83Ioe40aMk
         ObtWBuco14H1YjG95oHV3t3N/kDaApDvELTHHZl+prDqNc5wj6jXYQfoC5IfTA3Wbb2q
         gucg==
X-Forwarded-Encrypted: i=1; AJvYcCUGzUSqR6R3aXY2X9iC3U4KzyjaWPzSjlwAMktBlPptQhyoZIwUruHMwTLETeK92iOA+c4S1i82AQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwWIQuaT6rGtUHej1sUWkFf8Joa37mU/965WRzYS6vVBWu1ALrV
	f+57rjkxJIFZCoxgf7VeTVlA52i5Avm4HB/zLBjltB1Rrind57NqoHaPQTry8c7ixxk=
X-Gm-Gg: ATEYQzy5v3j0a6PbbLp2RK2IQTW0BLYVPwOH6R+EYt3qoW7VtacTRpZxn3IlqEC83vy
	rynHzv3yjOHby7EpKEbNBul8IeViDvMciUEQgDd51M9EVDXXcuisL3RcBF9N/KRPF/hq0uVPidK
	umF7FVg7ndQSeBLJAt3A3nU/A6Ebine6OHga7Z+fxJE+O1Wcdba39Ppl9OkkgTJVJKqPs3EpMfN
	I/jqgQ5uc3qpMSt4/cj93w1s4yjKs4V2wyoX4g7VEYAiZV2KIAGFJTb5grZ10HxNRnDu1gs3Vwh
	oFA/uafNvwZC0lNUwDX4Xq1nORlpTQwbtJDfAQISizUsdPdyuE66K/1YHmZj8y/BGZni6sXmBW0
	eio+gTwCujOLTf6t1f1Jp2gtC9fgZkUNxEizx0BNBbqJKRqR3sI5M2aLnQdiKZa9mAocw06MaTl
	zH623+pplguwrT0tPbwdtoNyaOn9miEn/NE6LIidJBl+oYCZtbycGJlI4HsDfyLJjLtEZJBaw0m
	Co1ET9tyA==
X-Received: by 2002:a05:6871:3591:b0:417:5a8c:feba with SMTP id 586e51a60fabf-417b9243fafmr4117961fac.12.1773507257919;
        Sat, 14 Mar 2026 09:54:17 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4177e6c7885sm10652627fac.17.2026.03.14.09.54.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Mar 2026 09:54:16 -0700 (PDT)
Message-ID: <873d56d8-6c1c-447f-ae70-870417c6de5a@kernel.dk>
Date: Sat, 14 Mar 2026 10:54:15 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/2] io_uring: add IPC channel infrastructure
To: Daniel Hodges <git@danielhodges.dev>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260313130739.23265-1-git@danielhodges.dev>
 <20260314135053.3334-1-git@danielhodges.dev>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260314135053.3334-1-git@danielhodges.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	TAGGED_FROM(0.00)[bounces-12678-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCPT_COUNT_THREE(0.00)[3];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,kernel.dk:mid]
X-Rspamd-Queue-Id: 8FE7F28DF9D
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/14/26 7:50 AM, Daniel Hodges wrote:
> On Thu, Mar 13, 2026 at 01:07:37PM +0000, Daniel Hodges wrote:
>> Performance (virtme-ng VM, single-socket, msg_size sweep 64B-32KB):
>>
>>   Point-to-point latency (64B-32KB messages):
>>     io_uring unicast: 597-3,185 ns/msg (within 1.5-2.5x of pipe for small msgs)
> 
> Benchmark sources used to generate the numbers in the cover letter:
> 
>   io_uring IPC modes (broadcast, multicast, unicast):
>     https://gist.github.com/hodgesds/fbcd8bb8497bc0ec2bf1f95244a984fe#file-io_uring_ipc_bench-c
> 
>   IPC comparison (pipes, unix sockets, shm+eventfd):
>     https://gist.github.com/hodgesds/fbcd8bb8497bc0ec2bf1f95244a984fe#file-ipc_comparison_bench-c

Thanks for sending these, was going to ask you about them. I'll take a
look at your patches Monday.

-- 
Jens Axboe

