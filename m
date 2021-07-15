Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2763C9D28
	for <lists+io-uring@lfdr.de>; Thu, 15 Jul 2021 12:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241663AbhGOKtA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Jul 2021 06:49:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240405AbhGOKtA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Jul 2021 06:49:00 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A54CC061762;
        Thu, 15 Jul 2021 03:46:07 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id h8so7462692eds.4;
        Thu, 15 Jul 2021 03:46:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oHTyVssJOKOMNYLoKsanZl5rYRQNpuGGGknPYRfBiFQ=;
        b=Lk1e7v1opZ6cVSQWmvBhOflQ5lr6jIulj+Y7tha9yIw27WEK8xUjosK7p9SNgDvcwP
         iTW3bYpnJqOkXTbAeR9KmlgBVmfd9cbYyiD8mgUxuULSItEP9FGZZGmTggbn5l4GtTBU
         Y/sbNbLtspkaH5OjpY6v5WYpqre/uRdjXVR/Sn7WqRLuuUdT3MsVUf0MDy7grXGWLSjc
         gZLZjWZF9gJx8146iUDZagqMpBG3Jq0oPNf00QBf1H+av9GVnYyogM1jK3oSEpWrxbUt
         47cBZ3hsuKk84zYfgG00ONml8O2xYrL1LVLi6gSzzFroQzDN/W4boskWeqlPPV9ab4Wi
         dSxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oHTyVssJOKOMNYLoKsanZl5rYRQNpuGGGknPYRfBiFQ=;
        b=Z/debBfuX66Tb0R+zxen2Ei91c1B2xQbODvggJ9pectLUwiZ7E1qbmruC+RshmscsH
         ZBDLynqH9j0AVtqLiu2JbjqUSUzuwq8atjyyrO7DydKpkfVYJs8Fhty5XihBmbBRxozS
         16W9lpXyqlSj5jZxDu11X4LP2UGIKj1jwOBWh8oCHGuEGm3KhBLYVMXoMiGh3KBxqDkc
         XSNaSZJRs5bfGg20CFfgX670Z9FfVIODJpRdyyVV8LPXYF0RXaFKTgGO0ZDkIqPbGK1i
         R7vSkIVjtmhUuQjFseazQrBaVk711USdwKOtfu0upDLh2UoQqMVl2OWuIV1AcfBit13a
         ghlg==
X-Gm-Message-State: AOAM533GL9mPboYaWFyZ4n6WL/9tr9Qq5flt1FG0qJE3t4hLB24jIVBy
        zuIYLK7Q4buFZ02MmHxzAAo=
X-Google-Smtp-Source: ABdhPJyNQhzwbKup7VT/cN+NGWBsses1SeBDISFgChKHNOLVOnFAyp4PNJvkwm7rN61rm3X5KYrGyw==
X-Received: by 2002:a05:6402:64e:: with SMTP id u14mr6051187edx.122.1626345965798;
        Thu, 15 Jul 2021 03:46:05 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id d19sm2231498eds.54.2021.07.15.03.46.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 03:46:05 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v2 12/14] namei: clean up do_linkat retry logic
Date:   Thu, 15 Jul 2021 17:45:34 +0700
Message-Id: <20210715104536.3598130-13-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210715104536.3598130-1-dkadashev@gmail.com>
References: <20210715104536.3598130-1-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

No functional changes, just move the main logic to a helper function to
make the whole thing easier to follow.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/io-uring/CAHk-=wiG+sN+2zSoAOggKCGue2kOJvw3rQySvQXsZstRQFTN+g@mail.gmail.com/
Link: https://lore.kernel.org/io-uring/CAHk-=wiE_JVny73KRZ6wuhL_5U0RRSmAw678_Cnkh3OHM8C7Jg@mail.gmail.com/
Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
---
 fs/namei.c | 37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 82cb6421b6df..b93e9623eb5d 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4381,37 +4381,32 @@ EXPORT_SYMBOL(vfs_link);
  * with linux 2.0, and to avoid hard-linking to directories
  * and other special files.  --ADM
  */
-int do_linkat(int olddfd, struct filename *old, int newdfd,
-	      struct filename *new, int flags)
+static int try_linkat(int olddfd, struct filename *old, int newdfd,
+		      struct filename *new, int flags, unsigned int how)
 {
 	struct user_namespace *mnt_userns;
 	struct dentry *new_dentry;
 	struct path old_path, new_path;
 	struct inode *delegated_inode = NULL;
-	int how = 0;
 	int error;
 
 retry:
-	if ((flags & ~(AT_SYMLINK_FOLLOW | AT_EMPTY_PATH)) != 0) {
-		error = -EINVAL;
-		goto out_putnames;
-	}
+	if ((flags & ~(AT_SYMLINK_FOLLOW | AT_EMPTY_PATH)) != 0)
+		return -EINVAL;
 	/*
 	 * To use null names we require CAP_DAC_READ_SEARCH
 	 * This ensures that not everyone will be able to create
 	 * handlink using the passed filedescriptor.
 	 */
-	if (flags & AT_EMPTY_PATH && !capable(CAP_DAC_READ_SEARCH)) {
-		error = -ENOENT;
-		goto out_putnames;
-	}
+	if (flags & AT_EMPTY_PATH && !capable(CAP_DAC_READ_SEARCH))
+		return -ENOENT;
 
 	if (flags & AT_SYMLINK_FOLLOW)
 		how |= LOOKUP_FOLLOW;
 
 	error = __filename_lookup(olddfd, old, how, &old_path, NULL);
 	if (error)
-		goto out_putnames;
+		return error;
 
 	new_dentry = __filename_create(newdfd, new, &new_path,
 					(how & LOOKUP_REVAL));
@@ -4442,14 +4437,20 @@ int do_linkat(int olddfd, struct filename *old, int newdfd,
 	}
 out_putpath:
 	path_put(&old_path);
-out_putnames:
-	if (unlikely(retry_estale(error, how))) {
-		how |= LOOKUP_REVAL;
-		goto retry;
-	}
+	return error;
+}
+
+int do_linkat(int olddfd, struct filename *old, int newdfd,
+	      struct filename *new, int flags)
+{
+	int error;
+
+	error = try_linkat(olddfd, old, newdfd, new, flags, 0);
+	if (unlikely(retry_estale(error, 0)))
+		error = try_linkat(olddfd, old, newdfd, new, flags, LOOKUP_REVAL);
+
 	putname(old);
 	putname(new);
-
 	return error;
 }
 
-- 
2.30.2

