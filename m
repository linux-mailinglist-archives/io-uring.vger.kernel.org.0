Return-Path: <io-uring+bounces-11075-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AC90ECC0C6F
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 04:56:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 013FD301DE1F
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 03:55:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 707E031A54A;
	Tue, 16 Dec 2025 03:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="RRO+yPrB"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EEA1311C38;
	Tue, 16 Dec 2025 03:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765857294; cv=none; b=aPtljl1KJtusWfKfD3nVs/88mCKrzZQ/E+07RI0RicgkwocnVlkcncR/kDDut8DdnZq2wQMseFgXxXEPFpu0LIi22id7gqPozgSFoqTkej5IpH5Tm09enC6qdCnMXFK9+TokQDBh2a3J70wHsjfLFYEqQLRwNLC3B2VHlfLTLIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765857294; c=relaxed/simple;
	bh=ChpWIeg+38MgGLjdG9lHbGmsXI4DwNrcC5qNS+HG7IM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sIGTCEQ2JtjAQ4ZJa5yFevW/FUdjq2eT/M9TqwcYalspt9WHKyo++Was4PMbA81vIHsSNqwL+Jl4OidZuiTIKuLWQQt1RdkuNLnJ15XoDQjp5z+LgHcEgBEPgCEWTar4gDC5O8CXx0KQBiuydRApBMwXRJFsqd6ONu9pDALrCDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=RRO+yPrB; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=7a2XMJ0nbM/r82AQZ5Xoc360TFgnxmE4ZD+qqJbM6eU=; b=RRO+yPrBA0OLZGzjUl7zd1tczc
	dLLuOlkeDF0YI+BUOjq1jUkFvkXSd90KBhtHfKdd//PSBliS158ZS57Nz2fO64eBxlnlQaFi5LFIM
	QN5H5MTWR+Y7Rk1RONfV0CmDIk06rQ7cz3LagYD+wfsd1LFbvgEdFnNiFsuSIUKwkFLnLomGqXObJ
	sTX5kS/yIvp9fh8TmlL9SiLL95jW7b64xjY9WRHIaP81ieM3aVxESPifGjV+LKIcLIWFllVaNA7rx
	JkbOvC6SAGheYTGYtwUPCBOOQt1hCFbL9yy8cBZZ3SeWVcOU5hIy3/i1Idb4+vxYh692OIb+y8Dka
	P6My6AHQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVM9k-0000000GwNx-24q8;
	Tue, 16 Dec 2025 03:55:24 +0000
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
Subject: [RFC PATCH v3 54/59] statx: switch to CLASS(filename_maybe_null)
Date: Tue, 16 Dec 2025 03:55:13 +0000
Message-ID: <20251216035518.4037331-55-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216035518.4037331-1-viro@zeniv.linux.org.uk>
References: <20251216035518.4037331-1-viro@zeniv.linux.org.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Al Viro <viro@ftp.linux.org.uk>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/stat.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/fs/stat.c b/fs/stat.c
index d18577f3688c..89909746bed1 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -365,17 +365,13 @@ static int vfs_statx(int dfd, struct filename *filename, int flags,
 int vfs_fstatat(int dfd, const char __user *filename,
 			      struct kstat *stat, int flags)
 {
-	int ret;
-	int statx_flags = flags | AT_NO_AUTOMOUNT;
-	struct filename *name = getname_maybe_null(filename, flags);
+	CLASS(filename_maybe_null, name)(filename, flags);
 
 	if (!name && dfd >= 0)
 		return vfs_fstat(dfd, stat);
 
-	ret = vfs_statx(dfd, name, statx_flags, stat, STATX_BASIC_STATS);
-	putname(name);
-
-	return ret;
+	return vfs_statx(dfd, name, flags | AT_NO_AUTOMOUNT,
+			 stat, STATX_BASIC_STATS);
 }
 
 #ifdef __ARCH_WANT_OLD_STAT
@@ -810,16 +806,12 @@ SYSCALL_DEFINE5(statx,
 		unsigned int, mask,
 		struct statx __user *, buffer)
 {
-	int ret;
-	struct filename *name = getname_maybe_null(filename, flags);
+	CLASS(filename_maybe_null, name)(filename, flags);
 
 	if (!name && dfd >= 0)
 		return do_statx_fd(dfd, flags & ~AT_NO_AUTOMOUNT, mask, buffer);
 
-	ret = do_statx(dfd, name, flags, mask, buffer);
-	putname(name);
-
-	return ret;
+	return do_statx(dfd, name, flags, mask, buffer);
 }
 
 #if defined(CONFIG_COMPAT) && defined(__ARCH_WANT_COMPAT_STAT)
-- 
2.47.3


