Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DFA457FE6B
	for <lists+io-uring@lfdr.de>; Mon, 25 Jul 2022 13:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234723AbiGYLeh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Jul 2022 07:34:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbiGYLeh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Jul 2022 07:34:37 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B3701A051
        for <io-uring@vger.kernel.org>; Mon, 25 Jul 2022 04:34:36 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id h8so15531804wrw.1
        for <io-uring@vger.kernel.org>; Mon, 25 Jul 2022 04:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=flrSSD/oqDeoR+pcufA+loQzl8ORR4uaVTkm5ef3tSc=;
        b=AsTHf9Wm5mW83H8f1RMaOJXs/bvqCY5ZnQtdHjyE4CkPkYD9oKjHmY2txta3xWNw0n
         GwA8q9jUR8kEKATHWfJCv9LfKO0WKE6KJx/fezY15n2V0GV2UZhI/tJif6ef2azK0+Ih
         x6SGl2LqAvGjqFj7zP+qygTwDi3thMDGCNdr7myNvI+64ZTCfGqnjtxbD3Ilmi/bZ6Qz
         vqp/N+cPda1C0Sml+T1SHOsUX7HBE6EDabIvMs6/xP44e1Hjhfgzi2RFaBv8di/QalJo
         6UMRa2QGWLHTgQNJXp4Tj6eF9MI/7dIFmK/JM1ZDZwU7cbkIjmtmqbxLu06LPLHky5cZ
         DHLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=flrSSD/oqDeoR+pcufA+loQzl8ORR4uaVTkm5ef3tSc=;
        b=SM0HzEyqg4KDSiEWbSPUNHHVLump8+nCLpmSvM/Fag2CGJ0yYQOwvQoKR/OWjKE5y3
         Q+wLsameP0hGRKZKm5j5qXtKfetB1uh/TJcXadmK5TSsk64TdDPtq7jd/CvH3rsDyyOr
         ukm1Ph6oxCRwNgVcFaUOTzSgga5EzIoiPZr8z62lWD8yEespj2lpM1Q28ho36Be4trHq
         UUvKw+cMabtyA4aGawrQKNA9CFQTOasYs4ZY1cM3n1KFlDGb75mH8e8pUvyudwpEu1JS
         76HUepjV8QvvgHHu1niHmTi2/gUB2xfhhUcN+Omf9rYgiIVAEvOZY3uI2fKsuYuly+jV
         PC/w==
X-Gm-Message-State: AJIora+Y0h5/WroTe6xPcKa5V+7XYbyhky8Mo0BEAFeI8TfXHfCzc8Xj
        NUg10n1wx5a2iWNagwtpUUcNrKRqlQFGIg==
X-Google-Smtp-Source: AGRyM1s3KAKBGfRq4FGCxQpaKenZ3ftPUdvcQWle8cJ2DHPxfyz6U0In7KIWbHucAE1I3vD1AFR4NA==
X-Received: by 2002:a05:6000:1f0d:b0:21e:927e:d440 with SMTP id bv13-20020a0560001f0d00b0021e927ed440mr1336227wrb.621.1658748874309;
        Mon, 25 Jul 2022 04:34:34 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c093:600::1:9f35])
        by smtp.gmail.com with ESMTPSA id e29-20020a5d595d000000b0021e501519d3sm11659991wri.67.2022.07.25.04.34.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 04:34:33 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH liburing v2 1/5] io_uring.h: sync with kernel for zc send and notifiers
Date:   Mon, 25 Jul 2022 12:33:18 +0100
Message-Id: <75b424869b9dad220d425693a43ec5ae97e5b8e8.1658748624.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <cover.1658748623.git.asml.silence@gmail.com>
References: <cover.1658748623.git.asml.silence@gmail.com>
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

