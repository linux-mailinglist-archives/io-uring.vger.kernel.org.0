Return-Path: <io-uring+bounces-11666-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E2371D1C635
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:36:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6067D309D226
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:32:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35C5932D0EA;
	Wed, 14 Jan 2026 04:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="LLNFfxai"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15FB303C83;
	Wed, 14 Jan 2026 04:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365117; cv=none; b=ef7VelBVBglLXiD02KG0kPoBRPekKyjQxVqcZp5JwNynHAsCYxllva15ATCLWmqesLsCU3HlZejhNlJrD9kxhR/YMkAuLhFL8tvf693tB6fc48MShbbOWjvq9ma+ZK58vKFUvMKF89WbAecCPc8RrpXkT4nWvQI8UtV6dOGFy8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365117; c=relaxed/simple;
	bh=oyKBfs/wj+3AFANKikryvf2/aOkh/ktfJ9g7Txd0zkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iqIacfbUzx+/WUR+UKxtPQeVx2N4ZqT9n2k14zxjOxrBc/kElWELy9ZhUUSZW2sqphR+V2WmXkpHtm+nvscN/pW//nR+YLpxIuiP18oZwZ+ecbCTgOUrZyv3EOnnxmyjChZNxHHPb9oKHS6pYWqz9FRRl9j/zzChxyNvHSwhqg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=LLNFfxai; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=MIN8O3p6p0pbv2G0caQzyJS0UvmyEXVx3gIFuoTDNSc=; b=LLNFfxai+CFP263vVi0kOaJQsW
	pmbRSiWJ+IDUrqJn8oi4koG+LGHr6Vvyvh9ix9YXQRXuuD7c+efw1k6uyxmvkTeEyjpoPAlMSUlTR
	GIfeYO5MLG2QOCDUHiYCqwOf50jKJtsdVN4Jf2ewqVeNeYYlXH12XHyenh8egFhUp80pG/uOvA70V
	LV0SiJjz+u9KE0iAKcxH2da0MeodbRg1RHdv/xymvMg5Ar2R6g9EPkor8kBWuMNhYXUp0HxI7k/o4
	eVxNPX1GoA/vpt/ykP3Xa0jSdPB1S3NmtJTkzojo7zZUgI4uwKihWrp2cGLpyFPDFHyWhhI9ZA5eh
	vWtR+fCA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZL-0000000GIxQ-3uX3;
	Wed, 14 Jan 2026 04:33:20 +0000
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
Subject: [PATCH v5 54/68] do_sys_truncate(): switch to CLASS(filename)
Date: Wed, 14 Jan 2026 04:32:56 +0000
Message-ID: <20260114043310.3885463-55-viro@zeniv.linux.org.uk>
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


