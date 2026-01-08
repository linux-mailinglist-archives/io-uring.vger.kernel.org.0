Return-Path: <io-uring+bounces-11497-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 55CBED017E9
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 09:02:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DB77B3090DD4
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 08:01:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B4D43469E0;
	Thu,  8 Jan 2026 07:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="ekPboU6A"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63071341AD0;
	Thu,  8 Jan 2026 07:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857823; cv=none; b=nJn98ujS4K4nvSBMzH7ERyaA82v0nlBis3d1PCR39FksjXvw5g0Q19khNs6Bj6Jslpt6O3lbBLRHAwbov5kZ6rF1ikWkC3to7JhmpfEyJSocIPOwDMV6KDu9JHvk7SyDksgU5bwwUOi5JVvTd+KWpfOJP4VVqol1Se3q6qX2VDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857823; c=relaxed/simple;
	bh=ChpWIeg+38MgGLjdG9lHbGmsXI4DwNrcC5qNS+HG7IM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HZU8AjXUyECtns7rA7SLu9/1iCoOuTpbOnm3FrRx6vzp2PAyO9oUQuUEaUiwRxnNl1sZoHygliIFSttYSXohvLl30L9ixYZWU+o58qd8l1vhofGWA3HwdIZqgeSZIE/7SsP7MchMu1/dv2KUB7YrOZIs+CREq/o84O5G7pSAySo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=ekPboU6A; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=7a2XMJ0nbM/r82AQZ5Xoc360TFgnxmE4ZD+qqJbM6eU=; b=ekPboU6AOWobolBQnKLQ7XAimF
	b6N6WSE+lpW0Aa4UlUvcw7nyVACuzqw6nWJX2kqQZzsCk8UG5SxwVdS4QOjGX330IcJUIk8xRUAzA
	et8IXSkCLUPeVWfnxOsO18M9KAe7K9ysl/95zZixv1RI0k/x7dzD66n4/ZV/DxqJ3x2m+/to+v8iO
	NvJCUEY21WzR92jWqKBIIR0yVO2t6oEWoNSBDCKC0rCxTz0gCPCT0JQMMjk/B1KUitmAX9JwKfRcF
	M4+urEEeV8xy8xsTNMAMKSYAVtowAUVS+P9Vy58dsj8kagnY4Ml3Ojn50i1wulaCPXxkpcUVJ9c8k
	iBp5kFoA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkb0-00000001muv-2PmF;
	Thu, 08 Jan 2026 07:38:14 +0000
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
Subject: [PATCH v4 53/59] statx: switch to CLASS(filename_maybe_null)
Date: Thu,  8 Jan 2026 07:37:57 +0000
Message-ID: <20260108073803.425343-54-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260108073803.425343-1-viro@zeniv.linux.org.uk>
References: <20260108073803.425343-1-viro@zeniv.linux.org.uk>
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


