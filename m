Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE14947E160
	for <lists+io-uring@lfdr.de>; Thu, 23 Dec 2021 11:24:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347675AbhLWKYs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Dec 2021 05:24:48 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49688 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347664AbhLWKYr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Dec 2021 05:24:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57FB161E1C;
        Thu, 23 Dec 2021 10:24:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38CFCC36AE9;
        Thu, 23 Dec 2021 10:24:44 +0000 (UTC)
Date:   Thu, 23 Dec 2021 11:24:40 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        kernel-team@fb.com, torvalds@linux-foundation.org
Subject: Re: [PATCH v6 2/5] fs: split off setxattr_setup function from
 setxattr
Message-ID: <20211223102440.4bd5t25tojkhpbuy@wittgenstein>
References: <20211222210127.958902-1-shr@fb.com>
 <20211222210127.958902-3-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211222210127.958902-3-shr@fb.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Dec 22, 2021 at 01:01:24PM -0800, Stefan Roesch wrote:
> This splits of the setup part of the function
> setxattr in its own dedicated function called
> setxattr_setup.
> 
> This makes it possible to call this function
> from io_uring in the pre-processing of an
> xattr request.
> 
> Signed-off-by: Stefan Roesch <shr@fb.com>
> ---

I like the introduction of struct xattr_ctx.
But I would prefer if we called this setxattr_prepare() to mirror
setattr_prepare() and change the signature to:

int setxattr_setup(struct user_namespace *mnt_userns,
                   const char __user *name,
		   struct xattr_ctx *ctx,
		   void **xattr_val);

Since NULL is a success condition I think it makes more sense to have an
error returned and the value be a return argument. So sm like
(uncompiled and untested):

int setxattr_prepare(struct user_namespace *mnt_userns, const char __user *name,
		     struct xattr_ctx *ctx, void **xattr_val)
{
	void *kvalue = NULL;
	int error;

	if (ctx->flags & ~(XATTR_CREATE | XATTR_REPLACE))
		return -EINVAL;

	error = strncpy_from_user(ctx->kname, name, ctx->kname_sz);
	if (error == 0 || error == ctx->kname_sz)
		return -ERANGE;
	if (error < 0)
		return error;

	if (ctx->size) {
		if (ctx->size > XATTR_SIZE_MAX)
			return -E2BIG;

		kvalue = kvmalloc(ctx->size, GFP_KERNEL);
		if (!kvalue)
			return -ENOMEM;

		if (copy_from_user(kvalue, ctx->value, ctx->size)) {
			kvfree(kvalue);
			return -EFAULT;
		}

		if ((strcmp(ctx->kname, XATTR_NAME_POSIX_ACL_ACCESS) == 0) ||
		    (strcmp(ctx->kname, XATTR_NAME_POSIX_ACL_DEFAULT) == 0))
			posix_acl_fix_xattr_from_user(mnt_userns, kvalue, ctx->size);
	}

	*xattr_val = kvalue;
	return 0;
}
