Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBC1F46C5D3
	for <lists+io-uring@lfdr.de>; Tue,  7 Dec 2021 22:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236374AbhLGVFb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Dec 2021 16:05:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233007AbhLGVE4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Dec 2021 16:04:56 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7E6EC0698FD
        for <io-uring@vger.kernel.org>; Tue,  7 Dec 2021 13:01:25 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id r9-20020a7bc089000000b00332f4abf43fso2356516wmh.0
        for <io-uring@vger.kernel.org>; Tue, 07 Dec 2021 13:01:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=KAa7fSywz3jhvhB/KLLHxB2dWeh/yqk9OP5+HQ3yx6Q=;
        b=fzry8LbH2yDwjBJ0XHRgBIcqKxx1NWcPCMFuk5kkTrTKSeeaSmHazl7FsMvagcdb/Q
         BWVVBt7GYw8SCjdUAhBB1l8dcSpeaixKRTuX38dt8hJQ4UIlCM4oOPTQp13ERvsN/V7x
         fsQ55xmnIUV2IUH3pmebcnYdx+OvVEhDynYEVK0aZUKkvicWP3w0lgmwc1QUoyKrNf/A
         LNTPejoTfUxJXnV9Q1I4IaPLvbtuL51jM7dhN7j6X7TSDqa2gd3Q3tNjtjJT6N08d8zN
         N0DgNCo6RyKidGH1p4Uf+vQZLb+7EasmkkEh/WcPV8vrhVYUPTCu1ne4CcK4/ph1TgWI
         yOVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=KAa7fSywz3jhvhB/KLLHxB2dWeh/yqk9OP5+HQ3yx6Q=;
        b=bU/rXnaMLWM/KbXtD7Zb7EpVWQPyQL2l0air+DpbqjdJ9tIxWFtK6utVn+bSij+qtG
         G6NUbJRJMNLgCYkDOMk3BxpeJIt0gRqvXRuyPLVliyPt49Om9Gt8umb8FIXVemysfT3X
         Y6pAb6Mug+TVoeEBNEZVKjRnrF4wqSavcoHMcikAmQCs+lSbnV/i97ntmJC5dATy62Y2
         pjkCihEoQn1GDQ2V8U/OeiI/Rn0xGAhmTgtZhW4Tet3C3GiLe2yzwtcSUkHgD5u2dpB7
         uu9Fk+pSUWREBQoRvxGcF+PlJAlIh7duJ/e5cKren/B4yy44UQr9+Ltv3GuxLhDS403i
         ZhEQ==
X-Gm-Message-State: AOAM530fzLKvogaTTzXavkOYvcOrkMmjEYuYhxIJJaXRiu7QDdh+7uVp
        Q6nTAye05mkZPpg6wPFm1Bw=
X-Google-Smtp-Source: ABdhPJxELNvuICuyhwINeKjqsBJFwEDKvnp4l32jruN7HhSg46FpHZWL2jjlSV2RMFIrV76Qh1NOyQ==
X-Received: by 2002:a1c:988e:: with SMTP id a136mr8988327wme.185.1638910884294;
        Tue, 07 Dec 2021 13:01:24 -0800 (PST)
Received: from [192.168.8.198] ([148.252.132.245])
        by smtp.gmail.com with ESMTPSA id d15sm1199996wri.50.2021.12.07.13.01.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Dec 2021 13:01:23 -0800 (PST)
Message-ID: <fc9a8ac2-f339-a5c4-a85d-19d8c324a311@gmail.com>
Date:   Tue, 7 Dec 2021 21:01:25 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH 5/5] io_uring: batch completion in prior_task_list
Content-Language: en-US
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211207093951.247840-1-haoxu@linux.alibaba.com>
 <20211207093951.247840-6-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20211207093951.247840-6-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/7/21 09:39, Hao Xu wrote:
> In previous patches, we have already gathered some tw with
> io_req_task_complete() as callback in prior_task_list, let's complete
> them in batch while we cannot grab uring lock. In this way, we batch
> the req_complete_post path.
> 
> Tested-by: Pavel Begunkov <asml.silence@gmail.com>

Hao, please never add tags for other people unless they confirmed
that it's fine. I asked Jens to kill this one and my signed-off
from 4/5 from io_uring branches.


> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
> 
> Hi Pavel,
> May I add the above Test-by tag here?
> 
>   fs/io_uring.c | 70 +++++++++++++++++++++++++++++++++++++++++++--------
>   1 file changed, 60 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 21738ed7521e..f224f8df77a1 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2225,6 +2225,49 @@ static void ctx_flush_and_put(struct io_ring_ctx *ctx, bool *locked)
>   	percpu_ref_put(&ctx->refs);
>   }
>   
> +static inline void ctx_commit_and_unlock(struct io_ring_ctx *ctx)
> +{
> +	io_commit_cqring(ctx);
> +	spin_unlock(&ctx->completion_lock);
> +	io_cqring_ev_posted(ctx);
> +}
> +
> +static void handle_prior_tw_list(struct io_wq_work_node *node, struct io_ring_ctx **ctx,
> +				 bool *uring_locked, bool *compl_locked)

compl_locked probably can be a local var here, you're clearing it at the
end of the function anyway.

> +{
> +	do {
> +		struct io_wq_work_node *next = node->next;
> +		struct io_kiocb *req = container_of(node, struct io_kiocb,
> +						    io_task_work.node);
> +
> +		if (req->ctx != *ctx) {
> +			if (unlikely(*compl_locked)) {
> +				ctx_commit_and_unlock(*ctx);
> +				*compl_locked = false;
> +			}
> +			ctx_flush_and_put(*ctx, uring_locked);
> +			*ctx = req->ctx;
> +			/* if not contended, grab and improve batching */
> +			*uring_locked = mutex_trylock(&(*ctx)->uring_lock);
> +			percpu_ref_get(&(*ctx)->refs);
> +			if (unlikely(!*uring_locked)) {
> +				spin_lock(&(*ctx)->completion_lock);
> +				*compl_locked = true;
> +			}
> +		}
> +		if (likely(*uring_locked))
> +			req->io_task_work.func(req, uring_locked);
> +		else
> +			__io_req_complete_post(req, req->result, io_put_kbuf(req));

I think there is the same issue as last time, first iteration of tctx_task_work()
sets ctx but doesn't get uring_lock. Then you go here, find a request with the
same ctx and end up here with locking.


> +		node = next;
> +	} while (node);
> +
> +	if (unlikely(*compl_locked)) {
> +		ctx_commit_and_unlock(*ctx);
> +		*compl_locked = false;
> +	}
> +}


-- 
Pavel Begunkov
