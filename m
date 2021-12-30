Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D420481802
	for <lists+io-uring@lfdr.de>; Thu, 30 Dec 2021 02:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbhL3BPN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Dec 2021 20:15:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbhL3BPN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Dec 2021 20:15:13 -0500
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D61C3C061574;
        Wed, 29 Dec 2021 17:15:12 -0800 (PST)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n2k2A-00Fr4D-Dc; Thu, 30 Dec 2021 01:15:10 +0000
Date:   Thu, 30 Dec 2021 01:15:10 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        kernel-team@fb.com, torvalds@linux-foundation.org,
        christian.brauner@ubuntu.com
Subject: Re: [PATCH v10 2/5] fs: split off setxattr_copy and do_setxattr
 function from setxattr
Message-ID: <Yc0IHp2igNlXqyKV@zeniv-ca.linux.org.uk>
References: <20211229203002.4110839-1-shr@fb.com>
 <20211229203002.4110839-3-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211229203002.4110839-3-shr@fb.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Dec 29, 2021 at 12:29:59PM -0800, Stefan Roesch wrote:
> +	if (ctx->size) {
> +		if (ctx->size > XATTR_SIZE_MAX)
>  			return -E2BIG;
> -		kvalue = kvmalloc(size, GFP_KERNEL);
> -		if (!kvalue)
> +
> +		ctx->kvalue = kvmalloc(ctx->size, GFP_KERNEL);
> +		if (!ctx->kvalue)
>  			return -ENOMEM;
> -		if (copy_from_user(kvalue, value, size)) {
> -			error = -EFAULT;
> -			goto out;
> +
> +		if (copy_from_user(ctx->kvalue, ctx->value, ctx->size)) {
> +			kvfree(ctx->kvalue);
> +			return -EFAULT;

BTW, what's wrong with using vmemdup_user() here?
