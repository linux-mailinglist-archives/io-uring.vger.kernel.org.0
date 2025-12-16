Return-Path: <io-uring+bounces-11098-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CFF2BCC0CC9
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 04:58:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2F92F305ADCB
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 03:55:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D06B831A56B;
	Tue, 16 Dec 2025 03:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="JxN75zzx"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB15311C0C;
	Tue, 16 Dec 2025 03:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765857297; cv=none; b=QQJbzgJy46DQu1xMtRGxq/8bH0oSfjWxzlnl5Q2ZYvJYtAe7HzwK88zHhkV7FMKnNsW+BN3FEh6vyI2v9Z81U3eaRuRNyaJLFlcac3fjCsa1mpzWUID/IKRRblaXoOWLDWfP1krZcI1vx5qFEdr4TWPcp+du6Unnm/wUDVnRg7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765857297; c=relaxed/simple;
	bh=VJR7OANqAnNeKsJcpMXd5sA1W1qzF/DrbRQlYMiYeY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M/a7w5WozzMQtT0Dzqx/rzbYHqjzO0vFJcyphvj3i8u0qnIninMFrFye7vwD7HWDQi+VEqJ3evV4a5c0jKXq6uyLnuRg2xJZ+k2cyhpc6oS9dmSnZ2rPkKdaoTl9Ij4sccgDGE/C74BYWtefjeN4ywKLBmbhIMmcu4J2GEe/Dkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=JxN75zzx; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=nND/UTx2fHPWcfLy6K3U1k4zO8irk7L/OKSvicadqNs=; b=JxN75zzxsjkrCuGpmVZFPU11hv
	LWmmatYFiZSsKOZUBQE9iC4ljQyp5ZacKLKTOJBV3ZJNlgbrynAyCE+roj0wrnVpHa56u6GkVR2e+
	jn6j1nWHcpJvhlZY8LG5wprlsxutseIxVzs7vndvhg8hb20TjsNQNONgkDUYv37gnZ6WF+Dv1QbU5
	jsc6jIzlZBdoiU33NyRCwTL/SyhYre5ieQFxfopEBEySm1StDOiTUhCy5mQOkK21QpQBr5uP+ctEK
	9PYtpfBfmGHl/3bLWNLvxuzl14/ZX/F0Da5vS0AiaaaMKT3go/dMlwqUcbzkydbneS/JOexguX7VK
	8ElOdavA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVM9e-0000000GwIj-3xdO;
	Tue, 16 Dec 2025 03:55:19 +0000
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
Subject: [RFC PATCH v3 03/59] do_fchownat(): import pathname only once
Date: Tue, 16 Dec 2025 03:54:22 +0000
Message-ID: <20251216035518.4037331-4-viro@zeniv.linux.org.uk>
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
 fs/open.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 82bfa06dbfa5..a2d775bec8c1 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -801,17 +801,17 @@ int do_fchownat(int dfd, const char __user *filename, uid_t user, gid_t group,
 		int flag)
 {
 	struct path path;
-	int error = -EINVAL;
+	int error;
 	int lookup_flags;
+	struct filename *name;
 
 	if ((flag & ~(AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH)) != 0)
-		goto out;
+		return -EINVAL;
 
 	lookup_flags = (flag & AT_SYMLINK_NOFOLLOW) ? 0 : LOOKUP_FOLLOW;
-	if (flag & AT_EMPTY_PATH)
-		lookup_flags |= LOOKUP_EMPTY;
+	name = getname_uflags(filename, flag);
 retry:
-	error = user_path_at(dfd, filename, lookup_flags, &path);
+	error = filename_lookup(dfd, name, lookup_flags, &path, NULL);
 	if (error)
 		goto out;
 	error = mnt_want_write(path.mnt);
@@ -826,6 +826,7 @@ int do_fchownat(int dfd, const char __user *filename, uid_t user, gid_t group,
 		goto retry;
 	}
 out:
+	putname(name);
 	return error;
 }
 
-- 
2.47.3


