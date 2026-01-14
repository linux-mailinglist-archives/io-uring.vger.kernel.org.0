Return-Path: <io-uring+bounces-11633-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F695D1C587
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:32:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 08542300E051
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:32:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE483314B60;
	Wed, 14 Jan 2026 04:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="ooKloF7Y"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E811C2DC350;
	Wed, 14 Jan 2026 04:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365113; cv=none; b=NpEXJU/0xZv3SidBRwDV2wBPVg4/40gCqnOONa+Sa6zMxdCVMlHVZdr4kbFd9omh0kL7PSd9H62r69MfJtTWqUZS8C29X4uDemxgfUA+8MSVNFaW15mqU4itIzgzYr0yvwT7NpFpY61ptDt9FkP/bvgcr3MV8j9YlKTCR3xpTOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365113; c=relaxed/simple;
	bh=HuofTO6W7vR4qzfevIkIBi62Ny1xGF40NvZUmdOESYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UfZdvS+48bCI8BFkRqq9wwtKHqMoSteZEXPN1uye4paGb7dBXZFUUo+gPVfnSjTdtMrEUaZg+scDXzPm9KnajJ/u1FBqTwLDIeGnj+WuwWJZD1FqOskuYKc8jm4DiwfBWMoZczADHQLlk4Tm9ld1vyNt2upK1Ke4XKPj0oRrw7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=ooKloF7Y; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=5sjmtHpN+aNv13Y+x7OR9WyKLSyrvAiIxsgVcm3G3Vk=; b=ooKloF7Y5owgjXCDb2rohL8m+F
	E8xTkvDuL+MAjgnO773vg/6C9RgY9im6OWJd6AocKJZYvvuhffS7+ey374q7XqBCa/9MPWmNxEQo7
	kB6WEsq+fpoX3AUSFn7qVcPpuAA+a/vBIOuhFl2XZOlkpBm/VAM6vE2lQfZjUNKsTfOHk2ELMTyuA
	b0v9wlzcb/rRSiI1leG7x1QkqG2HB58YflkAjUXH0sEzbdHTsufEtfCpavGUa6VdkrFnUK6cjwVRM
	D9UOs1Oe9xbnv5R2akxbA9CsM0yI/Eg61VTauy32Tktk2dkCmaXAdZin3P3P8SZANgtrTQYPNQm7l
	wpLzmuWA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZC-0000000GIn4-48tA;
	Wed, 14 Jan 2026 04:33:11 +0000
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
Subject: [PATCH v5 03/68] init_symlink(): turn into a trivial wrapper for do_symlinkat()
Date: Wed, 14 Jan 2026 04:32:05 +0000
Message-ID: <20260114043310.3885463-4-viro@zeniv.linux.org.uk>
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

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/init.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/fs/init.c b/fs/init.c
index 4b1fd7675095..27e149a4e8ce 100644
--- a/fs/init.c
+++ b/fs/init.c
@@ -180,19 +180,8 @@ int __init init_link(const char *oldname, const char *newname)
 
 int __init init_symlink(const char *oldname, const char *newname)
 {
-	struct dentry *dentry;
-	struct path path;
-	int error;
-
-	dentry = start_creating_path(AT_FDCWD, newname, &path, 0);
-	if (IS_ERR(dentry))
-		return PTR_ERR(dentry);
-	error = security_path_symlink(&path, dentry, oldname);
-	if (!error)
-		error = vfs_symlink(mnt_idmap(path.mnt), path.dentry->d_inode,
-				    dentry, oldname, NULL);
-	end_creating_path(&path, dentry);
-	return error;
+	return do_symlinkat(getname_kernel(oldname), AT_FDCWD,
+			    getname_kernel(newname));
 }
 
 int __init init_unlink(const char *pathname)
-- 
2.47.3


