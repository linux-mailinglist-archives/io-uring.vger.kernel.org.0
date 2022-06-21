Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EBB4553669
	for <lists+io-uring@lfdr.de>; Tue, 21 Jun 2022 17:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353059AbiFUPkl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Jun 2022 11:40:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353052AbiFUPk3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Jun 2022 11:40:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D34852BB28
        for <io-uring@vger.kernel.org>; Tue, 21 Jun 2022 08:40:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F0DC61771
        for <io-uring@vger.kernel.org>; Tue, 21 Jun 2022 15:40:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99EA4C3411C;
        Tue, 21 Jun 2022 15:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655826026;
        bh=0cWo2c/zm4WO9qVU6zetr7PwvaMjZ7v86/LilLir9l4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UhhR/jvf1BmEPDZt6K4zfAUu+RkhmRSSLKWrINgb3prFzDDq8qrS/f1DQuNQd3fLu
         V7bgl7KXH3MzObapmP/cgxbCW9iXWM7lgWrwkr5YY7pIoVaNUyRcg8N32SzhmJm2RY
         I2tMyQE2vN8SnsZkW0dx3j9A3OGVsLroFwVFRptVem2SHDiIYc/jTNOY08+znjwvZ5
         G6QGgWhuA605hecgIEPrmYqSKF+Ap5Pum/69MctTYyYIjnhUqPGt+ViZEFlytSmoyg
         1LseJLbH9WHszksClrtsTuAn17wvD1VxZaqLI/qIoLs12EA+VvgQADzXnVZau3qaPi
         QzoYW0rRX+hjg==
Date:   Tue, 21 Jun 2022 08:40:24 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH for-next 03/10] io_uring: fix io_poll_remove_all clang
 warnings
Message-ID: <YrHmaOd1md4qqlHx@dev-arch.thelio-3990X>
References: <cover.1655684496.git.asml.silence@gmail.com>
 <f11d21dcdf9233e0eeb15fa13b858a05a78eb310.1655684496.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f11d21dcdf9233e0eeb15fa13b858a05a78eb310.1655684496.git.asml.silence@gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jun 20, 2022 at 01:25:54AM +0100, Pavel Begunkov wrote:
> clang complains on bitwise operations with bools, add a bit more
> verbosity to better show that we want to call io_poll_remove_all_table()
> twice but with different arguments.
> 
> Reported-by: Nathan Chancellor <nathan@kernel.org>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

Thank you for sending the patch! Apologies that I didn't do it but I
decided to actually take a full weekend off for once :) Looks like Jens
already applied it but just for the record:

Reviewed-by: Nathan Chancellor <nathan@kernel.org>

> ---
>  io_uring/poll.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/io_uring/poll.c b/io_uring/poll.c
> index d4bfc6d945cf..9af6a34222a9 100644
> --- a/io_uring/poll.c
> +++ b/io_uring/poll.c
> @@ -589,8 +589,11 @@ __cold bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
>  			       bool cancel_all)
>  	__must_hold(&ctx->uring_lock)
>  {
> -	return io_poll_remove_all_table(tsk, &ctx->cancel_table, cancel_all) |
> -	       io_poll_remove_all_table(tsk, &ctx->cancel_table_locked, cancel_all);
> +	bool ret;
> +
> +	ret = io_poll_remove_all_table(tsk, &ctx->cancel_table, cancel_all);
> +	ret |= io_poll_remove_all_table(tsk, &ctx->cancel_table_locked, cancel_all);
> +	return ret;
>  }
>  
>  static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, bool poll_only,
> -- 
> 2.36.1
> 
