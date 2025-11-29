Return-Path: <io-uring+bounces-10847-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 66DAEC94552
	for <lists+io-uring@lfdr.de>; Sat, 29 Nov 2025 18:04:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9886E3A97D3
	for <lists+io-uring@lfdr.de>; Sat, 29 Nov 2025 17:02:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B59523101C6;
	Sat, 29 Nov 2025 17:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="NZEcLrTZ"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32ECA225A5B;
	Sat, 29 Nov 2025 17:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764435701; cv=none; b=fmswT4cmL/hew6/h6avPXEgybc3woHortENUFRAaSXkqa30xNUZ0Fc+owvJaqQf55V0N103gytFbfSGcJAW8tNv/JAQPl9aZeia7BTVTN0YcmEpV9xAN4KQ87DQE+Ne6pgrktAA706vt8pLucI1tAhErAmEQR2zel9Qx2FuL35k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764435701; c=relaxed/simple;
	bh=E9Jim91cYu+hjfovMTAFNHpMUpWA1Dh3B6NDhEnGz0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gv8WLOT+Sr1Cf9T9sCXbX+7ie6Y+Mgl4GthF2xMH0wfzttPpQp8bwS5ZJqgkQklQXoleOuj1JCy1eBLeSrDisyYy03UbePaBKTpokYrXstJv03Znl8Mg4GZsX4SpmBp3QaeFxKmq7O6dl/gjHiUg+SAYWClG0B3vK1gacU1coHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=NZEcLrTZ; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=9w85sx1iZaHMSmctqEpLCcaa+NQBcfmgJNR7W4Z/A98=; b=NZEcLrTZCynyPBfy2FUn6MUbHF
	Fkz7D05w9EclnWfY/ipxLNyw6taUrmmjxsK5fIJgm1KoRua+9Usz9qxZriXujO5mfTibCX2tDy7YZ
	FhZoltT0CWg/XLbWRKxw51d3/YpsvdtI//77QO2KZ2DIKdqm5Ll+Zf1qy5olZOBzzeU9yAGSF93Yr
	BJ3GPDuO4nrmLsJkHcS5ekx5QYgJMrvajpN3ssPewoy0F7UdS03h24alFuhdyEY5NudrMmrXqvK6u
	c80K34KiDkwOkfd5/O/dgMNzvbflS5PmHEQR/zfzDdpx167ULD4TIYWuj4TvOkR6glHI2mN0Ky1lR
	oJxZm1JA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vPOKM-00000000dCC-2xnC;
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
Subject: [RFC PATCH v2 02/18] do_fchmodat(): import pathname only once
Date: Sat, 29 Nov 2025 17:01:26 +0000
Message-ID: <20251129170142.150639-3-viro@zeniv.linux.org.uk>
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


