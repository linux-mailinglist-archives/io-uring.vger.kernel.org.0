Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6564F8158
	for <lists+io-uring@lfdr.de>; Thu,  7 Apr 2022 16:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232468AbiDGONq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Apr 2022 10:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiDGONp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Apr 2022 10:13:45 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D52C13E407
        for <io-uring@vger.kernel.org>; Thu,  7 Apr 2022 07:11:45 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id bi13-20020a05600c3d8d00b0038c2c33d8f3so5739852wmb.4
        for <io-uring@vger.kernel.org>; Thu, 07 Apr 2022 07:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=rovrbX02/K9puoh9qInqMkpXALb7LCmyB9B1XlnjWVA=;
        b=A0QyzS5RmjIniej025UaKuJLBXnpOgA6K6Pl+FLD7iGKyx/7G1dBS9WI06vL8NE1QU
         caFNwTh44RPnA4RTZ7uhHDbanlLMK1tPQNVUOY6R710002SKHhu4D1zCdgA1G/pMla3M
         mFvJ68HAYad2vGAXRAKxCgY8HHqfYrt7qL9mzOp1/B+8oOHTeZORts4kXgyhh4ZrEjO1
         eIW4XrDvoDcAm9ucCy7oGnglmv+hP7ctES3uMhU7HL/4jZ59s13J35KusCH1G5UFCnYA
         8eviMwtoM+3aV3ye5szXYAhJYxO/gMFpUx/RgicBMM0kNxj+sHeCTg+B7BW7zCI/4BjQ
         fPzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rovrbX02/K9puoh9qInqMkpXALb7LCmyB9B1XlnjWVA=;
        b=U3V0pqz/P47TC7+GlbhWoCo8ENVYVD17bL1TTAgBxoeCkQFPrAKYNKNCTuonLH3h13
         iFRAbEpzbGcD27/s4x/ZcH4/574GAhfYCZDa3vZuPWWfg8+PV/N/igmuxfiR75gWI6H4
         HPt+Ngxn42cnhh7tIACSXAu5yC3xwzGpMug2wbF7TUHYiG5F45RI4R/oAMA6R/I0KvN6
         mjJ6Nv6Cp9aj2wKUR6fCBN9RPuSZwgiF57YbLVMa1ehhdrhS0xr50gR55khkjdhy7/tc
         vR0/PX9J0frKU9n2H9eBBZZdyxnzCW5TJ+A0o8SANFOoxvlWzADiJ2xthat/n9S/r3MA
         egTw==
X-Gm-Message-State: AOAM531R4Y2JHI1+1iMldXehi9ybErbEneD1AvjZP3X3VgkEQm7g1cOr
        cJQ46XJAVSygZeTufmMuDF2KDdnMIbw=
X-Google-Smtp-Source: ABdhPJzVK9ZF31p2m17X0TyVrzm8n63OpBDgBbEcLiNje2HBKmF3QL6bHs/uMCABukkjB71Ox1+uHQ==
X-Received: by 2002:a7b:cb4b:0:b0:38e:9c4c:9120 with SMTP id v11-20020a7bcb4b000000b0038e9c4c9120mr596249wmj.76.1649340671208;
        Thu, 07 Apr 2022 07:11:11 -0700 (PDT)
Received: from [192.168.8.198] ([85.255.237.149])
        by smtp.gmail.com with ESMTPSA id y7-20020adfdf07000000b0020609f6b386sm13643610wrl.37.2022.04.07.07.11.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Apr 2022 07:11:10 -0700 (PDT)
Message-ID: <f6778070-1e58-c8e2-24fc-8481c4ec3e7d@gmail.com>
Date:   Thu, 7 Apr 2022 15:10:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH 1/1] io_uring: don't scm-account for non af_unix sockets
Content-Language: en-US
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <9c44ecf6e89d69130a8c4360cce2183ffc5ddd6f.1649277098.git.asml.silence@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <9c44ecf6e89d69130a8c4360cce2183ffc5ddd6f.1649277098.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/6/22 21:33, Pavel Begunkov wrote:
> io_uring deals with file reference loops by registering all fixed files
> in the SCM/GC infrastrucure. However, only a small subset of all file
> types can keep long-term references to other files and those that don't
> are not interesting for the garbage collector as they can't be in a
> reference loop. They neither can be directly recycled by GC nor affect
> loop searching.
> 
> Let's skip io_uring SCM accounting for loop-less files, i.e. all but
> af_unix sockets, quite imroving fixed file updates performance and
> greatly helpnig with memory footprint.

Just to throw some numbers, simple loop with fixed file updates
in batches of 32 showed 2-3x performance improvement
(~400K-500K updates/s -> ~1.2M).


> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   fs/io_uring.c | 51 ++++++++++++++++++++++++++++++++++++++-------------
>   1 file changed, 38 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index b4c85d85f88d..be178694e8db 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1211,6 +1211,18 @@ struct sock *io_uring_get_socket(struct file *file)
>   }
>   EXPORT_SYMBOL(io_uring_get_socket);
>   
> +#if defined(CONFIG_UNIX)
> +static inline bool io_file_need_scm(struct file *filp)
> +{
> +	return !!unix_get_socket(filp);
> +}
> +#else
> +static inline bool io_file_need_scm(struct file *filp)
> +{
> +	return 0;
> +}
> +#endif
> +
>   static inline void io_tw_lock(struct io_ring_ctx *ctx, bool *locked)
>   {
>   	if (!*locked) {
> @@ -8424,6 +8436,17 @@ static void io_free_file_tables(struct io_file_table *table)
>   
>   static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
>   {
> +	int i;
> +
> +	for (i = 0; i < ctx->nr_user_files; i++) {
> +		struct file *file = io_file_from_index(ctx, i);
> +
> +		if (!file || io_file_need_scm(file))
> +			continue;
> +		io_fixed_file_slot(&ctx->file_table, i)->file_ptr = 0;
> +		fput(file);
> +	}
> +
>   #if defined(CONFIG_UNIX)
>   	if (ctx->ring_sock) {
>   		struct sock *sock = ctx->ring_sock->sk;
> @@ -8432,16 +8455,6 @@ static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
>   		while ((skb = skb_dequeue(&sock->sk_receive_queue)) != NULL)
>   			kfree_skb(skb);
>   	}
> -#else
> -	int i;
> -
> -	for (i = 0; i < ctx->nr_user_files; i++) {
> -		struct file *file;
> -
> -		file = io_file_from_index(ctx, i);
> -		if (file)
> -			fput(file);
> -	}
>   #endif
>   	io_free_file_tables(&ctx->file_table);
>   	io_rsrc_data_free(ctx->file_data);
> @@ -8590,7 +8603,9 @@ static struct io_sq_data *io_get_sq_data(struct io_uring_params *p,
>   /*
>    * Ensure the UNIX gc is aware of our file set, so we are certain that
>    * the io_uring can be safely unregistered on process exit, even if we have
> - * loops in the file referencing.
> + * loops in the file referencing. We account only files that can hold other
> + * files because otherwise they can't form a loop and so are not interesting
> + * for GC.
>    */
>   static int __io_sqe_files_scm(struct io_ring_ctx *ctx, int nr, int offset)
>   {
> @@ -8616,8 +8631,9 @@ static int __io_sqe_files_scm(struct io_ring_ctx *ctx, int nr, int offset)
>   	for (i = 0; i < nr; i++) {
>   		struct file *file = io_file_from_index(ctx, i + offset);
>   
> -		if (!file)
> +		if (!file || !io_file_need_scm(file))
>   			continue;
> +
>   		fpl->fp[nr_files] = get_file(file);
>   		unix_inflight(fpl->user, fpl->fp[nr_files]);
>   		nr_files++;
> @@ -8634,7 +8650,7 @@ static int __io_sqe_files_scm(struct io_ring_ctx *ctx, int nr, int offset)
>   		for (i = 0; i < nr; i++) {
>   			struct file *file = io_file_from_index(ctx, i + offset);
>   
> -			if (file)
> +			if (file && io_file_need_scm(file))
>   				fput(file);
>   		}
>   	} else {
> @@ -8676,6 +8692,7 @@ static int io_sqe_files_scm(struct io_ring_ctx *ctx)
>   
>   		if (file)
>   			fput(file);
> +		io_fixed_file_slot(&ctx->file_table, total)->file_ptr = 0;
>   		total++;
>   	}
>   
> @@ -8697,6 +8714,11 @@ static void io_rsrc_file_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc)
>   	struct sk_buff *skb;
>   	int i;
>   
> +	if (!io_file_need_scm(file)) {
> +		fput(file);
> +		return;
> +	}
> +
>   	__skb_queue_head_init(&list);
>   
>   	/*
> @@ -8889,6 +8911,9 @@ static int io_sqe_file_register(struct io_ring_ctx *ctx, struct file *file,
>   	struct sk_buff_head *head = &sock->sk_receive_queue;
>   	struct sk_buff *skb;
>   
> +	if (!io_file_need_scm(file))
> +		return 0;
> +
>   	/*
>   	 * See if we can merge this file into an existing skb SCM_RIGHTS
>   	 * file set. If there's no room, fall back to allocating a new skb

-- 
Pavel Begunkov
