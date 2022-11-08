Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37F0C621D9B
	for <lists+io-uring@lfdr.de>; Tue,  8 Nov 2022 21:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbiKHUZX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Nov 2022 15:25:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiKHUZV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Nov 2022 15:25:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEFF8220CA;
        Tue,  8 Nov 2022 12:25:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A78FB81C5A;
        Tue,  8 Nov 2022 20:25:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AED4C433C1;
        Tue,  8 Nov 2022 20:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667939118;
        bh=wXEswFWuG2tQo7Tnb0pvYwCXkAjnonOEVkUfYNxqkwc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YkQcvDrAQotZwQhiSWSK43CjScOjHmtP5vUwBKd5HD9xe45RI2BCfhQSv7PICTxLs
         V/zzdc2lhKIsei2walEd+LRF1WgMGE9cUICbgj7xV9xRXOvYDm2mfcrZHF70DXM3wD
         LMDagCWbekXd/LHtas+I7/1obzGB18aklKqCg862pqRNRUrhi5ThahtM3prfzMnlZr
         6LtnasQqbJo4rY9jsMJcoczfImtbrBlXiaj9k234JF1thtuPolVlnlJDWE/2IJuliM
         Lt0LeuPyj3Spy1CmX1WDum7SExVVkJ9NPoC6wWyQJsPZr69+MxQdEfOWlnhVIAg82T
         pnrnDotZRdwYg==
Date:   Tue, 8 Nov 2022 13:25:14 -0700
From:   Keith Busch <kbusch@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Keith Busch <kbusch@meta.com>, viro@zeniv.linux.org.uk,
        axboe@kernel.dk, io-uring@vger.kernel.org, asml.silence@gmail.com,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/4] io_uring: use ITER_UBUF
Message-ID: <Y2q7Kn4tDlaKCVMS@kbusch-mbp>
References: <20221107175610.349807-1-kbusch@meta.com>
 <Y2n9DteukhGuvdGe@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2n9DteukhGuvdGe@infradead.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Nov 07, 2022 at 10:54:06PM -0800, Christoph Hellwig wrote:
> On Mon, Nov 07, 2022 at 09:56:06AM -0800, Keith Busch wrote:
> >   1. io_uring will always prefer using the _iter versions of read/write
> >      callbacks if file_operations implement both, where as the generic
> >      syscalls will use .read/.write (if implemented) for non-vectored IO.
> 
> There are very few file operations that have both, and for those
> the difference matters, e.g. the strange vectors semantics for the
> sound code. 
 
Yes, thankfully there are not many. Other than the two mentioned
file_operations, the only other fops I find implementing both are
'null_ops' and 'zero_ops'; those are fine. And one other implements
just .write/.write_iter: trace_events_user.c, which is also fine.

> I would strongly suggest to mirror what the normal
> read/write path does here.

I don't think we can change that now. io_uring has always used the
.{read,write}_iter callbacks if available ever since it introduced
non-vectored read/write (3a6820f2bb8a0). Altering the io_uring op's ABI
to align with the read/write syscalls seems risky.

But I don't think there are any real use cases affected by this series
anyway.

> >   2. io_uring will use the ITER_UBUF representation for single vector
> >      readv/writev, but the generic syscalls currently uses ITER_IOVEC for
> >      these.
> 
> Same here.  It might be woth to use ITER_UBUF for single vector
> readv/writev, but this should be the same for all interfaces.  I'd
> suggest to drop this for now and do a separate series with careful
> review from Al for this.

I feel like that's a worthy longer term goal, but I'll start looking
into it now.
