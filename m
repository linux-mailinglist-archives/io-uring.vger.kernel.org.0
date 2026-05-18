Return-Path: <io-uring+bounces-13382-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mLNYKTHcCmog8wQAu9opvQ
	(envelope-from <io-uring+bounces-13382-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 11:30:25 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A7A5C569BCD
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 11:30:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 2B1FE30136DE
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 09:24:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EA903E5A13;
	Mon, 18 May 2026 09:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AlgdSvCf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F4F3E51E7
	for <io-uring@vger.kernel.org>; Mon, 18 May 2026 09:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779096284; cv=none; b=M+nwUKB36LihQ7bqBo4ULpo1sSCsBs6DWsbfwFyqlOn39WL+KSc/UsG5BWa6RnfXeEZPbmzv6r8BzIWE6YVNsoRWW47a/icCJ/2qvcEjDo2tbRzDkre7LH3nEKr74hZvTvis12SFDF4Y5F/qIsso3bHYSNnpXWclz4MAMkj4igM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779096284; c=relaxed/simple;
	bh=aFahUNzTuRd9lUxR1CTcAQQJqOKmfE/dGIcc0XxoVMU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LcbGQpvp7Uei2RcRgFeDuUr2WXStsNdifZ6HUZDdZ2iyAjH+vNGBvSbsMb0Cc2eJz8c6zj6FSTRt6vm/Po+wy4T4p1HsQ6/tcxVnt/MY/T5tzKfBcPADmk2f5CY6+Y4TFsKmOWHN+XKhvVGjrAvCmWGbeypFd2ZRfJOZU5oqFcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AlgdSvCf; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-43fe62837baso1049145f8f.3
        for <io-uring@vger.kernel.org>; Mon, 18 May 2026 02:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779096281; x=1779701081; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8ZnntFD93TY8/+xleaPVExk6NAT6He9j34KXY+n97WI=;
        b=AlgdSvCf0TRu9rJVleCHIzTcmD0GE+h3APf3VOfOZ1cbKpW6GubpjmhF4EwezjT5Vt
         TFs148AA7KCfRr+bwmWp3MR9SeVp2uvP+/gyUY5RvFBzbx2+gE7bTh09tdzJtCLELo0Q
         uYfcJCy9co8Wmd78W0TW+VrsKOeFaP4DATPE+fE0duTTx8VKUBBegBIstHdXyVNG/jLe
         gR6QTjNp8CNjx8WObfme7ar4nvVxXSf7b8cPeyguI2sxfZRylKWUUlIDpwrd025MhsLo
         CWCZpDS2CHpDJZUhf6x3MUl5XT6+wbbN2PUag9gYzY4dNJatC6vz777RWxanc9PlAtOi
         IozQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779096281; x=1779701081;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8ZnntFD93TY8/+xleaPVExk6NAT6He9j34KXY+n97WI=;
        b=MRkSD6ZBnrU+OaDV9Z3lG2GlBSdzbWDwSZ8z9JfeKhkGeXnXv2KBV+zVlftQoNy+MQ
         aQmzIhfDOxs8aUP8u5ne+e/HaxpLGM8CFBS0OUnX7RlMTwlwlhlvN7ZaKmckk4EKPK7s
         LNjQKoQvmoGwvxQBST03YN8pZYZtDbajjCHjYsnUCIDdsHlj/8vUMDuPUfwZfq9TA0c2
         ZITfuW26iNaaH99OxgXQNSA9IGnkXjP1Raslsl60I6qgVtrTGCe0PoSyHGHfDxXl+ao+
         rIFwyAftCmU8zGHSz7d6BMTwAQgwfR20j/mrxfzOZW1P2TmczaAk4nDtY1GeN7F9yoRN
         +Pug==
X-Forwarded-Encrypted: i=1; AFNElJ+BV2yc1S4g1Sc+zhweGsB/XHxs/5FJ98f5W3Om/9dOfkg+9BABqOSxIahPbZPFZCJDGMW3hkRYmg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyMDkEjjobTQS3oeNtA3K/uoAeIkjyjbK+Evi/rsXPDIoZFrUx9
	sDClhVEsXHqSymtvH0Af8LJyAW7nevaph1zEeP0nBNBcKcMlmEEWFdv8
X-Gm-Gg: Acq92OF7iOWlrakOXn7zKXQXk2CpXYkSPOG9+Xgr8cGaC5M2VuR29F18p2HaNBbiY0O
	yef5RTuSMnnhsD5CN1JtId9VkZjopxufuQ1PDt135wb/WsHNMg25zzW40eedSyoio4ZLHP7bg9i
	TgWH8DxWBSqTxAcZwz89IGIJV/ODMiQeAQGZlB8igeYgwpcBjhTQuNg9GJggJOet7mJ2O3SSPRW
	KwzuXl9BpPiIpMwV4E+nfIfgeXk0AtuG0fu6RxdPnuq3OZsfd2hVc3I/Uo5znZWE5VOeHFn48DW
	Gyjk0yR+CeNSepN3zo6nKfDTbGk1hjK5bxNmuVTAh9ymh/9gyWaLW8854uTlmzwEsh/hc9evLEn
	FzLHgTVnffpBk2NZzEz2C209paQjF5NySgPeSIvvr3vHZo55H9r6T42X0DU+96Ui7LPaHe18onq
	KBJ3E7hhWEJMu0kvEFox7+jFg0gNmZgjL3mv7+JTed4ijBarraqECu044R1IiyCvxLiAdYx5Nhv
	Be/lVL2cyUewA4PeSPcAQXRBWPJ4DOlma14JYVsYravi2OMp9fiA0GkC38=
X-Received: by 2002:a05:6000:288c:b0:43b:962b:5314 with SMTP id ffacd0b85a97d-45e5c372a9cmr22814328f8f.19.1779096280750;
        Mon, 18 May 2026 02:24:40 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:6e9b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45e6a135f0csm17325957f8f.27.2026.05.18.02.24.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2026 02:24:40 -0700 (PDT)
Message-ID: <4b2f74e9-3225-47f6-85fe-911720030e35@gmail.com>
Date: Mon, 18 May 2026 10:24:35 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/10] iov_iter: add iterator type for dmabuf maps
To: David Laight <david.laight.linux@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
 Nitesh Shetty <nj.shetty@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>,
 Anuj Gupta <anuj20.g@samsung.com>, Tushar Gohad <tushar.gohad@intel.com>,
 William Power <william.power@intel.com>, Phil Cayton
 <phil.cayton@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
References: <cover.1777475843.git.asml.silence@gmail.com>
 <20a233d2f35274817aa643cc0fe113707eb47e72.1777475843.git.asml.silence@gmail.com>
 <20260513110557.705bdeed@pumpkin> <20260513142909.03ae6c2b@pumpkin>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20260513142909.03ae6c2b@pumpkin>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A7A5C569BCD
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13382-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[25];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Action: no action

On 5/13/26 14:29, David Laight wrote:
> On Wed, 13 May 2026 11:05:57 +0100
> David Laight <david.laight.linux@gmail.com> wrote:
> 
> ...
>>> @@ -575,7 +575,8 @@ void iov_iter_advance(struct iov_iter *i, size_t size)
>>>   {
>>>   	if (unlikely(i->count < size))
>>>   		size = i->count;
>>> -	if (likely(iter_is_ubuf(i)) || unlikely(iov_iter_is_xarray(i))) {
>>> +	if (likely(iter_is_ubuf(i)) || unlikely(iov_iter_is_xarray(i)) ||
>>> +	    unlikely(iov_iter_is_dmabuf_map(i))) {
>>
>>
>> Doesn't the extra check add more code to all the non-ubuf cases?
>> This could be fixed by either making iter_type a bitmask (with one bit set)

Not going to do that. It was specifically converted from bitmask
before, and the check optimisations like this were voiced back than.

>> or writing an iter_is_one_of(i, ITER_xxx, ITER_yyy) define that uses
>> '(1 << i->iter_type) & ((1 << ITER_xxx) | ...)'
> 
> This seems to DTRT:
> 
> #define _ITER_IS_ONE_OF(iter, t1, t2, t3, t4, t5, t6, t7, t8, ...) \
>      ((1u << (iter)->iter_type) & ((1u << ITER_##t1) | (1u << ITER_##t2) | \
>          (1u << ITER_##t3) | (1u << ITER_##t4) | (1u << ITER_##t5) | \
>          (1u << ITER_##t6) | (1u << ITER_##t7) | (1u << ITER_##t8)))
> #define ITER_IS_ONE_OF(iter, t, ...) \
>      _ITER_IS_ONE_OF(iter, t, ## __VA_ARGS__, t, t, t, t, t, t, t)

We definitely don't want that, using them directly would've been
much cleaner.

if (get_type_mask(i) & (TYPE1 | TYPE2)) ...

-- 
Pavel Begunkov


