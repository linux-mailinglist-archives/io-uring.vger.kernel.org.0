Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95E0057FCEA
	for <lists+io-uring@lfdr.de>; Mon, 25 Jul 2022 12:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234497AbiGYKFL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Jul 2022 06:05:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234528AbiGYKFJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Jul 2022 06:05:09 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CDD4BD1
        for <io-uring@vger.kernel.org>; Mon, 25 Jul 2022 03:05:07 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id i205-20020a1c3bd6000000b003a2fa488efdso3266779wma.4
        for <io-uring@vger.kernel.org>; Mon, 25 Jul 2022 03:05:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=flrSSD/oqDeoR+pcufA+loQzl8ORR4uaVTkm5ef3tSc=;
        b=dvhri4wW1Mpyf0W/enNeSPw6zUlGtDQJEPrgN4HdAj1XKDSbaNbTOa65Pe6Iu7il8u
         GeGW2JcyewNhtN/BhYv5e81ycALbfNrcKdDtLn43rLIy+M3ysKLiWqj6YOv5/M4Wpk/U
         9GFHgDaF+Di+ljVXvafh+eXUvvBOh3TJreZWuliWpdjiz2M9VtQ/pM9Id33L0T56waA8
         g6ZoOJaOxCu6/dw3nZ5lgq6G4iCTPBTWnjv2vYY79e8X3c+BPGpp5d5q22A0VDDhQZyQ
         MMTLK6DoLoS0iLCkzsU0km48bD9GAW0CqzQXDrbMTjr48Eed7035PdOuodirrNEF3Boy
         8mfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=flrSSD/oqDeoR+pcufA+loQzl8ORR4uaVTkm5ef3tSc=;
        b=rtAc2eIF6l5Q/oHe25DtMMzujYe30ZlWM1AFdF/bhxjqAwWGwpKUQArQ9bIfMcxrVa
         rN/S66eS9ky/swvLggWNk2OMb6zrsnkA9SEopy2sp8k4PB4nFaNPN7xyztsmVw7LOdRG
         RijPqj7vxV8fCc4zWzUPcXl3okCH2CkhJPOOoVbkZaUvFxCeGSqeeYuU05fw+W8qficM
         aIuVnNCZjELe++QzEexuFDKPqzpcW3icDeZih5bvP/dHIq6ZkDlDZSEYNP+W9f+fLmkH
         acJIh6Q0QdHyDQgcvQg5K6icIBzKynUL78mePfJJaQ1tUS5DSdcO0hJD06ZoWOD/jRe6
         db4A==
X-Gm-Message-State: AJIora/UDMONOyviwnpTgW7B1Y01RmdimiqvyORGC8tNvW0PvjF3uv2/
        n6na4Z4WzZdwolBqQpDKROKLl+IiSYxHCg==
X-Google-Smtp-Source: AGRyM1tpImtwfln773EVhIYv1LAqSnFIJugQIQUmj5WxkcBH+kyio09JO1XHWOGjlEH97xLMfPgdEA==
X-Received: by 2002:a7b:ce0a:0:b0:3a3:1adf:af34 with SMTP id m10-20020a7bce0a000000b003a31adfaf34mr7745592wmc.127.1658743505011;
        Mon, 25 Jul 2022 03:05:05 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c093:600::1:9f35])
        by smtp.gmail.com with ESMTPSA id j23-20020a05600c1c1700b003a32251c3f9sm20553959wms.5.2022.07.25.03.05.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 03:05:04 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 1/4] io_uring.h: sync with kernel for zc send and notifiers
Date:   Mon, 25 Jul 2022 11:03:54 +0100
Message-Id: <75b424869b9dad220d425693a43ec5ae97e5b8e8.1658743360.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <cover.1658743360.git.asml.silence@gmail.com>
References: <cover.1658743360.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/include/liburing/io_uring.h | 37 +++++++++++++++++++++++++++++++--
 1 file changed, 35 insertions(+), 2 deletions(-)

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 99e6963..3953807 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -64,6 +64,10 @@ struct io_uring_sqe {
 	union {
 		__s32	splice_fd_in;
 		__u32	file_index;
+		struct {
+			__u16	notification_idx;
+			__u16	addr_len;
+		};
 	};
 	__u64	addr3;
 	__u64	__pad2[1];
@@ -160,7 +164,8 @@ enum io_uring_op {
 	IORING_OP_FALLOCATE,
 	IORING_OP_OPENAT,
 	IORING_OP_CLOSE,
-	IORING_OP_FILES_UPDATE,
+	IORING_OP_RSRC_UPDATE,
+	IORING_OP_FILES_UPDATE = IORING_OP_RSRC_UPDATE,
 	IORING_OP_STATX,
 	IORING_OP_READ,
 	IORING_OP_WRITE,
@@ -187,6 +192,7 @@ enum io_uring_op {
 	IORING_OP_GETXATTR,
 	IORING_OP_SOCKET,
 	IORING_OP_URING_CMD,
+	IORING_OP_SENDZC_NOTIF,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
@@ -208,6 +214,7 @@ enum io_uring_op {
 #define IORING_TIMEOUT_ETIME_SUCCESS	(1U << 5)
 #define IORING_TIMEOUT_CLOCK_MASK	(IORING_TIMEOUT_BOOTTIME | IORING_TIMEOUT_REALTIME)
 #define IORING_TIMEOUT_UPDATE_MASK	(IORING_TIMEOUT_UPDATE | IORING_LINK_TIMEOUT_UPDATE)
+
 /*
  * sqe->splice_flags
  * extends splice(2) flags
@@ -254,13 +261,23 @@ enum io_uring_op {
  *				CQEs on behalf of the same SQE.
  */
 #define IORING_RECVSEND_POLL_FIRST	(1U << 0)
-#define IORING_RECV_MULTISHOT	(1U << 1)
+#define IORING_RECV_MULTISHOT		(1U << 1)
+#define IORING_RECVSEND_FIXED_BUF	(1U << 2)
+#define IORING_RECVSEND_NOTIF_FLUSH	(1U << 3)
 
 /*
  * accept flags stored in sqe->ioprio
  */
 #define IORING_ACCEPT_MULTISHOT	(1U << 0)
 
+/*
+ * IORING_OP_RSRC_UPDATE flags
+ */
+enum {
+	IORING_RSRC_UPDATE_FILES,
+	IORING_RSRC_UPDATE_NOTIF,
+};
+
 /*
  * IO completion data structure (Completion Queue Entry)
  */
@@ -426,6 +443,9 @@ enum {
 	/* register a range of fixed file slots for automatic slot allocation */
 	IORING_REGISTER_FILE_ALLOC_RANGE	= 25,
 
+	IORING_REGISTER_NOTIFIERS		= 26,
+	IORING_UNREGISTER_NOTIFIERS		= 27,
+
 	/* this goes last */
 	IORING_REGISTER_LAST
 };
@@ -472,6 +492,19 @@ struct io_uring_rsrc_update2 {
 	__u32 resv2;
 };
 
+struct io_uring_notification_slot {
+	__u64 tag;
+	__u64 resv[3];
+};
+
+struct io_uring_notification_register {
+	__u32 nr_slots;
+	__u32 resv;
+	__u64 resv2;
+	__u64 data;
+	__u64 resv3;
+};
+
 /* Skip updating fd indexes set to this value in the fd table */
 #define IORING_REGISTER_FILES_SKIP	(-2)
 
-- 
2.37.0

