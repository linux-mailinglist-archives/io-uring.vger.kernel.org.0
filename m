Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7253C9D12
	for <lists+io-uring@lfdr.de>; Thu, 15 Jul 2021 12:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241622AbhGOKsp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Jul 2021 06:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241620AbhGOKsp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Jul 2021 06:48:45 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F8EC06175F;
        Thu, 15 Jul 2021 03:45:52 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id dp20so6617082ejc.7;
        Thu, 15 Jul 2021 03:45:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uvty18VOG05/H+n1wBlbsuIYvE4GDjObXZQJFvjmwnM=;
        b=t5R2wX95ccmsCYEPK1M0YCInfJsTdVzvCx9PztOYvvr/8/DNfzFfavqq1dWyYUWt7J
         i1zgVvGRvasP7Pys7nz0DUfMn1UdK36FzavewtScHiTRHh+FQ1bOG7oAQRiFNAUGHUya
         zVcjmca3yuUxD6gokF87KQWtRTrCnsaqdMeQ2hGitErv05S1qYptJ+co+w+zBCZtP1UJ
         AmKpvGQiNPVzHKIW3yeVDxgISqBVY7iARUrffM2jAHWLVQ8TPlZywfO73zOuLphWEXKZ
         zzMYGhC1PYgb5Zx+2aHUAmZuBkkQlYOqTMWvDNzwK5iqjw9S0cuxtXadlMms/jPz8vB2
         ksNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uvty18VOG05/H+n1wBlbsuIYvE4GDjObXZQJFvjmwnM=;
        b=B0RRLQmGxsNSDkxdwqANxlAnKaU3HhN1MVEkCIP0JiEmwaf8oX0je6LYS8/jtagjzh
         I3AsDJR+3IH9Qe9PMF416/9UlRNLntY04ys8mYJTNUBRWWAuH8KjJitf9uevtBCuXuxL
         1uxBHAx9xPhUp/PccXCsgh8k9ErdQvNJdSlbBoUN4tM/qVYfQ9mA3oHh2NiovG/b3S3a
         TJe1rY0WCbOLcXSXzRoi3Gcv5mXKWjmcmY2WRHfe2kyWoClbQ2gchbpAo2qrPxTACEOJ
         HfamxfpGDn+3BGhER/SWpE+PlRmaKZz6mHHVigTNnk+AKpyQ+e0PeLrIfDd8z/bmyZ8/
         QA7Q==
X-Gm-Message-State: AOAM532slkub8+O9umFXZTf/02Rx1uZmAr1isIrGg1ugvCSgrwZUwZQW
        wjSAlmBO7mXzC1OJaCNvs4E=
X-Google-Smtp-Source: ABdhPJzC54kam/0M33gVI+97K1sgLFv+EbTgVv2DP5zscNB1EVSgXbOEeQmME5Z5S1qGBYbQ178zxA==
X-Received: by 2002:a17:906:616:: with SMTP id s22mr4833879ejb.210.1626345950944;
        Thu, 15 Jul 2021 03:45:50 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id d19sm2231498eds.54.2021.07.15.03.45.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 03:45:50 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v2 02/14] namei: clean up do_rmdir retry logic
Date:   Thu, 15 Jul 2021 17:45:24 +0700
Message-Id: <20210715104536.3598130-3-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210715104536.3598130-1-dkadashev@gmail.com>
References: <20210715104536.3598130-1-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

No functional changes, just move the main logic to a helper function to
make the whole thing easier to follow.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/io-uring/CAHk-=wh=cpt_tQCirzFZRPawRpbuFTZ2MxNpXiyUF+eBXF=+sw@mail.gmail.com/
Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
---
 fs/namei.c | 44 +++++++++++++++++++++++++-------------------
 1 file changed, 25 insertions(+), 19 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 99d5c3a4c12e..fbae4e9fcf53 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3947,7 +3947,7 @@ int vfs_rmdir(struct user_namespace *mnt_userns, struct inode *dir,
 }
 EXPORT_SYMBOL(vfs_rmdir);
 
-int do_rmdir(int dfd, struct filename *name)
+static int try_rmdir(int dfd, struct filename *name, unsigned int lookup_flags)
 {
 	struct user_namespace *mnt_userns;
 	int error;
@@ -3955,54 +3955,60 @@ int do_rmdir(int dfd, struct filename *name)
 	struct path path;
 	struct qstr last;
 	int type;
-	unsigned int lookup_flags = 0;
-retry:
+
 	error = __filename_parentat(dfd, name, lookup_flags, &path, &last, &type);
 	if (error)
-		goto exit1;
+		return error;
 
 	switch (type) {
 	case LAST_DOTDOT:
 		error = -ENOTEMPTY;
-		goto exit2;
+		goto exit1;
 	case LAST_DOT:
 		error = -EINVAL;
-		goto exit2;
+		goto exit1;
 	case LAST_ROOT:
 		error = -EBUSY;
-		goto exit2;
+		goto exit1;
 	}
 
 	error = mnt_want_write(path.mnt);
 	if (error)
-		goto exit2;
+		goto exit1;
 
 	inode_lock_nested(path.dentry->d_inode, I_MUTEX_PARENT);
 	dentry = __lookup_hash(&last, path.dentry, lookup_flags);
 	error = PTR_ERR(dentry);
 	if (IS_ERR(dentry))
-		goto exit3;
+		goto exit2;
 	if (!dentry->d_inode) {
 		error = -ENOENT;
-		goto exit4;
+		goto exit3;
 	}
 	error = security_path_rmdir(&path, dentry);
 	if (error)
-		goto exit4;
+		goto exit3;
 	mnt_userns = mnt_user_ns(path.mnt);
 	error = vfs_rmdir(mnt_userns, path.dentry->d_inode, dentry);
-exit4:
-	dput(dentry);
 exit3:
+	dput(dentry);
+exit2:
 	inode_unlock(path.dentry->d_inode);
 	mnt_drop_write(path.mnt);
-exit2:
-	path_put(&path);
 exit1:
-	if (unlikely(retry_estale(error, lookup_flags))) {
-		lookup_flags |= LOOKUP_REVAL;
-		goto retry;
-	}
+	path_put(&path);
+
+	return error;
+}
+
+int do_rmdir(int dfd, struct filename *name)
+{
+	int error;
+
+	error = try_rmdir(dfd, name, 0);
+	if (unlikely(retry_estale(error, 0)))
+		error = try_rmdir(dfd, name, LOOKUP_REVAL);
+
 	putname(name);
 	return error;
 }
-- 
2.30.2

