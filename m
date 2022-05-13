Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 279475261C9
	for <lists+io-uring@lfdr.de>; Fri, 13 May 2022 14:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232430AbiEMM01 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 May 2022 08:26:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359612AbiEMM0B (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 May 2022 08:26:01 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B9B5B40
        for <io-uring@vger.kernel.org>; Fri, 13 May 2022 05:25:59 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id x12so7352393pgj.7
        for <io-uring@vger.kernel.org>; Fri, 13 May 2022 05:25:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=mgbd48TW30rg0ViY3f/60iyt3qhcJ1kMIO+coZN5Ba4=;
        b=dsaow0EHqUawKAdqLkbtuhJzbw61moNEcs0bSupQsz4inuyYSzs4kpZCiNsyptZbPf
         PFTopfj5O7iTjAsRzcvMyvc7CMn/0qtHsJJekdkevfEdp2WuNBrO46fmu7FMYWvIC3l/
         dffvRPq9UHGfMcD80j6OaTJPWHEWDRXXUuSxXKW5Vbo5v31gBLGfXq8v1QtQ4oaOH2wo
         vpLUEKKoulg4rUGAN7Lyu734+/I2U9tORs+Z+DMizsmnNzZKDRCTQFib+vasE5fGxcKe
         QYCz8agAq0F8ITs2iIqB6ezcHkO32wwSFc6R7EGb0cxMviPzFnrYx6HTz0S/o4wSYkLc
         gjdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mgbd48TW30rg0ViY3f/60iyt3qhcJ1kMIO+coZN5Ba4=;
        b=dxJ2dOgX7V4Ws99jPHD9SKiW04XNulLyaZu6JXVVvooJlBp6Cfo+6kyMbbKapm6L84
         DflsJG4ruw/mdgImZZr1FatLvVvg0Y132bu1leMPtMwFmE/1MG7VdySteKlfwXDE8VEB
         CECf7RsfN2izfuooIrsIly3uN8PiCZb+Z/tW6hDPa25sETOH7lbKHibj0VDqM0omP93l
         wkkm8o8DtHmXgR0ZSsq4l5LKSe5JrnJmQmW+3MTu6J+j3OAcz1AzOIYNfR9gA/yoXFp5
         hPLN9pqr6jahveT6wjaKyT2TCNacUJP0Ez4XJyLh6RnTik4zm1ItHjrnkA1Dg+jxd2Ky
         cMaA==
X-Gm-Message-State: AOAM5333KeOFZEK+EZq24x5xMfczeOUkGrtwdfiGJBqthFABd9eiGAh9
        8puEZUhRY70vQaEG97TkCOm/Otb4zGcGRw==
X-Google-Smtp-Source: ABdhPJzAlkVG4jwLSkZ7eWMTgTW0tZwoDoWMr29A6erPx1c98MPfUk22bvp8qhcxcK52aGwoLNTn0Q==
X-Received: by 2002:a05:6a00:806:b0:50d:dd03:a03a with SMTP id m6-20020a056a00080600b0050ddd03a03amr4607285pfk.57.1652444758621;
        Fri, 13 May 2022 05:25:58 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 4-20020a170902c20400b0015ef8ef0cddsm1677232pll.213.2022.05.13.05.25.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 May 2022 05:25:57 -0700 (PDT)
Message-ID: <e7726450-8004-a3e0-e5c7-b315eb0e9b6e@kernel.dk>
Date:   Fri, 13 May 2022 06:25:56 -0600
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
 <bac35aa1-02ee-d241-2427-207a1931c444@kernel.dk>
 <ac6d7ee0-3bff-3f33-c492-d5861af2d277@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ac6d7ee0-3bff-3f33-c492-d5861af2d277@gmail.com>
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

On 5/12/22 11:28 PM, Hao Xu wrote:
> ? 2022/5/12 ??8:23, Jens Axboe ??:
>> On 5/12/22 2:21 AM, Hao Xu wrote:
>>> ? 2022/5/9 ??11:50, Jens Axboe ??:
>>>> If the application passes in IORING_FILE_INDEX_ALLOC as the file_slot,
>>>> then that's a hint to allocate a fixed file descriptor rather than have
>>>> one be passed in directly.
>>>>
>>>> This can be useful for having io_uring manage the direct descriptor space.
>>>>
>>>> Normal open direct requests will complete with 0 for success, and < 0
>>>> in case of error. If io_uring is asked to allocated the direct descriptor,
>>>> then the direct descriptor is returned in case of success.
>>>>
>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>> ---
>>>>    fs/io_uring.c                 | 32 +++++++++++++++++++++++++++++---
>>>>    include/uapi/linux/io_uring.h |  9 +++++++++
>>>>    2 files changed, 38 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>> index 8c40411a7e78..ef999d0e09de 100644
>>>> --- a/fs/io_uring.c
>>>> +++ b/fs/io_uring.c
>>>> @@ -4697,7 +4697,7 @@ static int io_openat2_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>>        return __io_openat_prep(req, sqe);
>>>>    }
>>>>    -static int __maybe_unused io_file_bitmap_get(struct io_ring_ctx *ctx)
>>>> +static int io_file_bitmap_get(struct io_ring_ctx *ctx)
>>>>    {
>>>>        struct io_file_table *table = &ctx->file_table;
>>>>        unsigned long nr = ctx->nr_user_files;
>>>> @@ -4722,6 +4722,32 @@ static int __maybe_unused io_file_bitmap_get(struct io_ring_ctx *ctx)
>>>>        return -ENFILE;
>>>>    }
>>>>    +static int io_fixed_fd_install(struct io_kiocb *req, unsigned int issue_flags,
>>>> +                   struct file *file, unsigned int file_slot)
>>>> +{
>>>> +    int alloc_slot = file_slot == IORING_FILE_INDEX_ALLOC;
>>>> +    struct io_ring_ctx *ctx = req->ctx;
>>>> +    int ret;
>>>> +
>>>> +    if (alloc_slot) {
>>>> +        io_ring_submit_lock(ctx, issue_flags);
>>>> +        file_slot = io_file_bitmap_get(ctx);
>>>> +        if (unlikely(file_slot < 0)) {
>>>> +            io_ring_submit_unlock(ctx, issue_flags);
>>>> +            return file_slot;
>>>> +        }
>>>> +    }
>>>
>>> if (alloc_slot) {
>>>   ...
>>> } else {
>>>          file_slot -= 1;
>>> }
>>>
>>> Otherwise there is off-by-one error.
>>>
>>> Others looks good,
>>>
>>> Reviewed-by: Hao Xu <howeyxu@tencent.com>
>>
>> Thanks, you are correct, I've folded that in.
>>
> 
> Hi Jens,
> I've rebased multishot accept based on your fixed-alloc branch:
> 
> https://github.com/HowHsu/linux/commits/for-5.19/io_uring_multishot_accept_v6
> 
> Let me know when ixed-alloc is ready, then I'll do the final rebase
> for multishot accept and send it to the list, including the liburing
> change.

Just base it against for-5.19/io_uring, I'm fixing the one-off and
pushing it out.

-- 
Jens Axboe

