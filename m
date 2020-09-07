Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6EF260210
	for <lists+io-uring@lfdr.de>; Mon,  7 Sep 2020 19:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730410AbgIGRRn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Sep 2020 13:17:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729737AbgIGODe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Sep 2020 10:03:34 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 275AAC061757
        for <io-uring@vger.kernel.org>; Mon,  7 Sep 2020 07:03:06 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id j2so15935169wrx.7
        for <io-uring@vger.kernel.org>; Mon, 07 Sep 2020 07:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=N3v1+MiPbKfWgahEGEuPUf8b2uOmZmi4BBAm5QQ0sDM=;
        b=WbVe5hikT0OGP2oCZour7uk6e/LudhgEEWI05MKWTKFHU/NnHCuWuaCCWKvxf5jhZ+
         OSI5AMcriiR8soZuFh243rDg/AjgB02KeKcsB6cDf2MbL5hGVR+SO6MRoSp/rbXxHCUP
         5XyEVpC8sZ9BiWiWvQxbXB6kvqYj7gfxe0+9yxUM6GiicWHFqRA0hl+G5hRlAOAnMb8P
         xp/2b7XYRrqhpWSLEF+KtPnUdXit5yi3XQnF/RWEaVEQ6cJzucp19SxVjSsWeDI7gSiX
         MRgkmQgtlQcaLac6xCBiqNRXCy+2Jc/6/0Xnn8eMDfeYpuPtVo83uHpdZDyKytWq1bXF
         geWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=N3v1+MiPbKfWgahEGEuPUf8b2uOmZmi4BBAm5QQ0sDM=;
        b=njlr1/s0X30XoMsfj8vRNxMEsoxneK/c/6+mZXcq46F0SjJabF31yqTeva0lzEjDNG
         V2G8T6O6qS8cL4gQHH8rOOYVMehDcARUQH+9rmwJsl6AXOVn5/RIaiDUoKUzpGlHOPXW
         2Y3ez2UQSjhGaOvufTP5T+PEnbnwZ0zPkge2aTsSwtmR3Mwbxn5D6TgVqmymWBs6+93T
         R12iqLw9NhzkhS4bjd+Mk6tFd3v2Zk37le6hOVY2nZbsEwc/IjMgUFND6/+BEtqBPNLB
         Zyg2ewPuThSrgiEce9L7uOXyC4PIMdEnPqwFwyVnzxfxiKrjUNIJN9U6duFUiukRj6Cs
         H35g==
X-Gm-Message-State: AOAM530KXeDAyixrCTkKNk8NJXMs5fe4HprmAnxYhvWGvROtv/CoKQXQ
        Fz3WidqkkifA8+Ca1wWUXe0uFkGY918=
X-Google-Smtp-Source: ABdhPJyrI63eNYjAzbR0SOfdRJB7BzC9oSGJ6+huKdBtoNmiRqFfbmy5ibnatrcwS655Ve8rddy1JA==
X-Received: by 2002:adf:cd05:: with SMTP id w5mr21497860wrm.62.1599487382842;
        Mon, 07 Sep 2020 07:03:02 -0700 (PDT)
Received: from [192.168.43.239] ([5.100.193.184])
        by smtp.gmail.com with ESMTPSA id 5sm27084280wmz.22.2020.09.07.07.03.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Sep 2020 07:03:02 -0700 (PDT)
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20200903022053.912968-1-axboe@kernel.dk>
 <20200903022053.912968-9-axboe@kernel.dk>
 <c6562c28-7631-d593-d3e5-cde158337337@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 mQINBFmKBOQBEAC76ZFxLAKpDw0bKQ8CEiYJRGn8MHTUhURL02/7n1t0HkKQx2K1fCXClbps
 bdwSHrhOWdW61pmfMbDYbTj6ZvGRvhoLWfGkzujB2wjNcbNTXIoOzJEGISHaPf6E2IQx1ik9
 6uqVkK1OMb7qRvKH0i7HYP4WJzYbEWVyLiAxUj611mC9tgd73oqZ2pLYzGTqF2j6a/obaqha
 +hXuWTvpDQXqcOZJXIW43atprH03G1tQs7VwR21Q1eq6Yvy2ESLdc38EqCszBfQRMmKy+cfp
 W3U9Mb1w0L680pXrONcnlDBCN7/sghGeMHjGKfNANjPc+0hzz3rApPxpoE7HC1uRiwC4et83
 CKnncH1l7zgeBT9Oa3qEiBlaa1ZCBqrA4dY+z5fWJYjMpwI1SNp37RtF8fKXbKQg+JuUjAa9
 Y6oXeyEvDHMyJYMcinl6xCqCBAXPHnHmawkMMgjr3BBRzODmMr+CPVvnYe7BFYfoajzqzq+h
 EyXSl3aBf0IDPTqSUrhbmjj5OEOYgRW5p+mdYtY1cXeK8copmd+fd/eTkghok5li58AojCba
 jRjp7zVOLOjDlpxxiKhuFmpV4yWNh5JJaTbwCRSd04sCcDNlJj+TehTr+o1QiORzc2t+N5iJ
 NbILft19Izdn8U39T5oWiynqa1qCLgbuFtnYx1HlUq/HvAm+kwARAQABtDFQYXZlbCBCZWd1
 bmtvdiAoc2lsZW5jZSkgPGFzbWwuc2lsZW5jZUBnbWFpbC5jb20+iQJOBBMBCAA4FiEE+6Ju
 PTjTbx479o3OWt5b1Glr+6UFAlmKBOQCGwMFCwkIBwIGFQgJCgsCBBYCAwECHgECF4AACgkQ
 Wt5b1Glr+6WxZA//QueaKHzgdnOikJ7NA/Vq8FmhRlwgtP0+E+w93kL+ZGLzS/cUCIjn2f4Q
 Mcutj2Neg0CcYPX3b2nJiKr5Vn0rjJ/suiaOa1h1KzyNTOmxnsqE5fmxOf6C6x+NKE18I5Jy
 xzLQoktbdDVA7JfB1itt6iWSNoOTVcvFyvfe5ggy6FSCcP+m1RlR58XxVLH+qlAvxxOeEr/e
 aQfUzrs7gqdSd9zQGEZo0jtuBiB7k98t9y0oC9Jz0PJdvaj1NZUgtXG9pEtww3LdeXP/TkFl
 HBSxVflzeoFaj4UAuy8+uve7ya/ECNCc8kk0VYaEjoVrzJcYdKP583iRhOLlZA6HEmn/+Gh9
 4orG67HNiJlbFiW3whxGizWsrtFNLsSP1YrEReYk9j1SoUHHzsu+ZtNfKuHIhK0sU07G1OPN
 2rDLlzUWR9Jc22INAkhVHOogOcc5ajMGhgWcBJMLCoi219HlX69LIDu3Y34uIg9QPZIC2jwr
 24W0kxmK6avJr7+n4o8m6sOJvhlumSp5TSNhRiKvAHB1I2JB8Q1yZCIPzx+w1ALxuoWiCdwV
 M/azguU42R17IuBzK0S3hPjXpEi2sK/k4pEPnHVUv9Cu09HCNnd6BRfFGjo8M9kZvw360gC1
 reeMdqGjwQ68o9x0R7NBRrtUOh48TDLXCANAg97wjPoy37dQE7e5Ag0EWYoE5AEQAMWS+aBV
 IJtCjwtfCOV98NamFpDEjBMrCAfLm7wZlmXy5I6o7nzzCxEw06P2rhzp1hIqkaab1kHySU7g
 dkpjmQ7Jjlrf6KdMP87mC/Hx4+zgVCkTQCKkIxNE76Ff3O9uTvkWCspSh9J0qPYyCaVta2D1
 Sq5HZ8WFcap71iVO1f2/FEHKJNz/YTSOS/W7dxJdXl2eoj3gYX2UZNfoaVv8OXKaWslZlgqN
 jSg9wsTv1K73AnQKt4fFhscN9YFxhtgD/SQuOldE5Ws4UlJoaFX/yCoJL3ky2kC0WFngzwRF
 Yo6u/KON/o28yyP+alYRMBrN0Dm60FuVSIFafSqXoJTIjSZ6olbEoT0u17Rag8BxnxryMrgR
 dkccq272MaSS0eOC9K2rtvxzddohRFPcy/8bkX+t2iukTDz75KSTKO+chce62Xxdg62dpkZX
 xK+HeDCZ7gRNZvAbDETr6XI63hPKi891GeZqvqQVYR8e+V2725w+H1iv3THiB1tx4L2bXZDI
 DtMKQ5D2RvCHNdPNcZeldEoJwKoA60yg6tuUquvsLvfCwtrmVI2rL2djYxRfGNmFMrUDN1Xq
 F3xozA91q3iZd9OYi9G+M/OA01husBdcIzj1hu0aL+MGg4Gqk6XwjoSxVd4YT41kTU7Kk+/I
 5/Nf+i88ULt6HanBYcY/+Daeo/XFABEBAAGJAjYEGAEIACAWIQT7om49ONNvHjv2jc5a3lvU
 aWv7pQUCWYoE5AIbDAAKCRBa3lvUaWv7pfmcEACKTRQ28b1y5ztKuLdLr79+T+LwZKHjX++P
 4wKjEOECCcB6KCv3hP+J2GCXDOPZvdg/ZYZafqP68Yy8AZqkfa4qPYHmIdpODtRzZSL48kM8
 LRzV8Rl7J3ItvzdBRxf4T/Zseu5U6ELiQdCUkPGsJcPIJkgPjO2ROG/ZtYa9DvnShNWPlp+R
 uPwPccEQPWO/NP4fJl2zwC6byjljZhW5kxYswGMLBwb5cDUZAisIukyAa8Xshdan6C2RZcNs
 rB3L7vsg/R8UCehxOH0C+NypG2GqjVejNZsc7bgV49EOVltS+GmGyY+moIzxsuLmT93rqyII
 5rSbbcTLe6KBYcs24XEoo49Zm9oDA3jYvNpeYD8rDcnNbuZh9kTgBwFN41JHOPv0W2FEEWqe
 JsCwQdcOQ56rtezdCJUYmRAt3BsfjN3Jn3N6rpodi4Dkdli8HylM5iq4ooeb5VkQ7UZxbCWt
 UVMKkOCdFhutRmYp0mbv2e87IK4erwNHQRkHUkzbsuym8RVpAZbLzLPIYK/J3RTErL6Z99N2
 m3J6pjwSJY/zNwuFPs9zGEnRO4g0BUbwGdbuvDzaq6/3OJLKohr5eLXNU3JkT+3HezydWm3W
 OPhauth7W0db74Qd49HXK0xe/aPrK+Cp+kU1HRactyNtF8jZQbhMCC8vMGukZtWaAwpjWiiH bA==
Subject: Re: [PATCH 8/8] io_uring: enable IORING_SETUP_ATTACH_WQ to attach to
 SQPOLL thread too
Message-ID: <aa93c14b-cd50-b250-f70b-5c450c01ee8a@gmail.com>
Date:   Mon, 7 Sep 2020 17:00:38 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <c6562c28-7631-d593-d3e5-cde158337337@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 07/09/2020 11:56, Xiaoguang Wang wrote:
> hi,
> 
> First thanks for this patchset:) and I have some questions below:
> 
> 1. Does a uring instance which has SQPOLL enabled but does not specify
> a valid cpu is meaningful in real business product?
> IMHO, in a real business product, cpu usage should be under strict management,
> say a uring instance which has SQPOLL enabled but is not bound to fixed cpu,
> then this uring instance's corresponding io_sq_thread could be scheduled to any
> cpu(and can be re-scheduled many times), which may impact any other application
> greatly because of cpu contention, especially this io_sq_thread is just doing
> busy loop in its sq_thread_idle period time, so in a real business product, I
> wonder whether SQPOLL is only meaningful if user specifies a fixed cpu core.

It is meaningful for a part of cases, for the other part you can set
processes' affinities and pin each SQPOLL thread to a specific CPU, as
you'd do even without this series. And that gives you more flexibilty,
IMHO.

> 2. Does IORING_SETUP_ATTACH_WQ is really convenient?
> IORING_SETUP_ATTACH_WQ always needs to ensure a parent uring instance exists,
> that means it also requires app to regulate the creation oder of uring instanes,
> which maybe not convenient, just imagine how to integrate this new SQPOLL
> improvements to fio util.

It may be not so convenient, but it's flexible enough and prevents isolation
breaking issues. We've discussed that in the thread with your patches.

> 
> 3. When it's appropriate to set ctx's IORING_SQ_NEED_WAKEUP flag?
> In your current implementation, if a ctx is marked as SQT_IDLE, this ctx will be
> set IORING_SQ_NEED_WAKEUP flag, but if other ctxes have work to do, then io_sq_thread
> is still running and does not need to be waken up, then a later wakeup form userspace
> is unnecessary. I think it maybe appropriate to set IORING_SQ_NEED_WAKEUP when all
> ctxes have no work to do, you can have a look at my attached codes:)
> 
> 4. Is io_attach_sq_data really safe?
> sqd_list is a global list, but its search key is a fd local to process, different
> processes may have same fd, then this codes looks odd, seems that your design is
> to make io_sq_thread shared inside process.
> 
> Indeed I have sent a patch to implement similar idea before:
> https://lore.kernel.org/io-uring/20200520115648.6140-1-xiaoguang.wang@linux.alibaba.com/
> And below is a new version which is implemented in our kernel.
> commit 0195c87c786e034e351510e27bf1d15f2a3b9be2
> Author: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> Date:   Mon Jul 27 21:39:59 2020 +0800
> 
>     alios: io_uring: add percpu io sq thread support
> 
>     task #26578122
> 
>     Currently we can create multiple io_uring instances which all have SQPOLL
>     enabled and make them bound to same cpu core by setting sq_thread_cpu argument,
>     but sometimes this isn't efficient. Imagine such extreme case, create two io
>     uring instances, which both have SQPOLL enabled and are bound to same cpu core.
>     One instance submits io per 500ms, another instance submits io continually,
>     then obviously the 1st instance still always contend for cpu resource, which
>     will impact 2nd instance.
> 
>     To fix this issue, add a new flag IORING_SETUP_SQPOLL_PERCPU, when both
>     IORING_SETUP_SQ_AFF and IORING_SETUP_SQPOLL_PERCPU are enabled, we create a
>     percpu io sq_thread to handle multiple io_uring instances' io requests with
>     round-robin strategy, the improvements are very big, see below:
> 
>     IOPS:
>       No of instances       1     2     4     8     16     32
>       kernel unpatched   589k  487k  303k  165k  85.8k  43.7k
>       kernel patched     590k  593k  581k  538k   494k   406k
> 
>     LATENCY(us):
>       No of instances       1     2     4     8     16     32
>       kernel unpatched    217   262   422   775  1488    2917
>       kernel patched      216   215   219   237   258     313
> 
>     Link: https://lore.kernel.org/io-uring/20200520115648.6140-1-xiaoguang.wang@linux.alibaba.com/
>     Reviewed-by: Jiufei Xue <jiufei.xue@linux.alibaba.com>
>     Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
>     Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 530373a9e9c0..b8d66df002ba 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -259,7 +259,13 @@ struct io_ring_ctx {
>         struct io_wq            *io_wq;
>         struct task_struct      *sqo_thread;    /* if using sq thread polling */
>         struct mm_struct        *sqo_mm;
> -       wait_queue_head_t       sqo_wait;
> +       wait_queue_head_t       *sqo_wait;
> +       wait_queue_head_t       __sqo_wait;
> +
> +       /* Used for percpu io sq thread */
> +       int                     submit_status;
> +       int                     sq_thread_cpu;
> +       struct list_head        node;
> 
>         /*
>          * If used, fixed file set. Writers must ensure that ->refs is dead,
> @@ -330,6 +336,17 @@ struct io_ring_ctx {
>         struct work_struct              exit_work;
>  };
> 
> +struct sq_thread_percpu {
> +       struct list_head ctx_list;
> +       struct mutex lock;
> +       wait_queue_head_t sqo_wait;
> +       struct task_struct *sqo_thread;
> +       struct completion sq_thread_comp;
> +       unsigned int sq_thread_idle;
> +};
> +
> +static struct sq_thread_percpu __percpu *percpu_threads;
> +
>  /*
>   * First field must be the file pointer in all the
>   * iocb unions! See also 'struct kiocb' in <linux/fs.h>
> @@ -981,9 +998,11 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
>                 goto err;
> 
>         ctx->flags = p->flags;
> -       init_waitqueue_head(&ctx->sqo_wait);
> +       init_waitqueue_head(&ctx->__sqo_wait);
> +       ctx->sqo_wait = &ctx->__sqo_wait;
>         init_waitqueue_head(&ctx->cq_wait);
>         INIT_LIST_HEAD(&ctx->cq_overflow_list);
> +       INIT_LIST_HEAD(&ctx->node);
>         init_completion(&ctx->ref_comp);
>         init_completion(&ctx->sq_thread_comp);
>         idr_init(&ctx->io_buffer_idr);
> @@ -1210,8 +1229,8 @@ static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
>  {
>         if (waitqueue_active(&ctx->wait))
>                 wake_up(&ctx->wait);
> -       if (waitqueue_active(&ctx->sqo_wait))
> -               wake_up(&ctx->sqo_wait);
> +       if (waitqueue_active(ctx->sqo_wait))
> +               wake_up(ctx->sqo_wait);
>         if (io_should_trigger_evfd(ctx))
>                 eventfd_signal(ctx->cq_ev_fd, 1);
>  }
> @@ -2034,8 +2053,8 @@ static void io_iopoll_req_issued(struct io_kiocb *req)
>                 list_add_tail(&req->list, &ctx->poll_list);
> 
>         if ((ctx->flags & IORING_SETUP_SQPOLL) &&
> -           wq_has_sleeper(&ctx->sqo_wait))
> -               wake_up(&ctx->sqo_wait);
> +           wq_has_sleeper(ctx->sqo_wait))
> +               wake_up(ctx->sqo_wait);
>  }
> 
>  static void __io_state_file_put(struct io_submit_state *state)
> @@ -6068,7 +6087,7 @@ static int io_sq_thread(void *data)
>                                 continue;
>                         }
> 
> -                       prepare_to_wait(&ctx->sqo_wait, &wait,
> +                       prepare_to_wait(ctx->sqo_wait, &wait,
>                                                 TASK_INTERRUPTIBLE);
>                         /*
>                          * While doing polled IO, before going to sleep, we need
> @@ -6079,7 +6098,7 @@ static int io_sq_thread(void *data)
>                          */
>                         if ((ctx->flags & IORING_SETUP_IOPOLL) &&
>                             !list_empty_careful(&ctx->poll_list)) {
> -                               finish_wait(&ctx->sqo_wait, &wait);
> +                               finish_wait(ctx->sqo_wait, &wait);
>                                 continue;
>                         }
> 
> @@ -6088,25 +6107,25 @@ static int io_sq_thread(void *data)
>                         to_submit = io_sqring_entries(ctx);
>                         if (!to_submit || ret == -EBUSY) {
>                                 if (kthread_should_park()) {
> -                                       finish_wait(&ctx->sqo_wait, &wait);
> +                                       finish_wait(ctx->sqo_wait, &wait);
>                                         break;
>                                 }
>                                 if (current->task_works) {
>                                         task_work_run();
> -                                       finish_wait(&ctx->sqo_wait, &wait);
> +                                       finish_wait(ctx->sqo_wait, &wait);
>                                         io_ring_clear_wakeup_flag(ctx);
>                                         continue;
>                                 }
>                                 if (signal_pending(current))
>                                         flush_signals(current);
>                                 schedule();
> -                               finish_wait(&ctx->sqo_wait, &wait);
> +                               finish_wait(ctx->sqo_wait, &wait);
> 
>                                 io_ring_clear_wakeup_flag(ctx);
>                                 ret = 0;
>                                 continue;
>                         }
> -                       finish_wait(&ctx->sqo_wait, &wait);
> +                       finish_wait(ctx->sqo_wait, &wait);
> 
>                         io_ring_clear_wakeup_flag(ctx);
>                 }
> @@ -6130,6 +6149,147 @@ static int io_sq_thread(void *data)
>         return 0;
>  }
> 
> +static int process_ctx(struct sq_thread_percpu *t, struct io_ring_ctx *ctx)
> +{
> +       int ret = 0;
> +       unsigned int to_submit;
> +       struct io_ring_ctx *ctx2;
> +
> +       list_for_each_entry(ctx2, &t->ctx_list, node) {
> +               if (!list_empty(&ctx2->poll_list)) {
> +                       unsigned int nr_events = 0;
> +
> +                       mutex_lock(&ctx2->uring_lock);
> +                       if (!list_empty(&ctx2->poll_list))
> +                               io_iopoll_getevents(ctx2, &nr_events, 0);
> +                       mutex_unlock(&ctx2->uring_lock);
> +               }
> +       }
> +
> +       to_submit = io_sqring_entries(ctx);
> +       if (to_submit) {
> +               mutex_lock(&ctx->uring_lock);
> +               if (likely(!percpu_ref_is_dying(&ctx->refs)))
> +                       ret = io_submit_sqes(ctx, to_submit, NULL, -1);
> +               mutex_unlock(&ctx->uring_lock);
> +       }
> +       return ret;
> +}
> +
> +static int io_sq_thread_percpu(void *data)
> +{
> +       struct sq_thread_percpu *t = data;
> +       struct io_ring_ctx *ctx;
> +       const struct cred *saved_creds, *cur_creds, *old_creds;
> +       mm_segment_t old_fs;
> +       DEFINE_WAIT(wait);
> +       unsigned long timeout;
> +       int iters = 0;
> +
> +       complete(&t->sq_thread_comp);
> +
> +       old_fs = get_fs();
> +       set_fs(USER_DS);
> +       timeout = jiffies + t->sq_thread_idle;
> +       saved_creds = cur_creds = NULL;
> +       while (!kthread_should_park()) {
> +               bool needs_run, needs_wait;
> +               unsigned int to_submit;
> +
> +               mutex_lock(&t->lock);
> +again:
> +               needs_run = false;
> +               list_for_each_entry(ctx, &t->ctx_list, node) {
> +                       if (cur_creds != ctx->creds) {
> +                               old_creds = override_creds(ctx->creds);
> +                               cur_creds = ctx->creds;
> +                               if (saved_creds)
> +                                       put_cred(old_creds);
> +                               else
> +                                       saved_creds = old_creds;
> +                       }
> +
> +                       ctx->submit_status = process_ctx(t, ctx);
> +
> +                       if (!needs_run)
> +                               to_submit = io_sqring_entries(ctx);
> +                       if (!needs_run &&
> +                           ((to_submit && ctx->submit_status != -EBUSY) ||
> +                           !list_empty(&ctx->poll_list)))
> +                               needs_run = true;
> +               }
> +               if (needs_run && (++iters & 7)) {
> +                       if (current->task_works)
> +                               task_work_run();
> +                       timeout = jiffies + t->sq_thread_idle;
> +                       goto again;
> +               }
> +               mutex_unlock(&t->lock);
> +               if (needs_run || !time_after(jiffies, timeout)) {
> +                       if (current->task_works)
> +                               task_work_run();
> +                       if (need_resched()) {
> +                               io_sq_thread_drop_mm(ctx);
> +                               cond_resched();
> +                       }
> +                       if (needs_run)
> +                               timeout = jiffies + t->sq_thread_idle;
> +                       continue;
> +               }
> +
> +               needs_wait = true;
> +               prepare_to_wait(&t->sqo_wait, &wait, TASK_INTERRUPTIBLE);
> +               mutex_lock(&t->lock);
> +               list_for_each_entry(ctx, &t->ctx_list, node) {
> +                       if ((ctx->flags & IORING_SETUP_IOPOLL) &&
> +                           !list_empty_careful(&ctx->poll_list)) {
> +                               needs_wait = false;
> +                               break;
> +                       }
> +                       to_submit = io_sqring_entries(ctx);
> +                       if (to_submit && ctx->submit_status != -EBUSY) {
> +                               needs_wait = false;
> +                               break;
> +                       }
> +               }
> +               if (needs_wait) {
> +                       list_for_each_entry(ctx, &t->ctx_list, node)
> +                               io_ring_set_wakeup_flag(ctx);
> +               }
> +
> +               mutex_unlock(&t->lock);
> +
> +               if (needs_wait) {
> +                       if (current->task_works)
> +                               task_work_run();
> +                       io_sq_thread_drop_mm(ctx);
> +                       if (kthread_should_park()) {
> +                               finish_wait(&t->sqo_wait, &wait);
> +                               break;
> +                       }
> +                       schedule();
> +                       mutex_lock(&t->lock);
> +                       list_for_each_entry(ctx, &t->ctx_list, node)
> +                               io_ring_clear_wakeup_flag(ctx);
> +                       mutex_unlock(&t->lock);
> +                       finish_wait(&t->sqo_wait, &wait);
> +               } else
> +                       finish_wait(&t->sqo_wait, &wait);
> +               timeout = jiffies + t->sq_thread_idle;
> +       }
> +
> +       if (current->task_works)
> +               task_work_run();
> +
> +       set_fs(old_fs);
> +       io_sq_thread_drop_mm(ctx);
> +       if (saved_creds)
> +               revert_creds(saved_creds);
> +
> +       kthread_parkme();
> +
> +       return 0;
> +}
>  struct io_wait_queue {
>         struct wait_queue_entry wq;
>         struct io_ring_ctx *ctx;
> @@ -6291,18 +6451,25 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
>         return 0;
>  }
> 
> +static void destroy_sq_thread_percpu(struct io_ring_ctx *ctx, int cpu);
> +
>  static void io_sq_thread_stop(struct io_ring_ctx *ctx)
>  {
>         if (ctx->sqo_thread) {
> -               wait_for_completion(&ctx->sq_thread_comp);
> -               /*
> -                * The park is a bit of a work-around, without it we get
> -                * warning spews on shutdown with SQPOLL set and affinity
> -                * set to a single CPU.
> -                */
> -               kthread_park(ctx->sqo_thread);
> -               kthread_stop(ctx->sqo_thread);
> -               ctx->sqo_thread = NULL;
> +               if ((ctx->flags & IORING_SETUP_SQ_AFF) &&
> +                   (ctx->flags & IORING_SETUP_SQPOLL_PERCPU) && percpu_threads) {
> +                       destroy_sq_thread_percpu(ctx, ctx->sq_thread_cpu);
> +               } else {
> +                       wait_for_completion(&ctx->sq_thread_comp);
> +                       /*
> +                        * The park is a bit of a work-around, without it we get
> +                        * warning spews on shutdown with SQPOLL set and affinity
> +                        * set to a single CPU.
> +                        */
> +                       kthread_park(ctx->sqo_thread);
> +                       kthread_stop(ctx->sqo_thread);
> +                       ctx->sqo_thread = NULL;
> +               }
>         }
>  }
> 
> @@ -6917,6 +7084,54 @@ static int io_init_wq_offload(struct io_ring_ctx *ctx,
>         return ret;
>  }
> 
> +static void create_sq_thread_percpu(struct io_ring_ctx *ctx, int cpu)
> +{
> +       struct sq_thread_percpu *t;
> +
> +       t = per_cpu_ptr(percpu_threads, cpu);
> +       mutex_lock(&t->lock);
> +       if (!t->sqo_thread) {
> +               t->sqo_thread = kthread_create_on_cpu(io_sq_thread_percpu, t,
> +                                       cpu, "io_uring-sq-percpu");
> +               if (IS_ERR(t->sqo_thread)) {
> +                       ctx->sqo_thread = t->sqo_thread;
> +                       t->sqo_thread = NULL;
> +                       mutex_unlock(&t->lock);
> +                       return;
> +               }
> +       }
> +
> +       if (t->sq_thread_idle < ctx->sq_thread_idle)
> +               t->sq_thread_idle = ctx->sq_thread_idle;
> +       ctx->sqo_wait = &t->sqo_wait;
> +       ctx->sq_thread_cpu = cpu;
> +       list_add_tail(&ctx->node, &t->ctx_list);
> +       ctx->sqo_thread = t->sqo_thread;
> +       mutex_unlock(&t->lock);
> +}
> +
> +static void destroy_sq_thread_percpu(struct io_ring_ctx *ctx, int cpu)
> +{
> +       struct sq_thread_percpu *t;
> +       struct task_struct *sqo_thread = NULL;
> +
> +       t = per_cpu_ptr(percpu_threads, cpu);
> +       mutex_lock(&t->lock);
> +       list_del(&ctx->node);
> +       if (list_empty(&t->ctx_list)) {
> +               sqo_thread = t->sqo_thread;
> +               t->sqo_thread = NULL;
> +       }
> +       mutex_unlock(&t->lock);
> +
> +       if (sqo_thread) {
> +               wait_for_completion(&t->sq_thread_comp);
> +               kthread_park(sqo_thread);
> +               kthread_stop(sqo_thread);
> +       }
> +}
> +
> +
>  static int io_sq_offload_start(struct io_ring_ctx *ctx,
>                                struct io_uring_params *p)
>  {
> @@ -6943,9 +7158,11 @@ static int io_sq_offload_start(struct io_ring_ctx *ctx,
>                         if (!cpu_online(cpu))
>                                 goto err;
> 
> -                       ctx->sqo_thread = kthread_create_on_cpu(io_sq_thread,
> -                                                       ctx, cpu,
> -                                                       "io_uring-sq");
> +                       if ((p->flags & IORING_SETUP_SQPOLL_PERCPU) && percpu_threads)
> +                               create_sq_thread_percpu(ctx, cpu);
> +                       else
> +                               ctx->sqo_thread = kthread_create_on_cpu(io_sq_thread, ctx, cpu,
> +                                                                       "io_uring-sq");
>                 } else {
>                         ctx->sqo_thread = kthread_create(io_sq_thread, ctx,
>                                                         "io_uring-sq");
> @@ -7632,7 +7849,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
>                 if (!list_empty_careful(&ctx->cq_overflow_list))
>                         io_cqring_overflow_flush(ctx, false);
>                 if (flags & IORING_ENTER_SQ_WAKEUP)
> -                       wake_up(&ctx->sqo_wait);
> +                       wake_up(ctx->sqo_wait);
>                 submitted = to_submit;
>         } else if (to_submit) {
>                 mutex_lock(&ctx->uring_lock);
> @@ -7990,7 +8207,8 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
> 
>         if (p.flags & ~(IORING_SETUP_IOPOLL | IORING_SETUP_SQPOLL |
>                         IORING_SETUP_SQ_AFF | IORING_SETUP_CQSIZE |
> -                       IORING_SETUP_CLAMP | IORING_SETUP_ATTACH_WQ))
> +                       IORING_SETUP_CLAMP | IORING_SETUP_ATTACH_WQ |
> +                       IORING_SETUP_SQPOLL_PERCPU))
>                 return -EINVAL;
> 
>         return  io_uring_create(entries, &p, params);
> @@ -8218,6 +8436,8 @@ SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
> 
>  static int __init io_uring_init(void)
>  {
> +       int cpu;
> +
>  #define __BUILD_BUG_VERIFY_ELEMENT(stype, eoffset, etype, ename) do { \
>         BUILD_BUG_ON(offsetof(stype, ename) != eoffset); \
>         BUILD_BUG_ON(sizeof(etype) != sizeof_field(stype, ename)); \
> @@ -8257,6 +8477,28 @@ static int __init io_uring_init(void)
>         BUILD_BUG_ON(ARRAY_SIZE(io_op_defs) != IORING_OP_LAST);
>         BUILD_BUG_ON(__REQ_F_LAST_BIT >= 8 * sizeof(int));
>         req_cachep = KMEM_CACHE(io_kiocb, SLAB_HWCACHE_ALIGN | SLAB_PANIC);
> +
> +
> +       percpu_threads = alloc_percpu(struct sq_thread_percpu);
> +       /*
> +        * Don't take this as fatal error, if this happens, we will just
> +        * make io sq thread not go through io_sq_thread percpu version.
> +        */
> +       if (!percpu_threads)
> +               return 0;
> +
> +       for_each_possible_cpu(cpu) {
> +               struct sq_thread_percpu *t;
> +
> +               t = per_cpu_ptr(percpu_threads, cpu);
> +               INIT_LIST_HEAD(&t->ctx_list);
> +               init_waitqueue_head(&t->sqo_wait);
> +               init_completion(&t->sq_thread_comp);
> +               mutex_init(&t->lock);
> +               t->sqo_thread = NULL;
> +               t->sq_thread_idle = 0;
> +       }
> +
>         return 0;
>  };
>  __initcall(io_uring_init);
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index d25c42ae6052..5929b7b95368 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -94,6 +94,7 @@ enum {
>  #define IORING_SETUP_CQSIZE    (1U << 3)       /* app defines CQ size */
>  #define IORING_SETUP_CLAMP     (1U << 4)       /* clamp SQ/CQ ring sizes */
>  #define IORING_SETUP_ATTACH_WQ (1U << 5)       /* attach to existing wq */
> +#define IORING_SETUP_SQPOLL_PERCPU     (1U << 31)      /* use percpu SQ poll thread */
> 
>  enum {
>         IORING_OP_NOP,
> 
> Regards,
> Xiaoguang Wang
> 
> 
>> We support using IORING_SETUP_ATTACH_WQ to share async backends between
>> rings created by the same process, this now also allows the same to
>> happen with SQPOLL. The setup procedure remains the same, the caller
>> sets io_uring_params->wq_fd to the 'parent' context, and then the newly
>> created ring will attach to that async backend.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>   fs/io_uring.c | 43 +++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 43 insertions(+)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 5bafc7a2c65c..07e16049e62d 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -232,6 +232,10 @@ struct io_restriction {
>>   struct io_sq_data {
>>       refcount_t        refs;
>>   +    /* global sqd lookup */
>> +    struct list_head    all_sqd_list;
>> +    int            attach_fd;
>> +
>>       /* ctx's that are using this sqd */
>>       struct list_head    ctx_list;
>>       struct list_head    ctx_new_list;
>> @@ -241,6 +245,9 @@ struct io_sq_data {
>>       struct wait_queue_head    wait;
>>   };
>>   +static LIST_HEAD(sqd_list);
>> +static DEFINE_MUTEX(sqd_lock);
>> +
>>   struct io_ring_ctx {
>>       struct {
>>           struct percpu_ref    refs;
>> @@ -6975,14 +6982,38 @@ static void io_put_sq_data(struct io_sq_data *sqd)
>>               kthread_stop(sqd->thread);
>>           }
>>   +        mutex_lock(&sqd_lock);
>> +        list_del(&sqd->all_sqd_list);
>> +        mutex_unlock(&sqd_lock);
>> +
>>           kfree(sqd);
>>       }
>>   }
>>   +static struct io_sq_data *io_attach_sq_data(struct io_uring_params *p)
>> +{
>> +    struct io_sq_data *sqd, *ret = ERR_PTR(-ENXIO);
>> +
>> +    mutex_lock(&sqd_lock);
>> +    list_for_each_entry(sqd, &sqd_list, all_sqd_list) {
>> +        if (sqd->attach_fd == p->wq_fd) {
>> +            refcount_inc(&sqd->refs);
>> +            ret = sqd;
>> +            break;
>> +        }
>> +    }
>> +    mutex_unlock(&sqd_lock);
>> +
>> +    return ret;
>> +}
>> +
>>   static struct io_sq_data *io_get_sq_data(struct io_uring_params *p)
>>   {
>>       struct io_sq_data *sqd;
>>   +    if (p->flags & IORING_SETUP_ATTACH_WQ)
>> +        return io_attach_sq_data(p);
>> +
>>       sqd = kzalloc(sizeof(*sqd), GFP_KERNEL);
>>       if (!sqd)
>>           return ERR_PTR(-ENOMEM);
>> @@ -6992,6 +7023,10 @@ static struct io_sq_data *io_get_sq_data(struct io_uring_params *p)
>>       INIT_LIST_HEAD(&sqd->ctx_new_list);
>>       mutex_init(&sqd->ctx_lock);
>>       init_waitqueue_head(&sqd->wait);
>> +
>> +    mutex_lock(&sqd_lock);
>> +    list_add_tail(&sqd->all_sqd_list, &sqd_list);
>> +    mutex_unlock(&sqd_lock);
>>       return sqd;
>>   }
>>   @@ -7675,6 +7710,9 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
>>           if (!ctx->sq_thread_idle)
>>               ctx->sq_thread_idle = HZ;
>>   +        if (sqd->thread)
>> +            goto done;
>> +
>>           if (p->flags & IORING_SETUP_SQ_AFF) {
>>               int cpu = p->sq_thread_cpu;
>>   @@ -7701,6 +7739,7 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
>>           goto err;
>>       }
>>   +done:
>>       ret = io_init_wq_offload(ctx, p);
>>       if (ret)
>>           goto err;
>> @@ -8831,6 +8870,10 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
>>       if (ret < 0)
>>           goto err;
>>   +    if ((ctx->flags & (IORING_SETUP_SQPOLL | IORING_SETUP_ATTACH_WQ)) ==
>> +        IORING_SETUP_SQPOLL)
>> +        ctx->sq_data->attach_fd = ret;
>> +
>>       trace_io_uring_create(ret, ctx, p->sq_entries, p->cq_entries, p->flags);
>>       return ret;
>>   err:
>>

-- 
Pavel Begunkov
