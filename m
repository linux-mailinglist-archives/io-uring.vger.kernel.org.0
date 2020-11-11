Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 266342AF211
	for <lists+io-uring@lfdr.de>; Wed, 11 Nov 2020 14:26:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726273AbgKKN0G (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Nov 2020 08:26:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgKKN0G (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Nov 2020 08:26:06 -0500
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BABC4C0613D1
        for <io-uring@vger.kernel.org>; Wed, 11 Nov 2020 05:26:05 -0800 (PST)
Received: by mail-lf1-x141.google.com with SMTP id d17so3090958lfq.10
        for <io-uring@vger.kernel.org>; Wed, 11 Nov 2020 05:26:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nZJDQS4P54yu/pwy/CuQDdIYoQj5UDJetAoVCL7UczA=;
        b=jQey25Z7coLi0g18Uwl18YU1Lt0WAgmCD2EuLs8S1yARyZVJVWxc0qgHufcOoOkuTJ
         SpmN9rcMwxd0rFuLTBgnqHGzROpSfDSFRf3ifWk4QxGOSAXxAdPx3ljxMOnNlEANv7oU
         HDVfubKKseyp/7tTtBq0PriAXaEARDL9S9nC5UjmLRsQkDeE/Rjj+YcSfsNlji+Cud0T
         KliErEGqpe51LfoAqFbjczJTyPkeDNYIb5nYtNt/mQWNTiUUiGVyYK0DVFfAtT0/eNL3
         Q1xGUHSvDeH4yCZbxEuy6x6OTCnV1js6QyEbSwvxHLz6hjFOgx6ApQKL7oXatnSDEAc/
         whgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nZJDQS4P54yu/pwy/CuQDdIYoQj5UDJetAoVCL7UczA=;
        b=gHZJtj5K7nvMEvSxa/9AfqU+NcdXeydvueH2cKDjHNHQnH74Iqva4rN7nN8IumldoX
         Ddu8oXDnsy5RB4g9bEvlBk3sWEXSP29Oy6GX0kgSwwSBxmCxI3kBBGgkbbtvbuqyOfou
         uBoE2PIH3fpAnEepAAfgcwyXt/bgk9KzbNQoZByAZ+/iLXZC25UwVt2ID+d6bVAykxE/
         y9rZbgjNy5ZvEypfT1vNEyNAUuKoJfSU7pskLYxwGZHW4qp9L1mqnWkLQKaQZ1GI2l4d
         Mc0+N1cTlemzCn+1TDs7vdWIjCPXmV22yjVqUlyO222mKYqWHcwBsh/thLpp1ecnov75
         2IkA==
X-Gm-Message-State: AOAM531lkMQeQyr5dW8vsyCIwIn073nBsAZxTsBNgzyJpKF6Oz4B3+tJ
        kpvanAy0iT9VwcaHl6bu6HZS0Q9QGFTn3A==
X-Google-Smtp-Source: ABdhPJwO7xnsJXF199RWhegBzP7oAPQseQDXX6ofkQdAWProtSoQNCCrb9QIw6Xk2qfWUHl5i2XoJw==
X-Received: by 2002:ac2:4545:: with SMTP id j5mr8948759lfm.267.1605101163899;
        Wed, 11 Nov 2020 05:26:03 -0800 (PST)
Received: from carbon.v ([94.143.149.146])
        by smtp.googlemail.com with ESMTPSA id m22sm222738lfl.14.2020.11.11.05.26.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 05:26:02 -0800 (PST)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH 1/2] fs: make do_mkdirat() take struct filename
Date:   Wed, 11 Nov 2020 20:25:50 +0700
Message-Id: <20201111132551.3536296-2-dkadashev@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201111132551.3536296-1-dkadashev@gmail.com>
References: <20201111132551.3536296-1-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Pass in the struct filename pointers instead of the user string, and
update the three callers to do the same. This is heavily based on
commit dbea8d345177 ("fs: make do_renameat2() take struct filename").

This behaves like do_unlinkat() and do_renameat2().

Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
---
 fs/internal.h |  1 +
 fs/namei.c    | 20 ++++++++++++++------
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 6fd14ea213c3..23b8b427dbd2 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -80,6 +80,7 @@ long do_unlinkat(int dfd, struct filename *name);
 int may_linkat(struct path *link);
 int do_renameat2(int olddfd, struct filename *oldname, int newdfd,
 		 struct filename *newname, unsigned int flags);
+long do_mkdirat(int dfd, struct filename *name, umode_t mode);
 
 /*
  * namespace.c
diff --git a/fs/namei.c b/fs/namei.c
index 03d0e11e4f36..9d26a51f3f54 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3654,17 +3654,23 @@ int vfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 }
 EXPORT_SYMBOL(vfs_mkdir);
 
-static long do_mkdirat(int dfd, const char __user *pathname, umode_t mode)
+long do_mkdirat(int dfd, struct filename *name, umode_t mode)
 {
 	struct dentry *dentry;
 	struct path path;
 	int error;
 	unsigned int lookup_flags = LOOKUP_DIRECTORY;
 
+	if (IS_ERR(name))
+		return PTR_ERR(name);
+
 retry:
-	dentry = user_path_create(dfd, pathname, &path, lookup_flags);
-	if (IS_ERR(dentry))
-		return PTR_ERR(dentry);
+	name->refcnt++; /* filename_create() drops our ref */
+	dentry = filename_create(dfd, name, &path, lookup_flags);
+	if (IS_ERR(dentry)) {
+		error = PTR_ERR(dentry);
+		goto out;
+	}
 
 	if (!IS_POSIXACL(path.dentry->d_inode))
 		mode &= ~current_umask();
@@ -3676,17 +3682,19 @@ static long do_mkdirat(int dfd, const char __user *pathname, umode_t mode)
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
+out:
+	putname(name);
 	return error;
 }
 
 SYSCALL_DEFINE3(mkdirat, int, dfd, const char __user *, pathname, umode_t, mode)
 {
-	return do_mkdirat(dfd, pathname, mode);
+	return do_mkdirat(dfd, getname(pathname), mode);
 }
 
 SYSCALL_DEFINE2(mkdir, const char __user *, pathname, umode_t, mode)
 {
-	return do_mkdirat(AT_FDCWD, pathname, mode);
+	return do_mkdirat(AT_FDCWD, getname(pathname), mode);
 }
 
 int vfs_rmdir(struct inode *dir, struct dentry *dentry)
-- 
2.28.0

