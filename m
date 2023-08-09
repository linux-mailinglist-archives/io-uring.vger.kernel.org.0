Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48AEE77634E
	for <lists+io-uring@lfdr.de>; Wed,  9 Aug 2023 17:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231754AbjHIPGi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Aug 2023 11:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbjHIPGh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Aug 2023 11:06:37 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A361A91
        for <io-uring@vger.kernel.org>; Wed,  9 Aug 2023 08:06:36 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-9936b3d0286so1026033366b.0
        for <io-uring@vger.kernel.org>; Wed, 09 Aug 2023 08:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691593595; x=1692198395;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QPp5/Mw5k8KhERZHTtBT/Wv5Cg7tHkjo4zClymTuFXY=;
        b=dqeKuGOybTiQIOwlBhJ5khjOO8d2WPEt39VANBqUBUaXEcgbXbdhwpZynBCxeVzpwP
         jKgsZjs0JOyb40umijhBy1eCR130lSdaI4z4kwTXVb4CSoseAYH3cp7u+PRBRZMvLXy4
         ySr+chCkzynEqGnaicLzJPpXNAVgHBLTjMIswNULanFqE5j8lo7YRqX6pnjpLSZE6CGM
         EL7YLJioHzqNKWRhDrLefGExcYob+m4xCmoLio1WyRqnwrDpjlxGGd4V5SRrVsuCJWfI
         igA0mOcpDlLuEmAqDIJQCUMhIA/w+YyG+ZeEYvZjd7oW08YOzTnZjJEnpLGprOKblr1S
         HomA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691593595; x=1692198395;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QPp5/Mw5k8KhERZHTtBT/Wv5Cg7tHkjo4zClymTuFXY=;
        b=kUPR01Gqxm7JAK6aFIinw8piQiZkxa44rFZ6LlnhsvyItCeXxmoWcKODLkFNeY29Zq
         /8WSNu63Ry6x88/tohhRISCUBc2yW2P3F6wbZgTTNlgBR7XFZUivMWrhFjkiOGlWXRhG
         yxFNIw5suIxP/6niEd53jGq3hR8MZzhRK1sJit9noFULL06Gp1Rh0RDob2Cdc47Oboqk
         CmICD6qmeFdqQfVBHWr8J7NybU417IVlPM6ndhtB5XrQoqPLwqvi+60A2mpc3yxapeDh
         kDOXwFJSO0ERunDrPvFYyJbVMYAgXHkine/3wi/8RWTA5jIVmS0IGpFOMVz5AtOABWET
         43yA==
X-Gm-Message-State: AOJu0YzCizliIQOBWYqeGK/SZLA0EGTvxZbFvyLjQeZDtP4myo9O1BQc
        dlibWRo6EuBmC3cJg7e3A6cjmEzpApg=
X-Google-Smtp-Source: AGHT+IGiEl4oEkapCtN7Dcnj/skCZd+LfcXJBh7mmI+X3vYXwShVCQuFuT4jSDKr4gn5i3BBxmldXA==
X-Received: by 2002:a17:907:784f:b0:993:d53b:9805 with SMTP id lb15-20020a170907784f00b00993d53b9805mr2137509ejc.11.1691593594726;
        Wed, 09 Aug 2023 08:06:34 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::26ef? ([2620:10d:c092:600::2:c27f])
        by smtp.gmail.com with ESMTPSA id v17-20020a170906489100b0099297c99314sm8108163ejq.113.2023.08.09.08.06.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Aug 2023 08:06:34 -0700 (PDT)
Message-ID: <9fd8e0be-2f9d-eaae-d0bd-d0c7b6521e05@gmail.com>
Date:   Wed, 9 Aug 2023 16:05:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] io_uring/rsrc: keep one global dummy_ubuf
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <cover.1691546329.git.asml.silence@gmail.com>
 <95c9dea5180d066dc35a94d39f4ce5a3ecdfbf77.1691546329.git.asml.silence@gmail.com>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <95c9dea5180d066dc35a94d39f4ce5a3ecdfbf77.1691546329.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/9/23 13:25, Pavel Begunkov wrote:
> We set empty registered buffers to dummy_ubuf as an optimisation.
> Currently, we allocate the dummy entry for each ring, whenever we can
> simply have one global instance.

And only now it started complaining about const-ness, I'll
resend it.


> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   io_uring/io_uring.c |  9 ---------
>   io_uring/rsrc.c     | 14 ++++++++++----
>   2 files changed, 10 insertions(+), 13 deletions(-)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index fb70ae436db6..3c97401240c2 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -307,13 +307,6 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
>   		goto err;
>   	if (io_alloc_hash_table(&ctx->cancel_table_locked, hash_bits))
>   		goto err;
> -
> -	ctx->dummy_ubuf = kzalloc(sizeof(*ctx->dummy_ubuf), GFP_KERNEL);
> -	if (!ctx->dummy_ubuf)
> -		goto err;
> -	/* set invalid range, so io_import_fixed() fails meeting it */
> -	ctx->dummy_ubuf->ubuf = -1UL;
> -
>   	if (percpu_ref_init(&ctx->refs, io_ring_ctx_ref_free,
>   			    0, GFP_KERNEL))
>   		goto err;
> @@ -352,7 +345,6 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
>   	INIT_WQ_LIST(&ctx->submit_state.compl_reqs);
>   	return ctx;
>   err:
> -	kfree(ctx->dummy_ubuf);
>   	kfree(ctx->cancel_table.hbs);
>   	kfree(ctx->cancel_table_locked.hbs);
>   	kfree(ctx->io_bl);
> @@ -2905,7 +2897,6 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
>   		io_wq_put_hash(ctx->hash_map);
>   	kfree(ctx->cancel_table.hbs);
>   	kfree(ctx->cancel_table_locked.hbs);
> -	kfree(ctx->dummy_ubuf);
>   	kfree(ctx->io_bl);
>   	xa_destroy(&ctx->io_bl_xa);
>   	kfree(ctx);
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index 5e8fdd9b8ca6..92e2471283ba 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -33,6 +33,12 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
>   #define IORING_MAX_FIXED_FILES	(1U << 20)
>   #define IORING_MAX_REG_BUFFERS	(1U << 14)
>   
> +static const struct io_mapped_ubuf dummy_ubuf = {
> +	/* set invalid range, so io_import_fixed() fails meeting it */
> +	.ubuf = -1UL,
> +	.ubuf_end = 0,
> +};
> +
>   int __io_account_mem(struct user_struct *user, unsigned long nr_pages)
>   {
>   	unsigned long page_limit, cur_pages, new_pages;
> @@ -132,7 +138,7 @@ static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ubuf **slo
>   	struct io_mapped_ubuf *imu = *slot;
>   	unsigned int i;
>   
> -	if (imu != ctx->dummy_ubuf) {
> +	if (imu != &dummy_ubuf) {
>   		for (i = 0; i < imu->nr_bvecs; i++)
>   			unpin_user_page(imu->bvec[i].bv_page);
>   		if (imu->acct_pages)
> @@ -459,14 +465,14 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
>   			break;
>   
>   		i = array_index_nospec(up->offset + done, ctx->nr_user_bufs);
> -		if (ctx->user_bufs[i] != ctx->dummy_ubuf) {
> +		if (ctx->user_bufs[i] != &dummy_ubuf) {
>   			err = io_queue_rsrc_removal(ctx->buf_data, i,
>   						    ctx->user_bufs[i]);
>   			if (unlikely(err)) {
>   				io_buffer_unmap(ctx, &imu);
>   				break;
>   			}
> -			ctx->user_bufs[i] = ctx->dummy_ubuf;
> +			ctx->user_bufs[i] = &dummy_ubuf;
>   		}
>   
>   		ctx->user_bufs[i] = imu;
> @@ -1077,7 +1083,7 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
>   	int ret, nr_pages, i;
>   	struct folio *folio = NULL;
>   
> -	*pimu = ctx->dummy_ubuf;
> +	*pimu = &dummy_ubuf;
>   	if (!iov->iov_base)
>   		return 0;
>   

-- 
Pavel Begunkov
