Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 159F13C9CD4
	for <lists+io-uring@lfdr.de>; Thu, 15 Jul 2021 12:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238112AbhGOKjI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Jul 2021 06:39:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241457AbhGOKjH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Jul 2021 06:39:07 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F24C06175F;
        Thu, 15 Jul 2021 03:36:13 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id nd37so8497371ejc.3;
        Thu, 15 Jul 2021 03:36:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uvty18VOG05/H+n1wBlbsuIYvE4GDjObXZQJFvjmwnM=;
        b=kSP0cjr2rtT0hXu2pOVreJXlJPkSgFamTgawgIoTB0eBPEj4mUTB2N5ETl+BHjVzz9
         rnh0bFSfScnAMGVQ5WO32OCDvifpDkNfXasef9DaeYWo9U/a6wtW84D6ODpcqcU3yXNb
         rzcTQxuXuiNxWWigfWJrrhaBYY62K6wim7+OyWVhu+GCsSZlEG77VGiys6KQ6h9kofZB
         WCFkzBHn+GiXUOCut8V8Bk2rxjsyyTrgvVl1MN/RQUSWRPwzrBLTBDk0xfN4jnF5CWsk
         R1q2Z0a7drfKU2lEaIgoFG9HOO10eBOEC6bLrm4GKSyc2Ho8xX1KQAyn0JY+SIMba85b
         jG9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uvty18VOG05/H+n1wBlbsuIYvE4GDjObXZQJFvjmwnM=;
        b=EXmbRkrvVucjRPkLu5rRKP/OPJ92WyuZTt8/icGEHmqUdVCt1gBWzyjh1uLob1DTjk
         IHzoIfBU867anlBvCmi3iQmFHcCLsCPDK/BDvivYxQdYOqYGoi84XF629M3eX4bNOEdT
         fH8JGMuGY/D2MtivgS/EGhygFb3C+j55bLsHJyf9Q1N1GQ9oSQFKU35eIxX+mZBpxOjA
         iSY7lsgFSu6SAjrvC6bc0EvCs1KdClQBClldEfaXfVOE0sRoRVS4XNttaCj1R+pzNDge
         wCqLskBcBx1pIDfDrr8J7Kc+/TYtpkqDQ34pNL6yC30OEIkmNrLu7obab8CH7W+XJB4z
         7jmw==
X-Gm-Message-State: AOAM533dTCcQ3R97H7qPlTkqx+O2AeQ7thhDcN5nwl/8mb6FHTTgppod
        DcC1dM/pEh7qVf51F0Wy5ZY=
X-Google-Smtp-Source: ABdhPJyIIBHwsrJNhrTNnvZi8zXJjBHM3RqVdoiWjYhyDzqgR0hqiWxUyJqGP+1KvhpFVlmREQwRVg==
X-Received: by 2002:a17:906:dd0:: with SMTP id p16mr4805958eji.389.1626345372077;
        Thu, 15 Jul 2021 03:36:12 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id dd24sm2228464edb.45.2021.07.15.03.36.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 03:36:11 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH  02/14] namei: clean up do_rmdir retry logic
Date:   Thu, 15 Jul 2021 17:35:48 +0700
Message-Id: <20210715103600.3570667-3-dkadashev@gmail.com>
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

