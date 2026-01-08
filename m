Return-Path: <io-uring+bounces-11491-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id B0224D018A6
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 09:15:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6280630D3327
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 08:00:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CB143451BD;
	Thu,  8 Jan 2026 07:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="G9S7NRtH"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565CD340DA6;
	Thu,  8 Jan 2026 07:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857822; cv=none; b=S915IL3V3cMcFXA80bbjw0oypNDiO/Q49JPq7MI6STYytlvhmz8gRmEl7Mp2th5pTBSam8ac5ACvwSIIoX5fpS3nRiQyx9Zq3pwKTlcnWD6nThjXswDfkZ05PXEV8I5Mj0vFuHloaC7u9Vo38X6PKiXye5I7YduPkswNa7B9UeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857822; c=relaxed/simple;
	bh=K04pMr7mpMxH0hiOJ7GtPBaHUbq5OaTNv0GMZ/FTQJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KfTdA0pId4pfKnCX3bKOYk8DVf0whGzJQP3fd61gNSKd2d2wE6xVycaqIN8HEBYlADkRMurvTxjvY3OvSzx4JZw32TqGI8nQsAcXgy/hCf0L/i9sCd/zH6ZHHbLhTjsDW3LvJ5T+s7hCb6rJVEfg3YsF98T0v5QDkAlJ4+aU2mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=G9S7NRtH; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=tD6MOGL3HuIaHYd3IIjMnJPzHw93K5UTdELNOyBshkM=; b=G9S7NRtHKwHs2mvYCEH8Yk4AJr
	vR/Hf7bNBQlhlRDxlYDHAjqmhIONxa9NfIvap+ljX89XHMM/b76CNnR3SpzFeZDrrHMB9XN5fN158
	Yy1wbY/UiE6v73vBKcC9QYCoENk+fVinOQ8rG+/r41dlx5KlIIF+xJ+SJkfol+CMserLhkfK/EQYB
	z5uFuRJArmZD7KGPc15wvCe8+xRvZrGwpTg0r5bRmMWzlaz+P4RmCkMkv6ZxN34sbotNAmGx3/l7q
	rkQrGCBE4rf6qjNWyw/1uR36z1ShGag/TTlVpaG4JYLdWjeDdYoVthi8VX8cX/BMQcAKTjGDve/qm
	Oe/UipWw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkb0-00000001muG-0S0p;
	Thu, 08 Jan 2026 07:38:14 +0000
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
Subject: [PATCH v4 51/59] chroot(2): switch to CLASS(filename)
Date: Thu,  8 Jan 2026 07:37:55 +0000
Message-ID: <20260108073803.425343-52-viro@zeniv.linux.org.uk>
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


