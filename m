Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DCFC312666
	for <lists+io-uring@lfdr.de>; Sun,  7 Feb 2021 18:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbhBGRe3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 7 Feb 2021 12:34:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbhBGRe2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 7 Feb 2021 12:34:28 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24682C06174A
        for <io-uring@vger.kernel.org>; Sun,  7 Feb 2021 09:33:48 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id c6so15537136ede.0
        for <io-uring@vger.kernel.org>; Sun, 07 Feb 2021 09:33:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=H0ZS6vpdYgC/QH3ExWcI5qAiEtHqMt6RBkM7EzK2Oko=;
        b=eEAn5XEPJucDVm6rOPeTDzjR2CdS46dS56M7/WOOCL62pZSpFO6+M7ZNFOCB7uHJ/2
         rboH2FmTOn+1EkGItBPYhVOIlbonyYRF8QrvRc+DGEgRYLeq4DFQ7ERCeyXZSikNO9CS
         Xt/1AYIC81dTQlaONAXFeA9AMW6y2NQJ7MjHFTFjgK9szRqjSD8VTvKWIkfLXVkqMH3K
         7IrdaJB+C8KV6l/gCdPS4N4Hs0juZ8BUpxya3gSIYyrQLIsWgPtDXJPR07oxtIRX6e7h
         lTQ11eQoghR8Ois4dXDnWLW6j7l4sa8SXgYKXsksGgMA0Dg1UwrWiveIzabs6KJ+E0Mw
         9N1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=H0ZS6vpdYgC/QH3ExWcI5qAiEtHqMt6RBkM7EzK2Oko=;
        b=o4A29IuDumB3ZpffOaBdUQTfxl64GRsRnPQ3yjEN9xIukzPrLSBvW06GUFhk3yWIYz
         7/ENFV2dVpQFkIDglJrjHU2SKxW4m1FBKRzHoseMMrX0uYVW3e8ysVn+k1vh3xgjPLYL
         /kfyherqvRAIRrsdpSJyDiSQ9y0gCTiKKZU/GQ/35pYt7fe+MDb1NL2C0cRbUbK8vCXC
         4VBhll6mQYlVh1XhCwjr9ekDEGU+/nw6zn2DVQd/qXjYKyBM4o306K+ZhvpWUfvUcZze
         fxzxuM6uQq/n6Kx77nYTw7ApbAhWWSzWIJwXztqLiNtxRCjK3T7U5saJYpdv7BMiRYux
         SovQ==
X-Gm-Message-State: AOAM530CYDOfXWMW57aQjknzzZ0NRsU8T6Dq72MQARcFTTXIwsqMhoqm
        rDrE5ahs1Bm6bLUyzBQstb8=
X-Google-Smtp-Source: ABdhPJwiv+JJsZfKp7cEKsV2TQ5E4HN80bACq7ggQmtYPE+l3x9LzEgVqEcTIs2TIqGqoBjRJEN2Rg==
X-Received: by 2002:aa7:c98e:: with SMTP id c14mr10127529edt.213.1612719226678;
        Sun, 07 Feb 2021 09:33:46 -0800 (PST)
Received: from [192.168.8.177] ([148.252.128.244])
        by smtp.gmail.com with ESMTPSA id l12sm5761456edn.83.2021.02.07.09.33.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Feb 2021 09:33:46 -0800 (PST)
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com
References: <20210206150006.1945-1-xiaoguang.wang@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH] io_uring: don't issue reqs in iopoll mode when ctx is
 dying
Message-ID: <e4220bf0-2d60-cdd8-c738-cf48236073fa@gmail.com>
Date:   Sun, 7 Feb 2021 17:30:01 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20210206150006.1945-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 06/02/2021 15:00, Xiaoguang Wang wrote:
> Abaci Robot reported following panic:
> ------------[ cut here ]------------
> refcount_t: underflow; use-after-free.
> WARNING: CPU: 1 PID: 195 at lib/refcount.c:28 refcount_warn_saturate+0x137/0x140
> Modules linked in:
> CPU: 1 PID: 195 Comm: kworker/u4:2 Not tainted 5.11.0-rc3+ #70
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.11.1-0-g0551a4be2c-prebuilt.qemu-project.or4
> Workqueue: events_unbound io_ring_exit_work
> RIP: 0010:refcount_warn_saturate+0x137/0x140
> Code: 05 ad 63 49 08 01 e8 45 0f 6f 00 0f 0b e9 16 ff ff ff e8 4c ba ae ff 48 c7 c7 28 2e 7c 82 c6 05 90 63 40
> RSP: 0018:ffffc900002e3cc8 EFLAGS: 00010282
> RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000000
> RDX: ffff888102918000 RSI: ffffffff81150a34 RDI: ffff88813bd28570
> RBP: ffff8881075cd348 R08: 0000000000000001 R09: 0000000000000001
> R10: 0000000000000001 R11: 0000000000080000 R12: ffff8881075cd308
> R13: ffff8881075cd348 R14: ffff888122d33ab8 R15: ffff888104780300
> FS:  0000000000000000(0000) GS:ffff88813bd00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000108 CR3: 0000000107636005 CR4: 0000000000060ee0
> Call Trace:
>  io_dismantle_req+0x3f3/0x5b0
>  __io_free_req+0x2c/0x270
>  io_put_req+0x4c/0x70
>  io_wq_cancel_cb+0x171/0x470
>  ? io_match_task.part.0+0x80/0x80
>  __io_uring_cancel_task_requests+0xa0/0x190
>  io_ring_exit_work+0x32/0x3e0
>  process_one_work+0x2f3/0x720
>  worker_thread+0x5a/0x4b0
>  ? process_one_work+0x720/0x720
>  kthread+0x138/0x180
>  ? kthread_park+0xd0/0xd0
>  ret_from_fork+0x1f/0x30
> 
> Later system will panic for some memory corruption.
> 
> The io_identity's count is underflowed. It's because in io_put_identity,
> first argument tctx comes from req->task->io_uring, the second argument
> comes from the task context that calls io_req_init_async, so the compare
> in io_put_identity maybe meaningless. See below case:
>     task context A issue one polled req, then req->task = A.
>     task context B do iopoll, above req returns with EAGAIN error.
>     task context B re-issue req, call io_queue_async_work for req.
>     req->task->io_uring will set to task context B's identity, or cow new one.
> then for above case, in io_put_identity(), the compare is meaningless.
> 
> IIUC, req->task should indicates the initial task context that issues req,
> then if it gets EAGAIN error, we'll call io_prep_async_work() in req->task
> context, but iopoll reqs seems special, they maybe issued successfully and
> got re-issued in other task context because of EAGAIN error.

Looks as you say, but the patch doesn't solve the issue completely.
1. We must not do io_queue_async_work() under a different task context,
because of it potentially uses a different set of resources. So, I just
thought that it would be better to punt it to the right task context
via task_work. But...

2. ...iovec import from io_resubmit_prep() might happen after submit ends,
i.e. when iovec was freed in userspace. And that's not great at all.

> Currently for this panic, we can disable issuing reqs that are returned
> with EAGAIN error in iopoll mode when ctx is dying, but we may need to
> re-consider the io identity codes more.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> ---
>  fs/io_uring.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 9db05171a774..e3b90426d72b 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2467,7 +2467,12 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
>  		int cflags = 0;
>  
>  		req = list_first_entry(done, struct io_kiocb, inflight_entry);
> -		if (READ_ONCE(req->result) == -EAGAIN) {
> +		/*
> +		 * If ctx is dying, don't need to issue reqs that are returned
> +		 * with EAGAIN error, since there maybe no users to reap them.
> +		 */
> +		if ((READ_ONCE(req->result) == -EAGAIN) &&
> +		    !percpu_ref_is_dying(&ctx->refs)) {
>  			req->result = 0;
>  			req->iopoll_completed = 0;
>  			list_move_tail(&req->inflight_entry, &again);
> 

-- 
Pavel Begunkov
