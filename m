Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D08D481832
	for <lists+io-uring@lfdr.de>; Thu, 30 Dec 2021 02:46:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234164AbhL3BqV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Dec 2021 20:46:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233692AbhL3BqU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Dec 2021 20:46:20 -0500
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8238C061574;
        Wed, 29 Dec 2021 17:46:20 -0800 (PST)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n2kWJ-00FrdV-Fa; Thu, 30 Dec 2021 01:46:19 +0000
Date:   Thu, 30 Dec 2021 01:46:19 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        kernel-team@fb.com, torvalds@linux-foundation.org,
        christian.brauner@ubuntu.com
Subject: Re: [PATCH v10 5/5] io_uring: add fgetxattr and getxattr support
Message-ID: <Yc0Paz1R77AuTds8@zeniv-ca.linux.org.uk>
References: <20211229203002.4110839-1-shr@fb.com>
 <20211229203002.4110839-6-shr@fb.com>
 <Yc0OT3C+pSqLOZym@zeniv-ca.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yc0OT3C+pSqLOZym@zeniv-ca.linux.org.uk>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Dec 30, 2021 at 01:41:35AM +0000, Al Viro wrote:
> On Wed, Dec 29, 2021 at 12:30:02PM -0800, Stefan Roesch wrote:
> 
> > +static int io_getxattr(struct io_kiocb *req, unsigned int issue_flags)
> > +{
> > +	struct io_xattr *ix = &req->xattr;
> > +	unsigned int lookup_flags = LOOKUP_FOLLOW;
> > +	struct path path;
> > +	int ret;
> > +
> > +	if (issue_flags & IO_URING_F_NONBLOCK)
> > +		return -EAGAIN;
> > +
> > +retry:
> > +	ret = do_user_path_at_empty(AT_FDCWD, ix->filename, lookup_flags, &path);
> > +	if (!ret) {
> > +		ret = do_getxattr(mnt_user_ns(path.mnt),
> > +				path.dentry,
> > +				ix->ctx.kname->name,
> > +				(void __user *)ix->ctx.value,
> > +				ix->ctx.size);
> > +
> > +		path_put(&path);
> > +		if (retry_estale(ret, lookup_flags)) {
> > +			lookup_flags |= LOOKUP_REVAL;
> > +			goto retry;
> > +		}
> > +	}
> > +	putname(ix->filename);
> > +
> > +	__io_getxattr_finish(req, ret);
> > +	return 0;
> > +}
> 
> Looking at that one...  Is there any reason to have that loop (from retry: to
> putname() call) outside of fs/xattr.c?  Come to think of that, why bother
> polluting your struct io_xattr with ->filename?
> 
> Note, BTW, that we already have this:
> static ssize_t path_getxattr(const char __user *pathname,
>                              const char __user *name, void __user *value,
> 			     size_t size, unsigned int lookup_flags)
> {
> 	struct path path;
> 	ssize_t error;
> retry:
> 	error = user_path_at(AT_FDCWD, pathname, lookup_flags, &path);
> 	if (error)
> 		return error;
> 	error = getxattr(mnt_user_ns(path.mnt), path.dentry, name, value, size);
> 	path_put(&path);
> 	if (retry_estale(error, lookup_flags)) {
> 		lookup_flags |= LOOKUP_REVAL;
> 		goto retry;
> 	}
> 	return error;
> }
> in there.  The only potential benefit here would be to avoid repeated getname
> in case of having hit -ESTALE and going to repeat the entire fucking pathwalk
> with maximal paranoia, asking the server(s) involved to revalidate on every
> step, etc.
> 
> If we end up going there, who the hell *cares* about the costs of less than
> a page worth of copy_from_user()?  We are already on a very slow path as it
> is, so what's the point?

BTW, if the answer is along the lines of "we want to copy the name in prep
phase fo $REASONS", I would like to hear what it is that makes getxattr()
different from statx() in that respect.
