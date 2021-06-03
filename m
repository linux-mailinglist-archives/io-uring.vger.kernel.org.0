Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38AA23999C6
	for <lists+io-uring@lfdr.de>; Thu,  3 Jun 2021 07:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbhFCFWD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Jun 2021 01:22:03 -0400
Received: from mail-ej1-f49.google.com ([209.85.218.49]:43698 "EHLO
        mail-ej1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbhFCFWC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Jun 2021 01:22:02 -0400
Received: by mail-ej1-f49.google.com with SMTP id ci15so7259501ejc.10;
        Wed, 02 Jun 2021 22:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pWdnqBn8XRSM/Unr4zlccrzRL0CGq6yKJ1Y9tLojFEg=;
        b=pfo3Re9VCtcjyqJpzdb4Z2B+CSIo6LiV/ZNHOIJej3ZabalaEBTUSNu0Q53a+qk8IR
         PfXselMLVXlCOYLSCp3Gcibc6vPvcrFz3nfeYlTqfPfdv3g6jFyfNzCd6K++V3J3TSUE
         +D0VhEFDhAdHOsKtxfHwZM4xo7/2Mn/i5uLjUMRvwFq/t38OdeQ/JUX6itQDVPNvnBE/
         DqW0pycKrCsHhL6FIHwf6oW6fCc6CyoiDJetfneasw1LBbmogJFoUJ+eQ1ZaR0ne0EO/
         1fi5ah9RZNByUo9iiCFTNcvDiVBidm+Wbamk01FqhizPHAYtXM5B8LznqXB3GABO0SxN
         RKOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pWdnqBn8XRSM/Unr4zlccrzRL0CGq6yKJ1Y9tLojFEg=;
        b=n9tEqDGbZlxVKn87fMW9ph8BKYi2GLmqdx1/C1ODWJHV+ULrX6akSmKFZwr3xjtIwh
         Jv0R5QawFP5iYz9G4zmLjvxzNAndJlrqSus+dp8MosKV+nc7LuW4+R8gYNs7GJbM89O9
         AqxPaeWzCUg36FINdAOtpdSYjx7Z1WBmkNJigx44PZlMqyX7c8sVZR/VXdbC9djDi87k
         xltBQ/IMgm2hfPCcKNXabGYz+itDZqO5Tc03u4WkTo7hwkEBgrTjA+oSthDhOtHgsfr7
         rW8P8O2xKy5K92hBbDxBN/mB3LRM66FURNdNJOEKhZqIE5UmEcZwppwv6fKo9DLwmczJ
         YIbA==
X-Gm-Message-State: AOAM531fCy2klRLJO09ug9HINft2Z1uCqTqqF6+zxpDgIXPf7sk2XeT6
        O7fTz3zqljCJIOtcD4BQTFw=
X-Google-Smtp-Source: ABdhPJzTcFpqI02ZcCxZ3POD6ughxsN0f8iRen9rxH9vzz7dwbUffd5avEONl8wlLr9Whm/JRFOYpw==
X-Received: by 2002:a17:906:4747:: with SMTP id j7mr28974351ejs.419.1622697545354;
        Wed, 02 Jun 2021 22:19:05 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id f7sm963668ejz.95.2021.06.02.22.19.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 22:19:05 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v5 07/10] fs: update do_*() helpers to return ints
Date:   Thu,  3 Jun 2021 12:18:33 +0700
Message-Id: <20210603051836.2614535-8-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603051836.2614535-1-dkadashev@gmail.com>
References: <20210603051836.2614535-1-dkadashev@gmail.com>
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

