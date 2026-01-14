Return-Path: <io-uring+bounces-11685-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 41A39D1C6AA
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:38:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9E63A30CAC22
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:33:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E902B3314DC;
	Wed, 14 Jan 2026 04:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="cA7NNjjX"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2CE326D5C;
	Wed, 14 Jan 2026 04:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365120; cv=none; b=t+VWyoVEXpjLT8bXcHIF/9+pOHq6d+yVKl33Jq+dXhP7EjqNH5RgMPQSrpwDlLNVcMMMJJRqhkSYJW1rd1PTTT5M1gqS5bKj+aiwb99CW+w2Lt2WhwXZKWuxmGyoh2jMjm5PIzdKpN/cipJpeMwGGguNiXE98pYxhRxs1qM+lBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365120; c=relaxed/simple;
	bh=ChpWIeg+38MgGLjdG9lHbGmsXI4DwNrcC5qNS+HG7IM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EZASuXCWSr6lIX1KZJEI4Odx+UH6GZyCoPo5kVeHGVCNfS7ZhYjKhrHDz/JJkzo8XT6Wwmu8ou9SBFPst9t06MXZMVwTg6ppWobbLsmvFuuD2GiA8S8C+wb6MQBxWq2Nzp0FWLPq44pvlDmH/PCgxa0LouMQRv78IJ/DLO9USqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=cA7NNjjX; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=7a2XMJ0nbM/r82AQZ5Xoc360TFgnxmE4ZD+qqJbM6eU=; b=cA7NNjjXEdMOJLa4ANPDvyB8Ep
	zQBOTvemSy1/Q7ZIoftYr4CnKO3fU7uE9+7DF8toHIcv+7RD96g2k3h2Qn09F51zY5gzLW5t5/gGL
	rTT6UMdh1DiL+ryHFeIPrb3iZK7xKuyviwbcqtCds0qb+SJNBnGHp0O7/dk0AIXiB4z7NuOmHkhqx
	5vKufpvhFTuqyA+BIayL2NUdFlxhm6wU1uDhWbg9lyZCvMZs/LE/CDU2anagXKnt83isKXTX+xCaE
	/FNhMstfV1lg9J11OfSz0qrR6E5BTq8hKHoTSIjjJLDGnfCIHQe6xYl5G0ZX93zxukHtKyKP+cxfA
	yeGenTgQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZN-0000000GIzj-3e9n;
	Wed, 14 Jan 2026 04:33:21 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Jens Axboe <axboe@kernel.dk>,
	audit@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 63/68] statx: switch to CLASS(filename_maybe_null)
Date: Wed, 14 Jan 2026 04:33:05 +0000
Message-ID: <20260114043310.3885463-64-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260114043310.3885463-1-viro@zeniv.linux.org.uk>
References: <20260114043310.3885463-1-viro@zeniv.linux.org.uk>
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


