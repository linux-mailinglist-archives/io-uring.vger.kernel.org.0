Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B854424D53
	for <lists+io-uring@lfdr.de>; Thu,  7 Oct 2021 08:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234016AbhJGGe2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Oct 2021 02:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbhJGGe1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Oct 2021 02:34:27 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F6AC061746
        for <io-uring@vger.kernel.org>; Wed,  6 Oct 2021 23:32:34 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id k23so4081050pji.0
        for <io-uring@vger.kernel.org>; Wed, 06 Oct 2021 23:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qZ7sOEYsMyTuqvPKVFKD0W/AHjQgDTYbZRXoi2Vj5EY=;
        b=C6EaictFAi+8UenrrHN5rUs6OYJWClmy/tqk1Wy9dRCPFaSBQbsQeYwib1tJpmGq5W
         tYGn2bOrQ6pQW9agrJjaJ1EoAJHwR247ZvPdKRhwkX2SpCGk2x7fSyV9NEeeAEh5iLSS
         U5qlyL2JOoFf9rQOy1xAVZZ73g3INmZIJJ7nIoNAvrB/LtvuLDnsJfi4CYWhUNt1YV6t
         7FW+qZEZ2sPWQNFa79PLNGVSPpdvGQ/9u4MLViEYLnd6hWKcDfh6oO/oRY2anjnZiJF1
         zULwoQux8KqlI8QZY3hZKCAwQLkqJDb0fC81lynZyCQG3ji5NndtvmuauvS5wes95T5M
         ziHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qZ7sOEYsMyTuqvPKVFKD0W/AHjQgDTYbZRXoi2Vj5EY=;
        b=M9MGMpSUgJ7hO/s2UeagF/LxB1Y5cQqs/qjxxhBS2/7+xaukB/46f4Wf863oopNiii
         8mKW4nMDZtuAPmvGFeYA+zoEmXoYKnZfKIaU5OJJhel7zCgAkggoZ+auQGrRhZVxCAaS
         5SMUNfI2UWRE37A0QbfizOrvmr7bZu+W3C95qUDZa7GmbWe5sXAumL98APm7p/ro+PDi
         GsbaeEhZDC3lsEpVDpiZx30VGM1l5+sHHVOavpS30ymt7YASKmFa/MKxQ96dteaOhIs7
         n65pLYN4pawI9epdfCtuezBSmMbqAidj98TYYF2ZnxEGKo/GkJqaA+f22t3Qo1XP0CXV
         shgg==
X-Gm-Message-State: AOAM530eDYJMz9OhCSdzqVmPc6UYQzMpY9iAKD7YIlM9QKq9XEhLM/Zs
        Za8jjeAKfodAg4RupFq7rzMJaQ==
X-Google-Smtp-Source: ABdhPJySrYx3XH4uOd6JXDtJhgPz6nlkYCCig37wYy4PFvWch6HB3ycLQ4NeIKVkMnVGJkYtE3WNUg==
X-Received: by 2002:a17:90a:5895:: with SMTP id j21mr3411894pji.99.1633588353702;
        Wed, 06 Oct 2021 23:32:33 -0700 (PDT)
Received: from integral.. ([182.2.71.97])
        by smtp.gmail.com with ESMTPSA id k35sm7103919pjc.53.2021.10.06.23.32.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 23:32:33 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Cc:     Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Subject: [PATCH v2 RFC liburing 5/5] Add LIBURING_NOLIBC variable and edit src/Makefile
Date:   Thu,  7 Oct 2021 13:31:57 +0700
Message-Id: <20211007063157.1311033-6-ammar.faizi@students.amikom.ac.id>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211007063157.1311033-1-ammar.faizi@students.amikom.ac.id>
References: <a8a96675-91c2-5566-4ac1-4b60bbafd94e@kernel.dk>
 <20211007063157.1311033-1-ammar.faizi@students.amikom.ac.id>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Conditonal variable to enable nolibc build.

Link: https://github.com/axboe/liburing/issues/443
Signed-off-by: Ammar Faizi <ammar.faizi@students.amikom.ac.id>
---
 configure    |  7 +++++++
 src/Makefile | 13 ++++++++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/configure b/configure
index 92f51bd..6bdcead 100755
--- a/configure
+++ b/configure
@@ -358,6 +358,13 @@ print_config "has_memfd_create" "$has_memfd_create"
 
 
 #############################################################################
+if test "$LIBURING_NOLIBC" = "y" -o "$LIBURING_NOLIBC" = "yes" -o "$LIBURING_NOLIBC" = "1"; then
+  output_sym "LIBURING_NOLIBC"
+  LIBURING_NOLIBC="yes"
+else
+  LIBURING_NOLIBC="no"
+fi
+print_config "LIBURING_NOLIBC" "$LIBURING_NOLIBC"
 
 if test "$__kernel_rwf_t" = "yes"; then
   output_sym "CONFIG_HAVE_KERNEL_RWF_T"
diff --git a/src/Makefile b/src/Makefile
index 5e46a9d..bc42675 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -32,11 +32,22 @@ endif
 
 all: $(all_targets)
 
-liburing_srcs := setup.c queue.c syscall.c register.c
+liburing_srcs := setup.c queue.c register.c
+
+ifeq ($(LIBURING_NOLIBC),y)
+	liburing_srcs += nolibc.c
+	override CFLAGS += -nostdlib -nolibc -nodefaultlibs -ffreestanding -fno-stack-protector -fpic
+	override CPPFLAGS += -nostdlib -nolibc -nodefaultlibs -ffreestanding -fno-stack-protector -fpic
+	override LINK_FLAGS += -nostdlib -nolibc -nodefaultlibs -fpic
+else
+	liburing_srcs += syscall.c
+endif
 
 liburing_objs := $(patsubst %.c,%.ol,$(liburing_srcs))
 liburing_sobjs := $(patsubst %.c,%.os,$(liburing_srcs))
 
+$(liburing_srcs): syscall.h lib.h
+
 $(liburing_objs) $(liburing_sobjs): include/liburing/io_uring.h
 
 %.os: %.c
-- 
2.30.2

