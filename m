Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5B0D675831
	for <lists+io-uring@lfdr.de>; Fri, 20 Jan 2023 16:10:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbjATPKq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Jan 2023 10:10:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbjATPKp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Jan 2023 10:10:45 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79A6D44BA;
        Fri, 20 Jan 2023 07:10:44 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id hw16so14648095ejc.10;
        Fri, 20 Jan 2023 07:10:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=itlZq4jszddGqsEVp43yTFiJ5AKOmLAYbdl8HkGi1kU=;
        b=aSIyqU386LRvXIn00fDGhBsX0dpl2n8IJ64ql3qg12E9EQrc5thChHh8dhOz/qvxo0
         dUZ17UrucEvidIS4EoWPgqEBZwJ7de+hOa/XkiXRtjRQLvYDh8kB/VUGljukTYA7UqWl
         aGNLCd4pZz9x+dUdbvsriuIX16hg0y+Iqx+38rZVgqTIagHMivwLZ6k0v6n+tstgdZQA
         I/1hjPO9uzMouOpKoVyC84P38z7QBLrvnMCl4tVG954x8Shasg9NcYcVL+COw4NNHBu4
         HHYVMsLp7aqKWM0y3VAdAKj2XAhSAEK8t8A4erG1oVKByIH+ocyEo45N8I1yrTaCmka9
         /SNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=itlZq4jszddGqsEVp43yTFiJ5AKOmLAYbdl8HkGi1kU=;
        b=PgoMP3rzf3y+uWwdTNRsnvMcU5AxQbO5NJbusORn4rDrQdlapOz7ylx4VPJLghV9G5
         3KTJGPtpMZRCCb69uMyY0qlhSByEIg5fnKiObJMsggS7POLy5EmeIZkhLPd3RH2GNZZo
         sdqoPmdi/c0OeRhv5Sr6DUsiwJq1Gp9wzyo62CpoUv/8hmtl66H4Lj45+QDGQqoJ2CkA
         oRuBjAkIwfJsYyzxvKvFQ+DV+AGOZZu5jrpRCh7rFK47F4VF95qJ13eGU0yAXxlQgoe+
         RcQ4cZZ6DTuBUWb434eKusxVwQ6padAQqbaZNaeslzrDv7Pc4B8fzfRP/9WACV/jv+4u
         5DRQ==
X-Gm-Message-State: AFqh2kpLeP4Q6mXhw8dWHGoNvMoP0dG4Ov53xPugWrDmbPtdTcIS0KJq
        kQm0JTaT1icESKTtrsUl6R2yiONQAfk=
X-Google-Smtp-Source: AMrXdXvEdDkMQGjjQS/PHPoHvjbY1m+JI/obAfWBPPxnSHmBbYlPuapUEiYKyG3W9Z/tCDmZy9k8Cw==
X-Received: by 2002:a17:906:1307:b0:803:4549:300b with SMTP id w7-20020a170906130700b008034549300bmr17092233ejb.19.1674227442899;
        Fri, 20 Jan 2023 07:10:42 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:310::26ef? ([2620:10d:c092:600::2:c4f8])
        by smtp.gmail.com with ESMTPSA id vw22-20020a170907059600b0084d43def70esm6445267ejb.25.2023.01.20.07.10.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Jan 2023 07:10:42 -0800 (PST)
Message-ID: <a0f75aa2-34dc-e3a8-c9fe-11f88412ef93@gmail.com>
Date:   Fri, 20 Jan 2023 15:09:51 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH] io_uring: Enable KASAN for request cache
To:     Breno Leitao <leitao@debian.org>, axboe@kernel.dk,
        io-uring@vger.kernel.org
Cc:     kasan-dev@googlegroups.com, leit@fb.com,
        linux-kernel@vger.kernel.org
References: <20230118155630.2762921-1-leitao@debian.org>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20230118155630.2762921-1-leitao@debian.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/18/23 15:56, Breno Leitao wrote:
> Every io_uring request is represented by struct io_kiocb, which is
> cached locally by io_uring (not SLAB/SLUB) in the list called
> submit_state.freelist. This patch simply enabled KASAN for this free
> list.
> 
> This list is initially created by KMEM_CACHE, but later, managed by
> io_uring. This patch basically poisons the objects that are not used
> (i.e., they are the free list), and unpoisons it when the object is
> allocated/removed from the list.
> 
> Touching these poisoned objects while in the freelist will cause a KASAN
> warning.

Doesn't apply cleanly to for-6.3/io_uring, but otherwise looks good

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

  
> Suggested-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>   io_uring/io_uring.c |  3 ++-
>   io_uring/io_uring.h | 11 ++++++++---
>   2 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 2ac1cd8d23ea..8cc0f12034d1 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -151,7 +151,7 @@ static void io_move_task_work_from_local(struct io_ring_ctx *ctx);
>   static void __io_submit_flush_completions(struct io_ring_ctx *ctx);
>   static __cold void io_fallback_tw(struct io_uring_task *tctx);
>   
> -static struct kmem_cache *req_cachep;
> +struct kmem_cache *req_cachep;
>   
>   struct sock *io_uring_get_socket(struct file *file)
>   {
> @@ -230,6 +230,7 @@ static inline void req_fail_link_node(struct io_kiocb *req, int res)
>   static inline void io_req_add_to_cache(struct io_kiocb *req, struct io_ring_ctx *ctx)
>   {
>   	wq_stack_add_head(&req->comp_list, &ctx->submit_state.free_list);
> +	kasan_poison_object_data(req_cachep, req);
>   }
>   
>   static __cold void io_ring_ctx_ref_free(struct percpu_ref *ref)
> diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
> index ab4b2a1c3b7e..0ccf62a19b65 100644
> --- a/io_uring/io_uring.h
> +++ b/io_uring/io_uring.h
> @@ -3,6 +3,7 @@
>   
>   #include <linux/errno.h>
>   #include <linux/lockdep.h>
> +#include <linux/kasan.h>
>   #include <linux/io_uring_types.h>
>   #include <uapi/linux/eventpoll.h>
>   #include "io-wq.h"
> @@ -379,12 +380,16 @@ static inline bool io_alloc_req_refill(struct io_ring_ctx *ctx)
>   	return true;
>   }
>   
> +extern struct kmem_cache *req_cachep;
> +
>   static inline struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx)
>   {
> -	struct io_wq_work_node *node;
> +	struct io_kiocb *req;
>   
> -	node = wq_stack_extract(&ctx->submit_state.free_list);
> -	return container_of(node, struct io_kiocb, comp_list);
> +	req = container_of(ctx->submit_state.free_list.next, struct io_kiocb, comp_list);
> +	kasan_unpoison_object_data(req_cachep, req);
> +	wq_stack_extract(&ctx->submit_state.free_list);
> +	return req;
>   }
>   
>   static inline bool io_allowed_run_tw(struct io_ring_ctx *ctx)

-- 
Pavel Begunkov
