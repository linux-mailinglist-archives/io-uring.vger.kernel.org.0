Return-Path: <io-uring+bounces-13863-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id eP6eKH1SRGopswoAu9opvQ
	(envelope-from <io-uring+bounces-13863-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 01 Jul 2026 01:34:21 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B6706E8A7A
	for <lists+io-uring@lfdr.de>; Wed, 01 Jul 2026 01:34:20 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=krOBstf8;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13863-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c15:e001:75::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13863-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 7A9D5300F25E
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2026 23:34:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4F14262FD0;
	Tue, 30 Jun 2026 23:34:14 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E23199D8
	for <io-uring@vger.kernel.org>; Tue, 30 Jun 2026 23:34:12 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782862454; cv=none; b=cseL6EomEWS3dkhYRZNdlyfzRIjF+rErR8EijN+2JBKVSlXXJbrb6vFFc6fhMIHxisjPGYatGaYhunObquHTw08rco7BpI8OlYdSPBqAJSP4hswmkPdbjXwO25W/1WN/9iSZTbjIYkR4wGUKnUckiO4XrnVO5QniRJlcTYdCrek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782862454; c=relaxed/simple;
	bh=xJIEiQYY1BuUadpLctVjizr0+MN2AmeT6NKjP10+1xw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dtYyiNBPQ/1blsnoGn7Eil6pLycFsVon0ohfcGzBYfbUPLbStn2HDLfFvcSWsyFOwJ8cEBXJYYz4E8PT3jEMCH4D5N7yaOXivIL2ycR+SuXMHWai/DGDwRuSZYAi5oddCXoj+uLcV9IR60ec8uyy+OCUwF4XFizXwHPyqtYQ01U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=krOBstf8; arc=none smtp.client-ip=209.85.210.46
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7e9bb837fdbso39947a34.3
        for <io-uring@vger.kernel.org>; Tue, 30 Jun 2026 16:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1782862451; x=1783467251; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Lan+fZPCJ8OKHMbASPxt5rlkSbv61YWFNs56HNVNP9s=;
        b=krOBstf80vatnsVHr0Z5F0Kx5KnJ0aaee5hv1f18v7YcgdbU7pKAw/D1sc1vLiUV74
         RLTv4PX6zVJz6F4sKrS8RR1+vSqD9ZWSKe8if5RmGc71EHdUvUGmdaTAhG2Ma2H1GfXN
         8jkjjFJoX37wk2Bxx2L1ayFGX8oxOE2Byz3R+d8XHDaDWWHbbC0hMQZtbXGRO9nT9UFh
         2knaeHWVYMCWguGz27PuS/vs0s4KYx6XkfCoA0c0oN+Oo0tDjhW2j/yMynYJ0v2KhSAT
         EYMRIfOOUGSGuZ+/wlB5/D8GWy9xgnGWd1enkNAPipQXa7baCpMai5p7KTMF/jP60P6a
         CDMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782862451; x=1783467251;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Lan+fZPCJ8OKHMbASPxt5rlkSbv61YWFNs56HNVNP9s=;
        b=P+65OnPqOjQWTTWSpeLU1YrmWnVLg56wJijZLlO4njhWAmm8qEBWePzksKQYIXfg1n
         Ur63Dy+vvr6FzC2JqKMWdZ23OqwmIoWykptY6jCaEoA47kBBFdxJ3QVqlzz30IGZgYWD
         FZ+KdVaNIaTaEsClOhxKzgqXtRwR1NwbfNUaUGfddp7GS6/qOwrEwsEio3IT94lYdMyw
         DNuG4u0qmKwfLfCKQcv/44OUSaZeYYjxG580JVwDrd7bJJS1FGcJgeqBSsTqVLPAu783
         rmfQbOm8nsVP7y106ZHL3Ak4xt42ZaYklHws96TIssDVYwoPto0vghS9j8IUPEpfKoPc
         LNVw==
X-Forwarded-Encrypted: i=1; AFNElJ9LA6jYKbsKPunI17XTv03bkwM1OStPdkhWc7X1DyOdfxxLXvE8L3Bg9bKfpMMNVtFQwJDFQlAivQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8sTKnsVkZTVD8iVd+B8d5IkZxcP/eJZKONYzo+qkCIzruEjkv
	dLJXKhMNrwk0auVfGEOhyTn2fplZyBZ2P0Hc8UjPeqE70bjfATwDAyXmRRdsWnuZOEs=
X-Gm-Gg: AfdE7cn18ir847NCmnoyFU+6nRFgCVo3mrrjllM86xATTjt2iqIGhNXQ9+lof39JaiC
	jbEOQKNorhTI0tmZIsxGgoalwg3fbPLgt6GfjOlD+H04i3L6ljKoqK6GQndp1HbcF0Zxk+tKJC0
	sXe0AQ40grlFcSglijHMNKUa5KhUM7lDcIdcg5bnSKNoKaZoPsqSf5P23iqcILVRSK+/vB3/nhQ
	gyvy7+uiIBjv8RsvgGlFYr/fugChWjOQ1IPwMjeEMXiqHqUJYGD0zbDCc2j6ZKbiB66r/IJjiMe
	yDHiFwV+Xmm2CMrDCY66aLjhns6NrNQjpv962ml+pHMUTqGTkHXn2CwuGOVrjD2zMK6iq8fjtZi
	11lIUhor40TFNipZ+ZhLz3Qg2aXYqwFVryI5rM1zbjXOOgrY8QmaRntD8P2HHzAV8QT/9sjV6I8
	6QoD2fFBNMKLwqx/0Y6KzpHjK7pbccTteTVcqgwj7wi91bsuvtYZ9NFHEmcQbdqxCeDNHEpSw=
X-Received: by 2002:a05:6830:6d52:b0:7d7:4fc7:21a with SMTP id 46e09a7af769-7e9fbfffcaemr1728813a34.13.1782862451516;
        Tue, 30 Jun 2026 16:34:11 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e9ec2b8edbsm3516153a34.17.2026.06.30.16.34.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2026 16:34:10 -0700 (PDT)
Message-ID: <91b6999b-9854-46bb-8e2b-c8e260581f4a@kernel.dk>
Date: Tue, 30 Jun 2026 17:34:10 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] io_uring: annotate remote tasks for kcoverage
To: Robert Femmer <robert@fmmr.tech>, io-uring@vger.kernel.org
Cc: Dmitry Vyukov <dvyukov@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, kasan-dev@googlegroups.com,
 Jann Horn <jannh@google.com>
References: <CAG48ez02Sio8ZENVK3gUWM+8j6NgG9LxtnDV=v+FSqsqs_KfnA@mail.gmail.com>
 <20260624090145.1715865-2-robert@fmmr.tech>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260624090145.1715865-2-robert@fmmr.tech>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13863-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:robert@fmmr.tech,m:io-uring@vger.kernel.org,m:dvyukov@google.com,m:andreyknvl@gmail.com,m:kasan-dev@googlegroups.com,m:jannh@google.com,s:lists@lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	FREEMAIL_CC(0.00)[google.com,gmail.com,googlegroups.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,kernel.dk:mid,kernel.dk:from_mime,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 8B6706E8A7A

On 6/24/26 3:01 AM, Robert Femmer wrote:
> diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
> index 8cc7b47d3089..173299dfc9c2 100644
> --- a/io_uring/io-wq.c
> +++ b/io_uring/io-wq.c
> @@ -19,6 +19,7 @@
>  #include <linux/mmu_context.h>
>  #include <linux/sched/sysctl.h>
>  #include <uapi/linux/io_uring.h>
> +#include <linux/kcov.h>
>  
>  #include "io-wq.h"
>  #include "slist.h"
> @@ -639,6 +640,7 @@ static void io_worker_handle_work(struct io_wq_acct *acct,
>  		/* handle a whole dependent link */
>  		do {
>  			struct io_wq_work *next_hashed, *linked;
> +			struct io_kiocb *req;
>  			unsigned int work_flags = atomic_read(&work->flags);
>  			unsigned int hash = __io_wq_is_hashed(work_flags)
>  				? __io_get_work_hash(work_flags)

We try to, roughly, keep this in reverse xmas tree order. I've fixed it
up.

> diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
> index 46c12afec73e..aafb640d3b2f 100644
> --- a/io_uring/sqpoll.c
> +++ b/io_uring/sqpoll.c
> @@ -13,6 +13,7 @@
>  #include <linux/cpuset.h>
>  #include <linux/sched/cputime.h>
>  #include <linux/io_uring.h>
> +#include <linux/kcov.h>
>  
>  #include <uapi/linux/io_uring.h>
>  
> @@ -342,10 +343,12 @@ static int io_sq_thread(void *data)
>  
>  		cap_entries = !list_is_singular(&sqd->ctx_list);
>  		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
> +			kcov_remote_start_common(ctx->kcov_handle);
>  			int ret = __io_sq_thread(ctx, sqd, cap_entries, &ist);

Never code before variable declarations in the scope. I've also fixed
that one up.

Also not sure what branch this was against, because it doesn't apply to
any current one. Guessing something old? I had applied 2 hunks, fwiw.
Please check the result!

-- 
Jens Axboe

