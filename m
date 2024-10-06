Return-Path: <io-uring+bounces-3432-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E705991CA7
	for <lists+io-uring@lfdr.de>; Sun,  6 Oct 2024 07:29:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 55162282B7A
	for <lists+io-uring@lfdr.de>; Sun,  6 Oct 2024 05:29:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66174157A48;
	Sun,  6 Oct 2024 05:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="mXBbTG7/"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D37714D2B9;
	Sun,  6 Oct 2024 05:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728192552; cv=none; b=O3Ovv2hisQyGMjrcuN7t2lCEOK318TUwB7Lsuypv58l1uuJWEI70FASJfDL9Cq8KWTwGL4EqATs5Uwlu1SFplbM0x6j4Qu1/YwePigzV2A9fwZZE5lg8B78S9fU76hTRoCNhkmfbXDtZ1+J2ePWKg5s92IAEpYyrxQGWY3bJHY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728192552; c=relaxed/simple;
	bh=+qvf+pVKRbwGu6gLpBn33/Zs3vLuu8P/6IkCw+IxAa4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hmzJdeayKixuYawR4VJ1JCZWuBwj9FaURBnplaiZik9iMo2bvfBgcD1tkIP0LPHhd2zFczYxe/4zJYxX5CgBN2w653V/8hZoDTC1uRwOdgsRf8BpJlSX8YiWgWXBer5OyBX/N1LSMrPI3IhAPob2i8CmpDv2/WLt58+fCow+084=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=mXBbTG7/; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9H6bmpjotof79tAf7RgMUcUrKT2EtJKt/JeJ+48AWwo=; b=mXBbTG7/bRjFtUx1Dg/8LZmJqs
	PW/i/dK2d/RurQk0x6oH60j4KxDXkpSq45yO7kxy52A3oX5mBNMkotIKHGgvlQ6uN59XWKJoPM8dp
	9uBbbG9CY20eLGYQzZyNKIpifFLWVgXYvxrF370FP2qsL/sxiQK423nN0yL+3Vi5Uzn/jjfnmICc9
	TL6VUkMhkJawOKu/J8VAFXx1Fas4VaHFweCfwdrSx7FJI6qstBN+QYPswdJKp7vCQ0naUc1/nvy7g
	ecXIEhhZooI4tJt0DOb2Ajz6AyRBKscm6gUHwSz0AklrOt+oGU5bBFnu5wH+ji3Enw6bCWZp3aLRW
	HquyGvrw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98 #2 (Red Hat Linux))
	id 1sxJpD-00000001FjB-3m5i;
	Sun, 06 Oct 2024 05:28:59 +0000
Date: Sun, 6 Oct 2024 06:28:59 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, brauner@kernel.org,
	io-uring@vger.kernel.org, cgzones@googlemail.com
Subject: Re: [PATCH 5/9] replace do_setxattr() with saner helpers.
Message-ID: <20241006052859.GD4017910@ZenIV>
References: <20241002011011.GB4017910@ZenIV>
 <20241002012230.4174585-1-viro@zeniv.linux.org.uk>
 <20241002012230.4174585-5-viro@zeniv.linux.org.uk>
 <12334e67-80a6-4509-9826-90d16483835e@kernel.dk>
 <20241002020857.GC4017910@ZenIV>
 <a2730d25-3998-4d76-8c12-dde7ce1be719@kernel.dk>
 <20241002211939.GE4017910@ZenIV>
 <d69b33f9-31a0-4c70-baf2-a72dc28139e0@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d69b33f9-31a0-4c70-baf2-a72dc28139e0@kernel.dk>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Wed, Oct 02, 2024 at 04:55:22PM -0600, Jens Axboe wrote:

> The reason I liked the putname() is that it's unconditional - the caller
> can rely on it being put, regardless of the return value. So I'd say the
> same should be true for ctx.kvalue, and if not, the caller should still
> free it. That's the path of least surprise - no leak for the least
> tested error path, and no UAF in the success case.

The problem with ctx.kvalue is that on the syscall side there's a case when
we do not call either file_setxattr() or filename_setxattr() - -EBADF.
And it's a lot more convenient to do setxattr_copy() first, so we end
up with a lovely landmine:
        filename = getname_xattr(pathname, at_flags);
	if (!filename) {
		CLASS(fd, f)(dfd);
		if (fd_empty(f)) {
			kfree(ctx.kvalue); // lest we leak
			return -EBADF;
		}
		return file_setxattr(fd_file(f), &ctx);
	}
	return filename_setxattr(dfd, filename, lookup_flags, &ctx);

That's asking for trouble, obviously.  So I think we ought to consume
filename (in filename_...()) case, leave struct file reference alone
(we have to - it might have been borrowed rather than cloned) and leave
->kvalue unchanged.  Yes, it ends up being more clumsy, but at least
it's consistent between the cases...

As for consuming filename...  On the syscall side it allows things like
SYSCALL_DEFINE3(mkdirat, int, dfd, const char __user *, pathname, umode_t, mode)
{
        return do_mkdirat(dfd, getname(pathname), mode);
}  
which is better than the alternatives - I mean, that's
SYSCALL_DEFINE3(mkdirat, int, dfd, const char __user *, pathname, umode_t, mode)
{
	struct filename *filename = getname(pathname);
	int res = do_mkdirat(dfd, filename, mode);
	putname(filename);
	return ret;
}  
or 
SYSCALL_DEFINE3(mkdirat, int, dfd, const char __user *, pathname, umode_t, mode)
{
	struct filename *filename __free(putname) = getname(pathname);
	return do_mkdirat(dfd, filename, mode);
}
and both stink, if for different reasons ;-/  Having those things consume
(unconditionally) is better, IMO.

Hell knows; let's go with what I described above for now and see where it leads
when more such helpers are regularized.

> That's a bit different than your putname() case, but I think as long as
> it's consistent regardless of return value, then either approach is
> fine. Maybe just add a comment about that? At least for the consistent
> case, if it blows up, it'll blow up instantly rather than be a surprise
> down the line for "case x,y,z doesn't put it" or "case x,y,z always puts
> in, normal one does not".

Obviously.

> > Questions on the io_uring side:
> > 	* you usually reject REQ_F_FIXED_FILE for ...at() at ->prep() time.
> > Fine, but... what's the point of doing that in IORING_OP_FGETXATTR case?
> > Or IORING_OP_GETXATTR, for that matter, since you pass AT_FDCWD anyway...
> > Am I missing something subtle here?
> 
> Right, it could be allowed for fgetxattr on the io_uring side. Anything
> that passes in a struct file would be fair game to enable it on.
> Anything that passes in a path (eg a non-fd value), it obviously
> wouldn't make sense anyway.

OK, done and force-pushed into #work.xattr.

