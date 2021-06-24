Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2263B2D86
	for <lists+io-uring@lfdr.de>; Thu, 24 Jun 2021 13:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232421AbhFXLRg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Jun 2021 07:17:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232338AbhFXLRd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Jun 2021 07:17:33 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C3BC061756;
        Thu, 24 Jun 2021 04:15:14 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id f13so7208440ljp.10;
        Thu, 24 Jun 2021 04:15:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cjY5NIv8T/UjPF6/khgDh63aie+4OSg4ezXbryOnIVo=;
        b=iPq9xrKb0sRL7Yr9n1OmNxiPLN2GfT6ZyRhYwm7ARhlN0/DRkMHt2sFM7RGXlgBmCV
         IMFjahnn5wtgJUJI47fapqOkiwwIjs4A9WEJ6fG6zbw0TWz6faa7a7bonY5Hvlsv5GR/
         h0QzJ85j9RBHBPEY/bKHGnMq4gL+WdMZa0qY4g5eRaVCH60XEJCCUF0vp5AmMt+HpTm7
         8mFcQbensaJuqiymZ32luFOi7inXI6IW23lUhUPqFgTabKGovtPwlyaiy7W3fGQrGtXM
         LmKtKpxjgM+dLRRuKjBDkqrFbnfxDYWxv9GeF5YyesWUq+4B8xHMJoYJNK+wEMpdvr2N
         2/Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cjY5NIv8T/UjPF6/khgDh63aie+4OSg4ezXbryOnIVo=;
        b=KhMOIi2uA3U6a5QQbi0CWWw8WchlRwQKGijqhbpzzKtjJpYG1puh+wHsZCQmqIY8x+
         Zz60CUzDvDDK4wDkN5xHFJLdAW9cVt9USSxdBxkfjgHVGXYHGWpuYET8+Rh4iqq3XWAi
         2YDgoYLHIZowBXCIFdQ2JgHQWpxd3pGElZOmT8mCwdkNv9FHiv6sTL6lwEtkMJOduLHR
         NOsE+lMa94bnLpGlL3U91vv977Glg5vlTeSvbXXmlUbWR1A2D+nJ/fIqEvlLddMxt8Nm
         Rm2ZqylYnBOhV+aBzkLTDUghzUEkO53hPDNp3uTULkLmew2QfGZainaNfaox+AJUOmRh
         30Cw==
X-Gm-Message-State: AOAM530UrvsmsoCVuBDUvaovMFZQowc1ZBuK6QghZlBP4REOGMwkHSc2
        6VDrN3BhCWVV7OQ1MwUrCiU=
X-Google-Smtp-Source: ABdhPJxku+acLC+qRFUlPCKbuqqKavPd77Hh1oluLVaX7b7XEZQu2t7SgzsHbaqTBdNQSbvIdp+1vA==
X-Received: by 2002:a2e:8941:: with SMTP id b1mr3566449ljk.284.1624533312471;
        Thu, 24 Jun 2021 04:15:12 -0700 (PDT)
Received: from carbon.v ([94.143.149.146])
        by smtp.googlemail.com with ESMTPSA id q21sm195293lfp.233.2021.06.24.04.15.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 04:15:11 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v6 5/9] namei: add getname_uflags()
Date:   Thu, 24 Jun 2021 18:14:48 +0700
Message-Id: <20210624111452.658342-6-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210624111452.658342-1-dkadashev@gmail.com>
References: <20210624111452.658342-1-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There are a couple of places where we already open-code the (flags &
AT_EMPTY_PATH) check and io_uring will likely add another one in the
future.  Let's just add a simple helper getname_uflags() that handles
this directly and use it.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Link: https://lore.kernel.org/io-uring/20210415100815.edrn4a7cy26wkowe@wittgenstein/
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/exec.c          | 8 ++------
 fs/namei.c         | 8 ++++++++
 include/linux/fs.h | 1 +
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 18594f11c31f..df33ecaf2111 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -2069,10 +2069,8 @@ SYSCALL_DEFINE5(execveat,
 		const char __user *const __user *, envp,
 		int, flags)
 {
-	int lookup_flags = (flags & AT_EMPTY_PATH) ? LOOKUP_EMPTY : 0;
-
 	return do_execveat(fd,
-			   getname_flags(filename, lookup_flags, NULL),
+			   getname_uflags(filename, flags),
 			   argv, envp, flags);
 }
 
@@ -2090,10 +2088,8 @@ COMPAT_SYSCALL_DEFINE5(execveat, int, fd,
 		       const compat_uptr_t __user *, envp,
 		       int,  flags)
 {
-	int lookup_flags = (flags & AT_EMPTY_PATH) ? LOOKUP_EMPTY : 0;
-
 	return compat_do_execveat(fd,
-				  getname_flags(filename, lookup_flags, NULL),
+				  getname_uflags(filename, flags),
 				  argv, envp, flags);
 }
 #endif
diff --git a/fs/namei.c b/fs/namei.c
index 76572d703e82..010455938826 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -203,6 +203,14 @@ getname_flags(const char __user *filename, int flags, int *empty)
 	return result;
 }
 
+struct filename *
+getname_uflags(const char __user *filename, int uflags)
+{
+	int flags = (uflags & AT_EMPTY_PATH) ? LOOKUP_EMPTY : 0;
+
+	return getname_flags(filename, flags, NULL);
+}
+
 struct filename *
 getname(const char __user * filename)
 {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c3c88fdb9b2a..5885a68d2c12 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2781,6 +2781,7 @@ static inline struct file *file_clone_open(struct file *file)
 extern int filp_close(struct file *, fl_owner_t id);
 
 extern struct filename *getname_flags(const char __user *, int, int *);
+extern struct filename *getname_uflags(const char __user *, int);
 extern struct filename *getname(const char __user *);
 extern struct filename *getname_kernel(const char *);
 extern void putname(struct filename *name);
-- 
2.30.2

