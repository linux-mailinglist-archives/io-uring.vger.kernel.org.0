Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7121775CB46
	for <lists+io-uring@lfdr.de>; Fri, 21 Jul 2023 17:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231923AbjGUPQl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Jul 2023 11:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231935AbjGUPQa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Jul 2023 11:16:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E44D3583;
        Fri, 21 Jul 2023 08:16:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 978A061886;
        Fri, 21 Jul 2023 15:16:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 023A1C433C8;
        Fri, 21 Jul 2023 15:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689952565;
        bh=MkNuVd1XgobqU04f2sbF0/9zB0OovXVCUzqAotlByNQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GqOnO1++zVordyFDHsphIpZWUj6nCZLrhxeg9Ql80P7yC/Owrn8smvphZoFjw9BMP
         wMxGWGAG0u5KjxwtT2VgQ+wzZeD3hdtLZEI9bVaTRBvXQXGq6ZDMeurFhHTIR03WyU
         fhkpsPNhhmEfZmTeQK9swrH1rcXYjhKqAQGmrD8iwiVFHKQvYKvA+8VZr3ntND1UJI
         432wzYuQA44KanfSckjPkclndZAcDor2f3/niKPxvVqdYHqtLwRSa6wSQXigstUGYH
         9KRgX+R3zi4WMO/ec3lsJkV7eyx7yAd9BRcnUhIXNzC6s0TvrwRrn72xKi/hcyAQF0
         4fcM1iZpIyGzA==
Date:   Fri, 21 Jul 2023 08:16:04 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
        andres@anarazel.de, david@fromorbit.com
Subject: Re: [PATCH 2/8] iomap: add IOMAP_DIO_INLINE_COMP
Message-ID: <20230721151604.GL11352@frogsfrogsfrogs>
References: <20230720181310.71589-1-axboe@kernel.dk>
 <20230720181310.71589-3-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230720181310.71589-3-axboe@kernel.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jul 20, 2023 at 12:13:04PM -0600, Jens Axboe wrote:
> Rather than gate whether or not we need to punt a dio completion to a
> workqueue on whether the IO is a write or not, add an explicit flag for
> it. For now we treat them the same, reads always set the flags and async
> writes do not.
> 
> No functional changes in this patch.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Looks good,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/iomap/direct-io.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index 0ce60e80c901..c654612b24e5 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -20,6 +20,7 @@
>   * Private flags for iomap_dio, must not overlap with the public ones in
>   * iomap.h:
>   */
> +#define IOMAP_DIO_INLINE_COMP	(1 << 27)
>  #define IOMAP_DIO_WRITE_FUA	(1 << 28)
>  #define IOMAP_DIO_NEED_SYNC	(1 << 29)
>  #define IOMAP_DIO_WRITE		(1 << 30)
> @@ -171,8 +172,10 @@ void iomap_dio_bio_end_io(struct bio *bio)
>  		goto release_bio;
>  	}
>  
> -	/* Read completion can always complete inline. */
> -	if (!(dio->flags & IOMAP_DIO_WRITE)) {
> +	/*
> +	 * Flagged with IOMAP_DIO_INLINE_COMP, we can complete it inline
> +	 */
> +	if (dio->flags & IOMAP_DIO_INLINE_COMP) {
>  		WRITE_ONCE(iocb->private, NULL);
>  		iomap_dio_complete_work(&dio->aio.work);
>  		goto release_bio;
> @@ -527,6 +530,9 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>  		iomi.flags |= IOMAP_NOWAIT;
>  
>  	if (iov_iter_rw(iter) == READ) {
> +		/* reads can always complete inline */
> +		dio->flags |= IOMAP_DIO_INLINE_COMP;
> +
>  		if (iomi.pos >= dio->i_size)
>  			goto out_free_dio;
>  
> -- 
> 2.40.1
> 
