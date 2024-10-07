Return-Path: <io-uring+bounces-3460-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E4E2993B79
	for <lists+io-uring@lfdr.de>; Tue,  8 Oct 2024 01:58:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 09F62B216F8
	for <lists+io-uring@lfdr.de>; Mon,  7 Oct 2024 23:58:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D092A192B8D;
	Mon,  7 Oct 2024 23:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="lzymT+VD"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4305618CBF4;
	Mon,  7 Oct 2024 23:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728345499; cv=none; b=HQTmY8vEw0lmwzfRvwImt6QHKDQ6yCps97Sg2kOtMxmxg4uOusPf3KO6Gci3AII6gtNBjp1z2UeF4gqZnhE987o/8BEIFJUlYviFRa61MRwDJl+2A1APMkopCLLenHg25McCLFQzsUnkiBK0QdOovDS4dHnDTAqJTmnHFv+tXFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728345499; c=relaxed/simple;
	bh=90Bwktj5IOiWk4M0yQuEDT80jv0QRJpvTcOJARftBUg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bx0Zqfq5VozLxMA/I8UmDNk9NJwaw7q38HpAjhY21212J/waW1Q2kJItqdlGCxamy00O8gHzn4WN3jpxivg1MZuugVp1JNAE2jYIs4nlFKDHfJSbvOdVicBIsJ3Ueh/OpblF2KSETX+nsFS/dOZVZvTSP0dnMvColeV7V30pqRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=lzymT+VD; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Z7wWOJjw+YlO5tJ4k9pD+F+6MgV6cgp39aSz1M6inXo=; b=lzymT+VD0z17msR0bECXH3HgR/
	qVYxErpxJRUJzXr/TsFL+CGdQ5barLN2DEcxCoMwg9Y2JhlKKje4jF2LxVt3CM4R9QCD5QInhWKV3
	DpkhFsXoR3Rl8zMp42qzwpNIKS8A9eAeTIOjXHnJWVSxFBxyW3CjzMYQHibHIojOkzqvGwiUvapSq
	YzNJ9pVh/+0BczA7GXVmV+qRVPWHIbf3fcO6FZ3k1xqdeIxiZlbIntPmfnnJkY64MdbT3Y58ROrGb
	fbt3SppV7FjqRIEDALlLNLvtnOHbAx0A0c+ugm+Bb2XZEhggZzxHPNzDjEM99DPkhKvpB+3t9mYev
	mhulnUVg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98 #2 (Red Hat Linux))
	id 1sxxcF-00000001j8n-1E8F;
	Mon, 07 Oct 2024 23:58:15 +0000
Date: Tue, 8 Oct 2024 00:58:15 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, brauner@kernel.org,
	io-uring@vger.kernel.org, cgzones@googlemail.com
Subject: Re: [PATCH 5/9] replace do_setxattr() with saner helpers.
Message-ID: <20241007235815.GT4017910@ZenIV>
References: <12334e67-80a6-4509-9826-90d16483835e@kernel.dk>
 <20241002020857.GC4017910@ZenIV>
 <a2730d25-3998-4d76-8c12-dde7ce1be719@kernel.dk>
 <20241002211939.GE4017910@ZenIV>
 <d69b33f9-31a0-4c70-baf2-a72dc28139e0@kernel.dk>
 <20241006052859.GD4017910@ZenIV>
 <69e696d7-637a-4cb2-912c-6066d23afd72@kernel.dk>
 <965e59b5-615a-4d20-bb04-a462c33ad84b@kernel.dk>
 <20241007212034.GS4017910@ZenIV>
 <2da6c045-3e55-4137-b646-f2da69032fff@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2da6c045-3e55-4137-b646-f2da69032fff@kernel.dk>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Mon, Oct 07, 2024 at 04:29:29PM -0600, Jens Axboe wrote:
> > Can I put your s-o-b on that, with e.g.
> > 
> > io_uring: IORING_OP_F[GS]ETXATTR is fine with REQ_F_FIXED_FILE
> > 
> > Rejection of IOSQE_FIXED_FILE combined with IORING_OP_[GS]ETXATTR
> > is fine - these do not take a file descriptor, so such combination
> > makes no sense.  The checks are misplaced, though - as it is, they
> > triggers on IORING_OP_F[GS]ETXATTR as well, and those do take 
> > a file reference, no matter the origin. 
> 
> Yep that's perfect, officially:
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> Thanks Al!

OK, updated and force-pushed (with slight reordering).  I can almost
promise no-rebase mode for that thing from now on, as long as nobody
on fsdevel objects to fs/xattr.c part of things after I repost the
series in the current form.

One possible exception: I'm not sure that fs/internal.h is a good
place for those primitives.  OTOH, any bikeshedding in that direction
can be delayed until the next cycle...

To expand the circle of potential bikeshedders: s/do_mkdirat/filename_mkdirat/
is a reasonable idea for this series, innit?  How about turning e.g.

int __init init_mkdir(const char *pathname, umode_t mode)
{
        struct dentry *dentry;
        struct path path;
        int error;

        dentry = kern_path_create(AT_FDCWD, pathname, &path, LOOKUP_DIRECTORY);
        if (IS_ERR(dentry))
                return PTR_ERR(dentry);
        mode = mode_strip_umask(d_inode(path.dentry), mode);
        error = security_path_mkdir(&path, dentry, mode);
        if (!error)
                error = vfs_mkdir(mnt_idmap(path.mnt), path.dentry->d_inode,
                                  dentry, mode);
        done_path_create(&path, dentry);
        return error;
}

into

int __init init_mkdir(const char *pathname, umode_t mode)
{
	return filename_mkdirat(AT_FDCWD, getname_kernel(pathname), mode);
}

reducing the duplication?  It really should not be accessible to random
places in the kernel, but syscalls in core VFS + io_uring interface for
the same + possibly init/*.c...

OTOH, I'm afraid to let the "but our driver is sooo special!" crowd play
with the full set of syscalls...  init_syscalls.h is already bad enough.
Hell knows, fs/internal.h just might be a bit of deterrent...

