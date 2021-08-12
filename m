Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 090CC3EA72A
	for <lists+io-uring@lfdr.de>; Thu, 12 Aug 2021 17:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238380AbhHLPI6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Aug 2021 11:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238375AbhHLPI5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Aug 2021 11:08:57 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B355BC061756
        for <io-uring@vger.kernel.org>; Thu, 12 Aug 2021 08:08:32 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id 61-20020a9d0d430000b02903eabfc221a9so8205054oti.0
        for <io-uring@vger.kernel.org>; Thu, 12 Aug 2021 08:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DgRvpKzMqUwNe01AoX0wUWkAhZnVkoKdGV1S13pUHXc=;
        b=jLs3yIwVePiXQdFbHgTTwka5lLGzLnTlIqzGU4wU2t7tJ+JFYNdPq0uQh7hLGe0mXY
         ZZ8cCTqGLxkLG6U9baB6D/q2lSiLvR+KMrXYJcSfB2gDO7ydTxIQ4n/hSh5wIfrHmXuT
         K3L1es1eKh33BteNPkRVr0OOGqQo4f88XLhCe3BFFJYC/MEtG05FgJSmkCzQI0NF5rfR
         AyWTHQR3cVEQHfnPBRGx8yFXH3AnASXyFBdf6Gax0B3PUicRNWhp+jeDfxpqHq41uDY5
         /ITIY/aB7gr5ssWJhCRFuTExTs2pQSg+DN30lpHZXYq6Lu7aMk6XwMYpEyuBSx+fsCuy
         MrLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DgRvpKzMqUwNe01AoX0wUWkAhZnVkoKdGV1S13pUHXc=;
        b=F93BN5F1SN+5iS0kLXmLqy26oDBJoW9OmyGE0iQDKMdOWcvLdUjIewTWgF5GFOHczM
         XmUQHiTE8GTKZFx5afDKXtlaIFVXzBS0AQmvtb2Sgs09HQPW0mC+fn3hlKfK7zavv5Cb
         MW1pL/KKrrQfGO62RsqVpkcswKI36+UD3FWvpvlyGQIZDZucDXu7nP1eeyRTN4GHaC6x
         0DG1Nge/vmUVCmhYUjE8BIiYqr4oACVzjc3KIHIFAO4LDp86rLjGUJlj6E7VEKURLXoH
         8Q9T/ae6hCj/9YO07HWyl3ojgpyiVqa4zEzDklV3fcbU04rNHX+NOMssQJQJM9xokkwl
         SS8A==
X-Gm-Message-State: AOAM530jpLjd+XyAbOiGrmfAcEE/G5umlahIAVuZMM347Ji2J6GDSw8C
        wYFuX70yAPHceQKnBzU5lS4MRA==
X-Google-Smtp-Source: ABdhPJzy1wEym/EySsm9b4JEdcpdGbSFD6+RfhcmdA28/1FpL9zs/gzMfRVrQrqm7pDnhcvwW/JM/A==
X-Received: by 2002:a9d:6103:: with SMTP id i3mr3852508otj.277.1628780910647;
        Thu, 12 Aug 2021 08:08:30 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id 65sm579662ooc.2.2021.08.12.08.08.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Aug 2021 08:08:30 -0700 (PDT)
Subject: Re: [PATCH 3/6] bio: add allocation cache abstraction
To:     Christoph Hellwig <hch@infradead.org>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org
References: <20210811193533.766613-1-axboe@kernel.dk>
 <20210811193533.766613-4-axboe@kernel.dk> <YRTHTyz+tlRuGv2i@infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <845afc13-448d-0cb1-f9f7-86ac91d27c0f@kernel.dk>
Date:   Thu, 12 Aug 2021 09:08:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YRTHTyz+tlRuGv2i@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/12/21 1:01 AM, Christoph Hellwig wrote:
> On Wed, Aug 11, 2021 at 01:35:30PM -0600, Jens Axboe wrote:
>> +	struct bio *bio;
>> +	unsigned int i;
>> +
>> +	i = 0;
> 
> Initialize at declaration time?

Sure, done.

>> +static inline bool __bio_put(struct bio *bio)
>> +{
>> +	if (!bio_flagged(bio, BIO_REFFED))
>> +		return true;
>> +
>> +	BIO_BUG_ON(!atomic_read(&bio->__bi_cnt));
>> +
>> +	/*
>> +	 * last put frees it
>> +	 */
>> +	return atomic_dec_and_test(&bio->__bi_cnt);
>> +}
> 
> Please avoid this helper, we can trivially do the check inside of bio_put:
> 
> 	if (bio_flagged(bio, BIO_REFFED)) {
> 		BIO_BUG_ON(!atomic_read(&bio->__bi_cnt));
> 		if (!atomic_dec_and_test(&bio->__bi_cnt))
> 			return;
> 	}

Done

>> -			bio_free(bio);
>> +	if (bio_flagged(bio, BIO_PERCPU_CACHE)) {
>> +		struct bio_alloc_cache *cache;
>> +
>> +		bio_uninit(bio);
>> +		cache = per_cpu_ptr(bio->bi_pool->cache, get_cpu());
>> +		bio_list_add_head(&cache->free_list, bio);
>> +		cache->nr++;
>> +		if (cache->nr > ALLOC_CACHE_MAX + ALLOC_CACHE_SLACK)
> 
> Folding the increment as a prefix here would make the increment and test
> semantics a little more obvious.

I don't really care that deeply about it, but I generally prefer keeping
them separate as it makes it easier to read (for me). But I'll change it.

>> +struct bio *bio_alloc_kiocb(struct kiocb *kiocb, gfp_t gfp,
>> +			    unsigned short nr_vecs, struct bio_set *bs)
>> +{
>> +	struct bio_alloc_cache *cache = NULL;
>> +	struct bio *bio;
>> +
>> +	if (!(kiocb->ki_flags & IOCB_ALLOC_CACHE) || nr_vecs > BIO_INLINE_VECS)
>> +		goto normal_alloc;
>> +
>> +	cache = per_cpu_ptr(bs->cache, get_cpu());
>> +	bio = bio_list_pop(&cache->free_list);
>> +	if (bio) {
>> +		cache->nr--;
>> +		put_cpu();
>> +		bio_init(bio, nr_vecs ? bio->bi_inline_vecs : NULL, nr_vecs);
>> +		bio_set_flag(bio, BIO_PERCPU_CACHE);
>> +		return bio;
>> +	}
>> +	put_cpu();
>> +normal_alloc:
>> +	bio = bio_alloc_bioset(gfp, nr_vecs, bs);
>> +	if (cache)
>> +		bio_set_flag(bio, BIO_PERCPU_CACHE);
>> +	return bio;
> 
> The goto here is pretty obsfucating and adds an extra patch to the fast
> path.

I don't agree, and it's not the fast path - the fast path is popping off
a bio off the list, not hitting the allocator.

> Also I don't think we need the gfp argument here at all - it should
> always be GFP_KERNEL.  In fact I plan to kill these arguments from much
> of the block layer as the places that need NOIO of NOFS semantics can
> and should move to set that in the per-thread context.

Yeah, I actually kept it on purpose for future users, but let's just
kill it as both potential use cases I have use GFP_KERNEL anyway.

>> -static inline struct bio *bio_list_pop(struct bio_list *bl)
>> +static inline void bio_list_del_head(struct bio_list *bl, struct bio *head)
>>  {
>> -	struct bio *bio = bl->head;
>> -
>> -	if (bio) {
>> +	if (head) {
>>  		bl->head = bl->head->bi_next;
>>  		if (!bl->head)
>>  			bl->tail = NULL;
>>  
>> -		bio->bi_next = NULL;
>> +		head->bi_next = NULL;
>>  	}
>> +}
>> +
>> +static inline struct bio *bio_list_pop(struct bio_list *bl)
>> +{
>> +	struct bio *bio = bl->head;
>>  
>> +	bio_list_del_head(bl, bio);
>>  	return bio;
>>  }
> 
> No need for this change.

Leftover from earlier series, killed it now.

>> @@ -699,6 +706,12 @@ struct bio_set {
>>  	struct kmem_cache *bio_slab;
>>  	unsigned int front_pad;
>>  
>> +	/*
>> +	 * per-cpu bio alloc cache and notifier
>> +	 */
>> +	struct bio_alloc_cache __percpu *cache;
>> +	struct hlist_node cpuhp_dead;
>> +
> 
> I'd keep the hotplug list entry at the end instead of bloating the
> cache line used in the fast path.

Good point, moved to the end.

-- 
Jens Axboe

