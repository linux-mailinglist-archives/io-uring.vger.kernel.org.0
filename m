Return-Path: <io-uring+bounces-13440-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2Jh5Mw2IDGo1iwUAu9opvQ
	(envelope-from <io-uring+bounces-13440-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 19 May 2026 17:55:57 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 937D6581D14
	for <lists+io-uring@lfdr.de>; Tue, 19 May 2026 17:55:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 963B8305AD3A
	for <lists+io-uring@lfdr.de>; Tue, 19 May 2026 15:43:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE6532F4A14;
	Tue, 19 May 2026 15:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="kMhwL/Iq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB1626FA60
	for <io-uring@vger.kernel.org>; Tue, 19 May 2026 15:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779205395; cv=none; b=HEP3wiqf4Qu7Xc1lypZBhCkObN+WPQ6rMhhFVOcqNve8tLHaCo+px/6l00/f8sNwbHqNMkvERu/1XR5pQ+Rgc4G2kwlPKuczjshFZ3CN3jl/cdb0gFXvGfmUT6aOILffjnGJaIAPzs7dcm2GmTP5If0QE1hXq9RfmHHTo8Qbdwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779205395; c=relaxed/simple;
	bh=G/7XVZC4FDtV3QjaP9/dyeOQh4gr39OaZNtRC4VeFTc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ixAaO1UrPylBJLNUpXnGUS5VISqXMPdm7IEE7Bsct4FplcMegHOWgOkAZ3k2bqAxzx3b+z9B3axvkQwYuq7YBx5Hc71GIwJb+6T7MyGKBSkIFqNqrSgfH2L/sZpzCMSJ4U1simmj+OslxnsYIz/5wtFtaD75Fso3ilovgN80sOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=kMhwL/Iq; arc=none smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7dbd23bc684so1996433a34.2
        for <io-uring@vger.kernel.org>; Tue, 19 May 2026 08:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1779205393; x=1779810193; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u9JaArJrMzxRkLIleuzE0wCjfnbwwuVxD7ruLv1TUho=;
        b=kMhwL/IqvWEkY918wPhuTeASxPkmrRsQLDsjcJUiajr0iUENHWBO8lGAr8A6/+G/lp
         Gpt203KYQdr2uZHfLuM+5uXeac77IeOMibGE/6X3+iGVIUfxtxUP3CdW5jpQof1o+lpc
         kBgB8SgRZG+9f05Mr4I5dNT+9bPy3tN+5J0Xz6aGOw1DM02f7c1LqcqRJ4F9cQdJc2do
         y6AhbgsQ/xlWcbVdwNeNBBs+xqJKgWUb/tsSkC+Jd4oNnq9x+hUrPhSx9UpJdESz9tRT
         lzRlhKAV36s87JFCpGMJjFaRnG7EH4tbcfHkz8BMq2uWxKmDA9c0aY1Rw+NpZQtL4Ge1
         tLLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779205393; x=1779810193;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u9JaArJrMzxRkLIleuzE0wCjfnbwwuVxD7ruLv1TUho=;
        b=nP6UR7ohMKMI/w5mORjQ6ATON4G+BE4veVzVN6hawifqtFc/V1PK6SooZMyeorvzyG
         y+fdk8bVrr9oEQdtfhJNZR9viQ+l3zQib06t9TWvz2CzdFnKJWi1EaJQJgXpg0Nu4Vwp
         4upw/4AAqrVa6GrLDP/2v/QpsfWAeQgucmXEn7wGuI896oifCTPrBlObYNBZ49cwKUp4
         ezfstnKaS+hwT0Dy9uQAlbdgVgP99nenHMZqJ9Y56TtraFSPOmScPPEh06wtp/r+Z7hg
         uWdGpW34smPQS/WcfMmo4OlgKP1vReuTtx9KY2XGZ2G+fpjQwAdllS999Utwmp+v5cBO
         eOQA==
X-Forwarded-Encrypted: i=1; AFNElJ+rV+Slt19kMK6oMg6Iwm6oXK1Ql8CoK/C+96zXiz6J2ZqJP4bBmTLt0K0ez8N+HVI/dxRdkSgDtg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzO+Az1rYaKqJk6aFR7iBwHMBtOtp/W2ojaCh7G322UyOKMlfZA
	DXCoYGfk/rNSG2ShzDtEGh73AIKG/EGFEoCjF0u58dYtq+Og0zs3SXothTlGROn6q10=
X-Gm-Gg: Acq92OGAXbHNKlpDzSPJPm2CsfeYqf0Ni8j+YNZlu/+K4p2k8blEeyYKPkqUXx+z4CS
	ZBmxUf5DnHEyfUkWnm1gI9NXHuINpnmOZIv1M184LKsc+fZvTJxeWlzWwogxXgdN7ZPTlNTH9TF
	/2p6HUIZDlhqzAlLCX3S6gjtfAGhc7vGtQahbfwE6IOVlf/YGuAs3bqI32rhLfcIzXSHDqmWMUy
	CKHAjVYSde3uSzN75/mUQbD4ES9iI+8vz77n2y43ebZlfWRztygL+A4dZ9nCzrbGG8yu+rxKHpI
	NrJamxGmO1kJC1CqdA2heFisMO07aE4PoPlZe8rAHJAai7IACBdBoTPS+EguGdg52dwUy+BTY90
	6KYwahmrB2XPvqDld7195itxazM4bS5+qQoSCXpRWh+YWOJ5Wu21ejvywy1UJ//h3ISm7eo3N3g
	X1Fao6/3hPaID/Wex0ftk6T1bTxlXqURMMXwHSvk5csmT4nSiiqq/GD817y2UkW85vC1PvAm7xW
	HD7G812
X-Received: by 2002:a05:6830:67d1:b0:7dc:dd19:7f53 with SMTP id 46e09a7af769-7e4f2b865c4mr13521733a34.14.1779205392795;
        Tue, 19 May 2026 08:43:12 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e55b7c6b38sm10304383a34.2.2026.05.19.08.43.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2026 08:43:12 -0700 (PDT)
Message-ID: <2305e4d6-55cf-421c-94b0-ad8aae8db99c@kernel.dk>
Date: Tue, 19 May 2026 09:43:11 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/8] io_uring/zcrx: notify user when out of buffers
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: netdev@vger.kernel.org
References: <cover.1779189667.git.asml.silence@gmail.com>
 <35cd307a03a43583838a2e151fc641c69abd786f.1779189667.git.asml.silence@gmail.com>
 <7bfd707b-1e21-413e-a2e7-71e8df3e43d7@kernel.dk>
 <6d1187c8-ba4f-41ad-b692-351d8b072038@gmail.com>
 <a2a92049-0974-478a-9297-76af96b455d8@kernel.dk>
 <c8a21efc-1443-4ff2-ac53-7846533a26bb@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <c8a21efc-1443-4ff2-ac53-7846533a26bb@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13440-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,kernel-dk.20251104.gappssmtp.com:dkim,kernel.dk:mid]
X-Rspamd-Queue-Id: 937D6581D14
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 5/19/26 9:40 AM, Pavel Begunkov wrote:
> On 5/19/26 16:37, Jens Axboe wrote:
>> On 5/19/26 9:30 AM, Pavel Begunkov wrote:
>>> On 5/19/26 16:26, Jens Axboe wrote:
>>>> On 5/19/26 5:44 AM, Pavel Begunkov wrote:
>>>>> @@ -1126,6 +1142,48 @@ static unsigned io_zcrx_refill_slow(struct page_pool *pp, struct io_zcrx_ifq *if
>>>>>        return allocated;
>>>>>    }
>>>>>    +static void zcrx_notif_tw(struct io_tw_req tw_req, io_tw_token_t tw)
>>>>> +{
>>>>> +    struct io_kiocb *req = tw_req.req;
>>>>> +    struct io_ring_ctx *ctx = req->ctx;
>>>>> +
>>>>> +    io_post_aux_cqe(ctx, req->cqe.user_data, req->cqe.res, 0);
>>>>> +    percpu_ref_put(&ctx->refs);
>>>>> +    io_poison_req(req);
>>>>> +    kmem_cache_free(req_cachep, req);
>>>>> +}
>>>>> +
>>>>> +static void zcrx_send_notif(struct io_zcrx_ifq *ifq, unsigned type)
>>>>> +{
>>>>> +    gfp_t gfp = GFP_ATOMIC | __GFP_NOWARN | __GFP_ZERO;
>>>>> +    u32 type_mask = 1 << type;
>>>>> +    struct io_kiocb *req;
>>>>> +
>>>>> +    if (!(type_mask & ifq->allowed_notif_mask))
>>>>> +        return;
>>>>> +
>>>>> +    guard(spinlock_bh)(&ifq->ctx_lock);
>>>>> +    if (!ifq->master_ctx)
>>>>> +        return;
>>>>> +    if (type_mask & ifq->fired_notifs)
>>>>> +        return;
>>>>> +
>>>>> +    req = kmem_cache_alloc(req_cachep, gfp);
>>>>> +    if (unlikely(!req))
>>>>> +        return;
>>>>
>>>> It'd be nice to avoid an allocation here inside ctx_lock and with bh's
>>>> disabled, which looks like is also the only reason why GFP_ATOMIC is
>>>> being used here.
>>>
>>> I thought about it, but it's already bh, it'd need to do pre
>>> allocations + caching to be reliable, but that's left out for now.
>>
>> Not sure I follow - GFP_KERNEL would be more reliable than GFP_ATOMIC.
>> What's the contract in terms of the notification? If we fail the alloc,
>> then userspace can't rely on the notification on the refill failure.
>>
>> Are we under bh save already here, before doing it ourselves? If so,
>> then how does the guard work?
> 
> In 99% of cases it's called from softirq, not sure what you mean
> by how it works.

Ah ok, I thought you meant it was already called with softirqs disabled.
In which case the guard would seem broken, as we'd enable softirqs when
exiting. But if we're just inside softirq yeah it's fine, and there's no
point shuffling the allocation either.

Question on the contract still stands, in terms of missing a
notification. I guess since it's a hint basically it doesn't really
matter, just something that should be documented on the userspace side.
Do you have test cases for these?

-- 
Jens Axboe

