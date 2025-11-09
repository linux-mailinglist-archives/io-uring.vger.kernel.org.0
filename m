Return-Path: <io-uring+bounces-10469-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 468FAC43954
	for <lists+io-uring@lfdr.de>; Sun, 09 Nov 2025 07:38:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A1A373B2AEE
	for <lists+io-uring@lfdr.de>; Sun,  9 Nov 2025 06:38:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FDA6251795;
	Sun,  9 Nov 2025 06:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="U7QNuNul"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340A921018A;
	Sun,  9 Nov 2025 06:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762670271; cv=none; b=f0kUUImSpqnTtaZAra9H6kAN6OfLb5Efx/1lJoFLdeWthG3745Vu8Q/sP9FwaHDebpWdsT7aemgXpN8H92CDqPCw1keauBmRqkVWQVyhsPt1O4jt7Q9er78f2anzwZUR2w+s/DU7lb8rgH+M2iOiMHf0Za8436zDa1giZOQOPpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762670271; c=relaxed/simple;
	bh=baMOPtk3nbJJvzRoLOvYH128FU/gcEoAgtiDd1Hx3fQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cuuYlHQWFLZw4mJYYvW0SVn1B8xosn+QHe1rrrs+vN6tHi+16qXYV5M02v+QWTj8t6xrqTvNZpWzQJQrOm9WN6MsIK/bzWQDILY4LDLP8s0Krf+I/w1HZ2wF6u+8VVoDUVfw3yQnEoYPX7L2MYaGFeJ0t5v7K+6Au2Gpp1XsHB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=U7QNuNul; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=cKIa+FRKqhlosKFiCPklZ3Ftnw6IS15CGX1Ala1Uzf8=; b=U7QNuNuljnugaMJd7aGc66iicY
	pAXh2QP5DGGAD25hrbS7qd7GVyOo8nbePZjl8vtIsL0cHrPedc/AhLEgLbQWhZ7SuwxbZ0by8jmsQ
	lHmGk2wwWlKVz2vIO6z//4Fez+44Rkydb+sPnx2yxF+sL1kiFJ0kqmU/sXJSG+GSEEz/EHdOpZr4k
	3ajgQTgTAP8CYNn0Nn28W9EPmil7ihagjXSdaGeqgRvR54aLOidmnfbEmc0S4Bn+8BTOA1gcZSXc7
	0+KZrIQmujHnzZK2ra7o6kh8vS7tq/3EBoWX7fo47Ng98FXIeuFbGjzlkJxODW2toywIy6Uywzoy3
	G95q212w==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vHz3Z-00000008lbC-3dq3;
	Sun, 09 Nov 2025 06:37:45 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: torvalds@linux-foundation.org,
	brauner@kernel.org,
	jack@suse.cz,
	mjguzik@gmail.com,
	paul@paul-moore.com,
	axboe@kernel.dk,
	audit@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: [RFC][PATCH 01/13] do_faccessat(): import pathname only once
Date: Sun,  9 Nov 2025 06:37:33 +0000
Message-ID: <20251109063745.2089578-2-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251109063745.2089578-1-viro@zeniv.linux.org.uk>
References: <20251109063745.2089578-1-viro@zeniv.linux.org.uk>
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
index 3d64372ecc67..db8fe2b5463d 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -471,6 +471,7 @@ static int do_faccessat(int dfd, const char __user *filename, int mode, int flag
 	int res;
 	unsigned int lookup_flags = LOOKUP_FOLLOW;
 	const struct cred *old_cred = NULL;
+	struct filename *name;
 
 	if (mode & ~S_IRWXO)	/* where's F_OK, X_OK, W_OK, R_OK? */
 		return -EINVAL;
@@ -480,8 +481,6 @@ static int do_faccessat(int dfd, const char __user *filename, int mode, int flag
 
 	if (flags & AT_SYMLINK_NOFOLLOW)
 		lookup_flags &= ~LOOKUP_FOLLOW;
-	if (flags & AT_EMPTY_PATH)
-		lookup_flags |= LOOKUP_EMPTY;
 
 	if (access_need_override_creds(flags)) {
 		old_cred = access_override_creds();
@@ -489,8 +488,9 @@ static int do_faccessat(int dfd, const char __user *filename, int mode, int flag
 			return -ENOMEM;
 	}
 
+	name = getname_uflags(filename, flags);
 retry:
-	res = user_path_at(dfd, filename, lookup_flags, &path);
+	res = filename_lookup(dfd, name, lookup_flags, &path, NULL);
 	if (res)
 		goto out;
 
@@ -530,6 +530,7 @@ static int do_faccessat(int dfd, const char __user *filename, int mode, int flag
 		goto retry;
 	}
 out:
+	putname(name);
 	if (old_cred)
 		put_cred(revert_creds(old_cred));
 
-- 
2.47.3


