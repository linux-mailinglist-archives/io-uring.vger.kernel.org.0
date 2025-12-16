Return-Path: <io-uring+bounces-11060-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C88A8CC0C27
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 04:55:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C2600301C884
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 03:54:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25FB4314D05;
	Tue, 16 Dec 2025 03:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="eb5g0Wxa"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533C63112C2;
	Tue, 16 Dec 2025 03:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765857292; cv=none; b=WqGWaNq01iGOu8T1e5YtS4C7ZlQfeFwrGIpamq/NUx0c3wKRqC6zpbajHAfpIdUCT6QELow2GC9ct2q8XauzzW8EztIZGedlpGXI4QWa21CeXtW8tW9nsvjIcxCjgIVRDOTXXL0wVrZz9JqIGwUUlcdHw+aZRPVHU5f2SC2tDds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765857292; c=relaxed/simple;
	bh=5MEqgjhpmzI29H1uV/1SQLwXuo398WOo5iQ8G4kZTTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qo3cJz/0QdXdtRSiO2DVOOQXfa0C1TcPxmacoA2XDjSVBg9fwiRhzP/Cl8V4nmmluWWbgV96Qv3pENXZ+HOXmo3JsVP4JYVQl74LtTnx4zDd803gpOITgjW9bBBOkb7tZhpmZHpbdKn2imH3yfcLLo6Vh0VrDqemIS03fNFQ9mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=eb5g0Wxa; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=H3lRaX9hzJYaGyPHgtEsqC7lsKDUGMd09oess7PslzA=; b=eb5g0Wxazt+Ak80G5ERSgW1fD+
	0+lIuT/W0nNu0zsE8QO2dhchOeKq8AJyorJixpuB/zoGrbDaGjJoqiV30O8uD5n+Cqxhvt7YMkgBt
	NSjAdjqdik5mFHWESNO/+q2cqYDcbxz7DMhbHQ/OUuvWomhbs+pH4n2kl1ioiNuhfhGf7kfRNAC3o
	BRPvVmSiMNXn5fEEEPsWUBzqKTDYu3Cn2MHQJxM3UFgyh6+m7F/LmZ0AhEejO8YZ+tuw1lfBf65Hb
	XYlcj8QLNx54t2kwoZUZcvFRxKXWQjWcFdHFj8nStPPgk28k5vem9ZJD3oSDu2O9z0UjlWdXfwekM
	3Xn4LFTA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVM9f-0000000GwJ2-1AHS;
	Tue, 16 Dec 2025 03:55:19 +0000
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
Subject: [RFC PATCH v3 07/59] user_statfs(): import pathname only once
Date: Tue, 16 Dec 2025 03:54:26 +0000
Message-ID: <20251216035518.4037331-8-viro@zeniv.linux.org.uk>
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


