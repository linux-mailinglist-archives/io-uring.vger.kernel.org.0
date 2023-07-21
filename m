Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02C8375CC64
	for <lists+io-uring@lfdr.de>; Fri, 21 Jul 2023 17:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232268AbjGUPsn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Jul 2023 11:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbjGUPsk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Jul 2023 11:48:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D77073599;
        Fri, 21 Jul 2023 08:48:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C36461CF4;
        Fri, 21 Jul 2023 15:48:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE253C433C8;
        Fri, 21 Jul 2023 15:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689954517;
        bh=Zi5JGltTTzlzoq7emz3BD71lLiNNCga60s7DO6hXsdo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=coz2ogWgRBaIsizCxVSU+xB/R+rvS+gPOId6Hs1+TaU5UhGKfuGmoSt6SyUJxWSWh
         fqNmOYuPuUrKabljMcVyG8EJ99bu6KLzVHWo1pPuOcxKNUkAVklKFJd9CzIGyaI9JG
         ZBcdK9L439u5aS3L0AasjbZ1b7kQtT62RVEMmoDpGJfOFPp0IFJwZ/qK5g+/ihyKXz
         Br8JG+3tqgUX8qYHxEnj+IIulCrrEtRpTzAqhdJ+Im0XDlJzbLsy0rX2MLhZUjcvRe
         2J6h8E7pMr1xyqtT9bJY/ijGuqodgBsHs4GsEGdU51cpIdUbjw6U6XhnP1qwNgGQNN
         E42U2WrQc6rig==
Date:   Fri, 21 Jul 2023 08:48:37 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
        andres@anarazel.de, david@fromorbit.com
Subject: Re: [PATCH 6/8] fs: add IOCB flags related to passing back dio
 completions
Message-ID: <20230721154837.GO11352@frogsfrogsfrogs>
References: <20230720181310.71589-1-axboe@kernel.dk>
 <20230720181310.71589-7-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230720181310.71589-7-axboe@kernel.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jul 20, 2023 at 12:13:08PM -0600, Jens Axboe wrote:
> Async dio completions generally happen from hard/soft IRQ context, which
> means that users like iomap may need to defer some of the completion
> handling to a workqueue. This is less efficient than having the original
> issuer handle it, like we do for sync IO, and it adds latency to the
> completions.
> 
> Add IOCB_DIO_DEFER, which the issuer can set if it is able to safely
> punt these completions to a safe context. If the dio handler is aware
> of this flag, assign a callback handler in kiocb->dio_complete and
> associated data io kiocb->private. The issuer will then call this handler
> with that data from task context.
> 
> No functional changes in this patch.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  include/linux/fs.h | 34 ++++++++++++++++++++++++++++++++--
>  1 file changed, 32 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 6867512907d6..2c589418a078 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -338,6 +338,20 @@ enum rw_hint {
>  #define IOCB_NOIO		(1 << 20)
>  /* can use bio alloc cache */
>  #define IOCB_ALLOC_CACHE	(1 << 21)
> +/*
> + * IOCB_DIO_DEFER can be set by the iocb owner, to indicate that the
> + * iocb completion can be passed back to the owner for execution from a safe
> + * context rather than needing to be punted through a workqueue. If this
> + * flag is set, the completion handling may set iocb->dio_complete to a
> + * handler, which the issuer will then call from task context to complete
> + * the processing of the iocb. iocb->private should then also be set to
> + * the argument being passed to this handler. Note that while this provides

Who should be setting iocb->private?  Can I suggest rewording this to:

"If this flag is set, the bio completion handling may set
iocb->dio_complete to a handler function and iocb->private to context
information for that handler.  The issuer should call the handler with
that context information from task context to complete the processing of
the iocb."

Assuming I've understood what this does from the next patch? :)

> + * a task context for the dio_complete() callback, it should only be used
> + * on the completion side for non-IO generating completions. It's fine to
> + * call blocking functions from this callback, but they should not wait for
> + * unrelated IO (like cache flushing, new IO generation, etc).
> + */
> +#define IOCB_DIO_DEFER		(1 << 22)

Sorry to nitpick names here, but "defer" feels a little vague to me.
Defer what?  And to whom?

This flag means "defer iocb completion to the caller", right?  If so,
wouldn't this be better named IOCB_DIO_CALLER_COMP?

>  /* for use in trace events */
>  #define TRACE_IOCB_STRINGS \
> @@ -351,7 +365,8 @@ enum rw_hint {
>  	{ IOCB_WRITE,		"WRITE" }, \
>  	{ IOCB_WAITQ,		"WAITQ" }, \
>  	{ IOCB_NOIO,		"NOIO" }, \
> -	{ IOCB_ALLOC_CACHE,	"ALLOC_CACHE" }
> +	{ IOCB_ALLOC_CACHE,	"ALLOC_CACHE" }, \
> +	{ IOCB_DIO_DEFER,	"DIO_DEFER" }
>  
>  struct kiocb {
>  	struct file		*ki_filp;
> @@ -360,7 +375,22 @@ struct kiocb {
>  	void			*private;
>  	int			ki_flags;
>  	u16			ki_ioprio; /* See linux/ioprio.h */
> -	struct wait_page_queue	*ki_waitq; /* for async buffered IO */
> +	union {
> +		/*
> +		 * Only used for async buffered reads, where it denotes the
> +		 * page waitqueue associated with completing the read. Valid
> +		 * IFF IOCB_WAITQ is set.
> +		 */
> +		struct wait_page_queue	*ki_waitq;
> +		/*
> +		 * Can be used for O_DIRECT IO, where the completion handling
> +		 * is punted back to the issuer of the IO. May only be set
> +		 * if IOCB_DIO_DEFER is set by the issuer, and the issuer must
> +		 * then check for presence of this handler when ki_complete is
> +		 * invoked.

Might want to reiterate in the comment that kiocb.private should be
passed as @data.

--D

> +		 */
> +		ssize_t (*dio_complete)(void *data);
> +	};
>  };
>  
>  static inline bool is_sync_kiocb(struct kiocb *kiocb)
> -- 
> 2.40.1
> 
