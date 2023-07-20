Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B73175A547
	for <lists+io-uring@lfdr.de>; Thu, 20 Jul 2023 06:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbjGTE7Y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Jul 2023 00:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjGTE7X (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Jul 2023 00:59:23 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEABF1FD2;
        Wed, 19 Jul 2023 21:59:22 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 56ABE67373; Thu, 20 Jul 2023 06:59:19 +0200 (CEST)
Date:   Thu, 20 Jul 2023 06:59:19 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
        andres@anarazel.de, david@fromorbit.com
Subject: Re: [PATCH 6/6] iomap: support IOCB_DIO_DEFER
Message-ID: <20230720045919.GD1811@lst.de>
References: <20230719195417.1704513-1-axboe@kernel.dk> <20230719195417.1704513-7-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230719195417.1704513-7-axboe@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> +	if (dio->flags & IOMAP_DIO_DEFER_COMP) {
> +		/* only polled IO cares about private cleared */
> +		iocb->private = dio;

FYI, I find this comment a bit weird as it comments on what we're
not doing in a path where it is irreleant.  I'd rather only clear
the private data in the path where polling is applicable and have
a comment there why it is cleared.  That probably belongs into the
first patch restructuring the function.

> @@ -277,12 +308,15 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
>  		 * data IO that doesn't require any metadata updates (including
>  		 * after IO completion such as unwritten extent conversion) and
>  		 * the underlying device supports FUA. This allows us to avoid
> -		 * cache flushes on IO completion.
> +		 * cache flushes on IO completion. If we can't use FUA and
> +		 * need to sync, disable in-task completions.

... because iomap_dio_complete will have to call generic_write_sync to
do a blocking ->fsync call.

> @@ -308,6 +342,8 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
>  		pad = pos & (fs_block_size - 1);
>  		if (pad)
>  			iomap_dio_zero(iter, dio, pos - pad, pad);
> +
> +		dio->flags &= ~IOMAP_DIO_DEFER_COMP;

Why does zeroing disable the deferred completions?  I can't really think
of why, which is probably a strong indicator why this needs a comment.

