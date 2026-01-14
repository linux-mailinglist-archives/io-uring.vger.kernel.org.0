Return-Path: <io-uring+bounces-11645-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C45DAD1C5E4
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:34:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7396D302F912
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:32:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52D68327210;
	Wed, 14 Jan 2026 04:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="Y1v3PAT4"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F9A2DC34E;
	Wed, 14 Jan 2026 04:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365114; cv=none; b=iJnI6tGAUJZIGRck234iOonKLxLK1+4nWt90yNqVknNl6IWBuQDIR3WgjHfTt8I/AfwSALXD5YpG01MW4x/kV4msa8X7CiMHHsYRe2dGn96CXOIwpGx36C6/yxRyHVgpWOmLswWwz+q+suXh7P/6v/2e2GJj7TGQTq69gGby8UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365114; c=relaxed/simple;
	bh=1T9eJEuB6l9T+/4WSvz0MwkQ6ZS9+2XOjVOn7L1MH44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iQaTcJfQkEso5IASaKSdSPtjXSRb1FnT+5SAVHIz6LkfZQb6K+FCOIvPBugXZRcxV5ydGQx4EGdOyzwgdf3xSpsIUCtn+5REnvxfBg5EtcdofjwGEc6k1zFu1BzBbm71dDBPRIB6Dx05s6RD8TsdwIzWsepeduiM0x3dXniIPys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=Y1v3PAT4; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=KpWOI8XMVeq41RdiPMuRug/lWmTpOFPv9An76fDH+Fk=; b=Y1v3PAT4aVTWLpvyKMFJ7A8roL
	kTNB4yZQQe2SfDvPFD8HTZSncSDVh8cZIf4LraYO8+DZCCtvSWwJR2zDGezVP7NHltFYAz1rJk1uZ
	ARD7oOcqr9RtoiM5Dq6XRBFyqFcjBZVuNrmrl5Zs5qM/qAU3Rg5OEIhZjIY44w/krsZ2yHQDK3TvJ
	iN9EOgRKc2BgImuD3ryiMedob4NWwJ8a9nzA1zvpCCyvQlv8100RhVxJGnl/E9jx+seNhpsPSZEQW
	ouWAqaCr57mqiZeYbtEFf1N3b3jdmYHZ+CNzLyJ+/dMB0LLUaRwiS0gXXtfUiU2YlK+7U3NxjocwJ
	5IqzN0xg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZJ-0000000GIt3-18FK;
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
Subject: [PATCH v5 45/68] file_[gs]etattr(2): switch to CLASS(filename_maybe_null)
Date: Wed, 14 Jan 2026 04:32:47 +0000
Message-ID: <20260114043310.3885463-46-viro@zeniv.linux.org.uk>
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
 fs/file_attr.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/file_attr.c b/fs/file_attr.c
index f44ce46e1411..42721427245a 100644
--- a/fs/file_attr.c
+++ b/fs/file_attr.c
@@ -374,7 +374,6 @@ SYSCALL_DEFINE5(file_getattr, int, dfd, const char __user *, filename,
 		unsigned int, at_flags)
 {
 	struct path filepath __free(path_put) = {};
-	struct filename *name __free(putname) = NULL;
 	unsigned int lookup_flags = 0;
 	struct file_attr fattr;
 	struct file_kattr fa;
@@ -395,7 +394,7 @@ SYSCALL_DEFINE5(file_getattr, int, dfd, const char __user *, filename,
 	if (usize < FILE_ATTR_SIZE_VER0)
 		return -EINVAL;
 
-	name = getname_maybe_null(filename, at_flags);
+	CLASS(filename_maybe_null, name)(filename, at_flags);
 	if (!name && dfd >= 0) {
 		CLASS(fd, f)(dfd);
 		if (fd_empty(f))
@@ -428,7 +427,6 @@ SYSCALL_DEFINE5(file_setattr, int, dfd, const char __user *, filename,
 		unsigned int, at_flags)
 {
 	struct path filepath __free(path_put) = {};
-	struct filename *name __free(putname) = NULL;
 	unsigned int lookup_flags = 0;
 	struct file_attr fattr;
 	struct file_kattr fa;
@@ -458,7 +456,7 @@ SYSCALL_DEFINE5(file_setattr, int, dfd, const char __user *, filename,
 	if (error)
 		return error;
 
-	name = getname_maybe_null(filename, at_flags);
+	CLASS(filename_maybe_null, name)(filename, at_flags);
 	if (!name && dfd >= 0) {
 		CLASS(fd, f)(dfd);
 		if (fd_empty(f))
-- 
2.47.3


