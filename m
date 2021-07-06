Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55DEF3BD723
	for <lists+io-uring@lfdr.de>; Tue,  6 Jul 2021 14:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233812AbhGFMwh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Jul 2021 08:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241617AbhGFMwL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Jul 2021 08:52:11 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CB6BC061762;
        Tue,  6 Jul 2021 05:49:31 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id n14so38115771lfu.8;
        Tue, 06 Jul 2021 05:49:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=U3TpmkEbOEl8XxDNCUtx8QPNmXronxF1cOY9CIR3fQs=;
        b=i26gSEhaDfFOVJ+lkynY5yB2vlj1NKszOie41PEK2RPDegL5+GPPm8R5X2mJDpCC1b
         fqnW23DxNcd5H8mbdvwS1Vn40tOOISMf1vmeJ1R/P/regCZYQJq6+jwQSgop7/dU7uoO
         ouqmDhvxAIUMkpyt7oOyxeS6TKk/t9EE0jYqxXTHOVnxHeQz8/2Ix7WMzpccNhHb8ORd
         UeTumPPOiHpGgzdasDIkMzVP2q2qaMAFz2309RWCGlSumbZkKuPn8BFa+3jJYpfdJnLv
         P7GRs92+JrsyuJtDEm04by6nJJgWIT021Oj8uPWe0hL1Zb/wYmxk3xeaiv+bflFmQSwI
         B9IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U3TpmkEbOEl8XxDNCUtx8QPNmXronxF1cOY9CIR3fQs=;
        b=X9U49zfVwcBqHQyDhG29EVy+VKmPwgx/kiETr1KHeie0NxAkL4OpXKw7eczogg9oto
         qhZab20grWLUoHdG+VpxaTdkwtvxZvyDHyP3FNPF3PijAVI8z/7XHW3WzcGxB0T6LXHA
         T9TkHzhyKFD8YQ5Zke7eDHqbfmK1OtOwqc9BW2+yjDOktBdUfdgdWM5LBxIQHgJA2BmM
         RW2XEfJF3XilO0gGAH85Pl/9vVu4fl9FqvHgacEE9e8gMtlAl0qyvonA570SzraPX6bF
         g7fhPGdE2w2WXCGMOvwK2thYPnmNEhBIG8H/2UuXHbHVCvIU/IJqp4lE88gEenAGvaPp
         /vfA==
X-Gm-Message-State: AOAM532rgiGLi7zp5bY2UFwwq0nNhFok+hII+7IHtY0QpHseur2UyFk4
        XAtskx1ox/94AD/gWrl3eEA=
X-Google-Smtp-Source: ABdhPJxIMvOC7fye8f41lFke77y/TKZP9IxyoXzwFdWfXal/mYzrQWyv08pJzu3oHOUC6yn+s2Tcig==
X-Received: by 2002:ac2:4285:: with SMTP id m5mr11469535lfh.244.1625575769659;
        Tue, 06 Jul 2021 05:49:29 -0700 (PDT)
Received: from carbon.v ([94.143.149.146])
        by smtp.googlemail.com with ESMTPSA id r18sm139519ljc.120.2021.07.06.05.49.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jul 2021 05:49:29 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v7 08/10] fs: update do_*() helpers to return ints
Date:   Tue,  6 Jul 2021 19:48:59 +0700
Message-Id: <20210706124901.1360377-9-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706124901.1360377-1-dkadashev@gmail.com>
References: <20210706124901.1360377-1-dkadashev@gmail.com>
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
index 0a2731f7ef71..1656073ca493 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3746,7 +3746,7 @@ static int may_mknod(umode_t mode)
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
@@ -3945,7 +3945,7 @@ int vfs_rmdir(struct user_namespace *mnt_userns, struct inode *dir,
 }
 EXPORT_SYMBOL(vfs_rmdir);
 
-long do_rmdir(int dfd, struct filename *name)
+int do_rmdir(int dfd, struct filename *name)
 {
 	struct user_namespace *mnt_userns;
 	int error = 0;
@@ -4083,7 +4083,7 @@ EXPORT_SYMBOL(vfs_unlink);
  * writeout happening, and we don't want to prevent access to the directory
  * while waiting on the I/O.
  */
-long do_unlinkat(int dfd, struct filename *name)
+int do_unlinkat(int dfd, struct filename *name)
 {
 	int error;
 	struct dentry *dentry;
@@ -4210,7 +4210,7 @@ int vfs_symlink(struct user_namespace *mnt_userns, struct inode *dir,
 }
 EXPORT_SYMBOL(vfs_symlink);
 
-static long do_symlinkat(struct filename *from, int newdfd,
+static int do_symlinkat(struct filename *from, int newdfd,
 		  struct filename *to)
 {
 	int error;
-- 
2.30.2

