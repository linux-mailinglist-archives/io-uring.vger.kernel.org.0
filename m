Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 370544CCC0E
	for <lists+io-uring@lfdr.de>; Fri,  4 Mar 2022 04:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237797AbiCDDD7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Mar 2022 22:03:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232147AbiCDDD7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Mar 2022 22:03:59 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6BB417ED9B
        for <io-uring@vger.kernel.org>; Thu,  3 Mar 2022 19:03:11 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id gj15-20020a17090b108f00b001bef86c67c1so6686778pjb.3
        for <io-uring@vger.kernel.org>; Thu, 03 Mar 2022 19:03:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=3t3XuOMZWtSq0y8Dfe3kt+TaE6aNSL1HnAeDIky6OS4=;
        b=EaWA/K3sLC3lLWfFzAXmZ1xIWxJCHuWzJ4irfzGWYp08l70vlAk1BEYE98+z/yN+cz
         DoAzd5SmTL5WQFZufvF0KvD/kcYrrVUySs9Wxe+70jx1ER4GuWGOBOa5fFFdr/SEZ2pF
         oSN3LC5CU4aM98gXc8VOxFuWL/Vdoh7Mpgn0q5gjbEOmSfTto1Y+xFd4D3aYZ1bOD/hK
         VkL9oH8YGz7ZkINyqO4hIUYZs5C2XzwTQxdya95S/nEIMJFIrXCejYwPVe6d7cQ03MtM
         85TSeDdWZP9y3ITjh5tRCFlGXU7LqtKwO0IiqtA+u/R1nNzr0Yu6lSW8L1KhmFgZZOXf
         yIsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3t3XuOMZWtSq0y8Dfe3kt+TaE6aNSL1HnAeDIky6OS4=;
        b=zGcuPM1RrptdpiX460prEZSHk+MdAa6sPVdbYbJnNFp1NRfc9GEUJd+h3FuM2AkPoe
         2x8UBvHOl+DZSugULJ/IejT3joesNkN/kEsigx1Cwzrc3iLSZ4rjvPnCkchIT0Vnm07D
         zf5UzPULoPfFgtXZgsj+MnagCrFVZNBirRxt1IoUE/UFrCM4jS9RJh8Y2F4UzLUvvaIK
         H7slK8FD49LiY+qZo8Rw6iLIFoffJO1I/nBiQBFEZfM0D9TUU2EwcKfqHbmjwSmJSN3H
         gvPy4ZzkXQkNQg8Dg2UcphKK6xfMAKslSyZlRA1M3Vd5S2N1qmCplK4+sgeHCDtvcls6
         9qBw==
X-Gm-Message-State: AOAM531pPZQ+b8olUmImYT5HsUbJgHOJAAKvrXQyu8COHUI1N0XNWMR1
        0Jbm92ZxYOtvD+BC6ONM6YPtNQ==
X-Google-Smtp-Source: ABdhPJznz93vX6Mp4/ZpseYCFQb1dlSIPJALXzcaVCrSOEJPVXFmDImjMYfKWGB4BsGhvVajxP/tag==
X-Received: by 2002:a17:902:be14:b0:14f:ce67:d0a1 with SMTP id r20-20020a170902be1400b0014fce67d0a1mr39142462pls.29.1646362991127;
        Thu, 03 Mar 2022 19:03:11 -0800 (PST)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id w5-20020a056a0014c500b004f3a5535431sm4166090pfu.4.2022.03.03.19.03.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Mar 2022 19:03:10 -0800 (PST)
Message-ID: <feb75cbb-120e-5f85-4db7-8d6bde90b37c@kernel.dk>
Date:   Thu, 3 Mar 2022 20:03:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH] io_uring: add io_uring_enter(2) fixed file support
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
References: <20220303052811.31470-1-xiaoguang.wang@linux.alibaba.com>
 <4f197b0e-6066-b59e-aae0-2218e9c1b643@kernel.dk>
 <528ce414-c0fe-3318-483a-f51aa8a407b9@kernel.dk>
 <040e9262-4ebb-8505-5a14-6f399e40332c@kernel.dk>
 <951ea55c-b6a3-59e4-1011-4f46fae547b3@kernel.dk>
 <8e4ce4da-040f-70e6-8a9d-54e25c71222f@gmail.com>
 <69ef4007-45d6-3b15-022b-b00fc7182499@kernel.dk>
 <69e494cc-a199-db59-ecc0-4b430ac35bb5@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <69e494cc-a199-db59-ecc0-4b430ac35bb5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/3/22 7:39 PM, Pavel Begunkov wrote:
> On 3/4/22 02:19, Jens Axboe wrote:
>> On 3/3/22 6:52 PM, Pavel Begunkov wrote:
>>> On 3/3/22 16:31, Jens Axboe wrote:
>>>> On 3/3/22 7:40 AM, Jens Axboe wrote:
>>>>> On 3/3/22 7:36 AM, Jens Axboe wrote:
> [...]
>>>>
>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>> index ad3e0b0ab3b9..8a1f97054b71 100644
>>>> --- a/fs/io_uring.c
>>>> +++ b/fs/io_uring.c
>>> [...]
>>>>    static void *io_uring_validate_mmap_request(struct file *file,
>>>>                            loff_t pgoff, size_t sz)
>>>>    {
>>>> @@ -10191,12 +10266,23 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
>>>>        io_run_task_work();
>>>>          if (unlikely(flags & ~(IORING_ENTER_GETEVENTS | IORING_ENTER_SQ_WAKEUP |
>>>> -                   IORING_ENTER_SQ_WAIT | IORING_ENTER_EXT_ARG)))
>>>> +                   IORING_ENTER_SQ_WAIT | IORING_ENTER_EXT_ARG |
>>>> +                   IORING_ENTER_REGISTERED_RING)))
>>>>            return -EINVAL;
>>>>    -    f = fdget(fd);
>>>> -    if (unlikely(!f.file))
>>>> -        return -EBADF;
>>>> +    if (flags & IORING_ENTER_REGISTERED_RING) {
>>>> +        struct io_uring_task *tctx = current->io_uring;
>>>> +
>>>> +        if (fd >= IO_RINGFD_REG_MAX || !tctx)
>>>> +            return -EINVAL;
>>>> +        f.file = tctx->registered_rings[fd];
>>>
>>> btw, array_index_nospec(), possibly not only here.
>>
>> Yeah, was thinking that earlier too in fact but forgot about it. Might
>> as well, though I don't think it's strictly required as it isn't a user
>> table.
> 
> I may have missed in what cases it's used, but shouldn't it be
> in all cases when we use a user passed index for array addressing?
> e.g. to protect from pre-caching a chunk of memory computed from
> an out-of-array malevolent index
> 
> I just don't see any relevant difference from normal file tables

Indeed, I guess it's the indexing that matters, not the table itself.
I'll make the edit.

-- 
Jens Axboe

