Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3226C5303DF
	for <lists+io-uring@lfdr.de>; Sun, 22 May 2022 17:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344769AbiEVPfb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 22 May 2022 11:35:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241366AbiEVPfa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 22 May 2022 11:35:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 788CA27FED;
        Sun, 22 May 2022 08:35:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14F5760FF3;
        Sun, 22 May 2022 15:35:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 636F3C385AA;
        Sun, 22 May 2022 15:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653233728;
        bh=YXTIrOj8iGM+Es7V2nzotlSJAwHMwEsEUSy0fGR2HAQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j0fZohjwZfLrTlKglgtdEhVQmd9GF0M4XVflv078ghl3pPL0XS5q2mZY1gy/xXwhu
         YTO1jY7DEoKy9wJ9R8N4md6aMyKssVH6GJ/ZT0pB0aXfv2WDUHt4Uwt+F8+tLdX1D6
         1o5yYN1BLZu1YIVGOVhkMI/CXBIXtockL89ZimwKDXu6i5wCX6bdSSLnbm+b/TIZz5
         S1ioDBT/1EqjMvpnqZ4J2ZNaeUVymhxXAwhsYouGqiulznEgec6sX9P3k1aepxQwXi
         tLnUhf45xV+ev7iENlRM9mnhRO2Vn7M+dfyYkHtxBzx9eIf5qSAUAn49OblXeYTkMf
         voOJDnCkXnBzQ==
Date:   Sun, 22 May 2022 08:35:27 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org
Subject: Re: [RFC PATCH v4 16/17] xfs: Add async buffered write support
Message-ID: <YopYP9vI7E7LbjiD@magnolia>
References: <20220520183646.2002023-1-shr@fb.com>
 <20220520183646.2002023-17-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220520183646.2002023-17-shr@fb.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, May 20, 2022 at 11:36:45AM -0700, Stefan Roesch wrote:
> This adds the async buffered write support to XFS. For async buffered
> write requests, the request will return -EAGAIN if the ilock cannot be
> obtained immediately.
> 
> This splits off a new helper xfs_ilock_inode from the existing helper
> xfs_ilock_iocb so it can be used for this function. The exising helper
> cannot be used as it hardcoded the inode to be used.
> 
> Signed-off-by: Stefan Roesch <shr@fb.com>
> ---
>  fs/xfs/xfs_file.c | 32 +++++++++++++++-----------------
>  1 file changed, 15 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 793918c83755..ad3175b7d366 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -190,14 +190,13 @@ xfs_file_fsync(
>  	return error;
>  }
>  
> -static int
> -xfs_ilock_iocb(
> -	struct kiocb		*iocb,
> +static inline int
> +xfs_ilock_xfs_inode(

A couple of nitpicky things:

"ilock" is shorthand for "inode lock", which means this name expands to
"xfs inode lock xfs inode", which is redundant.  Seeing as the whole
point of this function is to take a particular inode lock with a
particular set of IOCB flags, just leave the name as it was.

> +	struct xfs_inode	*ip,
> +	int			flags,

"iocb_flags", not "flags", to reinforce what kind of flags are supposed
to be passed in here.

--D

>  	unsigned int		lock_mode)
>  {
> -	struct xfs_inode	*ip = XFS_I(file_inode(iocb->ki_filp));
> -
> -	if (iocb->ki_flags & IOCB_NOWAIT) {
> +	if (flags & IOCB_NOWAIT) {
>  		if (!xfs_ilock_nowait(ip, lock_mode))
>  			return -EAGAIN;
>  	} else {
> @@ -222,7 +221,7 @@ xfs_file_dio_read(
>  
>  	file_accessed(iocb->ki_filp);
>  
> -	ret = xfs_ilock_iocb(iocb, XFS_IOLOCK_SHARED);
> +	ret = xfs_ilock_xfs_inode(ip, iocb->ki_flags, XFS_IOLOCK_SHARED);
>  	if (ret)
>  		return ret;
>  	ret = iomap_dio_rw(iocb, to, &xfs_read_iomap_ops, NULL, 0, 0);
> @@ -244,7 +243,7 @@ xfs_file_dax_read(
>  	if (!iov_iter_count(to))
>  		return 0; /* skip atime */
>  
> -	ret = xfs_ilock_iocb(iocb, XFS_IOLOCK_SHARED);
> +	ret = xfs_ilock_xfs_inode(ip, iocb->ki_flags, XFS_IOLOCK_SHARED);
>  	if (ret)
>  		return ret;
>  	ret = dax_iomap_rw(iocb, to, &xfs_read_iomap_ops);
> @@ -264,7 +263,7 @@ xfs_file_buffered_read(
>  
>  	trace_xfs_file_buffered_read(iocb, to);
>  
> -	ret = xfs_ilock_iocb(iocb, XFS_IOLOCK_SHARED);
> +	ret = xfs_ilock_xfs_inode(ip, iocb->ki_flags, XFS_IOLOCK_SHARED);
>  	if (ret)
>  		return ret;
>  	ret = generic_file_read_iter(iocb, to);
> @@ -343,7 +342,7 @@ xfs_file_write_checks(
>  	if (*iolock == XFS_IOLOCK_SHARED && !IS_NOSEC(inode)) {
>  		xfs_iunlock(ip, *iolock);
>  		*iolock = XFS_IOLOCK_EXCL;
> -		error = xfs_ilock_iocb(iocb, *iolock);
> +		error = xfs_ilock_xfs_inode(ip, iocb->ki_flags, *iolock);
>  		if (error) {
>  			*iolock = 0;
>  			return error;
> @@ -516,7 +515,7 @@ xfs_file_dio_write_aligned(
>  	int			iolock = XFS_IOLOCK_SHARED;
>  	ssize_t			ret;
>  
> -	ret = xfs_ilock_iocb(iocb, iolock);
> +	ret = xfs_ilock_xfs_inode(ip, iocb->ki_flags, iolock);
>  	if (ret)
>  		return ret;
>  	ret = xfs_file_write_checks(iocb, from, &iolock);
> @@ -583,7 +582,7 @@ xfs_file_dio_write_unaligned(
>  		flags = IOMAP_DIO_FORCE_WAIT;
>  	}
>  
> -	ret = xfs_ilock_iocb(iocb, iolock);
> +	ret = xfs_ilock_xfs_inode(ip, iocb->ki_flags, iolock);
>  	if (ret)
>  		return ret;
>  
> @@ -659,7 +658,7 @@ xfs_file_dax_write(
>  	ssize_t			ret, error = 0;
>  	loff_t			pos;
>  
> -	ret = xfs_ilock_iocb(iocb, iolock);
> +	ret = xfs_ilock_xfs_inode(ip, iocb->ki_flags, iolock);
>  	if (ret)
>  		return ret;
>  	ret = xfs_file_write_checks(iocb, from, &iolock);
> @@ -702,12 +701,11 @@ xfs_file_buffered_write(
>  	bool			cleared_space = false;
>  	int			iolock;
>  
> -	if (iocb->ki_flags & IOCB_NOWAIT)
> -		return -EOPNOTSUPP;
> -
>  write_retry:
>  	iolock = XFS_IOLOCK_EXCL;
> -	xfs_ilock(ip, iolock);
> +	ret = xfs_ilock_xfs_inode(ip, iocb->ki_flags, iolock);
> +	if (ret)
> +		return ret;
>  
>  	ret = xfs_file_write_checks(iocb, from, &iolock);
>  	if (ret)
> -- 
> 2.30.2
> 
