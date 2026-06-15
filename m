Return-Path: <io-uring+bounces-13726-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id PVM4ETTfL2oFIQUAu9opvQ
	(envelope-from <io-uring+bounces-13726-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2026 13:17:08 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 95467685A5D
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2026 13:17:07 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LKDTr7fE;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13726-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13726-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4EAA3301FA7D
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2026 11:17:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 873D83E3C5A;
	Mon, 15 Jun 2026 11:17:05 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395663DC4DF
	for <io-uring@vger.kernel.org>; Mon, 15 Jun 2026 11:17:04 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781522225; cv=none; b=cM8kgq55O6dyP+FILVlv9TioQs5SfOpqchotYXy1yHvMrX1uD0uSjW8Yjmk+x0ymaaUDdTdFDSLE28rIXaEVVfiLTR+6GJq/XCD9mj2pR1+TrS7UwsNId4FVdZJxnYOZBIbrsFnjfY+i5rfgTo/c6+Ix3iyUgeo/P6Z6ZOYxBIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781522225; c=relaxed/simple;
	bh=d4RFhTaPxFFCmH6AlRCJafNoHTeDvIseqfsOBH9V82I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L+oE+hYkUtmryphhQWXGy75EgkW9/54v6cj9TONTxElvEuHfR9rex8irZ0SCdQNCPxQG8sKSoujB593cNVQTpQYotWthn8f2MPp08ddnFCFONALx2qzrZXaUpTKObIUujQgypB5cTEZ+1/or1hTf2kPEKOSb61jbe0xtKas9hLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LKDTr7fE; arc=none smtp.client-ip=209.85.208.42
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-68acf0a15b3so4838595a12.1
        for <io-uring@vger.kernel.org>; Mon, 15 Jun 2026 04:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781522223; x=1782127023; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sga08RS68cA7NsGgPks/diWwawk9O5eve5G9GV8WMYQ=;
        b=LKDTr7fEWxwmvA5GG6mIW3g8D/lRx7LfQF0YMWaRO3gpE/eSSI3oxDUOpRZwTyBPYA
         s4h6W/P5PeEN+/69Z1OHqsQNrnoeuJCD8aDSzSgUfreJbQi9t1LN3gYP2/ps3xEFP6Va
         Auc8CPdrAuZYG7SE4gwjCUKPSdCg2nSH3rBIHlvHkJWPvDx/EePNjOBr4Ym9Lzgy4lpi
         LVT1iyXxLv4P+lXRBxZjW8VLfGJSWx3YgYMvPHIoz7XdRhmLFzYgP2zZxKiXEBHzvc/X
         OcLmHQwFX7435NRiJIhXj1q1noDzr2zwkOE1GkTqMYiE/VhCeI/BEBqSgr37G2IjT56K
         jQ6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781522223; x=1782127023;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sga08RS68cA7NsGgPks/diWwawk9O5eve5G9GV8WMYQ=;
        b=DhpVoupvACl+ti7qUddUg8Oiwf5as488hbovCYLsclwPTbdNxPFGcJ2DaMtYIGtslW
         YD2sN3RC8D9ATbrfmVnEL8cxvkXwEGnoODQH2MAJd28DuSstFFXoyj6dfYBhL+y0d7u+
         x1OVnoJcyyUENWamlijcnllDZF9B+qlsyUNbm6dmKbc1EOxQlusT9UEfEHQkkkcoSQVb
         zGrKorIYzxsRout1P57FWnv/Mp4CLEkvyiu0Mlj6/FNUA2QaZ7nf029EEUpYaif569aJ
         zWulpE4ZNpZ2o9QdOEZDJmOshikMOmNmwcAtHUZWhE20r1hsRa8Xn1PU+OYg6633qda1
         3K1w==
X-Forwarded-Encrypted: i=1; AFNElJ8B4DVnyC74XLLcoaEHeor9tRoNC9wwBCGFqQBgVmmuCKCO+2/ZGJrY3HY/Mw+XK03u7ld3FFJMKA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxpWTsQiHOlYUCx5IGmRovXsDN6HBPw9hhFQ77QWUE7sG7xJeXB
	SCs7XwZbgg/p4y0/9rzdDj3v2ANnZzOw1D1Hx8OTmnxLsVRXsR66bQGv
X-Gm-Gg: Acq92OHFAGI0ZSpHPcJLtSNiVaqQqvQIqMeZnbNlmBZ/rbhaFCQcpIDY70gY0zy+vtd
	nRCXKCpPkWKSlnJTXdHOZvicR9gt7GpPLpJAU4NTDocKlrLTFUkxj1X7rX65BqxwqWtGsM8So8o
	M4JYDEl3qTl9Lq5elhaQv503QnBvA18h4v3PSxwx90T+2jiN3lhL/+k60TOaUap7DINFjie3dMN
	EY0HFesc+MZbnA7qqb8Q7ibVPIY+aes060BuLkXvue1Zwv7wl2fGBPyoHVnCBSoiibLkpqWvlje
	1Ayf4CUm117Q7PGbZxcCAUlO7kjlShGFTVwIQaJw7J3SleZc4w2i262bAH94KLpHOWUTe2RJ9j6
	TZ4epJcegN95alnG5pK7CidP5mVwiYKWUs+LzWYfbCQPFeX6mVhzQoSLsmFsociNt4D0PtSZp19
	w6eQVCjQspHR4A0V/n96nu/95iV96UotYQK+6YQXYNvWGEw66WMLcBqlGMoGxsV1HBc6Ex7EEqs
	mmosweynauH/Xf8MMniagXZYWBv9ctvJlakdqWQG9N1rYYkLAH72x0dAbw=
X-Received: by 2002:a17:907:c305:b0:bec:7661:6397 with SMTP id a640c23a62f3a-bfe2a222b62mr581935066b.29.1781522222408;
        Mon, 15 Jun 2026 04:17:02 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:2bf9])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bfdb4b2276fsm452438866b.17.2026.06.15.04.17.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jun 2026 04:17:01 -0700 (PDT)
Message-ID: <a773d177-82f3-4046-866d-852d0d83e08b@gmail.com>
Date: Mon, 15 Jun 2026 12:16:47 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v2 1/2] netdev: expose io_uring rx_page_order
 order via netlink
To: Jakub Kicinski <kuba@kernel.org>, Dragos Tatulea <dtatulea@nvidia.com>
Cc: Donald Hunter <donald.hunter@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Andrew Lunn <andrew+netdev@lunn.ch>, Jens Axboe <axboe@kernel.dk>,
 Yael Chemla <ychemla@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org
References: <20260612211709.1456966-2-dtatulea@nvidia.com>
 <20260612211709.1456966-3-dtatulea@nvidia.com>
 <d0401fab-61c5-43e7-93ae-d4757433eb7a@gmail.com>
 <b581d253-135b-4c75-a50d-2049c6d6e249@nvidia.com>
 <20260613170232.6f9e72ba@kernel.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20260613170232.6f9e72ba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13726-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:kuba@kernel.org,m:dtatulea@nvidia.com,m:donald.hunter@gmail.com,m:davem@davemloft.net,m:edumazet@google.com,m:pabeni@redhat.com,m:horms@kernel.org,m:andrew+netdev@lunn.ch,m:axboe@kernel.dk,m:ychemla@nvidia.com,m:tariqt@nvidia.com,m:netdev@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:io-uring@vger.kernel.org,m:donaldhunter@gmail.com,m:andrew@lunn.ch,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[gmail.com,davemloft.net,google.com,redhat.com,kernel.org,lunn.ch,kernel.dk,nvidia.com,vger.kernel.org];
	RCPT_COUNT_TWELVE(0.00)[14];
	FORWARDED(0.00)[lists@lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring,netdev];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 95467685A5D

On 6/14/26 01:02, Jakub Kicinski wrote:
> On Sat, 13 Jun 2026 16:09:03 +0200 Dragos Tatulea wrote:
>> On 13.06.26 11:53, Pavel Begunkov wrote:
>>> On 6/12/26 22:17, Dragos Tatulea wrote:
>>>> This adds observability for the io_uring zcrx rx-buf-len configuration.
>>>
>>> It might be nicer to look it up in the queue, e.g. rxq->mp_params,
>>> and make it a queue attribute instead of zcrx specific one. In either
>>> case, no objections.
>>    
>> In io_pp_nl_fill() or in page_pool_nl_fill() as it was done in v1 for order?
> 
> It's fine. We decided to make the "page size" a memory provider
> property, now we're going back to making it a queue level param?
> Like my RFC had that everyone hated so much? Sigh.

TBH, I never cared much how nl would show it, so not opposing either
version. My idea is that even without plumbing in per-queue non-mp size
configuration, it'd be nice to have a common way to check it b/w
providers.

 From the semantics and observability perspective, zcrx is probably not
that interesting as the parameter is basically just a hint with no affect
on uapi, and I'd assume people would rather see the page pool size or even
the NIC's page size. But I guess it depends on what Dragos is really after
with this patch.

-- 
Pavel Begunkov


