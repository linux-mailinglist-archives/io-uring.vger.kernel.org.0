Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74C173BE7E6
	for <lists+io-uring@lfdr.de>; Wed,  7 Jul 2021 14:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231675AbhGGMay (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Jul 2021 08:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231593AbhGGMax (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Jul 2021 08:30:53 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DBEDC061762;
        Wed,  7 Jul 2021 05:28:13 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id o5so2983182ejy.7;
        Wed, 07 Jul 2021 05:28:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/ENI3vx+SPLOvrCGGRMyzNMRkwVI7tMhimck/JVEfvw=;
        b=BkPfnDL71/+Q0LVkN7HlOiTBrdnaGq1c5/jAv4KCzRDb68WVqkQByrxZgQHa7VkbiH
         lmkHnxfYu1CZfD8D5YQ8WVZJA+dubKGLC8YboIDQ+PrR8OKigtXzREAVnihVBBjKpGp1
         jPeqk/phjgQ1QxYZxo+qhzlQ1ECddTbZSxdXVPA9Greyxn97SuDdGw1cQBOe4RwAlK4I
         FJ7bGdzfQywkVak15SdkYAtxzVTWMMQp9uiWurdrDPtqMLBijn3P9xZb8aGYNCQzTEH0
         pevHkHq0qVshLRWGtSP0iKXHZYQXbB6zu5167k+D51zDQE6WpzYB+CaBu9oEV0lOtG1M
         9BeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/ENI3vx+SPLOvrCGGRMyzNMRkwVI7tMhimck/JVEfvw=;
        b=nE54nme1N45d7731boZyEFqnhtLO+3T2mWtXBzO1Ng8qafsOck6tIH3L9Z5Dxf7PGd
         wqDWJobbMmsjYzY9CGtQtAAx929i1LEXd64hsV1zlviGtEdMuPrI57XvvfuXgACjNxRd
         zEbo6SThebYgLy/UbJ3Fxtg6lUxvHT0g73orcZUsRa0iGXF2EWDPNCsDJ14AWLOKn3o8
         AbfxZMtvVUyzCag/7irYnXYMb+jEIAhfMiIiDyqbO8i1X4I8pRYNMx7uxc6j/+dllyTh
         3se5x1xmcQlJgD4WzdJB73GQheXb2H0E4WQ2zMRLXwkBtBec89Cm9wwoNOTy5UDR30oQ
         tgqQ==
X-Gm-Message-State: AOAM5326qUMGD+IUTo/PtFigv90VPPhlq3A/KkcyVHkkFq2qRWsCGtxt
        RErousrH6YGeL4pQOisOHfQ=
X-Google-Smtp-Source: ABdhPJzFsZAQwjchGo0YWRuTPdUDRWRW7qSdqORoTtV1oCE1PpVy2mYiaYV05x2CbvSTD0rGZnJ3zQ==
X-Received: by 2002:a17:907:9622:: with SMTP id gb34mr23885097ejc.401.1625660891729;
        Wed, 07 Jul 2021 05:28:11 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id ze15sm7019821ejb.79.2021.07.07.05.28.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 05:28:11 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v8 08/11] fs: make do_linkat() take struct filename
Date:   Wed,  7 Jul 2021 19:27:44 +0700
Message-Id: <20210707122747.3292388-9-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210707122747.3292388-1-dkadashev@gmail.com>
References: <20210707122747.3292388-1-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Pass in the struct filename pointers instead of the user string, for
uniformity with do_renameat2, do_unlinkat, do_mknodat, etc.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Link: https://lore.kernel.org/io-uring/20210330071700.kpjoyp5zlni7uejm@wittgenstein/
Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/namei.c | 45 +++++++++++++++++++++++++++++----------------
 1 file changed, 29 insertions(+), 16 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index ab7979f9daaa..c4e13bd8652f 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2450,7 +2450,7 @@ static int path_lookupat(struct nameidata *nd, unsigned flags, struct path *path
 	return err;
 }
 
-int filename_lookup(int dfd, struct filename *name, unsigned flags,
+static int __filename_lookup(int dfd, struct filename *name, unsigned flags,
 		    struct path *path, struct path *root)
 {
 	int retval;
@@ -2472,6 +2472,14 @@ int filename_lookup(int dfd, struct filename *name, unsigned flags,
 		audit_inode(name, path->dentry,
 			    flags & LOOKUP_MOUNTPOINT ? AUDIT_INODE_NOEVAL : 0);
 	restore_nameidata();
+	return retval;
+}
+
+int filename_lookup(int dfd, struct filename *name, unsigned flags,
+		    struct path *path, struct path *root)
+{
+	int retval = __filename_lookup(dfd, name, flags, path, root);
+
 	putname(name);
 	return retval;
 }
@@ -4351,8 +4359,8 @@ EXPORT_SYMBOL(vfs_link);
  * with linux 2.0, and to avoid hard-linking to directories
  * and other special files.  --ADM
  */
-static int do_linkat(int olddfd, const char __user *oldname, int newdfd,
-	      const char __user *newname, int flags)
+static int do_linkat(int olddfd, struct filename *old, int newdfd,
+	      struct filename *new, int flags)
 {
 	struct user_namespace *mnt_userns;
 	struct dentry *new_dentry;
@@ -4361,31 +4369,32 @@ static int do_linkat(int olddfd, const char __user *oldname, int newdfd,
 	int how = 0;
 	int error;
 
-	if ((flags & ~(AT_SYMLINK_FOLLOW | AT_EMPTY_PATH)) != 0)
-		return -EINVAL;
+	if ((flags & ~(AT_SYMLINK_FOLLOW | AT_EMPTY_PATH)) != 0) {
+		error = -EINVAL;
+		goto out_putnames;
+	}
 	/*
 	 * To use null names we require CAP_DAC_READ_SEARCH
 	 * This ensures that not everyone will be able to create
 	 * handlink using the passed filedescriptor.
 	 */
-	if (flags & AT_EMPTY_PATH) {
-		if (!capable(CAP_DAC_READ_SEARCH))
-			return -ENOENT;
-		how = LOOKUP_EMPTY;
+	if (flags & AT_EMPTY_PATH && !capable(CAP_DAC_READ_SEARCH)) {
+		error = -ENOENT;
+		goto out_putnames;
 	}
 
 	if (flags & AT_SYMLINK_FOLLOW)
 		how |= LOOKUP_FOLLOW;
 retry:
-	error = user_path_at(olddfd, oldname, how, &old_path);
+	error = __filename_lookup(olddfd, old, how, &old_path, NULL);
 	if (error)
-		return error;
+		goto out_putnames;
 
-	new_dentry = user_path_create(newdfd, newname, &new_path,
+	new_dentry = __filename_create(newdfd, new, &new_path,
 					(how & LOOKUP_REVAL));
 	error = PTR_ERR(new_dentry);
 	if (IS_ERR(new_dentry))
-		goto out;
+		goto out_putpath;
 
 	error = -EXDEV;
 	if (old_path.mnt != new_path.mnt)
@@ -4413,8 +4422,11 @@ static int do_linkat(int olddfd, const char __user *oldname, int newdfd,
 		how |= LOOKUP_REVAL;
 		goto retry;
 	}
-out:
+out_putpath:
 	path_put(&old_path);
+out_putnames:
+	putname(old);
+	putname(new);
 
 	return error;
 }
@@ -4422,12 +4434,13 @@ static int do_linkat(int olddfd, const char __user *oldname, int newdfd,
 SYSCALL_DEFINE5(linkat, int, olddfd, const char __user *, oldname,
 		int, newdfd, const char __user *, newname, int, flags)
 {
-	return do_linkat(olddfd, oldname, newdfd, newname, flags);
+	return do_linkat(olddfd, getname_uflags(oldname, flags),
+		newdfd, getname(newname), flags);
 }
 
 SYSCALL_DEFINE2(link, const char __user *, oldname, const char __user *, newname)
 {
-	return do_linkat(AT_FDCWD, oldname, AT_FDCWD, newname, 0);
+	return do_linkat(AT_FDCWD, getname(oldname), AT_FDCWD, getname(newname), 0);
 }
 
 /**
-- 
2.30.2

