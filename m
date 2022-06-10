Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69637546376
	for <lists+io-uring@lfdr.de>; Fri, 10 Jun 2022 12:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245365AbiFJKWq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Jun 2022 06:22:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238600AbiFJKWo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Jun 2022 06:22:44 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE69D4161E
        for <io-uring@vger.kernel.org>; Fri, 10 Jun 2022 03:22:43 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id q15so10534462wmj.2
        for <io-uring@vger.kernel.org>; Fri, 10 Jun 2022 03:22:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=eUHby0KhhIkYOKbvQ30d0foiDUkpupkYoXC97C66C/M=;
        b=KOd/LjCenOJWxR0eW+p2IBGkvioEInVjKt+amKHMXn9dHVv4GQp/zpJbg7nh1zwHgU
         c0s2SVZXZjWF1h0vL7vuoFFIy37BUZsTvT0yLjdOtiPD8WbNCpeBs9mtRBuNQp+5qfdn
         vm55VMB2v4eozCcN/UK9Ub6qFT9LI99mkTScsdBMvbmn+Nyo9RElkERqWUkzPivoT8V3
         dWBGWRhUb0hxgGqzZJTj8aRD7D6i4vcUcdw1rsxmy0Qz/A83Yi+J98dN/XTD2B1IUo2r
         NthGbGom5BKQLnfvh85II7VDrGa+KynbyOMLOuolSomECD9OkK5UOtKjXVsWwYSaVnCi
         ioCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=eUHby0KhhIkYOKbvQ30d0foiDUkpupkYoXC97C66C/M=;
        b=OYWVgcW27xMoJ4IVjEuTvFUvwj1imtjPe0AU3zGjnR0UzT2IU/hDzgFlKaonvA/8iE
         RCPBee3iZH2Fm8nP9iPj4m+jAlgiOO94yI1Jdm/t4HhRvoOZmATAFrDhLBEAAMpXqs3B
         rQ2uCo+cyb09kORMtStJkhIjGROEoNL5FyYrx4H1C702AyR/JcCObhp7/x8nThtAPm5v
         JpcibNybv7RfvezXTzkHti31Xm4rWMZsRXcchVGGu211HxldWXInQeNqaeXgMnO1h8i8
         MjCknCSbtmXRQlBShEHZOMWaTn3q9Xt23wc5K50Y7a63Bvy8sRRacH9TwMjnISZpdQQG
         XA1A==
X-Gm-Message-State: AOAM531+rqc+xFHZJaTn2/BHhYWVmS9SWFMrKSmwwokxlW/lT0vRd0yN
        pW5NW3CI3baZSes9d72UHqM=
X-Google-Smtp-Source: ABdhPJypU4MK9a8u2WZelPlW6dYdtmgIf1Inq/+37cKYfa1YcFPtWnEaOFa1ZGmawIdrf3FCviHhug==
X-Received: by 2002:a1c:4d05:0:b0:39c:5932:d9f1 with SMTP id o5-20020a1c4d05000000b0039c5932d9f1mr7972177wmh.52.1654856562140;
        Fri, 10 Jun 2022 03:22:42 -0700 (PDT)
Received: from [192.168.8.198] (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id h9-20020a5d4309000000b002102af52a2csm33934618wrq.9.2022.06.10.03.22.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jun 2022 03:22:41 -0700 (PDT)
Message-ID: <37d73555-197b-29e1-d2cc-b7313501a394@gmail.com>
Date:   Fri, 10 Jun 2022 11:21:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v3] io_uring: switch cancel_hash to use per entry spinlock
Content-Language: en-US
To:     Hao Xu <hao.xu@linux.dev>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <20220608111259.659536-1-hao.xu@linux.dev>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20220608111259.659536-1-hao.xu@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/8/22 12:12, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> Add a new io_hash_bucket structure so that each bucket in cancel_hash
> has separate spinlock. Use per entry lock for cancel_hash, this removes
> some completion lock invocation and remove contension between different
> cancel_hash entries.
> 
> Signed-off-by: Hao Xu <howeyxu@tencent.com>
> ---
> 
> v1->v2:
>   - Add per entry lock for poll/apoll task work code which was missed
>     in v1
>   - add an member in io_kiocb to track req's indice in cancel_hash
> 
> v2->v3:
>   - make struct io_hash_bucket align with cacheline to avoid cacheline
>     false sharing.
>   - re-calculate hash value when deleting an entry from cancel_hash.
>     (cannot leverage struct io_poll to store the indice since it's
>      already 64 Bytes)
> 
>   io_uring/cancel.c         | 14 +++++++--
>   io_uring/cancel.h         |  6 ++++
>   io_uring/fdinfo.c         |  9 ++++--
>   io_uring/io_uring.c       |  8 +++--
>   io_uring/io_uring_types.h |  2 +-
>   io_uring/poll.c           | 64 +++++++++++++++++++++------------------
>   6 files changed, 65 insertions(+), 38 deletions(-)
> 
> diff --git a/io_uring/cancel.c b/io_uring/cancel.c
> index 83cceb52d82d..bced5d6b9294 100644
> --- a/io_uring/cancel.c
> +++ b/io_uring/cancel.c
> @@ -93,14 +93,14 @@ int io_try_cancel(struct io_kiocb *req, struct io_cancel_data *cd)
>   	if (!ret)
>   		return 0;
>   
> -	spin_lock(&ctx->completion_lock);
>   	ret = io_poll_cancel(ctx, cd);
>   	if (ret != -ENOENT)
>   		goto out;
> +	spin_lock(&ctx->completion_lock);
>   	if (!(cd->flags & IORING_ASYNC_CANCEL_FD))
>   		ret = io_timeout_cancel(ctx, cd);
> -out:
>   	spin_unlock(&ctx->completion_lock);
> +out:
>   	return ret;
>   }
>   
> @@ -192,3 +192,13 @@ int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
>   	io_req_set_res(req, ret, 0);
>   	return IOU_OK;
>   }
> +
> +inline void init_hash_table(struct io_hash_bucket *hash_table, unsigned size)

Not inline, it can break builds

> diff --git a/io_uring/cancel.h b/io_uring/cancel.h
> index 4f35d8696325..b57d6706f84d 100644
> --- a/io_uring/cancel.h
> +++ b/io_uring/cancel.h
> @@ -4,3 +4,9 @@ int io_async_cancel_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
>   int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags);
>   
>   int io_try_cancel(struct io_kiocb *req, struct io_cancel_data *cd);
> +inline void init_hash_table(struct io_hash_bucket *hash_table, unsigned size);

And this inline as well

> diff --git a/io_uring/poll.c b/io_uring/poll.c
> index 0df5eca93b16..515f1727e3c6 100644
> --- a/io_uring/poll.c
> +++ b/io_uring/poll.c
[...]
>   static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, bool poll_only,
>   				     struct io_cancel_data *cd)
> -	__must_hold(&ctx->completion_lock)
>   {
> -	struct hlist_head *list;
>   	struct io_kiocb *req;
>   
> -	list = &ctx->cancel_hash[hash_long(cd->data, ctx->cancel_hash_bits)];
> -	hlist_for_each_entry(req, list, hash_node) {
> +	u32 index = hash_long(cd->data, ctx->cancel_hash_bits);
> +	struct io_hash_bucket *hb = &ctx->cancel_hash[index];
> +
> +	spin_lock(&hb->lock);
> +	hlist_for_each_entry(req, &hb->list, hash_node) {
>   		if (cd->data != req->cqe.user_data)
>   			continue;
>   		if (poll_only && req->opcode != IORING_OP_POLL_ADD)
> @@ -569,47 +577,48 @@ static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, bool poll_only,
>   				continue;
>   			req->work.cancel_seq = cd->seq;
>   		}
> +		spin_unlock(&hb->lock);

The problem here is that after you unlock, nothing keeps the
request alive. Before it was more like

lock(completion_lock);
req = poll_find();
cancel_poll(req);
unlock(completion_lock);

and was relying on all of this happening under ->completion_lock.
Now following io_poll_disarm() and/or io_poll_cancel_req() race.
Same with io_poll_file_find().

Should be fine apart from this

-- 
Pavel Begunkov
