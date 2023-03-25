Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3139F6C89CA
	for <lists+io-uring@lfdr.de>; Sat, 25 Mar 2023 02:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbjCYBGd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Mar 2023 21:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjCYBGc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Mar 2023 21:06:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4AAB1716E
        for <io-uring@vger.kernel.org>; Fri, 24 Mar 2023 18:06:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C3EFB8208C
        for <io-uring@vger.kernel.org>; Sat, 25 Mar 2023 01:06:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1866C4339C;
        Sat, 25 Mar 2023 01:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679706389;
        bh=HEBymkn8U+uNfR4f9MHOQne17SN3xz2T/U2MofzQVlk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=toIIrlJZiZ5kBLWHCX8qVKjYl9ZUttAghIvSdvty2c2OYJ467rZWg7f2N/hOc8IEE
         dWzcEANpgAjqp2OR0Iq/v4fkfaAx+KJLa7xl+BVL6HdW6Y9WO10TIB7QdarAswsSry
         psd29uix+ODBD2WmqEq4ry59e2kKck9g5AHG6760F+faZbQqm674E0zdYtNHEoaf9U
         GYOlT1hYNFVjVoFPZfN1fFu07PkqOV+WnYwkck2oK5T330tWyQ1CHL7RBFgpyWd/Fm
         PXYyDn2BAyw+JSUUhJ3VVvU1GOSTgCmGqtlY3hthHh7kKDBA+GJRjTMdM44m8h0ilC
         ScCgIM9ksf/cA==
Date:   Fri, 24 Mar 2023 19:06:26 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Subject: Re: [PATCH] io_uring/rw: transform single vector readv/writev into
 ubuf
Message-ID: <ZB5JEmqhfLAJKUO7@kbusch-mbp.dhcp.thefacebook.com>
References: <43cb1fb7-b30b-8df1-bba6-e50797d680c6@kernel.dk>
 <ZB44PG+EFK4Xid/W@kbusch-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZB44PG+EFK4Xid/W@kbusch-mbp.dhcp.thefacebook.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Mar 24, 2023 at 05:54:36PM -0600, Keith Busch wrote:
> On Fri, Mar 24, 2023 at 08:35:38AM -0600, Jens Axboe wrote:
> > @@ -402,7 +402,22 @@ static struct iovec *__io_import_iovec(int ddir, struct io_kiocb *req,
> >  			      req->ctx->compat);
> >  	if (unlikely(ret < 0))
> >  		return ERR_PTR(ret);
> > -	return iovec;
> > +	if (iter->nr_segs != 1)
> > +		return iovec;
> > +	/*
> > +	 * Convert to non-vectored request if we have a single segment. If we
> > +	 * need to defer the request, then we no longer have to allocate and
> > +	 * maintain a struct io_async_rw. Additionally, we won't have cleanup
> > +	 * to do at completion time
> > +	 */
> > +	rw->addr = (unsigned long) iter->iov[0].iov_base;
> > +	rw->len = iter->iov[0].iov_len;
> > +	iov_iter_ubuf(iter, ddir, iter->iov[0].iov_base, rw->len);
> > +	/* readv -> read distance is the same as writev -> write */
> > +	BUILD_BUG_ON((IORING_OP_READ - IORING_OP_READV) !=
> > +			(IORING_OP_WRITE - IORING_OP_WRITEV));
> > +	req->opcode += (IORING_OP_READ - IORING_OP_READV);
> > +	return NULL;
> >  }
> 
> This may break anyone using io_uring with those bizarre drivers that have
> entirely different readv semantics from normal read. I think we can safely say
> no one's using io_uring for such interfaces, so probably a moot point. If you
> wanted to be extra cautious though, you may want to skip this transformation if
> the file->f_op implements both .read+read_iter and .write+.write_iter.

Sorry, scratch that; those drivers are already broken if they implement both
with different semantics, so we can definitely say none of those are using
io_uring. This new patch should be safe then.
