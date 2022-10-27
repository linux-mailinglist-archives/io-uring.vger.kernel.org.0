Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAAFD60FC22
	for <lists+io-uring@lfdr.de>; Thu, 27 Oct 2022 17:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236158AbiJ0PiO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Oct 2022 11:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235285AbiJ0PiO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Oct 2022 11:38:14 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 473671905E0
        for <io-uring@vger.kernel.org>; Thu, 27 Oct 2022 08:38:13 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id g13so1246686ile.0
        for <io-uring@vger.kernel.org>; Thu, 27 Oct 2022 08:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9Z+9jrYt4vkZNXYivPTFJLAa2nfhWWVxXmsEnzTdAHo=;
        b=cBuzNH63bCha8qRPTSHjj3tIN0uKCSv/6bCSZ0iPQPjv3G3LT645WYdU8MvnNqTVvp
         VAtXntXpEM5ujXboh05p2gdFzHANB9KDQuTZnhzET0Av75+v5UjdKKSIt4leNTwEFMZg
         Y+54pMXhePr+WlZMJH67kq7sXdnktX44e2Q38Pz85B3hEs1vuixjLvpNwSsH8ez1FWF2
         8yYlT1mr47bhiiC1UIwPELEo66DGw7CMfGoTviSNYHliVVrvSjgPBbg4VlI4Xch14mTv
         +YAekTwEK5+0AGOSW6Djbt9UQWq6nA4IwOywgZGTq3iDW1IzqGSj4Tcg06gjwToY2o1x
         k3FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9Z+9jrYt4vkZNXYivPTFJLAa2nfhWWVxXmsEnzTdAHo=;
        b=ceaAWR3VanE7ADwHOOVGNz2MmDN0Y9X1NbU4Ogd/HXmaN4Yx/UhywGNHYhZvVO2V9c
         eC74B8Rz72DkZfkd3KH2SeTuNqNmHBzbjlHsHsi5uHD0X3+jsIesctPxL5uEH7nniX2k
         4+UJSQsmUPM3VvFeVGKJzsBMwKuK2yCVlwQMhO2e1q4qDApL8bvdaFODKT9arKvgIsMS
         kwL0Vv/rl0QmhiIulb5NTlWbdad8YsHps+AAtG1HLil/aI3HMdFxuyqVLrqWbuBUfPxf
         gJQoN6beFunm5+JXr03nkG0ux5eh4poYEGXrkk+Hl9aXC/WezwlYC5WTqYUMLkcX+pmH
         vgEg==
X-Gm-Message-State: ACrzQf1jKSiEpbDESjAWXWDv9f1jIvJUMACANwLn41223XO5AKWWijVK
        /eusmKr+PmlPEk+YXyTIoYi8mw==
X-Google-Smtp-Source: AMsMyM6vBbyJXVqWMCyR5w+H6YC8pE8QBY48KI0gnb+Gp3x0tqNAeHxYru57kp+kYK5y1mK28pt0Ug==
X-Received: by 2002:a92:ca0c:0:b0:2f9:204:7a0d with SMTP id j12-20020a92ca0c000000b002f902047a0dmr31868481ils.194.1666885092585;
        Thu, 27 Oct 2022 08:38:12 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id w10-20020a92db4a000000b002ff54e19cb0sm653428ilq.36.2022.10.27.08.38.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Oct 2022 08:38:12 -0700 (PDT)
Message-ID: <bc3a9ac6-9e31-6a8f-1511-95eef4209da3@kernel.dk>
Date:   Thu, 27 Oct 2022 09:38:10 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH 2/2] io_uring: unlock if __io_run_local_work locked inside
To:     Dylan Yudaken <dylany@meta.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com
References: <20221027144429.3971400-1-dylany@meta.com>
 <20221027144429.3971400-3-dylany@meta.com>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20221027144429.3971400-3-dylany@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/27/22 8:44 AM, Dylan Yudaken wrote:
> It is possible for tw to lock the ring, and this was not propogated out to
> io_run_local_work. This can cause an unlock to be missed.
> 
> Instead pass a pointer to locked into __io_run_local_work.
> 
> Fixes: 8ac5d85a89b4 ("io_uring: add local task_work run helper that is entered locked")
> Signed-off-by: Dylan Yudaken <dylany@meta.com>
> ---
>  io_uring/io_uring.c |  8 ++++----
>  io_uring/io_uring.h | 12 ++++++++++--
>  2 files changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 8a0ce7379e89..ac8c488e3077 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -1173,7 +1173,7 @@ static void __cold io_move_task_work_from_local(struct io_ring_ctx *ctx)
>  	}
>  }
>  
> -int __io_run_local_work(struct io_ring_ctx *ctx, bool locked)
> +int __io_run_local_work(struct io_ring_ctx *ctx, bool *locked)
>  {
>  	struct llist_node *node;
>  	struct llist_node fake;
> @@ -1192,7 +1192,7 @@ int __io_run_local_work(struct io_ring_ctx *ctx, bool locked)
>  		struct io_kiocb *req = container_of(node, struct io_kiocb,
>  						    io_task_work.node);
>  		prefetch(container_of(next, struct io_kiocb, io_task_work.node));
> -		req->io_task_work.func(req, &locked);
> +		req->io_task_work.func(req, locked);
>  		ret++;
>  		node = next;
>  	}
> @@ -1208,7 +1208,7 @@ int __io_run_local_work(struct io_ring_ctx *ctx, bool locked)
>  		goto again;
>  	}
>  
> -	if (locked)
> +	if (*locked)
>  		io_submit_flush_completions(ctx);
>  	trace_io_uring_local_work_run(ctx, ret, loops);
>  	return ret;
> @@ -1225,7 +1225,7 @@ int io_run_local_work(struct io_ring_ctx *ctx)
>  
>  	__set_current_state(TASK_RUNNING);
>  	locked = mutex_trylock(&ctx->uring_lock);
> -	ret = __io_run_local_work(ctx, locked);
> +	ret = __io_run_local_work(ctx, &locked);
>  	if (locked)
>  		mutex_unlock(&ctx->uring_lock);
>  
> diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
> index ef77d2aa3172..331ec2869212 100644
> --- a/io_uring/io_uring.h
> +++ b/io_uring/io_uring.h
> @@ -27,7 +27,7 @@ enum {
>  struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx *ctx, bool overflow);
>  bool io_req_cqe_overflow(struct io_kiocb *req);
>  int io_run_task_work_sig(struct io_ring_ctx *ctx);
> -int __io_run_local_work(struct io_ring_ctx *ctx, bool locked);
> +int __io_run_local_work(struct io_ring_ctx *ctx, bool *locked);
>  int io_run_local_work(struct io_ring_ctx *ctx);
>  void io_req_complete_failed(struct io_kiocb *req, s32 res);
>  void __io_req_complete(struct io_kiocb *req, unsigned issue_flags);
> @@ -277,9 +277,17 @@ static inline int io_run_task_work_ctx(struct io_ring_ctx *ctx)
>  
>  static inline int io_run_local_work_locked(struct io_ring_ctx *ctx)
>  {
> +	bool locked;
> +	int ret;
> +
>  	if (llist_empty(&ctx->work_llist))
>  		return 0;
> -	return __io_run_local_work(ctx, true);
> +
> +	locked = true;
> +	ret = __io_run_local_work(ctx, &locked);
> +	if (WARN_ON(!locked))
> +		mutex_lock(&ctx->uring_lock);
> +	return ret;
>  }

If you think warning on !locked is a good idea, it should be a
WARN_ON_ONCE(). Or is this leftover debugging?

-- 
Jens Axboe


