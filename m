Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E18154E141
	for <lists+io-uring@lfdr.de>; Thu, 16 Jun 2022 14:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233379AbiFPM6q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jun 2022 08:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233280AbiFPM6p (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jun 2022 08:58:45 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD55934655
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 05:58:43 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id o7so2652590eja.1
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 05:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6AYfqcfmJ4itm1Y6HT6AlVE9aUis5Xusf4ZdczQWYN4=;
        b=S3d9NrV8e3QYu/Z1G9RiijHKXaWwmTluY3CRqPuW402vXsKRfZTZaHmt93mBlspAaB
         FkZ5MC9NewJyaHd5WnknRfMI1uZwWi1Z3QILiFXDWVKUX7p9LpnTXFbqJKBDHQuPlVMB
         avTiV2DGUql6xk/DHNpJ4fGiL9sVnQbokGKYlpdFsEx4eMsGdHc1XLk0uxl0kuOvbzdU
         h9oGuOYY5cavsZD2sYSIG3D0yIPvOvmwnBTOWn66ZgaBIuco7F6gEG11VBckqKOFiNeX
         WhpKzf/gjEuyUyLPn5U6DTIuIh8BThdd+1d2khOpVmih2cK81ayuFhk9KlLeJidFM4q0
         hL2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6AYfqcfmJ4itm1Y6HT6AlVE9aUis5Xusf4ZdczQWYN4=;
        b=rrWmdW8CMpPrR3bdApZb6p2Hq2w5RxLxkvVtYjz8S1dtFE4p5NoD/gUUHp+jI7Bhgs
         Rhv3QZ1MWk5JjFukYnnilOMKuP30tCrB6QRjl9cKDoeHjDQwtbci7ROgxPYnd+83orQO
         Z6kcsNuGzZTKzdUgbu4x4uwwOmiXrLv4smTdxlokGQ3vANPaEUN1q4zh5TqkCqZdsJLQ
         rDFOYNtJPWVoBSvBJWoWbGFTqyxpTECa2mYLKGovZ70zUoqBUrAkeyNInxFLO9ScBcdi
         PQrulD/mCcsytJUozK1ty0gvj9LOnWLLrbOLr03LhLCPqZcvXsdzwD4aO79H/WNYZyk7
         b6yg==
X-Gm-Message-State: AJIora9EAeELZ4+efa7tZWpOK1I6/KXd4l89or3Rq6x83A47vpds46p/
        VsIOeyUzokugKDXNVd26QRfGXbEdmCHgVg==
X-Google-Smtp-Source: AGRyM1tcC3wyicOGToxIbaIdj2JTa7rn85x4oyBsXvx4AOHwkPVBRs9mOdPfcmqVa59Pv3Jk1UzAfg==
X-Received: by 2002:a17:907:9958:b0:6e7:f67a:a1e7 with SMTP id kl24-20020a170907995800b006e7f67aa1e7mr4287962ejc.400.1655384321965;
        Thu, 16 Jun 2022 05:58:41 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c093:600::1:139d])
        by smtp.gmail.com with ESMTPSA id j17-20020a17090623f100b00711d5baae0esm746896ejg.145.2022.06.16.05.58.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 05:58:41 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 1/3] io_uring: kill extra io_uring_types.h includes
Date:   Thu, 16 Jun 2022 13:57:18 +0100
Message-Id: <94d8c943fbe0ef949981c508ddcee7fc1c18850f.1655384063.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655384063.git.asml.silence@gmail.com>
References: <cover.1655384063.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_uring/io_uring.h already includes io_uring_types.h, no need to
include it every time. Kill it in a bunch of places, it prepares us for
following patches.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/advise.c    | 1 -
 io_uring/cancel.c    | 1 -
 io_uring/epoll.c     | 1 -
 io_uring/fdinfo.c    | 1 -
 io_uring/filetable.c | 1 -
 io_uring/fs.c        | 1 -
 io_uring/io_uring.c  | 1 -
 io_uring/kbuf.c      | 1 -
 io_uring/msg_ring.c  | 1 -
 io_uring/net.c       | 1 -
 io_uring/nop.c       | 1 -
 io_uring/opdef.c     | 1 -
 io_uring/openclose.c | 1 -
 io_uring/poll.c      | 1 -
 io_uring/rsrc.c      | 1 -
 io_uring/rw.c        | 1 -
 io_uring/splice.c    | 1 -
 io_uring/sqpoll.c    | 1 -
 io_uring/statx.c     | 1 -
 io_uring/sync.c      | 1 -
 io_uring/tctx.c      | 1 -
 io_uring/timeout.c   | 1 -
 io_uring/uring_cmd.c | 1 -
 io_uring/xattr.c     | 1 -
 24 files changed, 24 deletions(-)

diff --git a/io_uring/advise.c b/io_uring/advise.c
index 8870fdf66ffb..581956934c0b 100644
--- a/io_uring/advise.c
+++ b/io_uring/advise.c
@@ -11,7 +11,6 @@
 #include <uapi/linux/fadvise.h>
 #include <uapi/linux/io_uring.h>
 
-#include "io_uring_types.h"
 #include "io_uring.h"
 #include "advise.h"
 
diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index f07bfd27c98a..d1e7f5a955ab 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -10,7 +10,6 @@
 
 #include <uapi/linux/io_uring.h>
 
-#include "io_uring_types.h"
 #include "io_uring.h"
 #include "tctx.h"
 #include "poll.h"
diff --git a/io_uring/epoll.c b/io_uring/epoll.c
index 10853e8ed078..a8b794471d6b 100644
--- a/io_uring/epoll.c
+++ b/io_uring/epoll.c
@@ -9,7 +9,6 @@
 
 #include <uapi/linux/io_uring.h>
 
-#include "io_uring_types.h"
 #include "io_uring.h"
 #include "epoll.h"
 
diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index 344e7d90d557..61c35707a6cf 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -9,7 +9,6 @@
 
 #include <uapi/linux/io_uring.h>
 
-#include "io_uring_types.h"
 #include "io_uring.h"
 #include "sqpoll.h"
 #include "fdinfo.h"
diff --git a/io_uring/filetable.c b/io_uring/filetable.c
index e449ceb9a848..534e1a3c625d 100644
--- a/io_uring/filetable.c
+++ b/io_uring/filetable.c
@@ -9,7 +9,6 @@
 
 #include <uapi/linux/io_uring.h>
 
-#include "io_uring_types.h"
 #include "io_uring.h"
 #include "rsrc.h"
 #include "filetable.h"
diff --git a/io_uring/fs.c b/io_uring/fs.c
index aac1bc5255b0..0de4f549bb7d 100644
--- a/io_uring/fs.c
+++ b/io_uring/fs.c
@@ -12,7 +12,6 @@
 
 #include "../fs/internal.h"
 
-#include "io_uring_types.h"
 #include "io_uring.h"
 #include "fs.h"
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index d256a611be4e..6ade0ec91979 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -80,7 +80,6 @@
 
 #include "io-wq.h"
 
-#include "io_uring_types.h"
 #include "io_uring.h"
 #include "opdef.h"
 #include "refs.h"
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 223d9db2ba94..e8931e0b3e4a 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -10,7 +10,6 @@
 
 #include <uapi/linux/io_uring.h>
 
-#include "io_uring_types.h"
 #include "io_uring.h"
 #include "opdef.h"
 #include "kbuf.h"
diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 3b89f9a0a0b4..1f2de3534932 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -7,7 +7,6 @@
 
 #include <uapi/linux/io_uring.h>
 
-#include "io_uring_types.h"
 #include "io_uring.h"
 #include "msg_ring.h"
 
diff --git a/io_uring/net.c b/io_uring/net.c
index 207803758222..cd931dae1313 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -10,7 +10,6 @@
 
 #include <uapi/linux/io_uring.h>
 
-#include "io_uring_types.h"
 #include "io_uring.h"
 #include "kbuf.h"
 #include "net.h"
diff --git a/io_uring/nop.c b/io_uring/nop.c
index d363d8ce70a3..d956599a3c1b 100644
--- a/io_uring/nop.c
+++ b/io_uring/nop.c
@@ -7,7 +7,6 @@
 
 #include <uapi/linux/io_uring.h>
 
-#include "io_uring_types.h"
 #include "io_uring.h"
 #include "nop.h"
 
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 2b6d133d845a..a5478cbf742d 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -8,7 +8,6 @@
 #include <linux/file.h>
 #include <linux/io_uring.h>
 
-#include "io_uring_types.h"
 #include "io_uring.h"
 #include "opdef.h"
 #include "refs.h"
diff --git a/io_uring/openclose.c b/io_uring/openclose.c
index 1cbf39030970..099a5ec84dfd 100644
--- a/io_uring/openclose.c
+++ b/io_uring/openclose.c
@@ -12,7 +12,6 @@
 
 #include "../fs/internal.h"
 
-#include "io_uring_types.h"
 #include "io_uring.h"
 #include "rsrc.h"
 #include "openclose.h"
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 2e068e05732a..76828bce8653 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -13,7 +13,6 @@
 
 #include <uapi/linux/io_uring.h>
 
-#include "io_uring_types.h"
 #include "io_uring.h"
 #include "refs.h"
 #include "opdef.h"
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index fd1323482030..2f893e3f5c15 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -12,7 +12,6 @@
 
 #include <uapi/linux/io_uring.h>
 
-#include "io_uring_types.h"
 #include "io_uring.h"
 #include "openclose.h"
 #include "rsrc.h"
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 818692a83d75..f5567d52d2af 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -14,7 +14,6 @@
 
 #include <uapi/linux/io_uring.h>
 
-#include "io_uring_types.h"
 #include "io_uring.h"
 #include "opdef.h"
 #include "kbuf.h"
diff --git a/io_uring/splice.c b/io_uring/splice.c
index 0e19d6330345..b013ba34bffa 100644
--- a/io_uring/splice.c
+++ b/io_uring/splice.c
@@ -11,7 +11,6 @@
 
 #include <uapi/linux/io_uring.h>
 
-#include "io_uring_types.h"
 #include "io_uring.h"
 #include "splice.h"
 
diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 149d5c976f14..76d4d70c733a 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -14,7 +14,6 @@
 
 #include <uapi/linux/io_uring.h>
 
-#include "io_uring_types.h"
 #include "io_uring.h"
 #include "sqpoll.h"
 
diff --git a/io_uring/statx.c b/io_uring/statx.c
index 83b15687e9c5..6056cd7f4876 100644
--- a/io_uring/statx.c
+++ b/io_uring/statx.c
@@ -8,7 +8,6 @@
 
 #include "../fs/internal.h"
 
-#include "io_uring_types.h"
 #include "io_uring.h"
 #include "statx.h"
 
diff --git a/io_uring/sync.c b/io_uring/sync.c
index 9ee8ff865521..f2102afa79ca 100644
--- a/io_uring/sync.c
+++ b/io_uring/sync.c
@@ -11,7 +11,6 @@
 
 #include <uapi/linux/io_uring.h>
 
-#include "io_uring_types.h"
 #include "io_uring.h"
 #include "sync.h"
 
diff --git a/io_uring/tctx.c b/io_uring/tctx.c
index 012be261dc50..a3bfbe5b6b72 100644
--- a/io_uring/tctx.c
+++ b/io_uring/tctx.c
@@ -9,7 +9,6 @@
 
 #include <uapi/linux/io_uring.h>
 
-#include "io_uring_types.h"
 #include "io_uring.h"
 #include "tctx.h"
 
diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index 526fc8b2e3b6..f9df359813c9 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -8,7 +8,6 @@
 
 #include <uapi/linux/io_uring.h>
 
-#include "io_uring_types.h"
 #include "io_uring.h"
 #include "refs.h"
 #include "cancel.h"
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 5fb95767ceaf..233e137f8c6d 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -6,7 +6,6 @@
 
 #include <uapi/linux/io_uring.h>
 
-#include "io_uring_types.h"
 #include "io_uring.h"
 #include "uring_cmd.h"
 
diff --git a/io_uring/xattr.c b/io_uring/xattr.c
index 79adf4efba01..b179f9acd5ac 100644
--- a/io_uring/xattr.c
+++ b/io_uring/xattr.c
@@ -13,7 +13,6 @@
 
 #include "../fs/internal.h"
 
-#include "io_uring_types.h"
 #include "io_uring.h"
 #include "xattr.h"
 
-- 
2.36.1

