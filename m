Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC803BF5A1
	for <lists+io-uring@lfdr.de>; Thu,  8 Jul 2021 08:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbhGHGiF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Jul 2021 02:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230412AbhGHGiD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Jul 2021 02:38:03 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 992FEC061574;
        Wed,  7 Jul 2021 23:35:20 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id t10so802217eds.2;
        Wed, 07 Jul 2021 23:35:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/ENI3vx+SPLOvrCGGRMyzNMRkwVI7tMhimck/JVEfvw=;
        b=iYgHh6Lz0AC4EZyvFw847POFlfgL5N6mMcv7Xd3apRPpGRbD7/hwHbghO0J1fpZU0q
         093ey3gKkRiaWtLHyKS/vAm2UwsukpfMlCxhuNZ9IIktSQjcTizs6lnrUkKU1WlnW1Oc
         YaUvaOjebkqmoGWmhQKpv9q1zck4N7A+ZtdT61rlWXj0T33mVHeFg0Y2UaIIQZMpzGv+
         x+xWe94NVstuGbeCSCoo9b5AoNTN2ZosIUFNIv6qyiCoOHU2MqjiNdP+CCAUt11rfrFl
         b3iN+O1cih2fGKk/m7KvH3+p4nIWLBZYvX+zl9d29lxkeJ8CkGSgk/LUHetYWBAM/u8x
         S9WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/ENI3vx+SPLOvrCGGRMyzNMRkwVI7tMhimck/JVEfvw=;
        b=OOMBahenFk7A3lASDvuxTqRB7O58s87El7jlC8tTH3nr+YGgxS5GTNRW40XkynmjfC
         jsHANbN+kn6ZoswG00g06abp5T6pRA4xBNxNxZC3Pah2g1nIjcbEoMDn2uyAA8Ncaol0
         bYb/9WgpR5/Ew/Fdw75HlBWTVoi5dXTltDS7kWXz0BWky7L+LSMhTs3elEY6UVRTqBul
         WKuqIzCATiza6E2+AcPsEe4c5zXMvJwqJMTsTRbKDP2TO0nRweR2n/PqpfgxsFF2qQ5r
         t8wawMXzJ+QbIY+8vGL4JQRgO9VxxGL3Qmn6mEj5lVwlCMXS7S6A8svzlz6UV8BH8X6C
         t7wA==
X-Gm-Message-State: AOAM530sYmR5NPSfRscnFTU+E5XGiXvS3dR4vOe2Xa8Z3wq6LbeatVRq
        /O05SqIfS5zqjjMdVAnNoOE=
X-Google-Smtp-Source: ABdhPJwZ2RMVs/WPlpBKzQ9XEogBjCGDKrzUryDzR8VRo92+Alh9C/Wr1ysO1xjR+6q9B76H2ytI6A==
X-Received: by 2002:a50:fb96:: with SMTP id e22mr28679645edq.95.1625726119306;
        Wed, 07 Jul 2021 23:35:19 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id u21sm410260eja.59.2021.07.07.23.35.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 23:35:19 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v9 07/11] namei: make do_linkat() take struct filename
Date:   Thu,  8 Jul 2021 13:34:43 +0700
Message-Id: <20210708063447.3556403-8-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210708063447.3556403-1-dkadashev@gmail.com>
References: <20210708063447.3556403-1-dkadashev@gmail.com>
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

