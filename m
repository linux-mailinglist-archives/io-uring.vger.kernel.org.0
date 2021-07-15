Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB0333C9CD8
	for <lists+io-uring@lfdr.de>; Thu, 15 Jul 2021 12:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241458AbhGOKjL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Jul 2021 06:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241457AbhGOKjK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Jul 2021 06:39:10 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66E9AC061760;
        Thu, 15 Jul 2021 03:36:16 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id l1so7347657edr.11;
        Thu, 15 Jul 2021 03:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rr2ogX0F2b70BRK2G5XV9Y3jelCgb4ODEp6gY/X8CXA=;
        b=G03xkg5hUl+2ZbuSu9MEGCBXLeo7fop7DEJOWJbBes1mnnhLkNtT5kTfVBW1nWfI+f
         L2gBbTFfRBro42BxMyFzK1cRl0Gh+9Ng5H78rTnJoWUEYKF2AL14JTWifse8Mhq7/PA1
         /x1xgdQA/atOFEEm2ZRIp66+X3oep6BgyfGL+x5gna53CJHZ9zoHqBQYZ01XiCt3TjSJ
         GBiN1iIsBX0vjBXMG3hk6DWK1JD9qq58uzOiIVmRycMHnj10ZBUS2E3/0kDlL1fY10mk
         S2YZPvwm2tgXphnuV2zfT0Oz6+kYV5t60pGtTaRvrrPedtQ98cAYr9ByI19RBoyJ0umj
         /4HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rr2ogX0F2b70BRK2G5XV9Y3jelCgb4ODEp6gY/X8CXA=;
        b=ZCjbY6UWnVczAhGGhM/i6ZsYYjNJNAX+5wrlCHcQfxB/LIJ580B1CW0cj2p6GILf9Z
         9ksxWLo9vU5mJt8aJmmCUzVmcfPH+QXqACjio9ZeyhyCPJWvrtY7c67jW7IyqOZ5xCyZ
         fHQALSg9cbaAA86V3a3CbUQD7mXIM2MlN3qYzbWpbTnkwP8oiYNITLKAgeoiOm/dZbWw
         HAWXbvOPUH3Et8f2u3SfXVRy119tqtiNDrNXoY36pxEay26PmAFX1+6ccLVkOKx5kTN7
         vOYVm4y7W6X56L9ZUQVaXnRKPMYLsTAc805JjqwS5g1qxrIkUwgM30F3zfLSv9KiG/8C
         XGbQ==
X-Gm-Message-State: AOAM530wbrJROG6PHy2F9Qv9uHlLo11Q21M45lyQzGnKHv4FxW/nUzKy
        8l1TqpCHPvWADtyp00n4lwY=
X-Google-Smtp-Source: ABdhPJx+6U6vT9VtGsBbXgs5kTtgeBn3Xj/CGVOTtTzf5nHxTFb2kGwNiGbsci7Qx3qKuOfLs7xn8Q==
X-Received: by 2002:a05:6402:895:: with SMTP id e21mr5882458edy.9.1626345375063;
        Thu, 15 Jul 2021 03:36:15 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id dd24sm2228464edb.45.2021.07.15.03.36.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 03:36:14 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH  04/14] namei: clean up do_unlinkat retry logic
Date:   Thu, 15 Jul 2021 17:35:50 +0700
Message-Id: <20210715103600.3570667-5-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210715103600.3570667-1-dkadashev@gmail.com>
References: <20210715103600.3570667-1-dkadashev@gmail.com>
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
 fs/namei.c | 42 ++++++++++++++++++++++++------------------
 1 file changed, 24 insertions(+), 18 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 6253486718d5..703cce40d597 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4091,7 +4091,9 @@ EXPORT_SYMBOL(vfs_unlink);
  * writeout happening, and we don't want to prevent access to the directory
  * while waiting on the I/O.
  */
-int do_unlinkat(int dfd, struct filename *name)
+
+static int try_unlinkat(int dfd, struct filename *name,
+			unsigned int lookup_flags)
 {
 	int error;
 	struct dentry *dentry;
@@ -4100,19 +4102,18 @@ int do_unlinkat(int dfd, struct filename *name)
 	int type;
 	struct inode *inode = NULL;
 	struct inode *delegated_inode = NULL;
-	unsigned int lookup_flags = 0;
-retry:
+
 	error = __filename_parentat(dfd, name, lookup_flags, &path, &last, &type);
 	if (error)
-		goto exit1;
+		return error;
 
 	error = -EISDIR;
 	if (type != LAST_NORM)
-		goto exit2;
+		goto exit1;
 
 	error = mnt_want_write(path.mnt);
 	if (error)
-		goto exit2;
+		goto exit1;
 retry_deleg:
 	inode_lock_nested(path.dentry->d_inode, I_MUTEX_PARENT);
 	dentry = __lookup_hash(&last, path.dentry, lookup_flags);
@@ -4129,11 +4130,11 @@ int do_unlinkat(int dfd, struct filename *name)
 		ihold(inode);
 		error = security_path_unlink(&path, dentry);
 		if (error)
-			goto exit3;
+			goto exit2;
 		mnt_userns = mnt_user_ns(path.mnt);
 		error = vfs_unlink(mnt_userns, path.dentry->d_inode, dentry,
 				   &delegated_inode);
-exit3:
+exit2:
 		dput(dentry);
 	}
 	inode_unlock(path.dentry->d_inode);
@@ -4146,17 +4147,9 @@ int do_unlinkat(int dfd, struct filename *name)
 			goto retry_deleg;
 	}
 	mnt_drop_write(path.mnt);
-exit2:
-	path_put(&path);
 exit1:
-	if (unlikely(retry_estale(error, lookup_flags))) {
-		lookup_flags |= LOOKUP_REVAL;
-		inode = NULL;
-		goto retry;
-	}
-	putname(name);
+	path_put(&path);
 	return error;
-
 slashes:
 	if (d_is_negative(dentry))
 		error = -ENOENT;
@@ -4164,7 +4157,20 @@ int do_unlinkat(int dfd, struct filename *name)
 		error = -EISDIR;
 	else
 		error = -ENOTDIR;
-	goto exit3;
+	goto exit2;
+}
+
+int do_unlinkat(int dfd, struct filename *name)
+{
+	int error;
+
+	error = try_unlinkat(dfd, name, 0);
+	if (unlikely(retry_estale(error, 0)))
+		error = try_unlinkat(dfd, name, LOOKUP_REVAL);
+
+	putname(name);
+	return error;
+
 }
 
 SYSCALL_DEFINE3(unlinkat, int, dfd, const char __user *, pathname, int, flag)
-- 
2.30.2

