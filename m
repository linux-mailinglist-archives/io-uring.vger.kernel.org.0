Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 978C869E7CB
	for <lists+io-uring@lfdr.de>; Tue, 21 Feb 2023 19:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbjBUSoL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Feb 2023 13:44:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbjBUSoI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Feb 2023 13:44:08 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59E781D922;
        Tue, 21 Feb 2023 10:44:06 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id o14so4312615wms.1;
        Tue, 21 Feb 2023 10:44:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1gzuCAVz6kfv/0+vDaFZ6agJKGlpUGSwLCeHL3z5J7I=;
        b=nAdcMw/CepSBBTS7InlcuvR+eNMiu3Jm7KJ/K4TeArF7yN1WRFN0AeJnBozRCvJaGy
         QQuj4NwpL3A0CsUigZ0FnR5r035n9RsWKCb5FyNH7C1ufQcbeSPZlk8oFrawdXzQdtnZ
         eI2CZ3qoDNkUTRGohNCAgfSB1FzJyfjd48sjE6MD1vM6JCR9fh3kpm7nteY/Co+fhEAf
         u52dBc5izliljGjYPSEygtqAddvPCRwG8sZpRy4T2nD9rFtRnsZqQ9M/suzLKHdgXD6b
         vwRLP93wOx4ZtAQL6rrMc2NBwY8Qw07t0A8GHy+xy4MUoFwuM9XXAhJa3lyiHZf1kXob
         Aeyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1gzuCAVz6kfv/0+vDaFZ6agJKGlpUGSwLCeHL3z5J7I=;
        b=TGK2BiY8q7M0yaooqm9Mylao6Gg8EzhScuYQLYFxAGChv6JxLKfqSHwgfhCi3rsSEF
         lzy9Hl0OeM/X0gs9206qGPJqSBv8nzVLSI7x6Zhogw5xAtSWTN9xfhlfaGitzf8nZCgA
         FFtECKFPUPPb3OBatulM8hcI6d/DXR+wGbyEhMQIQXeh5aQmoTv5JOist1nzn5YFBEIk
         SqfwSe2wUU8x2qwlraugqfsES6dGs6cdLhweEF5JZscxjYqMlZXW8s20ghB8eMBfNLTH
         selXntJa5WoU9uMOyOHwEWms0GyYZwXuPh0ein6S9nIDa90YqTolKudyTkAVofSVo3NV
         x1sg==
X-Gm-Message-State: AO0yUKXQnwqfYNvBuUPXVHWOy6IdgIKeK1wqg6DytQReKhymKdJeHGfh
        LuaER3+wFFMqnwDN0GzYra8=
X-Google-Smtp-Source: AK7set+aQZ5ClLvJ7Yr+tnUsa+QNwEnjjXNSGyFn9dvH2Eq+a8SkJO5FTLwM3D0Qscb4uKw42pYbhw==
X-Received: by 2002:a05:600c:600f:b0:3dc:4316:52be with SMTP id az15-20020a05600c600f00b003dc431652bemr4699506wmb.10.1677005044869;
        Tue, 21 Feb 2023 10:44:04 -0800 (PST)
Received: from [192.168.8.100] (94.196.95.64.threembb.co.uk. [94.196.95.64])
        by smtp.gmail.com with ESMTPSA id p13-20020a05600c1d8d00b003e1f6e18c95sm5169561wms.21.2023.02.21.10.44.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Feb 2023 10:44:04 -0800 (PST)
Message-ID: <657a599e-6ac1-610c-db15-04f428dbb5eb@gmail.com>
Date:   Tue, 21 Feb 2023 18:43:02 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH 1/2] io_uring: Move from hlist to io_wq_work_node
Content-Language: en-US
To:     Breno Leitao <leitao@debian.org>, axboe@kernel.dk,
        io-uring@vger.kernel.org
Cc:     leit@meta.com, linux-kernel@vger.kernel.org, gustavold@meta.com
References: <20230221135721.3230763-1-leitao@debian.org>
 <782b4b43-790c-6e89-ea74-aac1fd4ff1e2@gmail.com>
 <b04b7d5d-582f-1b45-efa3-6e951dfc3cbf@debian.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <b04b7d5d-582f-1b45-efa3-6e951dfc3cbf@debian.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/21/23 18:38, Breno Leitao wrote:
> On 21/02/2023 17:45, Pavel Begunkov wrote:
>> On 2/21/23 13:57, Breno Leitao wrote:
>>> Having cache entries linked using the hlist format brings no benefit, and
>>> also requires an unnecessary extra pointer address per cache entry.
>>>
>>> Use the internal io_wq_work_node single-linked list for the internal
>>> alloc caches (async_msghdr and async_poll)
>>>
>>> This is required to be able to use KASAN on cache entries, since we do
>>> not need to touch unused (and poisoned) cache entries when adding more
>>> entries to the list.
>>
>> Looks good, a few nits
>>
>>>
>>> Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
>>> Signed-off-by: Breno Leitao <leitao@debian.org>
>>> ---
>>>    include/linux/io_uring_types.h |  2 +-
>>>    io_uring/alloc_cache.h         | 27 +++++++++++++++------------
>>>    2 files changed, 16 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/include/linux/io_uring_types.h
>>> b/include/linux/io_uring_types.h
>>> index 0efe4d784358..efa66b6c32c9 100644
>>> --- a/include/linux/io_uring_types.h
>>> +++ b/include/linux/io_uring_types.h
>>> @@ -188,7 +188,7 @@ struct io_ev_fd {
>>>    };
>>>    
>> [...]
>>> -    if (!hlist_empty(&cache->list)) {
>>> -        struct hlist_node *node = cache->list.first;
>>> -
>>> -        hlist_del(node);
>>> -        return container_of(node, struct io_cache_entry, node);
>>> +    struct io_wq_work_node *node;
>>> +    struct io_cache_entry *entry;
>>> +
>>> +    if (cache->list.next) {
>>> +        node = cache->list.next;
>>> +        entry = container_of(node, struct io_cache_entry, node);
>>
>> I'd prefer to get rid of the node var, it'd be a bit cleaner
>> than keeping two pointers to the same chunk.
>>
>> entry = container_of(node, struct io_cache_entry,
>>                       cache->list.next);
>>
>>> +        cache->list.next = node->next;
>>> +        return entry;
>>>        }
>>>          return NULL;
>>> @@ -35,19 +38,19 @@ static inline struct io_cache_entry
>>> *io_alloc_cache_get(struct io_alloc_cache *c
>>>      static inline void io_alloc_cache_init(struct io_alloc_cache *cache)
>>>    {
>>> -    INIT_HLIST_HEAD(&cache->list);
>>> +    cache->list.next = NULL;
>>>        cache->nr_cached = 0;
>>>    }
>>>      static inline void io_alloc_cache_free(struct io_alloc_cache *cache,
>>>                        void (*free)(struct io_cache_entry *))
>>>    {
>>> -    while (!hlist_empty(&cache->list)) {
>>> -        struct hlist_node *node = cache->list.first;
>>> +    struct io_cache_entry *entry;
>>>    -        hlist_del(node);
>>> -        free(container_of(node, struct io_cache_entry, node));
>>> +    while ((entry = io_alloc_cache_get(cache))) {
>>> +        free(entry);
>>
>> We don't need brackets here.
> 
> The extra brackets are required if we are assignments in if, otherwise
> the compiler raises a warning (bugprone-assignment-in-if-condition)

I mean braces / curly brackets.
>> Personally, I don't have anything
>> against assignments in if, but it's probably better to avoid them
> 
> Sure. I will remove the assignents in "if" part and maybe replicate what
> we have
> in io_alloc_cache_get(). Something as:
>         if (cache->list.next) {
>                 node = cache->list.next;
> 
> Thanks for the review!

-- 
Pavel Begunkov
