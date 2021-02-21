Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9469E320989
	for <lists+io-uring@lfdr.de>; Sun, 21 Feb 2021 10:48:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbhBUJrK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 Feb 2021 04:47:10 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:50280 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229932AbhBUJrK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 21 Feb 2021 04:47:10 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R971e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UP5aRg-_1613900784;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UP5aRg-_1613900784)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 21 Feb 2021 17:46:24 +0800
Subject: Re: [PATCH 2/3] io_uring: fix io_rsrc_ref_quiesce races
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1613767375.git.asml.silence@gmail.com>
 <1b71f4059f088b035ec72307321f051a7be2d44f.1613767375.git.asml.silence@gmail.com>
 <e5c131a0-402d-31df-b5f9-156434bf3f29@linux.alibaba.com>
 <070f2274-187d-8ee8-e841-f44beeba4fd0@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <f8a51353-7631-1187-9ec7-407662e8ee50@linux.alibaba.com>
Date:   Sun, 21 Feb 2021 17:46:24 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <070f2274-187d-8ee8-e841-f44beeba4fd0@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/2/20 下午10:07, Pavel Begunkov 写道:
> On 20/02/2021 06:31, Hao Xu wrote:
>> 在 2021/2/20 上午4:45, Pavel Begunkov 写道:
>>> There are different types of races in io_rsrc_ref_quiesce()  between
>>> ->release() of percpu_refs and reinit_completion(), fix them by always
>>> resurrecting between iterations. BTW, clean the function up, because
>>> DRY.
>>>
>>> Fixes: 0ce4a72632317 ("io_uring: don't hold uring_lock when calling io_run_task_work*")
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> ---
>>>    fs/io_uring.c | 46 +++++++++++++---------------------------------
>>>    1 file changed, 13 insertions(+), 33 deletions(-)
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index 50d4dba08f82..38ed52065a29 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -7316,19 +7316,6 @@ static void io_sqe_rsrc_set_node(struct io_ring_ctx *ctx,
>>>        percpu_ref_get(&rsrc_data->refs);
>>>    }
>>>    -static int io_sqe_rsrc_add_node(struct io_ring_ctx *ctx, struct fixed_rsrc_data *data)
>>> -{
>>> -    struct fixed_rsrc_ref_node *backup_node;
>>> -
>>> -    backup_node = alloc_fixed_rsrc_ref_node(ctx);
>>> -    if (!backup_node)
>>> -        return -ENOMEM;
>>> -    init_fixed_file_ref_node(ctx, backup_node);
>>> -    io_sqe_rsrc_set_node(ctx, data, backup_node);
>>> -
>>> -    return 0;
>>> -}
>>> -
>>>    static void io_sqe_rsrc_kill_node(struct io_ring_ctx *ctx, struct fixed_rsrc_data *data)
>>>    {
>>>        struct fixed_rsrc_ref_node *ref_node = NULL;
>>> @@ -7347,36 +7334,29 @@ static int io_rsrc_ref_quiesce(struct fixed_rsrc_data *data,
>>>    {
>>>        int ret;
>>>    -    io_sqe_rsrc_kill_node(ctx, data);
>>> -    percpu_ref_kill(&data->refs);
>>> -
>>> -    /* wait for all refs nodes to complete */
>>> -    flush_delayed_work(&ctx->rsrc_put_work);
>>>        do {
>>> +        io_sqe_rsrc_kill_node(ctx, data);
>>> +        percpu_ref_kill(&data->refs);
>>> +        flush_delayed_work(&ctx->rsrc_put_work);
>>> +
>>>            ret = wait_for_completion_interruptible(&data->done);
>>>            if (!ret)
>>>                break;
>>>    -        ret = io_sqe_rsrc_add_node(ctx, data);
>>> -        if (ret < 0)
>>> -            break;
>>> -        /*
>>> -         * There is small possibility that data->done is already completed
>>> -         * So reinit it here
>>> -         */
>>> +        percpu_ref_resurrect(&data->refs);
>> I've thought about this, if we resurrect data->refs, then we can't
>> avoid parallel files unregister by percpu_refs_is_dying.
> 
> Right, totally forgot about it, but otherwise we race with data->done.
> Didn't test yet, but a diff below should do the trick.
I'll test the latest version soon.
> 
>>> +        if (ret < 0)
>>> +            return ret;
>>> +        backup_node = alloc_fixed_rsrc_ref_node(ctx);
>>> +        if (!backup_node)
>>> +            return -ENOMEM;
>> Should we resurrect data->refs and reinit completion before
>> signal or error return?
> 
> Not sure what exactly you mean, we should not release uring_lock with
> inconsistent state, so it's done right before unlock. And we should not
> do it before wait_for_completion_interruptible() before it would take a
> reference.
Nevermind, I misread the code.
> 
>>> +        init_fixed_file_ref_node(ctx, backup_node);
>>> +    } while (1);
>>>          destroy_fixed_rsrc_ref_node(backup_node);
>>>        return 0;
>>>
>>
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index ce5fccf00367..0af1572634de 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -236,6 +236,7 @@ struct fixed_rsrc_data {
>   	struct fixed_rsrc_ref_node	*node;
>   	struct percpu_ref		refs;
>   	struct completion		done;
> +	bool				quiesce;
>   };
>   
>   struct io_buffer {
> @@ -7335,6 +7336,7 @@ static int io_rsrc_ref_quiesce(struct fixed_rsrc_data *data,
>   	struct fixed_rsrc_ref_node *backup_node;
>   	int ret;
>   
> +	data->quiesce = true;
>   	do {
>   		backup_node = alloc_fixed_rsrc_ref_node(ctx);
>   		if (!backup_node)
> @@ -7353,16 +7355,19 @@ static int io_rsrc_ref_quiesce(struct fixed_rsrc_data *data,
>   		percpu_ref_resurrect(&data->refs);
>   		synchronize_rcu();
>   		io_sqe_rsrc_set_node(ctx, data, backup_node);
> +		backup_node = NULL;
>   		reinit_completion(&data->done);
>   		mutex_unlock(&ctx->uring_lock);
>   		ret = io_run_task_work_sig();
>   		mutex_lock(&ctx->uring_lock);
>   		if (ret < 0)
>   			return ret;
> -	} while (1);
> +	} while (ret >= 0);
>   
> -	destroy_fixed_rsrc_ref_node(backup_node);
> -	return 0;
> +	data->quiesce = false;
> +	if (backup_node)
> +		destroy_fixed_rsrc_ref_node(backup_node);
> +	return ret;
>   }
>   
>   static struct fixed_rsrc_data *alloc_fixed_rsrc_data(struct io_ring_ctx *ctx)
> @@ -7401,7 +7406,7 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
>   	 * Since we possibly drop uring lock later in this function to
>   	 * run task work.
>   	 */
> -	if (!data || percpu_ref_is_dying(&data->refs))
> +	if (!data || data->quiesce)
>   		return -ENXIO;
>   	ret = io_rsrc_ref_quiesce(data, ctx, io_ring_file_put);
>   	if (ret)
> 

