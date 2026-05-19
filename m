Return-Path: <io-uring+bounces-13438-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8HVkJpWGDGo1iwUAu9opvQ
	(envelope-from <io-uring+bounces-13438-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 19 May 2026 17:49:41 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 959AC581BB2
	for <lists+io-uring@lfdr.de>; Tue, 19 May 2026 17:49:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 86597302D33E
	for <lists+io-uring@lfdr.de>; Tue, 19 May 2026 15:37:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBF1D28000F;
	Tue, 19 May 2026 15:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="KxBhdtsF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2134121ABBB
	for <io-uring@vger.kernel.org>; Tue, 19 May 2026 15:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779205030; cv=none; b=GXx118a6xvT+1f0sM18p95YTNhackj9VtAOzD8jGKPwejQ0pGzCX8pIsoG7btP+AxE0F/wYCnbATuJpZ86s8N4qaNjldHBXV+CHmweMJtGNz3HsurkrOQg66zkMCdWX5Fc6vj6fL9V4Hfr9zGvbf/F9wm9pnM0BHQ1d/yOMvEmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779205030; c=relaxed/simple;
	bh=F6OlfBKiNsylIrupucoxYn/nGc3mFSZIztHNwtP9mOE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sGt0zYEYkvqdUOtpM+tWLJCMOtLTgiBqk4ESWAKyJzx6Lody4qDUfV3mVo2E19Z8OrHSiDGXjY6vUGwtOj47PopBoVbKUK1aC6cuJB75YR4W05XYeRllV550dEaLg8DA11DWX/nGNd/97it23LGPZupZxGfi28oP9pHDXyeiWpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=KxBhdtsF; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7dbd23bc684so1991011a34.2
        for <io-uring@vger.kernel.org>; Tue, 19 May 2026 08:37:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1779205027; x=1779809827; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cAmxlcoFo23JCvyuJi7CgaBoDD5EitgK/qfPK6YkFWc=;
        b=KxBhdtsFCsBKbvbN6vH+wINgUtpP7A3DqU/7IoEVRecAo/4ulQcTX96BAzK4UqLZ0p
         O3wjbJCqVknODHbjPjvCX2zggo23BlXB5N7z015WlmUYlFI6BCzxGylIfIyOBs+KoM+r
         CiIY8Dc2JMDsuueYJkIDaGfLnxkv7N5sJZcX7IFktYPniAOeAmf9zuw2mmM8hAAuDv4E
         YiifeUQqtPYfRkHm87E0hC0ku8wdZ96qnFCPOihOGjJDOWRDKu6LLVtpULJOU9nSv5O5
         Ec4jmATYTL/oDg2sKUG0UjmwlDNAXSKjnyOGsioSTYXTHwDz9A//2R/+Us11xyHRwwIp
         i5xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779205027; x=1779809827;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cAmxlcoFo23JCvyuJi7CgaBoDD5EitgK/qfPK6YkFWc=;
        b=VImwB8qonxz8RN3R/Kq0+vUuEbzB20yHFli63DQc2G01NQj8uovU6K1SmbjYg6ORTa
         YFkSPoRClBVOUtZUVQtfOFmfkTd2hp9KOacXQJmTTCCWCEPrQICQY3ZRGnVP9TQEsWfL
         GF5Ujdjmku5DskrWg/MUOmxvZeYPul5+lUb9+IXyUtBgoOzVV9Mw3afMiXxZuMAaxq2d
         mAZLvsbEhDXep1NPNgWDBBq7tr3fdwurr91u61zz2lYqQIK8JjZgyLN+7lnTwavaG8yL
         kNWK2N7ZSY/z119upZqlhNo4mZiPL2HWvhUU9pmQHv/NulDh7mMcGCaTS16D5WsOd7S+
         c9Pg==
X-Forwarded-Encrypted: i=1; AFNElJ8mjDSWJ//e7FWVE9H7Xwet5/QzsSohQWGmHjt9C2/SiBGZQVsFjmPxkHXs0dY9JDM0nJP/bwalsQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwkyETgcfZMhBlmx326OHvOtBO4oJ9TDnUfVhc3yAsRPhZj5VPO
	6h17GYd1avYyFwC39NRnjlN3P6XrsOLQa3J+wVotHkz4Hav/cb3rsXAmEkNrMFd6KPc=
X-Gm-Gg: Acq92OHwEOO2RPwWMZqlRw0IeonQo2xNacSFpwsrwVtyrFdI3yQLlfNSdutsXWRpaB4
	Bpa/TELcrOuNAk8+PmP8KC6dZOmDWWiYCTHk1l88eDfB0OaYJB/zoI/dFVHPjFaqM115xGl3krW
	B3xsxo4azngg+KY3CMvM8cWcbXL/BTdKJSGgJpS+xuj5joZw80J5e/2PKaVUl+0OdHCEUqmFmnO
	Hom6OHxcJbjId0dodvTVpvccdp0mEA4da8TzMRtImTHzTUkc6M4ulZPr4H+u4BXfOcRDRf8bXMe
	Fbl2bcCD1ySjwRym9TUZJYvREDRNJnS45nQre7X+0Xe3V0wwbEc5J5PUKesdELfDAsE4yjeImxz
	3zqiBKo3guU+FIb8811tbyzpOWwVgqA4gUFBgZn5+suao8MzxdxAViRijVuJxq30GaSdk05ExYh
	NjWeVmhCdfejBVDI9AQSOkSLKX+WCHZbs9JnndzhsxUFOreXRznkKfPtys+BcRHva+VdW1xVoOF
	8G2KUSU
X-Received: by 2002:a05:6830:d8a:b0:7e4:de59:4202 with SMTP id 46e09a7af769-7e4f2b82e66mr12919218a34.12.1779205027065;
        Tue, 19 May 2026 08:37:07 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e568e92e54sm8464198a34.24.2026.05.19.08.37.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2026 08:37:06 -0700 (PDT)
Message-ID: <a2a92049-0974-478a-9297-76af96b455d8@kernel.dk>
Date: Tue, 19 May 2026 09:37:05 -0600
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
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <6d1187c8-ba4f-41ad-b692-351d8b072038@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13438-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,kernel.dk:mid,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 959AC581BB2
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 5/19/26 9:30 AM, Pavel Begunkov wrote:
> On 5/19/26 16:26, Jens Axboe wrote:
>> On 5/19/26 5:44 AM, Pavel Begunkov wrote:
>>> @@ -1126,6 +1142,48 @@ static unsigned io_zcrx_refill_slow(struct page_pool *pp, struct io_zcrx_ifq *if
>>>       return allocated;
>>>   }
>>>   +static void zcrx_notif_tw(struct io_tw_req tw_req, io_tw_token_t tw)
>>> +{
>>> +    struct io_kiocb *req = tw_req.req;
>>> +    struct io_ring_ctx *ctx = req->ctx;
>>> +
>>> +    io_post_aux_cqe(ctx, req->cqe.user_data, req->cqe.res, 0);
>>> +    percpu_ref_put(&ctx->refs);
>>> +    io_poison_req(req);
>>> +    kmem_cache_free(req_cachep, req);
>>> +}
>>> +
>>> +static void zcrx_send_notif(struct io_zcrx_ifq *ifq, unsigned type)
>>> +{
>>> +    gfp_t gfp = GFP_ATOMIC | __GFP_NOWARN | __GFP_ZERO;
>>> +    u32 type_mask = 1 << type;
>>> +    struct io_kiocb *req;
>>> +
>>> +    if (!(type_mask & ifq->allowed_notif_mask))
>>> +        return;
>>> +
>>> +    guard(spinlock_bh)(&ifq->ctx_lock);
>>> +    if (!ifq->master_ctx)
>>> +        return;
>>> +    if (type_mask & ifq->fired_notifs)
>>> +        return;
>>> +
>>> +    req = kmem_cache_alloc(req_cachep, gfp);
>>> +    if (unlikely(!req))
>>> +        return;
>>
>> It'd be nice to avoid an allocation here inside ctx_lock and with bh's
>> disabled, which looks like is also the only reason why GFP_ATOMIC is
>> being used here.
> 
> I thought about it, but it's already bh, it'd need to do pre
> allocations + caching to be reliable, but that's left out for now.

Not sure I follow - GFP_KERNEL would be more reliable than GFP_ATOMIC.
What's the contract in terms of the notification? If we fail the alloc,
then userspace can't rely on the notification on the refill failure.

Are we under bh save already here, before doing it ourselves? If so,
then how does the guard work?

>> Maybe opportunistically check ->fired_notifs early? Might also avoid the
>> lock in the first place if we get back-to-back of these.
> 
> Slow path, doesn't matter

Agree, not a huge deal as we hope to not hit the notif path.

-- 
Jens Axboe


