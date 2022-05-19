Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB41252CE44
	for <lists+io-uring@lfdr.de>; Thu, 19 May 2022 10:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234551AbiESIZb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 May 2022 04:25:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiESIZ3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 May 2022 04:25:29 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4A196A053;
        Thu, 19 May 2022 01:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=NMVgWH8Av+/hGKuajJ4b2VmD67IiLz5BfVbltl8x7Rk=; b=wNSo9a3yLDZhwGX5vSnu8bsz/H
        +XKZomAL3wu02/BFL23DGpYhU0CuJ22mPdBv5XPWKw+Ps4D/qSaTKADz7BhXraSpK1JC7717YTlg5
        MjIB5axQHbw8VcU5mKCxCE25Voq42yl7Y1lGjxDOggE4lAlRmtd+3VZJmhrWDgYMU+I46oKqZkjYE
        TOAj6PClBgrVMjjLRFkTK5X3LcZBISJERGzoBPVD3erHPo46MJT9DDkVI2rmaSqmvAkXl2NzBI0+v
        hnHlKxWbVjog/pQcW8kbHO9f+47KrlL+UlPmiZZuvarsirayZ/20Hh4Bd3heyfa3aDHLQpr9DCFko
        USJrzhvQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nrbTM-005omx-39; Thu, 19 May 2022 08:25:28 +0000
Date:   Thu, 19 May 2022 01:25:28 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz
Subject: Re: [RFC PATCH v3 04/18] iomap: Add async buffered write support
Message-ID: <YoX++EWdgyNVOQAI@infradead.org>
References: <20220518233709.1937634-1-shr@fb.com>
 <20220518233709.1937634-5-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518233709.1937634-5-shr@fb.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, May 18, 2022 at 04:36:55PM -0700, Stefan Roesch wrote:
> This adds async buffered write support to iomap. The support is focused
> on the changes necessary to support XFS with iomap.
> 
> Support for other filesystems might require additional changes.

What would those other changes be?  Inline data support should not
matter here, so I guess it is buffer_head support?  Please spell out
the actual limitations instead of the use case.  Preferably including
asserts in the code to catch the case of a file system trying to use
the now supported cases.

> 
> Signed-off-by: Stefan Roesch <shr@fb.com>
> ---
>  fs/iomap/buffered-io.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 6b06fd358958..b029e2b10e07 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -580,12 +580,18 @@ static int __iomap_write_begin(const struct iomap_iter *iter, loff_t pos,
>  	size_t from = offset_in_folio(folio, pos), to = from + len;
>  	size_t poff, plen;
>  	gfp_t  gfp = GFP_NOFS | __GFP_NOFAIL;
> +	bool no_wait = (iter->flags & IOMAP_NOWAIT);
> +
> +	if (no_wait)

Does thi flag really buy us anything?  My preference woud be to see
the IOMAP_NOWAIT directy as that is easier for me to read than trying to
figure out what no_wait actually means.

> +		gfp = GFP_NOWAIT;
>  
>  	if (folio_test_uptodate(folio))
>  		return 0;
>  	folio_clear_error(folio);
>  
>  	iop = iomap_page_create_gfp(iter->inode, folio, nr_blocks, gfp);

And maybe the btter iomap_page_create inteface would be one that passes
the flags so that we can centralize the gfp_t selection.

> @@ -602,6 +608,8 @@ static int __iomap_write_begin(const struct iomap_iter *iter, loff_t pos,
>  			if (WARN_ON_ONCE(iter->flags & IOMAP_UNSHARE))
>  				return -EIO;
>  			folio_zero_segments(folio, poff, from, to, poff + plen);
> +		} else if (no_wait) {
> +			return -EAGAIN;
>  		} else {
>  			int status = iomap_read_folio_sync(block_start, folio,
>  					poff, plen, srcmap);

That's a somewhat unnatural code flow.  I'd much prefer:

		} else {
			int status;

			if (iter->flags & IOMAP_NOWAIT)
				return -EAGAIN;
			iomap_read_folio_sync(block_start, folio,
					poff, plen, srcmap);

Or maybe even pass the iter to iomap_read_folio_sync and just do the
IOMAP_NOWAIT check there.
