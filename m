Return-Path: <io-uring+bounces-13695-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 6YSOC7T5K2p6IwQAu9opvQ
	(envelope-from <io-uring+bounces-13695-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 14:21:08 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 892F067951F
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 14:21:07 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=frCuEeeX;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13695-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.105.105.114 as permitted sender) smtp.mailfrom="io-uring+bounces-13695-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 992BF30A4260
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 12:21:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABDD13932FC;
	Fri, 12 Jun 2026 12:21:05 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2BDC38E8B9
	for <io-uring@vger.kernel.org>; Fri, 12 Jun 2026 12:21:03 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781266865; cv=none; b=mxU2OqOl4trOX5zv+xPhmbP2T0t/W3vCeVOQJOnAHghFlTmpDUWmhj0uC71dRNgupfVcuttE8aHKRJOJdP+y+yi09djG/vHWT4bo6jgrV+dhhzOCEdejIG97Zeud7B56d2msFJHLDezaQjDzp6rbpssa/oeTcKT2rNrVK/Zi56w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781266865; c=relaxed/simple;
	bh=i6JqW4MDixRyhjGSrWWsJh4qykQt1TXnXQaFW5g0UOA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dU0Tsc4Qznemo//FSCzVu8Vzh2MhMjktB2vBzOX2Ngz50Q0V+WHCBndjaOibpazEyi0pJ5FCqvaUjzNF6QvEU2qhdQEFO8JIutqbaGTP5tVFp5Xa++uWbno/CCoKIAaFgB+unxI82GKu4Rm5GB3dKsH/ufTlazv4zOhQLQojips=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=frCuEeeX; arc=none smtp.client-ip=209.85.160.50
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-440e2b605ddso213008fac.3
        for <io-uring@vger.kernel.org>; Fri, 12 Jun 2026 05:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1781266862; x=1781871662; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=q5YfwvTgkVV9liuxUrun742toM+85ieMDdVaMhpjgfA=;
        b=frCuEeeX2vWz1EWKqC4CZresjXHTsA0QjGd9yvolQspZnDUD3AznPSwX5+0Oom7u4F
         ULigEQpAsl2WHzlCIBEYNr50iyHhwUiHPuNpgIrTWXKTI+z+oEqgmnEjsg0GC5klophD
         PLCV8zG/FuqIOxTBRXwzb8wT7kHb1cXZGsPFxJYOp12jIpJ+uwiPdwhsQyd4zQT0pmW4
         os5V9DqbJyRLRCV8Q2dCDuZ8r5MIakz9ESbRbFmik4Ve9WL/rHFLn3/UILBKKgSWQ+sz
         gLYfGATRJXwng+Vt9wss7TWWPuZJyinUCvP/f1BQgxFbzoqsRgalfTZsq2+QX+6Wmg44
         bKWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781266862; x=1781871662;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q5YfwvTgkVV9liuxUrun742toM+85ieMDdVaMhpjgfA=;
        b=eI4PqOc7XX3JzI+ttWlMZ+eYKK5EPjOWPqu998x76OLjsVXRMFBloNOJ0mPtUnL7Yd
         fh30amHBjQjTDBH19x24c4uiMZZo1d6sRvDSOQCrj3KtqdQAzduGEyYDioxKucrXD8q/
         G3FLYsm5abWHoBx4JmY+z0XrRAhGPA/tFDA0Xnb9J9Tn+tTHkFEbHX60frV5XQdFO6Aq
         5ER2e8FRswn4/3omzKqG5p9Ep8QlxPCVjEh8VrHW6p/EbDaY0JTiGbaiDECuApmC15GW
         /7vnoXaylqoviysJfUc5L+kSdm8VfWXF42LlI7Zy0BNgwb3BSFD8ZNKvxqMlLQYm3Emf
         8uXA==
X-Gm-Message-State: AOJu0YyP8StK5TAXoifqyBzavKlPO4OnUMGuJNkY5WGNfBLsAu3J8kdr
	ywynIv53OjSsKQ9L5bc1UXatiJ4R7itXqDQT8AinH/QkSamujj+ovhLZdGKbser9rv5O+JpkYpo
	2CXvHtuo=
X-Gm-Gg: Acq92OGsj3F7hu3E0ExgVUUaQ2c5Cdg6KZPHkH4muooxEGb/JX8dTbbUiitOrkMv0gR
	Xt/aUU5c9zoM8NPPvTWXQk06T9Bs6Y/as5jWKJtdt4KrxHMaiHdId8/wkThLTTERy24cSWEt/Ca
	ILRUQk7xCdch2NQg+4Ezeu/51/Ih86f4VvVuRF8UAH453f0EQxGpMs0Dmq5gu8j/GisGkEN9Ls2
	UgnAgi7eHVAyFnfqT+b3YrujlmnuwLrVQ6C6a5MGbF9s7pUi0YloHkHu7u5H1UqiZ5tS8u0w11E
	/Q1jXbiWenFmKQFb7nnrimUWXjJJIndVR5gxPqYc3Cv5SHLU5lm3co9WZW1dZbEctqNSQnQpC25
	IeL1M4LlYkCfDxhsCVtuFTnmAC5hTMFES8pgtnByyxnn/rSeRyX/gSqLHC7QoTEC1ykUav2o/7F
	jO7195GiqvUFxYed9Othtmj1P6uzEENr4X7X64UW98L3p1BOQxW3w64vu5bDmYZ/V4XcDZHGlsk
	OFySgeXjQ==
X-Received: by 2002:a05:6870:d410:b0:42f:f368:e025 with SMTP id 586e51a60fabf-4426dd8172emr1520044fac.10.1781266862459;
        Fri, 12 Jun 2026 05:21:02 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4426b32624csm1648056fac.16.2026.06.12.05.21.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 05:21:01 -0700 (PDT)
Message-ID: <1af6602f-590e-4ca5-b034-b09b3f40a8d1@kernel.dk>
Date: Fri, 12 Jun 2026 06:21:00 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] io_uring: switch local task_work to a mpscq
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, dvyukov@google.com
References: <20260611160553.1486640-1-axboe@kernel.dk>
 <20260611160553.1486640-3-axboe@kernel.dk>
 <CADUfDZrzwvY6UpBBhLj1JynuNf5bo140+LbMYDOvU13=od+nkQ@mail.gmail.com>
 <4be7a6db-44bc-4125-867e-9d22c2809f1c@kernel.dk>
 <CADUfDZr-MMYBaP-e+y9+xuRhuiunO2sBTUCmwZyd7AgT8sVtiQ@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZr-MMYBaP-e+y9+xuRhuiunO2sBTUCmwZyd7AgT8sVtiQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-13695-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:csander@purestorage.com,m:io-uring@vger.kernel.org,m:dvyukov@google.com,s:lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 892F067951F

On 6/11/26 11:24 PM, Caleb Sander Mateos wrote:
> On Thu, Jun 11, 2026 at 7:23?PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 6/11/26 7:14 PM, Caleb Sander Mateos wrote:
>>> This is great stuff! I had also observed these hotspots on a ublk
>>> workload. Since incoming ublk requests post task work to the ublk
>>> server's io_urings and completed ublk requests post task work to the
>>> client's io_urings, there is significant cross-CPU contention on the
>>> task work queues.
>>
>> Glad you like it! Once I post v2 tomorrow, perhaps you can try and run
>> some tests with and without and see how it does for you?
> 
> Haven't tested v2 yet, but v1 shows a 4% IOPS improvement on a ublk
> 4-KB read workload. The workload has 8 CPUs (unpaired hypertwins)
> running fio with io_uring submitting I/O to the ublk devices and 32
> ublk server CPUs (paired hypertwins) servicing the requests, achieving
> around 4M IOPS. Both the client and server CPUs look completely busy.

That's a pretty nice improvement! Would be curious to hear what v2 looks
like.

> I can see clear reductions in __io_req_task_work_add() and
> llist_reverse_order() (now gone) on both sets of CPUs, through the
> cache misses popping task work items are now attributed to
> __io_run_local_work() instead.

Right, llist_reverse_order() previously could have had the useful side
effect of priming the cache. Sometimes that could be useful, if the
task_work itself was basically just posting a CQE. Other times, when the
task_work itself does actual work (eg socket recv), then it was just
harmful. For the former case, we could potentially prefetch() next when
popping. Not sure it's worth it though, though we could experiment with
something along those lines.

-- 
Jens Axboe

