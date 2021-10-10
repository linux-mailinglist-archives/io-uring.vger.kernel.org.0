Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6397B42819A
	for <lists+io-uring@lfdr.de>; Sun, 10 Oct 2021 15:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232818AbhJJNz5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 10 Oct 2021 09:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232815AbhJJNz4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 10 Oct 2021 09:55:56 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27320C06161C
        for <io-uring@vger.kernel.org>; Sun, 10 Oct 2021 06:53:58 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id g5so6391784plg.1
        for <io-uring@vger.kernel.org>; Sun, 10 Oct 2021 06:53:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vmloDOYaKp2FgwK+dZti8Gh+AvX+kqdJX0UhspXfHYI=;
        b=EKG9dq8JVH+xmIlp4Bledu+NCFmheyZaTgyCyLVIQGAX3QG3eVly8y0wEB7paXNdeP
         uMUGdjd0lCDqG46l1joYAyELHtMqe3S1viqWQ55x0iFORoga8jcRhVFJoQq8mi9/RPJF
         wrKPHG8CYfIAf5NPjM067w3PhRjOORme7K9TkOMex3z0I1ks7PbqZjiFjPpDdC3YcyND
         WiMLllCxvqh4dVuelh4wC9t/JnvC7FNpg7p8kQGQNenm9zrqEEjg1ZteotLxFJxTf27W
         cLWHR36dDQBOxPvYTM0lHkWUoml4T1yXNahGyreDNfoKFCRmG0VaAKAWx6tPWo1jj3x3
         iCOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vmloDOYaKp2FgwK+dZti8Gh+AvX+kqdJX0UhspXfHYI=;
        b=5x9UsApYh5YDHE/ZVXxvDgVlhH3llNLZ7nRCS4b/hVrNwfNVMiAK+gXLMb409zyshq
         FM0c90P6ye2v3FCvky53Ki9ivU2cP/zNO1ia4S14fwYBQwzSULsqI5/FhQxLs0Y38/Qy
         7ZNR165gOBXGbFNKLnvGQdu4jCz3s4dJl2C1joM8Fna3A8W/v6LJwVqllzjgp2n0NKwJ
         3zRUXcRAgr0OLOAgLLbRSDybR32T0oe4kB91itBLPhMILIf5sMM8MLImEcw4IQBzPlxj
         lNysKru93uVKq9OmEH5EX50nJVQjm+9KOvPi6mHZoPpwrqEf4C5/+1MpizDwDuA+GcRK
         exNg==
X-Gm-Message-State: AOAM5312Jv9N38B7IS/JvOQvJAv6fXfTwzsB0StlLtdsZ/nAW7v6ZUn2
        /1NkXXgVgKORl9DPIdEKz4Qz3g==
X-Google-Smtp-Source: ABdhPJzQefkuwwygGqe9sjjEAtdabbGZtZH0jMB7oVpHolbuiBk4/QQuJw3fXvfy5VGt0+gLualQzA==
X-Received: by 2002:a17:90a:de16:: with SMTP id m22mr24030058pjv.54.1633874037605;
        Sun, 10 Oct 2021 06:53:57 -0700 (PDT)
Received: from integral.. ([182.2.41.40])
        by smtp.gmail.com with ESMTPSA id p4sm4557249pjo.0.2021.10.10.06.53.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 06:53:57 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Cc:     Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Subject: [PATCH v3 liburing 3/3] configure: Add `CONFIG_NOLIBC` variable and macro
Date:   Sun, 10 Oct 2021 20:53:38 +0700
Message-Id: <20211010135338.397115-4-ammar.faizi@students.amikom.ac.id>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211010135338.397115-1-ammar.faizi@students.amikom.ac.id>
References: <20211010135338.397115-1-ammar.faizi@students.amikom.ac.id>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It's for conditonal variable and macro to enable nolibc build.
Also add `--nolibc` option to `configure` to enable it.

Link: https://github.com/axboe/liburing/issues/443
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Ammar Faizi <ammar.faizi@students.amikom.ac.id>
---
 configure    |  9 +++++++++
 src/Makefile | 17 ++++++++++++++++-
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/configure b/configure
index 92f51bd..d2866b3 100755
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
@@ -71,6 +73,7 @@ Options: [defaults in brackets after descriptions]
   --datadir=PATH           install shared data in PATH [$datadir]
   --cc=CMD                 use CMD as the C compiler
   --cxx=CMD                use CMD as the C++ compiler
+  --nolibc                 build liburing without libc
 EOF
 exit 0
 fi
@@ -358,6 +361,12 @@ print_config "has_memfd_create" "$has_memfd_create"
 
 
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
index 5e46a9d..09ff395 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -32,11 +32,22 @@ endif
 
 all: $(all_targets)
 
-liburing_srcs := setup.c queue.c syscall.c register.c
+liburing_srcs := setup.c queue.c register.c
+
+ifeq ($(CONFIG_NOLIBC),y)
+	liburing_srcs += nolibc.c
+	override CFLAGS += -nostdlib -nodefaultlibs -ffreestanding -fno-stack-protector
+	override CPPFLAGS += -nostdlib -nodefaultlibs -ffreestanding -fno-stack-protector
+	override LINK_FLAGS += -nostdlib -nodefaultlibs
+else
+	liburing_srcs += syscall.c
+endif
 
 liburing_objs := $(patsubst %.c,%.ol,$(liburing_srcs))
 liburing_sobjs := $(patsubst %.c,%.os,$(liburing_srcs))
 
+$(liburing_srcs): syscall.h lib.h
+
 $(liburing_objs) $(liburing_sobjs): include/liburing/io_uring.h
 
 %.os: %.c
@@ -73,3 +84,7 @@ clean:
 	@rm -f $(all_targets) $(liburing_objs) $(liburing_sobjs) $(soname).new
 	@rm -f *.so* *.a *.o
 	@rm -f include/liburing/compat.h
+
+	@# When cleaning, we don't include ../config-host.mak,
+	@# so the nolibc objects are always skipped, clean them up!
+	@rm -f nolibc.ol nolibc.os
-- 
2.30.2

