Return-Path: <io-uring+bounces-940-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E8F5D87B551
	for <lists+io-uring@lfdr.de>; Thu, 14 Mar 2024 00:44:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D3C541C20F0A
	for <lists+io-uring@lfdr.de>; Wed, 13 Mar 2024 23:44:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A7282260B;
	Wed, 13 Mar 2024 23:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="oyAtwuOa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB134691
	for <io-uring@vger.kernel.org>; Wed, 13 Mar 2024 23:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710373467; cv=none; b=R9PhhvEjUEPQrvyP3sCYFDdelbru8frvKvZJ1AosG4bCa5IDZKT1Aq0L3z/yjAmFGCEVFZ3+mWNxn2Wwghvgon6xNqRl96gPn3NX6wT9S5gNn/gbwy9XYf2FlkbvH50i1kHbiYD5JBAdOCXmNHP71zdufE9vBEgCQkb7v7kNaNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710373467; c=relaxed/simple;
	bh=1gluA/tWPcVKltBHzEinj54kybCbdJ3wQ3zbsngwa6s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YZV326+6fDMG57Xk6brWWGhm/RDrNKhlmTfLsYTERE5oAV3x5AxrdZkIpGPLdQmdFVpKVhJKVOjPhuCqqghBuMSH2D/ewPgcVsPjfA7uHSo3QMdU6G1p3NqpjX+f+J/OCN6vQSAFFR3HfpBJkrT0Gi5/g3DYUytMS4bqCIanz64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=oyAtwuOa; arc=none smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-220ce420472so116696fac.1
        for <io-uring@vger.kernel.org>; Wed, 13 Mar 2024 16:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710373463; x=1710978263; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zzvt90LsTRyVH8nnRm1OXdQOQV3Vum7zVzHwIRErtbc=;
        b=oyAtwuOaok0lPIVrQKEb7geN1HfCRnUNEeVg6fwgInMBGfIAnpkP5Ok20rNzqDLmX3
         JNPKMirkdpB/JuPt/kh67mpM71yfWc8/Ohpnonvbkjc0e0iwm4/7eAqQVhVtl6Qff3vo
         QHbxsOmmPhSsfDJ2eCBqDV/tENNiYJ1PSAz9PH8kxyxRnMhuufa2Vgud2jCbWUqOakdW
         v6frEnrD0obejoS6luwsxhGo8WtJyaLfnCmvPUsXWWO9z6onKRMwVbChVMSIs7sbk0gN
         KzfsTeABxio1dWxGnAA6FVY8SiEmgu4fNNaYBk5xGmsxdj6xKRq6VHUVosq9fM7fcNgQ
         UcFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710373463; x=1710978263;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zzvt90LsTRyVH8nnRm1OXdQOQV3Vum7zVzHwIRErtbc=;
        b=Ayk/nvjjwSUuo0RVExuwng0oU9d/TwCCoFMUPq+VxRfhmgNDGQOsRhxL7LHORbZ9Lt
         V+4xYzoPE4jOA6V92zr7UY5ijvkR44fYSlkfc6LH8KvBHdDsujBKxxVGDWIFApmUsPXb
         NvMgXx/kYYcyg69o1FrslGZjsVqx8F71hYg06jLM0qW3gLljM9m2SSeBZmDyXiMYKc/u
         KgaWbjK2H7tR3Pqwrx6i/r58bRfU+nfu/NrBOQCgPTq32KZpYldLmoDEUFQ/Nq8VawJl
         yziJboWg1F17Qe1N+Op8vyIDCM9S6bOC3CmjhOb/Gbbwgjqi6gktttcPyDDXbzAK9nwu
         hz/g==
X-Forwarded-Encrypted: i=1; AJvYcCXVPU+2Re5JQaXQzjBOX4KAMklaeAhduUOVooSx0sAAD3Fj1WS+C1qqr/X09ibZX78rwQ4ud6eABlN4SW8T40V4MHDkk+Lhaww=
X-Gm-Message-State: AOJu0Yy84OB7TA1ZTIOqdysEnFOwvnHpgOHTFfu9Pj+rjEeAj3ZBLPwX
	4oJ1PxC2GrhVEug2grQmpHmXQthkWFU8eryVpXqWO4H/a0fJv084oWJAU9/aRwI=
X-Google-Smtp-Source: AGHT+IF15zsh9uR9qeqAcDjP2yWzkDy/0JXp07BptN/YuT6yWDNqpNc2UWkBUxnyENb97LXZ4/DqZw==
X-Received: by 2002:a05:6359:45a9:b0:17c:1bef:407d with SMTP id no41-20020a05635945a900b0017c1bef407dmr515170rwb.1.1710373463211;
        Wed, 13 Mar 2024 16:44:23 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id o37-20020a634e65000000b005dc1edf7371sm196791pgl.9.2024.03.13.16.44.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Mar 2024 16:44:22 -0700 (PDT)
Message-ID: <72ae1e88-6a62-4f81-926c-33fc906b5931@kernel.dk>
Date: Wed, 13 Mar 2024 17:44:21 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] io_uring: simplify io_mem_alloc return values
Content-Language: en-US
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1710343154.git.asml.silence@gmail.com>
 <ba1f5a30be45eec6cf73cfdbf4b4e1679a03cef8.1710343154.git.asml.silence@gmail.com>
 <87plvxkbjp.fsf@mailhost.krisman.be>
 <4146d3a9-3f88-4ef5-8925-8782ae5aa90e@kernel.dk>
 <87a5n1k8a2.fsf@mailhost.krisman.be>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <87a5n1k8a2.fsf@mailhost.krisman.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/13/24 5:43 PM, Gabriel Krisman Bertazi wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> On 3/13/24 4:32 PM, Gabriel Krisman Bertazi wrote:
>>> Pavel Begunkov <asml.silence@gmail.com> writes:
>>>
>>>> io_mem_alloc() returns a pointer on success and a pointer-encoded error
>>>> otherwise. However, it can only fail with -ENOMEM, just return NULL on
>>>> failure. PTR_ERR is usually pretty error prone.
>>>>
>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>> ---
>>>>  io_uring/io_uring.c | 14 +++++---------
>>>>  io_uring/kbuf.c     |  4 ++--
>>>>  2 files changed, 7 insertions(+), 11 deletions(-)
>>>>
>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>>> index e7d7a456b489..1d0eac0cc8aa 100644
>>>> --- a/io_uring/io_uring.c
>>>> +++ b/io_uring/io_uring.c
>>>> @@ -2802,12 +2802,8 @@ static void io_rings_free(struct io_ring_ctx *ctx)
>>>>  void *io_mem_alloc(size_t size)
>>>>  {
>>>>  	gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_NOWARN | __GFP_COMP;
>>>> -	void *ret;
>>>>  
>>>> -	ret = (void *) __get_free_pages(gfp, get_order(size));
>>>> -	if (ret)
>>>> -		return ret;
>>>> -	return ERR_PTR(-ENOMEM);
>>>> +	return (void *) __get_free_pages(gfp, get_order(size));
>>>>  }
>>>>  
>>>>  static unsigned long rings_size(struct io_ring_ctx *ctx, unsigned int sq_entries,
>>>> @@ -3762,8 +3758,8 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
>>>>  	else
>>>>  		rings = io_rings_map(ctx, p->cq_off.user_addr, size);
>>>>  
>>>> -	if (IS_ERR(rings))
>>>> -		return PTR_ERR(rings);
>>>> +	if (!rings)
>>>> +		return -ENOMEM;
>>>>
>>>
>>> Sorry, I started reviewing this, got excited about the error path quick
>>> fix, and didn't finish the review before it got it.
>>>
>>> I think this change is broken for the ctx->flags & IORING_SETUP_NO_MMAP
>>> case, because io_rings_map returns ERR_PTR, and not NULL.  In addition,
>>> io_rings_map might fail for multiple reasons, and we want to propagate
>>> the different error codes up here.
>>
>> Yeah, see my reply from some hours ago. I dropped it back then.
> 
> ah, thanks.  I've configured lei to fetch the io_uring list every few
> hours. This ended up fetching part of the thread at first, and I only saw
> it dropped in the next fetch, after I sent the email. sorry for the noise.

Oh it's fine, I'd rather have one extra review than none at all :-)

-- 
Jens Axboe


