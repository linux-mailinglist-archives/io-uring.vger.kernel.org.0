Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50A653C5C51
	for <lists+io-uring@lfdr.de>; Mon, 12 Jul 2021 14:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233823AbhGLMkL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Jul 2021 08:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233805AbhGLMkI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Jul 2021 08:40:08 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B629C0613DD;
        Mon, 12 Jul 2021 05:37:20 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id t3so27727748edc.7;
        Mon, 12 Jul 2021 05:37:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jmQhhtKuJTaTLxuFjmvXrR/SHun1fsX4z8wKfA2PONU=;
        b=gCEGIrIztx3JJ6l9GGE/xY58s+JMCpobqIw0HCywu93pLf4Nbe2vp6SQCecC305OSa
         M2m0Q3hwATpPxSYNSuBDNjLn0eIW6r9YNbAO5UjzikdNH+6oOlfm2f7Lv3rdJZ2vwO95
         YG2Zx9xCj7288CgZbPM/j/AvlpwkJFnUwEVHB/bq+o9scyr+yzg80JxQrw/6qAa56lcA
         Zly9zKnyMvURow7BE77JuxPBjYhXAVKLtPEB8DgjwLw3nq2y53uotDZQjLXopcTeXhx/
         sIjj9legGkdYfn+YspSOmGHPc7P8aUaUVGu3PRomdLspj0QxZxm0wJ34OWgBJgEI3HCk
         PUeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jmQhhtKuJTaTLxuFjmvXrR/SHun1fsX4z8wKfA2PONU=;
        b=AuC5Ii2N1mMyBs6R3GiyTVjFNXkw5Jo1lSCNI0ABDceIfEPNQh+/+/r7JHIDqCa1a2
         A3F9CMYssULpT8hBQi/d6ZgelXWHx27rYVikrf1Y7NjsmxDqlWMFb+H4onOHudwWbmIc
         jA/V+k14tFzfNORTbGawfI1OWINnIM5OrHRBynGoJ4gppNpLfbxZTnsL6hEtvaUtgvMZ
         xjJDT2RbwZAdh+wymvKiq3djo26uhswLLechKVoP5CiDyrjoXWk8b60WkWO47fqtHZNV
         4q20wsZFBMq0X3uz0WutGHMy0Fz1laFC5jW3zAlA6cyu8Qg+JuYHMfCswhlGeDOJLLMp
         BCsg==
X-Gm-Message-State: AOAM532lbZovD+lpGQaD+of3LAjIhzw3Wnjxr5UFUyQJJ4ej8Tg0KaMw
        gABOyTtsOGvBq3S6tLUYY/0=
X-Google-Smtp-Source: ABdhPJygXvf7a0qf9onV80YNIiU/n1qYrT+jtxfD7Kvxc1gKRpq9uMutAM0rEV3aCOlrfkblaAAqXA==
X-Received: by 2002:a05:6402:68a:: with SMTP id f10mr64287710edy.99.1626093438595;
        Mon, 12 Jul 2021 05:37:18 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id y7sm6785216edc.86.2021.07.12.05.37.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 05:37:18 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH  7/7] namei: clean up do_renameat retry logic
Date:   Mon, 12 Jul 2021 19:36:49 +0700
Message-Id: <20210712123649.1102392-8-dkadashev@gmail.com>
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
 fs/namei.c | 36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 5e4fa8b65a8d..023ee19aa5ed 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4658,8 +4658,9 @@ int vfs_rename(struct renamedata *rd)
 }
 EXPORT_SYMBOL(vfs_rename);
 
-int do_renameat2(int olddfd, struct filename *from, int newdfd,
-		 struct filename *to, unsigned int flags)
+static int renameat_helper(int olddfd, struct filename *from, int newdfd,
+			   struct filename *to, unsigned int flags,
+			   unsigned int lookup_flags)
 {
 	struct renamedata rd;
 	struct dentry *old_dentry, *new_dentry;
@@ -4668,25 +4669,23 @@ int do_renameat2(int olddfd, struct filename *from, int newdfd,
 	struct qstr old_last, new_last;
 	int old_type, new_type;
 	struct inode *delegated_inode = NULL;
-	unsigned int lookup_flags = 0, target_flags = LOOKUP_RENAME_TARGET;
-	bool should_retry = false;
+	unsigned int target_flags = LOOKUP_RENAME_TARGET;
 	int error = -EINVAL;
 
 	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE | RENAME_WHITEOUT))
-		goto put_names;
+		return error;
 
 	if ((flags & (RENAME_NOREPLACE | RENAME_WHITEOUT)) &&
 	    (flags & RENAME_EXCHANGE))
-		goto put_names;
+		return error;
 
 	if (flags & RENAME_EXCHANGE)
 		target_flags = 0;
 
-retry:
 	error = __filename_parentat(olddfd, from, lookup_flags, &old_path,
 					&old_last, &old_type);
 	if (error)
-		goto put_names;
+		return error;
 
 	error = __filename_parentat(newdfd, to, lookup_flags, &new_path, &new_last,
 				&new_type);
@@ -4784,17 +4783,22 @@ int do_renameat2(int olddfd, struct filename *from, int newdfd,
 	}
 	mnt_drop_write(old_path.mnt);
 exit2:
-	if (retry_estale(error, lookup_flags))
-		should_retry = true;
 	path_put(&new_path);
 exit1:
 	path_put(&old_path);
-	if (should_retry) {
-		should_retry = false;
-		lookup_flags |= LOOKUP_REVAL;
-		goto retry;
-	}
-put_names:
+	return error;
+}
+
+int do_renameat2(int olddfd, struct filename *from, int newdfd,
+		 struct filename *to, unsigned int flags)
+{
+	int error;
+
+	error = renameat_helper(olddfd, from, newdfd, to, flags, 0);
+	if (retry_estale(error, 0))
+		error = renameat_helper(olddfd, from, newdfd, to, flags,
+					LOOKUP_REVAL);
+
 	putname(from);
 	putname(to);
 	return error;
-- 
2.30.2

