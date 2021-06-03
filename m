Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85EB73999BB
	for <lists+io-uring@lfdr.de>; Thu,  3 Jun 2021 07:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbhFCFU7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Jun 2021 01:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbhFCFU5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Jun 2021 01:20:57 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 383D5C061756;
        Wed,  2 Jun 2021 22:18:57 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id b11so5638548edy.4;
        Wed, 02 Jun 2021 22:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Xp1EXKPrsRbSPLaqx+abK9C+016qOT2YFPeg3T/SDS4=;
        b=BXEGHFJ9x1ouzOmTIqfPRg6LnBvLgFv9rGbTzey44PbnRkXrkMDRLK/wq3E2G70NX3
         U7c6e+22lPqznLQgLMGVbmanjh2uLLusssU1NMMNSuM7QxAPFQaW/Ps2GU+BVQT12ok/
         rPstre7Q/InPsibsgwBI9nEnKNo+zQ9EUVRuYWi4v18FlzNvQgKLJE5RB/Dsvh0jkj/L
         DNcWLBSIuDIRI3feSMyvhVe3HPtr4KXh79z+AUARkKfUlZpY6g5C0dZ6H7HZDbxJmWJZ
         7H1PyPKolSgzliHcHPzMNkVx3idV13XbnrrRIhfZfjAYbX3durH5KBSOqTnBRsiwJCY4
         dMmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xp1EXKPrsRbSPLaqx+abK9C+016qOT2YFPeg3T/SDS4=;
        b=YEpNVXrSmOeA4m8iwocV73nINEfW68waISD2BkB2235BPEHEMiJyauDQ/pby/Z75AH
         30ql97H1x3eUvY1jf3V30rBgpqlyn7SjJBd+6c6h+/3+glO+8mm9thGQAfsUkAawXrdT
         V0oObSlAUAoxJ2spKFzV/EK0xsp/RMyl4InMZ3lRvlQBKvqAynxEYRde3ufTj7lzhqAA
         EsS0BUKihr/YvwQqBurAWPuqhQTcU8gUCR+5Whp0oWJeK2URVleKEWzWhMmeVQaaxKCQ
         6nMDPIT599MxKUXcFx097YwyKTujN1tBaedd9YrIpWFuTwAPBh0ksBWgmub9nkuGaCOb
         6CiA==
X-Gm-Message-State: AOAM532ckydNVlBx4wz9Ftq66eDVrW/1/jOlvoUOwLjCvceZGHd5PIsT
        bU/YIrFhaxSwBdBePwcM4tc=
X-Google-Smtp-Source: ABdhPJwzvj5mWR0vRbFhlw/2QxZx9+vKupPz1Kxi4SBwEXh2Jq6gcI6tDwJNrKMdR1vnymhPIBUtmA==
X-Received: by 2002:aa7:ce82:: with SMTP id y2mr30529857edv.264.1622697535849;
        Wed, 02 Jun 2021 22:18:55 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id f7sm963668ejz.95.2021.06.02.22.18.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 22:18:55 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v5 01/10] fs: make do_mkdirat() take struct filename
Date:   Thu,  3 Jun 2021 12:18:27 +0700
Message-Id: <20210603051836.2614535-2-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603051836.2614535-1-dkadashev@gmail.com>
References: <20210603051836.2614535-1-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Pass in the struct filename pointers instead of the user string, and
update the three callers to do the same. This is heavily based on
commit dbea8d345177 ("fs: make do_renameat2() take struct filename").

This behaves like do_unlinkat() and do_renameat2().

Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
---
 fs/internal.h |  1 +
 fs/namei.c    | 22 ++++++++++++++++------
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 6aeae7ef3380..848e165ef0f1 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -77,6 +77,7 @@ long do_unlinkat(int dfd, struct filename *name);
 int may_linkat(struct user_namespace *mnt_userns, struct path *link);
 int do_renameat2(int olddfd, struct filename *oldname, int newdfd,
 		 struct filename *newname, unsigned int flags);
+long do_mkdirat(int dfd, struct filename *name, umode_t mode);
 
 /*
  * namespace.c
diff --git a/fs/namei.c b/fs/namei.c
index 79b0ff9b151e..49317c018341 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3556,7 +3556,7 @@ struct file *do_file_open_root(struct dentry *dentry, struct vfsmount *mnt,
 	return file;
 }
 
-static struct dentry *filename_create(int dfd, struct filename *name,
+static struct dentry *__filename_create(int dfd, struct filename *name,
 				struct path *path, unsigned int lookup_flags)
 {
 	struct dentry *dentry = ERR_PTR(-EEXIST);
@@ -3612,7 +3612,6 @@ static struct dentry *filename_create(int dfd, struct filename *name,
 		error = err2;
 		goto fail;
 	}
-	putname(name);
 	return dentry;
 fail:
 	dput(dentry);
@@ -3627,6 +3626,16 @@ static struct dentry *filename_create(int dfd, struct filename *name,
 	return dentry;
 }
 
+static inline struct dentry *filename_create(int dfd, struct filename *name,
+				struct path *path, unsigned int lookup_flags)
+{
+	struct dentry *res = __filename_create(dfd, name, path, lookup_flags);
+
+	if (!IS_ERR(res))
+		putname(name);
+	return res;
+}
+
 struct dentry *kern_path_create(int dfd, const char *pathname,
 				struct path *path, unsigned int lookup_flags)
 {
@@ -3817,7 +3826,7 @@ int vfs_mkdir(struct user_namespace *mnt_userns, struct inode *dir,
 }
 EXPORT_SYMBOL(vfs_mkdir);
 
-static long do_mkdirat(int dfd, const char __user *pathname, umode_t mode)
+long do_mkdirat(int dfd, struct filename *name, umode_t mode)
 {
 	struct dentry *dentry;
 	struct path path;
@@ -3825,7 +3834,7 @@ static long do_mkdirat(int dfd, const char __user *pathname, umode_t mode)
 	unsigned int lookup_flags = LOOKUP_DIRECTORY;
 
 retry:
-	dentry = user_path_create(dfd, pathname, &path, lookup_flags);
+	dentry = __filename_create(dfd, name, &path, lookup_flags);
 	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
 
@@ -3843,17 +3852,18 @@ static long do_mkdirat(int dfd, const char __user *pathname, umode_t mode)
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
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
 
 /**
-- 
2.30.2

