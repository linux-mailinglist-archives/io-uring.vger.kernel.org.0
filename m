Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD09E20BEE8
	for <lists+io-uring@lfdr.de>; Sat, 27 Jun 2020 07:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbgF0FzV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 27 Jun 2020 01:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgF0FzV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 27 Jun 2020 01:55:21 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55ACBC03E979
        for <io-uring@vger.kernel.org>; Fri, 26 Jun 2020 22:55:21 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id z63so10823258qkb.8
        for <io-uring@vger.kernel.org>; Fri, 26 Jun 2020 22:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ivV+a2H2rkY8BwXyYD7rQ9Eiso5z/PFlGSHIBM/9rRE=;
        b=UaX3L9ML2uzRwEt7OPRh9f1iUwYoYqXfPlG9iRSMRRG4hCuJZaD9/4OEvB0vv5QqVF
         BxwID2zgvYEm96VUML+G43xJ0OJsN+4k5X63RQEWUdca6tKxT4ZCXPFKwEtDl5Sx2K4u
         u17YvKfsaP4J4kIFKegVziqR00Fiw2Gv0WqblL0iydyB+HX3/ODajCpVifJg8oyhBjSu
         Vcbn6QjEClCi9UijoihtO1jUDFa5SceDsYv298OhQwu8D7XW+B06gV7HLg52UcqrGZu6
         RVaxlhlpBDKC6ferbjUGJ9fyP9ICnnuv/+1V7YoOJgjGn6xNMQIJ24+rMstFzqT1Fhdy
         jcGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ivV+a2H2rkY8BwXyYD7rQ9Eiso5z/PFlGSHIBM/9rRE=;
        b=szwxICp3p69G9nLMYcUz+23cyoNo9UkAno7pKc3IxKs5MKK9x2xUGfSqAfiyS3ImRb
         Jw2GcJSssy1tOksj1khzoPmUGcT1sjdD5UQJskWjCC3c3gZo8FtoNLhit2IVLc64Mxer
         CPAvyqKK/3iJQ3cqr6EL2E/t5Zvg70xQqMrFvSvRiaG6Dqwo3lgx5RWuq/s4GSw0Y5xJ
         0y9f/PBpsJuCYziTU58CE8ISBml/XLU8SbrhSx9a1eT29rxN/pn49Ew4ln9S0+pCpLa9
         hrBlG9zDuJWIJnAwF0FPMay/Lu8Fc/lCtdXFnDDFRfmwYWW1iS/mEL17CNWHAcfvg2lg
         SCqQ==
X-Gm-Message-State: AOAM530LZenr3SEXSB/iGdFNQGVIx/KeJ0vaDSDbmsozIjgivj5qv8QU
        +PTncjIHsXDFVa0tZBYVYdbxk4Us0YM=
X-Google-Smtp-Source: ABdhPJxBiJ4D9C0VGPTin0KT8A/vBJ3TaFeoX9fYb97FTciLHqLHxeyeS3NFlXVVvkD4Dz2y7ogkPg==
X-Received: by 2002:a37:45d8:: with SMTP id s207mr6194164qka.140.1593237318803;
        Fri, 26 Jun 2020 22:55:18 -0700 (PDT)
Received: from littletwo.lan ([2604:6000:150e:c284::e96])
        by smtp.gmail.com with ESMTPSA id g4sm9889224qka.97.2020.06.26.22.55.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2020 22:55:18 -0700 (PDT)
From:   Hrvoje Zeba <zeba.hrvoje@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Hrvoje Zeba <zeba.hrvoje@gmail.com>
Subject: [RFC PATCH] Fix usage of stdatomic.h for C++ compilers
Date:   Sat, 27 Jun 2020 01:55:15 -0400
Message-Id: <20200627055515.764165-1-zeba.hrvoje@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Since b9c0bf79aa8, liburing.h doesn't compile with C++ compilers. C++
provides it's own <atomic> interface and <stdatomic.h> can't be used. This
is a minimal change to use <atomic> variants where needed.

Signed-off-by: Hrvoje Zeba <zeba.hrvoje@gmail.com>
---
 src/include/liburing.h         | 18 ++++++++++--------
 src/include/liburing/barrier.h |  8 ++++++++
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index c9034fc..2bb6efd 100644
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
@@ -15,9 +11,15 @@ extern "C" {
 #include <inttypes.h>
 #include <time.h>
 #include <linux/swab.h>
+
+#include "liburing/barrier.h"
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
 #include "liburing/compat.h"
 #include "liburing/io_uring.h"
-#include "liburing/barrier.h"
 
 /*
  * Library interface to io_uring
@@ -40,11 +42,11 @@ struct io_uring_sq {
 };
 
 struct io_uring_cq {
-	unsigned *khead;
-	unsigned *ktail;
+	atomic_uint *khead;
+	atomic_uint *ktail;
 	unsigned *kring_mask;
 	unsigned *kring_entries;
-	unsigned *kflags;
+	atomic_uint *kflags;
 	unsigned *koverflow;
 	struct io_uring_cqe *cqes;
 
diff --git a/src/include/liburing/barrier.h b/src/include/liburing/barrier.h
index c8aa421..8f422eb 100644
--- a/src/include/liburing/barrier.h
+++ b/src/include/liburing/barrier.h
@@ -2,7 +2,15 @@
 #ifndef LIBURING_BARRIER_H
 #define LIBURING_BARRIER_H
 
+#ifdef __cplusplus
+#include <atomic>
+using std::atomic_uint;
+using std::memory_order_release;
+using std::memory_order_acquire;
+using std::memory_order_relaxed;
+#else
 #include <stdatomic.h>
+#endif
 
 /*
 From the kernel documentation file refcount-vs-atomic.rst:
-- 
2.27.0

