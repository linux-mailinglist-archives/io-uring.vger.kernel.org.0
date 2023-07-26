Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 965C77641F2
	for <lists+io-uring@lfdr.de>; Thu, 27 Jul 2023 00:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbjGZWOn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Jul 2023 18:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbjGZWOn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Jul 2023 18:14:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78AEC270E;
        Wed, 26 Jul 2023 15:14:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1369D61CD9;
        Wed, 26 Jul 2023 22:14:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CCF0C433C8;
        Wed, 26 Jul 2023 22:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690409681;
        bh=egdqwbn07wMpy4n0nNbgk+Y5rjF+a39thHupWZUic9o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CUMJYy0LXaNgi1LZB06GxmhHfiojM2rDGziXwwBvtdzM5QWCWwdVWcs7FhIy8wACH
         ldhlZvTNLgxKJG8gjAL74Cp8sD1hcqfPXW7glxvSjQgXmY4M0BWs9qE6ebP5GRE2H0
         g+9MQ3IBXqcOHwDUgN5t0V9r5E0qL5MrEmbWi3P1qo+qnAvjaGA4TEQtxV1uEFqFaF
         ixzhTylfDqf+740uEkk65jt4r8OSPk6qNpP/7Lp1sldobbroz4+MsBsq/yAM0x8yY8
         dGkxITTXR2MXurk8ioXn18CZHjQ34iqdYXPm1T+bpO66IBVf+Ux3enZCNSvYS2Uy3Y
         w8gTVL5hP139A==
Date:   Wed, 26 Jul 2023 15:14:40 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Hao Xu <hao.xu@linux.dev>, io-uring@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH 2/7] xfs: add nowait support for xfs_seek_iomap_begin()
Message-ID: <20230726221440.GB11352@frogsfrogsfrogs>
References: <20230726102603.155522-1-hao.xu@linux.dev>
 <20230726102603.155522-3-hao.xu@linux.dev>
 <ZMGWYyNz6SUTdRef@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZMGWYyNz6SUTdRef@dread.disaster.area>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jul 27, 2023 at 07:55:47AM +1000, Dave Chinner wrote:
> On Wed, Jul 26, 2023 at 06:25:58PM +0800, Hao Xu wrote:
> > From: Hao Xu <howeyxu@tencent.com>
> > 
> > To support nowait llseek(), IOMAP_NOWAIT semantics should be respected.
> > In xfs, xfs_seek_iomap_begin() is the only place which may be blocked
> > by ilock and extent loading. Let's turn it into trylock logic just like
> > what we've done in xfs_readdir().
> > 
> > Signed-off-by: Hao Xu <howeyxu@tencent.com>
> > ---
> >  fs/xfs/xfs_iomap.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> > index 18c8f168b153..bbd7c6b27701 100644
> > --- a/fs/xfs/xfs_iomap.c
> > +++ b/fs/xfs/xfs_iomap.c
> > @@ -1294,7 +1294,9 @@ xfs_seek_iomap_begin(
> >  	if (xfs_is_shutdown(mp))
> >  		return -EIO;
> >  
> > -	lockmode = xfs_ilock_data_map_shared(ip);
> > +	lockmode = xfs_ilock_data_map_shared_generic(ip, flags & IOMAP_NOWAIT);
> 
> What does this magic XFS function I can't find anywhere in this
> patch set do?

It's in (iirc) the io_uring getdents patchset that wasn't cc'd to
linux-xfs and that I haven't looked at yet.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
