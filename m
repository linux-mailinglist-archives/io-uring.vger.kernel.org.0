Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 770C641C28D
	for <lists+io-uring@lfdr.de>; Wed, 29 Sep 2021 12:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245538AbhI2KTR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Sep 2021 06:19:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245274AbhI2KS5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Sep 2021 06:18:57 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99FFEC061760
        for <io-uring@vger.kernel.org>; Wed, 29 Sep 2021 03:17:16 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id lp15-20020a17090b4a8f00b0019f4059bd90so9790pjb.3
        for <io-uring@vger.kernel.org>; Wed, 29 Sep 2021 03:17:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lcenYzu+oA9Fj2QbuekN7tzi8G95tBvqNzWbY8TopP0=;
        b=c9+yWeheqKoLD1YOErDKnLr+zP0eG/F82j/c/GgylHX2bGryLClGJvfOFQ25ritXbs
         m5QZJ961g3vAibrxUQChuMV3sOCeqO4HdSauGtdqKxHF18DWZxlNkGJ7SyG9G/UaXPkV
         h7iyW7HSyEpi13pU/1k2RhKvYuCb6DZcsTzOfRAKXr89NpiknKPAulJJk4AXGKvV8o54
         SeOdSV8fWNQz9uiH/czTuRnJOZQag0stNnncK5+kpyf8rcCz82l1cNQXwlKofQei1Zk4
         TbpBKwsT6qTwT3cBX5xphkyX1Wq4vojZp9yl/hKFGKF89S13wy4iFC8aaq/kXuyu5vjt
         f/oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lcenYzu+oA9Fj2QbuekN7tzi8G95tBvqNzWbY8TopP0=;
        b=UdQGAJPoYfOZq/gct6ygfnTqyw6bU9gKdss5Ke1/r/mW0SW2wk0BlT4OtTa83z2l0f
         VdZUPh8dR1vF35ae8590vlojgsZU594c+mJWRhHOCc9AszIWREtkj51dkyu9g/AR0Q7F
         Ni0MfYSGR1bp5X+J3mfl1dpG7WJmvfbNTF4B0IhGYubC8rkznsTo5agxCqecextVnsXz
         hKtBfWOLMcBM4x+ZHFBPjsumnGRPdaYbbUjxSgn4Godc9GOkNWW+flWQe0X33diwHNpV
         gI0XUIJ5b9ZWWGHvDleuMcpLG9dwKuvezRavdRJN79OKV+06x6e4izTPTmF44Uw/kma3
         iNjA==
X-Gm-Message-State: AOAM532uomLeGjuh1D+0Aaikix3tiu4YXCU34C9IiHP1kOB+tTZouBhf
        JxF/ci/mGphloS90jUw+pMb/Xg==
X-Google-Smtp-Source: ABdhPJzOhtg20uD4gLgUxodNnUu+PWHWPlSc6O0W+Idmtk8jkQeXr8eu7rqXDxnSSmacBhGVHx5HLQ==
X-Received: by 2002:a17:902:b696:b0:13a:7871:55f5 with SMTP id c22-20020a170902b69600b0013a787155f5mr9683970pls.60.1632910636140;
        Wed, 29 Sep 2021 03:17:16 -0700 (PDT)
Received: from integral.. ([68.183.184.174])
        by smtp.gmail.com with ESMTPSA id f16sm2001512pfk.110.2021.09.29.03.17.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 03:17:15 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>,
        Ammar Faizi <ammarfaizi2@gmail.com>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Subject: [PATCHSET v1 RFC liburing 5/6] Add `liburing_getrlimit()` and `liburing_setrlimit()`
Date:   Wed, 29 Sep 2021 17:16:05 +0700
Message-Id: <20210929101606.62822-6-ammar.faizi@students.amikom.ac.id>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210929101606.62822-1-ammar.faizi@students.amikom.ac.id>
References: <20210929101606.62822-1-ammar.faizi@students.amikom.ac.id>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Do not use `getrlimit()` and `mumap()` directly from the libc in the
liburing internal sources. Wrap them in `src/syscall.c`. This is the
part of implementing the kernel style return value (which later is
supposed to support no libc environment).

`liburing_getrlimit()` and `liburing_setrlimit()` do the same thing
with `getrlimit()` and `setrlimit()` from the libc. The only different
is when error happens, the return value is of `liburing_{get,set}rlimit()`
will be a negative error code.

Signed-off-by: Ammar Faizi <ammar.faizi@students.amikom.ac.id>
---
 src/register.c |  4 ++--
 src/syscall.c  | 16 ++++++++++++++++
 src/syscall.h  |  4 ++++
 3 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/src/register.c b/src/register.c
index 944852e..0908e3e 100644
--- a/src/register.c
+++ b/src/register.c
@@ -107,11 +107,11 @@ static int increase_rlimit_nofile(unsigned nr)
 {
 	struct rlimit rlim;
 
-	if (getrlimit(RLIMIT_NOFILE, &rlim) < 0)
+	if (liburing_getrlimit(RLIMIT_NOFILE, &rlim) < 0)
 		return -errno;
 	if (rlim.rlim_cur < nr) {
 		rlim.rlim_cur += nr;
-		setrlimit(RLIMIT_NOFILE, &rlim);
+		liburing_setrlimit(RLIMIT_NOFILE, &rlim);
 	}
 
 	return 0;
diff --git a/src/syscall.c b/src/syscall.c
index 44861f6..b8e7cb3 100644
--- a/src/syscall.c
+++ b/src/syscall.c
@@ -141,3 +141,19 @@ int liburing_madvise(void *addr, size_t length, int advice)
 	ret = madvise(addr, length, advice);
 	return (ret < 0) ? -errno : ret;
 }
+
+int liburing_getrlimit(int resource, struct rlimit *rlim)
+{
+	int ret;
+
+	ret = getrlimit(resource, rlim);
+	return (ret < 0) ? -errno : ret;
+}
+
+int liburing_setrlimit(int resource, const struct rlimit *rlim)
+{
+	int ret;
+
+	ret = setrlimit(resource, rlim);
+	return (ret < 0) ? -errno : ret;
+}
diff --git a/src/syscall.h b/src/syscall.h
index 32381ce..1ac56f9 100644
--- a/src/syscall.h
+++ b/src/syscall.h
@@ -3,6 +3,8 @@
 #define LIBURING_SYSCALL_H
 
 #include <signal.h>
+#include <sys/time.h>
+#include <sys/resource.h>
 #include "kernel_err.h"
 
 struct io_uring_params;
@@ -30,5 +32,7 @@ void *liburing_mmap(void *addr, size_t length, int prot, int flags, int fd,
 		    off_t offset);
 int liburing_munmap(void *addr, size_t length);
 int liburing_madvise(void *addr, size_t length, int advice);
+int liburing_getrlimit(int resource, struct rlimit *rlim);
+int liburing_setrlimit(int resource, const struct rlimit *rlim);
 
 #endif
-- 
2.30.2

