Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE243BF5A9
	for <lists+io-uring@lfdr.de>; Thu,  8 Jul 2021 08:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbhGHGiG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Jul 2021 02:38:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230414AbhGHGiD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Jul 2021 02:38:03 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5233AC061574;
        Wed,  7 Jul 2021 23:35:22 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id s15so6835308edt.13;
        Wed, 07 Jul 2021 23:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dJEfPWt8A2cpdRy8a2TP12zWmZnjHsnti/CgfmiTAVs=;
        b=SO0Te5a8vrpaBfywmtjzyQIA0pLAVyiPDCyUowoT4pFvyW200rWllfAJWK2aWR5Y7r
         pzhLGsm0Gu/ul24NOxtZ1WjO1LsPXFVMsvTOm9zram+HErnv60MzDQg8yFCsEBvYE1sy
         Mm+4Gf9NwnbWhmv9CGMYpNcv1MxMb+AiSt35VP7dHu8OGA5vnep8b71NFUTAyuzseQm4
         i/8Jp9SYopOULk+B62CR+yPJ7MLDSV7j+xufJDVMUV5n6YvATqcZW5LhF1eJFxX1bUiE
         Cs27M3e4a0F833wj/ml93sc2gjGM5N1wMkUQIotC/+d3my6PdwkvSf1m0+PXGcQQYpDG
         UGTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dJEfPWt8A2cpdRy8a2TP12zWmZnjHsnti/CgfmiTAVs=;
        b=cH3V9Ph+ACMG652FEY1ucHEjgzFws/zZb3qnlzYTtoZTisZKI1NLnZDQA7dWq2z770
         wqUYLyT0jPjMcysNjkYc8/6KZMlUiL+EJ+FO2IE/Dv8s8WdU+BDHFrN20pBLewo+L74+
         3dqWvH2vcI1XyQbIJXm1UYHgcwA3PmMfkzw1eVNw2E8BBZxHuNyGynPZYPxWa3tKcBM6
         6BfR6p09ltz5DjBu2j1lsnBRtOXwzaZhxwxR35Z0MCB1YsZ3vRABWb3N/84foiePberg
         duwit2qAdOKfVOhOzMFItRKf2Ue6M4amAIfXCtzdlWlNBeIOVMsfzaVWT9YPapX2D3RF
         3BFg==
X-Gm-Message-State: AOAM530h26hp3KpWMxiPxskp07p+L95Wf7mUfuH2YK+k21/ogjJNs362
        sIxp1YP3W70VQ4gyRR0BxmY=
X-Google-Smtp-Source: ABdhPJw0JkxMjbzYjej4sc4nz+6XYoB4Q9B+xqFXXNqlXCVriFBheAHVuB982W9NnjKTqzFbRQrVzg==
X-Received: by 2002:a05:6402:1688:: with SMTP id a8mr34097761edv.4.1625726121018;
        Wed, 07 Jul 2021 23:35:21 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id u21sm410260eja.59.2021.07.07.23.35.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 23:35:20 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v9 08/11] namei: update do_*() helpers to return ints
Date:   Thu,  8 Jul 2021 13:34:44 +0700
Message-Id: <20210708063447.3556403-9-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210708063447.3556403-1-dkadashev@gmail.com>
References: <20210708063447.3556403-1-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Update the following to return int rather than long, for uniformity with
the rest of the do_* helpers in namei.c:

* do_rmdir()
* do_unlinkat()
* do_mkdirat()
* do_mknodat()
* do_symlinkat()

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Link: https://lore.kernel.org/io-uring/20210514143202.dmzfcgz5hnauy7ze@wittgenstein/
Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/internal.h |  6 +++---
 fs/namei.c    | 10 +++++-----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 848e165ef0f1..207a455e32d3 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -72,12 +72,12 @@ extern int filename_lookup(int dfd, struct filename *name, unsigned flags,
 			   struct path *path, struct path *root);
 extern int vfs_path_lookup(struct dentry *, struct vfsmount *,
 			   const char *, unsigned int, struct path *);
-long do_rmdir(int dfd, struct filename *name);
-long do_unlinkat(int dfd, struct filename *name);
+int do_rmdir(int dfd, struct filename *name);
+int do_unlinkat(int dfd, struct filename *name);
 int may_linkat(struct user_namespace *mnt_userns, struct path *link);
 int do_renameat2(int olddfd, struct filename *oldname, int newdfd,
 		 struct filename *newname, unsigned int flags);
-long do_mkdirat(int dfd, struct filename *name, umode_t mode);
+int do_mkdirat(int dfd, struct filename *name, umode_t mode);
 
 /*
  * namespace.c
diff --git a/fs/namei.c b/fs/namei.c
index c4e13bd8652f..d06aeaf5da00 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3745,7 +3745,7 @@ static int may_mknod(umode_t mode)
 	}
 }
 
-static long do_mknodat(int dfd, struct filename *name, umode_t mode,
+static int do_mknodat(int dfd, struct filename *name, umode_t mode,
 		unsigned int dev)
 {
 	struct user_namespace *mnt_userns;
@@ -3850,7 +3850,7 @@ int vfs_mkdir(struct user_namespace *mnt_userns, struct inode *dir,
 }
 EXPORT_SYMBOL(vfs_mkdir);
 
-long do_mkdirat(int dfd, struct filename *name, umode_t mode)
+int do_mkdirat(int dfd, struct filename *name, umode_t mode)
 {
 	struct dentry *dentry;
 	struct path path;
@@ -3947,7 +3947,7 @@ int vfs_rmdir(struct user_namespace *mnt_userns, struct inode *dir,
 }
 EXPORT_SYMBOL(vfs_rmdir);
 
-long do_rmdir(int dfd, struct filename *name)
+int do_rmdir(int dfd, struct filename *name)
 {
 	struct user_namespace *mnt_userns;
 	int error;
@@ -4085,7 +4085,7 @@ EXPORT_SYMBOL(vfs_unlink);
  * writeout happening, and we don't want to prevent access to the directory
  * while waiting on the I/O.
  */
-long do_unlinkat(int dfd, struct filename *name)
+int do_unlinkat(int dfd, struct filename *name)
 {
 	int error;
 	struct dentry *dentry;
@@ -4213,7 +4213,7 @@ int vfs_symlink(struct user_namespace *mnt_userns, struct inode *dir,
 }
 EXPORT_SYMBOL(vfs_symlink);
 
-static long do_symlinkat(struct filename *from, int newdfd,
+static int do_symlinkat(struct filename *from, int newdfd,
 		  struct filename *to)
 {
 	int error;
-- 
2.30.2

