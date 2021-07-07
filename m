Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 498803BE7EA
	for <lists+io-uring@lfdr.de>; Wed,  7 Jul 2021 14:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231683AbhGGMa5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Jul 2021 08:30:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231630AbhGGMaz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Jul 2021 08:30:55 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0435C061574;
        Wed,  7 Jul 2021 05:28:14 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id t3so3097778edt.12;
        Wed, 07 Jul 2021 05:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dJEfPWt8A2cpdRy8a2TP12zWmZnjHsnti/CgfmiTAVs=;
        b=Pk4/bZDarLKQzT6FQ5PSJ1dcIehdqOZWHbyiloAQ2bvTuH4CMG5HrLAZIcD6k57rVx
         GoglIaul0oj5PlJYPi3r64m/sPEsYzSRClPhgtRccJgr6+pgMUnddN3eWM1O7UwBPa32
         pE6LYq6DQZftVfjVfMGJSVgijh9IP5XetWMxv6TelzC85Xlatj5MmKz//qfsDQvv/5Xh
         0TieF+a+rTBkDSyvM4d5cwao0DWmUvv6BoacU3DMP4HlheZrMMm5OlH8fKibAZcSSQui
         YEidX7TBAxIju7wvqW4mocWYTJKwyzjoksErLb4xlH3jUyldNHPigMMLdjDMeB+t+BYT
         1v5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dJEfPWt8A2cpdRy8a2TP12zWmZnjHsnti/CgfmiTAVs=;
        b=MmZIry0YegQvZxipGkCfDCW2SFls/69YPcLLlXmoqOjxV/leV86uwCuHyBsrjI2Lpu
         XsaAyvuZmlnQFU9FBLm0Ve89GCwdT3ovHJ7NP0bqdxhwlLeiv3QL9Kl1mrU+XA7yTl1A
         ApjZ/VZOZf3DZyuJQpRGs5uuJvIhgHJJF1nGxJcWOsgtJo8/IBZq570oaCFhwVKgx7eP
         cpnwRvzFc3u2CeNpXFqT2l7WPTM6VpcEKDXNsOGbUsLq2ME2n1wmB6NbGl7MH+5BqtWl
         3AfA/5UawVYdYMq8seKiqUKi1QTF6552+320a+9cafFH4dIqmQB7ToHHIAZ0Lx6OGWa0
         9JBQ==
X-Gm-Message-State: AOAM532xlT3sBjjnImAfqbvlt7JnTWbMcGC7JwjQGMGFX7bdc2SpAHFL
        1pqO07yiVcEL4pij9LUnwy8MX9sLvd7Eyf/m
X-Google-Smtp-Source: ABdhPJxoSc64++mtyFflNcst5V1lHeReX82t+NpfXtfdYVo1fzHFCW4CdPh+lB+uWtgOU8HrGEypPQ==
X-Received: by 2002:a05:6402:138c:: with SMTP id b12mr29832153edv.268.1625660893444;
        Wed, 07 Jul 2021 05:28:13 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id ze15sm7019821ejb.79.2021.07.07.05.28.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 05:28:13 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v8 09/11] fs: update do_*() helpers to return ints
Date:   Wed,  7 Jul 2021 19:27:45 +0700
Message-Id: <20210707122747.3292388-10-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210707122747.3292388-1-dkadashev@gmail.com>
References: <20210707122747.3292388-1-dkadashev@gmail.com>
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

