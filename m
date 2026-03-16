Return-Path: <io-uring+bounces-12701-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6BqxDwhcuGl0cgEAu9opvQ
	(envelope-from <io-uring+bounces-12701-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 20:37:44 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FCCD29FD8D
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 20:37:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4D39E302C938
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 19:37:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9529E3E717E;
	Mon, 16 Mar 2026 19:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="V9gJGEMJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043B33254A9
	for <io-uring@vger.kernel.org>; Mon, 16 Mar 2026 19:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773689859; cv=none; b=BNaQnCty5RYDHyMlx+ObtiLlJw4gJ+RRahnsj6nnFmNQnhjoVBP8UlmTmgBFW6Suz3b/yQJ0CzCDVmCa/tNSCsrYj7jE09xaNeO/OaKRdDa/XWA3ZYd5RVXjVB9oqp1WMMx7N7Cdk0YvisaeWEG7vztXpFcmra9kSgvRyqFodLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773689859; c=relaxed/simple;
	bh=ZvsXSyiI3XkbsKZuNkcSgsTni+v4WLMdb2x9NUrXcM4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h3pCAyt26X/2IJCi2zkD7tUPBqMlo27cg7Ilo96XEYcA0JtNYlubLi4AAHQCg3PbcM0uqgJV/y2VrIK3o6T8GZbnoDWfWgrMIkhFSWc2h0H0214ArP3QldI/L/NGQWRUfpMst7zLmglAPP/5NfHbezLkwH3j8qkLtKCVDoorJ5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=V9gJGEMJ; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7d1872504cbso69603a34.0
        for <io-uring@vger.kernel.org>; Mon, 16 Mar 2026 12:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773689857; x=1774294657; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yTI4ZGyhMvb0csBBlNJg9TpIQ4OoSUyId0bqLGFvRG4=;
        b=V9gJGEMJeyQPEUQoq9izwPN833JdTjNkNnsg4VZ/+fCFTH48JFcd8wv+fsWT8ST/yU
         klaxnuhF6HFEsSdeMgQwqanoKL/qJ+quPTuHr3gYGCAp0XmpMvHHkKjPCK6R6sv7tm3m
         vjvFoOi2OItk0dQPsz6Uj1UvINuWVdab+kma3F7x2JkQUD9rVR+ddS65zDiAYR8RfJsr
         pxr7ojJq5IHyxUtV8KJ2jMkKbj4jjyRyzF67oaCRQ0hFY1J4WZsFggqVVpDz0tnOplVD
         OGQYZliyau63hDIggJOS/5aPQi4M+OC+t0xjnvbEdbKeZUpLs1MqwiH2Fhmw9m7x8Ra7
         BWbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773689857; x=1774294657;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yTI4ZGyhMvb0csBBlNJg9TpIQ4OoSUyId0bqLGFvRG4=;
        b=lXuZnhEh/7LMSCl1X7DjHGYbhIY8GuPGTO05e612bZEKA8q6ajwnPt66MG8UlqRzZJ
         6/qW5PBj9KnqsuP59nMUqej/Zg+wijX8zvCgiHAgS8WBxwvl+tQ+zTskrjcXLK9pcqp3
         l5znPXzrANiyuWNtm8GlTdTSwpP/SGyzaA2k6VIkhSvhPn6wmn+jXPRvhkwFHQldazDI
         9zQF2hk0TFXzi78kBLgGwcMd7hvEnu+Zqh8kQjDMFu5qd56K2ygygrrP062Dl/TmyCpk
         VcXmzFXIaKJ2nBqIm8Q40/pUVyze7tZH1cY9k2RfdYh1g3aCFuqsvrDn4qHdWcnBM/pw
         ctaw==
X-Gm-Message-State: AOJu0YxYcNmJeWq3Vju7Y0M22dm8ew+qQAhfMIcxcopop2lnZe005vJp
	NlLBI8tZbGM5fvfHFOyn8L0IbKSHNn27RE+jns3kkFGHS9dBW0J6v/qeVGe2p3K95H0=
X-Gm-Gg: ATEYQzwTFgkEV7CJ8Jf2tjXOiuHiGblQ6gkFKkSt/OH1uAsBi/nPKn2tubWMqMCIJVz
	tY1IYV6FNI9OG9U7Z3IKrEZQkluSEm6qlMV2cFEa/DfNAAuux3/2FNsdVX714o0T4Uwpc/XqwmH
	QEDfp3pgygdf0gy6mJBE/L8YXVEN9mXX9Ail/hchGS3lOfrPFrUhsgKer8lQkdZO7MKuCuXdjzn
	Rehkh3DxxX9/wV1oAoKXPSl+o5PFt6k0BVgMnRJKT4106eFFUEjdPHTwnjcgA7rx4zDH4uXRoU3
	8k4tTWt5VkmyagwvU5s7N8k1e890VmMmLQO6MHtCcghX4p19/6+AJO6ryK6HDhjH3n3vkQAL3KX
	MoufSdGB0+gGBGt96J65FKV32e3JBWIueWZBELme6ccU9+RR+KArMjbE078atZ9TVrqrq/9lsKB
	Wv2Ib0E3cvzbvHb+eoE5lVkfHNNrqO/nmZ+i3TQvG5ePoR1D3B7lV3CpqRD0iUy1y94RqdxDdCp
	Hdv3pdSXg==
X-Received: by 2002:a05:6830:3591:b0:7d7:4c90:ddce with SMTP id 46e09a7af769-7d7bb6c99b9mr470879a34.7.1773689857004;
        Mon, 16 Mar 2026 12:37:37 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d76ae39b39sm13970767a34.15.2026.03.16.12.37.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Mar 2026 12:37:36 -0700 (PDT)
Message-ID: <1f79957a-5b23-4bbd-af8d-9d1c86791645@kernel.dk>
Date: Mon, 16 Mar 2026 13:37:35 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: cast id to u64 before shifting in
 io_allocate_rbuf_ring()
To: Anas Iqbal <mohd.abd.6602@gmail.com>,
 Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260316150636.2123-1-mohd.abd.6602@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260316150636.2123-1-mohd.abd.6602@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12701-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel-dk.20230601.gappssmtp.com:dkim,kernel.dk:mid]
X-Rspamd-Queue-Id: 8FCCD29FD8D
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/16/26 9:06 AM, Anas Iqbal wrote:
> Smatch warns:
> io_uring/zcrx.c:393 io_allocate_rbuf_ring() warn: should 'id << 16' be a 64 bit type?
> 
> The expression 'id << IORING_OFF_PBUF_SHIFT' is evaluated using 32-bit
> arithmetic because id is a u32. This may overflow before being promoted
> to the 64-bit mmap_offset.
> 
> Cast id to u64 before shifting to ensure the shift is performed in
> 64-bit arithmetic.

I'd be impressed if 'id' could be large enough to cause this to
overflow. AFAICT, you'd need more than 64K interface queues registered
to hit this. So I think this should be reframed as a cleanup, to appease
smatch.

I'll defer to Pavel on that one.

-- 
Jens Axboe

