Return-Path: <io-uring+bounces-13057-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8JLVAUQA4Wk7oQAAu9opvQ
	(envelope-from <io-uring+bounces-13057-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 16 Apr 2026 17:29:08 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A6BA410C83
	for <lists+io-uring@lfdr.de>; Thu, 16 Apr 2026 17:29:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id B24443030852
	for <lists+io-uring@lfdr.de>; Thu, 16 Apr 2026 15:28:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1038B3E0C67;
	Thu, 16 Apr 2026 15:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="pgpNOSvv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF703DFC61
	for <io-uring@vger.kernel.org>; Thu, 16 Apr 2026 15:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776353323; cv=none; b=kgjbdPj1PxLHXElGfWC/i60k6OFhPOGg20vKOdsnCAkrV515Ifg5ITmR8Tk80Z/dmabylbb1cjRnMe77nZTjznY9YuLExzoNPb3RbQTHo6EACaTtvziHIFt1OCDso/otXFKL5nuuK/kJf9cCPj6GA8MiHvzmcN4z9l05OU3lsGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776353323; c=relaxed/simple;
	bh=1kiqTlF9vgla/kagPltqcu2hmPvWBlevPKnYGJvPoGY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h0aXXVnarRGnE/aqzML6uhT7nDiC2UfJ7y2C0ZhJLOFf5IZsmj2mvEpheuukKfmHUjgq9jGdcUD7bAtCZFO53jqVsQH5iLEewU71jzl3mwWKkEV/sCh0wTXP9Y0NdiY4Nwrv9I/kms+jGpeHbWZmIw+acdi39iPiu1IHGLRxtrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=pgpNOSvv; arc=none smtp.client-ip=209.85.160.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-41708f6c3feso4812043fac.3
        for <io-uring@vger.kernel.org>; Thu, 16 Apr 2026 08:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1776353318; x=1776958118; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IDeRlu94J6k2+cc8OM82ZUFLBdHkWOILHFwsCHHMsJk=;
        b=pgpNOSvv9RzvbAvfZNsIySyCgW8+/UFYnfSC4s7v/1vmg5tDpeNaCznXkkhN6hOHQH
         F4iblhC1pyzi4rxj6mjqAu0ngjCJ6Hq/h1vzRrwROF6KxB5sezIIpusPV6x8z2wa09aF
         +w6J2GpPBMoiqZ/Y3uryrNoOueGhdjFzfkADKwEcczHInIoqxRZZzu/d6CrMiOGWWoEF
         Q4TTGvu+CdaKqy7mNqlTEYPJ4t9pw+bs25LlW+vgsrqZrm7WowDZIbpdzGoU+7B+rMS0
         fDcFU2i1W7kCx6F9xNrYQ6cMvoa3rlwOuTQu5W4L7Dk5/W+tpnKyz4mcrDh7giHlWCNn
         I+Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776353318; x=1776958118;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IDeRlu94J6k2+cc8OM82ZUFLBdHkWOILHFwsCHHMsJk=;
        b=rY8W9vni1hSy7YkNz0jvmGKzfPjznxInPEs+N2HedFvEK6rxB1xCb+FriygnA8pJ1V
         6mKMcwwwW1dV2fnJbjolJTmAUdh67Ym6l5vwTNMymi4naliyNz/FtLzjChHOMtMfAwmJ
         sK74YzfX+8vmqyXc1kmM1yw+kpteLLvdAjBF63erHb8oWkQmETh/JEk4dBN2koWFZ+ec
         i6f40b7If+ZmUR3QzfnhXU3ODopvtOWDaBxwCeuEzeucofTDBj50KsWv0nPA60DyQfRJ
         SGjMn/YkyLfTbya11ksCY9b8h2BfhVKVmQw4672MZy4Z78wlDDiduVle6FsSZgc/kmUA
         ORdQ==
X-Forwarded-Encrypted: i=1; AFNElJ+KlinKQ8CFChq1qs01XurwodsUiAaTg7J5P7wN7EMR9sUzwZB1HZQ5+MiRa/UrMdj4G5FYKTslaw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwmH8fYrQ49q/AvKnPi2YxXP18bB+COFUj9/orl4yATDi2es9M7
	DrsWM7dyr7PKgE3SsD+ywkce6gHSkU9WvugCxjhiHwfD4/Xb7i3jkxD940sBXbk0OCc=
X-Gm-Gg: AeBDietqdsBK/UqPGSmhyNfggYS8DUEbmXyAraxD6nKo9qLMf+VYOtHVl8RBOPP8Poq
	/9LlVkjfqzVlUyfrxksOQUCRhCRnA/EamBBW+8ffR+J2yDua/xQNCIXxh6t5RK6fmcnSZogxRe7
	y8hB1tuWEbDrTZEih9JQZajgvFPoi0TT3hVDWzdBP7nyAZcATIR2fsiYbWHhBDR3daOs2/RC/LL
	x3HiCVWKAu3ZWGElhuN6nQLot27Qhmt1u4GKVs2HekiH4U6mOVcZDTC1h154Jok8QvmsVzBnRig
	R9oRlhPpsZoczG1JAxs4TT4jGpmE9luf8HHeNKOehfy2Rm3ZBX3his5u7m4tUuLetoRiDxk4Law
	wF3pHfR8ylERDxPNR/3kt/7A/Tvbcskiw7jErhDVEAXMhkRDfV42x7rQc81He8kr0tx1SwTxzqv
	DqkXWvyeixj1jEeUBaL2WWD8OzpDV6h1zsIoZ7Rv3dqbcAL4QUgb8o9mzJ3uLfu9sV6J1nSuBpT
	GM9+OupXQ==
X-Received: by 2002:a05:6820:2210:b0:68e:2a4b:9058 with SMTP id 006d021491bc7-68e2a4b90camr9775557eaf.25.1776353318044;
        Thu, 16 Apr 2026 08:28:38 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-694601e9854sm137235eaf.1.2026.04.16.08.28.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2026 08:28:36 -0700 (PDT)
Message-ID: <d46b8edc-e63d-4d5b-a235-b74693402c89@kernel.dk>
Date: Thu, 16 Apr 2026 09:28:34 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/poll: fix signed comparison in
 io_poll_get_ownership()
To: Yuan Tan <yuantan098@gmail.com>, Ren Wei <n05ec@lzu.edu.cn>,
 io-uring@vger.kernel.org
Cc: asml.silence@gmail.com, yifanwucs@gmail.com, tomapufckgml@gmail.com,
 bird@lzu.edu.cn, zcliangcn@gmail.com, ylong030@ucr.edu
References: <cover.1775965597.git.ylong030@ucr.edu>
 <3a3508b08bcd7f1bc3beff848ae6e1d73d355043.1775965597.git.ylong030@ucr.edu>
 <6dc4f9dd-975b-436f-889b-7c584bc18e62@kernel.dk>
 <e5b35ee6-8255-4164-8aef-3b9168634529@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <e5b35ee6-8255-4164-8aef-3b9168634529@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13057-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com,lzu.edu.cn,ucr.edu];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com,lzu.edu.cn,vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.999];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,kernel-dk.20251104.gappssmtp.com:dkim,ucr.edu:email,kernel.dk:mid]
X-Rspamd-Queue-Id: 8A6BA410C83
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/15/26 7:50 PM, Yuan Tan wrote:
> 
> On 4/15/26 13:09, Jens Axboe wrote:
>> On 4/12/26 2:38 AM, Ren Wei wrote:
>>> From: Longxuan Yu <ylong030@ucr.edu>
>>>
>>> io_poll_get_ownership() uses a signed comparison to check whether
>>> poll_refs has reached the threshold for the slowpath:
>>>
>>>     if (unlikely(atomic_read(&req->poll_refs) >= IO_POLL_REF_BIAS))
>>>
>>> atomic_read() returns int (signed). When IO_POLL_CANCEL_FLAG
>>> (BIT(31)) is set in poll_refs, the value becomes negative in
>>> signed arithmetic, so the >= 128 comparison always evaluates to
>>> false and the slowpath is never taken.
>>>
>>> Fix this by casting the atomic_read() result to unsigned int
>>> before the comparison, so that the cancel flag is treated as a
>>> large positive value and correctly triggers the slowpath.
>>>
>>> Fixes: aa43477b0402 ("io_uring: poll rework")
>> Is this correct? Seems it should be:
>>
>> Fixes: a26a35e9019f ("io_uring: make poll refs more robust")
>>
> I just double check it. Yes we were wrong. Correct bug inducing commit is 
> 
> a26a35e9019f ("io_uring: make poll refs more robust").
> 
> Thanks for pointing it out.
> 
> 
> Do we need to send a v2 to fix this?

No need, I corrected it already while applying yesterday.

-- 
Jens Axboe


