Return-Path: <io-uring+bounces-11696-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2868FD1C665
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:37:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 42D1130288A3
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:33:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A063D334C3F;
	Wed, 14 Jan 2026 04:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="q6eDnMVG"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD29328626;
	Wed, 14 Jan 2026 04:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365122; cv=none; b=Bg67TuEXD5LGXNcAGMR4DnxjoTwHVNWmZT/8UYGLloQzISSh1a+WAdeItCgijLWh+OueSgh8YDRr6GuYoE3+PDG/VjjU/m3FMtmt/8m6AOZwR2zsdje6rw0LwQMfjwsHB/oZZ8uKVBVKdNE944rTtOVrN1SeV0Vfq+WTnhdHWUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365122; c=relaxed/simple;
	bh=D/4Kpd2bYKbkRLQSN5eQLKG4OXd7jN3AcvumkEOaeMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s/VEe1u73YcJaWBN+a11tKwHE5Xom/gtW5Oph+uSbJ75hA2R0gZD4mfFqNutESQCW5sNfBiqqs36Fs6qJs2sNpUkCFQTufBRSQlzD4zIvU6w+YItJZHKaj8Liz5XpBi0cPGpXGOpaAnJgacRJOdfTCxHxxzRtdIZjZoLA9Ws0kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=q6eDnMVG; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=yl4N9qiPKC+robz7RIG19DtsqLRtLo4jXB61e6cJSfg=; b=q6eDnMVGCue82S/H/esM2+3jZc
	6KBSWimbIIsHZFZvq/DkOP5nJeUWVRYSV7mXQzPMcxXaaBZzjw15Rd6HDR7BoBvd2eAAk3TrddjSG
	9KMeRzO2odb+BjUR9XFGAVioYH5P+6Joc9Xys2gX4k3PVA26jSpgtPAycQjWPsyq7MnFdAbJl94eZ
	gmHoL3Kv4bqh5ZaLy79mLaADD71yO3CKyK76HI8YrONkydr+f5dVlTLDiKJt3ih8xAoclS+xZGfx0
	iNDQQX5v+5KkYmpKSELOf7eZ0r1E+YWbYMYQCsuHqy7WFhPa060UwuHhkKf/XNrs4+s4dZaa4SM/7
	tWBZqHsQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZO-0000000GJ0O-2VGS;
	Wed, 14 Jan 2026 04:33:22 +0000
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
Subject: [PATCH v5 66/68] ksmbd: use CLASS(filename_kernel)
Date: Wed, 14 Jan 2026 04:33:08 +0000
Message-ID: <20260114043310.3885463-67-viro@zeniv.linux.org.uk>
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


