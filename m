Return-Path: <io-uring+bounces-3271-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1152897F1B8
	for <lists+io-uring@lfdr.de>; Mon, 23 Sep 2024 22:37:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 421421C20D89
	for <lists+io-uring@lfdr.de>; Mon, 23 Sep 2024 20:37:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E20928C06;
	Mon, 23 Sep 2024 20:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="h5f9TNsE"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E672A1C3D;
	Mon, 23 Sep 2024 20:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727123824; cv=none; b=OrC3hW2U/DHaH59t6iu+sk9GbdKwnE3n7BTlAjuAw9Y2EllYFpumyZupkN2K2+ec818afY24Ghyj3EIufY/WoRBftA7HymiIrO5xIMz9SoREHHjJEK6v/RFN166cEsE+LZ7dYYyLGapycjPtfXZw0hGWBvd5b3gIRgYWR5pqEA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727123824; c=relaxed/simple;
	bh=Ge/INV1DCihg8u0K0dtZIxHEcglYThbaG+RfLrp+ieA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u7QJxSaLbVKqkfzl+vy8camFOm8ZHZ2Nef5M2evKlcpoc7W+2KBjbgS8+MGTPoUsZSXEdn6+hVA7tVeHowz/Pny3VOCmX613243rQDOtC85S30MEFVoGqpB3ewH9XDe4uk6ZdzHQ5OAjJ/fcv7UH1QX4YRLnRJMiB4xlTVPjbRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=h5f9TNsE; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8va+wSI0jH4YNvmV6CQTpud3DZG27Y4kQFClTpxSxKE=; b=h5f9TNsEqM7M35R16PKmpzm+4j
	syU+UWF50x6eF40SJ14+/uYpo7K0LiVvapP+AwdhrCz9IaxlMrZvI/N0X2czNUvyPCw3HJEbrapU0
	VUyGeZnzMwzwiU2KNUcj2y5HgBXdFTBpifXz5U2/QjbxSxDqex6UuprmbeU9d4EzFNk1EsM2HYvuH
	1B/SFjru6+ux/DercWoHYjFMp5YzpsfRd+pT/46beD513T5eZUsStjuEOzNU145QV5u0Ijs0XlNun
	8vtpsutPmxzoUM8OhyNUG9Y1npzQq61A6/xH7ZdYnUQ2vdLKZq9OBt+GBe0Q2r++erMGkU39VYcPu
	E5Gi3tbQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98 #2 (Red Hat Linux))
	id 1sspnn-0000000Ez2c-3c33;
	Mon, 23 Sep 2024 20:36:59 +0000
Date: Mon, 23 Sep 2024 21:36:59 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Paul Moore <paul@paul-moore.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
	audit@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [RFC] struct filename, io_uring and audit troubles
Message-ID: <20240923203659.GD3550746@ZenIV>
References: <20240922004901.GA3413968@ZenIV>
 <20240923015044.GE3413968@ZenIV>
 <62104de8-6e9a-4566-bf85-f4c8d55bdb36@kernel.dk>
 <CAHC9VhQMGsL1tZrAbpwTHCriwZE2bzxAd+-7MSO+bPZe=N6+aA@mail.gmail.com>
 <20240923144841.GA3550746@ZenIV>
 <CAHC9VhSuDVW2Dmb6bA3CK6k77cPEv2vMqv3w4FfGvtcRDmgL3A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhSuDVW2Dmb6bA3CK6k77cPEv2vMqv3w4FfGvtcRDmgL3A@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Mon, Sep 23, 2024 at 12:14:29PM -0400, Paul Moore wrote:

[ordering and number of PATH items for syscall]

> >From my point of view, stuff like that is largely driven by enterprise
> distros chasing 3rd party security certifications so they can sell
> products/services to a certain class of users.  These are the same
> enterprise distros that haven't really bothered to contribute a lot to
> the upstream Linux kernel's audit subsystem lately so I'm not going to
> worry too much about them at this point.

Umm...  IIRC, sgrubb had been involved in the spec-related horrors, but
that was a long time ago...

> where I would like to take audit ... eventually).  Assuming your ideas
> for struct filename don't significantly break audit you can consider
> me supportive so long as we still have a way to take a struct filename
> reference inside the audit_context; we need to keep that ref until
> syscall/io_uring-op exit time as we can't be certain if we need to log
> the PATH until we know the success/fail status of the operation (among
> other things).

OK...  As for what I would like to do:

	* go through the VFS side of things and make sure we have a consistent
set of helpers that would take struct filename * - *not* the ad-hoc mix we
have right now, when that's basically driven by io_uring borging them in
one by one - or duplicates them without bothering to share helpers.
E.g. mkdirat(2) does getname() and passes it to do_mkdirat(), which
consumes the sucker; so does mknodat(2), but do_mknodat() is static.  OTOH,
path_setxattr() does setxattr_copy(), then retry_estale loop with
user_path_at() + mnt_want_write() + do_setxattr() + mnt_drop_write() + path_put()
as a body, while on io_uring side we have retry_estale loop with filename_lookup() +
(io_uring helper that does mnt_want_write() + do_setxattr() + mnt_drop_write()) +
path_put().
	Sure, that user_path_at() call is getname() + filename_lookup() + putname(),
so they are equivalent, but keeping that shite in sync is going to be trouble.

	* get rid of the "repeated getname() on the same address is going to
give you the same object" - that can't be relied upon without audit, for one
thing and for another... having a syscall that takes two pathnames that gives
different audit log (if not predicate evaluation) in cases when those are
identical pointers vs. strings with identical contenst is, IMO, somewhat
undesirable.  That kills filename->uaddr.

	* looking at the users of that stuff, I would probably prefer to
separate getname*() from insertion into audit context.  It's not that
tricky - __set_nameidata() catches *everything* that uses nd->name (i.e.
all that audit_inode() calls in fs/namei.c use).  What remains is
	do_symlinkat() for symlink body
	fs_index() on the argument (if we want to bother - it's a part
of weird Missed'em'V sysfs(2) syscall; I sincerely doubt that there's
anybody who'd use it)
	fsconfig(2) FSCONFIG_SET_PATH handling.
	mq_open(2) and mq_unlink(2) - those bypass the normal pathwalk
logics, so __set_nameidata() won't catch them.
	_maybe_ alpha osf_mount(2) devname argument; or we could get rid
of that stupidity and have it use copy_mount_string() like mount(2) does,
instead of messing with getname().
	That's all it takes.  With that done, we can kill ->aname;
just look in the ->names_list for the first entry with given ->name -
as in, given struct filename * value, no need to look inside.

