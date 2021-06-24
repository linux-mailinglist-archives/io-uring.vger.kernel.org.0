Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0A23B2D89
	for <lists+io-uring@lfdr.de>; Thu, 24 Jun 2021 13:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232447AbhFXLRh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Jun 2021 07:17:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232440AbhFXLRf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Jun 2021 07:17:35 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A4C8C061760;
        Thu, 24 Jun 2021 04:15:16 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id c16so7207885ljh.0;
        Thu, 24 Jun 2021 04:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+1IHeLQmFnCkiRM6Le09tuowGzlsNL/9ZhUl0moeekU=;
        b=UlNba2a9ma6y+J9Kv2fW/386Zp2+Gmujt/QJjDt9x7Md8rM+MPfa5JX64hmwGStLSk
         u/MzuKc08ZtS9cUTm/JrEAPfu8w5+6/C2iQkRDQj8WsJ2tkZZIBvgwHvpf6iXuGdrUh1
         YObJ/5bYyc9b8U/cFoAPEJ22IEWaZ2Y9z5+iTVib3xq1GpUMAQppY61VLoEkeDAqUxpK
         6+Gq2FtZH1rK9DWP6xEXQtkbCLKwAmF1BlYQzxwj63Qtw4uheKvgulpUz2jWqGPktOmR
         AV49/M9S/pE76rmy7UeDXbNR19Tj/AoLq/OQQQuTbExleEBCL/d+zCF1oZ89tHwIO58h
         w+DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+1IHeLQmFnCkiRM6Le09tuowGzlsNL/9ZhUl0moeekU=;
        b=lYsura1I6g1lcwC1fBPzIFAUfl4UWSzeupZk/+CBvc9PsJ0r+n8m05BC2D8BkrIt51
         taDUm4rEcVk7ShdIaIwjZOmwscbUmtXs7WmXc2UkZbapIfuZMmvLbmcN+1SNrdenWX5/
         Zw2/rZ7zN/aDzs/oD4aZNq+qLcbymS5i8bAmBAeua1UZOr6PI0J/SDaxwHjbE6GOIB00
         GU6yeM4Vuqc5PFGHtr/LAdRaJ/F9Mu9ZkRFYl2FowDxEgDDOALz5D2XTIVhnesiF9iv5
         xevvsl1dsV7MutZZvCrkU7WPKQgEDZ0ro6I4KAMU1k6R6kl/5CHhScaIOA9m29GBCtXq
         LtVg==
X-Gm-Message-State: AOAM533UuyhTBkM6bCwYr9COq0M2ZqI4I2P43aNPk+5p5LaT0AOeA6/i
        6Lv373RQTaWHK7s84yo8Ju4=
X-Google-Smtp-Source: ABdhPJyvD95YLFujaf0giD5sCvYw0iC3O8AgnlO47bGiKY0X1tFfaJTW+1dg9jKkzkPtn51SifEAQg==
X-Received: by 2002:a2e:8750:: with SMTP id q16mr3481727ljj.92.1624533314962;
        Thu, 24 Jun 2021 04:15:14 -0700 (PDT)
Received: from carbon.v ([94.143.149.146])
        by smtp.googlemail.com with ESMTPSA id q21sm195293lfp.233.2021.06.24.04.15.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 04:15:14 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v6 7/9] fs: update do_*() helpers to return ints
Date:   Thu, 24 Jun 2021 18:14:50 +0700
Message-Id: <20210624111452.658342-8-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210624111452.658342-1-dkadashev@gmail.com>
References: <20210624111452.658342-1-dkadashev@gmail.com>
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
index 07b1619dd343..f99de6e294ad 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3743,7 +3743,7 @@ static int may_mknod(umode_t mode)
 	}
 }
 
-static long do_mknodat(int dfd, struct filename *name, umode_t mode,
+static int do_mknodat(int dfd, struct filename *name, umode_t mode,
 		unsigned int dev)
 {
 	struct user_namespace *mnt_userns;
@@ -3848,7 +3848,7 @@ int vfs_mkdir(struct user_namespace *mnt_userns, struct inode *dir,
 }
 EXPORT_SYMBOL(vfs_mkdir);
 
-long do_mkdirat(int dfd, struct filename *name, umode_t mode)
+int do_mkdirat(int dfd, struct filename *name, umode_t mode)
 {
 	struct dentry *dentry;
 	struct path path;
@@ -3943,7 +3943,7 @@ int vfs_rmdir(struct user_namespace *mnt_userns, struct inode *dir,
 }
 EXPORT_SYMBOL(vfs_rmdir);
 
-long do_rmdir(int dfd, struct filename *name)
+int do_rmdir(int dfd, struct filename *name)
 {
 	struct user_namespace *mnt_userns;
 	int error = 0;
@@ -4081,7 +4081,7 @@ EXPORT_SYMBOL(vfs_unlink);
  * writeout happening, and we don't want to prevent access to the directory
  * while waiting on the I/O.
  */
-long do_unlinkat(int dfd, struct filename *name)
+int do_unlinkat(int dfd, struct filename *name)
 {
 	int error;
 	struct dentry *dentry;
@@ -4208,7 +4208,7 @@ int vfs_symlink(struct user_namespace *mnt_userns, struct inode *dir,
 }
 EXPORT_SYMBOL(vfs_symlink);
 
-static long do_symlinkat(struct filename *from, int newdfd,
+static int do_symlinkat(struct filename *from, int newdfd,
 		  struct filename *to)
 {
 	int error;
-- 
2.30.2

