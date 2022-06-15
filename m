Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37BEE54C314
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 10:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236288AbiFOIFq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 04:05:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236586AbiFOIFp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 04:05:45 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F30DB45ACA
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 01:05:44 -0700 (PDT)
Message-ID: <1e54cb98-23dd-d092-c0b9-937462a9418f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1655280343;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UIr7RHhCObo8VPaR/DNbXkf1XAngu4kwygxwxBjB8+M=;
        b=MfPdVk2lQw2r/CpMXnrtO3Iz4ROaDOcThz8HzLhKJovzXCSZAvvlXU6HJ1Sgk0ArDRpPke
        yBFogzRvknV7ry4rfK6quwtOywHGYEy/DtxfuhJUQ49pMiuW3/NRM4gPKoGEwDGVeJGPXt
        fcGmlODDY/2NZfLiFiKMnIMcaMLoQhk=
Date:   Wed, 15 Jun 2022 16:05:31 +0800
MIME-Version: 1.0
Subject: Re: [PATCH for-next v2 09/25] io_uring: never defer-complete
 multi-apoll
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <cover.1655213915.git.asml.silence@gmail.com>
 <9ce557af28d199cb03cd24db65fad6579a2e9c2b.1655213915.git.asml.silence@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <9ce557af28d199cb03cd24db65fad6579a2e9c2b.1655213915.git.asml.silence@gmail.com>
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

On 6/14/22 22:36, Pavel Begunkov wrote:
> Luckily, nnobody completes multi-apoll requests outside the polling
> functions, but don't set IO_URING_F_COMPLETE_DEFER in any case as
> there is nobody who is catching REQ_F_COMPLETE_INLINE, and so will leak
> requests if used.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   io_uring/io_uring.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index d895f70977b0..1fb93fdcfbab 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -2149,7 +2149,7 @@ int io_poll_issue(struct io_kiocb *req, bool *locked)
>   	io_tw_lock(req->ctx, locked);
>   	if (unlikely(req->task->flags & PF_EXITING))
>   		return -EFAULT;
> -	return io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_COMPLETE_DEFER);
> +	return io_issue_sqe(req, IO_URING_F_NONBLOCK);
>   }
>   
>   struct io_wq_work *io_wq_free_work(struct io_wq_work *work)

Good catch! Thanks.
