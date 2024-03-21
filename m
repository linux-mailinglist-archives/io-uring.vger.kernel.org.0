Return-Path: <io-uring+bounces-1189-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E7F3E885EB6
	for <lists+io-uring@lfdr.de>; Thu, 21 Mar 2024 17:54:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 167B11C231CE
	for <lists+io-uring@lfdr.de>; Thu, 21 Mar 2024 16:54:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5286413341A;
	Thu, 21 Mar 2024 16:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="KuuK60CW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E6A1482E5
	for <io-uring@vger.kernel.org>; Thu, 21 Mar 2024 16:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711039124; cv=none; b=LNaIkDF60UnBpTcuTtOWyCpi+du8uYn9Z2FDAVA+Y6MgxB/7Fg/UH2hesjorqPleafSpLDf0VuD7Xij1o4qC9SNXFLFr3LoI2ZOOooDBlEhmuFq3W3e9clIeOZ6ZGymYLFHL4WEJV1GpK3ricxbVsvX24LX+bm6lLAHKIqlaeVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711039124; c=relaxed/simple;
	bh=rxoEpWBTx5epDktRcV1G9fIavFO/+oDGoh7egr5Gl5g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GnifSnHMp8o5xAofZBe/Pk80m/bNByZTx7A0TgB8xmKf6rzFecdx4B5T1XMw9x3K5Rb4dva9txXdtXDcapEaBpXvlXKNkFmxy966I0I5h7DFRoAx0qEtxgOSZcNxJvZs+s4DZS/kqw7oWD+lH3Nd7X9kkfzcALA0cM5cyHP8u20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=KuuK60CW; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-36699ee4007so1226275ab.0
        for <io-uring@vger.kernel.org>; Thu, 21 Mar 2024 09:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711039120; x=1711643920; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=42yLElE/AL+Sih1qx4VVfEEsqMDCRY2Wv8k5ilj4iqA=;
        b=KuuK60CWdiCpJqg3h8/x5qsfSAScgyROr0jujMcgqXFUnu184VOnzMGd2WQY+0t2VA
         HVTmbVskENwK2u+rq53qpWBcw/vDY0D8eaWDljh3PhzqpzTkPB0dGP2XVwGUzCGhyHqE
         m73OixPi62SWZmRA8T1SMprm6AsO4jyiyly9tA/fVqXoHz1C8Pw5v+OIzFxM7Oszwxvb
         La+gtLixcRDl+nHTCVGTaM74XcXtobK7X5SDLumr+CWUhtFq3JoehObQPrgsE0cV5TjY
         I0/2adhiWFJBBBVLC7bhBdKitafCffKwwYOliHjoZ6fGRA5Ypb1d8wNOT3ye4fj+eKUs
         6V2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711039120; x=1711643920;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=42yLElE/AL+Sih1qx4VVfEEsqMDCRY2Wv8k5ilj4iqA=;
        b=WrYYctcHgNsX5bzR7FJ5h9O1s3FFcUqk55NhJSZvrhU8oXllWIJF7T0TEtZZGPPtZD
         L763vAj/wqsaqh9ZX7Ofaf4iS7tYxMLOk/AKyl7dh2wVUmvWZ+/0p5ecY7UyoobobjkV
         TLrg6k1bkzLjno33J+GZQDdItrk12TeOvbPsVFu8lohuecHu1oR+5SrcyM1grSGhKjPr
         U9vf+Uok4ifYYC4lH+eRudwC8Rr+ruE0g2ni8DG4V2pqEBUTAPnhS0EP5EqjvVLuw/RO
         TthutB2M1QVuSy34JVt6Qud/JYtPOkE+DdjYXh07bU/8msEMB9ZiSrR3oy6GfBk2pRxu
         6kEA==
X-Gm-Message-State: AOJu0YwIC3NzGWP30cdewgFfPLjfIXsk+bineVJQMd04qPYFz9ejER5Z
	MBf3EerSSuDpwW6EM8xO7qlUuxy6H7L1lp8kePd4hbbWDH7nwlmcyIQhHUD+Yg4=
X-Google-Smtp-Source: AGHT+IH49IsZmBjPTn07k9WvAgUUYP9awMQsA/oK6PcgSUjNWXjBCanaaTAyQl4r/wuJXQc6FrprYQ==
X-Received: by 2002:a92:d2cb:0:b0:366:7d03:eb51 with SMTP id w11-20020a92d2cb000000b003667d03eb51mr22017ilg.2.1711039119918;
        Thu, 21 Mar 2024 09:38:39 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id r1-20020a92c501000000b00366776dcc88sm26908ilg.79.2024.03.21.09.38.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Mar 2024 09:38:39 -0700 (PDT)
Message-ID: <20f95e13-85af-4316-b167-160571f09369@kernel.dk>
Date: Thu, 21 Mar 2024 10:38:37 -0600
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
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <87frwja83n.fsf@mailhost.krisman.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/21/24 9:59 AM, Gabriel Krisman Bertazi wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> Currently lists are being used to manage this, but lists isn't a very
>> good choice for as extracting the current entry necessitates touching
>> the next entry as well, to update the list head.
>>
>> Outside of that detail, games are also played with KASAN as the list
>> is inside the cached entry itself.
>>
>> Finally, all users of this need a struct io_cache_entry embedded in
>> their struct, which is union'ized with something else in there that
>> isn't used across the free -> realloc cycle.
>>
>> Get rid of all of that, and simply have it be an array. This will not
>> change the memory used, as we're just trading an 8-byte member entry
>> for the per-elem array size.
>>
>> This reduces the overhead of the recycled allocations, and it reduces
>> the code we have to support recycling.
> 
> Hi Jens,
> 
> I tried applying the entire to your for-6.10/io_uring branch to test it
> and only this last patch failed to apply. The tip of the branch I have
> is 22261e73e8d2 ("io_uring/alloc_cache: shrink default max entries from
> 512 to 128").

Yeah it has some dependencies that need unraveling. The easiest is if
you just pull:

git://git.kernel.dk/linux io_uring-recvsend-bundle

into current -git master, and then just test that. That gets you pretty
much everything that's being tested and played with.

Top of tree is d5653d2fcf1383c0fbe8b64545664aea36c7aca2 right now.

>> -static inline struct io_cache_entry *io_alloc_cache_get(struct io_alloc_cache *cache)
>> +static inline void *io_alloc_cache_get(struct io_alloc_cache *cache)
>>  {
>> -	if (cache->list.next) {
>> -		struct io_cache_entry *entry;
>> +	if (cache->nr_cached) {
>> +		void *entry = cache->entries[--cache->nr_cached];
>>  
>> -		entry = container_of(cache->list.next, struct io_cache_entry, node);
>>  		kasan_mempool_unpoison_object(entry, cache->elem_size);
>> -		cache->list.next = cache->list.next->next;
>> -		cache->nr_cached--;
>>  		return entry;
>>  	}
>>  
>>  	return NULL;
>>  }
>>  
>> -static inline void io_alloc_cache_init(struct io_alloc_cache *cache,
>> -				       unsigned max_nr, size_t size)
>> +static inline int io_alloc_cache_init(struct io_alloc_cache *cache,
>> +				      unsigned max_nr, size_t size)
>>  {
>> -	cache->list.next = NULL;
>> +	cache->entries = kvmalloc_array(max_nr, sizeof(void *), GFP_KERNEL);
>> +	if (!cache->entries)
>> +		return -ENOMEM;
>>  	cache->nr_cached = 0;
>>  	cache->max_cached = max_nr;
>>  	cache->elem_size = size;
>> +	return 0;
>>  }
>>  
>>  static inline void io_alloc_cache_free(struct io_alloc_cache *cache,
>> -					void (*free)(struct io_cache_entry *))
>> +				       void (*free)(const void *))
> 
> Minor, but since free is supposed to free the entry, const doesn't
> make sense here.  Also, you actually just cast it away immediately in
> every usage.

It's because then I can use kfree() directly for most cases, only two of
them have special freeing functions. And kfree takes a const void *. I
should add a comment about that.

-- 
Jens Axboe


