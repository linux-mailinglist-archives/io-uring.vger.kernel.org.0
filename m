Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C11A750619
	for <lists+io-uring@lfdr.de>; Wed, 12 Jul 2023 13:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbjGLLcF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Jul 2023 07:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjGLLcE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Jul 2023 07:32:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D088F;
        Wed, 12 Jul 2023 04:32:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58ECC6175C;
        Wed, 12 Jul 2023 11:32:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B10FC433C8;
        Wed, 12 Jul 2023 11:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689161522;
        bh=9rx2MR9wSkgBD2w9pp+VSGyTVTC8YI5+oIEH0fAB128=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OlFIxEhEbKQ3iYu6vGcZjHyC3ycs44DU5RAlbarUtaC9eOLPWnF7DogkuczkCJ1ZW
         uKUdMXVlKwesxfAZ2TyeMLefeNirO3RYF2ojP75/wD0qN5O4SfijQ9+yPeZHtYjDs1
         lQ3WjNp35BTcH0gNvT0cmJj9csA8ZSl9qsbHw+x2qRXwoZ37p1sqITUELGDv0Z6cks
         +A5sy2XMks46C1BWVnTJ1kxHxSbP03qbukav/7e6UhrG5rnnZzs2xatp8fTTaMTeOg
         LcdUtw6cgCuWWtdyma6i7pMsvhi5agSW5uvEbEYJOcDOGsWfpvKqLL/6ASobwH+3DO
         Blamj3TcYCNOA==
Date:   Wed, 12 Jul 2023 13:31:57 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Hao Xu <hao.xu@linux.dev>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH 2/3] vfs_getdents/struct dir_context: add flags field
Message-ID: <20230712-halbleiter-weder-35e042adcb30@brauner>
References: <20230711114027.59945-1-hao.xu@linux.dev>
 <20230711114027.59945-3-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230711114027.59945-3-hao.xu@linux.dev>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jul 11, 2023 at 07:40:26PM +0800, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> The flags will allow passing DIR_CONTEXT_F_NOWAIT to iterate()
> implementations that support it (as signaled through FMODE_NWAIT
> in file->f_mode)
> 
> Notes:
> - considered using IOCB_NOWAIT but if we add more flags later it
> would be confusing to keep track of which values are valid, use
> dedicated flags
> - might want to check ctx.flags & DIR_CONTEXT_F_NOWAIT is only set
> when file->f_mode & FMODE_NOWAIT in iterate_dir() as e.g. WARN_ONCE?
> 
> Co-developed-by: Dominique Martinet <asmadeus@codewreck.org>
> Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
> Signed-off-by: Hao Xu <howeyxu@tencent.com>
> ---
>  fs/internal.h      | 2 +-
>  fs/readdir.c       | 6 ++++--
>  include/linux/fs.h | 8 ++++++++
>  3 files changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/internal.h b/fs/internal.h
> index b1f66e52d61b..7508d485c655 100644
> --- a/fs/internal.h
> +++ b/fs/internal.h
> @@ -311,4 +311,4 @@ void mnt_idmap_put(struct mnt_idmap *idmap);
>  struct linux_dirent64;
>  
>  int vfs_getdents(struct file *file, struct linux_dirent64 __user *dirent,
> -		 unsigned int count);
> +		 unsigned int count, unsigned long flags);
> diff --git a/fs/readdir.c b/fs/readdir.c
> index 9592259b7e7f..b80caf4c9321 100644
> --- a/fs/readdir.c
> +++ b/fs/readdir.c
> @@ -358,12 +358,14 @@ static bool filldir64(struct dir_context *ctx, const char *name, int namlen,
>   * @file    : pointer to file struct of directory
>   * @dirent  : pointer to user directory structure
>   * @count   : size of buffer
> + * @flags   : additional dir_context flags

Why do you need that flag argument. The ->iterate{_shared}() i_op gets
passed the file so the filesystem can check
@file->f_mode & FMODE_NOWAIT, no?

>   */
>  int vfs_getdents(struct file *file, struct linux_dirent64 __user *dirent,
> -		 unsigned int count)
> +		 unsigned int count, unsigned long flags)
>  {
>  	struct getdents_callback64 buf = {
>  		.ctx.actor = filldir64,
> +		.ctx.flags = flags,
>  		.count = count,
>  		.current_dir = dirent
>  	};
> @@ -395,7 +397,7 @@ SYSCALL_DEFINE3(getdents64, unsigned int, fd,
>  	if (!f.file)
>  		return -EBADF;
>  
> -	error = vfs_getdents(f.file, dirent, count);
> +	error = vfs_getdents(f.file, dirent, count, 0);
>  
>  	fdput_pos(f);
>  	return error;
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 6867512907d6..f3e315e8efdd 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1719,8 +1719,16 @@ typedef bool (*filldir_t)(struct dir_context *, const char *, int, loff_t, u64,
>  struct dir_context {
>  	filldir_t actor;
>  	loff_t pos;
> +	unsigned long flags;
>  };
>  
> +/*
> + * flags for dir_context flags
> + * DIR_CONTEXT_F_NOWAIT: Request non-blocking iterate
> + *                       (requires file->f_mode & FMODE_NOWAIT)
> + */
> +#define DIR_CONTEXT_F_NOWAIT	(1 << 0)

Even if this should be needed, I don't think this needs to use a full
flags field.
