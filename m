Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB975371CF
	for <lists+io-uring@lfdr.de>; Sun, 29 May 2022 18:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbiE2Q6E (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 29 May 2022 12:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiE2Q6D (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 29 May 2022 12:58:03 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C98D568312
        for <io-uring@vger.kernel.org>; Sun, 29 May 2022 09:58:01 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id j7so2972136pjn.4
        for <io-uring@vger.kernel.org>; Sun, 29 May 2022 09:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=wWA8dUd9yX9jxRW2OeSZ2F6kqHvqZuEVqL8Q0XgUjCQ=;
        b=sFYrOjeN2yGMk1q/+QS9q50dXoDzkE/iacOqd+9nxaUrS4RIJpB+/CqOTkfe5UdTf6
         zF8UXzhA1GXbhVQr3yuQtyEHOrAVjSEh+oE0e+qyM7X1EZ4YKdfXW/V8qAzcX3hnv3zt
         y0EHxiAc+3i9vTysShgFOoMaFZD8yh612OihWt6aPRDE448T4lzSJEcNvOeTvDqppQb1
         ysK6zxDvq1sv4dyDPZ8Dye/fgwm0BOU86kaEtGig/j3HU9gjzoOPlFWoIyT6iLm+crUp
         JxGJx+6FIvQc3AhR/YlK6XDrcXcTVCkXwUq+iZzg1uHwnyZGvJ/uugdzECxY8pp0ldA3
         Nt3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=wWA8dUd9yX9jxRW2OeSZ2F6kqHvqZuEVqL8Q0XgUjCQ=;
        b=pZxlb0HRRjN/6qlcHCKxSUOJ2lRcCj4XVD/GURintfiu7nsjHwYXkkhqbu8ak5kGtX
         0h6ewG52QFsYtdRh2btAEjwEN7uf+QXg3CeyupWRUeHS3kyrEJt6IT1vSCZX6xK1Lkw0
         2tIw7UpfOxSNJj8D4ldfOfCC3s1F8TxHwmsNKMg3W8cZXGgG0eGO80QXdcJydclb+8k/
         BfmhLnujgwq0grTlYUeLN6su5d7fb59b3IkRR++vyIdBKHVlVmWXm71G1+MaJF5jTCGB
         JTEJWPXkzbykwnRTPh/rOv/SiYZDtULReiKQ+7hZdkWl6/QBUoeoQz49NqNzM0loFyat
         +qyA==
X-Gm-Message-State: AOAM530C+BhK4cdslAzOumRbKvrO5UrqaEdNLC1m4YLR7eaFJX3QO/ov
        uh0HQyRGVSlI0x+rSXz6gb8zWaVzNDu8tQ==
X-Google-Smtp-Source: ABdhPJzmTDm5/WUXB0tYhP8PiKcDZU+whTgNoe3/5+c4Y9xaqtbGGVpz9V7bGKlvHfvVgoBtxURgZA==
X-Received: by 2002:a17:90b:3141:b0:1e0:6062:9c10 with SMTP id ip1-20020a17090b314100b001e060629c10mr18865434pjb.84.1653843481250;
        Sun, 29 May 2022 09:58:01 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id y18-20020a1709029b9200b00163b2c46ef1sm3236045plp.222.2022.05.29.09.58.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 May 2022 09:58:00 -0700 (PDT)
Message-ID: <8e6585df-10d6-9f12-5e82-7d7bc905e741@kernel.dk>
Date:   Sun, 29 May 2022 10:57:59 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [RFC] io_uring: let IORING_OP_FILES_UPDATE support to choose
 fixed file slot
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Hao Xu <haoxu.linux@icloud.com>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20220526123848.18998-1-xiaoguang.wang@linux.alibaba.com>
 <aff94898-3642-99c4-e640-39139214dbc7@icloud.com>
 <76746921-0d10-2e8b-db30-26f1143b953b@linux.alibaba.com>
 <58d62354-0dab-e6a6-662d-26253bcb8123@kernel.dk>
In-Reply-To: <58d62354-0dab-e6a6-662d-26253bcb8123@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/28/22 6:28 AM, Jens Axboe wrote:
> On 5/28/22 3:45 AM, Xiaoguang Wang wrote:
>> hi Hao,
>>
>>> Hi Xiaoguang,
>>>
>>> On 5/26/22 20:38, Xiaoguang Wang wrote:
>>>> One big issue with file registration feature is that it needs user
>>>> space apps to maintain free slot info about io_uring's fixed file
>>>> table, which really is a burden for development. Now since io_uring
>>>> starts to choose free file slot for user space apps by using
>>>> IORING_FILE_INDEX_ALLOC flag in accept or open operations, but they
>>>> need app to uses direct accept or direct open, which as far as I know,
>>>> some apps are not prepared to use direct accept or open yet.
>>>>
>>>> To support apps, who still need real fds, use registration feature
>>>> easier, let IORING_OP_FILES_UPDATE support to choose fixed file slot,
>>>> which will return free file slot in cqe->res.
>>>>
>>>> TODO list:
>>>>      Need to prepare liburing corresponding helpers.
>>>>
>>>> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
>>>> ---
>>>>   fs/io_uring.c                 | 50 ++++++++++++++++++++++++++++++++++---------
>>>>   include/uapi/linux/io_uring.h |  1 +
>>>>   2 files changed, 41 insertions(+), 10 deletions(-)
>>>>
>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>> index 9f1c682d7caf..d77e6bbec81c 100644
>>>> --- a/fs/io_uring.c
>>>> +++ b/fs/io_uring.c
>>>> @@ -680,6 +680,7 @@ struct io_rsrc_update {
>>>>       u64                arg;
>>>>       u32                nr_args;
>>>>       u32                offset;
>>>> +    u32                flags;
>>>>   };
>>>>     struct io_fadvise {
>>>> @@ -7970,14 +7971,23 @@ static int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
>>>>       return 0;
>>>>   }
>>>>   +#define IORING_FILES_UPDATE_INDEX_ALLOC 1
>>>> +
>>>>   static int io_rsrc_update_prep(struct io_kiocb *req,
>>>>                   const struct io_uring_sqe *sqe)
>>>>   {
>>>> +    u32 flags = READ_ONCE(sqe->files_update_flags);
>>>> +
>>>>       if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
>>>>           return -EINVAL;
>>>> -    if (sqe->rw_flags || sqe->splice_fd_in)
>>>> +    if (sqe->splice_fd_in)
>>>> +        return -EINVAL;
>>>> +    if (flags & ~IORING_FILES_UPDATE_INDEX_ALLOC)
>>>> +        return -EINVAL;
>>>> +    if ((flags & IORING_FILES_UPDATE_INDEX_ALLOC) && READ_ONCE(sqe->len) != 1)
>>>
>>> How about allowing multiple fd update in IORING_FILES_UPDATE_INDEX_ALLOC
>>> case? For example, using the sqe->addr(the fd array) to store the slots we allocated, and let cqe return the number of slots allocated.
>> Good idea, I'll try in patch v2, thanks.
>> Jens, any comments about this patch? At least It's really helpful to our
>> internal apps based on io_uring :)
> 
> I like this suggestion too, other thoughts in reply to the original.

BTW, if you have time, would be great to get this done for 5.19. It
makes the whole thing more consistent and makes it so that 5.19 has
(hopefully) all the alloc bits for direct descriptors.

-- 
Jens Axboe

