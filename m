Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62D7D6A9C6F
	for <lists+io-uring@lfdr.de>; Fri,  3 Mar 2023 17:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbjCCQyn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Mar 2023 11:54:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbjCCQym (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Mar 2023 11:54:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06F521164E;
        Fri,  3 Mar 2023 08:54:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51605B81902;
        Fri,  3 Mar 2023 16:53:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAF03C433EF;
        Fri,  3 Mar 2023 16:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677862381;
        bh=2/MxGsA+UeJoeA0qwShKf6lp6y22SPH559LMbaOGOUc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Fy8mUh8ElUxKUrQu+GRfoNvC6ZR30x5Qv1MpnJHepd3jPizO5xu0Av5rz58V1z2c1
         wSGjGASRIwKn7tYhJUGFdludgRmW7l4z7zUljb+qMLenmvY/HLlhjciprzRwsw0Xx6
         KT05LR8AGH5lNYPhT6xuVBXLBVbi/vAMWIFb91Wi+TfsASsGP+3aTQKA2e+P8ped8N
         KULknt2iIyjBpzgHFg/ReRS34jeBtxky9u4iTD3M/T2XoZNNRFBCveAqlK4pB5GbFf
         E0RBumj48mLkl4U2UhehD1j75tWcTryyJOHJJ11UL30aj4gn/ObA/d+jErlQxW5eJs
         nALyEce2ffbbA==
Date:   Fri, 3 Mar 2023 08:53:00 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Stefan Roesch <shr@fb.com>, io-uring@vger.kernel.org,
        kernel-team@fb.com, linux-mm@kvack.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, david@fromorbit.com, jack@suse.cz,
        hch@infradead.org, axboe@kernel.dk, Christoph Hellwig <hch@lst.de>
Subject: Re: [RESEND PATCH v9 04/14] iomap: Add flags parameter to
 iomap_page_create()
Message-ID: <ZAIl7JfPXivtN8qm@magnolia>
References: <20220623175157.1715274-1-shr@fb.com>
 <20220623175157.1715274-5-shr@fb.com>
 <ZAF8vk6Jns/40bc0@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAF8vk6Jns/40bc0@casper.infradead.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Mar 03, 2023 at 04:51:10AM +0000, Matthew Wilcox wrote:
> On Thu, Jun 23, 2022 at 10:51:47AM -0700, Stefan Roesch wrote:
> > Add the kiocb flags parameter to the function iomap_page_create().
> > Depending on the value of the flags parameter it enables different gfp
> > flags.
> > 
> > No intended functional changes in this patch.
> 
> [...]
> 
> > @@ -226,7 +234,7 @@ static int iomap_read_inline_data(const struct iomap_iter *iter,
> >  	if (WARN_ON_ONCE(size > iomap->length))
> >  		return -EIO;
> >  	if (offset > 0)
> > -		iop = iomap_page_create(iter->inode, folio);
> > +		iop = iomap_page_create(iter->inode, folio, iter->flags);
> >  	else
> >  		iop = to_iomap_page(folio);
> 
> I really don't like what this change has done to this file.  I'm
> modifying this function, and I start thinking "Well, hang on, if
> flags has IOMAP_NOWAIT set, then GFP_NOWAIT can fail, and iop
> will be NULL, so we'll end up marking the entire folio uptodate
> when really we should only be marking some blocks uptodate, so
> we should really be failing the entire read if the allocation
> failed, but maybe it's OK because IOMAP_NOWAIT is never set in
> this path".
> 
> I don't know how we fix this.  Maybe return ERR_PTR(-ENOMEM) or
> -EAGAIN if the memory allocation fails (leaving the NULL return
> for "we don't need an iop").  Thoughts?

I don't see any problem with that, aside from being pre-coffee and on
vacation for the rest of today. ;)

--D
