Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90EA13C5C4F
	for <lists+io-uring@lfdr.de>; Mon, 12 Jul 2021 14:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233807AbhGLMkI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Jul 2021 08:40:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233767AbhGLMkG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Jul 2021 08:40:06 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61E74C0613DD;
        Mon, 12 Jul 2021 05:37:18 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id w14so16075418edc.8;
        Mon, 12 Jul 2021 05:37:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+FVArqkVRaomd+7KMO4YhQzaR3yQ+VNKusKAERQCef0=;
        b=YGItG5TtmRVQzpajXhZmOAwhrnYf3Vr2Fdopjis2HdpyiUsKrIHB7vBIOS2OUa144o
         1gGJ39cOfUazqbVhPe0U/jx6Z4Pvrpkyx5Vu1FmohgDfdnp18OmK/WNSheRMLViQCWyC
         F4uKkp+BRiETl6fWrAYspLDaiaL1mkzZ2yp+bXgM5ItnTAWuBMRXJM+EJ9h6g/xklKiu
         5gBU7dlzUzkkk6kNbBfxoj+0xt/1/mJ93V+vcNM2ILuuCmfnljaDB2dUAsn8RM6UHb0H
         PI7p9le7AxQMn7JkClBdfUMW4nzMIrDHXPs9EdKn3iVACl5IAOUj/SpZVJ4NfLXvG7Uk
         fnQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+FVArqkVRaomd+7KMO4YhQzaR3yQ+VNKusKAERQCef0=;
        b=WS82nktpfXfQh8+w9sLwmTdo5FomJrRDZgwoTtE5iJFw/eh/Wbt8v9aXHrj4pAg4rw
         ZUii3pvyb4I5gAyL6PD9XCebc8nITljV+3GSD4qThkU9Ne7+Qpl+zEa6vQ4zHIHK6VWS
         DM7DIICvIqqP7Bms+7/NdMf5yq/50fy9RUqZG8Bj89n5pa3BZTTAda9fbnm5t9MBJr5J
         XdBSJiOVTrmvFj0b8kMwh3MpwrJI64Rfsa5AjSabqX+P4WZfx51a9GUzBuFeowuBuh6c
         hXWt4o/wii0c96zLGWovWxdxv91FoscRsgoJYRve1pRVhtOlmBiRlTvRjn5SDPB5JuMw
         59zg==
X-Gm-Message-State: AOAM533zVcvgTlXXrDejZAk6k9sqaKhog+AaUKrhQ9VRUWfKvEmK31GR
        bYjeQvkwJ984pvYRQM54iYE=
X-Google-Smtp-Source: ABdhPJxwOC1w40hnLxs55jo16uJi+k58iKQqq/jdEkZOuC0ba7RI9gFI6vm/Iaw1VhEWJ5j774fnIA==
X-Received: by 2002:a05:6402:101a:: with SMTP id c26mr64981145edu.317.1626093437028;
        Mon, 12 Jul 2021 05:37:17 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id y7sm6785216edc.86.2021.07.12.05.37.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 05:37:16 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH  6/7] namei: clean up do_linkat retry logic
Date:   Mon, 12 Jul 2021 19:36:48 +0700
Message-Id: <20210712123649.1102392-7-dkadashev@gmail.com>
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
Link: https://lore.kernel.org/io-uring/CAHk-=wiG+sN+2zSoAOggKCGue2kOJvw3rQySvQXsZstRQFTN+g@mail.gmail.com/
Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
---
 fs/namei.c | 80 ++++++++++++++++++++++++++++++------------------------
 1 file changed, 44 insertions(+), 36 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index c9110ac83ccb..5e4fa8b65a8d 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4380,48 +4380,22 @@ int vfs_link(struct dentry *old_dentry, struct user_namespace *mnt_userns,
 }
 EXPORT_SYMBOL(vfs_link);
 
-/*
- * Hardlinks are often used in delicate situations.  We avoid
- * security-related surprises by not following symlinks on the
- * newname.  --KAB
- *
- * We don't follow them on the oldname either to be compatible
- * with linux 2.0, and to avoid hard-linking to directories
- * and other special files.  --ADM
- */
-int do_linkat(int olddfd, struct filename *old, int newdfd,
-	      struct filename *new, int flags)
+static int linkat_helper(int olddfd, struct filename *old, int newdfd,
+			 struct filename *new, unsigned int lookup_flags)
 {
 	struct user_namespace *mnt_userns;
 	struct dentry *new_dentry;
 	struct path old_path, new_path;
 	struct inode *delegated_inode = NULL;
-	int how = 0;
 	int error;
 
-	if ((flags & ~(AT_SYMLINK_FOLLOW | AT_EMPTY_PATH)) != 0) {
-		error = -EINVAL;
-		goto out_putnames;
-	}
-	/*
-	 * To use null names we require CAP_DAC_READ_SEARCH
-	 * This ensures that not everyone will be able to create
-	 * handlink using the passed filedescriptor.
-	 */
-	if (flags & AT_EMPTY_PATH && !capable(CAP_DAC_READ_SEARCH)) {
-		error = -ENOENT;
-		goto out_putnames;
-	}
-
-	if (flags & AT_SYMLINK_FOLLOW)
-		how |= LOOKUP_FOLLOW;
 retry:
-	error = __filename_lookup(olddfd, old, how, &old_path, NULL);
+	error = __filename_lookup(olddfd, old, lookup_flags, &old_path, NULL);
 	if (error)
-		goto out_putnames;
+		return error;
 
 	new_dentry = __filename_create(newdfd, new, &new_path,
-					(how & LOOKUP_REVAL));
+					(lookup_flags & LOOKUP_REVAL));
 	error = PTR_ERR(new_dentry);
 	if (IS_ERR(new_dentry))
 		goto out_putpath;
@@ -4447,14 +4421,48 @@ int do_linkat(int olddfd, struct filename *old, int newdfd,
 			goto retry;
 		}
 	}
+out_putpath:
+	path_put(&old_path);
+	return error;
+}
+
+/*
+ * Hardlinks are often used in delicate situations.  We avoid
+ * security-related surprises by not following symlinks on the
+ * newname.  --KAB
+ *
+ * We don't follow them on the oldname either to be compatible
+ * with linux 2.0, and to avoid hard-linking to directories
+ * and other special files.  --ADM
+ */
+int do_linkat(int olddfd, struct filename *old, int newdfd,
+	      struct filename *new, int flags)
+{
+	int error, how = 0;
+
+	if ((flags & ~(AT_SYMLINK_FOLLOW | AT_EMPTY_PATH)) != 0) {
+		error = -EINVAL;
+		goto out;
+	}
+	/*
+	 * To use null names we require CAP_DAC_READ_SEARCH
+	 * This ensures that not everyone will be able to create
+	 * handlink using the passed filedescriptor.
+	 */
+	if (flags & AT_EMPTY_PATH && !capable(CAP_DAC_READ_SEARCH)) {
+		error = -ENOENT;
+		goto out;
+	}
+
+	if (flags & AT_SYMLINK_FOLLOW)
+		how |= LOOKUP_FOLLOW;
+
+	error = linkat_helper(olddfd, old, newdfd, new, how);
 	if (retry_estale(error, how)) {
-		path_put(&old_path);
 		how |= LOOKUP_REVAL;
-		goto retry;
+		error = linkat_helper(olddfd, old, newdfd, new, how);
 	}
-out_putpath:
-	path_put(&old_path);
-out_putnames:
+out:
 	putname(old);
 	putname(new);
 
-- 
2.30.2

