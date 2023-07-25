Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06909761D2A
	for <lists+io-uring@lfdr.de>; Tue, 25 Jul 2023 17:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233206AbjGYPTW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Jul 2023 11:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232978AbjGYPTP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Jul 2023 11:19:15 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C6D2199D;
        Tue, 25 Jul 2023 08:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=SRlxnNT5gYqx8VeXj9kxPiPB5tagsg9OYIr/uXQ4Zs0=; b=uBw/jBAQc9yS4f8S7cfU5HAIPR
        3imEZIa3sp9gEuLxoeZBqw6kLXg2fd6WaiqK6w1TeJ+mj+AXF0NlI8484Y5m+rmZ2TbLOmW1LiE93
        tx5vjkKwfjMF2g+c2EcGv4uuQAf0aaDzwMUvEuF/Mf9293n4gv6p+zPDstaf3QzUa2hKJnx5I3kwn
        NO3pj90dmP/ycInJQh1H3OwkbD1bWY9to7idZbL/wIV3RTUIg0g4Nm9R8OBaVUKtkUT3Tje8OXjkR
        OMAfYOBttDyisLb5cn3ssMsc7d+tvhQONHM4ZQKgN39QU7FPSat9KxuERLfIMXKeSCpcu/0lVI9DY
        s9Q0IGsw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qOJod-005aXS-3Y; Tue, 25 Jul 2023 15:19:11 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id A04FE3001FD;
        Tue, 25 Jul 2023 17:19:09 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 69CF52612ACA0; Tue, 25 Jul 2023 17:19:09 +0200 (CEST)
Date:   Tue, 25 Jul 2023 17:19:09 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        andres@anarazel.de
Subject: Re: [PATCH 06/10] io_uring: add support for futex wake and wait
Message-ID: <20230725151909.GT4253@hirez.programming.kicks-ass.net>
References: <20230720221858.135240-1-axboe@kernel.dk>
 <20230720221858.135240-7-axboe@kernel.dk>
 <20230721113031.GG3630545@hirez.programming.kicks-ass.net>
 <20230721113718.GA3638458@hirez.programming.kicks-ass.net>
 <d95bfb98-8d76-f0fd-6283-efc01d0cc015@kernel.dk>
 <94b8fcc4-12b5-8d8c-3eb3-fe1e73a25456@kernel.dk>
 <20230725130015.GI3765278@hirez.programming.kicks-ass.net>
 <28a42d23-6d70-bc4c-5abc-0b3cc5d7338d@kernel.dk>
 <9a197037-4732-c524-2eb9-250ef7175a82@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a197037-4732-c524-2eb9-250ef7175a82@kernel.dk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jul 25, 2023 at 07:57:28AM -0600, Jens Axboe wrote:

> Something like the below - totally untested, but just to show what I
> mean. Will need to get split and folded into the two separate patches.
> Will test and fold them later today.
> 
> 
> diff --git a/io_uring/futex.c b/io_uring/futex.c
> index 4c9f2c841b98..b0f90154d974 100644
> --- a/io_uring/futex.c
> +++ b/io_uring/futex.c
> @@ -168,7 +168,7 @@ bool io_futex_remove_all(struct io_ring_ctx *ctx, struct task_struct *task,
>  	return found;
>  }
>  
> -int io_futex_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> +static int __io_futex_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  {
>  	struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
>  	u32 flags;
> @@ -179,9 +179,6 @@ int io_futex_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  	iof->uaddr = u64_to_user_ptr(READ_ONCE(sqe->addr));
>  	iof->futex_val = READ_ONCE(sqe->addr2);
>  	iof->futex_mask = READ_ONCE(sqe->addr3);
> -	iof->futex_nr = READ_ONCE(sqe->len);
> -	if (iof->futex_nr && req->opcode != IORING_OP_FUTEX_WAITV)
> -		return -EINVAL;
>  
>  	flags = READ_ONCE(sqe->futex_flags);
>  	if (flags & ~FUTEX2_MASK)
> @@ -191,14 +188,36 @@ int io_futex_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  	if (!futex_flags_valid(iof->futex_flags))
>  		return -EINVAL;
>  
> -	if (!futex_validate_input(iof->futex_flags, iof->futex_val) ||
> -	    !futex_validate_input(iof->futex_flags, iof->futex_mask))
> +	if (!futex_validate_input(iof->futex_flags, iof->futex_mask))
>  		return -EINVAL;
>  
> -	iof->futexv_owned = 0;
>  	return 0;
>  }

I think you can/should split more into io_futex_prep(), specifically
waitv should also have zero @val and @mask.

But yes, something like this makes sense.
