Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC31F75CB72
	for <lists+io-uring@lfdr.de>; Fri, 21 Jul 2023 17:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231985AbjGUPUk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Jul 2023 11:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231989AbjGUPU1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Jul 2023 11:20:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD11F3C3C;
        Fri, 21 Jul 2023 08:19:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C34461886;
        Fri, 21 Jul 2023 15:19:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCF43C433C8;
        Fri, 21 Jul 2023 15:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689952785;
        bh=M8PjcSukgHLbup2keJf+FD+7guLaxXPzAwPhCUSpEOs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O6H16n94o4YRsdBIc55e7sJrBSluHktO39pM6YB3KLOVGIOqkoU7Md5bqlgNm2BFP
         t9FExLDNi5oCVemmTSFPJZDcERpiwhURHpnvhiRjjfkCCVz6IKXBEi42R0nnIgKnzW
         UIuskWxeLY8wz3cfoxd5A3f36crQmQnlfqUZRxatiZDPk8j4aPK6EMtjfNyp45cUDh
         53RtjrZ8HGAnWW+LSD3QbD0fkrBRAAI1xwxW/TGipTjxtYHsIBh14cZxcYCMMeINwh
         xUcgKSXjU0jcT/E5t0BJxDzipCw+2CyHhrhPMLXx8UhRXm9bUktrOxhSFRj/LiSYIh
         G5Oqnh5NE6qqQ==
Date:   Fri, 21 Jul 2023 08:19:45 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
        andres@anarazel.de, david@fromorbit.com
Subject: Re: [PATCH 4/8] iomap: completed polled IO inline
Message-ID: <20230721151945.GM11352@frogsfrogsfrogs>
References: <20230720181310.71589-1-axboe@kernel.dk>
 <20230720181310.71589-5-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230720181310.71589-5-axboe@kernel.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jul 20, 2023 at 12:13:06PM -0600, Jens Axboe wrote:
> Polled IO is only allowed for conditions where task completion is safe
> anyway, so we can always complete it inline. This cannot easily be
> checked with a submission side flag, as the block layer may clear the
> polled flag and turn it into a regular IO instead. Hence we need to
> check this at completion time. If REQ_POLLED is still set, then we know
> that this IO was successfully polled, and is completing in task context.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  fs/iomap/direct-io.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index 9f97d0d03724..c3ea1839628f 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -173,9 +173,19 @@ void iomap_dio_bio_end_io(struct bio *bio)
>  	}
>  
>  	/*
> -	 * Flagged with IOMAP_DIO_INLINE_COMP, we can complete it inline
> +	 * Flagged with IOMAP_DIO_INLINE_COMP, we can complete it inline.
> +	 * Ditto for polled requests - if the flag is still at completion
> +	 * time, then we know the request was actually polled and completion

Glad you added the comment here pointing out that REQ_POLLED must
*still* be set after the bio has been executed, because that was the
only question I had about this patch.

> +	 * is called from the task itself. This is why we need to check it
> +	 * here rather than flag it at issue time.
>  	 */
> -	if (dio->flags & IOMAP_DIO_INLINE_COMP) {
> +	if ((dio->flags & IOMAP_DIO_INLINE_COMP) || (bio->bi_opf & REQ_POLLED)) {
> +		/*
> +		 * For polled IO, we need to clear ->private as it points to
> +		 * the bio being polled for. The completion side uses it to
> +		 * know if a given request has been found yet or not. For
> +		 * non-polled IO, ->private isn't applicable.

Thanks for the clarifying note here too.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


> +		 */
>  		WRITE_ONCE(iocb->private, NULL);
>  		iomap_dio_complete_work(&dio->aio.work);
>  		goto release_bio;
> -- 
> 2.40.1
> 
