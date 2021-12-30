Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0296F48186E
	for <lists+io-uring@lfdr.de>; Thu, 30 Dec 2021 03:17:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234453AbhL3CR0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Dec 2021 21:17:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbhL3CRZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Dec 2021 21:17:25 -0500
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55968C061574;
        Wed, 29 Dec 2021 18:17:25 -0800 (PST)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n2l0N-00FsD0-Jy; Thu, 30 Dec 2021 02:17:23 +0000
Date:   Thu, 30 Dec 2021 02:17:23 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        kernel-team@fb.com, torvalds@linux-foundation.org,
        christian.brauner@ubuntu.com
Subject: Re: [PATCH v10 4/5] io_uring: add fsetxattr and setxattr support
Message-ID: <Yc0Ws8LevbWc+N1q@zeniv-ca.linux.org.uk>
References: <20211229203002.4110839-1-shr@fb.com>
 <20211229203002.4110839-5-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211229203002.4110839-5-shr@fb.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Dec 29, 2021 at 12:30:01PM -0800, Stefan Roesch wrote:

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

OK, so you
	* allocate a buffer for xattr name
	* have setxattr_copy() copy the name in *and* memdup the contents
	* on failure, you have the buffer for xattr name freed and return
an error.  memdup'ed stuff is left for cleanup, presumably.

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

... and here you use it and bring the pathname in.  Should the latter
step fail, you restore ->filename to NULL and return an error.

Could you explain what kind of magic could allow the caller to tell
whether ix->ctx.kname needs to be freed on error?  I don't see any way
that could possibly work...
