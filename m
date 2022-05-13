Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB6E0525B03
	for <lists+io-uring@lfdr.de>; Fri, 13 May 2022 07:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359652AbiEMF2t (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 May 2022 01:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344254AbiEMF2q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 May 2022 01:28:46 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FAAB6CF43
        for <io-uring@vger.kernel.org>; Thu, 12 May 2022 22:28:45 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id iq10so7184194pjb.0
        for <io-uring@vger.kernel.org>; Thu, 12 May 2022 22:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=1ROQTCKGoukWVx7icc1s7HSkGd3uqQExDLCPzqQ7log=;
        b=qTEW8ocvMl750y6+oErzFwptpajR62xpqEwNozapCQU8KKSnfrjCgLBAXWHx6I0IyR
         qx2EzzWHAkSbtd8LP+WQrCaZD+bYKF+T44N6abA1WFjhzPnuAHaMakKlLtP2kQDCvatg
         x61HYpBO5k6mVl11qYdTa0MG+LO5IuJh4lxhb8SM+nEoTQfwOIui55CxnQ3fMRyeqpBx
         YuVWWqtOOi0Thz5Rf8ejPMD0OZ3SYqNUy2Z1R4AXiHoVPMnZl3wv7qRMtTMEfFA6U1OM
         8G3baEcTveZc3Fw0DtAXr9/CFib0IfaHTDfjTVYcKiBU/zBf7WKc1H9Fx/lcxEsTYMwE
         vgPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=1ROQTCKGoukWVx7icc1s7HSkGd3uqQExDLCPzqQ7log=;
        b=l2Z4VQjD0b8Z62xuVEjJGiKHVt2xrcL8QuIMxRbdF78JCBvYn98f14DIGPoKh8o/C1
         zGs91o7uNrenEPGVIDo+vqrvLQjuaLb7awKlDxTwL0UKJhN/lvtWmDYAVaipJ+aeEAlV
         nLKatdp2j/ZkT9YrVAMct5zOdoCu6vkyt1/QloGoq7IP2hp3X3sKcCmLOQeVXbzky7qE
         tf8AkXl+3ZJIAQmIvoYw0ik/EzK6VGIQPm5McfW+t1C4IZ/LV3xQziS4bGbR9NfDApB9
         dAS4OIvGjfi5+wkL2B6SPPcNNsEkwnk69n6schGhtKvpw/AIbIUktdbLrWHF4LJw/ZcN
         EVHQ==
X-Gm-Message-State: AOAM530CP2TyZS/RnOZ2driH0jSTfkuocME3gJ8W25POSFj44iPv8okw
        4R9DCJqWxT2SAdnH1g2pB9o=
X-Google-Smtp-Source: ABdhPJzHVBWR4Dxe3Qbw6JF6IGI78JU9TCK3Hno4yk9aStIXLJ7p3NBk25rm3DhAQvJW0+Qq4uhdeQ==
X-Received: by 2002:a17:90b:380f:b0:1dc:d54b:1888 with SMTP id mq15-20020a17090b380f00b001dcd54b1888mr3098147pjb.228.1652419724724;
        Thu, 12 May 2022 22:28:44 -0700 (PDT)
Received: from [192.168.255.10] ([106.53.4.151])
        by smtp.gmail.com with ESMTPSA id t186-20020a6281c3000000b0050dc762812esm779344pfd.8.2022.05.12.22.28.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 May 2022 22:28:44 -0700 (PDT)
Message-ID: <ac6d7ee0-3bff-3f33-c492-d5861af2d277@gmail.com>
Date:   Fri, 13 May 2022 13:28:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH 3/6] io_uring: allow allocated fixed files for
 openat/openat2
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20220509155055.72735-1-axboe@kernel.dk>
 <20220509155055.72735-4-axboe@kernel.dk>
 <e2b53efa-32d5-4732-bce3-c8b8d55ec0b9@gmail.com>
 <bac35aa1-02ee-d241-2427-207a1931c444@kernel.dk>
From:   Hao Xu <haoxu.linux@gmail.com>
In-Reply-To: <bac35aa1-02ee-d241-2427-207a1931c444@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2022/5/12 下午8:23, Jens Axboe 写道:
> On 5/12/22 2:21 AM, Hao Xu wrote:
>> ? 2022/5/9 ??11:50, Jens Axboe ??:
>>> If the application passes in IORING_FILE_INDEX_ALLOC as the file_slot,
>>> then that's a hint to allocate a fixed file descriptor rather than have
>>> one be passed in directly.
>>>
>>> This can be useful for having io_uring manage the direct descriptor space.
>>>
>>> Normal open direct requests will complete with 0 for success, and < 0
>>> in case of error. If io_uring is asked to allocated the direct descriptor,
>>> then the direct descriptor is returned in case of success.
>>>
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>> ---
>>>    fs/io_uring.c                 | 32 +++++++++++++++++++++++++++++---
>>>    include/uapi/linux/io_uring.h |  9 +++++++++
>>>    2 files changed, 38 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index 8c40411a7e78..ef999d0e09de 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -4697,7 +4697,7 @@ static int io_openat2_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>        return __io_openat_prep(req, sqe);
>>>    }
>>>    -static int __maybe_unused io_file_bitmap_get(struct io_ring_ctx *ctx)
>>> +static int io_file_bitmap_get(struct io_ring_ctx *ctx)
>>>    {
>>>        struct io_file_table *table = &ctx->file_table;
>>>        unsigned long nr = ctx->nr_user_files;
>>> @@ -4722,6 +4722,32 @@ static int __maybe_unused io_file_bitmap_get(struct io_ring_ctx *ctx)
>>>        return -ENFILE;
>>>    }
>>>    +static int io_fixed_fd_install(struct io_kiocb *req, unsigned int issue_flags,
>>> +                   struct file *file, unsigned int file_slot)
>>> +{
>>> +    int alloc_slot = file_slot == IORING_FILE_INDEX_ALLOC;
>>> +    struct io_ring_ctx *ctx = req->ctx;
>>> +    int ret;
>>> +
>>> +    if (alloc_slot) {
>>> +        io_ring_submit_lock(ctx, issue_flags);
>>> +        file_slot = io_file_bitmap_get(ctx);
>>> +        if (unlikely(file_slot < 0)) {
>>> +            io_ring_submit_unlock(ctx, issue_flags);
>>> +            return file_slot;
>>> +        }
>>> +    }
>>
>> if (alloc_slot) {
>>   ...
>> } else {
>>          file_slot -= 1;
>> }
>>
>> Otherwise there is off-by-one error.
>>
>> Others looks good,
>>
>> Reviewed-by: Hao Xu <howeyxu@tencent.com>
> 
> Thanks, you are correct, I've folded that in.
> 

Hi Jens,
I've rebased multishot accept based on your fixed-alloc branch:

https://github.com/HowHsu/linux/commits/for-5.19/io_uring_multishot_accept_v6

Let me know when ixed-alloc is ready, then I'll do the final rebase
for multishot accept and send it to the list, including the liburing
change.

Thanks,
Hao

