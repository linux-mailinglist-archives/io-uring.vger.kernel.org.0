Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5211F53BC6D
	for <lists+io-uring@lfdr.de>; Thu,  2 Jun 2022 18:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236984AbiFBQZ0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Jun 2022 12:25:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232191AbiFBQZZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Jun 2022 12:25:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9EF21BFEE3;
        Thu,  2 Jun 2022 09:25:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66CDB6158E;
        Thu,  2 Jun 2022 16:25:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0111C385A5;
        Thu,  2 Jun 2022 16:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654187123;
        bh=7UcCRqSpD2TdOJD14ymFMXRaY45q56kpZGZdkaGsnKQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MNShMMeG4c42ZH87g7ktWoewKnCkJ0x+OBUEFScT7poN+BVT3/KTsdfrVfubu3xFh
         gX0WyJZYTQfoetCbcZwhawgyE3/XwS+IhzqdZrqV2EZMxlXYufvxFZMUd4Rhwn4wRY
         r/CMsFWkRJCwG1j0nmCj2YoVVnYcYti40O+ZlLTguoUKBlj197sL2tP6UO4ZKJldKB
         vwG/gkJ8ATlxLguIWG5OXmIdYWflgIVzn6aGxNQvytFyImK+p0NbgkP49cJFdbYAPc
         jvI3l8NGONrqt6mZNMf8fZAJloIidjICf6YmtrCnad8s/1PjokAEGLDTcvOqVv6cgN
         AxkcLSMGCBWvg==
Date:   Thu, 2 Jun 2022 09:25:23 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org,
        axboe@kernel.dk, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v7 14/15] xfs: Specify lockmode when calling
 xfs_ilock_for_iomap()
Message-ID: <Ypjkc3d1tnTeWseg@magnolia>
References: <20220601210141.3773402-1-shr@fb.com>
 <20220601210141.3773402-15-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220601210141.3773402-15-shr@fb.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jun 01, 2022 at 02:01:40PM -0700, Stefan Roesch wrote:
> This patch changes the helper function xfs_ilock_for_iomap such that the
> lock mode must be passed in.
> 
> Signed-off-by: Stefan Roesch <shr@fb.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

LGTM
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_iomap.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 5a393259a3a3..bcf7c3694290 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -664,7 +664,7 @@ xfs_ilock_for_iomap(
>  	unsigned		flags,
>  	unsigned		*lockmode)
>  {
> -	unsigned		mode = XFS_ILOCK_SHARED;
> +	unsigned int		mode = *lockmode;
>  	bool			is_write = flags & (IOMAP_WRITE | IOMAP_ZERO);
>  
>  	/*
> @@ -742,7 +742,7 @@ xfs_direct_write_iomap_begin(
>  	int			nimaps = 1, error = 0;
>  	bool			shared = false;
>  	u16			iomap_flags = 0;
> -	unsigned		lockmode;
> +	unsigned int		lockmode = XFS_ILOCK_SHARED;
>  
>  	ASSERT(flags & (IOMAP_WRITE | IOMAP_ZERO));
>  
> @@ -1172,7 +1172,7 @@ xfs_read_iomap_begin(
>  	xfs_fileoff_t		end_fsb = xfs_iomap_end_fsb(mp, offset, length);
>  	int			nimaps = 1, error = 0;
>  	bool			shared = false;
> -	unsigned		lockmode;
> +	unsigned int		lockmode = XFS_ILOCK_SHARED;
>  
>  	ASSERT(!(flags & (IOMAP_WRITE | IOMAP_ZERO)));
>  
> -- 
> 2.30.2
> 
