Return-Path: <io-uring+bounces-13619-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id tPoQF1CXJGr58wEAu9opvQ
	(envelope-from <io-uring+bounces-13619-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 06 Jun 2026 23:55:28 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9536764E70C
	for <lists+io-uring@lfdr.de>; Sat, 06 Jun 2026 23:55:27 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b="NrHDD/Sq";
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13619-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13619-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C5B6D3015E1C
	for <lists+io-uring@lfdr.de>; Sat,  6 Jun 2026 21:55:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79FD23D330B;
	Sat,  6 Jun 2026 21:55:23 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F268274B23
	for <io-uring@vger.kernel.org>; Sat,  6 Jun 2026 21:55:21 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780782923; cv=none; b=tcSPkdY3HljOo8yTocbFnSymRUNckxprtpXLez0P7TWlu57hhVqY/0IHzVk2BN8GgPDQDVdE3k3fDbmkfnBzU3Q1fZpU2VNtcSqeil9Ju/mZozeSdBsJqXio9vFO+GvjfqaidIkO8cC5J+o8PB5O4qZB24u8iBbqF46PqELRTAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780782923; c=relaxed/simple;
	bh=TEWLbo8/iNKa29hISjwP1lL4kySPmvoVu3KsMz64d90=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=THgWXas8yiF0GyUzg+4e5qT9sThxnoqkB4RBFIvRRubE55rlFIkWhTnAmAbPLfkyS/0RMLEtx/GfRV7drODJD8fDJ/7HbQ+zGO1iCpXLh12Rq8KgcY0Kgi78mJaFYU1s618le2MCMdA2m6ETN8XavYdRJgQQ9c+wgD3ZNNqO38s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=NrHDD/Sq; arc=none smtp.client-ip=209.85.167.171
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-48657fc84a3so2645796b6e.3
        for <io-uring@vger.kernel.org>; Sat, 06 Jun 2026 14:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1780782920; x=1781387720; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iPnWjGOdOrf1OytOjS78s1pTXmzRpumt7Mjx9WGwmic=;
        b=NrHDD/Sqd+LIo7PGYxLPMFH9mVrBCYV6mzgt8s/9aolz0gu/4GQh1b7jW0YmJlYapB
         8kyLlf+rUDhHayzW5FSVs9OFvAcdFP+kD3FR+Upp6swYh/I7r0IN2B4XK7UJ35e9/LDg
         ky2hoks5cy3JKctSDOUaWcbBG6Y74mGq6JK4KXunrHkS7V5+iopqm62yTw1RpP4qUOns
         PQ4sHzRMdN6+/VUM1XRbNKadAzS1KF4p2FQPf3Zop48Fd6hfUSmhaYVAmoZ/24Hh+dfN
         IWMz/6KHFXOVDJesLdVEW+IV5oL+mVNnbLvsI43f57YwHGzz4cavRTJxN2JK2VuJR6Df
         31VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780782920; x=1781387720;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iPnWjGOdOrf1OytOjS78s1pTXmzRpumt7Mjx9WGwmic=;
        b=ZLS1s9v7GgywethF09lHc0veBmgwI1/ExiNILoNkcoHm15TSGrLPLRUVCEF8J+vRwl
         WpI3A4OJCrWn/04lEiXPRfL7bKj8JhmCZAnR6nhjS+/0W5C7NCSUmZDXEXYL5xBs1Yhu
         dPBaz6R2Y+DS+ZwQFoH+7qZ69+LLS/O4gmf75WaxSxHBm57JLyjv5QjkKHJq++Ntav1H
         55MKMOVJbTfoE38EDCA2tfsg2BhIZpkgCvsWUuCXt+G8rb7JUF6HrEmCIkHIYcRRzcew
         LR+3t1jLkcuT4W4AvwsYOBe64X6Sc8dN0KjRhsBMcxDb0HeQfATe8wz9TzsCfuTAIuzp
         6J9Q==
X-Forwarded-Encrypted: i=1; AFNElJ9zcAO+YEJuPeZ4Z4CkyK4BT8bfwG/+VSv5zFIE6LrqxPJJr09l/6LXlXB3w8UItK/SU+b+ydlAXg==@vger.kernel.org
X-Gm-Message-State: AOJu0YztMnr4d4fwJOJqD3D+bJKc5NCg6DIRmqheDYn88X9J8Da+dw1N
	yj3WdrqGdk8STIyviTOlEVYi7P4Q0af3Fzdfeh1BSrxquM7/1pGQwk2GG4MMdhS2oxhPjSdBhdC
	/FF81
X-Gm-Gg: Acq92OE5DWxIclvEC9x2CXlpXKCCh6YSlGXtm64oXbbKXS7MD6sLOX+PxWRtbibDC60
	3kI9wU6SSlgTxnH4BgzMSneU5KwQXDC1svhEJRkKLfGzUt445alSEf0xaGGYR1XBy7gxCfVCBN9
	/1AOOPz+d6WK4uPF1xp/6Ix0w9iLw3c0aulcECuQmuMgO78r3RM11KYTK++Yey7+t62jHQ6iigX
	OctR5T9e1SQGldaPndq5ZvwqN97sxcGzZKBDguJr64psNei4XsZdvZ6HuGFi6ZtCeUk7Jzk9MFw
	tn1ez1xVNT2/o7RCHuQvH3WVpJ04eE+KybcMUHY6pgXYyE3SjkX8Ho1Ko8mJ3g/n7j+YYcYhund
	JUPnbhNF9w73oho7Lllzi2O4tWhSHCDZceVBdy/U82WnKqRGdkyt7zAJX446cFv7at0Cd3PypS6
	0azQdnIwtZH7rsnpBhFZ2RrChByZ6X36K1C9i90Ysf+MY2IAOXyWkYmle7eU1inOG1INzfzFPoa
	kNyvlKRzg0ru348HUsB
X-Received: by 2002:a05:6808:2387:b0:46a:7c00:5cd8 with SMTP id 5614622812f47-4868df60b43mr5814156b6e.22.1780782920315;
        Sat, 06 Jun 2026 14:55:20 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4865b5a53bcsm10107618b6e.3.2026.06.06.14.55.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Jun 2026 14:55:19 -0700 (PDT)
Message-ID: <9f94f066-ea36-443e-b989-cf920ff9d27e@kernel.dk>
Date: Sat, 6 Jun 2026 15:55:18 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] iouring: Fix min_timeout behaviour
To: "Christian A. Ehrhardt" <lk@c--e.de>
Cc: Tip ten Brink <tip@tenbrinkmeijs.com>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260606201120.1441447-1-lk@c--e.de>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260606201120.1441447-1-lk@c--e.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-13619-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:lk@c--e.de,m:tip@tenbrinkmeijs.com,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,s:lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:from_mime,kernel.dk:mid,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 9536764E70C

On 6/6/26 2:11 PM, Christian A. Ehrhardt wrote:
> The wakeup condition if a min timeout is present and has
> expired is that at least _one_ CQE was posted. Thus set
> the cq_tail target to ->cq_min_tail + 1. Without this
> commit a spurious wakeup can result in a premature wakeup
> because io_should_wake() will return true even if _no_ CQE
> was posted at all.
> 
> Tested by running the liburing testsuite with no regressions.
> 
> Additionally, tested by turning all calls to schedule() in
> io_uring/wait.c into calls to schedule_timeout(1) to force
> the spurious wakeups. With these spurious wakeups the
> min-timeout.t test fails before and passes after this commit.

Either this or the test case is broken, with or without the change
you sent for the test case. I'll take a look, but it's definitely
not passing as-is.

-- 
Jens Axboe


