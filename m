Return-Path: <io-uring+bounces-11114-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A087FCC0ED4
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 05:43:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id F3EB0314A48E
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 04:17:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B31AA32C921;
	Tue, 16 Dec 2025 04:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="J7xXFw34"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A248318132;
	Tue, 16 Dec 2025 04:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765858313; cv=none; b=bBT3udeoq//ZgHt9qIFIU3cdqXVO9xZky+jHQmqKGJ2rkg4VyMpApI13+xF2vG65+XTrhf7ynX0GRMEKe33JEhkwzq8vNQHZnEfiH++i+GwFX8oiq1Ge1sSg80cS2oj6uHMZmJ6mEqXzzjFsT/DGd5OM9Gtl0d22Wv/+ygZkLkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765858313; c=relaxed/simple;
	bh=flPREUjz226vbhFUNOUM/b2whXof1cRdtkFUivOyMAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mRWCF8gQMTDSYU0kw96JN57ZbHa7DIaXCQ6kpDf2/DZSGweZ0fkM2+/OSCcWcB/hmXa9y73/Br09/sWEcWbl4rAtrT559TtSSiwPDo3I9cLywK/x3/H1LxUajoG2AprjJRyRceUDGhnFzk4dzAk21KHnrf+ozoaZ1SDRgDoth8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=J7xXFw34; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=uZ4IKI6AXMjVP+nAvbUk5ps0UL7ywHeADF5WufBC7LU=; b=J7xXFw34TkAELI0/C1uvFceVBX
	wDMSw2INCQbhqCHQYNgsKVXogc3AA4MzN/aZZhhCpROTkeBk2bvPBq3bjq8ro/qHmmFsRGxImmZPY
	FRuK5XeOIaps+ZYC5zi4rydlaIKfDBXlYuhY9OBNYmMLzkAyz2O7RWRsphXI2rmlKnNtiNarbb1Or
	hZJlCh0iAx6xXvWtbEcieDDHfRthBCJga9vChabp1BJibR0A5GBpDsN9cp6Am3X/s3J7a4L+OPMBb
	/+h9iw/FEKObpkL35yzj25I+FzQcjYYOrnjTTlRE8SKSejoz0qV1tUS+zfTnfwEn5sins7EdWTETf
	I7J/c5Hg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVM9j-0000000GwMJ-0kUH;
	Tue, 16 Dec 2025 03:55:23 +0000
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
Subject: [RFC PATCH v3 43/59] do_f{chmod,chown,access}at(): use CLASS(filename_uflags)
Date: Tue, 16 Dec 2025 03:55:02 +0000
Message-ID: <20251216035518.4037331-44-viro@zeniv.linux.org.uk>
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


