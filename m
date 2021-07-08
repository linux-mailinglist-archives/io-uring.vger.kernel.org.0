Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10E993BF5A0
	for <lists+io-uring@lfdr.de>; Thu,  8 Jul 2021 08:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbhGHGiF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Jul 2021 02:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbhGHGiB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Jul 2021 02:38:01 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF73C06175F;
        Wed,  7 Jul 2021 23:35:18 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id t3so6846586edt.12;
        Wed, 07 Jul 2021 23:35:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+aL8eUyCcZIm7m9c9cpQrgQm638OpqOKLxLINa0Iv48=;
        b=n7IrrwOZ90WSiTV/5g19dM6dn5cB+ZxsruZocVQdDOMmm1W4SWrVLQo1BTgxxZakff
         Rp/FImeAafFltRdJCKRa3t74NuhPKOeUFI+feaFHfTlyx+5OzpBFM9i2eYm0ErfiR3Aw
         +s1UEnpNypLP0yLkWfCjfrKMcISLSkirfGlMYL1zxMH8kS/L0OtehqI6TYcJ7jh0qR/D
         iIv63/0yGGEgyyXAH/xSMGR+aUmW5GkDoFT3D+Ae9LxNwebucGytq/a3XeYF1VP+4gIf
         Yj18dx7xIpe31JVdFqaUNDpwhVdXh08NGL1k6dC2S+HBCW0+SVvETJNvOzByuRdT2sx5
         xiFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+aL8eUyCcZIm7m9c9cpQrgQm638OpqOKLxLINa0Iv48=;
        b=Qv4Cumr91Wi9bl4pRtyL9H2wEaSxNefqe0RV1LG9kCvYoPqyxPZJpb0qtYXJgai9xM
         zO71VQAlsjSOj2YP0qg5sZxgIEFuVuH3mzBZO/tXKD/urb7GqaO2FuD1T77ImU/oo5Xh
         fOLFy3UTN0+fvWEa0teqY++p3BpyiDdPe15JTWm61gv0AeScFVzLGAPoGraps79NS8mq
         CtFerx/QDMHpv4gw6FbQ8dK374AHzqDLEpNV5JyX5JyMI9xSSBmwIGQzBTzZa1P7+Wdz
         MH6t3SLUvxbzULwdzV8DZIQvGoXApyL3pKTyPY1p29rw/h5KyyuMZSrZRL17DgbwJByO
         C/XQ==
X-Gm-Message-State: AOAM530qTZdcjcZokuX5jWWd4tWu3BALtqeUG7o+BzytDWT1ZQorBqiE
        vcEPNfXo+OvlOYqUFLiGOsQ=
X-Google-Smtp-Source: ABdhPJx9W3O5wCAhbS9cqd/Y/s5TZhFetTt0+7Y16o8/2uxaAFETH+Dbu3tP89b7b+3a5o+pZPw51Q==
X-Received: by 2002:aa7:dc0c:: with SMTP id b12mr36266761edu.105.1625726117585;
        Wed, 07 Jul 2021 23:35:17 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id u21sm410260eja.59.2021.07.07.23.35.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 23:35:17 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v9 06/11] namei: add getname_uflags()
Date:   Thu,  8 Jul 2021 13:34:42 +0700
Message-Id: <20210708063447.3556403-7-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210708063447.3556403-1-dkadashev@gmail.com>
References: <20210708063447.3556403-1-dkadashev@gmail.com>
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
index add984e4bfd0..ab7979f9daaa 100644
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

