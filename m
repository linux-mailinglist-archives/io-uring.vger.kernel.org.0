Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19537320431
	for <lists+io-uring@lfdr.de>; Sat, 20 Feb 2021 07:33:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbhBTGco (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 20 Feb 2021 01:32:44 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:44493 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229543AbhBTGco (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 20 Feb 2021 01:32:44 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UP.qOJd_1613802714;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UP.qOJd_1613802714)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 20 Feb 2021 14:31:55 +0800
Subject: Re: [PATCH 2/3] io_uring: fix io_rsrc_ref_quiesce races
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1613767375.git.asml.silence@gmail.com>
 <1b71f4059f088b035ec72307321f051a7be2d44f.1613767375.git.asml.silence@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <e5c131a0-402d-31df-b5f9-156434bf3f29@linux.alibaba.com>
Date:   Sat, 20 Feb 2021 14:31:54 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <1b71f4059f088b035ec72307321f051a7be2d44f.1613767375.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

ÔÚ 2021/2/20 ÉÏÎç4:45, Pavel Begunkov Ð´µÀ:
> There are different types of races in io_rsrc_ref_quiesce()  between
> ->release() of percpu_refs and reinit_completion(), fix them by always
> resurrecting between iterations. BTW, clean the function up, because
> DRY.
> 
> Fixes: 0ce4a72632317 ("io_uring: don't hold uring_lock when calling io_run_task_work*")
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   fs/io_uring.c | 46 +++++++++++++---------------------------------
>   1 file changed, 13 insertions(+), 33 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 50d4dba08f82..38ed52065a29 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -7316,19 +7316,6 @@ static void io_sqe_rsrc_set_node(struct io_ring_ctx *ctx,
>   	percpu_ref_get(&rsrc_data->refs);
>   }
>   
> -static int io_sqe_rsrc_add_node(struct io_ring_ctx *ctx, struct fixed_rsrc_data *data)
> -{
> -	struct fixed_rsrc_ref_node *backup_node;
> -
> -	backup_node = alloc_fixed_rsrc_ref_node(ctx);
> -	if (!backup_node)
> -		return -ENOMEM;
> -	init_fixed_file_ref_node(ctx, backup_node);
> -	io_sqe_rsrc_set_node(ctx, data, backup_node);
> -
> -	return 0;
> -}
> -
>   static void io_sqe_rsrc_kill_node(struct io_ring_ctx *ctx, struct fixed_rsrc_data *data)
>   {
>   	struct fixed_rsrc_ref_node *ref_node = NULL;
> @@ -7347,36 +7334,29 @@ static int io_rsrc_ref_quiesce(struct fixed_rsrc_data *data,
>   {
>   	int ret;
>   
> -	io_sqe_rsrc_kill_node(ctx, data);
> -	percpu_ref_kill(&data->refs);
> -
> -	/* wait for all refs nodes to complete */
> -	flush_delayed_work(&ctx->rsrc_put_work);
>   	do {
> +		io_sqe_rsrc_kill_node(ctx, data);
> +		percpu_ref_kill(&data->refs);
> +		flush_delayed_work(&ctx->rsrc_put_work);
> +
>   		ret = wait_for_completion_interruptible(&data->done);
>   		if (!ret)
>   			break;
>   
> -		ret = io_sqe_rsrc_add_node(ctx, data);
> -		if (ret < 0)
> -			break;
> -		/*
> -		 * There is small possibility that data->done is already completed
> -		 * So reinit it here
> -		 */
> +		percpu_ref_resurrect(&data->refs);
I've thought about this, if we resurrect data->refs, then we can't
avoid parallel files unregister by percpu_refs_is_dying.
> +		io_sqe_rsrc_set_node(ctx, data, backup_node);
>   		reinit_completion(&data->done);
>   		mutex_unlock(&ctx->uring_lock);
>   		ret = io_run_task_work_sig();
>   		mutex_lock(&ctx->uring_lock);
> -		io_sqe_rsrc_kill_node(ctx, data);
> -	} while (ret >= 0);
>   
> -	if (ret < 0) {
> -		percpu_ref_resurrect(&data->refs);
> -		reinit_completion(&data->done);
> -		io_sqe_rsrc_set_node(ctx, data, backup_node);
> -		return ret;
> -	}
> +		if (ret < 0)
> +			return ret;
> +		backup_node = alloc_fixed_rsrc_ref_node(ctx);
> +		if (!backup_node)
> +			return -ENOMEM;
Should we resurrect data->refs and reinit completion before
signal or error return?
> +		init_fixed_file_ref_node(ctx, backup_node);
> +	} while (1);
>   
>   	destroy_fixed_rsrc_ref_node(backup_node);
>   	return 0;
> 

