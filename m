Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55D1E536CE2
	for <lists+io-uring@lfdr.de>; Sat, 28 May 2022 14:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346743AbiE1M2i (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 May 2022 08:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238619AbiE1M2h (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 May 2022 08:28:37 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1D9C1DA54
        for <io-uring@vger.kernel.org>; Sat, 28 May 2022 05:28:36 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d22so6365987plr.9
        for <io-uring@vger.kernel.org>; Sat, 28 May 2022 05:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=9hlJKVW9Z5PCQFvNHS8zjMfBOC+BrYoPzriO9dFcYUY=;
        b=oXM4sacS94fZ1BTq55ZAxGZyDeR3E84VeqoBHmIQ8Kzr3Ykt8U9VlIQUZajzQ5HMgq
         BLV1rgPMLRA7TltWfn+wwpZ7tTCIBmLJFsXbNgDScYj21qHrjTjrhU8rJwYcN1GiT+yb
         GxqyxWXb8PcOMECD6ZCPMfFz7OZsoXuA5PZNw+SOsXn2sopmkfN/dVkqNp6p42lAe2pL
         Eh2L8OJULFNgfycN6U5wUB04gcB3poy0Bi+Wk163wSzRcV9ALBVyzRxf1G+oNvnJIVvp
         hDQdUo3TTCf8Sw1cd5czENBtzKJUnDljFr+CfaUTP/DPZd4PVW6GZeFWXFRss/SAVj2C
         ivTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9hlJKVW9Z5PCQFvNHS8zjMfBOC+BrYoPzriO9dFcYUY=;
        b=ij/fr2+yZW8BPlgBx3aCW2Nej3RNGRKrFTsqF12SMMNERSesxK6cp0ArpBjb2SoMv6
         /41mfy3DwBd8xCuTiUnryYdGXYoIMcprvXnoml4DMEMmAdlZqtvIOXoRz8IfJ+1lNneS
         8lLnzaDUy4lrbF1lJOGw8exEdtvgNfK7pdgKmxDsF0mRLEeIdShM7DoxBg/8gd6RBih4
         dVHFgd81RMa4zC4Ci4nd6xz+C5pN149IWXesPZtxK4ifETz7FajxsP8wpqubY63TFXS7
         dwjceAqYV++F4IuVmeML05CDG/lrOKtXF6pQa5weABkoGE7zoSOuuWSZx91GB88KCrud
         2BOA==
X-Gm-Message-State: AOAM531AlVCZ0L6rjhh78nN/ldtVAbk70GIR/m1SBzCf32SPYyBQXEQn
        PmCSWJ2greuA/khZcB1tLLSj7+Gm8fUznw==
X-Google-Smtp-Source: ABdhPJyBUcYQXNlA6CqYC8XQieOOU5R0GvyEYtkk2/cukuB2/E3tD/3HwHmaS9K2YWsU6Rhs0vp3hQ==
X-Received: by 2002:a17:90b:2245:b0:1e0:6ad6:33c with SMTP id hk5-20020a17090b224500b001e06ad6033cmr13032516pjb.86.1653740916381;
        Sat, 28 May 2022 05:28:36 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id n1-20020a17090a670100b001dc1950ead5sm3176081pjj.38.2022.05.28.05.28.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 May 2022 05:28:35 -0700 (PDT)
Message-ID: <58d62354-0dab-e6a6-662d-26253bcb8123@kernel.dk>
Date:   Sat, 28 May 2022 06:28:34 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [RFC] io_uring: let IORING_OP_FILES_UPDATE support to choose
 fixed file slot
Content-Language: en-US
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Hao Xu <haoxu.linux@icloud.com>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20220526123848.18998-1-xiaoguang.wang@linux.alibaba.com>
 <aff94898-3642-99c4-e640-39139214dbc7@icloud.com>
 <76746921-0d10-2e8b-db30-26f1143b953b@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <76746921-0d10-2e8b-db30-26f1143b953b@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/28/22 3:45 AM, Xiaoguang Wang wrote:
> hi Hao,
> 
>> Hi Xiaoguang,
>>
>> On 5/26/22 20:38, Xiaoguang Wang wrote:
>>> One big issue with file registration feature is that it needs user
>>> space apps to maintain free slot info about io_uring's fixed file
>>> table, which really is a burden for development. Now since io_uring
>>> starts to choose free file slot for user space apps by using
>>> IORING_FILE_INDEX_ALLOC flag in accept or open operations, but they
>>> need app to uses direct accept or direct open, which as far as I know,
>>> some apps are not prepared to use direct accept or open yet.
>>>
>>> To support apps, who still need real fds, use registration feature
>>> easier, let IORING_OP_FILES_UPDATE support to choose fixed file slot,
>>> which will return free file slot in cqe->res.
>>>
>>> TODO list:
>>>      Need to prepare liburing corresponding helpers.
>>>
>>> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
>>> ---
>>>   fs/io_uring.c                 | 50 ++++++++++++++++++++++++++++++++++---------
>>>   include/uapi/linux/io_uring.h |  1 +
>>>   2 files changed, 41 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index 9f1c682d7caf..d77e6bbec81c 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -680,6 +680,7 @@ struct io_rsrc_update {
>>>       u64                arg;
>>>       u32                nr_args;
>>>       u32                offset;
>>> +    u32                flags;
>>>   };
>>>     struct io_fadvise {
>>> @@ -7970,14 +7971,23 @@ static int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
>>>       return 0;
>>>   }
>>>   +#define IORING_FILES_UPDATE_INDEX_ALLOC 1
>>> +
>>>   static int io_rsrc_update_prep(struct io_kiocb *req,
>>>                   const struct io_uring_sqe *sqe)
>>>   {
>>> +    u32 flags = READ_ONCE(sqe->files_update_flags);
>>> +
>>>       if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
>>>           return -EINVAL;
>>> -    if (sqe->rw_flags || sqe->splice_fd_in)
>>> +    if (sqe->splice_fd_in)
>>> +        return -EINVAL;
>>> +    if (flags & ~IORING_FILES_UPDATE_INDEX_ALLOC)
>>> +        return -EINVAL;
>>> +    if ((flags & IORING_FILES_UPDATE_INDEX_ALLOC) && READ_ONCE(sqe->len) != 1)
>>
>> How about allowing multiple fd update in IORING_FILES_UPDATE_INDEX_ALLOC
>> case? For example, using the sqe->addr(the fd array) to store the slots we allocated, and let cqe return the number of slots allocated.
> Good idea, I'll try in patch v2, thanks.
> Jens, any comments about this patch? At least It's really helpful to our
> internal apps based on io_uring :)

I like this suggestion too, other thoughts in reply to the original.

-- 
Jens Axboe

