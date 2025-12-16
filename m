Return-Path: <io-uring+bounces-11118-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 356DCCC0DF9
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 05:21:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D115530C9640
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 04:19:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79CBB33AD9C;
	Tue, 16 Dec 2025 04:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="nQQyieJa"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CBC433ADB9;
	Tue, 16 Dec 2025 04:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765858379; cv=none; b=IstnnhZ4ehK4VH++W81D0c0vCGdv5wfLJ5VOFBaYZjywzJ4ndmUatlj9Q0PpakETgHGxC2rWnz2PzHEORUnzfg/914wf4YwTuRtFMg15AFhUw9TnnotGoZwo6g421iVWV7S5WeCWLVN37FWm7vOV2Kut7iGp9NqRnuPdw8fgGoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765858379; c=relaxed/simple;
	bh=oyKBfs/wj+3AFANKikryvf2/aOkh/ktfJ9g7Txd0zkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qCOVgdxiJatkQwpdNOwxVt6l3wXi82nyIXUqzVEztZgiVhSQjO82AlncKqDOvQWpnLdUj+0wfzEONNgfC7F1HjOdh+Turg4Bu5Wv9O83gFsS0a4X/KEeaa4cMgSvH2ao0vQbXBgF4N2JBKTxERYKxmAzW1tJHJ0qK6pCx4+juos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=nQQyieJa; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=MIN8O3p6p0pbv2G0caQzyJS0UvmyEXVx3gIFuoTDNSc=; b=nQQyieJaFx0lqaigNsTb2H461V
	y5mIqrtFTehZO0RP67qE5SUy4zIXHn8LxmlMGI/+1TN8sSSXdvI1yLzyhRl3qSSQHXVYwaPYufU1F
	IVzoYw4Y0xeLZgeiq9G0rvbxr1ELU/rhIMxXlNjmsGb6wpoc6o1VgpWLrMyd9dF8Ecfw3CRcPM5ih
	3/DetEESmFvTf6nmqInqlwt0q3cHB+r37NtmLcS+L4tjJD+0HouX+Yg/ttZpnRjvNDEkpZQWW4Xeq
	THyTdUnZ5buq6K5MlMnOoh+EOyoYPU5KXgt8WVi7wpUo/gAYiK7Sa5HPmIXTNTXHZBaPbo32TO8Ez
	deaw4MMg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVM9i-0000000GwM7-3bEa;
	Tue, 16 Dec 2025 03:55:22 +0000
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
Subject: [RFC PATCH v3 41/59] do_sys_truncate(): switch to CLASS(filename)
Date: Tue, 16 Dec 2025 03:55:00 +0000
Message-ID: <20251216035518.4037331-42-viro@zeniv.linux.org.uk>
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


