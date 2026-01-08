Return-Path: <io-uring+bounces-11487-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id DCB83D017B9
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 08:59:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 79D0230DC304
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 07:54:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5030344034;
	Thu,  8 Jan 2026 07:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="Vj5AclKv"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F12933D6D2;
	Thu,  8 Jan 2026 07:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857821; cv=none; b=O/BoaFJmBEdW5X86qP2jjytOdHbRaftqOnVLYvmJs9rZSFWg2axLdm9uoLi3YsYouzUWGWA2RVAhgGG2hUCDNIF67akXeuT010UxUQv9mGKpXntfVWOpjarzH2wlvezTh02sQjLEkW0COuQXUfZzWrd6oERIGPLXub9wR91exWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857821; c=relaxed/simple;
	bh=oyKBfs/wj+3AFANKikryvf2/aOkh/ktfJ9g7Txd0zkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P0KCvL+pwt1m0Jl4QOfRI+DdLjPas1MBuChlsVsXp14YggRM2GLFtY+HOHsbwbmGDhXysAw+lloS+B/LsXOcmaY1+Fj1kocmJkZfSA3tMJnrZIiTe95/MT/kSGe199hSALM+5t3Tka68kvRuI+TrvXaIMQGzE6eqv1sZvoSHx/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=Vj5AclKv; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=MIN8O3p6p0pbv2G0caQzyJS0UvmyEXVx3gIFuoTDNSc=; b=Vj5AclKvC2Z4txEXi/GDxMXgWi
	/ap+EUvWKzXkwM8/i6V1b5qRAGMSMvaUuzgFC/KNYcWgQRF7Lyh2wYfXObinW1K/cmhEAoTsoOyOQ
	miZHU//hE7OV12Od7BhDVa8l9js7n+mr9F0cqFTz58SRucvyH3rTPE4m4i7XOnqxuyEe3HF86+yE/
	97vhpfJx4rQ8jeSetwc7u8bbIKpE61mQIeeOwE7rzj75mcq/izlyVohd+DcwaBStkrJfJWiGwiGRw
	BTLS8Niu/UXliagwE0u9UZTkwZrRrtgdfRj7RSEdmymXgPEjVhR7e+OY7nq+Y41814lk2F+459dxK
	smmTFumQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkay-00000001mrT-0QSg;
	Thu, 08 Jan 2026 07:38:12 +0000
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
Subject: [PATCH v4 42/59] do_sys_truncate(): switch to CLASS(filename)
Date: Thu,  8 Jan 2026 07:37:46 +0000
Message-ID: <20260108073803.425343-43-viro@zeniv.linux.org.uk>
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

Note that failures from filename_lookup() are final - ESTALE returned
by it means that retry had been done by filename_lookup() and it failed
there.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/open.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index bcaaf884e436..34d9b1ecc141 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -129,25 +129,23 @@ EXPORT_SYMBOL_GPL(vfs_truncate);
 int do_sys_truncate(const char __user *pathname, loff_t length)
 {
 	unsigned int lookup_flags = LOOKUP_FOLLOW;
-	struct filename *name;
 	struct path path;
 	int error;
 
 	if (length < 0)	/* sorry, but loff_t says... */
 		return -EINVAL;
 
-	name = getname(pathname);
+	CLASS(filename, name)(pathname);
 retry:
 	error = filename_lookup(AT_FDCWD, name, lookup_flags, &path, NULL);
 	if (!error) {
 		error = vfs_truncate(&path, length);
 		path_put(&path);
+		if (retry_estale(error, lookup_flags)) {
+			lookup_flags |= LOOKUP_REVAL;
+			goto retry;
+		}
 	}
-	if (retry_estale(error, lookup_flags)) {
-		lookup_flags |= LOOKUP_REVAL;
-		goto retry;
-	}
-	putname(name);
 	return error;
 }
 
-- 
2.47.3


