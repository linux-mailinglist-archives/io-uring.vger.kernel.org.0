Return-Path: <io-uring+bounces-11086-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id B120DCC0CA5
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 04:57:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7D8A1304BC43
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 03:55:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C513C32144A;
	Tue, 16 Dec 2025 03:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="jcf3OCkS"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4E73126B6;
	Tue, 16 Dec 2025 03:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765857296; cv=none; b=N/2Rlp9SSinuyW5w04wia5E4uPxnjlXhkgIqAHScjxCTmzKnfUAVOPzUDQ4LzmbrJhD0zWhaQDDP9NO3rMrOJ10+lRvBw5L7F9YEdkPwk/5HPoZCIU0IUO/n49QcsDl5tqSesujBmaQ5LW8uaYB6p8384+pvjMDiWxTfuPWluPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765857296; c=relaxed/simple;
	bh=j/fZI9gOy5aAZK2Biqi4W4BSmjrAvJoDy10xpzp9eQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IJLKPVrJywa20kUj7F1JldL5UmQslN72bppj4t3JNGbU8AmuaWfwK1SrfQ4MXgclOELU0/SZFWdr5uDiJWkrhrlxqzVEwlMV/GGkUxMbLMDNvxIitX6mJQP47wYDjLHvMlaaxnz98wEso/LixGhxdRs52j4R8rl8C+y9kyGnrio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=jcf3OCkS; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=+ujKCUHwkeCitxlUD/zuRqlmA0R6LL0GJMO0Py7Npfc=; b=jcf3OCkSgbHNl8Xo7cbwcv5kHp
	YUEkyKhnmPDYcni+CQVTfabzmz5kaLKiDQTT209koTxqBKHDN+l9H9GhO3zrxS3nOrX/dUDGCewxm
	Ira0Ra2l1FlgYhz1MbmBwRC9fKs8/yhHFlhTMf0CYzz2MNbmaVCIFjmYKzw41TWIvJsj0vY53rPMX
	Zi7hOwwv+4BJCReQBfH6JhCJaKZzyyDPJC7CYqQsJwyiGnY3xi+6Kmxxcqapz4pFk4WRTY2AOlMg9
	OK8fiYBy7/qrSkoKohjP1y9uxryuu1/BU2pQDMOBLAKzbM1ydnxPJ/BWtoF5+LtcBP2yc7Es2Muz8
	8ooMsLtQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVM9k-0000000GwOJ-2mov;
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
Subject: [RFC PATCH v3 57/59] ksmbd: use CLASS(filename_kernel)
Date: Tue, 16 Dec 2025 03:55:16 +0000
Message-ID: <20251216035518.4037331-58-viro@zeniv.linux.org.uk>
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
 fs/smb/server/vfs.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index abfaebcf8cde..0fcf4898035e 100644
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


