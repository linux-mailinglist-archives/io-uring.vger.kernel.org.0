Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50BB8524CA0
	for <lists+io-uring@lfdr.de>; Thu, 12 May 2022 14:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353651AbiELMX1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 May 2022 08:23:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349641AbiELMXZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 May 2022 08:23:25 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CA0310F7F4
        for <io-uring@vger.kernel.org>; Thu, 12 May 2022 05:23:24 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 137so4445251pgb.5
        for <io-uring@vger.kernel.org>; Thu, 12 May 2022 05:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=3tMCRRSUjLPjs9SHMUsBfmr3dWXz1TqtKlbw80jipfQ=;
        b=WFNk2zx2mM6xdz0rh2bGyyxj4wW6UAfKjxUQW95XAdta+y6oDbSp3LpsWhm7vBwJzM
         EkXOdl3NQTqpjCz75ABxk+7TzbM44G6MMu5VUDJlcpMWjK9ZMZOAdmMNkT43Ilp0vH74
         RdBBpsWCEderrCzLRiseOFog40SFY1EfMZysCrdpM9YdelmwkpZzrK0jpt20m4xXZKD3
         JmDKlEpsRabTC9Sy3PNCtgxkZlrt4JEGfd4cqIOF9aPkxJ+4xeSbtcYehzsQYGrlWbFt
         ygMTv0mh2py1j+NbFkm/9QUAlNWz5WZdppbg1zpiN1BrR39acxVQlB9viVK/HesaWj9w
         cTcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3tMCRRSUjLPjs9SHMUsBfmr3dWXz1TqtKlbw80jipfQ=;
        b=ckeHQ/rnGFZ21sF7cmgaVGI4K9d6g+yIqavhrIApuVgfdUxfEJqfv+9oD58EIWKZRu
         ZkDL68DGfjjLMcKpaB72zQLSrqchCpUk/xWCSkRR6kgxpdJzLtJRAQ+GZAWHv1hWnlk5
         O/xCy/aczzWb8DrPCgWViRUoPfJ7aduVFxua592eoSKzaTgkcR099yrkFtsCmP7AVeTK
         yV6nE9Ks4I8AbqPrBy+EyeQqCukol7fwTSDdfWcmcrbSzqOomA+tbc0cuIG1dqna3ztD
         it7WPrbBj+K/sc/AHgtLH2jOLav9ELodO66Rb43/zsrxQ8/AfxGQVhoVRzAiLVYZB2Mc
         5sng==
X-Gm-Message-State: AOAM532SbrUzACWnwRKyb+ih7LqFIYZ4++WdUqrw3PprHh/B4pEV/gdp
        3EZB6RuZhyU50O0bSSny2NIN0Q==
X-Google-Smtp-Source: ABdhPJxYWc4TPGzueER8ipNCqKNvkO1YnT7XefXtfYOB1GPyqP2Sk0qT9U7LkpIDsdhneY6457wQjA==
X-Received: by 2002:a05:6a00:15d0:b0:50e:b15:cc43 with SMTP id o16-20020a056a0015d000b0050e0b15cc43mr29805131pfu.28.1652358203570;
        Thu, 12 May 2022 05:23:23 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id y24-20020a63de58000000b003c14af50643sm1719935pgi.91.2022.05.12.05.23.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 May 2022 05:23:22 -0700 (PDT)
Message-ID: <bac35aa1-02ee-d241-2427-207a1931c444@kernel.dk>
Date:   Thu, 12 May 2022 06:23:21 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 3/6] io_uring: allow allocated fixed files for
 openat/openat2
Content-Language: en-US
To:     Hao Xu <haoxu.linux@gmail.com>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20220509155055.72735-1-axboe@kernel.dk>
 <20220509155055.72735-4-axboe@kernel.dk>
 <e2b53efa-32d5-4732-bce3-c8b8d55ec0b9@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <e2b53efa-32d5-4732-bce3-c8b8d55ec0b9@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/12/22 2:21 AM, Hao Xu wrote:
> ? 2022/5/9 ??11:50, Jens Axboe ??:
>> If the application passes in IORING_FILE_INDEX_ALLOC as the file_slot,
>> then that's a hint to allocate a fixed file descriptor rather than have
>> one be passed in directly.
>>
>> This can be useful for having io_uring manage the direct descriptor space.
>>
>> Normal open direct requests will complete with 0 for success, and < 0
>> in case of error. If io_uring is asked to allocated the direct descriptor,
>> then the direct descriptor is returned in case of success.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>   fs/io_uring.c                 | 32 +++++++++++++++++++++++++++++---
>>   include/uapi/linux/io_uring.h |  9 +++++++++
>>   2 files changed, 38 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 8c40411a7e78..ef999d0e09de 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -4697,7 +4697,7 @@ static int io_openat2_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>       return __io_openat_prep(req, sqe);
>>   }
>>   -static int __maybe_unused io_file_bitmap_get(struct io_ring_ctx *ctx)
>> +static int io_file_bitmap_get(struct io_ring_ctx *ctx)
>>   {
>>       struct io_file_table *table = &ctx->file_table;
>>       unsigned long nr = ctx->nr_user_files;
>> @@ -4722,6 +4722,32 @@ static int __maybe_unused io_file_bitmap_get(struct io_ring_ctx *ctx)
>>       return -ENFILE;
>>   }
>>   +static int io_fixed_fd_install(struct io_kiocb *req, unsigned int issue_flags,
>> +                   struct file *file, unsigned int file_slot)
>> +{
>> +    int alloc_slot = file_slot == IORING_FILE_INDEX_ALLOC;
>> +    struct io_ring_ctx *ctx = req->ctx;
>> +    int ret;
>> +
>> +    if (alloc_slot) {
>> +        io_ring_submit_lock(ctx, issue_flags);
>> +        file_slot = io_file_bitmap_get(ctx);
>> +        if (unlikely(file_slot < 0)) {
>> +            io_ring_submit_unlock(ctx, issue_flags);
>> +            return file_slot;
>> +        }
>> +    }
> 
> if (alloc_slot) {
>  ...
> } else {
>         file_slot -= 1;
> }
> 
> Otherwise there is off-by-one error.
> 
> Others looks good,
> 
> Reviewed-by: Hao Xu <howeyxu@tencent.com>

Thanks, you are correct, I've folded that in.

-- 
Jens Axboe

