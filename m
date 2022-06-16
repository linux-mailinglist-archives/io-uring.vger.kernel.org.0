Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C02D54E192
	for <lists+io-uring@lfdr.de>; Thu, 16 Jun 2022 15:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376839AbiFPNNh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jun 2022 09:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376939AbiFPNNf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jun 2022 09:13:35 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83EFA2ED69
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 06:13:33 -0700 (PDT)
Message-ID: <afae40a9-f27f-1090-cd6d-4ab02f740966@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1655385211;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kC+K3WypVrYjxRT8nx/1mi96gi3ZYp6Ks5/ETviOqCc=;
        b=ALmY2nvH8hkZYqzFmbfMRNw/TxWYCWwBvFSGm5iR9HZ2Fv9Shs2aJmNfAtXQ1A7eN78Z2f
        iuZyDPg9WbBLuY656GIX8bO3e5o92leDej0pvnvno2h37TTBWoLAa2/6eBekDpoUJPDY1+
        EWJnoNeRP1Hk1TqCNTaEmTLdd2q09Kk=
Date:   Thu, 16 Jun 2022 21:13:25 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2] io_uring: commit non-pollable provided mapped buffers
 upfront
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>
References: <43b88754-a171-e871-5418-1ce53055c715@kernel.dk>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <43b88754-a171-e871-5418-1ce53055c715@kernel.dk>
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

On 6/16/22 20:34, Jens Axboe wrote:
> For recv/recvmsg, IO either completes immediately or gets queued for a
> retry. This isn't the case for read/readv, if eg a normal file or a block
> device is used. Here, an operation can get queued with the block layer.
> If this happens, ring mapped buffers must get committed immediately to
> avoid that the next read can consume the same buffer.
> 
> Check if we're dealing with pollable file, when getting a new ring mapped
> provided buffer. If it's not, commit it immediately rather than wait post
> issue. If we don't wait, we can race with completions coming in, or just
> plain buffer reuse by committing after a retry where others could have
> grabbed the same buffer.
> 
> Fixes: c7fb19428d67 ("io_uring: add support for ring mapped supplied buffers")
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> ---
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 5d479428d8e5..b6e75f69c6b1 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -3836,7 +3836,7 @@ static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
>   	req->buf_list = bl;
>   	req->buf_index = buf->bid;
>   
> -	if (issue_flags & IO_URING_F_UNLOCKED) {
> +	if (issue_flags & IO_URING_F_UNLOCKED || !file_can_poll(req->file)) {
>   		/*
>   		 * If we came in unlocked, we have no choice but to consume the
>   		 * buffer here. This does mean it'll be pinned until the IO
> 

Looks good,
Reviewed-by: Hao Xu <howeyxu@tencent.com>

