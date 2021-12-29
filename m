Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66A7F48143C
	for <lists+io-uring@lfdr.de>; Wed, 29 Dec 2021 15:52:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240421AbhL2OwG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Dec 2021 09:52:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233850AbhL2OwG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Dec 2021 09:52:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7106FC061574;
        Wed, 29 Dec 2021 06:52:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7322614FF;
        Wed, 29 Dec 2021 14:52:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31744C36AE7;
        Wed, 29 Dec 2021 14:52:01 +0000 (UTC)
Date:   Wed, 29 Dec 2021 15:51:58 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        kernel-team@fb.com, torvalds@linux-foundation.org
Subject: Re: [PATCH v9 4/5] io_uring: add fsetxattr and setxattr support
Message-ID: <20211229145158.ir7h7uii4l46zctu@wittgenstein>
References: <20211228184145.1131605-1-shr@fb.com>
 <20211228184145.1131605-5-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211228184145.1131605-5-shr@fb.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Dec 28, 2021 at 10:41:44AM -0800, Stefan Roesch wrote:
> This adds support to io_uring for the fsetxattr and setxattr API.
> 
> Signed-off-by: Stefan Roesch <shr@fb.com>
> ---
>  fs/io_uring.c                 | 165 ++++++++++++++++++++++++++++++++++
>  include/uapi/linux/io_uring.h |   6 +-
>  2 files changed, 170 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index c8258c784116..2a0138a2876a 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -82,6 +82,7 @@
>  #include <linux/audit.h>
>  #include <linux/security.h>
>  #include <linux/atomic-ref.h>
> +#include <linux/xattr.h>
>  
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/io_uring.h>
> @@ -726,6 +727,12 @@ struct io_async_rw {
>  	struct wait_page_queue		wpq;
>  };
>  
> +struct io_xattr {
> +	struct file			*file;
> +	struct xattr_ctx		ctx;
> +	struct filename			*filename;
> +};
> +
>  enum {
>  	REQ_F_FIXED_FILE_BIT	= IOSQE_FIXED_FILE_BIT,
>  	REQ_F_IO_DRAIN_BIT	= IOSQE_IO_DRAIN_BIT,
> @@ -866,6 +873,7 @@ struct io_kiocb {
>  		struct io_symlink	symlink;
>  		struct io_hardlink	hardlink;
>  		struct io_getdents	getdents;
> +		struct io_xattr		xattr;
>  	};
>  
>  	u8				opcode;
> @@ -1118,6 +1126,10 @@ static const struct io_op_def io_op_defs[] = {
>  	[IORING_OP_GETDENTS] = {
>  		.needs_file		= 1,
>  	},
> +	[IORING_OP_FSETXATTR] = {
> +		.needs_file = 1
> +	},
> +	[IORING_OP_SETXATTR] = {},
>  };
>  
>  /* requests with any of those set should undergo io_disarm_next() */
> @@ -3887,6 +3899,140 @@ static int io_renameat(struct io_kiocb *req, unsigned int issue_flags)
>  	return 0;
>  }
>  
> +static int __io_setxattr_prep(struct io_kiocb *req,
> +			const struct io_uring_sqe *sqe)
> +{
> +	struct io_xattr *ix = &req->xattr;
> +	const char __user *name;
> +	int ret;
> +
> +	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
> +		return -EINVAL;
> +	if (unlikely(sqe->ioprio))
> +		return -EINVAL;
> +	if (unlikely(req->flags & REQ_F_FIXED_FILE))
> +		return -EBADF;
> +
> +	ix->filename = NULL;
> +	name = u64_to_user_ptr(READ_ONCE(sqe->addr));
> +	ix->ctx.value = u64_to_user_ptr(READ_ONCE(sqe->addr2));
> +	ix->ctx.kvalue = NULL;
> +	ix->ctx.size = READ_ONCE(sqe->len);
> +	ix->ctx.flags = READ_ONCE(sqe->xattr_flags);
> +
> +	ix->ctx.kname = kmalloc(sizeof(*ix->ctx.kname), GFP_KERNEL);
> +	if (!ix->ctx.kname)
> +		return -ENOMEM;
> +
> +	ret = setxattr_copy(name, &ix->ctx);
> +	if (ret) {
> +		kfree(ix->ctx.kname);
> +		return ret;
> +	}
> +
> +	req->flags |= REQ_F_NEED_CLEANUP;
> +	return 0;
> +}
> +
> +static int io_setxattr_prep(struct io_kiocb *req,
> +			const struct io_uring_sqe *sqe)
> +{
> +	struct io_xattr *ix = &req->xattr;
> +	const char __user *path;
> +	int ret;
> +
> +	ret = __io_setxattr_prep(req, sqe);
> +	if (ret)
> +		return ret;
> +
> +	path = u64_to_user_ptr(READ_ONCE(sqe->addr3));
> +
> +	ix->filename = getname_flags(path, LOOKUP_FOLLOW, NULL);
> +	if (IS_ERR(ix->filename)) {
> +		ret = PTR_ERR(ix->filename);
> +		ix->filename = NULL;
> +	}
> +
> +	return ret;
> +}
> +
> +static int io_fsetxattr_prep(struct io_kiocb *req,
> +			const struct io_uring_sqe *sqe)
> +{
> +	return __io_setxattr_prep(req, sqe);
> +}
> +
> +static int __io_setxattr(struct io_kiocb *req, unsigned int issue_flags,
> +			struct path *path)
> +{
> +	struct io_xattr *ix = &req->xattr;
> +	int ret;
> +
> +	ret = mnt_want_write(path->mnt);
> +	if (!ret) {
> +		ret = do_setxattr(mnt_user_ns(path->mnt), path->dentry, &ix->ctx);
> +		mnt_drop_write(path->mnt);
> +	}
> +
> +	return ret;
> +}
> +
> +static int io_fsetxattr(struct io_kiocb *req, unsigned int issue_flags)
> +{
> +	struct io_xattr *ix = &req->xattr;
> +	int ret;
> +
> +	if (issue_flags & IO_URING_F_NONBLOCK)
> +		return -EAGAIN;
> +
> +	ret = __io_setxattr(req, issue_flags, &req->file->f_path);
> +
> +	req->flags &= ~REQ_F_NEED_CLEANUP;
> +	kfree(ix->ctx.kname);
> +
> +	if (ix->ctx.kvalue)
> +		kvfree(ix->ctx.kvalue);
> +	if (ret < 0)
> +		req_set_fail(req);
> +
> +	io_req_complete(req, ret);
> +	return 0;
> +}
> +
> +static int io_setxattr(struct io_kiocb *req, unsigned int issue_flags)
> +{
> +	struct io_xattr *ix = &req->xattr;
> +	unsigned int lookup_flags = LOOKUP_FOLLOW;
> +	struct path path;
> +	int ret;
> +
> +	if (issue_flags & IO_URING_F_NONBLOCK)
> +		return -EAGAIN;
> +
> +retry:
> +	ret = do_user_path_at_empty(AT_FDCWD, ix->filename, lookup_flags, &path);
> +	if (!ret) {
> +		ret = __io_setxattr(req, issue_flags, &path);
> +		path_put(&path);
> +		if (retry_estale(ret, lookup_flags)) {
> +			lookup_flags |= LOOKUP_REVAL;
> +			goto retry;
> +		}
> +	}
> +	putname(ix->filename);
> +
> +	req->flags &= ~REQ_F_NEED_CLEANUP;
> +	kfree(ix->ctx.kname);
> +
> +	if (ix->ctx.kvalue)
> +		kvfree(ix->ctx.kvalue);
> +	if (ret < 0)
> +		req_set_fail(req);
> +
> +	io_req_complete(req, ret);
> +	return 0;
> +}

(One suggestin below.)

Looks good,
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>

You could minimize the redudancy by implementing a simple helper
callable from both io_fsetxattr() and io_setxattr() if you think it's
worth with. So sm like:

From 2f837aa2a19b5cd8e73fffb9b87b6e6b22c5cae7 Mon Sep 17 00:00:00 2001
From: Christian Brauner <christian.brauner@ubuntu.com>
Date: Wed, 29 Dec 2021 15:22:34 +0100
Subject: [PATCH] UNTESTED

---
 fs/io_uring.c | 36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7204b8d593e4..c88916b8cccc 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4118,6 +4118,21 @@ static int __io_setxattr(struct io_kiocb *req, unsigned int issue_flags,
 	return ret;
 }
 
+static void __io_setxattr_finish(struct io_kiocb *req, int ret)
+{
+	struct xattr_ctx *ctx = &req->xattr.ctx;
+
+	req->flags &= ~REQ_F_NEED_CLEANUP;
+
+	kfree(ctx->kname);
+	if (ctx->kvalue)
+		kvfree(ctx->kvalue);
+
+	if (ret < 0)
+		req_set_fail(req);
+
+	io_req_complete(req, ret);
+}
+
 static int io_fsetxattr(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_xattr *ix = &req->xattr;
@@ -4127,16 +4142,7 @@ static int io_fsetxattr(struct io_kiocb *req, unsigned int issue_flags)
 		return -EAGAIN;
 
 	ret = __io_setxattr(req, issue_flags, &req->file->f_path);
-
-	req->flags &= ~REQ_F_NEED_CLEANUP;
-	kfree(ix->ctx.kname);
-
-	if (ix->ctx.kvalue)
-		kvfree(ix->ctx.kvalue);
-	if (ret < 0)
-		req_set_fail(req);
-
-	io_req_complete(req, ret);
+	__io_setxattr_finish(req, ret);
 	return 0;
 }
 
@@ -4162,15 +4168,7 @@ static int io_setxattr(struct io_kiocb *req, unsigned int issue_flags)
 	}
 	putname(ix->filename);
 
-	req->flags &= ~REQ_F_NEED_CLEANUP;
-	kfree(ix->ctx.kname);
-
-	if (ix->ctx.kvalue)
-		kvfree(ix->ctx.kvalue);
-	if (ret < 0)
-		req_set_fail(req);
-
-	io_req_complete(req, ret);
+	__io_setxattr_finish(req, ret);
 	return 0;
 }
 
-- 
2.30.2

