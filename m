Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5445D2B3C3B
	for <lists+io-uring@lfdr.de>; Mon, 16 Nov 2020 05:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgKPEqq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 Nov 2020 23:46:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726377AbgKPEqp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 Nov 2020 23:46:45 -0500
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69FF2C0613CF;
        Sun, 15 Nov 2020 20:46:45 -0800 (PST)
Received: by mail-lf1-x143.google.com with SMTP id e139so3890870lfd.1;
        Sun, 15 Nov 2020 20:46:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nZJDQS4P54yu/pwy/CuQDdIYoQj5UDJetAoVCL7UczA=;
        b=L6O9oNvW0M/N7o3IjzZuCgrk7zwbrmZFaWw7Txb6S9difJkCohjgd1ZfnUue/ByP1T
         j8EecdYfvdZk7p170zTfNclsOU9SteWqqTYeunOTuozt7yjiVR3JBCWJjDrD4qncPIib
         By/X2Bwthh9MHTfxto8JGfTIQfV2szJog1hcQryU34Ne9eU7mDSfxtIS/Ftxh7tzZ4L7
         Ddu2ZSpEySpWEk7OPMoGJkA1E/dHRc7a4puh+hPihwIJimaJ49TeSwlk8TzPA2qVhqF1
         Nt7NfvIqGXKkWnO+kL7ndWn+bxTCTIVLW6RMq9SsQ1i25euBErNBCFslp4Kkb61rDZMS
         k/rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nZJDQS4P54yu/pwy/CuQDdIYoQj5UDJetAoVCL7UczA=;
        b=Jk1lP9d58UmLHVPFdmsZlZmezDOR/nDCRGsTO6Q6Vcf6yxHD3qBgQZcleJpAe6RXsf
         LXsxMSN5tjrRuw0TzZaO8bylhOfSJmohDRGhYtcHvECWuzqIIb5WVzZ6gl/eNUcsoYjh
         lMTvMaEg9McLWEqQKI8iDY8QZAgc45V9XIxZkhmm+BgWJ6I920E1esp+gBgojeNwT1az
         kfIAQEERs8hOktWc1T2yuywfpydAMmsisLTSuaaU0TnUFZ2EYEHjAnMGDhwLQKSXarw+
         fSGX6Twcul+KQPv0u6gPK+Vcel5QWBjH866byLev4KdDTBuzrDjD5UToW7Rl+a67Xfe7
         TPpA==
X-Gm-Message-State: AOAM532D9TRUQXE5PbBw7w/cA84BdJCa3lQbFSqSnLu3Xl8jNAXb9FaP
        C+ocZf7C6A+ULvO05Bx6m54UGglmTabwWA==
X-Google-Smtp-Source: ABdhPJxDVdLg/Bu1fJplqZB88nQH+RbWVD1eqtBCYgByAq+s9h3CzyEs4Z8YSWx4DOYqj5aoRrX+XA==
X-Received: by 2002:a19:8982:: with SMTP id l124mr5174613lfd.368.1605502003675;
        Sun, 15 Nov 2020 20:46:43 -0800 (PST)
Received: from carbon.v ([94.143.149.146])
        by smtp.googlemail.com with ESMTPSA id d7sm2572781lji.114.2020.11.15.20.46.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 20:46:43 -0800 (PST)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH 1/2] fs: make do_mkdirat() take struct filename
Date:   Mon, 16 Nov 2020 11:45:28 +0700
Message-Id: <20201116044529.1028783-2-dkadashev@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201116044529.1028783-1-dkadashev@gmail.com>
References: <20201116044529.1028783-1-dkadashev@gmail.com>
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

