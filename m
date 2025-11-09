Return-Path: <io-uring+bounces-10478-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 7733CC43979
	for <lists+io-uring@lfdr.de>; Sun, 09 Nov 2025 07:38:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 032F24E45FA
	for <lists+io-uring@lfdr.de>; Sun,  9 Nov 2025 06:38:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 924342652AF;
	Sun,  9 Nov 2025 06:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="C88t1wMj"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3420823CEF9;
	Sun,  9 Nov 2025 06:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762670272; cv=none; b=tVTmiRtl2D28JmCi+VaYrQ/AAmuc0z9hAniPClQ0JZYgeZ3Vl/nBpa2tYD/7nEpaLSSnuHQnHu00II3fe94z7SZIOzBQhoIhx9yYH8Xior7/t87A/LOJgnuXt9g/DkQYPWT51WsAv3ne0FR3tuBcgSxdY482Zvw9MI9mSW7s1Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762670272; c=relaxed/simple;
	bh=E9Jim91cYu+hjfovMTAFNHpMUpWA1Dh3B6NDhEnGz0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QZNMVSDTIfu41B79QDG4MScoIQXqwFY2lmdogWM/YH/Ky4L9ps7JQPAnPXOmH4Vtt4XczHwMEElodI2T7dQA7XUK4/DKb7VQgh7SMn+SxEG4l6O6jX9DF3iBenEQxF3Wz5zHhCVOAoUgvYz8AvUiFPuUEufXu20UvEpUdi2l7BA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=C88t1wMj; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=9w85sx1iZaHMSmctqEpLCcaa+NQBcfmgJNR7W4Z/A98=; b=C88t1wMjDJYLUNh0rJV28fAGGi
	50vpPw0JvDNbh1c5Xzxi9gZzAABW3PNvJz8izObysbwCWCBF91nMBKa0PnjBwQtTB9v+I8zm6smqR
	0F8cyQBopGmFxXBDDKyxhGm091hCcVmTt1RnyHmNfnbGUOTI9Qkc5IhS3JtGdhtaIq/EO29iQ1IAj
	1X1NAbPU2jBTkJivollIuulopP908VnLgUN72OmH8pFmHzloiHmjLY7xmHqwk68T/JcN3rd9WYDTl
	AhkhhfAwygPPJmo/V42VULXU5oDy4kprC2A5kzXU+GeFzIWvkOALWZi/Ba088AxWcN5B7ULx9jaT9
	oRI4Q+Pw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vHz3a-00000008lbI-04Ar;
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
Subject: [RFC][PATCH 02/13] do_fchmodat(): import pathname only once
Date: Sun,  9 Nov 2025 06:37:34 +0000
Message-ID: <20251109063745.2089578-3-viro@zeniv.linux.org.uk>
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
 fs/open.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index db8fe2b5463d..e9a08a820e49 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -682,6 +682,7 @@ static int do_fchmodat(int dfd, const char __user *filename, umode_t mode,
 		       unsigned int flags)
 {
 	struct path path;
+	struct filename *name;
 	int error;
 	unsigned int lookup_flags;
 
@@ -689,11 +690,9 @@ static int do_fchmodat(int dfd, const char __user *filename, umode_t mode,
 		return -EINVAL;
 
 	lookup_flags = (flags & AT_SYMLINK_NOFOLLOW) ? 0 : LOOKUP_FOLLOW;
-	if (flags & AT_EMPTY_PATH)
-		lookup_flags |= LOOKUP_EMPTY;
-
+	name = getname_uflags(filename, flags);
 retry:
-	error = user_path_at(dfd, filename, lookup_flags, &path);
+	error = filename_lookup(dfd, name, lookup_flags, &path, NULL);
 	if (!error) {
 		error = chmod_common(&path, mode);
 		path_put(&path);
@@ -702,6 +701,7 @@ static int do_fchmodat(int dfd, const char __user *filename, umode_t mode,
 			goto retry;
 		}
 	}
+	putname(name);
 	return error;
 }
 
-- 
2.47.3


