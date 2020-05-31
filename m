Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8DA1E9827
	for <lists+io-uring@lfdr.de>; Sun, 31 May 2020 16:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727013AbgEaOfB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 31 May 2020 10:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726555AbgEaOfB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 31 May 2020 10:35:01 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6636C061A0E
        for <io-uring@vger.kernel.org>; Sun, 31 May 2020 07:35:00 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id l11so8962482wru.0
        for <io-uring@vger.kernel.org>; Sun, 31 May 2020 07:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Y+cgvHWM2/ieEd9UvuMZ2D0bkwNP2lxfdvwGMoEvCdc=;
        b=loDYuC39rmPEKRJII+WrMSgwnGx3wwyOmNM1bVlqKOgZ+v+4UsmNj4XnvDhqUzaZ9s
         P/lIKTC14ujUohni6vnwKxgcH8nUsOsu5L7QBM/XExAuNyMqkN5OI4npZXWSkIVgkBPo
         yWxX/jrd9rjk/MsJMry/j44e27NyNvd1EQy1CrYmetyZzvGSl8c/Rs131kKmT7kBPfT3
         WqHqowiKcndBL1tESIuRjUQUbNfSYaucsvkJXc/d+Z3cGYphEFsJzAT+8GUzu/ra5dSw
         f1g+i5fqpffwgleNsKO7I5cTA2i1H+mIguSUgHrDrBregPDzzV04N7mG10g0uvDRORwY
         ogeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Y+cgvHWM2/ieEd9UvuMZ2D0bkwNP2lxfdvwGMoEvCdc=;
        b=LvrUINqyjA59vKGrQ8hNkPZtRKO71bVlZ9Zi+P3sCiRlV6fkpc/rpZC02/K5yki3OU
         0aI5z56FMW9/aJcST0vYOUXcIupOM/9wjnpS4ouSMWeDKQ8FI8EEszFEais0jYmJSLK+
         xRABi0Vw3U0uketAc16tzAcqUf3SIa0Iqwe8JxpBj1Y2VFdX7pGVqEIMgigaLVgZzFN1
         RDMV0Ju+8PM9w8aE0Egu5DrGw4ifG5q2erFgGXUiRBSMTv2ElA4NgBJgHURpkYMVZ76C
         DjFYZQthCkDyKxVId8AQqhUYAkzObY+JWy5pSgdkYlHAJFVqCCmgqiUj5w603srYFYd1
         q1ZA==
X-Gm-Message-State: AOAM5319WFKbyHdSs49xEhmHWY7wA8k+niB9Bm87nqLimQAujh+Sb1OQ
        XOnITUiVAUqN3CKimHnGrc11HYem
X-Google-Smtp-Source: ABdhPJy5lr2kfFnBffKVzKnhCFrUzgwll4zB/OFKLlRmDRHqBEhmVNQqkdlDCY+CkDGO5UhHsju8zw==
X-Received: by 2002:adf:e749:: with SMTP id c9mr19137151wrn.25.1590935699200;
        Sun, 31 May 2020 07:34:59 -0700 (PDT)
Received: from [192.168.43.60] ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id n23sm7372050wmc.0.2020.05.31.07.34.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 May 2020 07:34:58 -0700 (PDT)
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200530143947.21224-1-xiaoguang.wang@linux.alibaba.com>
 <8c361177-c0b0-b08c-e0a5-141f7fd948f0@kernel.dk>
 <e2040210-ab73-e82b-50ea-cdeb88c69157@kernel.dk>
 <27e264ec-2707-495f-3d24-4e9e20b86032@kernel.dk>
 <32d0768e-f7d7-1281-e9ff-e95329db9dc5@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v4 1/2] io_uring: avoid whole io_wq_work copy for requests
 completed inline
Message-ID: <985aa113-6d51-1c8d-a688-61ee592bb525@gmail.com>
Date:   Sun, 31 May 2020 17:33:42 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <32d0768e-f7d7-1281-e9ff-e95329db9dc5@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 31/05/2020 17:12, Xiaoguang Wang wrote:
>> A v5 with those two things would be ready to commit.
> First thanks for figuring out this bug.
> Indeed, I had run test cases in liburing/test multiple rounds before sending
> V4 patches, and all test cases pass, no kernel issues occurred, here is my kernel
> build config, seems that I had kasan enabled.
> [lege@localhost linux]$ cat .config | grep KASAN
> CONFIG_KASAN_SHADOW_OFFSET=0xdffffc0000000000
> CONFIG_HAVE_ARCH_KASAN=y
> CONFIG_HAVE_ARCH_KASAN_VMALLOC=y
> CONFIG_CC_HAS_KASAN_GENERIC=y
> CONFIG_KASAN=y
> CONFIG_KASAN_GENERIC=y
> CONFIG_KASAN_OUTLINE=y
> # CONFIG_KASAN_INLINE is not set
> CONFIG_KASAN_STACK=1
> # CONFIG_KASAN_VMALLOC is not set
> # CONFIG_TEST_KASAN is not set
> But I don't know why I did't reproduce the bug, sorry.

Hmm, can't find an option to poison allocated mem. Try to fill req->work
with garbage by hand (just after allocation), should help to reproduce.

> 
> Are you fine below changes?
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 12296ce3e8b9..2a3a02838f7b 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -907,9 +907,10 @@ static void io_file_put_work(struct work_struct *work);
>  static inline void io_req_init_async(struct io_kiocb *req,
>                         void (*func)(struct io_wq_work **))
>  {
> -       if (req->flags & REQ_F_WORK_INITIALIZED)
> -               req->work.func = func;
> -       else {
> +       if (req->flags & REQ_F_WORK_INITIALIZED) {
> +               if (!req->work.func)

->func should be initialised after alloc then, if not already.

> +                       req->work.func = func;
> +       } else {
>                 req->work = (struct io_wq_work){ .func = func };
>                 req->flags |= REQ_F_WORK_INITIALIZED;
>         }
> @@ -2920,6 +2921,8 @@ static int __io_splice_prep(struct io_kiocb *req,
>                 return ret;
>         req->flags |= REQ_F_NEED_CLEANUP;
> 
> +       /* Splice will be punted aync, so initialize io_wq_work firstly_*/
> +       io_req_init_async(req, io_wq_submit_work);
>         if (!S_ISREG(file_inode(sp->file_in)->i_mode))
>                 req->work.flags |= IO_WQ_WORK_UNBOUND;
> 
> @@ -3592,6 +3595,9 @@ static int io_statx(struct io_kiocb *req, bool force_nonblock)
> 
>  static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  {
> +        /* Close may be punted aync, so initialize io_wq_work firstly */

s/aync/async/

> +       io_req_init_async(req, io_wq_submit_work);
> +
>         /*
>          * If we queue this for async, it must not be cancellable. That would
>          * leave the 'file' in an undeterminate state.
> 
> Regards,
> Xiaoguang Wang
> 
> 
>>

-- 
Pavel Begunkov
