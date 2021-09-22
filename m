Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02449414E0D
	for <lists+io-uring@lfdr.de>; Wed, 22 Sep 2021 18:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233094AbhIVQ0n (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Sep 2021 12:26:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232357AbhIVQ0m (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Sep 2021 12:26:42 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CE6FC061574
        for <io-uring@vger.kernel.org>; Wed, 22 Sep 2021 09:25:12 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id y89so1402656ede.2
        for <io-uring@vger.kernel.org>; Wed, 22 Sep 2021 09:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gMitJevBurH0LCxDCBSaiDBUrnV0BcD4itPVTgXjewE=;
        b=jQjJcC3STnfdewH5nZ6VmW7YfaTfecAegI8mPgcBEymGqBde1fclnzsk3aEHvJEict
         BsC18OeCvDkuCFqIJX04RW1jMZVwAn9ybAXaLMLxfxilQiinv2hbacFX9FyLXfMQeZGS
         xv+9UD9zNkyjZ7PI0z6lzvyJR+ngiqdAF9/bwFrYVUTRnLOSe6u28aI1FQCcnbxDKfiL
         p+egcu4NZcAtxAbNm6uQtwtXi5AbkvOGpQRc9xvsrZ4/ZKd5HGaJhpj5sZ00tC+YQ473
         Maheqhd6tCeHzVdcKxOQhYMbcTXH6gQHRzvkxUeqMeLJ2cqOSZgbB8D5CxuCzAQwpS8X
         VIUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gMitJevBurH0LCxDCBSaiDBUrnV0BcD4itPVTgXjewE=;
        b=SoOfB/uNRw2cbXgctKsG1PVtLcD7N0TD0/g8Saw7l882lb5QHoe6FF3UP/VdRAVo+/
         oO7pylGlUnNrKre9gi8kFnc4cbvgn2alUrDP1aQEPlJBMW1t8X/V1WeKfKmOSZmw5H0D
         XoeCZfwmJmTsA04WjtD5GTyLXRDXpCTfwcH8dKuovvr2ypMQm2/EXq+4FhUAEtPgi7G5
         MILGvD5Cu+x6FSc1VmCMKxCl6iouQYAXG5neXIBu0T5E1oTLbz9tteuozu4WQ+cJWBsk
         MB4iyw4pqqmMQwu4uGfVu0LGrhklNUkGlalL/bnKvbA1j+0t2Bv3IZCAgza5SJlTJMrq
         4lVw==
X-Gm-Message-State: AOAM531whAZzENQBdruXh1PFEAokZthhdnj2Uxi7s1vUvgY5vcczCZJc
        4pvYKgPf6bghY72IRWrN9GI8hU4P/MY=
X-Google-Smtp-Source: ABdhPJxyJFM0+WrrduJ2V5XwaBe/IafmKdr64+DGJHEbeMRS7sgkbYpfF6+RGbDoSqQfZ1W4YLD9jg==
X-Received: by 2002:a17:906:c1c9:: with SMTP id bw9mr458998ejb.3.1632327910412;
        Wed, 22 Sep 2021 09:25:10 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.234.68])
        by smtp.gmail.com with ESMTPSA id ml12sm1264723ejb.29.2021.09.22.09.25.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Sep 2021 09:25:10 -0700 (PDT)
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     axboe@kernel.dk
References: <20210922123417.2844-1-xiaoguang.wang@linux.alibaba.com>
 <20210922123417.2844-4-xiaoguang.wang@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [RFC 3/3] io_uring: try to batch poll request completion
Message-ID: <a6806f4e-de9f-81b5-2c5e-3e59a6a6d318@gmail.com>
Date:   Wed, 22 Sep 2021 17:24:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210922123417.2844-4-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/22/21 1:34 PM, Xiaoguang Wang wrote:
> For an echo-server based on io_uring's IORING_POLL_ADD_MULTI feature,
> only poll request are completed in task work, normal read/write
> requests are issued when user app sees cqes on corresponding poll
> requests, and they will mostly read/write data successfully, which
> don't need task work. So at least for echo-server model, batching
> poll request completion properly will give benefits.
> 
> Currently don't find any appropriate place to store batched poll
> requests, put them in struct io_submit_state temporarily, which I
> think it'll need rework in future.
> 
> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> ---
>  fs/io_uring.c | 64 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 63 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 6fdfb688cf91..14118388bfc6 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -321,6 +321,11 @@ struct io_submit_state {
>  	 */
>  	struct io_kiocb		*compl_reqs[IO_COMPL_BATCH];
>  	unsigned int		compl_nr;
> +
> +	struct io_kiocb		*poll_compl_reqs[IO_COMPL_BATCH];
> +	bool			poll_req_status[IO_COMPL_BATCH];
> +	unsigned int		poll_compl_nr;
> +
>  	/* inline/task_work completion list, under ->uring_lock */
>  	struct list_head	free_list;
>  
> @@ -2093,6 +2098,8 @@ static void ctx_flush_and_put(struct io_ring_ctx *ctx, bool *locked)
>  	percpu_ref_put(&ctx->refs);
>  }
>  
> +static void io_poll_flush_completions(struct io_ring_ctx *ctx, bool *locked);
> +
>  static void tctx_task_work(struct callback_head *cb)
>  {
>  	bool locked = false;
> @@ -2103,8 +2110,11 @@ static void tctx_task_work(struct callback_head *cb)
>  	while (1) {
>  		struct io_wq_work_node *node;
>  
> -		if (!tctx->task_list.first && locked && ctx->submit_state.compl_nr)
> +		if (!tctx->task_list.first && locked && (ctx->submit_state.compl_nr ||
> +		    ctx->submit_state.poll_compl_nr)) {

io_submit_flush_completions() shouldn't be called if there are no requests... And the
check is already inside for-next, will be 

if (... && locked) {
	io_submit_flush_completions();
	if (poll_compl_nr)
		io_poll_flush_completions();
}

>  			io_submit_flush_completions(ctx);
> +			io_poll_flush_completions(ctx, &locked);
> +		}
>  
>  		spin_lock_irq(&tctx->task_lock);
>  		node = tctx->task_list.first;
> @@ -5134,6 +5144,49 @@ static inline bool io_poll_complete(struct io_kiocb *req, __poll_t mask)
>  static bool __io_poll_remove_one(struct io_kiocb *req,
>  				 struct io_poll_iocb *poll, bool do_cancel);
>  
> +static void io_poll_flush_completions(struct io_ring_ctx *ctx, bool *locked)
> +	__must_hold(&ctx->uring_lock)
> +{
> +	struct io_submit_state *state = &ctx->submit_state;
> +	struct io_kiocb *req, *nxt;
> +	int i, nr = state->poll_compl_nr;
> +	bool done, skip_done = true;
> +
> +	spin_lock(&ctx->completion_lock);
> +	for (i = 0; i < nr; i++) {
> +		req = state->poll_compl_reqs[i];
> +		done = __io_poll_complete(req, req->result);

I believe we first need to fix all the poll problems and lay out something more intuitive
than the current implementation, or it'd be pure hell to do afterwards.

Can be a nice addition, curious about numbers as well.


-- 
Pavel Begunkov
