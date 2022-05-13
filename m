Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A10F5261D1
	for <lists+io-uring@lfdr.de>; Fri, 13 May 2022 14:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354238AbiEMM2K (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 May 2022 08:28:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbiEMM2J (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 May 2022 08:28:09 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A07E7A
        for <io-uring@vger.kernel.org>; Fri, 13 May 2022 05:28:07 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id gj17-20020a17090b109100b001d8b390f77bso10697018pjb.1
        for <io-uring@vger.kernel.org>; Fri, 13 May 2022 05:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=484ltZZEZJb9fqOjG4DnqprnGWQlxkPZzWP2MFGQbug=;
        b=JC6kblQgOLGpWcvd1rLgEcxqPzTRWKxR82KewfuR110dodg9puABo7+EBrdNbGaJhz
         ENsb/36H7ZOmSX0PDTuATqzmONsKs6KwzlQyURW4KStsTB/fc/8/9GNPljvENdnwy4Tb
         CxlXK1g8gKtCRoyZhI17dsQryjpuxZnnhORn2SLIfmze0HsoxIVmIuPFb6vVS2iZK7ni
         mM/okhokPXOAVC7Hk1jKfuys3Wm1E40GGVVaSVLCKbuuWYc1uym222HekYbRcL5Kd/1v
         bP5foMku+pf69on9ONzOPs0pqYlisDdWnhfvsDlYv1ZOQvSQdpePBPWwiO08nH+O6HkD
         Qa8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=484ltZZEZJb9fqOjG4DnqprnGWQlxkPZzWP2MFGQbug=;
        b=stxxnWBK3rLsbXsIBbnUNfpGVmDcagvBPfXHlJbt38kTmTtfCXKcAPkeoCk0VmO9gC
         axUZKfhPcEgEvhZvl2tgGoj43JJldDRno0HVKbGxL6EHh66g2/SROop00faQljT4N4pu
         eJZKdg0wxS9uwLi8gCHsuBn2f/scegBmmeJREUCH7Ec3imkEqjtGH2Rvy000H+E5sJsI
         KWdMhlH/WWbtRNxZco5KG4qfJ9q1WIBDkpq4QY8hVnPuj9fbLcUC76CUEIWEOn9Gn2/Z
         CZv/Tk4mVSXdx+5ysBNxw9KpYUbFcal+yby319TQR9DyznG4tCS8g9iJr4Qkt5Nl7FiV
         PAAg==
X-Gm-Message-State: AOAM530/9qEx80d0EDbRuZrgtKXA4hah3GMGnS4zO+Mm1aSI2luUOWG4
        SaZonj9yHuKso8VACoOqsIhiXkIGjRh1ag==
X-Google-Smtp-Source: ABdhPJzjwwX4jpD9UpDKgEpndysmA3D1CMd5eL5CdTwCu6/XsGgybw0Ncnxml3aw0W5iA56C2gCB1Q==
X-Received: by 2002:a17:90a:7c4a:b0:1dc:f28f:4e06 with SMTP id e10-20020a17090a7c4a00b001dcf28f4e06mr4760846pjl.48.1652444887138;
        Fri, 13 May 2022 05:28:07 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id t28-20020a62d15c000000b0050dc762815csm1662102pfl.54.2022.05.13.05.28.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 May 2022 05:28:05 -0700 (PDT)
Message-ID: <be4b383e-76be-55d5-1a85-358c7cf9c77a@kernel.dk>
Date:   Fri, 13 May 2022 06:28:03 -0600
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
 <d9a5da57-ae34-b137-3ef8-fe6d6b16359a@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <d9a5da57-ae34-b137-3ef8-fe6d6b16359a@gmail.com>
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

On 5/12/22 10:38 PM, Hao Xu wrote:
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
>> +
>> +    ret = io_install_fixed_file(req, file, issue_flags, file_slot);
>> +    if (alloc_slot) {
>> +        io_ring_submit_unlock(ctx, issue_flags);
>> +        if (!ret)
>> +            return file_slot;
> 
> Sorry, I missed onething, looks like this should be file_slot+1, as this
> is returned to the userspace. I refer to the previous open/accept direct
> feature, they see the file_index from userspace as number counted from
> one, so it'd better to keep it consistent.

We need to return the actual slot, not slot + 1. It's kind of an ugly
API, but what we had left to deal with. The actual slot number is what
most other things would fill into sqe->fd and set IOSQE_FIXED_FILE with,
not slot + 1.

-- 
Jens Axboe

