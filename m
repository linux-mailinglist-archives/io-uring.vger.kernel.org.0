Return-Path: <io-uring+bounces-11492-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 38027D018A9
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 09:15:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A443C3139623
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 08:00:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D8043451C6;
	Thu,  8 Jan 2026 07:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="NfA1Z3b3"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E7133D4E2;
	Thu,  8 Jan 2026 07:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857822; cv=none; b=UtJ1L79wrEzFRl3baDwe8UxKj23N574P2vsL36NXLKQBW+NwG1JqJd0ujJMmX7XFB0ozS8cK+k8/82Mvd+GW95x57C7NbVTRJVF81KMHiTgBS60f5zBShyy0DVy4WBGMAIed8KUXqH9a9DUcVh2P9Dsf+0MsZFgPdTXEnmTW6LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857822; c=relaxed/simple;
	bh=flPREUjz226vbhFUNOUM/b2whXof1cRdtkFUivOyMAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c+PdpPZydznTn25E01XQV4J0Fui2p3te5VY3LyXiroovfiXLDApCrFVpkK5Spjk0V4pt7bIMRatDNaiG/3UjUkfZ5w58NF8N5fYIMTEqb3qh2F4VtWYyDYCkpLhkPIncfQk7md0KYPu5LpKRpxLelSYwxihu0WzxsIjsj6qPQWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=NfA1Z3b3; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=uZ4IKI6AXMjVP+nAvbUk5ps0UL7ywHeADF5WufBC7LU=; b=NfA1Z3b3t76p1on+DUEgD72MjZ
	Pw6DJlsefHFoI5w2pB/COi28F0kmiQA9KAz7UG5h+f2ShEF9dz4R6ohrAEBK5xYLnsdqf1Ur4I2Dl
	gCn7dPzI6PhnH3ddRxYkq2V8Y0d9sWGITeqtiqe+HYS4ZXWtjdpm1yzMuWMiLfvsLMOWI8nHycrnf
	sPELMKgus9sRinKI+vCm4gMR35VUELwJe1HxJCd7bUMZfBZTow+EK4KZHc2bGOQ5JcZsSf+sWrVTF
	2E3175NvF+BLLLcod/wr6AnEZ/1yzqEJeWBAb3/+xfPEGQTewJHRyyAt0f6nRdsyPkWCEQMTPMDVI
	wP3w+0/A==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkay-00000001msR-3Qeu;
	Thu, 08 Jan 2026 07:38:12 +0000
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
Subject: [PATCH v4 44/59] do_f{chmod,chown,access}at(): use CLASS(filename_uflags)
Date: Thu,  8 Jan 2026 07:37:48 +0000
Message-ID: <20260108073803.425343-45-viro@zeniv.linux.org.uk>
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
 fs/open.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 34d9b1ecc141..3c7081694326 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -469,7 +469,6 @@ static int do_faccessat(int dfd, const char __user *filename, int mode, int flag
 	int res;
 	unsigned int lookup_flags = LOOKUP_FOLLOW;
 	const struct cred *old_cred = NULL;
-	struct filename *name;
 
 	if (mode & ~S_IRWXO)	/* where's F_OK, X_OK, W_OK, R_OK? */
 		return -EINVAL;
@@ -486,7 +485,7 @@ static int do_faccessat(int dfd, const char __user *filename, int mode, int flag
 			return -ENOMEM;
 	}
 
-	name = getname_uflags(filename, flags);
+	CLASS(filename_uflags, name)(filename, flags);
 retry:
 	res = filename_lookup(dfd, name, lookup_flags, &path, NULL);
 	if (res)
@@ -528,7 +527,6 @@ static int do_faccessat(int dfd, const char __user *filename, int mode, int flag
 		goto retry;
 	}
 out:
-	putname(name);
 	if (old_cred)
 		put_cred(revert_creds(old_cred));
 
@@ -677,7 +675,6 @@ static int do_fchmodat(int dfd, const char __user *filename, umode_t mode,
 		       unsigned int flags)
 {
 	struct path path;
-	struct filename *name;
 	int error;
 	unsigned int lookup_flags;
 
@@ -685,7 +682,7 @@ static int do_fchmodat(int dfd, const char __user *filename, umode_t mode,
 		return -EINVAL;
 
 	lookup_flags = (flags & AT_SYMLINK_NOFOLLOW) ? 0 : LOOKUP_FOLLOW;
-	name = getname_uflags(filename, flags);
+	CLASS(filename_uflags, name)(filename, flags);
 retry:
 	error = filename_lookup(dfd, name, lookup_flags, &path, NULL);
 	if (!error) {
@@ -696,7 +693,6 @@ static int do_fchmodat(int dfd, const char __user *filename, umode_t mode,
 			goto retry;
 		}
 	}
-	putname(name);
 	return error;
 }
 
-- 
2.47.3


