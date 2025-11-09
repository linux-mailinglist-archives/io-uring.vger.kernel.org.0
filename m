Return-Path: <io-uring+bounces-10472-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C202C43957
	for <lists+io-uring@lfdr.de>; Sun, 09 Nov 2025 07:38:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 363F84E4CCA
	for <lists+io-uring@lfdr.de>; Sun,  9 Nov 2025 06:38:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0614257848;
	Sun,  9 Nov 2025 06:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="QUgXUu55"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3426F23E320;
	Sun,  9 Nov 2025 06:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762670271; cv=none; b=lYYo2EuKUaG2avIXSBlMTnb3JNfrNTotvHkGdjwM0LQ22YVJpEo0EZUOqa2ZqpRm5+9kFBpq67w449bHEbHZA/9rDacXk30gzxssZQ1J1VP6/biqWjp+IK4U2NDl926DxZ1MaEQ7Vu/GG3RZQanwwrYyGTC7eoIDKRd1FDlpeUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762670271; c=relaxed/simple;
	bh=JMysKiJC2Ik/MGivxpLNZ5AaJ71+hLEqdgKpHC+WWWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XiUCFTcLz7EZ8ZhzW+9b7HpHtjUiEda8kZFU9mkwMkCVQSqn8LOC0oty88wQsxLQ8ycaXIjOkyNE3vkAOG4Ie9yf2TbuAjaS8U/ITCaCI40voIimBL0NQmm1MVBwrJGNK+wVdFhSa6qx/69yFBOxnoJg996Cm+cjMs7zj1FlVE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=QUgXUu55; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=SS4qvkqrh8UOOAGK12l+kZvjxypKYwL6MT4Ujmz3sdw=; b=QUgXUu55Xdog94UeiVeR47vFXC
	kpY9trH1HfLLdV5gP+L4NJXLYC++k7T3vnGoi2tUvYzmeZoruPzPUnJdIVSBEgbJLfLNoYiYQiPnJ
	r/YE5W6PEhRaGLOPVyReUcymIMhiVZ3pmb9G1IvG+hHbZmqVn6YB7NfklYQrCktJs8OKWIqf8jOk6
	56TXkLfRXEblv7W55M3RFoEBY2eLrow7kjTA/QWdXLYRbKob5Ps/kcOsWVq6O8uGtHyu7b2jzWyvy
	OlJJTytUwT+hOuWK5UHq9vE2KR+jqVwl8MAY+jPVGQIuokOoU5tCeZCbX4hKAolgzPYpIYnGB3USC
	keee4roA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vHz3a-00000008lbe-0ojB;
	Sun, 09 Nov 2025 06:37:46 +0000
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
Subject: [RFC][PATCH 04/13] do_utimes_path(): import pathname only once
Date: Sun,  9 Nov 2025 06:37:36 +0000
Message-ID: <20251109063745.2089578-5-viro@zeniv.linux.org.uk>
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
 fs/utimes.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/utimes.c b/fs/utimes.c
index c7c7958e57b2..262a4ddeb9cc 100644
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -8,6 +8,7 @@
 #include <linux/compat.h>
 #include <asm/unistd.h>
 #include <linux/filelock.h>
+#include "internal.h"
 
 static bool nsec_valid(long nsec)
 {
@@ -82,27 +83,27 @@ static int do_utimes_path(int dfd, const char __user *filename,
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


