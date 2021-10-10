Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2081427F5F
	for <lists+io-uring@lfdr.de>; Sun, 10 Oct 2021 08:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbhJJGnl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 10 Oct 2021 02:43:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230433AbhJJGnk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 10 Oct 2021 02:43:40 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C80BBC061764
        for <io-uring@vger.kernel.org>; Sat,  9 Oct 2021 23:41:41 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id k26so11926612pfi.5
        for <io-uring@vger.kernel.org>; Sat, 09 Oct 2021 23:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SqyBzjlUnzSQmy573EQAqdqJc8Pc2d86PQ9u0ucfsRQ=;
        b=hOR9s6CMymm96ddme28OwL41ldmXk+HO6WADRyw90949xyvHDQ1EUQz3u94P1TD2CP
         /o21r4lPo5j1Cm9FhRms/QD0HoLoGjuWQjskqVFS+Kk8NJq6e1uDFFPbfWUw/oXCCe9N
         aNO8vibbqETqike5MOINq773QyN+np5lHBMmnu5aImzN0xw0LincOMp3WHrWhDqROe/a
         peco867AlUnLjRizN5kYyxIfHY9BQB0nCxUwH5x+VZJNPcIaiLpzc59AYLLFNtgX95Jv
         yVemdZv19OeHDlhr3qwRqLrnkMNskXW3DIut3t7z5vU2ua6Hc1451wvk9JJHHFAxJH8M
         20yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SqyBzjlUnzSQmy573EQAqdqJc8Pc2d86PQ9u0ucfsRQ=;
        b=b8q/SCtKWLMB3H9WEMwdgf3/29OKKHClDbgXI7Rt7T3M1nsLyyNdcYl1HAXZ3SxU7R
         2oiskAblg7NcSNu+Tl72EhiTqOol3BtNPEXpo/7fqNS73yPx7aiDMZUjWpS7vlff5l4H
         U3vvkGtdj/e00hKh6Was7zb3KXBWrbDdv09SIbeKEeQHpim3/fEr/6pwDrxZUS7249fq
         V2vXvLqCqAuClm1sixkpdHOr1+bDh0hfuy3naIuVCG+x4xduXxy2udGthxqCeu9NEVYV
         0d8mlAje/wR5It4eVYUW1WYnC6rBX0RI6VdX2w45EWA5g2RhWV+Um+7FkHPsHpY7BLVz
         dl3w==
X-Gm-Message-State: AOAM531eYN1DrnGZOydjPkT5OijZwvKdqeJN0V0Gx8koKOnYJNOtRctS
        +AD+lKlFu5A5pwTIJ79znwNpVw==
X-Google-Smtp-Source: ABdhPJy3iIWCAQ48PU4Ujc4WUyFZEJnNhWO7jEdmKZcwoA99N5owRbZ3OET95jiVVmedqptoMNLXtg==
X-Received: by 2002:a65:6a0f:: with SMTP id m15mr12816637pgu.298.1633848101352;
        Sat, 09 Oct 2021 23:41:41 -0700 (PDT)
Received: from integral.. ([182.2.39.79])
        by smtp.gmail.com with ESMTPSA id s25sm3742225pfm.138.2021.10.09.23.41.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 23:41:40 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Cc:     Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Subject: [PATCH v2 liburing 4/4] Add CONFIG_NOLIBC variable and macro
Date:   Sun, 10 Oct 2021 13:39:06 +0700
Message-Id: <20211010063906.341014-5-ammar.faizi@students.amikom.ac.id>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211010063906.341014-1-ammar.faizi@students.amikom.ac.id>
References: <20211010063906.341014-1-ammar.faizi@students.amikom.ac.id>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

For conditonal variable and macro to enable nolibc build.
Add `--nolibc` option for `configure` to enable it.

Link: https://github.com/axboe/liburing/issues/443
Signed-off-by: Ammar Faizi <ammar.faizi@students.amikom.ac.id>
---
 configure    |  8 ++++++++
 src/Makefile | 13 ++++++++++++-
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/configure b/configure
index 92f51bd..6712ce3 100755
--- a/configure
+++ b/configure
@@ -24,6 +24,8 @@ for opt do
   ;;
   --cxx=*) cxx="$optarg"
   ;;
+  --nolibc) liburing_nolibc="yes"
+  ;;
   *)
     echo "ERROR: unknown option $opt"
     echo "Try '$0 --help' for more information"
@@ -358,6 +360,12 @@ print_config "has_memfd_create" "$has_memfd_create"
 
 
 #############################################################################
+if test "$liburing_nolibc" = "yes"; then
+  output_sym "CONFIG_NOLIBC"
+else
+  liburing_nolibc="no"
+fi
+print_config "liburing_nolibc" "$liburing_nolibc"
 
 if test "$__kernel_rwf_t" = "yes"; then
   output_sym "CONFIG_HAVE_KERNEL_RWF_T"
diff --git a/src/Makefile b/src/Makefile
index 5e46a9d..290517d 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -32,11 +32,22 @@ endif
 
 all: $(all_targets)
 
-liburing_srcs := setup.c queue.c syscall.c register.c
+liburing_srcs := setup.c queue.c register.c
+
+ifeq ($(CONFIG_NOLIBC),y)
+	liburing_srcs += nolibc.c
+	override CFLAGS += -nostdlib -nolibc -nodefaultlibs -ffreestanding -fno-stack-protector
+	override CPPFLAGS += -nostdlib -nolibc -nodefaultlibs -ffreestanding -fno-stack-protector
+	override LINK_FLAGS += -nostdlib -nolibc -nodefaultlibs
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

