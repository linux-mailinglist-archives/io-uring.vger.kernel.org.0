Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 691C93BD71D
	for <lists+io-uring@lfdr.de>; Tue,  6 Jul 2021 14:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233385AbhGFMwa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Jul 2021 08:52:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241542AbhGFMwI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Jul 2021 08:52:08 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0FA4C0613DC;
        Tue,  6 Jul 2021 05:49:27 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id s18so7172871ljg.7;
        Tue, 06 Jul 2021 05:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A3R2pVP2sKQYuRMhVaQbdCO9y7ULwCGT8uQ0UDTT414=;
        b=p6FloF2pJGN0SMloBnyXy1dnp9Of0CbXi0qBHXcWFBdidOTaxneAaMxisRrQkkttQQ
         jqBCLoDSjF9SQW8S0qPDkDzIdIlVwo5k6i7wWeMFzpCrA1WDNKo8h0tvyQ741ifDKwcG
         dbd19QXsFs4qnhEwHbaBlxmu3ltEQKQGtdxrRhmLOAVWBJd/P3hMY/yxj8H3WVX79BQE
         V8ylKU7swTfOwAN19tqLEa1dc8c+FuPWLG7NAu5W/dCnml/pSeCKFL3UlEarVVLIC/Eo
         88zBQZuShiU/ZldfIMc99Bl6QddlMn2d0xoLAkSZFPI+PheJJqf1vqz5ssqqH59ajaWE
         ue/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A3R2pVP2sKQYuRMhVaQbdCO9y7ULwCGT8uQ0UDTT414=;
        b=Ph2V8jR1CggtmcGgIzW9qh4//pcpGdsy4J6/NvdyDj0S4wriFwU2dxNJMxaTtxD5OG
         gQZjjFKCa/MAZY4gw24EgOhO6H7IqspmND4cfFqsjO1CDFxkvxxQWTqJzTPAltSpBKr2
         62/pEIt15kn8jXaFcAHFIiof7Km84sjTgLg8ZSRr3vooIjkHhUwYywSVuA/JFPvL6MiZ
         N8verzyw94hB/OHR/mXOuAnNXUxBdN8CF3+NLMbwOLNSOT0oNKmiP7QerAYH1lc0x6Gh
         zjdS/afj+KIDocnHOz30K/CMyw7asEN85rE9J2EQdxxl2iYtoJkgjrkgOVVEndbHu17p
         cVyQ==
X-Gm-Message-State: AOAM532X1XU+NQjYM+aqxJK7SzEiURGS4tZiEU0Mq4S402hvDjQYmODN
        +t8eOl7X4jGfoYn388peKxw=
X-Google-Smtp-Source: ABdhPJxocVVf3x4e1yBMfjSkmBP4JmezSgnu8VIiZVmE5LEL3tUFeo4qkao4NxDl5lMZslElppcu6g==
X-Received: by 2002:a2e:9759:: with SMTP id f25mr7490855ljj.15.1625575766068;
        Tue, 06 Jul 2021 05:49:26 -0700 (PDT)
Received: from carbon.v ([94.143.149.146])
        by smtp.googlemail.com with ESMTPSA id r18sm139519ljc.120.2021.07.06.05.49.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jul 2021 05:49:25 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v7 05/10] fs: make do_symlinkat() take struct filename
Date:   Tue,  6 Jul 2021 19:48:56 +0700
Message-Id: <20210706124901.1360377-6-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706124901.1360377-1-dkadashev@gmail.com>
References: <20210706124901.1360377-1-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Pass in the struct filename pointers instead of the user string, for
uniformity with the recently converted do_mkdnodat(), do_unlinkat(),
do_renameat(), do_mkdirat().

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Link: https://lore.kernel.org/io-uring/20210330071700.kpjoyp5zlni7uejm@wittgenstein/
Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/namei.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 34b8968dec92..57170d57e84d 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4191,23 +4191,23 @@ int vfs_symlink(struct user_namespace *mnt_userns, struct inode *dir,
 }
 EXPORT_SYMBOL(vfs_symlink);
 
-static long do_symlinkat(const char __user *oldname, int newdfd,
-		  const char __user *newname)
+static long do_symlinkat(struct filename *from, int newdfd,
+		  struct filename *to)
 {
 	int error;
-	struct filename *from;
 	struct dentry *dentry;
 	struct path path;
 	unsigned int lookup_flags = 0;
 
-	from = getname(oldname);
-	if (IS_ERR(from))
-		return PTR_ERR(from);
+	if (IS_ERR(from)) {
+		error = PTR_ERR(from);
+		goto out_putboth;
+	}
 retry:
-	dentry = user_path_create(newdfd, newname, &path, lookup_flags);
+	dentry = __filename_create(newdfd, to, &path, lookup_flags);
 	error = PTR_ERR(dentry);
 	if (IS_ERR(dentry))
-		goto out_putname;
+		goto out_putfrom;
 
 	error = security_path_symlink(&path, dentry, from->name);
 	if (!error) {
@@ -4222,7 +4222,9 @@ static long do_symlinkat(const char __user *oldname, int newdfd,
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
-out_putname:
+out_putboth:
+	putname(to);
+out_putfrom:
 	putname(from);
 	return error;
 }
@@ -4230,12 +4232,12 @@ static long do_symlinkat(const char __user *oldname, int newdfd,
 SYSCALL_DEFINE3(symlinkat, const char __user *, oldname,
 		int, newdfd, const char __user *, newname)
 {
-	return do_symlinkat(oldname, newdfd, newname);
+	return do_symlinkat(getname(oldname), newdfd, getname(newname));
 }
 
 SYSCALL_DEFINE2(symlink, const char __user *, oldname, const char __user *, newname)
 {
-	return do_symlinkat(oldname, AT_FDCWD, newname);
+	return do_symlinkat(getname(oldname), AT_FDCWD, getname(newname));
 }
 
 /**
-- 
2.30.2

