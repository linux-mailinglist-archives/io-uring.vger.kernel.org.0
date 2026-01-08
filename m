Return-Path: <io-uring+bounces-11455-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id DEDB2D016D8
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 08:38:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4124F302CDF6
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 07:37:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 292BB33A029;
	Thu,  8 Jan 2026 07:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="eVbC3rfh"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8276D3009EA;
	Thu,  8 Jan 2026 07:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857812; cv=none; b=oiULkc8lz+tAVY4tseethdDZOWQUpzXaC0apLkSrRQx6LNJTxCzRxCtPzNWQwblooBAsTT5/PxiVQ+gox91tHZLPNHuEjwyXquFdw/XSIPWutJgV41JRJDaEuL2vtY2VxsQzCG/YsPYopFSgwXJCE20LBvsqPYZZs7ojVQouogQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857812; c=relaxed/simple;
	bh=aacmgBkIekWcKT1nYvHuUWkKevrQq3dWCTP/f16lQvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X0l+AcLMy84W9iET18n/D9ZTeRL/rWBoY7Ax9RPrxdGkXlLlVY3D9gtIfMYtdG+7TDluKMOkepUPuGboWKnreHvJA8xrH+7wUtItDTr/McvMzHUMGFEuGaBjuwmGBXlHH8Q/Cl7jP8oHJ0HXR621S+/NtH57rH2ybxFwRJBLg4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=eVbC3rfh; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=F3fmLDfzzCSFX0fX01qQzZyvJwhOF7I5P+jzcyU8rOk=; b=eVbC3rfhhSMSp5hiAGmtYMW32W
	/CwPQeXZxT48jFZL0oA1H36B3324pzmjp7u+ngUvtNl4XXDHvoMgGMtU2BAeUI0wqHBg872E21Y5n
	zUSn2o5Wm+LSIgQgBFV2oRATIC9UMX2ceuakIGztdvOL30GS/GGjOR+2dseFwfO9LjETGDss+tSMZ
	I/f4HZ7A0qE46hp0LX6rfc3e3i8PhwnuaS6TNLiDqMaa7E7VYvqbBcKHv2jR10aYAWNAGdXNFfoZA
	DVZZpwMrICAzPRZ2Q+vfruxqEWXBpowZ54VlkP77SEyBgE0AYtMgfrKncyyAEXArkdyaVilj+Dw1d
	cECwoEfg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkap-00000001mem-3PmX;
	Thu, 08 Jan 2026 07:38:03 +0000
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
Subject: [PATCH v4 01/59] do_faccessat(): import pathname only once
Date: Thu,  8 Jan 2026 07:37:05 +0000
Message-ID: <20260108073803.425343-2-viro@zeniv.linux.org.uk>
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


