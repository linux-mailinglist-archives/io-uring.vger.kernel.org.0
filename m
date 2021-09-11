Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF2C2407A5A
	for <lists+io-uring@lfdr.de>; Sat, 11 Sep 2021 22:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233603AbhIKUNv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Sep 2021 16:13:51 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:34930 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233387AbhIKUNv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Sep 2021 16:13:51 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R991e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0Uo.swAm_1631391155;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Uo.swAm_1631391155)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 12 Sep 2021 04:12:36 +0800
Subject: Re: [PATCH 3/3] io_uring: don't spinlock when not posting CQEs
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1631367587.git.asml.silence@gmail.com>
 <3a5f0436099b84f71fdc8c9bd9f21842581feaf9.1631367587.git.asml.silence@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <1cc2816e-bf18-fbb9-b5ed-e8786babc4fc@linux.alibaba.com>
Date:   Sun, 12 Sep 2021 04:12:35 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <3a5f0436099b84f71fdc8c9bd9f21842581feaf9.1631367587.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/9/11 下午9:52, Pavel Begunkov 写道:
> When no of queued for the batch completion requests need to post an CQE,
> see IOSQE_CQE_SKIP_SUCCESS, avoid grabbing ->completion_lock and other
> commit/post.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   fs/io_uring.c | 24 +++++++++++++++---------
>   1 file changed, 15 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 172c857e8b3f..8983a5a6851a 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -317,6 +317,7 @@ struct io_submit_state {
>   
>   	bool			plug_started;
>   	bool			need_plug;
> +	bool			flush_cqes;
>   
>   	/*
>   	 * Batch completion logic
> @@ -1858,6 +1859,8 @@ static void io_req_complete_state(struct io_kiocb *req, long res,
>   	req->result = res;
>   	req->compl.cflags = cflags;
>   	req->flags |= REQ_F_COMPLETE_INLINE;
> +	if (!(req->flags & IOSQE_CQE_SKIP_SUCCESS))
Haven't look into this patchset deeply, but this looks
like should be REQ_F_CQE_SKIP ?
> +		req->ctx->submit_state.flush_cqes = true;
>   }
>   
>   static inline void __io_req_complete(struct io_kiocb *req, unsigned issue_flags,
> @@ -2354,17 +2357,19 @@ static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
>   	int i, nr = state->compl_nr;
>   	struct req_batch rb;
>   
> -	spin_lock(&ctx->completion_lock);
> -	for (i = 0; i < nr; i++) {
> -		struct io_kiocb *req = state->compl_reqs[i];
> +	if (state->flush_cqes) {
> +		spin_lock(&ctx->completion_lock);
> +		for (i = 0; i < nr; i++) {
> +			struct io_kiocb *req = state->compl_reqs[i];
>   
> -		if (!(req->flags & REQ_F_CQE_SKIP))
> -			__io_fill_cqe(ctx, req->user_data, req->result,
> -				      req->compl.cflags);
> +			if (!(req->flags & REQ_F_CQE_SKIP))
> +				__io_fill_cqe(ctx, req->user_data, req->result,
> +					      req->compl.cflags);
> +		}
> +		io_commit_cqring(ctx);
> +		spin_unlock(&ctx->completion_lock);
> +		io_cqring_ev_posted(ctx);
>   	}
> -	io_commit_cqring(ctx);
> -	spin_unlock(&ctx->completion_lock);
> -	io_cqring_ev_posted(ctx);
>   
>   	io_init_req_batch(&rb);
>   	for (i = 0; i < nr; i++) {
> @@ -2376,6 +2381,7 @@ static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
>   
>   	io_req_free_batch_finish(ctx, &rb);
>   	state->compl_nr = 0;
> +	state->flush_cqes = false;
>   }
>   
>   /*
> 

