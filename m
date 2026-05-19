Return-Path: <io-uring+bounces-13442-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +D59N8eMDGokjAUAu9opvQ
	(envelope-from <io-uring+bounces-13442-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 19 May 2026 18:16:07 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 622485821AF
	for <lists+io-uring@lfdr.de>; Tue, 19 May 2026 18:16:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3C1E930DA3E8
	for <lists+io-uring@lfdr.de>; Tue, 19 May 2026 16:08:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F33A3F7A99;
	Tue, 19 May 2026 16:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iv2H5Lab"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6171400E10
	for <io-uring@vger.kernel.org>; Tue, 19 May 2026 16:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779206890; cv=none; b=u01d0f/fnngAlNhVT7/K76QCsN7/afIuG60vurbrgm6djF7QT+/wTB+UJF4opofF6KKzosxCTf+w0QxRiaHFFkb32Whb4CMBZ6Z8gyM0UYQueXzLrVCfuv2sc34X4hAWOvwmVjIGcFEZwKRa1RgojDAHqzrKC7V87PJulZJTMKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779206890; c=relaxed/simple;
	bh=UuyF9HSNLo2vfD4Gvn/2sLT/MUfk98mNlM17lhTaJNc=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=kJqkedkTIz8t2nP3f/UaQKF5bv2LQUGV7004lKcmPBjocEwEcrCfOM7Fxgd86EXkOYk03uGoJUnbTOT0r9Ygpcd8S2QE+0ZvPXay5ksQdSOERS6bk+5Y0+LZ+Ap/qgVeDemXqBzCuNZKToB9Mvkgz5aq4COGYEwG8ZL+/OAUDzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iv2H5Lab; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-44a5174670eso2135170f8f.1
        for <io-uring@vger.kernel.org>; Tue, 19 May 2026 09:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779206886; x=1779811686; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ubhMnVbQfORgfno1r5ieAcypoEGZy/A2m77VzqQGjb8=;
        b=iv2H5Lab86i7Gdw0bqr7rsEeGeLjZ8HBemJOByB1mIpVPTXLR9Bi773Y2lAKc+LLZ8
         7BESIL54l0fAlIlJCVAPCH7qLqjCvy6zErIhlQjlRq5MkyDJbhzn3bHd76kTdIS5+Fk0
         XNNu+/u2y2+n2ITeD80H051y8DIUqnjXWYa2M7MaGHQmHjdBV4g/bynqXdqX3G6EWfT5
         Woq/Im4/0l0N0Le/9v2DTbmQc5pE8k8+vMjsQ92Th18s66XE/i72qDp8o5pVWZkWKTFw
         d052IkPo/mlYBSj+G1p4CWs3Tg6aLwQb2+zR20+Hn2LUAKBvwsDD3g+qcu1KlUz4s/BM
         KJWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779206886; x=1779811686;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ubhMnVbQfORgfno1r5ieAcypoEGZy/A2m77VzqQGjb8=;
        b=i4lo3CzxeZSikpfow0DHa7wbMbUkXjyXyURkxZItS/huxXRx3yGlknvwH+NYlwGNIE
         FB3ZOkgWUw8IFnjkXltP2JhAq9lIsfLxOOAfUwKBCZcqlfkq+o+OIEemmp3BUg202AFb
         6uruJWh6+NrLRtDh7c+XUgWH8JIyqM1Y3pZhdrF2g9eYfP/6I7mm2OKAXxK3KIuaQPqj
         TSTEddC3+i6eYZD8wUz5g6ZxCUbEd2RGq7zZk9yJF5+sZIbKTNEJ/EheYy05yHmUcYpg
         wWGwutvxJvayj2/pV6O33kBLsE02vJ8YQpdx5oWB3ujXJLEa4etlxZcG8VhP1mWV/u/A
         YZvw==
X-Forwarded-Encrypted: i=1; AFNElJ9sONfgGSpQV6J3vpztZwMgcthz48Hby52G5jzAOp7MPvuLzW0XXZLpyLC/9mztb3UfSGxl5j3zWw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxrwayb2ZmiOEYr2BJrl5H0djpWOPQgLMiVHnq4qBW8QBDp+r0k
	+cIlE48vBmI4pnpMrthwoLHP/ux+nj4iNNjZzPWtEbS9uI0L2O3JVK7ED45PRA==
X-Gm-Gg: Acq92OFGynjbDPlnQMpNi6Fuf5ZyYWKIlh1tGKUHG5O5gIN6msLBtISqaitwpssn6IB
	Ci5hAGR72txpb0swi/YxEcJSxqnO3Y1ENqXrRB4MA7ndv0A2XZd2nN4FuKkGYzM/lxf8HxAeQqw
	R5c5eYsESRnpyCScW5U0Iz2RvpmETksFXVLaH7wWvZ8TqGSCk7BSMWv1SmNa906MKdpzMK/RU1F
	KsVyIARxstq8FZg2tyb11MBrfvOwJ8/L1TqZ0l4whUJ1Jacw/H2MFpuH7yHQbJrNal8NtYIeh0u
	dVy/C+uLwwG9oJW/fB++D2TP14MMlGakLCRtrI3r6OPXSGbJjbbnlzQm+JXwLtm44cbX9d/676k
	aiXGV+4/fgwd5iZoHVyPJFA86TiXbeY0TuKwrnETouSUgu/Tr9iU5LbPIisQKPuS4lrbkJWi0Cy
	VV68Qz8I/lnBkazRFwMmMa3yrP4Oa2LqLg3UAJ23SVwOn4Izw5pFPwVigJ3UiL7JS9yN7QKAmnP
	p5RjrHUcJ5OTCMwQpyjwdxw5XYaSa7pwxx6eGfyxxNXk4TZStj03qtNziLmYPUeN6sMjvcm5Yjx
	Rg==
X-Received: by 2002:a05:6000:2584:b0:43d:7783:c684 with SMTP id ffacd0b85a97d-45e5c5e6d3dmr33130978f8f.43.1779206885595;
        Tue, 19 May 2026 09:08:05 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45d9ec3b18fsm43195577f8f.11.2026.05.19.09.08.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2026 09:08:04 -0700 (PDT)
Message-ID: <57122bd8-034a-4f12-b1f7-641798252044@gmail.com>
Date: Tue, 19 May 2026 17:08:01 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/8] io_uring/zcrx: notify user when out of buffers
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: netdev@vger.kernel.org, =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?=
 <cleger@meta.com>, Vishwanath Seshagiri <vishs@meta.com>
References: <cover.1779189667.git.asml.silence@gmail.com>
 <35cd307a03a43583838a2e151fc641c69abd786f.1779189667.git.asml.silence@gmail.com>
 <7bfd707b-1e21-413e-a2e7-71e8df3e43d7@kernel.dk>
 <6d1187c8-ba4f-41ad-b692-351d8b072038@gmail.com>
 <a2a92049-0974-478a-9297-76af96b455d8@kernel.dk>
 <c8a21efc-1443-4ff2-ac53-7846533a26bb@gmail.com>
 <2305e4d6-55cf-421c-94b0-ad8aae8db99c@kernel.dk>
 <7db0d602-bbbd-4554-996c-1dcefd69e2bf@gmail.com>
Content-Language: en-US
In-Reply-To: <7db0d602-bbbd-4554-996c-1dcefd69e2bf@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13442-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_FROM(0.00)[gmail.com];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 622485821AF
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 5/19/26 17:04, Pavel Begunkov wrote:
> On 5/19/26 16:43, Jens Axboe wrote:
>> On 5/19/26 9:40 AM, Pavel Begunkov wrote:
>>> On 5/19/26 16:37, Jens Axboe wrote:
>>>> On 5/19/26 9:30 AM, Pavel Begunkov wrote:
>>>>> On 5/19/26 16:26, Jens Axboe wrote:
>>>>>> On 5/19/26 5:44 AM, Pavel Begunkov wrote:
>>>>>>> @@ -1126,6 +1142,48 @@ static unsigned io_zcrx_refill_slow(struct page_pool *pp, struct io_zcrx_ifq *if
>>>>>>>         return allocated;
>>>>>>>     }
>>>>>>>     +static void zcrx_notif_tw(struct io_tw_req tw_req, io_tw_token_t tw)
>>>>>>> +{
>>>>>>> +    struct io_kiocb *req = tw_req.req;
>>>>>>> +    struct io_ring_ctx *ctx = req->ctx;
>>>>>>> +
>>>>>>> +    io_post_aux_cqe(ctx, req->cqe.user_data, req->cqe.res, 0);
>>>>>>> +    percpu_ref_put(&ctx->refs);
>>>>>>> +    io_poison_req(req);
>>>>>>> +    kmem_cache_free(req_cachep, req);
>>>>>>> +}
>>>>>>> +
>>>>>>> +static void zcrx_send_notif(struct io_zcrx_ifq *ifq, unsigned type)
>>>>>>> +{
>>>>>>> +    gfp_t gfp = GFP_ATOMIC | __GFP_NOWARN | __GFP_ZERO;
>>>>>>> +    u32 type_mask = 1 << type;
>>>>>>> +    struct io_kiocb *req;
>>>>>>> +
>>>>>>> +    if (!(type_mask & ifq->allowed_notif_mask))
>>>>>>> +        return;
>>>>>>> +
>>>>>>> +    guard(spinlock_bh)(&ifq->ctx_lock);
>>>>>>> +    if (!ifq->master_ctx)
>>>>>>> +        return;
>>>>>>> +    if (type_mask & ifq->fired_notifs)
>>>>>>> +        return;
>>>>>>> +
>>>>>>> +    req = kmem_cache_alloc(req_cachep, gfp);
>>>>>>> +    if (unlikely(!req))
>>>>>>> +        return;
>>>>>>
>>>>>> It'd be nice to avoid an allocation here inside ctx_lock and with bh's
>>>>>> disabled, which looks like is also the only reason why GFP_ATOMIC is
>>>>>> being used here.
>>>>>
>>>>> I thought about it, but it's already bh, it'd need to do pre
>>>>> allocations + caching to be reliable, but that's left out for now.
>>>>
>>>> Not sure I follow - GFP_KERNEL would be more reliable than GFP_ATOMIC.
>>>> What's the contract in terms of the notification? If we fail the alloc,
>>>> then userspace can't rely on the notification on the refill failure.
>>>>
>>>> Are we under bh save already here, before doing it ourselves? If so,
>>>> then how does the guard work?
>>>
>>> In 99% of cases it's called from softirq, not sure what you mean
>>> by how it works.
>>
>> Ah ok, I thought you meant it was already called with softirqs disabled.
>> In which case the guard would seem broken, as we'd enable softirqs when
>> exiting. But if we're just inside softirq yeah it's fine, and there's no
>> point shuffling the allocation either.
> 
> Softirqs are run with bh disabled, but bh_disable()/enable() are
> reenterable.

Better to say they're counting nesting

>> Question on the contract still stands, in terms of missing a
>> notification. I guess since it's a hint basically it doesn't really
>> matter, just something that should be documented on the userspace side.
> 
> Should rather be improved than documented, I'd say, but it's still
> better than not getting anything at all. And it's the only place
> where it can in theory be dropped, e.g. CQE overflow handling,
> though different GFP.
> 
>> Do you have test cases for these?
> 
> Clement needs to resend them. Actually, seems I forgot to CC Vish
> and Clement here, my bad.
> 

-- 
Pavel Begunkov


