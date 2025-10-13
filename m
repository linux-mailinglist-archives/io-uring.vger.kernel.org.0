Return-Path: <io-uring+bounces-9976-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id F2697BD335A
	for <lists+io-uring@lfdr.de>; Mon, 13 Oct 2025 15:30:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D419C4EB755
	for <lists+io-uring@lfdr.de>; Mon, 13 Oct 2025 13:30:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 323C2307AE0;
	Mon, 13 Oct 2025 13:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nKRLzPXZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525E2307AD2
	for <io-uring@vger.kernel.org>; Mon, 13 Oct 2025 13:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760362227; cv=none; b=lrPZPFYCYk9Q9XgI0mIaob6y09YgqDtvdLXRsqZjzPVseQgee1Zt5gwP5yZF2/MraYsjWZgVQnfhppvnt1m9wTo8mxRNaO22V5u8DAyleD/yjxKpvpaxvszs/aWC83S3PCsb2+mbnOCjvjVXgdE/ekCRF/4UxY/mNWCaYV2cYkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760362227; c=relaxed/simple;
	bh=pYKv/ZHAQal8b6v/icrawjp0xeugJB+Yhx7Gqtpqskc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DXL3ADuaQgBKrsplrDOI5YcObF/si5doXNAstQNPqImUqV/VT2tb0Qk1g6y5604A3w/5joRxmcWsYa/DuUSwEhXTcmemzjhzcljjj4TwwcpjYIzo5Q1Uv82t5nTo7BNqXxvGeeZFje2OlO8wEOBLVfJ0p/0KxRd7M2HcmJ98eSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nKRLzPXZ; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-46e34052bb7so50936185e9.2
        for <io-uring@vger.kernel.org>; Mon, 13 Oct 2025 06:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760362224; x=1760967024; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DZlmO7Er2VNfUt2lW8HD8G8xjeR52/0o/FyblKyrXi0=;
        b=nKRLzPXZnQf9ilLT2raNaKwPMG6B8Vee1uWqwMVCnAKqSukvQpx/qcvB400LvbTRYx
         fDZe5SHGtw9N/OmQD1fp+c20mNiIoCa7S0RTxayO7va4bk0AYZIOyHwbOj4vNB4tb9lN
         bDY5zZQosZZ3k6ApeKSFrEUwzob5gRGlEPeWCe+hfRjO2Q4+2xbXi8K5lIkkNpIQxvYy
         V8OGvKAJ6FdFO0bcqmacw5NecjeQUrtEPOZoUl8g/Buiy3JLKQg1IuddCiXv65nA1IlB
         jsEr6eXzXiqQ7TnC3MZw/sBS5/L3XBvLIZRHM2jk0DCOxNJHcyWKzuTSIlA8saTZEdtO
         vVeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760362224; x=1760967024;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DZlmO7Er2VNfUt2lW8HD8G8xjeR52/0o/FyblKyrXi0=;
        b=uKyXjjlgcMIVXMLdDelio03oVbemiTuSjWWepeKvS0bH073GAyCkxhbWqi3vt3KXRb
         ygfmWOCTdvCvCQjz1/aH3U9cXWmTZQi+4qQHyxpvp3FxQpyZQyaHGkNGTyNMf7QHr82X
         Kl4y9MMyeWZyYv4qzJnaD7TEDR6RfsZNDI91AYFTGCS4fhxvlVrlbtACCKjZqqMArCsX
         r/V/vH2liOszIX+uzdzlH+7Dyms4gCD4mUKTF06VIaQZXgjKB5JcsTf+eERkgAJqJCEW
         bQkyi2BxJCFs84n9NhjXuqLh07G4kkMvHhLCXSlO0VeO81JmCbK0CRCfSN+kueR38Bap
         SEKA==
X-Forwarded-Encrypted: i=1; AJvYcCXU2LK5mjriweOxI/G3EB+gtpPGBXfFwnGkH67LTMRSAnpDvlCHmuuF+GlQRIWRr+FZ1e5tLMFNyw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxZuPFqy0rAOLoA3PusHuloYx7uzToGhI0VmVVE1a9FcP5twoGz
	bBx05nxQoUNqME5zC3w3eGEVzX4QMe00hB+IcNssxq3dqzIAUiMTdVQn
X-Gm-Gg: ASbGncv9AR+RNikMkm1/FFNghJqWjP2GlnpC/KRHr0oAiBUdxVyq6uvEM7WX+VC65aB
	lOufCYJuMb3HMP5mFdHsdLGyUJ9hilDogQ4Idrov5Ly8j7VY/RujnbxJgu1pl2wp996rpFQw+TG
	4Ln98r1hAQ6JsgoF+LIk1x78xA1ILkdWIGTQMBbmc1jb6VtmRtygZRf5AP0Nr+/7TWRolXt4a9R
	0xhJKhztR7uHNHtY+e+bjoxQZrnFB8pUQE/hi4iL+sVvX5TGa3detWL4WmHXnQcGd0Gv6GO74nq
	44iwhMAi8HNYPjmI8J1CvLN6fN5K4dQ+ms0vDpeILJbLU8i1ae56noqaLbG9ZB+Lwn4HOQe/nXc
	/QyBuqb+HGW3cgyzr5VEkWlexdsoiVSrO2LZNIjAURmovlZ+8q+M45lDeWsbwpJ0etRr4Ioxqei
	DkqFLHhsnl
X-Google-Smtp-Source: AGHT+IFb8vtBJitNnjBlDbVIUCm2gATTzzIuI7S2acOd2FoeBSuIxAzk1vmdrirRWyHwbC1aiC5zwg==
X-Received: by 2002:a05:600c:6092:b0:45d:e28c:8741 with SMTP id 5b1f17b1804b1-46fa9b02e5amr148223315e9.29.1760362223296;
        Mon, 13 Oct 2025 06:30:23 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:eb09])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb49c3e49sm185108555e9.16.2025.10.13.06.30.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Oct 2025 06:30:22 -0700 (PDT)
Message-ID: <d785cc8e-d8fd-4bee-950c-7f3f7d452efc@gmail.com>
Date: Mon, 13 Oct 2025 14:31:32 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [External] Re: [PATCH] block: enable per-cpu bio cache by default
To: Fengnan Chang <changfengnan@bytedance.com>,
 Christoph Hellwig <hch@infradead.org>
Cc: fengnan chang <fengnanchang@gmail.com>, axboe@kernel.dk,
 viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
 willy@infradead.org, djwong@kernel.org, ritesh.list@gmail.com,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org
References: <20251011013312.20698-1-changfengnan@bytedance.com>
 <aOxxBS8075_gMXgy@infradead.org>
 <CALWNXx8pDOvDdNvw+v0rEyi33W8TL+OZW1YiFbF6Gns3PeWOLA@mail.gmail.com>
 <aOyb-NyCopUKridK@infradead.org>
 <CAPFOzZumoCERUj+VuegQNoAwFCoGxiaASD6R_4bE+p1TVbspUA@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAPFOzZumoCERUj+VuegQNoAwFCoGxiaASD6R_4bE+p1TVbspUA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/13/25 13:58, Fengnan Chang wrote:
> Christoph Hellwig <hch@infradead.org> 于2025年10月13日周一 14:28写道：
>>
>> On Mon, Oct 13, 2025 at 01:42:47PM +0800, fengnan chang wrote:
>>>> Just set the req flag in the branch instead of unconditionally setting
>>>> it and then clearing it.
>>>
>>> clearing this flag is necessary, because bio_alloc_clone will call this in
>>> boot stage, maybe the bs->cache of the new bio is not initialized yet.
>>
>> Given that we're using the flag by default and setting it here,
>> bio_alloc_clone should not inherit it.  In fact we should probably
>> figure out a way to remove it entirely, but if that is not possible
>> it should only be set when the cache was actually used.
> 
> For now bio_alloc_clone will inherit all flag of source bio, IMO if only not
> inherit REQ_ALLOC_CACHE, it's a little strange.
> The REQ_ALLOC_CACHE flag can not remove entirely.  maybe we can
> modify like this:
> 
> if (bs->cache && nr_vecs <= BIO_INLINE_VECS) {
>      opf |= REQ_ALLOC_CACHE;
>      bio = bio_alloc_percpu_cache(bdev, nr_vecs, opf,
>      gfp_mask, bs);
>      if (bio)
>          return bio;
>      /*
>       * No cached bio available, bio returned below marked with
>       * REQ_ALLOC_CACHE to participate in per-cpu alloc cache.
>      */
> } else
>          opf &= ~REQ_ALLOC_CACHE;
> 
>>
>>>>> +     /*
>>>>> +      * Even REQ_ALLOC_CACHE is enabled by default, we still need this to
>>>>> +      * mark bio is allocated by bio_alloc_bioset.
>>>>> +      */
>>>>>        if (rq->cmd_flags & REQ_ALLOC_CACHE && (nr_vecs <= BIO_INLINE_VECS)) {
>>>>
>>>> I can't really parse the comment, can you explain what you mean?
>>>
>>> This is to tell others that REQ_ALLOC_CACHE can't be deleted here, and
>>> that this flag
>>> serves other purposes here.
>>
>> So what can't it be deleted?
> 
> blk_rq_map_bio_alloc use REQ_ALLOC_CACHE to tell whether to use
> bio_alloc_bioset or bio_kmalloc, I considered removing the flag in
> blk_rq_map_bio_alloc, but then there would have to be the introduction
> of a new flag like  REQ_xx. So I keep this and comment.

That can likely be made unconditional as well. Regardless of that,
it can't be removed without additional changes because it's used to
avoid de-allocating into the pcpu cache requests that wasn't
allocated for it. i.e.

if (bio->bi_opf & REQ_ALLOC_CACHE)
	bio_put_percpu_cache(bio);
else
	bio_free(bio);

Without it under memory pressure you can end up in a situation
where bios are put into pcpu caches of other CPUs and can't be
reallocated by the current CPU, effectively loosing the mempool
forward progress guarantees. See:

commit 759aa12f19155fe4e4fb4740450b4aa4233b7d9f
Author: Pavel Begunkov <asml.silence@gmail.com>
Date:   Wed Nov 2 15:18:20 2022 +0000

     bio: don't rob starving biosets of bios

-- 
Pavel Begunkov


