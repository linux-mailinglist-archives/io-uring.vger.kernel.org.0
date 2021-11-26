Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 381E245F0D2
	for <lists+io-uring@lfdr.de>; Fri, 26 Nov 2021 16:37:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378130AbhKZPkr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Nov 2021 10:40:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232773AbhKZPiq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Nov 2021 10:38:46 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F16C0613F3
        for <io-uring@vger.kernel.org>; Fri, 26 Nov 2021 07:29:18 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id j3so19472430wrp.1
        for <io-uring@vger.kernel.org>; Fri, 26 Nov 2021 07:29:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Gze4rUZfYpGEzvPKAgxYVIePNQkQdm1TLi6tsJm+lIw=;
        b=JXj3upwfRoB1OLJ+6NN5m8SWRlg8ts9VMWUFX4uy8QqFgkZJ6PILJv2MSVbMOLy4O3
         yaZTcc0XR+mUmLgu1aFQZGDrDy7oC3KTgLsXLsWa3l4K0K9zi2HOSJ+DvmQLfPjYfO8f
         r5O2ypPMT456UBGg784fdRR7g8USs/ZH3csRgPneR8Bru0Mdqc4RV0/tsW24zm6gfwTo
         VIsozkzRx0nCsLPPFdT3pG416MhLoQoWE8pO7Qn+5tyG08X9GKbFKMhGjZyhxWcWBQky
         xMGM9QdKkr4x2cPkDJ2UJA5dqn0i1PF/vqkLcqJgUTphrtjv5ls/KySc0Oi8U9GfNq6n
         NCTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Gze4rUZfYpGEzvPKAgxYVIePNQkQdm1TLi6tsJm+lIw=;
        b=IJsDjcf9WswenBe60Eca2PwZmu0mu39/9xv5RgXEwFswzErGXwjw1cctB7oZeKH+fj
         Ny3cJiUZsqqqDOKPUiwuyeoku1wmmW1QI0t8ZWIOBthDox4Fk7v6l3+8K7I7ivGJ46qW
         rLdxAQcyzmyaCrvQurd4zrfsNT6SLRH4FDfwGLDKE8g+WlclEsn4fg/B1I/2Eq1Q+NnG
         hkLsi+++/SUNFRSXUneOr01/xgt8AC/gNz1ZLjKE1VvWTbZB9Wv2uuWWoioJ5hzbYqLO
         qnVwZvDcIL9QiqOe0avU+ZKz0CcmXLDsuai4HV4aX/lW+j+jeNj/gRGbKQdxZnvKJ+6V
         HmmA==
X-Gm-Message-State: AOAM532yqVeyZaZB1S1w/BcCSU8Gnvcn1X+aQXVGd6DKciAsfqHYa599
        7RdEDPMdwFA/mVvfeeszWJAwb/OuoWw=
X-Google-Smtp-Source: ABdhPJx3CAXNMcSW+R+6UF12jJCxNA3whLYrwcmtKs0vgPiVsXZUmYxbZ0eYoXAHz70a0WBBQzU+Ew==
X-Received: by 2002:a5d:40cf:: with SMTP id b15mr15004841wrq.161.1637940556871;
        Fri, 26 Nov 2021 07:29:16 -0800 (PST)
Received: from [192.168.43.77] (82-132-231-175.dab.02.net. [82.132.231.175])
        by smtp.gmail.com with ESMTPSA id y15sm7354875wry.72.2021.11.26.07.29.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Nov 2021 07:29:16 -0800 (PST)
Message-ID: <46bcbe8d-14a2-9d02-664f-fa9980d55a13@gmail.com>
Date:   Fri, 26 Nov 2021 15:29:13 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH 2/2] io_uring: fix link traversal locking
Content-Language: en-US
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <cover.1637937097.git.asml.silence@gmail.com>
 <397f7ebf3f4171f1abe41f708ac1ecb5766f0b68.1637937097.git.asml.silence@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <397f7ebf3f4171f1abe41f708ac1ecb5766f0b68.1637937097.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/26/21 14:38, Pavel Begunkov wrote:
> 674ee8e1b4a41 ("io_uring: correct link-list traversal locking") fixed a

The problematic commit is marked stable, so

Cc: stable@kernel.org # 5.15+

> data race but introduced a possible deadlock and inconsistentcy in irq
> states. E.g.
> 
> io_poll_remove_all()
>      spin_lock_irq(timeout_lock)
>      io_poll_remove_one()
>          spin_lock/unlock_irq(poll_lock);
>      spin_unlock_irq(timeout_lock)
> 
> Another type of problem is freeing a request while holding
> ->timeout_lock, which may leads to a deadlock in
> io_commit_cqring() -> io_flush_timeouts() and other places.
> 
> Having 3 nested locks is also too ugly. Add io_match_task_safe(), which
> would briefly take and release timeout_lock for race prevention inside,
> so the actuall request cancellation / free / etc. code doesn't have it
> taken.
> 
> Reported-by: syzbot+ff49a3059d49b0ca0eec@syzkaller.appspotmail.com
> Reported-by: syzbot+847f02ec20a6609a328b@syzkaller.appspotmail.com
> Reported-by: syzbot+3368aadcd30425ceb53b@syzkaller.appspotmail.com
> Reported-by: syzbot+51ce8887cdef77c9ac83@syzkaller.appspotmail.com
> Reported-by: syzbot+3cb756a49d2f394a9ee3@syzkaller.appspotmail.com
> Fixes: 674ee8e1b4a41 ("io_uring: correct link-list traversal locking")
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   fs/io_uring.c | 60 +++++++++++++++++++++++++++++++++++----------------
>   1 file changed, 42 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 7dd112d44adf..75841b919dce 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1278,6 +1278,7 @@ static void io_refs_resurrect(struct percpu_ref *ref, struct completion *compl)
>   
>   static bool io_match_task(struct io_kiocb *head, struct task_struct *task,
>   			  bool cancel_all)
> +	__must_hold(&req->ctx->timeout_lock)
>   {
>   	struct io_kiocb *req;
>   
> @@ -1293,6 +1294,44 @@ static bool io_match_task(struct io_kiocb *head, struct task_struct *task,
>   	return false;
>   }
>   
> +static bool io_match_linked(struct io_kiocb *head)
> +{
> +	struct io_kiocb *req;
> +
> +	io_for_each_link(req, head) {
> +		if (req->flags & REQ_F_INFLIGHT)
> +			return true;
> +	}
> +	return false;
> +}
> +
> +/*
> + * As io_match_task() but protected against racing with linked timeouts.
> + * User must not hold timeout_lock.
> + */
> +static bool io_match_task_safe(struct io_kiocb *head, struct task_struct *task,
> +			       bool cancel_all)
> +{
> +	bool matched;
> +
> +	if (task && head->task != task)
> +		return false;
> +	if (cancel_all)
> +		return true;
> +
> +	if (head->flags & REQ_F_LINK_TIMEOUT) {
> +		struct io_ring_ctx *ctx = head->ctx;
> +
> +		/* protect against races with linked timeouts */
> +		spin_lock_irq(&ctx->timeout_lock);
> +		matched = io_match_linked(head);
> +		spin_unlock_irq(&ctx->timeout_lock);
> +	} else {
> +		matched = io_match_linked(head);
> +	}
> +	return matched;
> +}
> +
>   static inline bool req_has_async_data(struct io_kiocb *req)
>   {
>   	return req->flags & REQ_F_ASYNC_DATA;
> @@ -5699,17 +5738,15 @@ static __cold bool io_poll_remove_all(struct io_ring_ctx *ctx,
>   	int posted = 0, i;
>   
>   	spin_lock(&ctx->completion_lock);
> -	spin_lock_irq(&ctx->timeout_lock);
>   	for (i = 0; i < (1U << ctx->cancel_hash_bits); i++) {
>   		struct hlist_head *list;
>   
>   		list = &ctx->cancel_hash[i];
>   		hlist_for_each_entry_safe(req, tmp, list, hash_node) {
> -			if (io_match_task(req, tsk, cancel_all))
> +			if (io_match_task_safe(req, tsk, cancel_all))
>   				posted += io_poll_remove_one(req);
>   		}
>   	}
> -	spin_unlock_irq(&ctx->timeout_lock);
>   	spin_unlock(&ctx->completion_lock);
>   
>   	if (posted)
> @@ -9565,19 +9602,8 @@ static bool io_cancel_task_cb(struct io_wq_work *work, void *data)
>   {
>   	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
>   	struct io_task_cancel *cancel = data;
> -	bool ret;
>   
> -	if (!cancel->all && (req->flags & REQ_F_LINK_TIMEOUT)) {
> -		struct io_ring_ctx *ctx = req->ctx;
> -
> -		/* protect against races with linked timeouts */
> -		spin_lock_irq(&ctx->timeout_lock);
> -		ret = io_match_task(req, cancel->task, cancel->all);
> -		spin_unlock_irq(&ctx->timeout_lock);
> -	} else {
> -		ret = io_match_task(req, cancel->task, cancel->all);
> -	}
> -	return ret;
> +	return io_match_task_safe(req, cancel->task, cancel->all);
>   }
>   
>   static __cold bool io_cancel_defer_files(struct io_ring_ctx *ctx,
> @@ -9588,14 +9614,12 @@ static __cold bool io_cancel_defer_files(struct io_ring_ctx *ctx,
>   	LIST_HEAD(list);
>   
>   	spin_lock(&ctx->completion_lock);
> -	spin_lock_irq(&ctx->timeout_lock);
>   	list_for_each_entry_reverse(de, &ctx->defer_list, list) {
> -		if (io_match_task(de->req, task, cancel_all)) {
> +		if (io_match_task_safe(de->req, task, cancel_all)) {
>   			list_cut_position(&list, &ctx->defer_list, &de->list);
>   			break;
>   		}
>   	}
> -	spin_unlock_irq(&ctx->timeout_lock);
>   	spin_unlock(&ctx->completion_lock);
>   	if (list_empty(&list))
>   		return false;
> 

-- 
Pavel Begunkov
