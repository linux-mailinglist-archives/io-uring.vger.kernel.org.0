Return-Path: <io-uring+bounces-3257-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7119497DF9A
	for <lists+io-uring@lfdr.de>; Sun, 22 Sep 2024 02:49:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 61CBAB20BBC
	for <lists+io-uring@lfdr.de>; Sun, 22 Sep 2024 00:49:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 249D918EFCC;
	Sun, 22 Sep 2024 00:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="AylD5jAS"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 580BD18EFC5;
	Sun, 22 Sep 2024 00:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726966147; cv=none; b=gQD8CWDvVJ+pzWpaHKiXn424vi5CFrLG7OHq7frq9uzMQty91tHYaoXybQiydKEs0NzXVLyf4qOP+Wmw3f0sGDfKPUzs8X51zBjRPegASr7F/7Dw95o0oWDCUS92oEA/+sCl2D9aiiNUpzozCfQ9TPdM5MitbOLT5W4LAICohQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726966147; c=relaxed/simple;
	bh=H6FLgymN+EvqaI2jCLVxaOQjwpiv6Oos9XrGRUPQoDM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=dOC60rKouRx+qw/OEXcm0R2qDNNitwMtw648ISx51ZZUE4EjHD9OprJf2hTJ4FGcAjiK96f7j1lYcnIjTlmWb+vnVY73jGDH1KJFaYukqv3+nUCTLg8eMFYeQFK3KQovQJ2z7DbKGncfwbyahOR3+bgTnlryYNGV2p8lc5kQyiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=AylD5jAS; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=dL4fqJSchammBoaFLHOQnJXekzu+Kyp9nHrzvajQPpE=; b=AylD5jASxY0z570bzQpKvl1bJc
	zgpmhoabY6c1jYzEjfl2plFWjc8ByTlRKMR+ahEzz2+vi+reKlvp0eCWNsSABhpkBk4h/tXSY99N0
	lsnaFwNmvDms0xydutg37zf9sYLGqTT9qUeRGFNM5Ldz0p5/uGgib3DVRmAP27iG5zE+J4oxWve+S
	vlYF5VyXOK04xJo9xgUWLY5mb6iGEa65Ug24fftDQq/jkpyPL4c9vD0prj6bsw66lkAl44fUqhbo2
	YRNsGImD2q0RUeUZCGSkOE5U08AQ7TRAP0f0yoq2+vJk5DgwpYlk6o+/ExoEf+glJu+78cQp7AhHr
	Oz8tYhBg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98 #2 (Red Hat Linux))
	id 1ssAmb-0000000EWZO-1SnI;
	Sun, 22 Sep 2024 00:49:01 +0000
Date: Sun, 22 Sep 2024 01:49:01 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: audit@vger.kernel.org, io-uring@vger.kernel.org
Subject: [RFC] struct filename, io_uring and audit troubles
Message-ID: <20240922004901.GA3413968@ZenIV>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Al Viro <viro@ftp.linux.org.uk>

	Looks like things like async unlink might fuck the audit
very badly.  io_uring does getname() in originating thread and uses the
result at the time of operation, which can happen in a different thread.
Moreover, by that time the original syscall might have very well returned.

	The trouble is, getname() establishes linkage between the struct
filename and struct audit_name; filename->aname and audit_name->name
respectively.  struct filename can get moved from one thread to another;
struct audit_name is very much tied to audit_context, which is per-thread
- first few (5, currently) audit_name instances are embedded into
audit_context.	The rest gets allocated dynamically, but all of them
are placed on audit_context::names_list.

	At audit_free_names() they are all wiped out - references
back to filename instances are dropped, dynamically allocated ones
are freed, and while embedded ones survive, they are zeroed out on
reuse by audit_alloc_name().  audit_free_names() is called on each
audit_reset_context(), which is done by __audit_syscall_exit() and
(in states other than AUDIT_SYSCALL_CONTEXT) __audit_uring_exit().

	Linkage from filename to audit_name is used by __audit_inode().
It definitely expects the reference back to filename to be stable.
And in situation when io_uring has offloaded a directory operation to
helper thread, that is not guaranteed.

	Another fun bit is that both audit_inode() and audit_inode_child()
may bump the refcount on struct filename.  Which can get really fishy
if they get called by helper thread while the originator is exiting the
syscall - putname() from audit_free_names() in originator vs. refcount
increment in helper is Not Nice(tm), what with the refcount not being
atomic.

	Potential solutions:

* don't bother with audit_name creation and linkage in getname(); do that
when we start using the sucker.  Doing that from __set_nameidata() will
catch the majority of the stuff that ever gets audit_inode* called for it
(the only exceptions are mq_open(2) and mq_unlink(2)).  Unfortunately,
each audit_name instance gets spewed into logs, so we would need to
bring the rest of that shite in, including the things like symlink
bodies (note that for io_uring-originating symlink we'd need that done
in do_symlinkat()), etc.  Unpleasant, that.

* make refcount atomic, add a pointer to audit_context or even task_struct
in audit_name, have the "use name->aname if the type is acceptable"
logics in audit_inode dependent upon the name->aname->owner matching
what we want.  With some locking to make the check itself safe.

* make refcount atomic, get rid of ->aname and have audit_inode() scan
the names_list for entries with matching ->name and type - and that
before the existing scan with ->name->name comparisons.

* something else?

	Suggestions _not_ involving creative uses of TARDIS would
be welcome.

