Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF6852626A
	for <lists+io-uring@lfdr.de>; Fri, 13 May 2022 14:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377204AbiEMM45 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 May 2022 08:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356173AbiEMM45 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 May 2022 08:56:57 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54486994E1
        for <io-uring@vger.kernel.org>; Fri, 13 May 2022 05:56:54 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id l11so7406791pgt.13
        for <io-uring@vger.kernel.org>; Fri, 13 May 2022 05:56:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=n5MU0bGJDxV206zfW7h9CtlNaiueHKfFuHAjwLaA3AM=;
        b=LWCzxek0sRFuilVZNL76VGAb6sIciJcUD/9RzyEDCC5F3sa+M9JOje0b9n8p8lI+Jc
         kKN/eD7vDwc8YB17W72bajybE9shUhZygsetrqwKTfTueYxGBnuOrEhdHezRAKXm/rZ+
         8h86NRt1qBycu9SrQn8xPwLMnFN/AwAjfLHjjeAS1W/GTjqo403IiUubZR2QRSswl6h8
         UR5GyLOQSWkyS2Cyz6T/Q+KeHHx3WpYb5P4VkdQ8V+gkjv7Yxq1oxcK2GqKhkihd2Wv0
         +IxiMEkuF9lut3/nKnN773kt6Av1a6vCTT2RC2uqlFdBet9S7cDt0y9XrO6ZHJUztw+p
         nCNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=n5MU0bGJDxV206zfW7h9CtlNaiueHKfFuHAjwLaA3AM=;
        b=4Vlb0Lvm+LIk6l26QTIGp9m+RFd+2Au1M/OZTxuxlTkC6sN4E+hkT6FQCJuwYB+BJi
         BTy7xyOujEXY0YBsgDhjyp+5FRvYQD4a9wcCRCWXnkSWv1x5pwf4Gxm2ioAldLXazqC/
         Wu7SCUBjmw7J/PmzzkdBcaXU7Phl5NDKcJtyj2sAQdSt0MsJDIdUSmn3Q3KnQvjlSJ99
         y2ukp2iL8Ys/X+u12LInaDkIdIRvKJUNoSG760RvGHmuoMrAlCRsyKDj9F4cC6rrtHhE
         iCLb6oH5QeKAWmmHWZYdC0we7GV3jF0dht2pSUKn60t4gk4OLDkDH3AwNNoYJltqNtXC
         7lqQ==
X-Gm-Message-State: AOAM5330TyvzjoRZ0vkzC/xrXtQEtrKhoz8Aeh+Xq63pXoOe58CWtesJ
        t/SQbE43friv8W6jvtzwE+rWDURTMvpYMw==
X-Google-Smtp-Source: ABdhPJyIdPBpZnwZAYKngaI3iUBSPACcCAkA0iwJ39XhVHi1XHYU+nR6CSzDUyogCftz2msO8kW/HA==
X-Received: by 2002:a65:4c44:0:b0:39c:e0b5:cd2a with SMTP id l4-20020a654c44000000b0039ce0b5cd2amr3879452pgr.481.1652446614088;
        Fri, 13 May 2022 05:56:54 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id u20-20020a63b554000000b003c6445e2aa8sm1550383pgo.4.2022.05.13.05.56.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 May 2022 05:56:53 -0700 (PDT)
Message-ID: <062d1174-d92b-77ba-15d5-d02a5327d854@kernel.dk>
Date:   Fri, 13 May 2022 06:56:52 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 3/6] io_uring: allow allocated fixed files for
 openat/openat2
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Hao Xu <haoxu.linux@gmail.com>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20220509155055.72735-1-axboe@kernel.dk>
 <20220509155055.72735-4-axboe@kernel.dk>
 <e2b53efa-32d5-4732-bce3-c8b8d55ec0b9@gmail.com>
 <bac35aa1-02ee-d241-2427-207a1931c444@kernel.dk>
 <ac6d7ee0-3bff-3f33-c492-d5861af2d277@gmail.com>
 <e7726450-8004-a3e0-e5c7-b315eb0e9b6e@kernel.dk>
In-Reply-To: <e7726450-8004-a3e0-e5c7-b315eb0e9b6e@kernel.dk>
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

On 5/13/22 6:25 AM, Jens Axboe wrote:
> On 5/12/22 11:28 PM, Hao Xu wrote:
>> ? 2022/5/12 ??8:23, Jens Axboe ??:
>>> On 5/12/22 2:21 AM, Hao Xu wrote:
>>>> ? 2022/5/9 ??11:50, Jens Axboe ??:
>>>>> If the application passes in IORING_FILE_INDEX_ALLOC as the file_slot,
>>>>> then that's a hint to allocate a fixed file descriptor rather than have
>>>>> one be passed in directly.
>>>>>
>>>>> This can be useful for having io_uring manage the direct descriptor space.
>>>>>
>>>>> Normal open direct requests will complete with 0 for success, and < 0
>>>>> in case of error. If io_uring is asked to allocated the direct descriptor,
>>>>> then the direct descriptor is returned in case of success.
>>>>>
>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>> ---
>>>>>    fs/io_uring.c                 | 32 +++++++++++++++++++++++++++++---
>>>>>    include/uapi/linux/io_uring.h |  9 +++++++++
>>>>>    2 files changed, 38 insertions(+), 3 deletions(-)
>>>>>
>>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>>> index 8c40411a7e78..ef999d0e09de 100644
>>>>> --- a/fs/io_uring.c
>>>>> +++ b/fs/io_uring.c
>>>>> @@ -4697,7 +4697,7 @@ static int io_openat2_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>>>        return __io_openat_prep(req, sqe);
>>>>>    }
>>>>>    -static int __maybe_unused io_file_bitmap_get(struct io_ring_ctx *ctx)
>>>>> +static int io_file_bitmap_get(struct io_ring_ctx *ctx)
>>>>>    {
>>>>>        struct io_file_table *table = &ctx->file_table;
>>>>>        unsigned long nr = ctx->nr_user_files;
>>>>> @@ -4722,6 +4722,32 @@ static int __maybe_unused io_file_bitmap_get(struct io_ring_ctx *ctx)
>>>>>        return -ENFILE;
>>>>>    }
>>>>>    +static int io_fixed_fd_install(struct io_kiocb *req, unsigned int issue_flags,
>>>>> +                   struct file *file, unsigned int file_slot)
>>>>> +{
>>>>> +    int alloc_slot = file_slot == IORING_FILE_INDEX_ALLOC;
>>>>> +    struct io_ring_ctx *ctx = req->ctx;
>>>>> +    int ret;
>>>>> +
>>>>> +    if (alloc_slot) {
>>>>> +        io_ring_submit_lock(ctx, issue_flags);
>>>>> +        file_slot = io_file_bitmap_get(ctx);
>>>>> +        if (unlikely(file_slot < 0)) {
>>>>> +            io_ring_submit_unlock(ctx, issue_flags);
>>>>> +            return file_slot;
>>>>> +        }
>>>>> +    }
>>>>
>>>> if (alloc_slot) {
>>>>   ...
>>>> } else {
>>>>          file_slot -= 1;
>>>> }
>>>>
>>>> Otherwise there is off-by-one error.
>>>>
>>>> Others looks good,
>>>>
>>>> Reviewed-by: Hao Xu <howeyxu@tencent.com>
>>>
>>> Thanks, you are correct, I've folded that in.
>>>
>>
>> Hi Jens,
>> I've rebased multishot accept based on your fixed-alloc branch:
>>
>> https://github.com/HowHsu/linux/commits/for-5.19/io_uring_multishot_accept_v6
>>
>> Let me know when ixed-alloc is ready, then I'll do the final rebase
>> for multishot accept and send it to the list, including the liburing
>> change.
> 
> Just base it against for-5.19/io_uring, I'm fixing the one-off and
> pushing it out.

You can send it against now, I don't think there's any further changes
needed.

-- 
Jens Axboe

