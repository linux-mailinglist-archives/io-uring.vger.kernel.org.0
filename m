Return-Path: <io-uring+bounces-3278-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C3CB983D7F
	for <lists+io-uring@lfdr.de>; Tue, 24 Sep 2024 09:01:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 32A721F2400A
	for <lists+io-uring@lfdr.de>; Tue, 24 Sep 2024 07:01:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2548B82D66;
	Tue, 24 Sep 2024 07:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="tUyKA44/"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F05312D744;
	Tue, 24 Sep 2024 07:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727161303; cv=none; b=t1FBYPLnA9kX1rJheCNWfnM0VEkkX9ySQg0lGrvBjIJP65Y+w3uMO1xJlwXPcbGOf1LmOOIcslrKWOCMP5A59xLrLi28x4M7vDe8/Y9Dmxk94T2q/zog+0sctrQ6Ggp2XGzoBNg5lPGDBSvp6BdJ8B9bVSD0ptkpvLvISDzmdUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727161303; c=relaxed/simple;
	bh=/zc15OtL50R5ltUAno2Uw31GPiLRuYoLkSNiAeRttGw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cWeAx///g01pGLtPAXLGxrDt9KTw/Z2FhS6bmPZD18vH2iWCa+eD3mtU4dP/5jREfObjYmw6+Y1ntV2x1T7akAIGghcsMhwpZvlo3TizSo/lJ0MUiJl4WuSK8DxqvM4FiU4UC1Uk8lkUjVQ2SyttWMUG6AmjaMXw1/omqwg0rqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=tUyKA44/; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=DseX3OnE4dAn+GJ4ArHvah3JrgIc9TBmDYLlTAQ6yLg=; b=tUyKA44/DJC7yPsogJgdWX2Nb0
	dakqFbD8CwlzCgpkmqbD8dFE55i/3Ar3RG3im6FKliPx3ZjDxGEuIYnF4EhjCuO0FJ2l6I1c+7ESm
	HEhrbAilI0xBiYMnWAN62JV7oNDVzLVlz73FhVte+mSgb939DAYMo812KgTofBwiF3Ufdg2Z83ZYI
	LJZomYO9MU4zH4vKoENIiaqw0SNCNXb790it1rqHA2777fT1K6KVKV9Dg9mOeQTxsPnrhF62JG81z
	h/wxL2ltnikZ9uvMTiGO9B7eAkJ8yuOC4NwLlEt/alYZLgvOtgEu2nHv/46rGe/BXiZfnUC7cVJwS
	LyIAVCfA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98 #2 (Red Hat Linux))
	id 1sszYH-0000000F5JV-1Q14;
	Tue, 24 Sep 2024 07:01:37 +0000
Date: Tue, 24 Sep 2024 08:01:37 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Paul Moore <paul@paul-moore.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
	audit@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [RFC] struct filename, io_uring and audit troubles
Message-ID: <20240924070137.GE3550746@ZenIV>
References: <20240922004901.GA3413968@ZenIV>
 <20240923015044.GE3413968@ZenIV>
 <62104de8-6e9a-4566-bf85-f4c8d55bdb36@kernel.dk>
 <CAHC9VhQMGsL1tZrAbpwTHCriwZE2bzxAd+-7MSO+bPZe=N6+aA@mail.gmail.com>
 <20240923144841.GA3550746@ZenIV>
 <CAHC9VhSuDVW2Dmb6bA3CK6k77cPEv2vMqv3w4FfGvtcRDmgL3A@mail.gmail.com>
 <20240923203659.GD3550746@ZenIV>
 <CAHC9VhSq=6MK=HKCJ8KCjYNQZ4j_eCSgTpuYyHtk2T-_m2Br3Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhSq=6MK=HKCJ8KCjYNQZ4j_eCSgTpuYyHtk2T-_m2Br3Q@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Mon, Sep 23, 2024 at 08:11:51PM -0400, Paul Moore wrote:
> > Umm...  IIRC, sgrubb had been involved in the spec-related horrors, but
> > that was a long time ago...
> 
> Yep, he was.  Last I spoke to Steve a year or so ago, audit was no
> longer part of his job description; Steve still maintains his
> userspace audit tools, but that is a nights/weekends job as far as I
> understand.
> 
> The last time I was involved in any audit/CC spec related work was
> well over a decade ago now, and all of those CC protection profiles
> have long since expired and been replaced.

Interesting...  I guess eparis would be the next victim^Wpossible source
of information.
 
> >         * get rid of the "repeated getname() on the same address is going to
> > give you the same object" - that can't be relied upon without audit, for one
> > thing and for another... having a syscall that takes two pathnames that gives
> > different audit log (if not predicate evaluation) in cases when those are
> > identical pointers vs. strings with identical contenst is, IMO, somewhat
> > undesirable.  That kills filename->uaddr.
> 
> /uaddr/uptr/ if I'm following you correctly, but yeah, that all seems good.

*nod*

> >         * looking at the users of that stuff, I would probably prefer to
> > separate getname*() from insertion into audit context.  It's not that
> > tricky - __set_nameidata() catches *everything* that uses nd->name (i.e.
> > all that audit_inode() calls in fs/namei.c use).
> 
> That should be a pretty significant simplification, that sounds good to me.
> 
> > ... What remains is
> >         do_symlinkat() for symlink body
> >         fs_index() on the argument (if we want to bother - it's a part
> > of weird Missed'em'V sysfs(2) syscall; I sincerely doubt that there's
> > anybody who'd use it)
> 
> We probably should bother, folks that really care about audit don't
> like blind spots.  Perhaps make it a separate patch if it isn't too
> ugly to split it out.

Heh...  I suggest you to look at the manpage of that thing.

sysfs(1, "ext2") => echo $((`sed -ne "/\text2$/=" </proc/filesystems` - 1))
sysfs(2, 10) => sed -ne "11s/.*\t//p" </proc/filesystems
sysfs(3) => wc -l </proc/filesystems

Yes, really - find position of filesystem type in the list of registered
filesystems by name (0-based numeration), find the name of filesystem
type by position and find the number of registered filesystem types.
Missed'em'V had no synthetic filesystems...

And the string is, of course, not a pathname of any sort, so I'd argue that
spewing PATH record into audit log is a bug.  Not that the number you get
from sysfs(1, something) had been usable for anything other than passing it
to sysfs(2, number) and getting the same string back - you can't pass that
number to mount(2) or anything of that kind.  I suspect that the only
reason this syscall exists is some binary emulation - introduced in 1.1.11,
not supported by glibc at least since 2014 (and almost certainly way before
that).

> >         That's all it takes.  With that done, we can kill ->aname;
> > just look in the ->names_list for the first entry with given ->name -
> > as in, given struct filename * value, no need to look inside.
> 
> Seems reasonable to me.  I can't imagine these special cases being any
> worse than what we have now in fs/namei.c, and if nothing else having
> a single catch point for the bulk of the VFS lookups makes it worth it
> as far as I'm concerned.

Huh?  Right now we allocate audit_names at getname_flags()/getname_kernel()
time; grep for audit_getname() - that's as centralized as it gets.
What I want to do is somewhat _de_centralize it; that way they would not
go anywhere other than audit_context of the thread actually doing the
work.

There is a lot of calls of audit_inode(), but I'm not planning to touch
any of those.

