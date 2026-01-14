Return-Path: <io-uring+bounces-11628-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3420BD1C572
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:31:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id EB319301199D
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:31:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8C302E62D9;
	Wed, 14 Jan 2026 04:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="KfAxo3FH"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85522DFA54;
	Wed, 14 Jan 2026 04:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365111; cv=none; b=Gln4GXsSPcsTRkDTGKVkcwprmSlhKdWPgOG9ucq2tVoBj6n/qG18zemJgu2UHRvJhIIAcBI/9ogYKOX+AG4mdsHBPdqtrS73IOgEyYIZXrtaCEBAg2AEA19aMyWuMIYfOqKUJeTm/youpgrRAXQLAzDJbYXck/DUKcx1+wOw5kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365111; c=relaxed/simple;
	bh=l5FHgW47f+Yj1iy0m1MGYj33Um71tv4luVBFCT40jnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iOKNa0Szr3ytGGMwogKFg3wX8ImWKqOzKjsCsPg0IbdGTzSdZVsM1iVHyzwrDa84s9NM88Y/R3ooZ6SG/PWtO9xcez9emD988JXMSEBT/RB0KoUb58NAnYbDdkJcAHjuOxYb4w/NAADBmvSXgrWpzBjMdKW//yAQ3M3XO80gdCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=KfAxo3FH; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ZTmwRYazdVffyBhN86itvLOlmBSFDHLQsgXip1U1wEw=; b=KfAxo3FHMN98EnMTwigbun8dgm
	4X9/GjMd0cNIdeAKRxIt9AMezGjzKQw4Z0yad4pJMDmx2rt9haMhRbaStCUbl9c2+9V1tTj7Tk9Lz
	HSJ6DAtg8x/y1bFGW0TEgBYIuBg2So2J5saT2Jaj6srFT+mcWcGLtOCCEuXovr4pZZOM5UqXw8Izg
	HHVDbFgDpeyQSazFGg37tVEnXMTShjUOY4ZevtwhW0upPw6iT/uDiEMYeK/cWQNOENM/fRP9n2q1L
	TCwyzc52s6OHv3DAD5Pv6m2k/Hy1u6rtUT2/72qaT0UA4X+YXv4WyI3lZhJUP7QhgNQmFoRPpxb3i
	YQ+b6rwg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZD-0000000GInC-1eX3;
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
Subject: [PATCH v5 07/68] do_fchmodat(): import pathname only once
Date: Wed, 14 Jan 2026 04:32:09 +0000
Message-ID: <20260114043310.3885463-8-viro@zeniv.linux.org.uk>
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
 fs/open.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index f3bacc583ef0..82bfa06dbfa5 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -679,6 +679,7 @@ static int do_fchmodat(int dfd, const char __user *filename, umode_t mode,
 		       unsigned int flags)
 {
 	struct path path;
+	struct filename *name;
 	int error;
 	unsigned int lookup_flags;
 
@@ -686,11 +687,9 @@ static int do_fchmodat(int dfd, const char __user *filename, umode_t mode,
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
@@ -699,6 +698,7 @@ static int do_fchmodat(int dfd, const char __user *filename, umode_t mode,
 			goto retry;
 		}
 	}
+	putname(name);
 	return error;
 }
 
-- 
2.47.3


