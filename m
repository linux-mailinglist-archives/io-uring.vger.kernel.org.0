Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0A6952CE22
	for <lists+io-uring@lfdr.de>; Thu, 19 May 2022 10:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235321AbiESITJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 May 2022 04:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235426AbiESISv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 May 2022 04:18:51 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB0CB66AD2;
        Thu, 19 May 2022 01:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ZB+WcPRihjvJB66nTSpRcM0fwO19ta8ZY92q52kEtEo=; b=TRU1vsxraCiNP2wKIH1sxGogi7
        KRi7lmoAFEwfbbRdZWKVfG0M7UkSz0m3Rr4uJalbzroPHb6wI1YcEi18mvjxANJYTPto1ZU2OWmJT
        ceXTwUImwwjbyUkOzP45fdh5bN/mWwz5OYG+wj8MYGHJ7PNolhavbxElk1GqOJD1jnZkv7yHsr6FF
        4/4DoBdJ0pP3k1lDmKaaAvU948qzj2mniOqW7g7wJL8H5d92OWh/w67XWNOp0B1huc/9oLFj7D5XA
        YPpCiLt5Kxp2APgpD6wHnU69nglLtc99MZsXa6j/iX+8E+cyOXx5QiHcOC+jvWv64XD32Tv0V9ajP
        IAmIHLIw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nrbMo-005kr7-Bj; Thu, 19 May 2022 08:18:42 +0000
Date:   Thu, 19 May 2022 01:18:42 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz
Subject: Re: [RFC PATCH v3 02/18] iomap: Add iomap_page_create_gfp to
 allocate iomap_pages
Message-ID: <YoX9YgEsnL743FiD@infradead.org>
References: <20220518233709.1937634-1-shr@fb.com>
 <20220518233709.1937634-3-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518233709.1937634-3-shr@fb.com>
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

 * This function returns a newly allocated iomap for the folio with the settings
> + * specified in the gfp parameter.
> + *
> + **/
>  static struct iomap_page *
> -iomap_page_create(struct inode *inode, struct folio *folio)
> +iomap_page_create_gfp(struct inode *inode, struct folio *folio,
> +		unsigned int nr_blocks, gfp_t gfp)
>  {
> -	struct iomap_page *iop = to_iomap_page(folio);
> -	unsigned int nr_blocks = i_blocks_per_folio(inode, folio);
> +	struct iomap_page *iop;
>  
> -	if (iop || nr_blocks <= 1)
> +	iop = kzalloc(struct_size(iop, uptodate, BITS_TO_LONGS(nr_blocks)), gfp);
> +	if (!iop)
>  		return iop;
>  
> -	iop = kzalloc(struct_size(iop, uptodate, BITS_TO_LONGS(nr_blocks)),
> -			GFP_NOFS | __GFP_NOFAIL);
>  	spin_lock_init(&iop->uptodate_lock);
>  	if (folio_test_uptodate(folio))
>  		bitmap_fill(iop->uptodate, nr_blocks);
> @@ -61,6 +71,18 @@ iomap_page_create(struct inode *inode, struct folio *folio)
>  	return iop;
>  }
>  
> +static struct iomap_page *
> +iomap_page_create(struct inode *inode, struct folio *folio)
> +{
> +	struct iomap_page *iop = to_iomap_page(folio);
> +	unsigned int nr_blocks = i_blocks_per_folio(inode, folio);
> +
> +	if (iop || nr_blocks <= 1)
> +		return iop;
> +
> +	return iomap_page_create_gfp(inode, folio, nr_blocks, GFP_NOFS | __GFP_NOFAIL);

Overly long line here.

Mor importantly why do you need a helper that does not do the number
of blocks check?  Why can't we just pass a gfp_t to iomap_page_create?
