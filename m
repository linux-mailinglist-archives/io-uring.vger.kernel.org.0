Return-Path: <io-uring+bounces-11513-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 70DE7D01BE1
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 10:09:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E42D43003788
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 09:04:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D96D335B144;
	Thu,  8 Jan 2026 07:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="SInSFdnw"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2119F35970E;
	Thu,  8 Jan 2026 07:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767858053; cv=none; b=VbzXN83jORKcNZpUmxMOq++QQebXRkSjdBZSekp8VgoUD4o/v6mTO566DBuacil6URbzA/8jWNmX/fRf8ScmAcIq5rydCt0TduhNnGdcj335oi6mgXEMZKKGBO8EpNIrDCg8VnEf9gAyV3Pqw2hxwAi9XuyKJLq8GEgfV2aN8Rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767858053; c=relaxed/simple;
	bh=y0fSS88FaLD/1hjr9i8JnMRqbkv5ATcNAM09cFE0wiE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rZbcHookGjibRnBRSROv0vdr6CZrYc5Bitylj0pDHMeN259MXmf6laAJsRXg8ojKMr/D3O3ANXMPh4ZFmqKVolZWKEUaR4kkGMNqe4X3AzuQEA28AifnSRJewyOsgBVdV3vUpfSRRhOJt08FgbktUJlEt8Y/J70z0EGy4zUHk5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=SInSFdnw; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=RqSr8nXaCST8kjVIFWUJupZ4lw+rAvvvW2rbESyuJxE=; b=SInSFdnwlKfcAp42G4d9ZZ9vsA
	x6T9H5E4gk06wTZxFCrz8uPEJKB4wlE4AaFHh6fn8f8741W42xLwUcV3lLAxfX3mPvRjHZHF+rHZp
	4ux+93s+ktvy18/CQpX7Tl+g2eSFGyHTEavqe54WeczrGqCpqphD67LqP5gYyWv+CE65U++vOSqH+
	rdeCG5UgxB099X9AwYQ1cV92b0OylpzKx67PBWoeWC5Axjr+8aCPqw47foFQuUeOYpDyxRyip5W28
	py1YlTLqFxDzgijFOzE9S0hkdjv5uzMPTjrCqslN/S/Zo6RXdJmCcSyESttg/bgMAz2fINoUGcpbL
	1U3/xoZw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkef-00000001pEr-0jmD;
	Thu, 08 Jan 2026 07:42:01 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: torvalds@linux-foundation.org,
	brauner@kernel.org,
	jack@suse.cz,
	mjguzik@gmail.com,
	paul@paul-moore.com,
	axboe@kernel.dk,
	audit@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/8] experimental struct filename followups
Date: Thu,  8 Jan 2026 07:41:53 +0000
Message-ID: <20260108074201.435280-1-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Al Viro <viro@ftp.linux.org.uk>

This series switches the filename-consuming primitives to variants
that leave dropping the reference(s) to caller.  These days it's
fairly painless, and results look simpler wrt lifetime rules:
	* with 3 exceptions, all instances have constructors and destructors
happen in the same scope (via CLASS(filename...), at that)
	* CLASS(filename_consume) has no users left, could be dropped.
	* exceptions are:
		* audit dropping the references it stashed in audit_names
		* fsconfig(2) creating and dropping references in two subcommands
		* fs_lookup_param() playing silly buggers.
	  That's it.
If we go that way, this will certainly get reordered back into the main series
and have several commits in there ripped apart and folded into these ones.
E.g. no sense to convert do_renameat2() et.al. to filename_consume, only to
have that followed by the first 6 commits here, etc.

For now I've put those into #experimental.filename, on top of #work.filename.
Comments would be very welcome...

Al Viro (8):
  non-consuming variant of do_renameat2()
  non-consuming variant of do_linkat()
  non-consuming variant of do_symlinkat()
  non-consuming variant of do_mkdirat()
  non-consuming variant of do_mknodat()
  non-consuming variants of do_{unlinkat,rmdir}()
  execve: fold {compat_,}do_execve{,at}() into their sole callers
  do_execveat_common(): don't consume filename reference

 Documentation/filesystems/porting.rst |  8 +++
 fs/coredump.c                         |  3 +-
 fs/exec.c                             | 87 ++++++++-------------------
 fs/init.c                             | 22 ++++---
 fs/internal.h                         | 14 ++---
 fs/namei.c                            | 87 +++++++++++++++------------
 io_uring/fs.c                         | 25 +++++---
 7 files changed, 117 insertions(+), 129 deletions(-)

