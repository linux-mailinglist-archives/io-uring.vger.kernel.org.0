Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5150A3C5C43
	for <lists+io-uring@lfdr.de>; Mon, 12 Jul 2021 14:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233593AbhGLMkA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Jul 2021 08:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233121AbhGLMj7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Jul 2021 08:39:59 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 767A6C0613DD;
        Mon, 12 Jul 2021 05:37:10 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id gn32so34324876ejc.2;
        Mon, 12 Jul 2021 05:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WGx4I6AHsXk5WHenLvUipyLCzSFA8DUcRBSRBnIKcQk=;
        b=nlFluJSmd4038/ylu5Spf9I37+g3CAb3Ug69cvMKTMcUrFWLdyz+ngqU/EcpGVq3Jc
         zqE5sSYSM0i3Y8bvv62LlcX2TQvR4C2/K6eH0jwgOj87XHKA+FpBURBj8L8yz/dpSnKV
         r14UtVGHHt1I1vvQZHah9aszxPfHn4emuU35WlEbee78zxDdVXzyyBUXRdHXkOnUBUcN
         aepybrNatPggAQxKSVeYcQm92KeRrJKVx3iIlFlDjAV/Kfkb1QUp+AFIzpiiIGH6qOuo
         HRiMj6sWcckSBEWzd3po6M/KgJUisSFLNkSdF01mBaeJcFWp36+zn3TVGr1AYDTuWjjs
         NpIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WGx4I6AHsXk5WHenLvUipyLCzSFA8DUcRBSRBnIKcQk=;
        b=L2YlLPNI4so13pRftKstuiL5wZle0etwHLe+VI5zp+E4stXdt8FtY4ggDrJy4U1vHh
         x1J5of5IPiDImDtQKmvEzdmofrr+yARimV5XidE1YNBmexAjZ7lej49TejFmGl5Jf0DF
         4pK0olB9Vc2hC2HbJ6bzv1jI/frGumuppap9+1XqM+qEicnqczwaSVakYQM1eF1qMDoj
         X6+cTHfxQxkmZ8jZiSdGbZgvN1CZ2tWvxprLWLw1g30JCU9SXy9bIlXkJTE9GLSqLyko
         gnlMUMt/C/ERfeLE4WFjAlKcrBoeN+e7brzGOzIFkvv1peYyUg0LlZxz/I9C77Gcvn6l
         NWkg==
X-Gm-Message-State: AOAM531PHBP+7oGcsMEr/GnvCb5E23IjgAaH4Ay/LLQzJW28CIa04f7T
        tNoxn+Dwufg6ig4H0LG7bHs=
X-Google-Smtp-Source: ABdhPJzlWCXhQq7kLKIzcW43ZXlSGUiC/jpDUqJKftv35KV9eAK6/on5QxvFPmZ+t1S2/yz/MmxZqQ==
X-Received: by 2002:a17:906:c34e:: with SMTP id ci14mr24992086ejb.199.1626093429170;
        Mon, 12 Jul 2021 05:37:09 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id y7sm6785216edc.86.2021.07.12.05.37.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 05:37:08 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH  1/7] namei: clean up do_rmdir retry logic
Date:   Mon, 12 Jul 2021 19:36:43 +0700
Message-Id: <20210712123649.1102392-2-dkadashev@gmail.com>
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
 fs/namei.c | 44 +++++++++++++++++++++++++-------------------
 1 file changed, 25 insertions(+), 19 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index b5adfd4f7de6..ae6cde7dc91e 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3947,7 +3947,8 @@ int vfs_rmdir(struct user_namespace *mnt_userns, struct inode *dir,
 }
 EXPORT_SYMBOL(vfs_rmdir);
 
-int do_rmdir(int dfd, struct filename *name)
+static int rmdir_helper(int dfd, struct filename *name,
+			unsigned int lookup_flags)
 {
 	struct user_namespace *mnt_userns;
 	int error;
@@ -3955,54 +3956,59 @@ int do_rmdir(int dfd, struct filename *name)
 	struct path path;
 	struct qstr last;
 	int type;
-	unsigned int lookup_flags = 0;
-retry:
+
 	error = __filename_parentat(dfd, name, lookup_flags, &path, &last, &type);
 	if (error)
-		goto exit1;
+		return error;
 
 	switch (type) {
 	case LAST_DOTDOT:
 		error = -ENOTEMPTY;
-		goto exit2;
+		goto exit1;
 	case LAST_DOT:
 		error = -EINVAL;
-		goto exit2;
+		goto exit1;
 	case LAST_ROOT:
 		error = -EBUSY;
-		goto exit2;
+		goto exit1;
 	}
 
 	error = mnt_want_write(path.mnt);
 	if (error)
-		goto exit2;
+		goto exit1;
 
 	inode_lock_nested(path.dentry->d_inode, I_MUTEX_PARENT);
 	dentry = __lookup_hash(&last, path.dentry, lookup_flags);
 	error = PTR_ERR(dentry);
 	if (IS_ERR(dentry))
-		goto exit3;
+		goto exit2;
 	if (!dentry->d_inode) {
 		error = -ENOENT;
-		goto exit4;
+		goto exit3;
 	}
 	error = security_path_rmdir(&path, dentry);
 	if (error)
-		goto exit4;
+		goto exit3;
 	mnt_userns = mnt_user_ns(path.mnt);
 	error = vfs_rmdir(mnt_userns, path.dentry->d_inode, dentry);
-exit4:
-	dput(dentry);
 exit3:
+	dput(dentry);
+exit2:
 	inode_unlock(path.dentry->d_inode);
 	mnt_drop_write(path.mnt);
-exit2:
-	path_put(&path);
-	if (retry_estale(error, lookup_flags)) {
-		lookup_flags |= LOOKUP_REVAL;
-		goto retry;
-	}
 exit1:
+	path_put(&path);
+	return error;
+}
+
+int do_rmdir(int dfd, struct filename *name)
+{
+	int error;
+
+	error = rmdir_helper(dfd, name, 0);
+	if (retry_estale(error, 0))
+		error = rmdir_helper(dfd, name, LOOKUP_REVAL);
+
 	putname(name);
 	return error;
 }
-- 
2.30.2

