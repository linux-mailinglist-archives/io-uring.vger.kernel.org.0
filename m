Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49E6E54FA5B
	for <lists+io-uring@lfdr.de>; Fri, 17 Jun 2022 17:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232856AbiFQPfN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jun 2022 11:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbiFQPfN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jun 2022 11:35:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21455250
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 08:35:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA6DDB82A37
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 15:35:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16630C3411F;
        Fri, 17 Jun 2022 15:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655480109;
        bh=VPkBkFvD/Xnk7A4j7m76oh1cYQnr7qtUqD6cTQbTnNo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lSwH1ee6epFMg63mrxjAXLHMfYkB8YEpBZ5dw7vY1YpEo81huYDAI+a6npp5Fdbbp
         l4NsakmpB4I8ktYEDrdVVzLc6kdlpcw3AZPXMd05+d6Rr5p/+K1Hi0dSTfIo9fl1XK
         Y0DlTIAlzxTPO/Vi860UmyR9s7zACRj40cy9kcMxey2dG0+DKfd303esiNB9a03/6R
         jQhNWaSLT6ll1PgT/VBdxRwUjkybS0fmAQODoMIXb/Pm7noA6qy7R1bLYVPjh2I5cs
         HII3pZN1vWq5aCx68oQmXUWbfTAIRSEptskGJShOFQvEfqFahNUzCO+LK6wv9Oxkkv
         nm5gmFpxzJocg==
Date:   Fri, 17 Jun 2022 08:35:07 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        llvm@lists.linux.dev
Subject: Re: [PATCH for-next v3 16/16] io_uring: mutex locked poll hashing
Message-ID: <YqyfK34NJakiLiVe@dev-arch.thelio-3990X>
References: <cover.1655371007.git.asml.silence@gmail.com>
 <1bbad9c78c454b7b92f100bbf46730a37df7194f.1655371007.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1bbad9c78c454b7b92f100bbf46730a37df7194f.1655371007.git.asml.silence@gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jun 16, 2022 at 10:22:12AM +0100, Pavel Begunkov wrote:
> Currently we do two extra spin lock/unlock pairs to add a poll/apoll
> request to the cancellation hash table and remove it from there.
> 
> On the submission side we often already hold ->uring_lock and tw
> completion is likely to hold it as well. Add a second cancellation hash
> table protected by ->uring_lock. In concerns for latency because of a
> need to have the mutex locked on the completion side, use the new table
> only in following cases:
> 
> 1) IORING_SETUP_SINGLE_ISSUER: only one task grabs uring_lock, so there
>    is little to no contention and so the main tw hander will almost
>    always end up grabbing it before calling callbacks.
> 
> 2) IORING_SETUP_SQPOLL: same as with single issuer, only one task is
>    a major user of ->uring_lock.
> 
> 3) apoll: we normally grab the lock on the completion side anyway to
>    execute the request, so it's free.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

<snip>

> -/*
> - * Returns true if we found and killed one or more poll requests
> - */
> -__cold bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
> -			       bool cancel_all)
> +static __cold bool io_poll_remove_all_table(struct task_struct *tsk,
> +					    struct io_hash_table *table,
> +					    bool cancel_all)
>  {
> -	struct io_hash_table *table = &ctx->cancel_table;
>  	unsigned nr_buckets = 1U << table->hash_bits;
>  	struct hlist_node *tmp;
>  	struct io_kiocb *req;
> @@ -557,6 +592,17 @@ __cold bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
>  	return found;
>  }
>  
> +/*
> + * Returns true if we found and killed one or more poll requests
> + */
> +__cold bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
> +			       bool cancel_all)
> +	__must_hold(&ctx->uring_lock)
> +{
> +	return io_poll_remove_all_table(tsk, &ctx->cancel_table, cancel_all) |
> +	       io_poll_remove_all_table(tsk, &ctx->cancel_table_locked, cancel_all);
> +}

Clang warns:

  io_uring/poll.c:602:9: error: use of bitwise '|' with boolean operands [-Werror,-Wbitwise-instead-of-logical]
          return io_poll_remove_all_table(tsk, &ctx->cancel_table, cancel_all) |
                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                                                                               ||
  io_uring/poll.c:602:9: note: cast one or both operands to int to silence this warning
  1 error generated.

I assume this is intentional so io_poll_remove_all_table() gets called
twice every time? If so, would you be opposed to unrolling this a bit to
make it clear to the compiler? Alternatively, we could change the return
type of io_poll_remove_all_table to be an int or add a cast to int like
the note mentioned but that is rather ugly to me. I can send a formal
patch depending on your preference.

Cheers,
Nathan

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 2e068e05732a..6a70bc220971 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -599,8 +599,12 @@ __cold bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
 			       bool cancel_all)
 	__must_hold(&ctx->uring_lock)
 {
-	return io_poll_remove_all_table(tsk, &ctx->cancel_table, cancel_all) |
-	       io_poll_remove_all_table(tsk, &ctx->cancel_table_locked, cancel_all);
+	bool ret;
+
+	ret = io_poll_remove_all_table(tsk, &ctx->cancel_table, cancel_all);
+	ret |= io_poll_remove_all_table(tsk, &ctx->cancel_table_locked, cancel_all);
+
+	return ret;
 }
 
 static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, bool poll_only,
