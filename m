Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A963481846
	for <lists+io-uring@lfdr.de>; Thu, 30 Dec 2021 02:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234247AbhL3B6e (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Dec 2021 20:58:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234245AbhL3B6e (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Dec 2021 20:58:34 -0500
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57189C061574;
        Wed, 29 Dec 2021 17:58:34 -0800 (PST)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n2ki8-00FrrI-Fl; Thu, 30 Dec 2021 01:58:32 +0000
Date:   Thu, 30 Dec 2021 01:58:32 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        kernel-team@fb.com, torvalds@linux-foundation.org,
        christian.brauner@ubuntu.com
Subject: Re: [PATCH v10 4/5] io_uring: add fsetxattr and setxattr support
Message-ID: <Yc0SSJHLyxBHEvaG@zeniv-ca.linux.org.uk>
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

Same question as for getxattr side.  Why bother doing getname in prep
and open-coding the ESTALE retry loop in io_setxattr() proper?

Again, if you have hit the retry_estale() returning true, you are already
on a very slow path; trying to save on getname is completely pointless.
Moreover, had there been a situation where it might have been warranted
(and I really can't imagine one), why would that only be applicable in
io_uring case?
