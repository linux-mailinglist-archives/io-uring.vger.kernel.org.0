Return-Path: <io-uring+bounces-11453-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id AD112D016D3
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 08:38:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 71A743029C2D
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 07:37:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 318AF33A71E;
	Thu,  8 Jan 2026 07:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="tsKY1M0m"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF72314A89;
	Thu,  8 Jan 2026 07:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857812; cv=none; b=UQ7tBO5g7KGCz8DnDS6AOMHuOrjlgIsoAJDLPqOn8c1FisSzU3mmwQV0Fl27kgUIzVK6ptQmW6tdtFKeDdE4WlgfhNKWfOQl4+N3aOz1fFZxIFLD6eclw4ZIlQDQi7HGcHAdgRbBA9K52c2cJpwh5k0OOob20PAFZZv7vzCJK6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857812; c=relaxed/simple;
	bh=l5FHgW47f+Yj1iy0m1MGYj33Um71tv4luVBFCT40jnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PBsiNcwKWKKIO+aAA9G/1QrIsKqN0DRPHcvBsmjiKcXjzGeulSR9O7pUmzAZxJfmFf1bFwW9kTN86qoR8TN9veNV3wZTtOQFcA7Uqp8PSgnZD3HDDpgCK4Pn4LCkxRDKDsNyvkXRWUFYCuQMbeBfam1MCnYrckvvITGlkj8Y18A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=tsKY1M0m; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ZTmwRYazdVffyBhN86itvLOlmBSFDHLQsgXip1U1wEw=; b=tsKY1M0mWl2OS8wXje9XTJYY8n
	j42bm41WLSLziOFstztGA4n7iqt0bOKUGKkTF73JaNKyP3N+2k8XLY/w5iHL26RYDiF7cpF3RFh8v
	agVeggLb5DUcCU2t/43eZZgyjWneewvXVgnIM1kSQRqJRoZ6+b1OWt//uYuKhq3xj0OcSB6Uhy53K
	THIKBCq87SCyd69DoS9K4x1upTjkvkwSwbhkdUJmbE1HEObOWzGQci3lb1Gb54qTos184F1hQUVnN
	WuCyC5ilefi/+d0GGyKdMoK15pFvLsgpjTCuqjaX9qNCFV4BT4k6u5H+hzrzlvfB5/5Qsonl84VzJ
	o4yFhVHA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkap-00000001mer-3mAb;
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
Subject: [PATCH v4 02/59] do_fchmodat(): import pathname only once
Date: Thu,  8 Jan 2026 07:37:06 +0000
Message-ID: <20260108073803.425343-3-viro@zeniv.linux.org.uk>
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


