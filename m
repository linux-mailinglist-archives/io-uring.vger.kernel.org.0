Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63D1B535024
	for <lists+io-uring@lfdr.de>; Thu, 26 May 2022 15:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239082AbiEZNoA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 26 May 2022 09:44:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231330AbiEZNn7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 26 May 2022 09:43:59 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0412CDFEB;
        Thu, 26 May 2022 06:43:58 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id A970821A06;
        Thu, 26 May 2022 13:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1653572636; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UpK3/+mflNhNMKFUzS8sRLaHIEJ6kOwAbvdU09gMH7s=;
        b=3LryFXFDC3AdXNd2lRAYNMZxlZT+62FzmWr4B8ftgsP6BcWFelARCV2g3tqqyflpefmbZC
        V0TO6tAhWU4d11Zz3OOY5idYus/ihMFEAn8xbzx5CbrfPymCOPoAiHnLNWT/XQO4v7rXUF
        JKZP6bbyQG8k+ISKbPJmd0FYmlUNVDE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1653572636;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UpK3/+mflNhNMKFUzS8sRLaHIEJ6kOwAbvdU09gMH7s=;
        b=51eEm0IOMH3zxagbLh+mvwGB43Gpbh0I3m8y+KDeUxONAAfQ+Q4NcRdjBVzAmxjnQ89Y9M
        yNq1pS9sp/GMhKAA==
Received: from quack3.suse.cz (unknown [10.100.224.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 9A9C32C141;
        Thu, 26 May 2022 13:43:56 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 26532A0632; Thu, 26 May 2022 15:43:56 +0200 (CEST)
Date:   Thu, 26 May 2022 15:43:56 +0200
From:   Jan Kara <jack@suse.cz>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org
Subject: Re: [PATCH v5 04/16] iomap: Add flags parameter to
 iomap_page_create()
Message-ID: <20220526134356.volr3q5ysewszfwo@quack3.lan>
References: <20220525223432.205676-1-shr@fb.com>
 <20220525223432.205676-5-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220525223432.205676-5-shr@fb.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed 25-05-22 15:34:20, Stefan Roesch wrote:
> Add the kiocb flags parameter to the function iomap_page_create().
> Depending on the value of the flags parameter it enables different gfp
> flags.
> 
> No intended functional changes in this patch.
> 
> Signed-off-by: Stefan Roesch <shr@fb.com>

Just one nit below:

> @@ -226,7 +231,7 @@ static int iomap_read_inline_data(const struct iomap_iter *iter,
>  	if (WARN_ON_ONCE(size > iomap->length))
>  		return -EIO;
>  	if (offset > 0)
> -		iop = iomap_page_create(iter->inode, folio);
> +		iop = iomap_page_create(iter->inode, folio, 0);
>  	else
>  		iop = to_iomap_page(folio);
>  
> @@ -264,7 +269,7 @@ static loff_t iomap_readpage_iter(const struct iomap_iter *iter,
>  		return iomap_read_inline_data(iter, folio);
>  
>  	/* zero post-eof blocks as the page may be mapped */
> -	iop = iomap_page_create(iter->inode, folio);
> +	iop = iomap_page_create(iter->inode, folio, 0);
>  	iomap_adjust_read_range(iter->inode, folio, &pos, length, &poff, &plen);
>  	if (plen == 0)
>  		goto done;

Shouldn't we pass iter->flags to iomap_page_create() in the above two call
sites? I know functionally it is no different currently but in the future
it might be less surprising...

With this fixed, feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
