Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83C1B54D96A
	for <lists+io-uring@lfdr.de>; Thu, 16 Jun 2022 06:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349153AbiFPEle (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jun 2022 00:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242840AbiFPElV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jun 2022 00:41:21 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F99B58E69
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 21:41:20 -0700 (PDT)
Message-ID: <5182eae9-efe8-4271-32f5-f90033679f9e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1655354478;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fXmy195oYktG4dJs3SOiWG8hRG5oM6LXs3iDYwDnBZQ=;
        b=CZy9bh82X+o0Ivv5V60bWgLG6fV8lK+HQv2PhjYpE/pzSPFmVb7707I7esRqgUerPxC7xX
        jt86ROXvAEWN4vf8Ln4pMIMlfFB81+4JU0Pqg7De82bTnxjF+kJxFNwhS7N6j3SVMg/L1C
        ddIonc0jvDc5NQnv/5kOk98at8h2/ig=
Date:   Thu, 16 Jun 2022 12:41:11 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] io_uring: read/readv must commit ring mapped buffers
 upfront
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>
References: <b0c9112b-15d3-052b-3880-a81bed7a5842@kernel.dk>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <b0c9112b-15d3-052b-3880-a81bed7a5842@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/16/22 09:55, Jens Axboe wrote:
> For recv/recvmsg, IO either completes immediately or gets queued for a
> retry. This isn't the case for read/readv, if eg a normal file or a block
> device is used. Here, an operation can get queued with the block layer.
> If this happens, ring mapped buffers must get committed immediately to
> avoid that the next read can consume the same buffer.
> 
> Add an io_op_def flag for this, buffer_ring_commit. If set, when a mapped
> buffer is selected, it is immediately committed.
> 
> Fixes: c7fb19428d67 ("io_uring: add support for ring mapped supplied buffers")
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> ---
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 5d479428d8e5..05703bcf73fd 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1098,6 +1098,8 @@ struct io_op_def {
>   	unsigned		poll_exclusive : 1;
>   	/* op supports buffer selection */
>   	unsigned		buffer_select : 1;
> +	/* op needs immediate commit of ring mapped buffers */
> +	unsigned		buffer_ring_commit : 1;
>   	/* do prep async if is going to be punted */
>   	unsigned		needs_async_setup : 1;
>   	/* opcode is not supported by this kernel */
> @@ -1122,6 +1124,7 @@ static const struct io_op_def io_op_defs[] = {
>   		.unbound_nonreg_file	= 1,
>   		.pollin			= 1,
>   		.buffer_select		= 1,
> +		.buffer_ring_commit	= 1,
>   		.needs_async_setup	= 1,
>   		.plug			= 1,
>   		.audit_skip		= 1,
> @@ -1239,6 +1242,7 @@ static const struct io_op_def io_op_defs[] = {
>   		.unbound_nonreg_file	= 1,
>   		.pollin			= 1,
>   		.buffer_select		= 1,
> +		.buffer_ring_commit	= 1,
>   		.plug			= 1,
>   		.audit_skip		= 1,
>   		.ioprio			= 1,


This way we also commit the buffer for read(sockfd) unconditionally.
Would it be better to commit buffer only for read(reg/blk fd) ?

> @@ -3836,7 +3840,8 @@ static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
>   	req->buf_list = bl;
>   	req->buf_index = buf->bid;
>   
> -	if (issue_flags & IO_URING_F_UNLOCKED) {
> +	if (issue_flags & IO_URING_F_UNLOCKED ||
> +	    io_op_defs[req->opcode].buffer_ring_commit) {
>   		/*
>   		 * If we came in unlocked, we have no choice but to consume the
>   		 * buffer here. This does mean it'll be pinned until the IO
> 

