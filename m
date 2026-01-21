Return-Path: <io-uring+bounces-11870-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2FDkOGRNcWkahAAAu9opvQ
	(envelope-from <io-uring+bounces-11870-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 21 Jan 2026 23:04:20 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D47535E73E
	for <lists+io-uring@lfdr.de>; Wed, 21 Jan 2026 23:04:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 05CBB5EF905
	for <lists+io-uring@lfdr.de>; Wed, 21 Jan 2026 21:56:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABB6A41C2FA;
	Wed, 21 Jan 2026 21:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m/R7SVr5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B6533BBD0
	for <io-uring@vger.kernel.org>; Wed, 21 Jan 2026 21:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769032525; cv=none; b=E0uAX1owGeNfAaNyM7Z30NkE+jy5VZAjAw7ORqwBk5Hr/as64EE/ioObrdeH5HBqABSSXpcP4El0s5cASHZh9I7jUBJjhDVnhevC1/N63DkniJswRL6Seo4VQdSj4c/hTOctqpxdt/nLINQSZu4GGGWHKvsWwl/fw0T/639SF9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769032525; c=relaxed/simple;
	bh=di1UjR31nVP8SvwUOVTTZqe9zm09WKYfEQEV85UAMuU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GC9kALNyc+Ga42G4m17mrTtzPoB1qUa58uUGqd5vcoezDu6+fdif9SuK1rZr/E6fqI/o6YPYfETrZ/Ju8hlsoWypXF3wOyIG0bE4U/DU0AcSgKfmSndRxPABjcrXRMHk4x3KQcNGJtYlG1DavNwUFMvTrg/A3mq1AodFz7lrpVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m/R7SVr5; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-47ee937ecf2so2335495e9.0
        for <io-uring@vger.kernel.org>; Wed, 21 Jan 2026 13:55:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769032522; x=1769637322; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vfGWlFtAfjDKMncEbJv8UAGEOP7OMebBkUw+PhQLrik=;
        b=m/R7SVr5n5Dv6f5bWXBMEw6bLJkUZiM5xjoIYpFprQBAuyr6xLY2uStPl/to7lH/Ru
         s71ZIYHwLWr2PuigSbRouekGcP7wT+8sDZ6Ebl2Vh+lebbI3WKQKtLzf7DIrydKME/lD
         nti8id5V5Mmo3WEWxsgPP9JMJUPLUR2fnNoE5DWcgLMXgz5B67xVLkMI8a24jnF0Tv9G
         aUH0dURr8y1ofTJA57U3k91PbCTPmIYrPl+of3hAyNuc1u+4Vh9aMPH2pQdUlxWg4cvd
         U+ZiI3+jLg9TGwxPRe4YZj8XDYY7Lo+N1pvNwblp2K9wNhDNnv3lS7iKo0czbU2zl31Z
         f3wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769032522; x=1769637322;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vfGWlFtAfjDKMncEbJv8UAGEOP7OMebBkUw+PhQLrik=;
        b=Zyra5UUwAKK9TQmdncV+ME2gTqyo5tNvn5w14EZVEwE9u6cWBivFWDE7wL/TVJi9kL
         zxxrdnNuOAWdPg6I+eSdngmrPmJVT2RKZSB0flBRrsWozBtwu6g9VA7HKy1kiaqLolc0
         eR/m2zbbyQDdTCXSG+okEoK61FKx7ZLrhMeb+OeCy6gD4JXMAmUv7Kl4CYV50gvr9Anl
         uZITlEk4kqqbhhVN4djdenb3Yd0Npx27AHIQTktquZLmo6kfutSbhSQ4VAObdDsdMDD9
         UK1uHp2FDdggVrmVx7GzfZ1n3FrshHGNpX7Fql8Hgbq/4UR06GQJoYriqaqyAOGgUiDZ
         Svgw==
X-Gm-Message-State: AOJu0YzukZzdeYBMeX+KMLYHLdm3ksOWbEfS6OwvzLou/NqDlppU7sDL
	fAf3KZUtf3qew1Najj54j181KaSFaUG+PASTnWfKCS4K5I2yYhuDMPbx
X-Gm-Gg: AZuq6aIQzChoAH9uj4Bk/XqJw2wcirEotxzo3A+Kdi+MSZL++GFWPZyGurUxrmMy4jP
	7L9Y2QLDOYdXSLtkOQqsifbjR2SW43KokMQPL2R9f1xqfVMMJIsaPeW41YocP09uu83Q5C+g3fb
	UePXHioFc31PzWlSLTc/0YuDiHRcOb8Yv8LqcesD/Y2wiUf4gs7DfDd251+9LQBz6Mj0zbmVAEi
	Vb8+u8ErA0/CZRHoVKwb7bCXwW1TgIfGCBLJuPNuYKZKiJJJR0Gm1C1rZU8L4V2oe3kyiHnhb60
	UPvup8sB5W9XVMy3pSpczfEOQ+LW4uVbXJEAyOM7owsBSPbOu88RhnCaQ4yexIJZm+r1kv6oBPr
	iqvCGALaFNCb/HTxSGZslV3L60o8EvZXx2li1X1ajkBnSub0NjptVH3DviDxQKcKfOHWaEPyxjg
	phjz/WXoqVTuk0IDfsbJjV5vz+zqvCEVqbNGW4B5n8UWA8lwliJD+7YLbfRrWeJBUlMbf1pLkbf
	9JOHkM5wuUWPzccpcRrryoCdPkcjVb+YU1RxtIRIZWV607Hc1P3FI42PuCF8yR3PQ==
X-Received: by 2002:a05:600c:5290:b0:47e:d9e8:2f3a with SMTP id 5b1f17b1804b1-48047052174mr14757675e9.2.1769032521535;
        Wed, 21 Jan 2026 13:55:21 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4804706ef6csm14660115e9.15.2026.01.21.13.55.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jan 2026 13:55:21 -0800 (PST)
Message-ID: <80368e4b-9148-40d0-bd52-1507fef68055@gmail.com>
Date: Wed, 21 Jan 2026 21:55:18 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/1] io_uring: introduce non-circular SQ
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org, axboe@kernel.dk
References: <b7a5502ee3da7ef096455498cd1ad3efbdbee288.1768940337.git.asml.silence@gmail.com>
 <87a4y6esjj.fsf@mailhost.krisman.be>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <87a4y6esjj.fsf@mailhost.krisman.be>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[gmail.com,none];
	TAGGED_FROM(0.00)[bounces-11870-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	FREEMAIL_FROM(0.00)[gmail.com];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: D47535E73E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 1/21/26 18:20, Gabriel Krisman Bertazi wrote:
> Pavel Begunkov <asml.silence@gmail.com> writes:
> 
>> Outside of SQPOLL, normally SQ entries are consumed by the time the
>> submission syscall returns. For those cases we don't need a circular
>> buffer and the head/tail tracking, instead the kernel can assume that
>> entries always start from the beginning of the SQ at index 0. This patch
>> introduces a setup flag doing exactly that. It's a simpler and helps
>> to keeps SQEs hot in cache.
>>
>> The feature is optional and enabled by setting IORING_SETUP_SQ_REWIND.
>> The flag is rejected if passed together with SQPOLL as it'd require
>> waiting for SQ before each submission. It also requires
>> IORING_SETUP_NO_SQARRAY, which can be supported but it's unlikely there
>> will be users, so leave more space for future optimisations.
> 
> This patch got me wondering if it would make sense to have a way to
> point to different buffers as the SQE map and execute them.  This way
> the user could initialize a set of operations in a specific region of
> the sq ring (or a separate buffer) once and have them repeatedly
> executed with a single command, similar to a procedure call.
> 
> Say we have a preloaded ring with some sqes to accept a new connection,
> and immediately some fixed data, etc.  When I want to run it, I push a
> SQE OP_EXECUTE pointing to this buffer to the "main" ring and io_uring
> will queue everything in this pre-registered buffer.
> 
> I imagine it would save nothing beyond SQ initialization. just curious
> if you see a use case for something like this?

You already can do it with the sq array. Never heard of anyone
using it, but liburing never exposed it to users either.

-- 
Pavel Begunkov


