Return-Path: <io-uring+bounces-12284-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aMxrFEhRlGktCQIAu9opvQ
	(envelope-from <io-uring+bounces-12284-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 12:30:16 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 74BF414B5D6
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 12:30:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id B0BA13007A43
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 11:30:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8FB832BF42;
	Tue, 17 Feb 2026 11:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fsMrkazs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6F6332909
	for <io-uring@vger.kernel.org>; Tue, 17 Feb 2026 11:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771327805; cv=none; b=FRWCQAeC8plQ025Dj48A0axl7cyM1PnUxY6BqJlDMDUcmZuPG89VU2+Mhqr+JY/PYeTffdASPfNh3g5DK27DCYMsn/xeVZwdwrfYbKlbEQyFOxSVuVJanEJBNECahB4UnCi3w2kUv5qfva3YiglyqTcG0DQm3D8N1GxhJpMWvrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771327805; c=relaxed/simple;
	bh=v8SjMTwLcBZJzVfReFV56hWL5F5UajY4TMlFqNjPxP4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uo5Bz+jgOFTCWxOyQKZL44c/08gAef92WV/XyIJXcYy0E2kNop5VROC5m8EZaCDvaUcSpA89gAPCZJ0+2Oso1nq1hAutg3jHhH9Y9uh8yQ1LfjYH8tuSqn6ELpEkd2l9ah7RSfeAb53jjVues5jypBgRUmfo7oJdgehyfAtFOQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fsMrkazs; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-48371bb515eso46527805e9.1
        for <io-uring@vger.kernel.org>; Tue, 17 Feb 2026 03:30:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771327803; x=1771932603; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S0+Q06IjqCZ+6T72QS3e3RaNmdECxYnd2ULwCEntpf4=;
        b=fsMrkazs4S+ywWW426JgyhIDDZPGKunXbMPXGjyP9qWhJqzgXsS2RQCzb8ai+TWmwY
         ZlcqSGq+G0g1S1ISvE1I75jKrWMuoW98SeatHWkGHvDoj5PT20EpXKugagoR+vnNnZQ6
         JGRMKQ725MVRLpuRaznwTT6AyNjZtz49LFXgpJdhRjSZd0zA1+yq6CS4AcdGNkTFkBCl
         YrQPlEbZfPGFyBbyAMoBQWbv/UwmY/YmzffhjMbasCsT36HdsAy4YWon94MzhYrnOMsE
         PdJo8K9KgBOWumZ/AF0WQStIbHksqvullu3NL8K2dRhGx9p1B/DHwaeCIMtTOxVqNoC2
         rSzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771327803; x=1771932603;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S0+Q06IjqCZ+6T72QS3e3RaNmdECxYnd2ULwCEntpf4=;
        b=PuezHYvutiwGHGoVhmDhNENiz53azEz4ynS7erbc/1JDusOcC74pPEb+NTCSdMZjqR
         LQVq7QHwJPio1pKIl3xOpnmnHqbp6dJ6Oiv5v29rPpca5iiaXyck8+eOHndJ1u+Bol5/
         fhXHKS0IrXzBiGE+54LBvC2+mzMrgAcsEI8RLI5gQDkNPIryjNcEmuBSh2zVxuE08BSe
         8JP22diljRS8/0T99BGgcGguZXy6hvbGD98bdDS2JDecW4jQN9wMiVxypXqGeAhU2oKm
         rfkR9f9qp2GgnRVvF8w+khQTe7StNqd02oL/BqSFUHumxOL0x7Dyy5HPniSoz+y1Bljs
         iVeQ==
X-Forwarded-Encrypted: i=1; AJvYcCWsVZW2cK/B8h98NngPHlNJdeiVbgBeIUZh8l2hOoeDcbMzrI6eL45HtZI+urf76NmqgfYwqSc/qg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwKuKGx4bOA04Jqk+MFJwdTpRhk3Vn6VR7LuVGTt8HCdFO3yMIK
	XAsaU8EBTP//WYJBQfBgO6lNAAu/OopLIy56zwrpZHhkatSDJYLzGI+t
X-Gm-Gg: AZuq6aLETIYNFpyEHD9EJJqUWGc3Bt41sQ1fD6WFFYMrXfleHe3oWrZ7hanHbSCuqvL
	ifR90seX9DnXrJ0bG/RtPyoUDvn2XAfVBjLS2sUXp5/DoQ8Ra11Qs3T3kYCy3SpVJsMaIt95sdA
	WBJksvHyy7OXn232vNaECEp569JqeczJNoRJoYqfA+5fV9wntJqTbCxp+X3zgpP0gmstiH6mW9O
	1jk7S2wA1cZSEh+gC6wm/4Gheh3fZmTkPBI0TWJWsdewlqslqKVeg36YwjbN/hb+FGTby4dXaWj
	RgIFhxceNYuOLBrQQJ9o06qFbCOUhOrHDtF2tyFvzih9quvKWqqS88Wq7QGcKVKPZr/vB158vZR
	nu0zjKfVwgY3+Hirkq4CzvmXSs3OW0A4WAvxq5th4Rw8svuZNd8nCJSloBt5WXqztjAXSgD28/s
	2BLBesqfrU0+/3zlbaz24GG4SmOAcIvAdpp4Axtroyw/sDoWgNkU5VFgJUXGoU6p68rQmNqd5Q0
	SGXHYoluZgQE5FiC46S1LGP6OOR0tnwrLB3YgGNy6nLfZnS7pwa8tZeXQpavkH8m92tkC8wircn
	Xg==
X-Received: by 2002:a05:600c:c8d:b0:480:699c:abe9 with SMTP id 5b1f17b1804b1-48373a7b3f1mr202735645e9.37.1771327802456;
        Tue, 17 Feb 2026 03:30:02 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4835d99e194sm388582305e9.8.2026.02.17.03.30.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Feb 2026 03:30:01 -0800 (PST)
Message-ID: <1985145e-7181-40c6-821d-239f62410618@gmail.com>
Date: Tue, 17 Feb 2026 11:29:59 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH io_uring-7.1 v6 0/5] BPF controlled io_uring
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: bpf@vger.kernel.org, Alexei Starovoitov <alexei.starovoitov@gmail.com>
References: <cover.1770836401.git.asml.silence@gmail.com>
 <d56b5f70-382e-4017-81f4-c9ae7a6c1b56@gmail.com>
 <ab4c6ffd-d7d2-45fc-bbd5-b6663d5c41e2@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ab4c6ffd-d7d2-45fc-bbd5-b6663d5c41e2@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12284-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com]
X-Rspamd-Queue-Id: 74BF414B5D6
X-Rspamd-Action: no action

On 2/16/26 15:18, Jens Axboe wrote:
> On 2/16/26 7:23 AM, Pavel Begunkov wrote:
>> On 2/11/26 19:04, Pavel Begunkov wrote:
>>> This series introduces a way to override the standard io_uring_enter
>>> syscall execution with an extendible event loop, which can be controlled
>>> by BPF via new io_uring struct_ops or from within the kernel.
>>
>> Let me know if there are any concerns or comments. There are some
>> parts that I'll need to add like timeouts for waiting, but those
>> will be natural extensions, and this feels like a good base to
>> move forward in general.
> 
> I don't have any complaints on it, but would be good to hear from the
> BPF folks.

I assumed Alexei has nothing against it in general since he didn't
mention, and his last review was quite straightforward, I just applied
all changes. But I'm not sure if he wants to take a another look.

I'll send out v8 to silence smatch, and let's see if BPF folks have
time for it.

-- 
Pavel Begunkov


