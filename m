Return-Path: <io-uring+bounces-11093-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id CF69ECC0CA8
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 04:57:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5D81530657A4
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 03:55:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E1E732694C;
	Tue, 16 Dec 2025 03:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="g4oJ0eBX"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3CC8312838;
	Tue, 16 Dec 2025 03:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765857297; cv=none; b=K8Tsj6MMMwsrRAQF5bAYWpvm/qi4hzylFJM4RvyXXaubSC1cRrYpyyFoUsJBjqYStMZ3vVqyzBQUwKE9chsbD/N1Nwa/gCa9/wPzoqs3omsj9/uzaxTgnlaWqeOl7mlm6nwxM6icbX3HG0rZZRoT/mYlCofMNmqOYdMBz+sC74k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765857297; c=relaxed/simple;
	bh=jdzYbS+XFnEHgYaBnGvA1HE7+1/v+uYUnrU+3o8mAwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tkk/+Q6Xn1+GwV7RVZfPxZ1byu9WB0A3uUvl425JLGT3pBYW+LvSshcNMMeid1jRb9XcMOkPO7zWRkj042U689Zg0ZG73yRKYN8GSPUGdFwXzq1SsZ3zcrWHbHGF9OW9zviUMmvTCjellq8joyVKdRFu73AKrY2Ko+US5TEw1z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=g4oJ0eBX; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=HnM8yEWuhhQLT940Vc2y+rRmTPsMSEE4Li0pZlObJ28=; b=g4oJ0eBXi/h7FV7cOSvH83WHs5
	NeIUTpKCUrp3gtq18pBL8yuwkGRBP5RibWRgqx/MnPeX3SVux2ntu+qo/DOAHDxZm5CQuPEZHDPYV
	WgxZtlgUj0Of/s+xf76AsCI12V2Mjb258XWsUQcs7tRkrPTHC5nC5DWX6PnO2xiXOTr4c18TBuhmz
	pWcZ3sBvB0iukUKee1zoBXFVh/2Ip/g7sccfxSwAF3aXPyL+wk0OvR1cmnmlqXnJRw3YOUpc7PSTu
	ZfJh7zTOLs3YORcpL0yNjCmKXyVIMvOp1WXV5hhKexAKqUy+RKlNEUlhpuLq/LOa3Suet8D0YM7em
	uXT7+JLQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVM9h-0000000GwKS-01Sq;
	Tue, 16 Dec 2025 03:55:21 +0000
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
Subject: [RFC PATCH v3 24/59] ksmbd_vfs_rename(): vfs_path_parent_lookup() accepts ERR_PTR() as name
Date: Tue, 16 Dec 2025 03:54:43 +0000
Message-ID: <20251216035518.4037331-25-viro@zeniv.linux.org.uk>
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

no need to check in the caller

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/smb/server/vfs.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index e874b27666a1..abfaebcf8cde 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -674,10 +674,6 @@ int ksmbd_vfs_rename(struct ksmbd_work *work, const struct path *old_path,
 		return -ENOMEM;
 
 	to = getname_kernel(newname);
-	if (IS_ERR(to)) {
-		err = PTR_ERR(to);
-		goto revert_fsids;
-	}
 
 retry:
 	err = vfs_path_parent_lookup(to, lookup_flags | LOOKUP_BENEATH,
@@ -737,7 +733,6 @@ int ksmbd_vfs_rename(struct ksmbd_work *work, const struct path *old_path,
 	}
 out1:
 	putname(to);
-revert_fsids:
 	ksmbd_revert_fsids(work);
 	return err;
 }
-- 
2.47.3


