Return-Path: <io-uring+bounces-11631-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C625D1C581
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:32:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0060C3046766
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:32:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FA772F0C49;
	Wed, 14 Jan 2026 04:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="ceNaE1sS"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E82562DCF6C;
	Wed, 14 Jan 2026 04:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365112; cv=none; b=hNMTHAYECuRf2SvF86cQRdsj+KPYpHHJzMCHZIY2n0Mvl4rKKhSmMArAwIsdIFDk8C8eo6/HfXdPXjPntKURTN77Rz2JOUYZgF+DP8DdYi73zMbuDK045fUAR0+be4cndQj+dspql8KNP0jluo1YWQfrxjfMdE5ZN3zD5Hf1u/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365112; c=relaxed/simple;
	bh=aacmgBkIekWcKT1nYvHuUWkKevrQq3dWCTP/f16lQvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dMMWRw/gVaXq05JvypA+09Zsr29tyxSqCFNfmkGACYuFRQBBVBgiUQVXU21NLN2kE7WP+S3p+R3qr8CKIJkKEJxxHXwOXY6V7ArlrCnYtBsWewNCzy3HkkF0+bHhLQXYX7nyuRa4KQc3a7ICToUTReP5YXqNi+7uqzCtmw5SgLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=ceNaE1sS; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=F3fmLDfzzCSFX0fX01qQzZyvJwhOF7I5P+jzcyU8rOk=; b=ceNaE1sS/zgPYbDGwQH4S6r0bD
	WC+quE5EMv+dfUrAgY3h1aCIHMUDrm/scyKauOzy+GGkK9WRJ3Vu+2CC3UvH0dnpDoFryRKcng4Tn
	WfMLHoAWac31HtMheTdR3/NPHQ/PczBciz4S7KwRS1IBcwcB0jvJ0BjewvRb9jVQNPMX+sQCAK+6o
	bDTvL9amooLrCIinOvmPpNocVMwgO8KE5ObMnr7krjECOn10UDU7Ln0OAE7kMgnIVqlMybcxVNmFS
	0dplpXw+NyLJb1mI/2gF6jS1eDzfZy3LLbq15Ff5E223iMtMyuWTVKbdv1fOFrZaJzhnPVIpIvFxt
	6GxNjUZA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZD-0000000GInA-15Op;
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
Subject: [PATCH v5 06/68] do_faccessat(): import pathname only once
Date: Wed, 14 Jan 2026 04:32:08 +0000
Message-ID: <20260114043310.3885463-7-viro@zeniv.linux.org.uk>
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

Since we have the default logics for use of LOOKUP_EMPTY (passed iff
AT_EMPTY_PATH is present in flags), just use getname_uflags() and
don't bother with setting LOOKUP_EMPTY in lookup_flags - getname_uflags()
will pass the right thing to getname_flags() and filename_lookup()
doesn't care about LOOKUP_EMPTY at all.

The things could be further simplified by use of cleanup.h stuff, but
let's not clutter the patch with that.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/open.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index f328622061c5..f3bacc583ef0 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -468,6 +468,7 @@ static int do_faccessat(int dfd, const char __user *filename, int mode, int flag
 	int res;
 	unsigned int lookup_flags = LOOKUP_FOLLOW;
 	const struct cred *old_cred = NULL;
+	struct filename *name;
 
 	if (mode & ~S_IRWXO)	/* where's F_OK, X_OK, W_OK, R_OK? */
 		return -EINVAL;
@@ -477,8 +478,6 @@ static int do_faccessat(int dfd, const char __user *filename, int mode, int flag
 
 	if (flags & AT_SYMLINK_NOFOLLOW)
 		lookup_flags &= ~LOOKUP_FOLLOW;
-	if (flags & AT_EMPTY_PATH)
-		lookup_flags |= LOOKUP_EMPTY;
 
 	if (access_need_override_creds(flags)) {
 		old_cred = access_override_creds();
@@ -486,8 +485,9 @@ static int do_faccessat(int dfd, const char __user *filename, int mode, int flag
 			return -ENOMEM;
 	}
 
+	name = getname_uflags(filename, flags);
 retry:
-	res = user_path_at(dfd, filename, lookup_flags, &path);
+	res = filename_lookup(dfd, name, lookup_flags, &path, NULL);
 	if (res)
 		goto out;
 
@@ -527,6 +527,7 @@ static int do_faccessat(int dfd, const char __user *filename, int mode, int flag
 		goto retry;
 	}
 out:
+	putname(name);
 	if (old_cred)
 		put_cred(revert_creds(old_cred));
 
-- 
2.47.3


