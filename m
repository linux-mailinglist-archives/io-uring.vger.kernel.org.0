Return-Path: <io-uring+bounces-11059-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id C313FCC0C21
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 04:54:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 3C4803002B8F
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 03:54:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A1FC313E38;
	Tue, 16 Dec 2025 03:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="pcjUgE3B"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8B63115AF;
	Tue, 16 Dec 2025 03:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765857291; cv=none; b=lYnbkOAJKTDqMNLi8yt6qQML6qAYaYSvdZ3A8XJWTbyM3tq9A6MzfMCKdIpPG9ryYOnoSlZceoARjToX3t358sI2fT6RRdTlScF3YTtKLE8qGDCODysTPvMyEambzHDeFcug6hb9an9gG+EjX1fmkw3LQ8GmXC+MNCEn1Q7wQJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765857291; c=relaxed/simple;
	bh=z/VLR9eMxqpn2kvuklpoYwJtnuXwpuC7asBssPdV4t8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yp7MPB0jMr7Zz4IoJoLdpMMMyO+PxWrExP3CqA2sEplt+EFEqc5Icaoow2DJXzgq9ubWpmIbuJfqZrJivuAMzwb5e9eM7EIxGNCoakcOBLOEuU/u5/u+rLbirQmsTJ5LHNAJEaURzn6NxNB4UBaVYxDxROPa1BSfyip/hzFZw/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=pcjUgE3B; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=psyse3tF8YfUqMHWKKqTPMQFoI6DnJDYxVm2oFFXrG8=; b=pcjUgE3BcltxGsi7YIigOtnx8e
	2Tn3cqRa5VpD6SeDPKQFO54G8ZceH1j3LO+OQgjrfTx8FLBoBUpyNwB6oJgEJ39YmOMsIRpWcO+W6
	harvNUgfA3QWuPGUUbN6Ea4YPi/NwY/kQX9KheuIBv07i1FLJXWLdbf2awTeh0meqQO8SZBM4YhKu
	PQ4oER17eIQ9pd18qC6w7ZBlTQuR5zvCPGGuIFRUfken19mJfkvGzTgXXNhDead5Ep8RMFyfgIedP
	vEo2VdBlAPl6CeDpLVneTh5CPfWNFg9RqmbujPWBFiiCsZJWkSqyjewqeP+BpuDPxOKy3oaVamlH7
	7/QqMgVw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVM9f-0000000GwIp-0Gs1;
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
Subject: [RFC PATCH v3 04/59] do_utimes_path(): import pathname only once
Date: Tue, 16 Dec 2025 03:54:23 +0000
Message-ID: <20251216035518.4037331-5-viro@zeniv.linux.org.uk>
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


