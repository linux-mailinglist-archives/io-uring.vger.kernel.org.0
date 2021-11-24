Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2493545CF5B
	for <lists+io-uring@lfdr.de>; Wed, 24 Nov 2021 22:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242390AbhKXVoZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Nov 2021 16:44:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234293AbhKXVoZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Nov 2021 16:44:25 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9C85C061574
        for <io-uring@vger.kernel.org>; Wed, 24 Nov 2021 13:41:14 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id e3so16529783edu.4
        for <io-uring@vger.kernel.org>; Wed, 24 Nov 2021 13:41:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=CpIw3XYox3zNZ1BssfOHoIU4Mg/pV6NGb+DsXwkaAoY=;
        b=p9FQ2WyI7bgV5OXEsArZDMngbFt3NpGBm+TWzL1AjM6BjcWAfK3vWc9UO+p5Ok/Nan
         dxOYJcsIX+VzTg6sO3Id/ZkyvALWSZQ4D2MTQ9jOtWTtbH+lILHuosHIIa03O2zNd2TX
         QDyb4hXvcg4EwKJ/8jgif+gJBwd+Xhag97trNkHJJkfoqEb/7j11AF9gMQ6LNrNAsjzP
         SRVdDtkrDTwvyvta7KPQBuMTUZQsUKhpB76DGOrfsIhoUlAEejZTCkO0KaZ2KqWqrpFl
         77uXZvy7Ps8YidwkafioTBmeaQ42TdWsku/xFEEQUv0qPQeM2IkHx8SJf6nspz6FeLx4
         zPMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=CpIw3XYox3zNZ1BssfOHoIU4Mg/pV6NGb+DsXwkaAoY=;
        b=AX9C+JpmUfeVPByv34O5Lw5T2dlAHLGfeUWwXdVWk/lvD/hjmxta4eQzaXl5h/tecL
         1HYFcaQsNWSUYTKZ9OBhCBRnG92WGKEfqgLJuhEsyRUruBj0fkJMJ76xzg7zDPM1HU/8
         dnozLXyx9xB7qwvTGbEHDgkHUKH/roe8SIQO1nCNs3B2qP497+xaVz9xIdRdkFs50vm/
         FdoVtHrPhmuqxVxmaWS17X3yqXrz0irmzDADqTEwRTAE0Nyyg0Ovu9om05F6ZyQlToFP
         MUQQXFKLriO1S3LNXIJIWHHMCmahYvz+9UlBva7gjxhpg2rq5Wk5vTAHJlcjNUwx+04Z
         dv2Q==
X-Gm-Message-State: AOAM532Qtxon86Fd7Q1pji2qKOAuZzpdrQyp3nPLXdL6WDba3hu5JQXD
        FVAiAvmx2HaQ7XuVLIjK4Ew=
X-Google-Smtp-Source: ABdhPJzZO8PiCh4xvGz1us2S46wu5mGQORZuIWJA1oBH3cN2RSOyBEn0gtPwOS45lq+ryhX38josuw==
X-Received: by 2002:a17:906:58d3:: with SMTP id e19mr24566672ejs.350.1637790073524;
        Wed, 24 Nov 2021 13:41:13 -0800 (PST)
Received: from [192.168.8.198] ([148.252.128.168])
        by smtp.gmail.com with ESMTPSA id a17sm673800edx.14.2021.11.24.13.41.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Nov 2021 13:41:13 -0800 (PST)
Message-ID: <28685b5a-5484-809c-38d7-ef60f359b535@gmail.com>
Date:   Wed, 24 Nov 2021 21:41:10 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v5 0/6] task work optimization
Content-Language: en-US
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211124122202.218756-1-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20211124122202.218756-1-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/24/21 12:21, Hao Xu wrote:
> v4->v5
> - change the implementation of merge_wq_list

They only concern I had was about 6/6 not using inline completion
infra, when it's faster to grab ->uring_lock. i.e.
io_submit_flush_completions(), which should be faster when batching
is good.

Looking again through the code, the only user is SQPOLL

io_req_task_work_add(req, !!(req->ctx->flags & IORING_SETUP_SQPOLL));

And with SQPOLL the lock is mostly grabbed by the SQPOLL task only,
IOW for pure block rw there shouldn't be any contention.
Doesn't make much sense, what am I missing?
How many requests are completed on average per tctx_task_work()?


It doesn't apply to for-5.17/io_uring, here is a rebase:
https://github.com/isilence/linux.git haoxu_tw_opt
link: https://github.com/isilence/linux/tree/haoxu_tw_opt

With that first 5 patches look good, so for them:
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

but I still don't understand how 6/6 is better. Can it be because of
indirect branching? E.g. would something like this give the result?

- req->io_task_work.func(req, locked);
+ INDIRECT_CALL_1(req->io_task_work.func, io_req_task_complete, req, locked);


> Hao Xu (6):
>    io-wq: add helper to merge two wq_lists
>    io_uring: add a priority tw list for irq completion work
>    io_uring: add helper for task work execution code
>    io_uring: split io_req_complete_post() and add a helper
>    io_uring: move up io_put_kbuf() and io_put_rw_kbuf()
>    io_uring: batch completion in prior_task_list
> 
>   fs/io-wq.h    |  22 +++++++
>   fs/io_uring.c | 158 +++++++++++++++++++++++++++++++++-----------------
>   2 files changed, 128 insertions(+), 52 deletions(-)
> 

-- 
Pavel Begunkov
