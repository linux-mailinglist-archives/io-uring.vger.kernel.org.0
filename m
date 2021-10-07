Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 580E54255F8
	for <lists+io-uring@lfdr.de>; Thu,  7 Oct 2021 17:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242248AbhJGPFK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Oct 2021 11:05:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242243AbhJGPFK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Oct 2021 11:05:10 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AFFEC061570
        for <io-uring@vger.kernel.org>; Thu,  7 Oct 2021 08:03:16 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id s16so5637056pfk.0
        for <io-uring@vger.kernel.org>; Thu, 07 Oct 2021 08:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qZ7sOEYsMyTuqvPKVFKD0W/AHjQgDTYbZRXoi2Vj5EY=;
        b=AgZJpR0PaCZ0J5H7pCQSBJ1Af0WtNVi3PA3X8ZlD0D/2A9sfOR4qUje8S5P6iYpK/p
         8cu8DcIFKXM7DLtwfhGwBJUeWdHjH8ujHXhVrs2Ca997jXvF7ZJ4DWVmqdwkPUTVnjUo
         /j/25xKq1P3JyIL8HcDYVVJPt39zoI5JQ29QeIYxbT5vZcH13gGtgyAqIEFco8sM8HTO
         4bZfOAk5x6pISMoo8zEL+TBxzNCu8NehapYEi+Bx8yvDJDCYAASsqpKzDkmhm23UW2kV
         siaD2G+xtPmCbIY39JkvpcbDfH8K+5HdtGZJB1DBHdc5h1GOdMp/JAKQm/nAMTqA9/+x
         mwqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qZ7sOEYsMyTuqvPKVFKD0W/AHjQgDTYbZRXoi2Vj5EY=;
        b=U1RpJAFAtbIQehNJnKCmIOs2lnOi52IUQBYxa+veye7wKF2i3XrNzJ/AFCFs6STalU
         UApT53GczWf7pMQ1xbEj5GtXG/c+OuV814Pz/BMyTZa3X8ZJldBIdvIrtNkCvpLfS/1r
         Fs4p70GgfVXR5jTN3VKnlDroqOq39OMenUDLDy9hRYKCbJ7+i/GEwLndvLvPo+ypnm2a
         uF5XwGVIiTqM5GZOaLhE94s88zSGd4HPLfb3QlRXPMYAr198fs2C1JDOdbuIak4mSlkK
         DRz4Cr6WSXgFb5gkjAV+97n6f2dOmQ0dUDNKz8SENjWtsNVKPiQ9LCrdZjDWTZbNgfPx
         0blw==
X-Gm-Message-State: AOAM53094gZ5gJwwUZpi5Flq2mO/zr3835Db6gbqpU3HDXg5nkta+4jK
        ScTvOz6o2Xh8XZ3LVPfPZHvW0A==
X-Google-Smtp-Source: ABdhPJy4bjiGZLRLers+ZBoVcMHnhbmbW6+ojmO+k6S7Y5LTWI8COj0SSjbPJkoseGRqPNP4lW/9RA==
X-Received: by 2002:a62:4e87:0:b0:447:ce02:c32e with SMTP id c129-20020a624e87000000b00447ce02c32emr4517454pfb.33.1633618995841;
        Thu, 07 Oct 2021 08:03:15 -0700 (PDT)
Received: from integral.. ([182.2.71.117])
        by smtp.gmail.com with ESMTPSA id z23sm25078983pgv.45.2021.10.07.08.03.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 08:03:15 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Cc:     Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Subject: [PATCH liburing 4/4] Add LIBURING_NOLIBC variable and edit src/Makefile
Date:   Thu,  7 Oct 2021 22:02:10 +0700
Message-Id: <20211007150210.1390189-5-ammar.faizi@students.amikom.ac.id>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211007150210.1390189-1-ammar.faizi@students.amikom.ac.id>
References: <20211007063157.1311033-1-ammar.faizi@students.amikom.ac.id>
 <20211007150210.1390189-1-ammar.faizi@students.amikom.ac.id>
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

