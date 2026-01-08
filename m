Return-Path: <io-uring+bounces-11499-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A9549D01B71
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 10:00:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5BE9A35923EE
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 08:48:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0F9D346A1D;
	Thu,  8 Jan 2026 07:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="c4WaRlmR"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89554342535;
	Thu,  8 Jan 2026 07:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857823; cv=none; b=lImOEd7YLXDxIeqxp7fG3CtkhdRd2htyADcP1H+hgq7yOQZbGCr5lh3EDZvZqISlrJklASiYQzWW+aOQjpEEHdF4kpYUXXgHB9rVg+bGxviYOX/d4mrYsG6q5kO16H9ylYBzYIqNZTKqeS53lthD9jn3n6/gzvLJtOLr/QMmbLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857823; c=relaxed/simple;
	bh=D/4Kpd2bYKbkRLQSN5eQLKG4OXd7jN3AcvumkEOaeMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PAh5x6+9uGb/KVF72DwtwmWswe3xHZljjhbUcnSxzB4GD86rdHjAbwTra6ozZTPkIdvrWEXFHX5OzgNfuUxECZs4oPsU23FuWzsyWB2i/2DL1raDI+eSQCe5wi4FwBBe38/dYiwCbRGzHgmVcpv5hKKxfIGuLct0FiwMHe6oqZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=c4WaRlmR; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=yl4N9qiPKC+robz7RIG19DtsqLRtLo4jXB61e6cJSfg=; b=c4WaRlmRFez+LyIO8ILViGLBfz
	18fySqcGXGPRGIrZZ/QDidAJrVsUwrYmDIJEXTbtBZ7V9E0zx5z/ycWl3Z82rBrLM1ncEjoRZFhyy
	Q9NBpv0UInSVc3ulZ70e969AVo5QCAalvIn+s1Y+ydBBjmSSqCHI4QCsIyuwU0fcUiorqedNWY6vK
	bQXb6b9jBQAkLW7qhOvfUYAyXhl4/YWMJLkyG0t6D4mhB/0zYTs5Zfl0pqRFlbS/d9q+LicW4fFzC
	2y5Zh6Qw+WI+HBrHCKxIejloIJ0ovBrW3QTNIwqzwQqIr0gakupTaX4KpS1U3KA14cXSZAA37r3cV
	7+sX4oog==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkb1-00000001mw9-1NOv;
	Thu, 08 Jan 2026 07:38:15 +0000
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
Subject: [PATCH v4 56/59] ksmbd: use CLASS(filename_kernel)
Date: Thu,  8 Jan 2026 07:38:00 +0000
Message-ID: <20260108073803.425343-57-viro@zeniv.linux.org.uk>
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
 fs/smb/server/vfs.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 30b65b667b96..523bc7f942ad 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -54,7 +54,6 @@ static int ksmbd_vfs_path_lookup(struct ksmbd_share_config *share_conf,
 				 struct path *path, bool for_remove)
 {
 	struct qstr last;
-	struct filename *filename __free(putname) = NULL;
 	const struct path *root_share_path = &share_conf->vfs_path;
 	int err, type;
 	struct dentry *d;
@@ -66,7 +65,7 @@ static int ksmbd_vfs_path_lookup(struct ksmbd_share_config *share_conf,
 		flags |= LOOKUP_BENEATH;
 	}
 
-	filename = getname_kernel(pathname);
+	CLASS(filename_kernel, filename)(pathname);
 	err = vfs_path_parent_lookup(filename, flags,
 				     path, &last, &type,
 				     root_share_path);
@@ -664,7 +663,6 @@ int ksmbd_vfs_rename(struct ksmbd_work *work, const struct path *old_path,
 	struct path new_path;
 	struct qstr new_last;
 	struct renamedata rd;
-	struct filename *to;
 	struct ksmbd_share_config *share_conf = work->tcon->share_conf;
 	struct ksmbd_file *parent_fp;
 	int new_type;
@@ -673,7 +671,7 @@ int ksmbd_vfs_rename(struct ksmbd_work *work, const struct path *old_path,
 	if (ksmbd_override_fsids(work))
 		return -ENOMEM;
 
-	to = getname_kernel(newname);
+	CLASS(filename_kernel, to)(newname);
 
 retry:
 	err = vfs_path_parent_lookup(to, lookup_flags | LOOKUP_BENEATH,
@@ -732,7 +730,6 @@ int ksmbd_vfs_rename(struct ksmbd_work *work, const struct path *old_path,
 		goto retry;
 	}
 out1:
-	putname(to);
 	ksmbd_revert_fsids(work);
 	return err;
 }
-- 
2.47.3


