Return-Path: <io-uring+bounces-11634-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D0C53D1C591
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:32:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3E73A304F505
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:32:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A338F301024;
	Wed, 14 Jan 2026 04:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="saKWQsBS"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E82DE2DEA80;
	Wed, 14 Jan 2026 04:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365112; cv=none; b=ATYjG+ULJzHXFMR/t74GqAUeh1T3yfpOzBi64wyPW8OZgMzRbxEczeGEO2S4WVRG2Hp1f9fPBgW8VGTv6P7vLtVJ14/5yj/Yoygoyt1/8EK9WVSDjhsih7qVYuxoVD9BWg+VbSKQQFI9qMp7vAJJPE/Cb3amTfvjJdKuzJGUyEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365112; c=relaxed/simple;
	bh=z/VLR9eMxqpn2kvuklpoYwJtnuXwpuC7asBssPdV4t8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j2BtqRHGOaxFNY7HC2uJ5Wcyp4wrcLahHFdBdv367hr4UbVxLIOd4SmJvkbjG4Zy/ZAEjyKBNuxlBjO1NW4liaQCVs2/73PEqtEXOKpOoqa+g2kM0fVVolWoROmTV98XuN3Chur3hscAJ/+EMmnnIaQApcrMH8VGFaPPakEZDW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=saKWQsBS; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=psyse3tF8YfUqMHWKKqTPMQFoI6DnJDYxVm2oFFXrG8=; b=saKWQsBSlo7539RdM4g4iCtrIN
	gP0H0hSxM3N0WcwrbmRHLQ+FVWHsbhPCejsS0DNn/Se/3vnEPQIIDHhO4fIWs0PPUd+H7J7jZXE6z
	uBPTOCYuRNoPGd68rpGNx6TV+J27NY/oxH53aZvTAHbqOBJCB0CiTyH6NCUrbY5gjFoK3XVok8dx/
	t5EizHaoTiPWSoyE0cWXh1Cj87kHUKlQO4J/n9SUDM64L9Elx6vMnRTg+okdzhB3uhUbmEejXFJ+h
	zoXygry57nVoR6RJMQi7By9wAc9YoSfRDx53I9o4w7BYYCCQhqrVSoGkFeebWX+rVuyCIasetnpdM
	Bevk+XQA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZD-0000000GInG-2SHc;
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
Subject: [PATCH v5 09/68] do_utimes_path(): import pathname only once
Date: Wed, 14 Jan 2026 04:32:11 +0000
Message-ID: <20260114043310.3885463-10-viro@zeniv.linux.org.uk>
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


