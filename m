Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98B2A56BA01
	for <lists+io-uring@lfdr.de>; Fri,  8 Jul 2022 14:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237030AbiGHMrS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 8 Jul 2022 08:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237613AbiGHMrR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 8 Jul 2022 08:47:17 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0026606AB
        for <io-uring@vger.kernel.org>; Fri,  8 Jul 2022 05:47:15 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id i190so9675961pge.7
        for <io-uring@vger.kernel.org>; Fri, 08 Jul 2022 05:47:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=FWZ0OYAT95gqCjcBNWAMbTFv0GczaNCC4QNrNZOG7s8=;
        b=Qv3T6X6bgqi5RFvg6M2+UUVvIVW85vkYr1CAsTLEfaZoXFYBdMPMXHm5SxZ++LjeEk
         wmnNsk3tvIhKDfS27jUJBJZ79uePhQE4GXkzMM+GYrrIFUfloQeSbnY0Q4bOlk2+nf3Z
         fsKVpf0RVEpFt9B7P8jGedD5N6IaXO/KfFLpCi8K6+WsQop9kW5Gv3HOR+dXBC9qal6C
         PTaPGsjYWxfNqEEfPGBNZMbzThVhWziSe/7xaPgZatavHjgmSHKcc9WKUO8WJ+7Bvoic
         vMCzJ29wyzVnV8JcRwGjyzKS7a5C3IPwJvh1i6DHvmV9PPEeq+FyEV9B8wdkqBuHq48Q
         wYSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=FWZ0OYAT95gqCjcBNWAMbTFv0GczaNCC4QNrNZOG7s8=;
        b=1eeLltaMP5gFZV8G0afePWH60Ch3BAOVFqWSlnBd62mj5VCM9eDSRUfw68d0ThpW+C
         Yfjlw3OGMgSvvqXjG71CSHxB1XwQ8ljeBreK4dsrESBMqGRoZ16Hf9wb1Iit1CwU5jRF
         xl5I8bbAv80akJ6fmC3VBMiT49ZQOXBxcVzJV9ypW+fLsijxrEOELpHMO+41Y+BNBWjW
         dv1LvOK7BBOdPEkkp2GOY8yT328LKInRo+BZINUj93nZoLiTDe23yepyJl27qLiokKTG
         tf3BfIQHGQEa9XLAmNPRSCsB6elaM+eIIiJQi4Q0b70e428f4LG/Hajhw/TFANbLSOJK
         lYdg==
X-Gm-Message-State: AJIora8JEHPm6ZHe5KsYpREs/9VLhaAOT8GVCymBIHCOEybHmfJOR7u4
        T8d5pUoXEOqCGSHyUavURpjvzg==
X-Google-Smtp-Source: AGRyM1v1RlMUNnoxzohe0cxV4F7jX8JaTsFs3q7plh1u1rS9EeRv4rFeTfAc9PT0mq7TXv5JAvC4IQ==
X-Received: by 2002:a63:80c8:0:b0:411:73dd:809b with SMTP id j191-20020a6380c8000000b0041173dd809bmr3138376pgd.441.1657284435141;
        Fri, 08 Jul 2022 05:47:15 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id g1-20020a625201000000b00528c16966casm4826087pfb.174.2022.07.08.05.47.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Jul 2022 05:47:14 -0700 (PDT)
Message-ID: <36fb29fd-d992-7f89-f551-6ec86214ae0a@kernel.dk>
Date:   Fri, 8 Jul 2022 06:47:13 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 4/4] io_uring: add netmsg cache
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Cc:     "asml.silence@gmail.com" <asml.silence@gmail.com>
References: <20220707232345.54424-1-axboe@kernel.dk>
 <20220707232345.54424-5-axboe@kernel.dk>
 <53378566ebb86a60d7d1dda0381fe5a4009c9ee4.camel@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <53378566ebb86a60d7d1dda0381fe5a4009c9ee4.camel@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/8/22 1:33 AM, Dylan Yudaken wrote:
> On Thu, 2022-07-07 at 17:23 -0600, Jens Axboe wrote:
>> For recvmsg/sendmsg, if they don't complete inline, we currently need
>> to allocate a struct io_async_msghdr for each request. This is a
>> somewhat large struct.
>>
>> Hook up sendmsg/recvmsg to use the io_alloc_cache. This reduces the
>> alloc + free overhead considerably, yielding 4-5% of extra
>> performance
>> running netbench.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  include/linux/io_uring_types.h |  6 ++-
>>  io_uring/io_uring.c            |  3 ++
>>  io_uring/net.c                 | 73 +++++++++++++++++++++++++++++---
>> --
>>  io_uring/net.h                 | 11 ++++-
>>  4 files changed, 81 insertions(+), 12 deletions(-)
>>
>> diff --git a/include/linux/io_uring_types.h
>> b/include/linux/io_uring_types.h
>> index bf8f95332eda..d54b8b7e0746 100644
>> --- a/include/linux/io_uring_types.h
>> +++ b/include/linux/io_uring_types.h
>> @@ -222,8 +222,7 @@ struct io_ring_ctx {
>>                 struct io_hash_table    cancel_table_locked;
>>                 struct list_head        cq_overflow_list;
>>                 struct io_alloc_cache   apoll_cache;
>> -               struct xarray           personalities;
>> -               u32                     pers_next;
>> +               struct io_alloc_cache   netmsg_cache;
>>         } ____cacheline_aligned_in_smp;
>>  
>>         /* IRQ completion list, under ->completion_lock */
>> @@ -241,6 +240,9 @@ struct io_ring_ctx {
>>         unsigned int            file_alloc_start;
>>         unsigned int            file_alloc_end;
>>  
>> +       struct xarray           personalities;
>> +       u32                     pers_next;
>> +
>>         struct {
>>                 /*
>>                  * We cache a range of free CQEs we can use, once
>> exhausted it
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index b5098773d924..32110c5b4059 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -89,6 +89,7 @@
>>  #include "kbuf.h"
>>  #include "rsrc.h"
>>  #include "cancel.h"
>> +#include "net.h"
>>  
>>  #include "timeout.h"
>>  #include "poll.h"
>> @@ -297,6 +298,7 @@ static __cold struct io_ring_ctx
>> *io_ring_ctx_alloc(struct io_uring_params *p)
>>         INIT_LIST_HEAD(&ctx->cq_overflow_list);
>>         INIT_LIST_HEAD(&ctx->io_buffers_cache);
>>         io_alloc_cache_init(&ctx->apoll_cache);
>> +       io_alloc_cache_init(&ctx->netmsg_cache);
>>         init_completion(&ctx->ref_comp);
>>         xa_init_flags(&ctx->personalities, XA_FLAGS_ALLOC1);
>>         mutex_init(&ctx->uring_lock);
>> @@ -2473,6 +2475,7 @@ static __cold void io_ring_ctx_free(struct
>> io_ring_ctx *ctx)
>>                 __io_cqring_overflow_flush(ctx, true);
>>         io_eventfd_unregister(ctx);
>>         io_flush_apoll_cache(ctx);
>> +       io_flush_netmsg_cache(ctx);
>>         mutex_unlock(&ctx->uring_lock);
>>         io_destroy_buffers(ctx);
>>         if (ctx->sq_creds)
>> diff --git a/io_uring/net.c b/io_uring/net.c
>> index 6679069eeef1..ba7e94ff287c 100644
>> --- a/io_uring/net.c
>> +++ b/io_uring/net.c
>> @@ -12,6 +12,7 @@
>>  
>>  #include "io_uring.h"
>>  #include "kbuf.h"
>> +#include "alloc_cache.h"
>>  #include "net.h"
>>  
>>  #if defined(CONFIG_NET)
>> @@ -97,18 +98,57 @@ static bool io_net_retry(struct socket *sock, int
>> flags)
>>         return sock->type == SOCK_STREAM || sock->type ==
>> SOCK_SEQPACKET;
>>  }
>>  
>> +static void io_netmsg_recycle(struct io_kiocb *req, unsigned int
>> issue_flags)
>> +{
>> +       struct io_async_msghdr *hdr = req->async_data;
>> +
>> +       if (!hdr || issue_flags & IO_URING_F_UNLOCKED)
>> +               return;
>> +
>> +       if (io_alloc_cache_store(&req->ctx->netmsg_cache)) {
>> +               hlist_add_head(&hdr->cache_list, &req->ctx-
>>> netmsg_cache.list);
> 
> can io_alloc_cache_store just do the store?
> would be nicer to have cache::list be generally unused outside of the
> cache code.

We could do that if we just make the hlist_node be inside a struct.
Would probably allow cleaning up the get-entry etc too, let me give that
a whirl.

-- 
Jens Axboe

