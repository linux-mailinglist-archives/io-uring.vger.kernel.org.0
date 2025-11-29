Return-Path: <io-uring+bounces-10839-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BDF53C94522
	for <lists+io-uring@lfdr.de>; Sat, 29 Nov 2025 18:03:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5FAB63A6E0C
	for <lists+io-uring@lfdr.de>; Sat, 29 Nov 2025 17:01:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8C8723D7FD;
	Sat, 29 Nov 2025 17:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="nk5LWx5c"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E57224AF1;
	Sat, 29 Nov 2025 17:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764435699; cv=none; b=rPuN3M2LRnshZcblwfHHiY5RmOVO+enczEc1aahSPFWoZvCFFc6AGxsTtwaJPsGbHVCLvNDnDrmPKYB7GDyYFO7babXC2una0nmlDULnCYWplmEiNSnA7nwkr1V62R7sDy31btStGYNT5kQwZc3w4mpDj6tFtt96fWDKUIYND5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764435699; c=relaxed/simple;
	bh=0YgR4JPIv4trQtTKKjsZyS87DZYBNKhfp3ECxkZq4Jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KHUrvfaFiC8CkG9PhEid5Y671dlm6XsZC6svYgnhQLv75Gy9Y+8i1F02gHzEzDThZ+smG72mW2xBgoRLykZRd7jBKkXYgTLurvYg1X+bhfLd1nbdzBiupei0wVI3jm7D43dvRoA/yzBH5GCRAlq7VlPHc3fMzkRKtDIqwj8zUkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=nk5LWx5c; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=rf0QBWjyFpio5L0bss+WOUIUsJ9vjsc4nuTYKt2zUvY=; b=nk5LWx5ctZD1BBYKyofwqyqFv8
	XIl2TlES11lqi/W5/bA3lw52NmuG0HbqvSAVkmRSeIJ7sGOi5XJukyWeUPN+SNDpClEoPIADZnNh1
	nJqkYcutyYhTqyLWAKjvqXiTgmvLgdxOrW76mFXPEc5tF14eTWlkaHyClGRDCyDKvO+/TgK6LXMqT
	lNEbS+lCGkfY3yMlyXJfSxkjGZZzOS86IBNHhx4DhCVvzsAg87HL7G5PUeSMGljXvkBuZoeE6V/DL
	egq9mWLNr2EbJ64knTcWNvX9QYUfi1ESAM+94ioLKAuo/dB217uG9L8oFHyVcKIv6ZOKIN7uKibOG
	87/FXaHA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vPOKM-00000000dCK-3X1S;
	Sat, 29 Nov 2025 17:01:42 +0000
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
Subject: [RFC PATCH v2 03/18] do_fchownat(): import pathname only once
Date: Sat, 29 Nov 2025 17:01:27 +0000
Message-ID: <20251129170142.150639-4-viro@zeniv.linux.org.uk>
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
 fs/open.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index e9a08a820e49..e5110f5e80c7 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -804,17 +804,17 @@ int do_fchownat(int dfd, const char __user *filename, uid_t user, gid_t group,
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
@@ -829,6 +829,7 @@ int do_fchownat(int dfd, const char __user *filename, uid_t user, gid_t group,
 		goto retry;
 	}
 out:
+	putname(name);
 	return error;
 }
 
-- 
2.47.3


