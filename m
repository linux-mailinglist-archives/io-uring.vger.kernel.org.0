Return-Path: <io-uring+bounces-11675-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BECF3D1C66E
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:37:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A443030AEBA8
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:32:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7290533032D;
	Wed, 14 Jan 2026 04:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="BzXb+GIg"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F20D2D322E;
	Wed, 14 Jan 2026 04:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365118; cv=none; b=X1e0SDCYGs7Lv7YIQjWzkjTPbs7FMqglxN+RjPa+e9N/Jc9zJyAfmxTpne5ffGvn9uffH9fOTnpcmMvJ+ZrnDDsLVgoaqIk9+TclY3gvFvILe53+ylV9oO1tIZ7CCl+jwYoAM1qlqmGHFofVRLoqqzqFi87sCENO3I12ZyiY7II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365118; c=relaxed/simple;
	bh=ltTrYl7GN0DzsMvuK83DN/Ol0bNTuyKzVNTK64WoEE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gJuJxGbZBDv9sGESpIPCbfzULAqQNexrojjfyy0EKVKpwtf0cmjMMsHgZ0wYpN0TAeFSY3m8JPc50bs8C/mQ+xALr8tq0so/+FDdWzoaf+HqDIbNnwHiHulS4Wd+LdQKw0PDFTQvpMHlPld3q/47tnstWjGxGXhTR8tP2PWShwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=BzXb+GIg; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=qwJAhJsvJ2SJYlVcArGg+7WWNzPWS5syBQcg8iMXPSQ=; b=BzXb+GIgEXdqrLi17RZGZNANZf
	Q+oDAcNC8t4GVTt/oQZZwivpKseY2qwS2a38XPFoAqg4IILvSKG+z8teKqI/NAe2kqyAauEntCGg8
	AGi6sgscPQqcWDlVsx186ycLy1ZeZHlPyZIn2Et5C3UHpXaDJ8JNbVu8WgDPd4mw7uIbkuH5uNuBI
	dRvO2g1ond16LpiXxp94KgeUg3tD1AchXQ+GKw3WPLvRhRVWZRKAz8gK9KLJbrV466FtN6kq6CQcx
	Xwe9DlMSPk3QUzIUHiHG93/pszQi2LlofrgN7NeqzjVsqbJXovor01Z9r/SfbiAWngUuD8MlarWl6
	T4/u2XpA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZJ-0000000GItT-1oxt;
	Wed, 14 Jan 2026 04:33:17 +0000
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
Subject: [PATCH v5 46/68] mount_setattr(2): don't mess with LOOKUP_EMPTY
Date: Wed, 14 Jan 2026 04:32:48 +0000
Message-ID: <20260114043310.3885463-47-viro@zeniv.linux.org.uk>
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

just use CLASS(filename_uflags) + filename_lookup()

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/namespace.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 9d0d8ed16264..d632180f9b1a 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -4978,8 +4978,6 @@ SYSCALL_DEFINE5(mount_setattr, int, dfd, const char __user *, path,
 		lookup_flags &= ~LOOKUP_AUTOMOUNT;
 	if (flags & AT_SYMLINK_NOFOLLOW)
 		lookup_flags &= ~LOOKUP_FOLLOW;
-	if (flags & AT_EMPTY_PATH)
-		lookup_flags |= LOOKUP_EMPTY;
 
 	kattr = (struct mount_kattr) {
 		.lookup_flags	= lookup_flags,
@@ -4992,7 +4990,8 @@ SYSCALL_DEFINE5(mount_setattr, int, dfd, const char __user *, path,
 	if (err <= 0)
 		return err;
 
-	err = user_path_at(dfd, path, kattr.lookup_flags, &target);
+	CLASS(filename_uflags, name)(path, flags);
+	err = filename_lookup(dfd, name, kattr.lookup_flags, &target, NULL);
 	if (!err) {
 		err = do_mount_setattr(&target, &kattr);
 		path_put(&target);
-- 
2.47.3


