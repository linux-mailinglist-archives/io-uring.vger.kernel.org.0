Return-Path: <io-uring+bounces-11099-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E7E47CC0CD2
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 04:58:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BE87C305C1D3
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 03:55:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D235B32825D;
	Tue, 16 Dec 2025 03:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="DVJaQdtl"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E938311950;
	Tue, 16 Dec 2025 03:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765857297; cv=none; b=jibkMb66OhnVQ/pRexshHMsROZFabCmqlltGWvcDNiPyDpp5uTfQqDy2Kuti2xyNCvAfNjcmkfUXO3T9rj1C5v3wqjhOnzM81bNsQ82xJqVBO5M3pgOMdkI50HDO6ADjTovWXwCq2QLfQfXUqf1bs15K/NYeeY0cX4gpHpNDSZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765857297; c=relaxed/simple;
	bh=aacmgBkIekWcKT1nYvHuUWkKevrQq3dWCTP/f16lQvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QlHPFeJWdHGSjUtpRhHBm9M5wqeOS8b0r/TmzSx102jAzcMD0K5XOjnrYbSzgtfCKAfyTweFUO6qYAZbXmRm4gAZZjwKtN3u9Ev47F11frk/WhzUa1q4614raXuXrAAqBWOg0T0upYtyV+in2A0gNfMKBteEov/G9X44yq6zbF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=DVJaQdtl; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=F3fmLDfzzCSFX0fX01qQzZyvJwhOF7I5P+jzcyU8rOk=; b=DVJaQdtli/wYnfwrZoSZrxP90S
	OG38WcF+hThzXIjy//xAzteO2n79CqkD0B+YZRPnB5ZyjnFBxO26Q5IA80CA9c5L8dDwa54hhu9hN
	vSEQal6aG6Ne+Bf0MIwhpjwMLI0VBDorC4wj0rerBa/61A8k9c85v+3dSYXVlVtLdq1kgcjXw+AIJ
	mIiuh8Gz41uJMmSa4sTPltjbB368X8NvIpZkeIo+N3GpsolBs6JXmh1hfLdC1ZlmYHQLugvm7Usam
	ow5/82d1zmOVSfM6u6kMC/B0oc2YXVeEvsVutk640+J/7O8gGpk5DY6D0YxzxP9tLlmrf6b75bU0Z
	3NugIP/A==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVM9e-0000000GwIa-2ljp;
	Tue, 16 Dec 2025 03:55:18 +0000
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
Subject: [RFC PATCH v3 01/59] do_faccessat(): import pathname only once
Date: Tue, 16 Dec 2025 03:54:20 +0000
Message-ID: <20251216035518.4037331-2-viro@zeniv.linux.org.uk>
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


