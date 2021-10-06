Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA6E42407A
	for <lists+io-uring@lfdr.de>; Wed,  6 Oct 2021 16:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239051AbhJFOxZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Oct 2021 10:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238436AbhJFOxZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Oct 2021 10:53:25 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E3C7C061753
        for <io-uring@vger.kernel.org>; Wed,  6 Oct 2021 07:51:33 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id v11so2670769pgb.8
        for <io-uring@vger.kernel.org>; Wed, 06 Oct 2021 07:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O2llvosXlVZBDUoYTOmjz7f3JFPEy9r9/UKWsxf6pro=;
        b=BEJ3MHY1IpYQIL0bKH67uHI79Dg0tb7gyHPyV/UGGaKrif2xCegmO7uwyrSlWlEah0
         vQowuT7lvLjIGsCmQXW33xvjFxlzSY/AXx9oPyyweenksXfDHmS3e8W7pUIBRhNnz3Il
         QCEVSc1ALkz7jVVuiTnGvmtVl386BdmrihF4Vc4+CtbYUv+utR16p6E/cKeL5kuEJTWg
         W4pHRZ7OCdMRhDAH+17KpttrUkHycK9qX1tyib5Q1wMA5T57Zjeocwh0mEXvp8oGRpYG
         muiEiUfFaYP2LsJmMZsHHpw8wx0Y/d+x+vT03Dv1ooKsZJbLe2SPvIjmQC5zUYVFay0W
         kOCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O2llvosXlVZBDUoYTOmjz7f3JFPEy9r9/UKWsxf6pro=;
        b=nXStv18ZUONPdDFATv8pScgHjXrb7yCOunxioFhAe7nTng8hBNUuOnmDJeA/rDFUOn
         KsvoW8nwW+JGidjHluCKDtPnJ0dB8Gku4RIYc07ubxzxvrwmJfAk8IwzTg2tBAsc6MZT
         kc5SRU2O+moy+ejp3BWnyQDPePrKhGgaWlyLejrzWaHV82VXOmIpskV4EfqWQJT6t96P
         /S9z1e4PX+IQfrCrS9+Iiyq0y/wO50xpcLqG4hYQSDxpftPCFk/AN7ifmJjhLXZgduyt
         m2nj887G1iIs7CSLt/KX+cxw07CvLHJB1mIoAV3tzVxYbGBaamR36pS76CZD7noNlDfB
         8W1Q==
X-Gm-Message-State: AOAM53183DeDKRVSSvGhHgBO3Wa5Vss5dx/wRXRElFtlJSC4vq6K22yt
        oYnQRpJRdGc9aAoM+W9k+ErbmQ==
X-Google-Smtp-Source: ABdhPJzt7ofleOI66fy0sHTGxBMWIARQ2H1lbgY02255An5gIMHu8K+xe3M4EuemE62z4xMjoiQUSg==
X-Received: by 2002:a65:64d7:: with SMTP id t23mr20594688pgv.237.1633531893011;
        Wed, 06 Oct 2021 07:51:33 -0700 (PDT)
Received: from integral.. ([182.2.71.97])
        by smtp.gmail.com with ESMTPSA id y197sm19155429pfc.56.2021.10.06.07.51.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 07:51:32 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Cc:     Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Subject: [PATCH v1 RFC liburing 6/6] src/{queue,register,setup}: Clean up unused includes
Date:   Wed,  6 Oct 2021 21:49:12 +0700
Message-Id: <20211006144911.1181674-7-ammar.faizi@students.amikom.ac.id>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211006144911.1181674-1-ammar.faizi@students.amikom.ac.id>
References: <20211006144911.1181674-1-ammar.faizi@students.amikom.ac.id>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Cc: Bedirhan KURT <windowz414@gnuweeb.org>
Cc: Louvian Lyndal <louvianlyndal@gmail.com>
Signed-off-by: Ammar Faizi <ammar.faizi@students.amikom.ac.id>
---
 src/queue.c    | 15 +++------------
 src/register.c | 13 +++----------
 src/setup.c    | 14 +++-----------
 3 files changed, 9 insertions(+), 33 deletions(-)

diff --git a/src/queue.c b/src/queue.c
index cd76048..eb0c736 100644
--- a/src/queue.c
+++ b/src/queue.c
@@ -1,20 +1,11 @@
 /* SPDX-License-Identifier: MIT */
 #define _POSIX_C_SOURCE 200112L
 
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <sys/mman.h>
-#include <unistd.h>
-#include <string.h>
-#include <stdbool.h>
-
-#include "liburing/compat.h"
-#include "liburing/io_uring.h"
-#include "liburing.h"
-#include "liburing/barrier.h"
-
 #include "lib.h"
 #include "syscall.h"
+#include "liburing.h"
+#include "liburing/compat.h"
+#include "liburing/io_uring.h"
 
 /*
  * Returns true if we're not using SQ thread (thus nobody submits but us)
diff --git a/src/register.c b/src/register.c
index f8e88cf..1f2c409 100644
--- a/src/register.c
+++ b/src/register.c
@@ -1,19 +1,12 @@
 /* SPDX-License-Identifier: MIT */
 #define _POSIX_C_SOURCE 200112L
 
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <sys/mman.h>
-#include <sys/resource.h>
-#include <unistd.h>
-#include <string.h>
-
+#include "lib.h"
+#include "syscall.h"
+#include "liburing.h"
 #include "liburing/compat.h"
 #include "liburing/io_uring.h"
-#include "liburing.h"
 
-#include "lib.h"
-#include "syscall.h"
 
 int io_uring_register_buffers_update_tag(struct io_uring *ring, unsigned off,
 					 const struct iovec *iovecs,
diff --git a/src/setup.c b/src/setup.c
index 0f64a35..083b685 100644
--- a/src/setup.c
+++ b/src/setup.c
@@ -1,19 +1,11 @@
 /* SPDX-License-Identifier: MIT */
 #define _DEFAULT_SOURCE
 
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <unistd.h>
-#include <string.h>
-#include <stdlib.h>
-#include <signal.h>
-
-#include "liburing/compat.h"
-#include "liburing/io_uring.h"
-#include "liburing.h"
-
 #include "lib.h"
 #include "syscall.h"
+#include "liburing.h"
+#include "liburing/compat.h"
+#include "liburing/io_uring.h"
 
 static void io_uring_unmap_rings(struct io_uring_sq *sq, struct io_uring_cq *cq)
 {
-- 
2.30.2

