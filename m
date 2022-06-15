Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB8754C360
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 10:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240678AbiFOIUd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 04:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243978AbiFOIUb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 04:20:31 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 279AF29379
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 01:20:30 -0700 (PDT)
Message-ID: <172baf20-e6d1-9098-187d-a2970885338b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1655281228;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rHmE7CVGXUy+IkG9zha6/3T3wQTVFGFcOuJukw1IvXE=;
        b=FXWJwYV01LC0rs7gna1cNapkmRXor9MujEh1JiIhhXrQcFIfCazMVT4jJ4M6U0rhfBOhKt
        yFodlifMdDbcxnPmYLAb5FPAQeWW79w5QyRbAQn5HeaWqyDOynexXW3mxNUO6jXQe2sUlU
        LLd3xO4GBrr46izp3e3F8NC3dCKx7g0=
Date:   Wed, 15 Jun 2022 16:20:24 +0800
MIME-Version: 1.0
Subject: Re: [PATCH for-next v2 10/25] io_uring: kill REQ_F_COMPLETE_INLINE
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <cover.1655213915.git.asml.silence@gmail.com>
 <378d3aba69ea2b6a8b14624810a551c2ae011791.1655213915.git.asml.silence@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <378d3aba69ea2b6a8b14624810a551c2ae011791.1655213915.git.asml.silence@gmail.com>
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

On 6/14/22 22:37, Pavel Begunkov wrote:
> REQ_F_COMPLETE_INLINE is only needed to delay queueing into the
> completion list to io_queue_sqe() as __io_req_complete() is inlined and
> we don't want to bloat the kernel.
> 
> As now we complete in a more centralised fashion in io_issue_sqe() we
> can get rid of the flag and queue to the list directly.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   io_uring/io_uring.c       | 20 ++++++++------------
>   io_uring/io_uring.h       |  5 -----
>   io_uring/io_uring_types.h |  3 ---
>   3 files changed, 8 insertions(+), 20 deletions(-)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 1fb93fdcfbab..fcee58c6c35e 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -1278,17 +1278,14 @@ static void io_req_complete_post32(struct io_kiocb *req, u64 extra1, u64 extra2)
>   
>   inline void __io_req_complete(struct io_kiocb *req, unsigned issue_flags)
>   {
> -	if (issue_flags & IO_URING_F_COMPLETE_DEFER)
> -		io_req_complete_state(req);
> -	else
> -		io_req_complete_post(req);
> +	io_req_complete_post(req);
>   }
>   

io_read/write and provide_buffers/remove_buffers are still using
io_req_complete() in their own function. By removing the
IO_URING_F_COMPLETE_DEFER branch they will end in complete_post path
100% which we shouldn't.
