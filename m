Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F18A6A904F
	for <lists+io-uring@lfdr.de>; Fri,  3 Mar 2023 05:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbjCCEvW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Mar 2023 23:51:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjCCEvU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Mar 2023 23:51:20 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1D7A20D3D;
        Thu,  2 Mar 2023 20:51:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Ptw2ZnLTY0tDIM3vATa4+dkiTkNFGKYnNtBzD29zdII=; b=dSCigbXH/7YIFjdjERUzIKAh07
        7LYO4Kp1YVDjqGehapqANvhPmksi8Qc7UIf1Xi4mhp19ewaKPy8E5ce0CgYf/c9tSl+nfCgfe9g01
        NQy9HGa4fdICvM2n1eG6uE8NM3kIsEEGQXoLRpGnA2SagYdLvIAqT3TRn05t39huO9Ohvak2CKFX2
        pLiRrhEhv9CFhW7IQzqI2xpQPNhpFRnkcn24GcDM1HeRDXpUclXI5YLAqdy4+7LpCslbVt5rT0rBI
        LQLXe1Lypkr6K8CtksXYpx/OnxdKyjHX/Q8dHMzVbmLimDdnm+wD7kWOq4kuvwYsjvkNZmxWa2T4o
        0TzuGJYA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pXxNu-002tMn-EB; Fri, 03 Mar 2023 04:51:10 +0000
Date:   Fri, 3 Mar 2023 04:51:10 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org,
        axboe@kernel.dk, Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [RESEND PATCH v9 04/14] iomap: Add flags parameter to
 iomap_page_create()
Message-ID: <ZAF8vk6Jns/40bc0@casper.infradead.org>
References: <20220623175157.1715274-1-shr@fb.com>
 <20220623175157.1715274-5-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623175157.1715274-5-shr@fb.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jun 23, 2022 at 10:51:47AM -0700, Stefan Roesch wrote:
> Add the kiocb flags parameter to the function iomap_page_create().
> Depending on the value of the flags parameter it enables different gfp
> flags.
> 
> No intended functional changes in this patch.

[...]

> @@ -226,7 +234,7 @@ static int iomap_read_inline_data(const struct iomap_iter *iter,
>  	if (WARN_ON_ONCE(size > iomap->length))
>  		return -EIO;
>  	if (offset > 0)
> -		iop = iomap_page_create(iter->inode, folio);
> +		iop = iomap_page_create(iter->inode, folio, iter->flags);
>  	else
>  		iop = to_iomap_page(folio);

I really don't like what this change has done to this file.  I'm
modifying this function, and I start thinking "Well, hang on, if
flags has IOMAP_NOWAIT set, then GFP_NOWAIT can fail, and iop
will be NULL, so we'll end up marking the entire folio uptodate
when really we should only be marking some blocks uptodate, so
we should really be failing the entire read if the allocation
failed, but maybe it's OK because IOMAP_NOWAIT is never set in
this path".

I don't know how we fix this.  Maybe return ERR_PTR(-ENOMEM) or
-EAGAIN if the memory allocation fails (leaving the NULL return
for "we don't need an iop").  Thoughts?
