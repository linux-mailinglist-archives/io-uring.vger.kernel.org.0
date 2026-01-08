Return-Path: <io-uring+bounces-11473-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 160A3D01A65
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 09:51:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 266BA33D119C
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 08:40:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C2B2341079;
	Thu,  8 Jan 2026 07:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="JNmx3J0x"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A19329390;
	Thu,  8 Jan 2026 07:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857818; cv=none; b=Lnc0KGG9v0BoXtp4jFfO009XseV2qkh44PnbnW3U49qfoU1GrZ44aEt7zL8OChI7zMUbNT4F7T4yU5XK+XMq3qdMq8swovWt5zzKEUdjpiBUewsIflI+PBIqmpHgzgcQrwWpG4m5RvZrWw5MXQtYDCGvCCOyZ6gZef1Tfo2wHCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857818; c=relaxed/simple;
	bh=9rjy/O7zk9NHa0zEpN/u8HwvuzoJz5ExAtWTchA9beE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C+5JBEt+lNmguSnxpJ5ZNRpSWwgJ68EBC5oJ6bvGqSWCq6okaO/UtMzJiL6sidpIMZi1IWcQ82g3hebpTpGHZ6feYdXP7N5hu969ekbXkmZEF3yxXG9WeuWag6HoUqwCWIxvAv1jQrfO60aLqTFpuMbsnaw1cfM329vuGEwo7tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=JNmx3J0x; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=W1bsT0yqh7PPRDzd1LW2lGzYKFRbDxQSk7TwwEivM5Q=; b=JNmx3J0xlR4S8HPod/8cb/f1/m
	tBIyeI6yuTL+hef6WqvliNasat3TfkhP3cZhTvPHK762mdB6PM2AtlO3LC+w576P2px9jwHS4OcMK
	mKTQACrWceKnVxYani7zqS68KOWSZX/fZ042nOocenIsIS4IQ8Q9lpP0p+fFehdnKxDE8a5YeGh3H
	En4KxXqvpaZNnq3ghNHIBOD8Qut02+exvHCdEyHJiC+s5v5tYEFzN3PMdOh4R58ZyWV3XOTQBE7Uq
	G0iPaWVi4rR419UhBgTLl4i+QC26BL97kZfSV9+m6IrVVsko7aEVujOeHcrqv95d+sJxHmY+qnmfj
	raIv4t2w==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkax-00000001mqa-1qqB;
	Thu, 08 Jan 2026 07:38:11 +0000
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
Subject: [PATCH v4 39/59] do_fchownat(): unspaghettify a bit...
Date: Thu,  8 Jan 2026 07:37:43 +0000
Message-ID: <20260108073803.425343-40-viro@zeniv.linux.org.uk>
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
 fs/open.c | 28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 7254eda9f4a5..425c09d83d7f 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -810,30 +810,26 @@ int do_fchownat(int dfd, const char __user *filename, uid_t user, gid_t group,
 	struct path path;
 	int error;
 	int lookup_flags;
-	struct filename *name;
 
 	if ((flag & ~(AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH)) != 0)
 		return -EINVAL;
 
 	lookup_flags = (flag & AT_SYMLINK_NOFOLLOW) ? 0 : LOOKUP_FOLLOW;
-	name = getname_uflags(filename, flag);
+	CLASS(filename_uflags, name)(filename, flag);
 retry:
 	error = filename_lookup(dfd, name, lookup_flags, &path, NULL);
-	if (error)
-		goto out;
-	error = mnt_want_write(path.mnt);
-	if (error)
-		goto out_release;
-	error = chown_common(&path, user, group);
-	mnt_drop_write(path.mnt);
-out_release:
-	path_put(&path);
-	if (retry_estale(error, lookup_flags)) {
-		lookup_flags |= LOOKUP_REVAL;
-		goto retry;
+	if (!error) {
+		error = mnt_want_write(path.mnt);
+		if (!error) {
+			error = chown_common(&path, user, group);
+			mnt_drop_write(path.mnt);
+		}
+		path_put(&path);
+		if (retry_estale(error, lookup_flags)) {
+			lookup_flags |= LOOKUP_REVAL;
+			goto retry;
+		}
 	}
-out:
-	putname(name);
 	return error;
 }
 
-- 
2.47.3


