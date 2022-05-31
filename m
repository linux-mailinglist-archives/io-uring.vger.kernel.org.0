Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27B5F538B9C
	for <lists+io-uring@lfdr.de>; Tue, 31 May 2022 08:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244343AbiEaGyX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 May 2022 02:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232460AbiEaGyW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 May 2022 02:54:22 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB1E80215;
        Mon, 30 May 2022 23:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=3w/feybneJ0sy1JULoFDyQ463v+aK5COROBK0seN86Y=; b=X9ArWCM6GQTQmfLdn+gNImflR4
        V2hPXk6tveGoUESCRb1f1H5nxCFMJEGlY9a/D88pWMTIQCSbYhjQbo21w/VDuNKAinjTliojbFqG+
        TyTDjQesyufhMJ+qJFLdIFF6GvBXZ6mTICzDV36+lid1sbFSKzNZolnHCtZOugkUR15elXxyCRKGd
        Zv5yMzLNs2sKEInMJ1N9iGHexE5MynT7gguixGgUKXBoLYIdfu/287vXud9TWaOc/0hUDMp4D6MkS
        vpqM7DhkgbXKeXEOG3L8Lt6xb86juWzBXiQDMhAd82Fk0K08gyRM9ZV+j0T/62mUiD8der11LUxSl
        eg7eCIBQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nvvlk-009ciB-9V; Tue, 31 May 2022 06:54:20 +0000
Date:   Mon, 30 May 2022 23:54:20 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org
Subject: Re: [PATCH v6 04/16] iomap: Add flags parameter to
 iomap_page_create()
Message-ID: <YpW7nKoUB9dJk3ee@infradead.org>
References: <20220526173840.578265-1-shr@fb.com>
 <20220526173840.578265-5-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220526173840.578265-5-shr@fb.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, May 26, 2022 at 10:38:28AM -0700, Stefan Roesch wrote:
> Add the kiocb flags parameter to the function iomap_page_create().
> Depending on the value of the flags parameter it enables different gfp
> flags.
> 
> No intended functional changes in this patch.
> 
> Signed-off-by: Stefan Roesch <shr@fb.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> ---
>  fs/iomap/buffered-io.c | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 8ce8720093b9..d6ddc54e190e 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -44,16 +44,21 @@ static inline struct iomap_page *to_iomap_page(struct folio *folio)
>  static struct bio_set iomap_ioend_bioset;
>  
>  static struct iomap_page *
> -iomap_page_create(struct inode *inode, struct folio *folio)
> +iomap_page_create(struct inode *inode, struct folio *folio, unsigned int flags)
>  {
>  	struct iomap_page *iop = to_iomap_page(folio);
>  	unsigned int nr_blocks = i_blocks_per_folio(inode, folio);
> +	gfp_t gfp = GFP_NOFS | __GFP_NOFAIL;
>  
>  	if (iop || nr_blocks <= 1)
>  		return iop;
>  
> +	if (flags & IOMAP_NOWAIT)
> +		gfp = GFP_NOWAIT;
> +

Maybe this would confuse people less if it was:

	if (flags & IOMAP_NOWAIT)
		gfp = GFP_NOWAIT;
	else
		gfp = GFP_NOFS | __GFP_NOFAIL;

but even as is it is perfectly fine (and I tend to write these kinds of
shortcuts as well).

Looks good either way:

Reviewed-by: Christoph Hellwig <hch@lst.de>
