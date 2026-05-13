Return-Path: <io-uring+bounces-13316-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kFj+GFi2BGplNQIAu9opvQ
	(envelope-from <io-uring+bounces-13316-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 13 May 2026 19:35:20 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A5D4A5381E6
	for <lists+io-uring@lfdr.de>; Wed, 13 May 2026 19:35:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E08523046061
	for <lists+io-uring@lfdr.de>; Wed, 13 May 2026 17:06:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B78FE2798EA;
	Wed, 13 May 2026 17:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="KKPBzvxs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868EB4DA531
	for <io-uring@vger.kernel.org>; Wed, 13 May 2026 17:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778692009; cv=none; b=g56x12UDjc1D18ZwI9s0ydB+BBWJp+aT0tK5Ai7YywcKfuN8TnqDdt15kViM2rjUNOfzEcw92bJDI6lwddRrBDNEbde32cT8izaDrJRumiXt8jXGs2+VcxI6sEuMnBhcKnyTqRV0j8un441P1QhXYRhWye+ygpUEC4VTNJxwZls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778692009; c=relaxed/simple;
	bh=59zc5vXay8rEFphsgl4XNPjLXgaeSBZyCL/L43HxZis=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eu9nA0xmU0Ro5AZEQKneFEOBtLqj9Me88wJMiebRW7stIVV+bOr+Lwsmqy1HhXo7f/vKTY8ecfAoO9S0vuSCNNxHpwkhNaf8X8MgbalV6/Jhvg4wxxDpmd8pFR1WRcJTqiHhSOuRPV11zU55Tn4FQMYlQqVFb7kXBQv1ZnCvMAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=KKPBzvxs; arc=none smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-4645dde00a7so6380177b6e.1
        for <io-uring@vger.kernel.org>; Wed, 13 May 2026 10:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778692003; x=1779296803; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BDH9eNlIImQOn22DuiNFmLTFk9pn4XJcdcC4Nsrn6Ok=;
        b=KKPBzvxsX72+n/Ma+EbMQb12OCfyCIyMfcVENZFRJn1/47O7nCXr76q/gL98lX6W5f
         ipCm+huxz1gtDf5zRQpv7PqWhzvnZJYB79j38y2Ue748GmofBuUmwAMY8zDv2698ZKoY
         NL9suuuhaF/GN+vNDVdyb79HJD/A5GVLYy6+lVQ1l48w2GVo6iiqtM609OWD73Hcz7IA
         PWDX90l3To8wFJBoVE9QhMDJzeI5G5OHVhWFhby19Y7cGbKrnkoW5tFD6iIkk0cyN+XF
         8wxkSOPW741AWwSS7GUFgFKsX7Xn8Aw5HfAnt8U+leSWoMkKYd9vXq2F5xelCnHB3LW7
         gvbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778692003; x=1779296803;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BDH9eNlIImQOn22DuiNFmLTFk9pn4XJcdcC4Nsrn6Ok=;
        b=H55SKvByRInTWUhdTLCCDa+YAayCum1AFMKlR3X/nHkCNDvRjY57xCkoYiq761MQKw
         9erYISvTQbRAyKYdCAd7ljfAvmsN4EXxOZ3okLlAWm5tjD46q3kXmU8cjcbtFDo3K5mb
         86p2OQ6xX+Wae+tRB8EAfZj1DToOSKg/bIIC6M6DoRRF5KannemWZqtIRiZEpfHvEtPb
         v6P+8S6IxiycuwhG0Ku6Mt20gej7ZJHVWCz8jIrGVnmHaSGj5BItFj7hrT5LiLX8zLZA
         uFf0d45lbIPaM23oPAMkEp0W1Pnft7g6YUwbyheDon8M4JN0oozv8mEFJvPZd/C0j6sk
         0eCQ==
X-Forwarded-Encrypted: i=1; AFNElJ+emOVnZTjUqjiD+IqMxXNWp5XSM3UkZfR/4zRx2K4xz5XvfvpVGTB0QI6k9Hq+RtQdpfCpPto6cQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzQ/FwfB5ikF9FxAdo2z4nL45W8RWmAsXzAMeiZ9aJLNDzqvN47
	GWEyX2TiWUMwSPqUUyUaiqBYoPZUDeJ1xVVzXLlppu0aIa0iNoYG+A4iFf4PMbiFNRU=
X-Gm-Gg: Acq92OFInZh/K/xmLuiwqDtKkPc3uSKKYsXl9iqV5K/iGl4VjWU1dmVucCfXNwbmnES
	t0RM0mR4hJ3XWQRR6wAsTY4IGHyRzrJXU3t3ZwTD9aXhY5mXrXLQgOr994PrMxB9dJ2uUtPR4kh
	KRD3z6cBQSY6ZoDmoO/qgvc1rcRUmOdAlYEDxyzNCJmpXF4+dgFNl8DgeM/PqvettJixib7FPpl
	K88PB8XDogHL+tlPqBPSzZQ22TffMxSNQyjzK2Q2GK2HuY99utj5S3tb+RloWBUl/HSJ5qWHz9Y
	L0dUdT5z1tUc8sXzW7tVDZIAW5LPyr2XoUB3vK2jLT5RpclOm3oC0BpQpUk2pg7Om7m1wrEOBzo
	n535799Cg/M9faKBfxCnB1b7/VxMVxNnsgbKVFO+/dgDDHqzLdBLRatzPlpzllbTaDbCs322K1S
	4RzoxuyH4pyRW1VBfSuZSyZrUHBwRkIH2LlfripEstKZWvHEuBMCgk5rsF7F2jGU2I+Y6EwHsF8
	5XFQ+4Q
X-Received: by 2002:a05:6820:338c:20b0:69b:5697:387f with SMTP id 006d021491bc7-69b87e309eemr121948eaf.5.1778692003438;
        Wed, 13 May 2026 10:06:43 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-69b25e0e79asm9573607eaf.14.2026.05.13.10.06.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2026 10:06:42 -0700 (PDT)
Message-ID: <2e18f7c1-6c52-494d-8718-e95e7777e613@kernel.dk>
Date: Wed, 13 May 2026 11:06:42 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing] tests: add cBPF filter tests for
 IORING_OP_CONNECT
To: Shouvik Kar <auxcorelabs@gmail.com>, io-uring@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>, Kees Cook <kees@kernel.org>,
 Christian Brauner <brauner@kernel.org>
References: <20260513121040.933053-1-auxcorelabs@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260513121040.933053-1-auxcorelabs@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A5D4A5381E6
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13316-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	FREEMAIL_CC(0.00)[gmail.com,kernel.org];
	TO_DN_SOME(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:mid]
X-Rspamd-Action: no action

On 5/13/26 6:10 AM, Shouvik Kar wrote:
> Add subtests for IORING_OP_CONNECT to test/cbpf_filter.c, exercising
> the io_connect_bpf_populate() helper added in the companion kernel
> patch ("io_uring/net: allow filtering on IORING_OP_CONNECT").
> 
> Coverage spans both blacklist and whitelist filters for each
> connect-specific data field (family, v4 address, v6 address, port),
> plus v4 and v6 subnet matching, and a test for the addr_len guard
> in io_connect_bpf_populate that prevents stale io_async_msghdr
> cache from leaking through to the filter on short connects.

If you run this on a kernel that doesn't have your connect changes,
then you get a lot of:

Child: register failed: Message too long
Child: register failed: Message too long
Child: register failed: Message too long
Child: register failed: Message too long
Child: register failed: Message too long
Child: register failed: Message too long
Child: register failed: Message too long
Child: register failed: Message too long
Child: register failed: Message too long
Child: register failed: Message too long
Child: register failed: Message too long
Child: register failed: Message too long
Child: register failed: Message too long

when the test is run. It's important that any liburing test cases
handles older kernels appropriately. You get some of it for free with
this test case, as previous tests will have already checked if cbpf
filters are supported in the first place. But you still need to handle
the case where cbpf filters are supported by io_uring, yet the kernel
doesn't support your filter yet.

It should just check for the error on the first case and skip testing
the rest of them.

-- 
Jens Axboe

