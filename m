Return-Path: <io-uring+bounces-11064-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 18EA0CC0C42
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 04:55:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D2B893026218
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 03:55:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36049318124;
	Tue, 16 Dec 2025 03:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="dLA5ZYtn"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EDE6311C24;
	Tue, 16 Dec 2025 03:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765857292; cv=none; b=ApdVpBE+JwtmxJYxMUVW7TLWHOSS6B/KLIWOcLOWpxmOPDp3nGekes1Xm04nUJD3Vv8DdqTr7DuzF35dDEE3W7vzTxud2hTL4BVU4Hvbdz3XXkVNhCsTUsqzbb8uZuiDX8zFS/OODAHkpBNisNueiZ6hmr8vCy2udY0bxLt3vFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765857292; c=relaxed/simple;
	bh=K04pMr7mpMxH0hiOJ7GtPBaHUbq5OaTNv0GMZ/FTQJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ar1X/lxBrw8WCTaMOPrligLPw6rhFm2CX8BSQ/oGklupDXMcvbZerHyeg4Pexy3yCFfNBhZxmsNVjuFLsHx8ecsd6Es2+UNOiQ6fEZ2bpMLTyVawAIiCZGEqzZeohvGM+ZM/Ph6YIjgRnN312A70chUUXCvjR4nqGtU398SYICI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=dLA5ZYtn; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=tD6MOGL3HuIaHYd3IIjMnJPzHw93K5UTdELNOyBshkM=; b=dLA5ZYtngaE/hBPbD9YmszAgi7
	haJvRgAlA/PoJlhrhsrWsLVgvCmL9CoAbOvrmnt/2jkSxPmB8FUD16UwrYHS2d1q1KfLtMCesZDP3
	xatqod2InJ8qOlkL8tk8uw1CoaNmeyR/ov2dRLac6/kZOiRmCsorlfxB1abzz7egF2GcbHsdcSHk8
	Ud5eLLHpdRR1YDaLdLeoE3wdFmjUo/X4YQoV/umGG+imNhAGrhlDp2dJV+6UEovPCJaw8KAA+A9Lj
	zAZbMmGggggSrRWePEXK1XG03FRuFHZgmjRaTBaosFN0pNvFvtDjj0okFQAfaw+xqZPdxTDX6P+fW
	nR+6ekgg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVM9k-0000000GwN6-1PRa;
	Tue, 16 Dec 2025 03:55:24 +0000
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
Subject: [RFC PATCH v3 52/59] chroot(2): switch to CLASS(filename)
Date: Tue, 16 Dec 2025 03:55:11 +0000
Message-ID: <20251216035518.4037331-53-viro@zeniv.linux.org.uk>
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

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/open.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 3c7081694326..4adfd7e1975a 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -592,11 +592,11 @@ SYSCALL_DEFINE1(chroot, const char __user *, filename)
 	struct path path;
 	int error;
 	unsigned int lookup_flags = LOOKUP_FOLLOW | LOOKUP_DIRECTORY;
-	struct filename *name = getname(filename);
+	CLASS(filename, name)(filename);
 retry:
 	error = filename_lookup(AT_FDCWD, name, lookup_flags, &path, NULL);
 	if (error)
-		goto out;
+		return error;
 
 	error = path_permission(&path, MAY_EXEC | MAY_CHDIR);
 	if (error)
@@ -606,19 +606,14 @@ SYSCALL_DEFINE1(chroot, const char __user *, filename)
 	if (!ns_capable(current_user_ns(), CAP_SYS_CHROOT))
 		goto dput_and_out;
 	error = security_path_chroot(&path);
-	if (error)
-		goto dput_and_out;
-
-	set_fs_root(current->fs, &path);
-	error = 0;
+	if (!error)
+		set_fs_root(current->fs, &path);
 dput_and_out:
 	path_put(&path);
 	if (retry_estale(error, lookup_flags)) {
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
-out:
-	putname(name);
 	return error;
 }
 
-- 
2.47.3


