Return-Path: <io-uring+bounces-11452-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 97CD4D016DB
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 08:38:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A7516304A940
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 07:37:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E7C233B6D2;
	Thu,  8 Jan 2026 07:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="bBg2jmsG"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8F430ACF0;
	Thu,  8 Jan 2026 07:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857812; cv=none; b=CXsUFPwVmFKmkTdZvj3otMpsBDdM9bfxMmw4Kr/l5a9xCXheomu5LkxXSwfzm42sbehTuZxakRcSdilBahNQk80Vtns2QfAaeSKV6NFYXNZ4S86lA2CKWhFlGKo9X+EuWvpEF4Na3alD/wwQjviTpkWhaQ4l5+mvMc3m6HeV9nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857812; c=relaxed/simple;
	bh=z/VLR9eMxqpn2kvuklpoYwJtnuXwpuC7asBssPdV4t8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TYFZfEslo8uyqjXmtRSP1AMpZp8iFYNOp/QK7YNR4fPF2+EdyjBMV6JmZRmA67kL8eUXvGcedmrgB6UkpfoW2jmdcBQqIORrFpyximtpKwrw/5mJ1wukKbdqImjkpz0Y1eon0mQN7kwYr7ELPTo9aADZGV7SY2bHGTBNowziKPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=bBg2jmsG; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=psyse3tF8YfUqMHWKKqTPMQFoI6DnJDYxVm2oFFXrG8=; b=bBg2jmsGl/EHffla1svFKk7pDE
	nD7y6KPXxGlBfcJMoNGTf46UVHh1e6iLtzXOnBc3XpaYWi7HMKXLN4H6KrpLrH2oSrWAXPocSvLID
	AJqFELqL7SOhtC/LCPuyJG80KRMAp/dSFVVd6+7S3v7NBVIcMJW2CrNguDTqvui6Hyr7Yzw/1OZIu
	tfMMAsfJBcav1Kt7iAXUSppEOR5n97rbbDni552bkH0QtetCbpjaeB3TUFTP5FBQVcmx+UQo0otOR
	Ax1OEX2/lnCYXD98CSZZxQqK6RsnXwXUiz5WbvKv5EqhkmZfvR/UzY4wv1tXXn1GGuL7yEpR+A8i/
	YsAx7yOQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkaq-00000001mf4-0eJf;
	Thu, 08 Jan 2026 07:38:04 +0000
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
Subject: [PATCH v4 04/59] do_utimes_path(): import pathname only once
Date: Thu,  8 Jan 2026 07:37:08 +0000
Message-ID: <20260108073803.425343-5-viro@zeniv.linux.org.uk>
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
 fs/utimes.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/utimes.c b/fs/utimes.c
index 86f8ce8cd6b1..84889ea1780e 100644
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -8,6 +8,7 @@
 #include <linux/compat.h>
 #include <asm/unistd.h>
 #include <linux/filelock.h>
+#include "internal.h"
 
 static bool nsec_valid(long nsec)
 {
@@ -83,27 +84,27 @@ static int do_utimes_path(int dfd, const char __user *filename,
 {
 	struct path path;
 	int lookup_flags = 0, error;
+	struct filename *name;
 
 	if (flags & ~(AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH))
 		return -EINVAL;
 
 	if (!(flags & AT_SYMLINK_NOFOLLOW))
 		lookup_flags |= LOOKUP_FOLLOW;
-	if (flags & AT_EMPTY_PATH)
-		lookup_flags |= LOOKUP_EMPTY;
+	name = getname_uflags(filename, flags);
 
 retry:
-	error = user_path_at(dfd, filename, lookup_flags, &path);
+	error = filename_lookup(dfd, name, lookup_flags, &path, NULL);
 	if (error)
-		return error;
-
+		goto out;
 	error = vfs_utimes(&path, times);
 	path_put(&path);
 	if (retry_estale(error, lookup_flags)) {
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
-
+out:
+	putname(name);
 	return error;
 }
 
-- 
2.47.3


