Return-Path: <io-uring+bounces-1191-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B1B2885F9A
	for <lists+io-uring@lfdr.de>; Thu, 21 Mar 2024 18:22:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3EBAF1C2094E
	for <lists+io-uring@lfdr.de>; Thu, 21 Mar 2024 17:22:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64FDD12B70;
	Thu, 21 Mar 2024 17:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="h9C0vVd4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D59B66F
	for <io-uring@vger.kernel.org>; Thu, 21 Mar 2024 17:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711041743; cv=none; b=m6g0ADZfVrqkQiLJOEksFjFwowgXMEWQYFtRRvAJIgnfGkaBLywOcf/fMIRoNhgGHww0+GVakh8CFXBxpSQZ9BZpFBCMQ8pVkkwoDLYALcLjSiOvM4V0EfCB4eSF0l0U20cAZynv5/hsDBmFXtCNwNdy/iudhhk7JBOARvYfjso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711041743; c=relaxed/simple;
	bh=XO7TJECLa2NTzx5qB7Wm3maBmvtYBdFnYs8w/T1wbI0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Kkd/Fe2WDiyrA8U3kFNd6lYgn1zdaoBMKgDJJ4SJ+cQzINPPDQpVm6lbZMD8oBLRTa8GlBobvS678BULyTRpuiVHATZWzUeLatxJovzTw6w//o12QImjROaN6iGjj/PEFxijl6J47msJ0jNlrnkvh+X1DSeQe4sGm9aHAA8yutM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=h9C0vVd4; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-7c86e6f649aso9450439f.0
        for <io-uring@vger.kernel.org>; Thu, 21 Mar 2024 10:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711041740; x=1711646540; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ctNmLJ75z3ns0fc4rG3ZcU7sPVguHFv/sD91hJZ/7hE=;
        b=h9C0vVd49IUiyRSB0Y17Prsa97MsaSU3gBV+Jow4vbNPlEjOHvLMW7eHL8EZNE0HhF
         WjbKZpp6dGNzxJmwK37PWYACeiDeVT3uieJDSD+VVqzI3g1MmDPde4YOt2vF4/FnKarX
         hqmU3oBEB9ugPSQsXyQO64kgYXCjNbqS8CmaCHjVtd5+eFOGu/NI8gLj7xfzjZLqi40L
         AFRr1qRilHpoPDoV9imbBvyIgViFf/lHtCvSoEt2NBcpqHy2F8rZqvQ7eMQ8qeUiRqiR
         Lv/OCf3qnBRg84ECxDismGsx/CRIrKOeSgo+g9nk2hjEkLJ6MC/vFrycmmLrfLXUy4G5
         +nDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711041740; x=1711646540;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ctNmLJ75z3ns0fc4rG3ZcU7sPVguHFv/sD91hJZ/7hE=;
        b=dZaPtu4ozTwUUHjrhop+bAojrMlgE2Sr02TeyVveXg0dLZ22nMd6qSYSr8k42UW7N/
         FB8OKxBxmG+xm6v1LGLSV9JrTy+WM35aacZxhyeDKJoTtWUUtL8VU0BoJ5F5t/TKeu+X
         pU/VCxAjlbJvsY15vLaxDVxJiPMfd9pX67rN3VfnCaFzGfz6lzoqIunYmeaPaNKaoxJG
         53YpLtgYR2T8eOcxmiqQ9oC7OvoWanYzTK4/wyLtH+3ik+W3B2Nk83nsg5CHXVQjPCiI
         qUEDnNyV0jGTXYzplgV9rRb0gc0LZrKYkMrXCPXk/yTDeNoRHusooXir6VCFs19UQF1e
         iEGg==
X-Gm-Message-State: AOJu0YxMREKoJPM2RUx2KZw3U90W1EEkwAk3WYpSE7sm7vsDeFPlD5sn
	HKR26h8tSU7rtKQlIRb9OdG2HVJ7ND5SDKx9V/3ojDP0Xhqz0mIzOjjeL4Qbjrs=
X-Google-Smtp-Source: AGHT+IGC0DMQVacOZ19iVOhPxY4bvBTh31xUOQ/fYg2V6UskB3eiOhAterWI6oaTKKTy/yU3fgB98A==
X-Received: by 2002:a5e:8e02:0:b0:7cf:272f:a3af with SMTP id a2-20020a5e8e02000000b007cf272fa3afmr77687ion.2.1711041740121;
        Thu, 21 Mar 2024 10:22:20 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 16-20020a0566380a5000b004772a0d4b0bsm9872jap.8.2024.03.21.10.22.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Mar 2024 10:22:19 -0700 (PDT)
Message-ID: <ddc6115a-d695-4430-acf8-9e8a740bcf8f@kernel.dk>
Date: Thu, 21 Mar 2024 11:22:18 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 17/17] io_uring/alloc_cache: switch to array based caching
Content-Language: en-US
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org
References: <20240320225750.1769647-1-axboe@kernel.dk>
 <20240320225750.1769647-18-axboe@kernel.dk>
 <87frwja83n.fsf@mailhost.krisman.be>
 <20f95e13-85af-4316-b167-160571f09369@kernel.dk>
 <878r2ba4dr.fsf@mailhost.krisman.be>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <878r2ba4dr.fsf@mailhost.krisman.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/21/24 11:20 AM, Gabriel Krisman Bertazi wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> On 3/21/24 9:59 AM, Gabriel Krisman Bertazi wrote:
>>> Jens Axboe <axboe@kernel.dk> writes:
>>>
>>>> Currently lists are being used to manage this, but lists isn't a very
>>>> good choice for as extracting the current entry necessitates touching
>>>> the next entry as well, to update the list head.
>>>>
>>>> Outside of that detail, games are also played with KASAN as the list
>>>> is inside the cached entry itself.
>>>>
>>>> Finally, all users of this need a struct io_cache_entry embedded in
>>>> their struct, which is union'ized with something else in there that
>>>> isn't used across the free -> realloc cycle.
>>>>
>>>> Get rid of all of that, and simply have it be an array. This will not
>>>> change the memory used, as we're just trading an 8-byte member entry
>>>> for the per-elem array size.
>>>>
>>>> This reduces the overhead of the recycled allocations, and it reduces
>>>> the code we have to support recycling.
>>>
>>> Hi Jens,
>>>
>>> I tried applying the entire to your for-6.10/io_uring branch to test it
>>> and only this last patch failed to apply. The tip of the branch I have
>>> is 22261e73e8d2 ("io_uring/alloc_cache: shrink default max entries from
>>> 512 to 128").
>>
>> Yeah it has some dependencies that need unraveling. The easiest is if
>> you just pull:
>>
>> git://git.kernel.dk/linux io_uring-recvsend-bundle
>>
>> into current -git master, and then just test that. That gets you pretty
>> much everything that's being tested and played with.
>>
>> Top of tree is d5653d2fcf1383c0fbe8b64545664aea36c7aca2 right now.
> 
> thanks, I'll test with that.

Thanks!

>>>> -static inline struct io_cache_entry *io_alloc_cache_get(struct io_alloc_cache *cache)
>>>> +static inline void *io_alloc_cache_get(struct io_alloc_cache *cache)
>>>>  {
>>>> -	if (cache->list.next) {
>>>> -		struct io_cache_entry *entry;
>>>> +	if (cache->nr_cached) {
>>>> +		void *entry = cache->entries[--cache->nr_cached];
>>>>  
>>>> -		entry = container_of(cache->list.next, struct io_cache_entry, node);
>>>>  		kasan_mempool_unpoison_object(entry, cache->elem_size);
>>>> -		cache->list.next = cache->list.next->next;
>>>> -		cache->nr_cached--;
>>>>  		return entry;
>>>>  	}
>>>>  
>>>>  	return NULL;
>>>>  }
>>>>  
>>>> -static inline void io_alloc_cache_init(struct io_alloc_cache *cache,
>>>> -				       unsigned max_nr, size_t size)
>>>> +static inline int io_alloc_cache_init(struct io_alloc_cache *cache,
>>>> +				      unsigned max_nr, size_t size)
>>>>  {
>>>> -	cache->list.next = NULL;
>>>> +	cache->entries = kvmalloc_array(max_nr, sizeof(void *), GFP_KERNEL);
>>>> +	if (!cache->entries)
>>>> +		return -ENOMEM;
>>>>  	cache->nr_cached = 0;
>>>>  	cache->max_cached = max_nr;
>>>>  	cache->elem_size = size;
>>>> +	return 0;
>>>>  }
>>>>  
>>>>  static inline void io_alloc_cache_free(struct io_alloc_cache *cache,
>>>> -					void (*free)(struct io_cache_entry *))
>>>> +				       void (*free)(const void *))
>>>
>>> Minor, but since free is supposed to free the entry, const doesn't
>>> make sense here.  Also, you actually just cast it away immediately in
>>> every usage.
>>
>> It's because then I can use kfree() directly for most cases, only two of
>> them have special freeing functions. And kfree takes a const void *. I
>> should add a comment about that.
> 
> TIL. For the record, I was very puzzled on why kfree receives a const
> pointer just to cast it away immediately too. Then I found Linus
> discussing it at https://yarchive.net/comp/const.html
> 
> Anyway, in this case, we are actually modifying it in io_rw_cache_free,
> and we don't need to explicitly cast from non-const to const , so I still
> think you can avoid the comment and drop the const.  But that is just
> a nitpick that i won't insist.

Right, but then I need a wrapper ala:

io_uring_kfree(void *entry)
{
	kfree(entry);
}

which obviously isn't the end of the world, but the cast is just fine
as-is imho.

-- 
Jens Axboe


