Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 130CB30F1DA
	for <lists+io-uring@lfdr.de>; Thu,  4 Feb 2021 12:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235657AbhBDLRR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Feb 2021 06:17:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235680AbhBDLPJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Feb 2021 06:15:09 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA42EC061788
        for <io-uring@vger.kernel.org>; Thu,  4 Feb 2021 03:14:53 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id i9so2655476wmq.1
        for <io-uring@vger.kernel.org>; Thu, 04 Feb 2021 03:14:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mcwjGO5Ar/d/uL2JM4ctLnot0SxARJBpoaRveF5ued4=;
        b=QQ1Ie/K/yAVomos7lzUFwLeBMBSrvO7YFi3dMsnScDzGA1nKPkCJxND7bWLDYHpimD
         yCEAfu4FE83JdI5+uUhkwqpFs66NfPY4LiWFlV0Iwi+3G9aDQQkUOBxIqLGrw9vMdfMf
         WYqc8nKDy6xhTEgW3ho2PGUIYTCbs1VMKrw8p8u+2W0rCQnfZ1Np7VRymmlzTiLnn5AJ
         FOpPWQUZTRRVyBEo1RqOvdFA2YWkIQ1499yYZfalgXA/lJqqjuF1FFUAJUmX9pfJ1ZpL
         h43dTP0AFJLu4WcZvoqoY9v3LjsX3SEbRT6fXlX2G35XQKPJTKvu3OyOEHYfR21SK6Zu
         YvSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=mcwjGO5Ar/d/uL2JM4ctLnot0SxARJBpoaRveF5ued4=;
        b=WO7iHoBQch1/LkFq0tyaJib0UcoD+OSfHVIdEWosAcdiX51YJYJhFgcnTC6Hk6JjrT
         nyXAjWYUVgzgsDyEqt70nOOKSMRgVvQZ21aY2YMJyyY3oJh0fKph7EX45V11+pTI0xCa
         Lj4f+RedAFUyHCEaIbx3ppi44fV7MX6/im9wyNWd/b/+ge1orvKwxZxaoTAYlbsBln+k
         1SKEif/5D0CjQq6a6FAuyFAz9aIu+FMr0vUe10runyk1rmGaJ8MJZ/+BCreqN/Vxn/u9
         5HLRemyngGiQsHWfwb2tTYErvYZXq+YRe3Z+cYhxjfKe1FSAqIrnJyPmMvBF+KxTxiRI
         6qug==
X-Gm-Message-State: AOAM530TBUfEWjajC33BF6+q4mvAbss7mqO1dDD3jotwvrvhH0DwpI0L
        Y/jNRv3mek8oxyIYUXQsSBM0ni5nhKAPAg==
X-Google-Smtp-Source: ABdhPJxPzT8rRwxR0l8fHrkvnLUIdFTu/wD0RNOOBapk0KTILCh+ciNufUL617pcTEEWG/9wJxsAsA==
X-Received: by 2002:a1c:1d8b:: with SMTP id d133mr7096751wmd.172.1612437292614;
        Thu, 04 Feb 2021 03:14:52 -0800 (PST)
Received: from [192.168.8.171] ([148.252.133.145])
        by smtp.gmail.com with ESMTPSA id b7sm7500382wru.33.2021.02.04.03.14.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Feb 2021 03:14:52 -0800 (PST)
Subject: Re: [PATCH 1/2] io_uring: add uring_lock as an argument to
 io_sqe_files_unregister()
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1612364276-26847-1-git-send-email-haoxu@linux.alibaba.com>
 <1612364276-26847-2-git-send-email-haoxu@linux.alibaba.com>
 <976179ed-6013-3cd7-46a0-aa3201444ac4@gmail.com>
 <a6827c98-c4f6-a0fd-6453-1351c654c3a5@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <9792fbbb-fa88-a276-9a4a-42fed4426424@gmail.com>
Date:   Thu, 4 Feb 2021 11:11:07 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <a6827c98-c4f6-a0fd-6453-1351c654c3a5@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 04/02/2021 03:34, Hao Xu wrote:
> 在 2021/2/4 上午12:33, Pavel Begunkov 写道:
>> On 03/02/2021 14:57, Hao Xu wrote:
>>> io_sqe_files_unregister is currently called from several places:
>>>      - syscall io_uring_register (with uring_lock)
>>>      - io_ring_ctx_wait_and_kill() (without uring_lock)
>>>
>>> There is a AA type deadlock in io_sqe_files_unregister(), thus we need
>>> to know if we hold uring_lock in io_sqe_files_unregister() to fix the
>>> issue.
>>
>> It's ugly, just take the lock and kill the patch. There can't be any
>> contention during io_ring_ctx_free anyway.
> Hi Pavel, I don't get it, do you mean this patch isn't needed, and we can just unlock(&uring_lock) before io_run_task_work_sig() and lock(&uring_lock) after it? I knew there won't be contention during io_ring_ctx_free that's why there is no uring_lock in it.
> I tried to just do unlock(&uring_lock) before io_run_task_sig() without if(locked) check, it reports something like "there are unpaired mutex lock/unlock" since we cannot just unlock if it's from io_ring_ctx_free.


The ugly part is @locked. I know that there is already similar stuff
around, but I may go long why and how much I don't like it.

io_ring_ctx_free()
{
    ...
    lock(uring_lock);
    files_unregister();
    unlock(uring_lock);
    ...
}

With this you'll always have the mutex locked in unregister, so
can drop it unconditionally (if that will ever be needed). It's
also cleaner from the synchronisation perspective.

>>
>>>
>>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>>> ---
>>>   fs/io_uring.c | 10 +++++-----
>>>   1 file changed, 5 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index 38c6cbe1ab38..efb6d02fea6f 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -7339,7 +7339,7 @@ static void io_sqe_files_set_node(struct fixed_file_data *file_data,
>>>       percpu_ref_get(&file_data->refs);
>>>   }
>>>   -static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
>>> +static int io_sqe_files_unregister(struct io_ring_ctx *ctx, bool locked)
>>>   {
>>>       struct fixed_file_data *data = ctx->file_data;
>>>       struct fixed_file_ref_node *backup_node, *ref_node = NULL;
>>> @@ -7872,13 +7872,13 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
>>>         ret = io_sqe_files_scm(ctx);
>>>       if (ret) {
>>> -        io_sqe_files_unregister(ctx);
>>> +        io_sqe_files_unregister(ctx, true);
>>>           return ret;
>>>       }
>>>         ref_node = alloc_fixed_file_ref_node(ctx);
>>>       if (!ref_node) {
>>> -        io_sqe_files_unregister(ctx);
>>> +        io_sqe_files_unregister(ctx, true);
>>>           return -ENOMEM;
>>>       }
>>>   @@ -8682,7 +8682,7 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
>>>           css_put(ctx->sqo_blkcg_css);
>>>   #endif
>>>   -    io_sqe_files_unregister(ctx);
>>> +    io_sqe_files_unregister(ctx, false);
>>>       io_eventfd_unregister(ctx);
>>>       io_destroy_buffers(ctx);
>>>       idr_destroy(&ctx->personality_idr);
>>> @@ -10065,7 +10065,7 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
>>>           ret = -EINVAL;
>>>           if (arg || nr_args)
>>>               break;
>>> -        ret = io_sqe_files_unregister(ctx);
>>> +        ret = io_sqe_files_unregister(ctx, true);
>>>           break;
>>>       case IORING_REGISTER_FILES_UPDATE:
>>>           ret = io_sqe_files_update(ctx, arg, nr_args);
>>>
>>
> 

-- 
Pavel Begunkov
