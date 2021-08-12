Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B34673EA784
	for <lists+io-uring@lfdr.de>; Thu, 12 Aug 2021 17:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232854AbhHLP1L (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Aug 2021 11:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238019AbhHLP1K (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Aug 2021 11:27:10 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CEBAC0613D9
        for <io-uring@vger.kernel.org>; Thu, 12 Aug 2021 08:26:45 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id w6so10840261oiv.11
        for <io-uring@vger.kernel.org>; Thu, 12 Aug 2021 08:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UD82te12uARXoEIcMB3qwCEklEFEppEcEKdhU6Axn70=;
        b=PcTLo7bLntonvTKIoQ5ZxVA3xvQPn2Z/as7EPz1/7ZeARVJJue5osA7MKm6SWxE6uT
         nmLJAenI6v6gYMTgBE1rLx0Y5Y3PltTsisq/aOS/9KZbCH6z+/6jagUS4c+1+N4M/Tvv
         rH8Qgk1zpVH457iOp7rEHC4OZSR2uswIUFa+FAnp6t4IojNDG9BoKzoGc+RE+tKstgI2
         ua/eRfDBWU60S/QaippHXkxf1rK5cQfni0Qm0MDgvE1IOwHVKIFoAYBTzG3bgttBqtXs
         SsCbcwE64a0k4aptiVNl/Oz4BrQ4NkXeHnZjsWKA8DoaUsfVlrQkLzWhzj25bi3431+d
         e8Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UD82te12uARXoEIcMB3qwCEklEFEppEcEKdhU6Axn70=;
        b=aEO4iyUlOu8DmoBtRJKulyFdWUj+vzddXd1VL/8krUBQU2AxMziljY56KSBt9eEEKJ
         QYkcZwEcWUcfFhRSivCNZjFiPbkDPtI9D5zPJX7kuoX5goLBBFaLVddToWfE4FfeQ1L8
         4zXs+rudhprfg7YrrSdquI7Eb8GtdviYejIx55KzMTgjQsWIrTpM9MMiBK8ci4NpYQ0p
         j+nzeSpW3jFP420b0xvFYcuTOl/tGKWYOyXFYGRZtImRj45ndtTq2cK6+YyXF6nX/iGA
         jRkOGj0wrxnfiuB7YSiX56/7kEwUxM1lqgKnaL8p4xDcMsoC7vRQKhGoVeLkxKVRoB4J
         2bog==
X-Gm-Message-State: AOAM532ELLppLzNrPucEzbmJtYfxW2ehEPbCk2MdWfPVevIY0f+yQIOa
        eicQxKih7WC5j4WvthsELJko7g==
X-Google-Smtp-Source: ABdhPJwxSe1uFCogxcA3o4JrEoa+9f8arLJ/9LHid2qvmb/ir/EcQpembYWCHC2RBzZNAQuDw9sgkA==
X-Received: by 2002:aca:1c0a:: with SMTP id c10mr3775908oic.87.1628782004545;
        Thu, 12 Aug 2021 08:26:44 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id 47sm661994otd.12.2021.08.12.08.26.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Aug 2021 08:26:44 -0700 (PDT)
Subject: Re: [PATCH 3/6] bio: add allocation cache abstraction
To:     Christoph Hellwig <hch@infradead.org>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org
References: <20210811193533.766613-1-axboe@kernel.dk>
 <20210811193533.766613-4-axboe@kernel.dk> <YRTHTyz+tlRuGv2i@infradead.org>
 <845afc13-448d-0cb1-f9f7-86ac91d27c0f@kernel.dk>
 <YRU713wjR0UBQ1uc@infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7325d3bc-27fd-6717-aa69-30fcb0322ddd@kernel.dk>
Date:   Thu, 12 Aug 2021 09:26:43 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YRU713wjR0UBQ1uc@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/12/21 9:18 AM, Christoph Hellwig wrote:
> On Thu, Aug 12, 2021 at 09:08:29AM -0600, Jens Axboe wrote:
>>>> +	cache = per_cpu_ptr(bs->cache, get_cpu());
>>>> +	bio = bio_list_pop(&cache->free_list);
>>>> +	if (bio) {
>>>> +		cache->nr--;
>>>> +		put_cpu();
>>>> +		bio_init(bio, nr_vecs ? bio->bi_inline_vecs : NULL, nr_vecs);
>>>> +		bio_set_flag(bio, BIO_PERCPU_CACHE);
>>>> +		return bio;
>>>> +	}
>>>> +	put_cpu();
>>>> +normal_alloc:
>>>> +	bio = bio_alloc_bioset(gfp, nr_vecs, bs);
>>>> +	if (cache)
>>>> +		bio_set_flag(bio, BIO_PERCPU_CACHE);
>>>> +	return bio;
>>>
>>> The goto here is pretty obsfucating and adds an extra patch to the fast
>>> path.
>>
>> I don't agree, and it's not the fast path - the fast path is popping off
>> a bio off the list, not hitting the allocator.
> 
> Oh, I see you special case the list pop return now.  Still seems much
> easier to follow to avoid the goto, the cache initialization and the
> conditional in the no bio found in the list case (see patch below).
> 
> diff --git a/block/bio.c b/block/bio.c
> index 689335c00937..b42621cecbef 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -1707,11 +1707,11 @@ EXPORT_SYMBOL(bioset_init_from_src);
>  struct bio *bio_alloc_kiocb(struct kiocb *kiocb, gfp_t gfp,
>  			    unsigned short nr_vecs, struct bio_set *bs)
>  {
> -	struct bio_alloc_cache *cache = NULL;
> +	struct bio_alloc_cache *cache;
>  	struct bio *bio;
>  
>  	if (!(kiocb->ki_flags & IOCB_ALLOC_CACHE) || nr_vecs > BIO_INLINE_VECS)
> -		goto normal_alloc;
> +		return bio_alloc_bioset(gfp, nr_vecs, bs);
>  
>  	cache = per_cpu_ptr(bs->cache, get_cpu());
>  	bio = bio_list_pop(&cache->free_list);
> @@ -1723,10 +1723,8 @@ struct bio *bio_alloc_kiocb(struct kiocb *kiocb, gfp_t gfp,
>  		return bio;
>  	}
>  	put_cpu();
> -normal_alloc:
>  	bio = bio_alloc_bioset(gfp, nr_vecs, bs);
> -	if (cache)
> -		bio_set_flag(bio, BIO_PERCPU_CACHE);
> +	bio_set_flag(bio, BIO_PERCPU_CACHE);
>  	return bio;
>  }

Sure, if that'll shut it down, I'll make the edit :-)

-- 
Jens Axboe

