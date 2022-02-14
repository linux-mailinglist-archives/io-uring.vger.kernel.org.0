Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8D54B595B
	for <lists+io-uring@lfdr.de>; Mon, 14 Feb 2022 19:08:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353777AbiBNSIn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Feb 2022 13:08:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235368AbiBNSIm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Feb 2022 13:08:42 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED0365171;
        Mon, 14 Feb 2022 10:08:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=c9YPrGABn7w/8u5ruEO/mdlaRrXyOVduf4KJ9J9ae6w=; b=akTThdDY+jFH+5THen3Sn3+Ux1
        /Oza9Vnodscf30MWU7Pvn3x0n+xnB+keIotCqEEOSeZvgmesga+UbXGALn6WrV00c61iEBVNspwhF
        8gmNeLyCvWQFiHQ8viKtxyQi80Acqo77ncm1k9PM7jM9H4k211nU+7M9YG4lCdeUserReXRkZvHRf
        XLNOvAoQCohO6yH9+sFwgzaUM8k8D2MANvYcNxHws83n8SOszjMa+4K5TdYPzYfG0109bl5G3p0m3
        tnFPBQrjL0ZufHJuuYG9AHIPDTA0F5amorZSCZ5Du244dvc0TQnNH6NUHY3kDyK8LOhPmY9ZLryXA
        Mg6aHR4g==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nJflz-00D8zj-KC; Mon, 14 Feb 2022 18:08:29 +0000
Date:   Mon, 14 Feb 2022 18:08:27 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-block@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v1 03/14] mm: add noio support in filemap_get_pages
Message-ID: <Ygqam9fgYXZeqK2H@casper.infradead.org>
References: <20220214174403.4147994-1-shr@fb.com>
 <20220214174403.4147994-4-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220214174403.4147994-4-shr@fb.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Feb 14, 2022 at 09:43:52AM -0800, Stefan Roesch wrote:
> This adds noio support for async buffered writes in filemap_get_pages.
> The idea is to handle the failure gracefully and return -EAGAIN if we
> can't get the memory quickly.

But it doesn't return -EAGAIN?

        folio = filemap_alloc_folio(mapping_gfp_mask(mapping), 0);
        if (!folio)
                return -ENOMEM;

> Signed-off-by: Stefan Roesch <shr@fb.com>
> ---
>  mm/filemap.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index d2fb817c0845..0ff4278c3961 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2591,10 +2591,15 @@ static int filemap_get_pages(struct kiocb *iocb, struct iov_iter *iter,
>  		filemap_get_read_batch(mapping, index, last_index, fbatch);
>  	}
>  	if (!folio_batch_count(fbatch)) {
> +		unsigned int pflags;
> +
>  		if (iocb->ki_flags & (IOCB_NOWAIT | IOCB_WAITQ))
> -			return -EAGAIN;
> +			pflags = memalloc_noio_save();
>  		err = filemap_create_folio(filp, mapping,
>  				iocb->ki_pos >> PAGE_SHIFT, fbatch);
> +		if (iocb->ki_flags & (IOCB_NOWAIT | IOCB_WAITQ))
> +			memalloc_noio_restore(pflags);
> +
>  		if (err == AOP_TRUNCATED_PAGE)
>  			goto retry;
>  		return err;

I would also not expect the memalloc_noio_save/restore calls to be
here.  Surely they should be at the top of the call chain where
IOCB_NOWAIT/IOCB_WAITQ are set?
