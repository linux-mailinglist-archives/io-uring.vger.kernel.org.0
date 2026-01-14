Return-Path: <io-uring+bounces-11692-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F296D1C6DD
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:42:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0DA0930D6B53
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:33:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B442633374F;
	Wed, 14 Jan 2026 04:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="n13ngzUJ"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B1132863E;
	Wed, 14 Jan 2026 04:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365122; cv=none; b=Q06S9TU6nm5FFD4qRlbd9WpKguDH6tCnQgFJzRWn5SwjgnJVYDmvB5kmqJuW1vl9i6FcqRFTg3Zs597OtMdl8BkhFlJ/JH+UZOdM18I8oXeGGHVB5uwtb6C4VT/vBCRvlJm2zeDcb0qj/AX7qax5xItHnGdJVBq5SMUs1I1O9tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365122; c=relaxed/simple;
	bh=RZMRszjUY/fIM2JLm9jks2g6cg0EVOixOwmn11+9ZsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eisKax52vQh8OBwKPhGgVR+UsYCdOD0B/G66sQO3UQwd+RrGW16XQa9dDoWwXefNn89Hs0ue5Fojowik53LiOwuGjVhJgqEHWF7b+aRKvqOmdDlmNc9G0x/3T3IdTq1X3Ifkdtm/z0rtOGLB5UU2SMXuJwqJ3+9mnNEsItvTBHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=n13ngzUJ; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=2HkCXtuYG81yDH2ptlOKycPDQQLzNXbW/SGw7cqaL7M=; b=n13ngzUJJNjynAk5oLJT8hVINI
	U9PhZSXxbeSNzHXmKzk6/VX2mQcxHgVayhLGNULAk8JxYuaob/4rOq+G2DAG8HMgP/NvJbcHLutMv
	HsEyNcrgJtz1+8fAa9xSBD2irNm3CUU7Rj9l+qaqN6Bs997Wj/55U1+dLofxUPq8tJuvqXCT0ouTK
	1gJJUwtd5QlodwnZXkOCUOh7MSJmDaeO5w8HtjO7AsEa4cTxm3ia33vagqUDJKQt7E+3mroSTKdR6
	rCuMqH84qJKu9mIYufkCUluPtslleG/TOIECku118jk6p4L91beD0OgcEPt5BDFIY4sCLx2LKdDTj
	+R9DJaKw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZO-0000000GJ0Y-2zDO;
	Wed, 14 Jan 2026 04:33:23 +0000
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
Subject: [PATCH v5 67/68] alpha: switch osf_mount() to strndup_user()
Date: Wed, 14 Jan 2026 04:33:09 +0000
Message-ID: <20260114043310.3885463-68-viro@zeniv.linux.org.uk>
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

... same as native mount(2) is doing for devname argument.  While we
are at it, fix misspelling ufs_args as cdfs_args in osf_ufs_mount() -
layouts are identical, so it doesn't change anything, but the current
variant is confusing for no reason.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/alpha/kernel/osf_sys.c | 34 +++++++++++-----------------------
 1 file changed, 11 insertions(+), 23 deletions(-)

diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
index a08e8edef1a4..7b6543d2cca3 100644
--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -454,42 +454,30 @@ static int
 osf_ufs_mount(const char __user *dirname,
 	      struct ufs_args __user *args, int flags)
 {
-	int retval;
-	struct cdfs_args tmp;
-	struct filename *devname;
+	struct ufs_args tmp;
+	char *devname __free(kfree) = NULL;
 
-	retval = -EFAULT;
 	if (copy_from_user(&tmp, args, sizeof(tmp)))
-		goto out;
-	devname = getname(tmp.devname);
-	retval = PTR_ERR(devname);
+		return -EFAULT;
+	devname = strndup_user(tmp.devname, PATH_MAX);
 	if (IS_ERR(devname))
-		goto out;
-	retval = do_mount(devname->name, dirname, "ext2", flags, NULL);
-	putname(devname);
- out:
-	return retval;
+		return PTR_ERR(devname);
+	return do_mount(devname, dirname, "ext2", flags, NULL);
 }
 
 static int
 osf_cdfs_mount(const char __user *dirname,
 	       struct cdfs_args __user *args, int flags)
 {
-	int retval;
 	struct cdfs_args tmp;
-	struct filename *devname;
+	char *devname __free(kfree) = NULL;
 
-	retval = -EFAULT;
 	if (copy_from_user(&tmp, args, sizeof(tmp)))
-		goto out;
-	devname = getname(tmp.devname);
-	retval = PTR_ERR(devname);
+		return -EFAULT;
+	devname = strndup_user(tmp.devname, PATH_MAX);
 	if (IS_ERR(devname))
-		goto out;
-	retval = do_mount(devname->name, dirname, "iso9660", flags, NULL);
-	putname(devname);
- out:
-	return retval;
+		return PTR_ERR(devname);
+	return do_mount(devname, dirname, "iso9660", flags, NULL);
 }
 
 static int
-- 
2.47.3


