Return-Path: <io-uring+bounces-3261-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ACA3B97E234
	for <lists+io-uring@lfdr.de>; Sun, 22 Sep 2024 17:10:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DCE6C1C20F4E
	for <lists+io-uring@lfdr.de>; Sun, 22 Sep 2024 15:10:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DB7110957;
	Sun, 22 Sep 2024 15:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="Yi3xnbZg"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4122BAE3;
	Sun, 22 Sep 2024 15:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727017776; cv=none; b=L65ZypB+uyxhPvW/rMIWdIUL6jKiWoRSU/aC7xp/64lLdnQ46vlDyPbbiYG1HAvjynCf6vwtt8EP1NkKfTvYvjnrGKQem5RaEtWLggrrUgPVBGLq+S1LVhwswXfR0w0aei9icDmke65m65kHgf8S/R2ihPYoJlmmkY8NmUDLdD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727017776; c=relaxed/simple;
	bh=ZuAZvymcd1OQSceqOb7Sw+a3Ug5r3S9OfLI70ytWi7o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gnGWkW0sppGNXgphQDdmZYz1nSKBu1ur9Ny5Lifo1bszmezVHPrxQM4ear/rVsE3i7n4qK2h/9h/TqeDVVztESMnE1PIT3Gbi/OHp0kKt1OjGStsuImK9cOvmmHdI54uX1UVmbdri641dHgwLWEJY/06rITytt6DUKaFToUT8Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=Yi3xnbZg; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Z3y0d3YfLN/aVd7IZpf+g6UrOV5ztW7Ct6YUGmeiSBc=; b=Yi3xnbZgOsb1N0z94t6fTaQuoM
	LwRT2RnB230hZHKUCaBcMj1s8bFOpUyRdgZXZckTL1wK+N2g6235Xj9Qy/9qgBU+7voWpnLQ6kT/i
	fLydnKBnQ72SLe4d04BB5WFkR2OzfjKQqM1aMKB2mWa2KIcrOtOSKIjFq6NBLSNouaSsGHpgKwyBt
	KBvEj4KrEz7U/zSJ9K/HsDKBHSUwbt4uQXAjDdIWBxa/P2Ruvl8r6TrJ11oaHBn9oaPCSNMyu2ZFK
	cS7MebTy/MlVA1alIbIlobagQkB/sFx6PtQlqCYGx1ae291bSuCS0dpHJScc4ODiL3JYwyX8/Zmhe
	W0NFuJgw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98 #2 (Red Hat Linux))
	id 1ssODL-0000000Eehi-0rBE;
	Sun, 22 Sep 2024 15:09:31 +0000
Date: Sun, 22 Sep 2024 16:09:31 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: audit@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [RFC] struct filename, io_uring and audit troubles
Message-ID: <20240922150931.GD3413968@ZenIV>
References: <20240922004901.GA3413968@ZenIV>
 <20240922041006.GC3413968@ZenIV>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240922041006.GC3413968@ZenIV>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Sun, Sep 22, 2024 at 05:10:06AM +0100, Al Viro wrote:
> On Sun, Sep 22, 2024 at 01:49:01AM +0100, Al Viro wrote:
> 
> > * don't bother with audit_name creation and linkage in getname(); do that
> > when we start using the sucker.  Doing that from __set_nameidata() will
> > catch the majority of the stuff that ever gets audit_inode* called for it
> > (the only exceptions are mq_open(2) and mq_unlink(2)).  Unfortunately,
> > each audit_name instance gets spewed into logs, so we would need to
> > bring the rest of that shite in, including the things like symlink
> > bodies (note that for io_uring-originating symlink we'd need that done
> > in do_symlinkat()), etc.  Unpleasant, that.
> 
> BTW, how much is exact order and number of PATH items in audit logs cast
> in stone?
> 
> For example,
>         char s[2][20] = {"/tmp/blah/x", "/tmp/blah/x"};
> 	rename(s[0], s[1]);
> 	rename(s[0], s[0]);
> 
> produces 2 items (both for /tmp/blah) on the first call, and only 1 on
> the second.  Does anything care about preserving that distinction?
> 
> And what in audit_inode{,_child}() behaviour can be changed?  I mean, does
> anything care about the loop directions when we pick the candidate
> audit_name for conversion, etc.?
> 
> It's been a long time since I've touched audit, and I have done my best
> to purge memories of the specifications ;-/

Speaking of which, is there anything in specs that would require -F obj_uid=0
to give a match on symlink("foo", "bar") done by non-root in non-root-owned
directory, but not on symlink("foo", "foo") in the same conditions?

Put it another way, could we possibly make the predicates that refer to inode
state *not* evaluate to true on audit_name instances that had never been
associated with any inodes?  Currently, symlink body has such an audit_name
instance, except when that instance had been picked by audit_inode_parent()
for conversion (or had been shared from the very beginning in case of symlink(2)
that had identical pointers passed in both arguments).

Al, carefully abstaining from any comments on the sanity of said specifications -
it's a government document, after all, so those should be obvious...

