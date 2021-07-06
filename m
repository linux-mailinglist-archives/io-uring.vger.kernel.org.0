Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB2FD3BD71F
	for <lists+io-uring@lfdr.de>; Tue,  6 Jul 2021 14:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232810AbhGFMwb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Jul 2021 08:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241547AbhGFMwI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Jul 2021 08:52:08 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1755C0613DD;
        Tue,  6 Jul 2021 05:49:28 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id v14so12545826lfb.4;
        Tue, 06 Jul 2021 05:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WkJGb3hmdHjOYQaewm0wQtiLEaHfags/GYZjg3z/bDI=;
        b=EyOdTcjQ+QBwPYgeuX4oERwhVfM1TIKGrAJRzaApFVmMX/2sETmVVCRjLivCir1561
         VfNqZBqRYAwRaOT16RD8zJue5I9wq3fN/+Hhz61/y2JkKSMBW0uFEUCl8UkhcfmK0qYw
         GWBoZj8SlL2uOCU5JjnHFZgrSGPmQS6lgLSJ+I2S4t4HWEZBxhPD8Ij8iXZkL7jwrAQM
         5mnEa6lgk0DMhQb2GXZWl0QQLj/Pcnno5EDuKpirLd2VYpfcYeWFsREvKKhGvTEbwwct
         sSrfIGdlVW44DRpouWISNbcHC37I6gdxAoMV5waKBtZ4F6TO6dmfWnBwPmzCPX5bGocl
         kN6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WkJGb3hmdHjOYQaewm0wQtiLEaHfags/GYZjg3z/bDI=;
        b=eqmbnQ+9wYFSNQoakigAeckaOIRW2ofBLbXCdnTYYniJODctY0ifpnB6EXSqAZgD//
         N/fnJPB0Mu+sLKDoXf5fexQHhd2IKANxwrSrrs6vfA3MQEj1l/DiJIqc6bhq9eY0EsX6
         YQZV7CM7gEznSXJWs0J4PVOTXlTRwe+3zg2ne59ttol6b8AUTssl3qWKG5KhHYndhwix
         mJFIlaGB0ZE6QIWrNWPxd7jbOe94uHOW9sO8W/F6qUxMOBMgAxj5ItsdeM8Heh17qcJU
         RRggwkSt1ph7U6lxxhHYiEYzNKVjefFtXH7Xk0ZKGpMdRhNUHKSR5bfqpGV4f0waTgg4
         myQg==
X-Gm-Message-State: AOAM530I64iWqKkQpV7z+0OYksgkddjhTVMj3T6cg3GNiCpgG7oOncLs
        CXtG2B5dXZp5+YXgtppgfiM=
X-Google-Smtp-Source: ABdhPJzog99PSephaO8dD/CEfhrrPOn/dOH3lhAa3XXooHUqxwXYCjCd8EQtY1n3pOa07sy90Mb4xA==
X-Received: by 2002:a19:6903:: with SMTP id e3mr8013646lfc.264.1625575767280;
        Tue, 06 Jul 2021 05:49:27 -0700 (PDT)
Received: from carbon.v ([94.143.149.146])
        by smtp.googlemail.com with ESMTPSA id r18sm139519ljc.120.2021.07.06.05.49.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jul 2021 05:49:26 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v7 06/10] namei: add getname_uflags()
Date:   Tue,  6 Jul 2021 19:48:57 +0700
Message-Id: <20210706124901.1360377-7-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706124901.1360377-1-dkadashev@gmail.com>
References: <20210706124901.1360377-1-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There are a couple of places where we already open-code the (flags &
AT_EMPTY_PATH) check and io_uring will likely add another one in the
future.  Let's just add a simple helper getname_uflags() that handles
this directly and use it.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
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
index 57170d57e84d..70a3c5124db3 100644
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

