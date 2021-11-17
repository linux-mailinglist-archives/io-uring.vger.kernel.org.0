Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C68F34550D9
	for <lists+io-uring@lfdr.de>; Wed, 17 Nov 2021 23:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241428AbhKQW6V (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Nov 2021 17:58:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233251AbhKQW6V (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Nov 2021 17:58:21 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EDF2C061570
        for <io-uring@vger.kernel.org>; Wed, 17 Nov 2021 14:55:22 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id n29so7618517wra.11
        for <io-uring@vger.kernel.org>; Wed, 17 Nov 2021 14:55:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=imaluUGYqBFxmIYBdahlon6QiZE34vS91diFmgriuqY=;
        b=PrPSG/A2KOMS4AYr4Oe76afrSW3AwC933lDUniOR1/NoTzo4g3hdKJ43nQKdwQsXRC
         cRmbb2pl51rFq587GV/fWWulRQumuPmUcx4e2md4R+ulZ9wmsSYlegQEzZiaJ20jp2EY
         M3Ri2IB0Bg/B7hXfxr+eQpEypBzK4yxFsdLUB8qUgQNWM31Taei0FBIFOcADLysUnPHo
         ngd/M40tMC7WaF28mPt1ZHY3jFK8/9VRYUvM6DRblIFZEMsxCvDFlBdPOgn/WdFLLxbn
         oUNTnXmBgg/n6ojsUvMHtaZUUI/zbNNa85WEp+nr2B1I6wCwv8r23ySS+gd8mtDLQt1o
         X7EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=imaluUGYqBFxmIYBdahlon6QiZE34vS91diFmgriuqY=;
        b=R9HT8eKpKxD70pmuNA+cwRLqzngdAMHiRLKafa16V8JdCfEmgjMT3kHMTRrXtQwQZu
         nyIDR5JgzoWHVoFwyF/cx5lFhjOU2vAwLVn33pADa55eWt3IE3TxrTWrP+wiqESAvevf
         CrJT7MLuQOqSGB1NhOF3rYcIWG0LQfq+sYuflYXnjyQmgTqMe86N9Xic7sjxKjrZ2DEK
         9bhEvbox5XeX9A2F9++2cXfF6ME2ywubBTXkCqMNs6lqYNN2LuslE5/MFRbT879eUhop
         WEIJeV5q91Y3bqJiEPhpX46eb9ah/grgjauzdZ5D38HWjgOwe88YiM+cekS9UY2yeWE1
         AZEQ==
X-Gm-Message-State: AOAM531YrinV4ZctxcFIwTf83jq2GPGWTnuB3B4wJXx2hbL8u+G06LKF
        70QsBXXhFv8ZYBLFJkvqCR4=
X-Google-Smtp-Source: ABdhPJxStS9RqhvccBvxi3fitDlQzRgXASNjdoQ363GIrQKxtRZcDtxRoRvVnJL0bVI5oXx0AfSGPg==
X-Received: by 2002:a5d:6244:: with SMTP id m4mr24722135wrv.186.1637189720526;
        Wed, 17 Nov 2021 14:55:20 -0800 (PST)
Received: from [192.168.8.198] ([148.252.133.228])
        by smtp.gmail.com with ESMTPSA id 10sm1603065wrb.75.2021.11.17.14.55.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Nov 2021 14:55:20 -0800 (PST)
Message-ID: <743d74dd-84c6-8a74-d7fb-780634cd59f7@gmail.com>
Date:   Wed, 17 Nov 2021 22:55:22 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 6/6] io_uring: batch completion in prior_task_list
Content-Language: en-US
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211029122237.164312-1-haoxu@linux.alibaba.com>
 <20211029122237.164312-7-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20211029122237.164312-7-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/29/21 13:22, Hao Xu wrote:
> In previous patches, we have already gathered some tw with
> io_req_task_complete() as callback in prior_task_list, let's complete
> them in batch regardless uring lock. For instance, we are doing simple
> direct read, most task work will be io_req_task_complete(), with this
> patch we don't need to hold uring lock there for long time.
> 
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
>   fs/io_uring.c | 52 ++++++++++++++++++++++++++++++++++++++++++---------
>   1 file changed, 43 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 694195c086f3..565cd0b34f18 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2166,6 +2166,37 @@ static inline unsigned int io_put_rw_kbuf(struct io_kiocb *req)
>   	return io_put_kbuf(req, req->kbuf);
>   }
>   
> +static void handle_prior_tw_list(struct io_wq_work_node *node)
> +{
> +	struct io_ring_ctx *ctx = NULL;
> +
> +	do {
> +		struct io_wq_work_node *next = node->next;
> +		struct io_kiocb *req = container_of(node, struct io_kiocb,
> +						    io_task_work.node);
> +		if (req->ctx != ctx) {
> +			if (ctx) {
> +				io_commit_cqring(ctx);
> +				spin_unlock(&ctx->completion_lock);
> +				io_cqring_ev_posted(ctx);
> +				percpu_ref_put(&ctx->refs);
> +			}
> +			ctx = req->ctx;
> +			percpu_ref_get(&ctx->refs);
> +			spin_lock(&ctx->completion_lock);
> +		}
> +		__io_req_complete_post(req, req->result, io_put_rw_kbuf(req));
> +		node = next;
> +	} while (node);
> +
> +	if (ctx) {
> +		io_commit_cqring(ctx);
> +		spin_unlock(&ctx->completion_lock);
> +		io_cqring_ev_posted(ctx);
> +		percpu_ref_put(&ctx->refs);
> +	}
> +}
> +
>   static void handle_tw_list(struct io_wq_work_node *node, struct io_ring_ctx **ctx, bool *locked)
>   {
>   	do {
> @@ -2193,25 +2224,28 @@ static void tctx_task_work(struct callback_head *cb)
>   						  task_work);
>   
>   	while (1) {
> -		struct io_wq_work_node *node;
> -		struct io_wq_work_list *merged_list;
> +		struct io_wq_work_node *node1, *node2;
>   
> -		if (!tctx->prior_task_list.first &&
> -		    !tctx->task_list.first && locked)
> +		if (!tctx->task_list.first &&
> +		    !tctx->prior_task_list.first && locked)
>   			io_submit_flush_completions(ctx);
>   
>   		spin_lock_irq(&tctx->task_lock);
> -		merged_list = wq_list_merge(&tctx->prior_task_list, &tctx->task_list);
> -		node = merged_list->first;
> +		node1 = tctx->prior_task_list.first;
> +		node2 = tctx->task_list.first;
>   		INIT_WQ_LIST(&tctx->task_list);
>   		INIT_WQ_LIST(&tctx->prior_task_list);
> -		if (!node)
> +		if (!node2 && !node1)
>   			tctx->task_running = false;
>   		spin_unlock_irq(&tctx->task_lock);
> -		if (!node)
> +		if (!node2 && !node1)
>   			break;
>   
> -		handle_tw_list(node, &ctx, &locked);
> +		if (node1)
> +			handle_prior_tw_list(node1);

IIUC, it moves all IRQ rw completions to this new path even when we already
have the lock. One concern is that io_submit_flush_completions() is better
optimised. Should probably be visible for one threaded apps and a bunch of
other cases.

How about a combined scheme? if we can grab the lock, go through the old
path, otherwise handle_prior_tw_list(). The rest looks good, will formally
review once we deal with this one.

> +
> +		if (node2)
> +			handle_tw_list(node2, &ctx, &locked);
>   		cond_resched();
>   	}
>   
> 

-- 
Pavel Begunkov
