Return-Path: <io-uring+bounces-11660-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C622FD1C5FF
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:35:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C9A983081FBC
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:32:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 924F932ABDC;
	Wed, 14 Jan 2026 04:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="D7xCKeYL"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE37F2E92A6;
	Wed, 14 Jan 2026 04:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365116; cv=none; b=RqDFC3jq1NGuK+qKLnOJXnFUYLvXEKNPyyWLWSarLLq7RWhMy6LbCHDojEEnpU0vAoVpMhaen/k5DAuKzSIWj/AfioJnU1pM3ZafVYlbRXLjTKZXU1NLqmZi6sgcl3usr+S/kZ8kwDJU9CjNBBWR+mvNfz1lFmAeQ3oUie9HatE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365116; c=relaxed/simple;
	bh=5MEqgjhpmzI29H1uV/1SQLwXuo398WOo5iQ8G4kZTTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X9wW78QN9+G/ST7s+ZBUcmINkojwgU2QjoqYG8hYExvJWfo5QV9jOp81zDqbvbDcQQT6/8uUW2/FA+SAsz4AeUQ5ReGnBKL17RwBkJBzQ8NqF5bonoIKjEC8aAPn5vcSPZy/8PYi284Gu80/1lmnNg3u3AIHkIEhgBBMFzp4SPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=D7xCKeYL; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=H3lRaX9hzJYaGyPHgtEsqC7lsKDUGMd09oess7PslzA=; b=D7xCKeYLEI0WNdee+ydyGOjzcw
	1Co/TKXZVuiaE3tW7G/YvX05tfI/wKDFwsMgRb7HJnloYewWg6Pui9Cu8yGJIbtPLpj/yagT87jxP
	wWOSNbH3YAEUQ7KQhElOiZK0cokX0/UiBp9QXFZIRnMLz6L0bHT8YidvVa+9tvWsqVrnt+VZYlGqJ
	FXvwKD8S/8xjkCNycBmOpDgyiXTPVwpFIDIyDb+dQEHqMmLDybDxUWMXvKEbMDAhEO3RhWvmfdc/9
	FjLO12rzl4PcMkrnkmlecFMo/1JSIWPkMxbm7pd6c0Hah6kKopFoHcSBxhuTdmdoFOmmyRkgfcvvu
	qTg2M8IQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZD-0000000GInP-3h0c;
	Wed, 14 Jan 2026 04:33:11 +0000
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
Subject: [PATCH v5 12/68] user_statfs(): import pathname only once
Date: Wed, 14 Jan 2026 04:32:14 +0000
Message-ID: <20260114043310.3885463-13-viro@zeniv.linux.org.uk>
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

Convert the user_path_at() call inside a retry loop into getname_flags() +
filename_lookup() + putname() and leave only filename_lookup() inside
the loop.

In this case we never pass LOOKUP_EMPTY, so getname_flags() is equivalent
to plain getname().

The things could be further simplified by use of cleanup.h stuff, but
let's not clutter the patch with that.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/statfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/statfs.c b/fs/statfs.c
index a45ac85e6048..a5671bf6c7f0 100644
--- a/fs/statfs.c
+++ b/fs/statfs.c
@@ -99,8 +99,9 @@ int user_statfs(const char __user *pathname, struct kstatfs *st)
 	struct path path;
 	int error;
 	unsigned int lookup_flags = LOOKUP_FOLLOW|LOOKUP_AUTOMOUNT;
+	struct filename *name = getname(pathname);
 retry:
-	error = user_path_at(AT_FDCWD, pathname, lookup_flags, &path);
+	error = filename_lookup(AT_FDCWD, name, lookup_flags, &path, NULL);
 	if (!error) {
 		error = vfs_statfs(&path, st);
 		path_put(&path);
@@ -109,6 +110,7 @@ int user_statfs(const char __user *pathname, struct kstatfs *st)
 			goto retry;
 		}
 	}
+	putname(name);
 	return error;
 }
 
-- 
2.47.3


