Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA9E69E7A4
	for <lists+io-uring@lfdr.de>; Tue, 21 Feb 2023 19:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbjBUSiK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Feb 2023 13:38:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbjBUSiJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Feb 2023 13:38:09 -0500
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C3C212E;
        Tue, 21 Feb 2023 10:38:07 -0800 (PST)
Received: by mail-wr1-f50.google.com with SMTP id j2so5314427wrh.9;
        Tue, 21 Feb 2023 10:38:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to:subject:cc
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=erB3/GtUGm9+YBWIftw38TCv2hPM2fpW+cbxQs8tCIg=;
        b=c88npd80hGOgqXa33VdVD0SIN32Ov5zDYi1VmpZ4G2rgTynDuRi4UXLpNezWtj0GXV
         D3n0JgqAHA+kRHgyMbU1vEvpg8e3h6bvdLVKkcvIUNxhwN/7prgb4aCOWp8q11nPe5Bw
         p5l5rYIqseQFDtZKNci52IaMl4zaXcYZ9s2aFCmS70hYt3RskXGmFvlxswyqWyVs1F1r
         0oMyIrx+7y4owu/I3RU9IJCMJ8hlDGAPkKe7um0Ru38ok1oRskj80B93VT4SC4TD9/Y/
         Kvb4ajZpHL70o+nVyedyLnaRhkYzfRbb/SYgnOJraLM4f9q/Rt0PxgJRUcHme8QVaTWr
         lS7w==
X-Gm-Message-State: AO0yUKXalclRBV5olvLTDO599qIJyHaXwX+DQpdXc/JAcUOEyeywdiSi
        HMnd20gs66IrF68a1V5GQDs=
X-Google-Smtp-Source: AK7set+QiVgzPQAzplKfJJnBHmZzm/XiWqW3q+r9FthIfUSfZTLEANmj1ddlDL/JoIXL3kxJQfr7Sw==
X-Received: by 2002:a05:6000:cd:b0:2c5:ab27:d344 with SMTP id q13-20020a05600000cd00b002c5ab27d344mr4209573wrx.20.1677004685946;
        Tue, 21 Feb 2023 10:38:05 -0800 (PST)
Received: from ?IPV6:2620:10d:c0c3:1136:1486:5f6c:3f1:4b78? ([2620:10d:c092:400::5:543])
        by smtp.gmail.com with ESMTPSA id o24-20020a5d58d8000000b002c7066a6f77sm2056204wrf.31.2023.02.21.10.38.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Feb 2023 10:38:05 -0800 (PST)
Message-ID: <b04b7d5d-582f-1b45-efa3-6e951dfc3cbf@debian.org>
Date:   Tue, 21 Feb 2023 18:38:03 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Cc:     leit@meta.com, linux-kernel@vger.kernel.org, gustavold@meta.com
Subject: Re: [PATCH 1/2] io_uring: Move from hlist to io_wq_work_node
To:     Pavel Begunkov <asml.silence@gmail.com>, axboe@kernel.dk,
        io-uring@vger.kernel.org
References: <20230221135721.3230763-1-leitao@debian.org>
 <782b4b43-790c-6e89-ea74-aac1fd4ff1e2@gmail.com>
From:   Breno Leitao <leitao@debian.org>
In-Reply-To: <782b4b43-790c-6e89-ea74-aac1fd4ff1e2@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 21/02/2023 17:45, Pavel Begunkov wrote:
> On 2/21/23 13:57, Breno Leitao wrote:
>> Having cache entries linked using the hlist format brings no benefit, and
>> also requires an unnecessary extra pointer address per cache entry.
>>
>> Use the internal io_wq_work_node single-linked list for the internal
>> alloc caches (async_msghdr and async_poll)
>>
>> This is required to be able to use KASAN on cache entries, since we do
>> not need to touch unused (and poisoned) cache entries when adding more
>> entries to the list.
> 
> Looks good, a few nits
> 
>>
>> Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
>> Signed-off-by: Breno Leitao <leitao@debian.org>
>> ---
>>   include/linux/io_uring_types.h |  2 +-
>>   io_uring/alloc_cache.h         | 27 +++++++++++++++------------
>>   2 files changed, 16 insertions(+), 13 deletions(-)
>>
>> diff --git a/include/linux/io_uring_types.h
>> b/include/linux/io_uring_types.h
>> index 0efe4d784358..efa66b6c32c9 100644
>> --- a/include/linux/io_uring_types.h
>> +++ b/include/linux/io_uring_types.h
>> @@ -188,7 +188,7 @@ struct io_ev_fd {
>>   };
>>   
> [...]
>> -    if (!hlist_empty(&cache->list)) {
>> -        struct hlist_node *node = cache->list.first;
>> -
>> -        hlist_del(node);
>> -        return container_of(node, struct io_cache_entry, node);
>> +    struct io_wq_work_node *node;
>> +    struct io_cache_entry *entry;
>> +
>> +    if (cache->list.next) {
>> +        node = cache->list.next;
>> +        entry = container_of(node, struct io_cache_entry, node);
> 
> I'd prefer to get rid of the node var, it'd be a bit cleaner
> than keeping two pointers to the same chunk.
> 
> entry = container_of(node, struct io_cache_entry,
>                      cache->list.next);
> 
>> +        cache->list.next = node->next;
>> +        return entry;
>>       }
>>         return NULL;
>> @@ -35,19 +38,19 @@ static inline struct io_cache_entry
>> *io_alloc_cache_get(struct io_alloc_cache *c
>>     static inline void io_alloc_cache_init(struct io_alloc_cache *cache)
>>   {
>> -    INIT_HLIST_HEAD(&cache->list);
>> +    cache->list.next = NULL;
>>       cache->nr_cached = 0;
>>   }
>>     static inline void io_alloc_cache_free(struct io_alloc_cache *cache,
>>                       void (*free)(struct io_cache_entry *))
>>   {
>> -    while (!hlist_empty(&cache->list)) {
>> -        struct hlist_node *node = cache->list.first;
>> +    struct io_cache_entry *entry;
>>   -        hlist_del(node);
>> -        free(container_of(node, struct io_cache_entry, node));
>> +    while ((entry = io_alloc_cache_get(cache))) {
>> +        free(entry);
> 
> We don't need brackets here.

The extra brackets are required if we are assignments in if, otherwise
the compiler raises a warning (bugprone-assignment-in-if-condition)

> Personally, I don't have anything
> against assignments in if, but it's probably better to avoid them

Sure. I will remove the assignents in "if" part and maybe replicate what
we have
in io_alloc_cache_get(). Something as:
       if (cache->list.next) {
               node = cache->list.next;

Thanks for the review!
