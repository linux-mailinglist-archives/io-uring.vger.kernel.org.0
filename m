Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D26E631FE88
	for <lists+io-uring@lfdr.de>; Fri, 19 Feb 2021 19:07:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbhBSSHr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Feb 2021 13:07:47 -0500
Received: from hmm.wantstofly.org ([213.239.204.108]:59320 "EHLO
        mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbhBSSHr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Feb 2021 13:07:47 -0500
Received: by mail.wantstofly.org (Postfix, from userid 1000)
        id 967BD7F4BD; Fri, 19 Feb 2021 20:07:04 +0200 (EET)
Date:   Fri, 19 Feb 2021 20:07:04 +0200
From:   Lennert Buytenhek <buytenh@wantstofly.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        io-uring@vger.kernel.org, David Laight <David.Laight@aculab.com>
Subject: Re: [PATCH v3 2/2] io_uring: add support for IORING_OP_GETDENTS
Message-ID: <20210219180704.GD342512@wantstofly.org>
References: <20210218122640.GA334506@wantstofly.org>
 <20210218122755.GC334506@wantstofly.org>
 <20210219123403.GT2858050@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210219123403.GT2858050@casper.infradead.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Feb 19, 2021 at 12:34:03PM +0000, Matthew Wilcox wrote:

> > IORING_OP_GETDENTS may or may not update the specified directory's
> > file offset, and the file offset should not be relied upon having
> > any particular value during or after an IORING_OP_GETDENTS call.
> 
> This doesn't give me the warm fuzzies.  What I might suggest
> is either passing a parameter to iterate_dir() or breaking out an
> iterate_dir_nofpos() to make IORING_OP_GETDENTS more of a READV operation.
> ie the equivalent of this:
> 
> @@ -37,7 +37,7 @@
>  } while (0)
>  
>  
> -int iterate_dir(struct file *file, struct dir_context *ctx)
> +int iterate_dir(struct file *file, struct dir_context *ctx, bool use_fpos)
>  {
>         struct inode *inode = file_inode(file);
>         bool shared = false;
> @@ -60,12 +60,14 @@ int iterate_dir(struct file *file, struct dir_context *ctx)
>  
>         res = -ENOENT;
>         if (!IS_DEADDIR(inode)) {
> -               ctx->pos = file->f_pos;
> +               if (use_fpos)
> +                       ctx->pos = file->f_pos;
>                 if (shared)
>                         res = file->f_op->iterate_shared(file, ctx);
>                 else
>                         res = file->f_op->iterate(file, ctx);
> -               file->f_pos = ctx->pos;
> +               if (use_fpos)
> +                       file->f_pos = ctx->pos;
>                 fsnotify_access(file);
>                 file_accessed(file);
>         }
> 
> That way there's no need to play with llseek or take a mutex on the
> f_pos of the directory.

I'll try this!
