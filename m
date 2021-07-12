Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12B553C5C45
	for <lists+io-uring@lfdr.de>; Mon, 12 Jul 2021 14:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233620AbhGLMkB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Jul 2021 08:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233121AbhGLMkB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Jul 2021 08:40:01 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20D4BC0613DD;
        Mon, 12 Jul 2021 05:37:12 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id l1so5972260edr.11;
        Mon, 12 Jul 2021 05:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=POUCrEBD/TS9KiXC0fMr2MMYnoW6MCo3pMbLe1dBMpc=;
        b=qjqbr5ZiHswustla15nUrvIQrCskMlPDP8iGD9fRCZsyuo6URIpLOG3q6onEf3XesA
         BiYJQ+zCrkl+xn41JQJSaUpqgX7hbz64wDvhw2xLO6sBda5iBgkBMc7qxcyRPirDM0J6
         LozmeIqJlew02uK8OaWHGMSPYsGuZPcTxYPd36gnkP3JmzXnvhkTsvgeAnMitpYX4bCg
         cH1O/3fp250Jc5+CpCPDkWVgZFqDTt+td4dQsu/qRHVNq4naoJV2HsBLzdBXFYuowjLx
         ohycCOYpw5iQmScUfRCQer34cwaDAzUqD6JSA76NJjcrOTHNhzvSfYD5DKc+ttmN8k/a
         BXZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=POUCrEBD/TS9KiXC0fMr2MMYnoW6MCo3pMbLe1dBMpc=;
        b=DcshNvYiP/OJ4P8JJB3FXQ3HEUZ6roPoOafy3PIE8W9vImyD08tp59giQE2nHQEfUj
         o/U850O9XrZ1naACU0viwQkrOA3qoITujzGlo5dVT2I/qRpSvmsio5nSU0DeAgbEOoHs
         XSMz4DSu7/cC9spGAcGCxQx4esW00D+HQmrkwviDjbFNJc4X/GL8BBS7V+iLqyoN6lSK
         U5H+by2fuu0JoCEcXM3+2+WrCclRnjCtS5MbYP9+qvDTn0JgBb3I7CIaQ64/OoU2dRPJ
         I69BGiakfr86mii7pMRc0diMYWTT1unW/Dywp23lv2z59pN8LAhrXQ0BRNWkx/1btmHb
         +hVg==
X-Gm-Message-State: AOAM531OUpmIw1SKSmA5VKNq4wjQ2oMKEKqdCDIlZUqAuI3jVOaytIl4
        y5H83jFjGm2Mh50MoEzGi90=
X-Google-Smtp-Source: ABdhPJymm0K3Yv0iCLeA+Tcu4gayWochFrAXdf42pJ48RSle2TVYD9iKCbWDoDRI2oaxreVKHtZ0ng==
X-Received: by 2002:a05:6402:35d4:: with SMTP id z20mr67195786edc.138.1626093430761;
        Mon, 12 Jul 2021 05:37:10 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id y7sm6785216edc.86.2021.07.12.05.37.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 05:37:10 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH  2/7] namei: clean up do_unlinkat retry logic
Date:   Mon, 12 Jul 2021 19:36:44 +0700
Message-Id: <20210712123649.1102392-3-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210712123649.1102392-1-dkadashev@gmail.com>
References: <20210712123649.1102392-1-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Moving the main logic to a helper function makes the whole thing much
easier to follow.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/io-uring/CAHk-=wh=cpt_tQCirzFZRPawRpbuFTZ2MxNpXiyUF+eBXF=+sw@mail.gmail.com/
Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
---
 fs/namei.c | 39 ++++++++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 17 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index ae6cde7dc91e..bb18b1adfea5 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4091,7 +4091,8 @@ EXPORT_SYMBOL(vfs_unlink);
  * writeout happening, and we don't want to prevent access to the directory
  * while waiting on the I/O.
  */
-int do_unlinkat(int dfd, struct filename *name)
+static int unlinkat_helper(int dfd, struct filename *name,
+			   unsigned int lookup_flags)
 {
 	int error;
 	struct dentry *dentry;
@@ -4100,19 +4101,18 @@ int do_unlinkat(int dfd, struct filename *name)
 	int type;
 	struct inode *inode = NULL;
 	struct inode *delegated_inode = NULL;
-	unsigned int lookup_flags = 0;
-retry:
+
 	error = __filename_parentat(dfd, name, lookup_flags, &path, &last, &type);
 	if (error)
-		goto exit1;
+		return error;
 
 	error = -EISDIR;
 	if (type != LAST_NORM)
-		goto exit2;
+		goto exit1;
 
 	error = mnt_want_write(path.mnt);
 	if (error)
-		goto exit2;
+		goto exit1;
 retry_deleg:
 	inode_lock_nested(path.dentry->d_inode, I_MUTEX_PARENT);
 	dentry = __lookup_hash(&last, path.dentry, lookup_flags);
@@ -4129,11 +4129,11 @@ int do_unlinkat(int dfd, struct filename *name)
 		ihold(inode);
 		error = security_path_unlink(&path, dentry);
 		if (error)
-			goto exit3;
+			goto exit2;
 		mnt_userns = mnt_user_ns(path.mnt);
 		error = vfs_unlink(mnt_userns, path.dentry->d_inode, dentry,
 				   &delegated_inode);
-exit3:
+exit2:
 		dput(dentry);
 	}
 	inode_unlock(path.dentry->d_inode);
@@ -4146,15 +4146,8 @@ int do_unlinkat(int dfd, struct filename *name)
 			goto retry_deleg;
 	}
 	mnt_drop_write(path.mnt);
-exit2:
-	path_put(&path);
-	if (retry_estale(error, lookup_flags)) {
-		lookup_flags |= LOOKUP_REVAL;
-		inode = NULL;
-		goto retry;
-	}
 exit1:
-	putname(name);
+	path_put(&path);
 	return error;
 
 slashes:
@@ -4164,7 +4157,19 @@ int do_unlinkat(int dfd, struct filename *name)
 		error = -EISDIR;
 	else
 		error = -ENOTDIR;
-	goto exit3;
+	goto exit2;
+}
+
+int do_unlinkat(int dfd, struct filename *name)
+{
+	int error;
+
+	error = unlinkat_helper(dfd, name, 0);
+	if (retry_estale(error, 0))
+		error = unlinkat_helper(dfd, name, LOOKUP_REVAL);
+
+	putname(name);
+	return error;
 }
 
 SYSCALL_DEFINE3(unlinkat, int, dfd, const char __user *, pathname, int, flag)
-- 
2.30.2

