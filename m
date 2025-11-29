Return-Path: <io-uring+bounces-10852-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id EA29DC94510
	for <lists+io-uring@lfdr.de>; Sat, 29 Nov 2025 18:02:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id EFD1E4E2942
	for <lists+io-uring@lfdr.de>; Sat, 29 Nov 2025 17:02:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F08A311583;
	Sat, 29 Nov 2025 17:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="QfCPXtd+"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3332322B5AD;
	Sat, 29 Nov 2025 17:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764435702; cv=none; b=kn4/2+gFh2oGASclLvvkqJ5h5Na1Ad/2OltkfkVAab08wTAcVE6cH97vR1tkK3prCyKBmUQ2O9E4x6uzyj4m8/fJ4GFinEJuSozcmIFTv68yYnBAb7PfTUakxNWXMwbYyFceS9qC9S5Q8x6yqtcX3BNaNe8a0IrdnkaeH60zrTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764435702; c=relaxed/simple;
	bh=JMysKiJC2Ik/MGivxpLNZ5AaJ71+hLEqdgKpHC+WWWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rP6xrOoKIUbyzD1RmEI8OfMvGl+3MVvnMhlMSoU8LvcmQDKev3Z+jBjHo8oG1G2kcY4oOIyLEUnUTGp6QzGScW+1p0fgAuAwTwoREeeLnnAfP+UklaexAWTUlFda4SBZzontqofG+gdI5MhbiA59KO3brC68SUhoilNOTonyKE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=QfCPXtd+; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=SS4qvkqrh8UOOAGK12l+kZvjxypKYwL6MT4Ujmz3sdw=; b=QfCPXtd+CZWOy68fWvjARyxOWx
	n4e8bGPzOS9ufy/SZ4iIr6nUeSKaZwhY2qkY2kORA54rdhBTf87SyODaeRHAEj2daTKlh5iasZB6r
	AIn+CBvNPRX8MLXsy2tABsQ6dHPzUH7bsD2PMmKDNvG/kQl3pa5CItApeQuSsbRg6dZQKw09hX9g2
	DEjZgiJMHDeNZLp2lH0pF8NBnfBKjzObkZTZetlOCipYeGEjARhtxVJnR1FTbqNe9CGem6esN4sJb
	CrvTHG27fZr4LWo53r7VI+RCiYYLTiqYlgtCIihW80ZGe7IK12s3pbW6/iv6rRjWn/qOoDbLJYlOs
	lMbjtDFA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vPOKM-00000000dCQ-44sl;
	Sat, 29 Nov 2025 17:01:43 +0000
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
Subject: [RFC PATCH v2 04/18] do_utimes_path(): import pathname only once
Date: Sat, 29 Nov 2025 17:01:28 +0000
Message-ID: <20251129170142.150639-5-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251129170142.150639-1-viro@zeniv.linux.org.uk>
References: <20251129170142.150639-1-viro@zeniv.linux.org.uk>
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


