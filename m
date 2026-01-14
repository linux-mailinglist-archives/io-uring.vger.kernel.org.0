Return-Path: <io-uring+bounces-11665-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id ACD42D1C632
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:36:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2AF48309C116
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:32:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35B4A32D0E8;
	Wed, 14 Jan 2026 04:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="NSJc3nsV"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB110302151;
	Wed, 14 Jan 2026 04:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365117; cv=none; b=UOVvLPDqiFy3syjKjzMkWgfrs8+1kOqgVXeF2ODETqzsM8YiN2PseAM/jRB9vNJl4Y3xed/dGyB+pu7afip8C8fF4zLozl59Zrwmg6vjnnnMUbJxRtaVRLqiz/0+51Jviwn9fi5T+LcVu5WfeHXKgiZa3y+N2Hwm/hUvYSTS8rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365117; c=relaxed/simple;
	bh=9rjy/O7zk9NHa0zEpN/u8HwvuzoJz5ExAtWTchA9beE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mypBYSi+MJOQsR6EsF2DghFOb0v5bznTE0lN7HtFyhe7Vih47Kn9XT/hi/0tIoh7RtPoBj2ygZHvXf0pfJqZxnigYVTkBbqU0x72bQUwkRD/v1OHrJapnL6r08TGVl+ahNueoZa/0aEgoT29p8hq5j7MrlZgA8Tc9RAJypuS/BU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=NSJc3nsV; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=W1bsT0yqh7PPRDzd1LW2lGzYKFRbDxQSk7TwwEivM5Q=; b=NSJc3nsVmPJoZ2JmtZS3Roy38L
	xrfbGlO0rxCV1kL4TD2CyFo5eHExYKMnyMlbRCoU31Q9GjufK2g5+0GfYtJnndhFLb6CDj8/Y3OOB
	gZwr2BtVlWxTxKkEREjqjSJi9SJngv7e6y4IcK51S50CekJ72QGpfPYY1bIGkilpYgsHfT4AmMS4G
	615ooNE93tWKgkLk0rIok/eFtdP22yBOtce7qeSOh+g/7lWKz4hsJ/r1uGC5FKbzMMO5fXchNGfzn
	OIvTCG1j80ADQt67P2JAcu0G3sh1N748oejjFODhQXMz+OY9ulscM0s1B/b/O5nAs+EP/gCBTzrA8
	4X2AY7mw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZL-0000000GIwc-1dFX;
	Wed, 14 Jan 2026 04:33:19 +0000
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
Subject: [PATCH v5 51/68] do_fchownat(): unspaghettify a bit...
Date: Wed, 14 Jan 2026 04:32:53 +0000
Message-ID: <20260114043310.3885463-52-viro@zeniv.linux.org.uk>
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


