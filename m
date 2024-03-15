Return-Path: <io-uring+bounces-1000-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 33C2487D751
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 00:26:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BE6E41F21C60
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 23:26:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8664759B71;
	Fri, 15 Mar 2024 23:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Zps4CWfS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0225854745
	for <io-uring@vger.kernel.org>; Fri, 15 Mar 2024 23:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710545159; cv=none; b=RvXjJ9NiyenJisxkSUit/Nn0yjHeJ70M+uNZyMZpALsVax1RyfcW5cM53ywyedrsZLuSHzdmYSYubyZxaHFnV+b68OZNeyv5zHFYvRBvKWxGOy5fcOAefKqnK+Hx+ewGBNg8AMXgs2Prl2DsSy9r5EAnDtN38tNCSms2IFjMCK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710545159; c=relaxed/simple;
	bh=tpStGezX4SOA79yqszxVbyhWioAGvZnJl0dgcptoqhw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=DiU48MZ6X7XM457/P1pjyGxGXg6KRojAGdt2NMMrs+df6WaHLHTpzh0xbFwpJRQdHpxy9PV1hX2hf4jK0IQqtaFgnBo0xs3agIHMAoYM3Zg5cpzijuaJfxD2vTCRhwfNZP+SYBce6S/u2FsjaYzXcY5kWDg6ji54nn3QBECqO3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Zps4CWfS; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6e696233f44so600597b3a.0
        for <io-uring@vger.kernel.org>; Fri, 15 Mar 2024 16:25:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710545156; x=1711149956; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ITiFP+WCtKVI+fGX175g1DPu5XIDUMyGy9HnvF9cJcQ=;
        b=Zps4CWfSuEwn+I9ok8AyjV2PmlN6Rf8Dxk7aVlgv1pFk01ocR0+PVaBgVS2WoeF4qb
         sr9rlpp6f9+596s6y3v1GtTlXbewmhJYKz3e5bPY6OeFVuXniC9weKLPRtd0/CiyFBLz
         26cQKj05PcFyBXpbAbSLlxMIQurMEH2EchDDbrcJUX4ncO/j0x+ABUyBwHlUPn660k8H
         zX2fGnvCdTY2Z0qwdeNf3xF0uCe1xPa9pdOEx+y/OcHTUIVhVNUGtJQL2O9f3RHpBtfI
         mLYvqUIwXKpnZM8+DNNuTNX9YHqZYT2qCFzz8RDg093afgSmSgDKLD9iCWZt83UvyNnQ
         SOIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710545156; x=1711149956;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ITiFP+WCtKVI+fGX175g1DPu5XIDUMyGy9HnvF9cJcQ=;
        b=tY7oNIMTj2z1DuiEpTq5dymJXIyvXGrPQn/2P4fi7tW1ja0jC2SrqH/i7V6xiZej+U
         m01B+KfCDOhGlDLEpCVYYYL07QsvhJGw3lkXqdozBkfiij1YbEIpxdPyu7nkHGak8o1B
         oHej7Q+FUl6TGUF6ZUFl4UJi2xNuEL3vqChp7kwaWiadwK6H/rgRGPQ3gM2eBzzNnNR/
         xfPNADyeW3k0+13l8JQ9w9NSMy+2+Tw1P7lafEM9BhSSv2RdgYBK4vvEOHBb0i4/bQ1M
         zoO1EUgfbL4wcFBRydeuATv3dI2oejeB+N6TDqInN5vwNk9D2l//r4jls0J5Ft8IPiTI
         HyKQ==
X-Forwarded-Encrypted: i=1; AJvYcCWC9VDxgfxLsUYJ4zZkNmlXQ0lFE6xSc5/TEvm0KCRWQ0aULkraKjlPwOM8BvlbQ0fxUKDdvW6Y4qxwQf9uBAi4QpaHVHt1TQE=
X-Gm-Message-State: AOJu0Yw1vjajEdzRN/w8ixrXXKyMvs1VOwvBo7JC7yvujjbdriwtQwgS
	6vUmdj/7x8oVWq1vASgXQtOMVYKYAym2VJQVyu4Iz1HtwG783dDEFwZ+8oPSOVtB0TIC2L/M83R
	A
X-Google-Smtp-Source: AGHT+IFBG4GeUuI8B2NcaX/k5yIgRrgZW2oWA7U4MGBHBSeGtc0lERWPX2+dxu6fiDSL58tXWYGoiQ==
X-Received: by 2002:a05:6a00:3990:b0:6e6:5574:17fe with SMTP id fi16-20020a056a00399000b006e6557417femr7045742pfb.2.1710545156246;
        Fri, 15 Mar 2024 16:25:56 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id i185-20020a62c1c2000000b006e583a649b4sm4063407pfg.210.2024.03.15.16.25.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Mar 2024 16:25:55 -0700 (PDT)
Message-ID: <cafdf8d7-2798-4d91-a6e5-3f9486303c6a@kernel.dk>
Date: Fri, 15 Mar 2024 17:25:54 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring/net: ensure async prep handlers always
 initialize ->done_io
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>,
 io-uring <io-uring@vger.kernel.org>
References: <472ec1d4-f928-4a52-8a93-7ccc1af4f362@kernel.dk>
 <0ec91000-43f8-477e-9b61-f0a2f531e7d5@gmail.com>
 <cef96955-f7bc-4a0f-b3aa-befb338ca84d@gmail.com>
 <2af3dfa2-a91c-4cae-8c4c-9599459202e2@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2af3dfa2-a91c-4cae-8c4c-9599459202e2@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/15/24 5:19 PM, Pavel Begunkov wrote:
> On 3/15/24 23:13, Pavel Begunkov wrote:
>> On 3/15/24 23:09, Pavel Begunkov wrote:
>>> On 3/15/24 22:48, Jens Axboe wrote:
>>>> If we get a request with IOSQE_ASYNC set, then we first run the prep
>>>> async handlers. But if we then fail setting it up and want to post
>>>> a CQE with -EINVAL, we use ->done_io. This was previously guarded with
>>>> REQ_F_PARTIAL_IO, and the normal setup handlers do set it up before any
>>>> potential errors, but we need to cover the async setup too.
>>>
>>> You can hit io_req_defer_failed() { opdef->fail(); }
>>> off of an early submission failure path where def->prep has
>>> not yet been called, I don't think the patch will fix the
>>> problem.
>>>
>>> ->fail() handlers are fragile, maybe we should skip them
>>> if def->prep() wasn't called. Not even compile tested:
>>>
>>>
>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>> index 846d67a9c72e..56eed1490571 100644
>>> --- a/io_uring/io_uring.c
>>> +++ b/io_uring/io_uring.c
> [...]
>>>           def->fail(req);
>>>       io_req_complete_defer(req);
>>>   }
>>> @@ -2201,8 +2201,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>>           }
>>>           req->flags |= REQ_F_CREDS;
>>>       }
>>> -
>>> -    return def->prep(req, sqe);
>>> +    return 0;
>>>   }
>>>
>>>   static __cold int io_submit_fail_init(const struct io_uring_sqe *sqe,
>>> @@ -2250,8 +2249,15 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>>       int ret;
>>>
>>>       ret = io_init_req(ctx, req, sqe);
>>> -    if (unlikely(ret))
>>> +    if (unlikely(ret)) {
>>> +fail:
> 
> Obvious the diff is crap, but still bugging me enough to write
> that the label should've been one line below, otherwise we'd
> flag after ->prep as well.

It certainly needs testing :-)

We can go either way - patch up the net thing, or do a proper EARLY_FAIL
and hopefully not have to worry about it again. Do you want to clean it
up, test it, and send it out?

-- 
Jens Axboe


