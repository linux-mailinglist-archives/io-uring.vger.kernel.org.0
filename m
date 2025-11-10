Return-Path: <io-uring+bounces-10503-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F2954C492AA
	for <lists+io-uring@lfdr.de>; Mon, 10 Nov 2025 21:00:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C76613A851A
	for <lists+io-uring@lfdr.de>; Mon, 10 Nov 2025 19:58:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3460E27055F;
	Mon, 10 Nov 2025 19:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="jUDCKcBp"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C4318A956;
	Mon, 10 Nov 2025 19:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762804719; cv=none; b=Le9TY7xvCt/iELz0lCfI3sa0xQ/SYt+MoaQJL0sXU1icza4ChVg19BZVXwP6jF/YbATkWZYyBqAMi57DrjoF2D6y34tGpWQZc4tBnqVfQZfZouL1iSWDHtyMVPInijKFN0TtRsUq5bChM9uAroBwZeF+neSkdV5BwGxQGhVzKtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762804719; c=relaxed/simple;
	bh=zzUMAVc+YltOZz/0m9lDa5bDZglHhhA+42+qMgWTBVM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ywlo+v9Bqiz7+HhFU7F6rqOjwzk5FKXcPWgsdCSh6dadzs5gUCmdEo58WHzRbC9+w2zgGmy7v/4zU86XmzibuXJI19to/aRn+Nufo0TRFvdnl+edubu7o7Ch6OZ6YyV6ICKsiPZ1eB74fgMomCpps6v9yihqznwQ2XGu3tCP97Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=jUDCKcBp; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6P0jRtBdbPeH9TaBadc+VJlhiYAMnrlWk/flaJZ0tDY=; b=jUDCKcBp4fnfkjSGgEAo0fqtHG
	hwJCCspPX1bf6ei8ytIFjFBw7Y1AV3+e8apSeeqPWQxKEtXNBvzhNRH/s27LKTME9wf6TusI7HpS5
	Kj7Lr9iV6h54Gc/uI6+Z5pdHXMLEPMmfna6yUU1wCYscL+97KToHAT3KnZucmFCLv+gVM80o8dxUx
	YZ4gQ2wCXieqcEE0XzBPvoNIjBJDY7yzMibhH3NYSC274xYxYDKWDLFYfcmDb0zXpVyhbPOmioOnq
	2R2+08spG7Pc1FKFB40Xz8eXb/fYWu0HbnneXYSPxASdyiXa6w/5/ID9QBncqLsE62l3c1lh76Fxd
	5N/vyZNA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIY25-0000000Gb8H-2eaC;
	Mon, 10 Nov 2025 19:58:33 +0000
Date: Mon, 10 Nov 2025 19:58:33 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, brauner@kernel.org, jack@suse.cz,
	mjguzik@gmail.com, paul@paul-moore.com, axboe@kernel.dk,
	audit@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [RFC][PATCH 10/13] get rid of audit_reusename()
Message-ID: <20251110195833.GN2441659@ZenIV>
References: <20251109063745.2089578-1-viro@zeniv.linux.org.uk>
 <20251109063745.2089578-11-viro@zeniv.linux.org.uk>
 <CAHk-=wgXvEK66gjkKfUxZ+G8n50Ms65MM6Sa9Vj9cTFg7_WAkA@mail.gmail.com>
 <CAHk-=wjA=iXRyu1-ABST43vdT60Md9zpQDJ4Kg14V3f_2Bf+BA@mail.gmail.com>
 <20251110051748.GJ2441659@ZenIV>
 <CAHk-=wgBewVovNTK4=O=HNbCZSQZgQMsFjBTq6bNFW2FZJcxnQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgBewVovNTK4=O=HNbCZSQZgQMsFjBTq6bNFW2FZJcxnQ@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Mon, Nov 10, 2025 at 08:41:45AM -0800, Linus Torvalds wrote:

> > IMO things like "xfs" or "ceph" don't look like pathnames - if
> > anything, we ought to use copy_mount_string() for consistency with
> > mount(2)...
> 
> Oh, absolutely not.
> 
> But that code certainly could just do strndup_user(). That's the
> normal thing for "get a string from user space" these days, but it
> didn't historically exist..

There would be a minor change in errors (s/ENAMETOOLONG/EINVAL/
and s/ENOENT/EINVAL/, AFAICS), but nobody really gives a damn,
so...

If we go that way, do you see any problems with treating
osf_{ufs,cdfs}_mount() in the same manner?  Yes, these are pathnames,
but the strings copied there are going to be fed (after another round
of copying) to lookup_bdev(), i.e. getname_kernel().  At least that
way it would be consistent with what mount(2) does...

diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
index a08e8edef1a4..21a8f985999b 100644
--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -454,42 +454,34 @@ static int
 osf_ufs_mount(const char __user *dirname,
 	      struct ufs_args __user *args, int flags)
 {
-	int retval;
+	char *devname __free(kfree) = NULL;
 	struct cdfs_args tmp;
-	struct filename *devname;
 
-	retval = -EFAULT;
 	if (copy_from_user(&tmp, args, sizeof(tmp)))
-		goto out;
-	devname = getname(tmp.devname);
-	retval = PTR_ERR(devname);
+		return -EFAULT;
+
+	devname = strndup_user(tmp.devname, PATH_MAX);
 	if (IS_ERR(devname))
-		goto out;
-	retval = do_mount(devname->name, dirname, "ext2", flags, NULL);
-	putname(devname);
- out:
-	return retval;
+		return PTR_ERR(devname);
+
+	return do_mount(devname, dirname, "ext2", flags, NULL);
 }
 
 static int
 osf_cdfs_mount(const char __user *dirname,
 	       struct cdfs_args __user *args, int flags)
 {
-	int retval;
+	char *devname __free(kfree) = NULL;
 	struct cdfs_args tmp;
-	struct filename *devname;
 
-	retval = -EFAULT;
 	if (copy_from_user(&tmp, args, sizeof(tmp)))
-		goto out;
-	devname = getname(tmp.devname);
-	retval = PTR_ERR(devname);
+		return -EFAULT;
+
+	devname = strndup_user(tmp.devname, PATH_MAX);
 	if (IS_ERR(devname))
-		goto out;
-	retval = do_mount(devname->name, dirname, "iso9660", flags, NULL);
-	putname(devname);
- out:
-	return retval;
+		return PTR_ERR(devname);
+
+	return do_mount(devname, dirname, "iso9660", flags, NULL);
 }
 
 static int


