Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F95770E0B4
	for <lists+io-uring@lfdr.de>; Tue, 23 May 2023 17:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237499AbjEWPjR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 May 2023 11:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233770AbjEWPjQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 May 2023 11:39:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A4AF11A;
        Tue, 23 May 2023 08:39:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5A25615E2;
        Tue, 23 May 2023 15:39:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E4AAC433EF;
        Tue, 23 May 2023 15:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684856354;
        bh=KOcyZ19L4AlfnOXdZXmoI91i3uvwElF0P4WDlZk+yvE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=elhoKLKis6peqVdy57qfugtTGrsRwvvp2zEa7BY9RigRocQqK3VUS/qRTp8xpRk2P
         2+AxAOrKvdlc7/ZBp6Pnpr6+x40qxAXhvsSU7WePHrE1ZBzFKIc1A9uYl4e3Qa32rb
         KMVoGOYQq2Q+IFTo3tPrNany/v4uTTBsZd1AKf2ch42DMUvD9ZHVz2KZ/3gZl9NBwM
         p6wJQq5vtdDksm+Er4dgcED1F6hF3Lj8AfWUOgK/S9ejnWcU713Yq4biEYiz1SfmbC
         nNvJqVXc8NK7tJwfSXfLApdT8NaqMam3zih2CgD4gbmiN6mcITR3eXeMvCufLB9MY7
         lYxQiVYC5YhUQ==
Date:   Tue, 23 May 2023 17:39:08 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org
Subject: Re: [PATCH v2 1/6] fs: split off vfs_getdents function of getdents64
 syscall
Message-ID: <20230523-entzug-komodowaran-96d003250f70@brauner>
References: <20230422-uring-getdents-v2-0-2db1e37dc55e@codewreck.org>
 <20230422-uring-getdents-v2-1-2db1e37dc55e@codewreck.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230422-uring-getdents-v2-1-2db1e37dc55e@codewreck.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, May 10, 2023 at 07:52:49PM +0900, Dominique Martinet wrote:
> This splits off the vfs_getdents function from the getdents64 system
> call.
> This will allow io_uring to call the vfs_getdents function.
> 
> Co-authored-by: Stefan Roesch <shr@fb.com>
> Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
> ---
>  fs/internal.h |  8 ++++++++
>  fs/readdir.c  | 34 ++++++++++++++++++++++++++--------
>  2 files changed, 34 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/internal.h b/fs/internal.h
> index bd3b2810a36b..e8ca000e6613 100644
> --- a/fs/internal.h
> +++ b/fs/internal.h
> @@ -260,3 +260,11 @@ ssize_t __kernel_write_iter(struct file *file, struct iov_iter *from, loff_t *po
>  struct mnt_idmap *alloc_mnt_idmap(struct user_namespace *mnt_userns);
>  struct mnt_idmap *mnt_idmap_get(struct mnt_idmap *idmap);
>  void mnt_idmap_put(struct mnt_idmap *idmap);
> +
> +/*
> + * fs/readdir.c
> + */
> +struct linux_dirent64;
> +
> +int vfs_getdents(struct file *file, struct linux_dirent64 __user *dirent,
> +		 unsigned int count);
> diff --git a/fs/readdir.c b/fs/readdir.c
> index 9c53edb60c03..ed0803d0011e 100644
> --- a/fs/readdir.c
> +++ b/fs/readdir.c
> @@ -21,6 +21,7 @@
>  #include <linux/unistd.h>
>  #include <linux/compat.h>
>  #include <linux/uaccess.h>
> +#include "internal.h"
>  
>  #include <asm/unaligned.h>
>  
> @@ -351,10 +352,16 @@ static bool filldir64(struct dir_context *ctx, const char *name, int namlen,
>  	return false;
>  }
>  
> -SYSCALL_DEFINE3(getdents64, unsigned int, fd,
> -		struct linux_dirent64 __user *, dirent, unsigned int, count)
> +
> +/**
> + * vfs_getdents - getdents without fdget
> + * @file    : pointer to file struct of directory
> + * @dirent  : pointer to user directory structure
> + * @count   : size of buffer
> + */
> +int vfs_getdents(struct file *file, struct linux_dirent64 __user *dirent,
> +		 unsigned int count)
>  {
> -	struct fd f;
>  	struct getdents_callback64 buf = {
>  		.ctx.actor = filldir64,
>  		.count = count,
> @@ -362,11 +369,7 @@ SYSCALL_DEFINE3(getdents64, unsigned int, fd,
>  	};
>  	int error;
>  
> -	f = fdget_pos(fd);
> -	if (!f.file)
> -		return -EBADF;
> -
> -	error = iterate_dir(f.file, &buf.ctx);
> +	error = iterate_dir(file, &buf.ctx);

So afaict this isn't enough.
If you look into iterate_shared() you should see that it uses and
updates f_pos. But that can't work for io_uring and also isn't how
io_uring handles read and write. You probably need to use a local pos
similar to what io_uring does in rw.c for rw->kiocb.ki_pos. But in
contrast simply disallow any offsets for getdents completely. Thus not
relying on f_pos anywhere at all.
