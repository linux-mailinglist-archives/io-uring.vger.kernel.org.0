Return-Path: <io-uring+bounces-3258-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 37B6F97E01F
	for <lists+io-uring@lfdr.de>; Sun, 22 Sep 2024 06:10:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A8BDAB20F49
	for <lists+io-uring@lfdr.de>; Sun, 22 Sep 2024 04:10:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BE8514A097;
	Sun, 22 Sep 2024 04:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="mYk0Znp0"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085C111712;
	Sun, 22 Sep 2024 04:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726978211; cv=none; b=qYC6AGgeV4T5WtTmio57bcJcLmTpvr4Je1FZE+Zko7Sgs+gw2Jt1A0iv8Qe/lA7HfLuC2DstrykMbe/7RyucyC2Ed62QBknTMbX7KagTpe/+IVXKdCEpLlJpNYI9PYN5XezHb07RpIE9GJEBXSQ4PsuJZlw6aeBXb3mXmkdH17o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726978211; c=relaxed/simple;
	bh=GmwT2MfZb+Hu1vNI7h+KSFFt0VL/u8ZYV9yw6fYXAAY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EeoGvWcJPLmqremzB3j/0+fHwQHZYm33NYT9HzYqNleCdnhrKy7iGCbOpKsPxaUqKiYWuuZ3CM0c6EewRstJs1hID67/RA4UEj6SXQOst/WwtEqqa8wEoonmcEIokEVSrV33Y99FUPhOmSrLsyYy7yI1ejnhTndjAkC7i7COoiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=mYk0Znp0; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=luj7dJe41qjgBXfEQGsLBJu7l5i/4o7jBwDDa7KAlus=; b=mYk0Znp08aCcY+Ic336QIre0BZ
	sVoL3PnxXvrOORMsYIETuK/PWQs504BTAD9Brae87iVZifHZ06YBhvJ8C/9E33WejRLErSnlFj/Nx
	snBkfsV6t9IPEboG/tNNDmcKJr18bxF4zVOCLkzbn7GawAZJQozYggfekACM1tJedwXYaIx+DWITC
	Xc+OcQO0O8ONH+ASxTq33PXFWOxfYJBS/ayCv1xa4YPZIV3NseMXyOrB3OxfcL1N/ybMNzOg3Txpe
	dpqmCLu3maFxGwG22Tcx5b8j5DhlsXvPUoFxDlRGxXS+DTvoxnANSF9wB0k7P1wjxDUQY/cUapgxW
	aiUvIQww==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98 #2 (Red Hat Linux))
	id 1ssDvC-0000000EZeJ-1NUa;
	Sun, 22 Sep 2024 04:10:06 +0000
Date: Sun, 22 Sep 2024 05:10:06 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: audit@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [RFC] struct filename, io_uring and audit troubles
Message-ID: <20240922041006.GC3413968@ZenIV>
References: <20240922004901.GA3413968@ZenIV>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240922004901.GA3413968@ZenIV>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Sun, Sep 22, 2024 at 01:49:01AM +0100, Al Viro wrote:

> * don't bother with audit_name creation and linkage in getname(); do that
> when we start using the sucker.  Doing that from __set_nameidata() will
> catch the majority of the stuff that ever gets audit_inode* called for it
> (the only exceptions are mq_open(2) and mq_unlink(2)).  Unfortunately,
> each audit_name instance gets spewed into logs, so we would need to
> bring the rest of that shite in, including the things like symlink
> bodies (note that for io_uring-originating symlink we'd need that done
> in do_symlinkat()), etc.  Unpleasant, that.

BTW, how much is exact order and number of PATH items in audit logs cast
in stone?

For example,
        char s[2][20] = {"/tmp/blah/x", "/tmp/blah/x"};
	rename(s[0], s[1]);
	rename(s[0], s[0]);

produces 2 items (both for /tmp/blah) on the first call, and only 1 on
the second.  Does anything care about preserving that distinction?

And what in audit_inode{,_child}() behaviour can be changed?  I mean, does
anything care about the loop directions when we pick the candidate
audit_name for conversion, etc.?

It's been a long time since I've touched audit, and I have done my best
to purge memories of the specifications ;-/

