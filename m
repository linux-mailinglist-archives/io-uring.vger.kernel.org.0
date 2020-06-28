Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6129120CA3F
	for <lists+io-uring@lfdr.de>; Sun, 28 Jun 2020 21:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgF1T6f (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Jun 2020 15:58:35 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41736 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbgF1T6f (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Jun 2020 15:58:35 -0400
Received: by mail-pg1-f194.google.com with SMTP id g67so6430687pgc.8
        for <io-uring@vger.kernel.org>; Sun, 28 Jun 2020 12:58:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e6oDbF5oEUKuQYEHTfavhkKbL50NifOZc02/IWyqWtk=;
        b=kPKxlwtFSS192alixH59ZFr/jFd9/Mic/XNJIQRX71SoyGzQUvs3/oEJJ7ygYjoehq
         j90xyblCRFbAv0jY2FvSjVHn8yhbH30eQ3KqSvURDPvaRkL9A+Qwqhzpg8CTJkxsEclj
         MP1FM7b9+p8NryWWaxRQeS0nTjvhIqxhUkOKjQo2mUX0BLtXk7t77QWuNYxyj/Xkfnaw
         VSHyHfnlGXMQHFQ6nDlMbInNUwmgJ1KT1B+uCRBuu+8S4vQBtD5gXUgDU3HU9DR2nnR7
         1zMKQf0MvAzVPXGKalLcUJ/aVuYFCR5k0/aWg1P8fKU8NJRIbmWzxABgmHn4SIfyDFPB
         zwfA==
X-Gm-Message-State: AOAM5314xbE+fMK6wiDkGf4ZbfFCWC8c6Qr97rLWuHkQAC62sb0ESJn2
        B67YjT6PaPTWWhPoD5HVyF4QDvOd
X-Google-Smtp-Source: ABdhPJzPJ3gjCohA31r1JlGe813Aygloejfk6MQ85EO+2idxwUg+qHEik1g6f5jziMryBIsJcJIOdQ==
X-Received: by 2002:a63:6c1:: with SMTP id 184mr7745905pgg.262.1593374314599;
        Sun, 28 Jun 2020 12:58:34 -0700 (PDT)
Received: from localhost.localdomain (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id d37sm1349394pgd.18.2020.06.28.12.58.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2020 12:58:33 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH liburing 3/7] Make the liburing header files again compatible with C++
Date:   Sun, 28 Jun 2020 12:58:19 -0700
Message-Id: <20200628195823.18730-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200628195823.18730-1-bvanassche@acm.org>
References: <20200628195823.18730-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Include <atomic> instead of <stdatomic.h> if built with a C++ compiler.

Fixes: b9c0bf79aa87 ("src/include/liburing/barrier.h: Use C11 atomics")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 src/include/liburing.h          |  8 +++----
 src/include/liburing/barrier.h  | 37 +++++++++++++++++++++++++++++++--
 src/include/liburing/io_uring.h |  8 +++++++
 3 files changed, 47 insertions(+), 6 deletions(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index c9034fc0df1b..76e2b854f957 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -2,10 +2,6 @@
 #ifndef LIB_URING_H
 #define LIB_URING_H
 
-#ifdef __cplusplus
-extern "C" {
-#endif
-
 #include <sys/socket.h>
 #include <sys/uio.h>
 #include <sys/stat.h>
@@ -19,6 +15,10 @@ extern "C" {
 #include "liburing/io_uring.h"
 #include "liburing/barrier.h"
 
+#ifdef __cplusplus
+extern "C" {
+#endif
+
 /*
  * Library interface to io_uring
  */
diff --git a/src/include/liburing/barrier.h b/src/include/liburing/barrier.h
index 57324348466b..a4a59fb499d6 100644
--- a/src/include/liburing/barrier.h
+++ b/src/include/liburing/barrier.h
@@ -2,8 +2,6 @@
 #ifndef LIBURING_BARRIER_H
 #define LIBURING_BARRIER_H
 
-#include <stdatomic.h>
-
 /*
 From the kernel documentation file refcount-vs-atomic.rst:
 
@@ -23,6 +21,40 @@ after the acquire operation executes. This is implemented using
 :c:func:`smp_acquire__after_ctrl_dep`.
 */
 
+#ifdef __cplusplus
+#include <atomic>
+
+template <typename T>
+static inline void IO_URING_WRITE_ONCE(T &var, T val)
+{
+	std::atomic_store_explicit(reinterpret_cast<std::atomic<T> *>(&var),
+				   val, std::memory_order_relaxed);
+}
+template <typename T>
+static inline T IO_URING_READ_ONCE(const T &var)
+{
+	return std::atomic_load_explicit(
+		reinterpret_cast<const std::atomic<T> *>(&var),
+		std::memory_order_relaxed);
+}
+
+template <typename T>
+static inline void io_uring_smp_store_release(T *p, T v)
+{
+	std::atomic_store_explicit(reinterpret_cast<std::atomic<T> *>(p), v,
+				   std::memory_order_release);
+}
+
+template <typename T>
+static inline T io_uring_smp_load_acquire(const T *p)
+{
+	return std::atomic_load_explicit(
+		reinterpret_cast<const std::atomic<T> *>(p),
+		std::memory_order_acquire);
+}
+#else
+#include <stdatomic.h>
+
 #define IO_URING_WRITE_ONCE(var, val)				\
 	atomic_store_explicit((_Atomic typeof(var) *)&(var),	\
 			      (val), memory_order_relaxed)
@@ -36,5 +68,6 @@ after the acquire operation executes. This is implemented using
 #define io_uring_smp_load_acquire(p)				\
 	atomic_load_explicit((_Atomic typeof(*(p)) *)(p),	\
 			     memory_order_acquire)
+#endif
 
 #endif /* defined(LIBURING_BARRIER_H) */
diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 785a6a4f2233..6a73522de0cb 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -11,6 +11,10 @@
 #include <linux/fs.h>
 #include <linux/types.h>
 
+#ifdef __cplusplus
+extern "C" {
+#endif
+
 /*
  * IO submission data structure (Submission Queue Entry)
  */
@@ -289,4 +293,8 @@ struct io_uring_probe {
 	struct io_uring_probe_op ops[0];
 };
 
+#ifdef __cplusplus
+}
+#endif
+
 #endif
