Return-Path: <io-uring+bounces-11466-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 439E4D0170B
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 08:39:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id CDC7A307942F
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 07:37:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB65533E37C;
	Thu,  8 Jan 2026 07:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="Qag851np"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ABED32AABC;
	Thu,  8 Jan 2026 07:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857817; cv=none; b=C0reQJQVq7YUgo9xWdju5Qh2s6v1XQ0WrbmxGxBTjL8I8JV3Q2HZOwOutjfBkLKVgn+YD2uanxKGUt+UT6XC4OnUa3liXNFJNpZBpQL7w3gHNR2042XwVGfM61hW0E7DiND69NP/q50RQCYrcvNDYCsmEsYdrqB3cbMH/5IeYeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857817; c=relaxed/simple;
	bh=rYNiXERMORELD3rtPdZULgbnCI+3YEmNF+Hwi5pTBHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pdUYXg2h90lZIsDDDlFzEfffduSl+JVQljbDHWY78wxsfM2Kg1B8BE1PWRH7wUoyjeOi74acjhmvoH6blpUJEce3HOqcln/mYRIdiu4cgzG/oErfQNd4FpgQEl+eSK4xE4VYo62R1tuyOBviDOiwr8g0edUSk5yL4KFJRHZDgYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=Qag851np; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=O3vCMEIcJ6QDV68ynljSAAzPvL85FljOJrW2O7eAqj8=; b=Qag851npjPI5cCZ5wPC3LzRWTX
	NO2RGhhZGlx79rOTZvvbwj98Ian64HiYNdSkiR0lnKtIdvRTn9lzjR3yA/HpRqlzhO6KaBzyaSHx3
	rib+3YCU56VMqFLBvBh4m6YBQ3UOsL9Mj6vOHY9wOb2fofP+Rox7OOm58ucAzg8y4QbpIcOGIctZo
	+4L3fLxVmfBanVuttLUeToC6BHdWx/xJ8d4/foPHXqQafGELtfZrrcdlgCEV88zjm8hxood6vE71h
	ldgN8JiMldXYpjrM9KRXUOgRzn4qWuqh0zqQXeOSzLKbSU/PUF2Z3uW6WHc9ryYaKMkxOL8Uhy+0L
	A0IgbXWQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkau-00000001mlt-1SYl;
	Thu, 08 Jan 2026 07:38:08 +0000
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
Subject: [PATCH v4 25/59] ksmbd_vfs_rename(): vfs_path_parent_lookup() accepts ERR_PTR() as name
Date: Thu,  8 Jan 2026 07:37:29 +0000
Message-ID: <20260108073803.425343-26-viro@zeniv.linux.org.uk>
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

no need to check in the caller

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/smb/server/vfs.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index a97226116840..30b65b667b96 100644
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


