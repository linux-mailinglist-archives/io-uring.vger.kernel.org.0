Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1963F4B11AC
	for <lists+io-uring@lfdr.de>; Thu, 10 Feb 2022 16:29:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243614AbiBJP3o (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Feb 2022 10:29:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234557AbiBJP3n (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Feb 2022 10:29:43 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D1DCC5
        for <io-uring@vger.kernel.org>; Thu, 10 Feb 2022 07:29:45 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id v13-20020a17090ac90d00b001b87bc106bdso8862840pjt.4
        for <io-uring@vger.kernel.org>; Thu, 10 Feb 2022 07:29:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XReVY2xQtHetUZYvyEAVJNhsvn3U+rEGg4o8H/7DTLc=;
        b=Jlh8jCc2fq18b8yPUJsd2qBJb4Fdwb7OR+mzBaaIP1Jk5jw5hkbAcZy6I/XbHtRkOe
         7mlQ7ckygOGe/0FTs+3lXTKnDN5eSGFPmG4ZvloTITOpf+HLJoZ59Co229sPknHmQeCC
         wNAVX5rf1HyQE5JV0UxVQ31UBZVMr19vZ5N6zTUIRy9k99CkWKxd0DYyk2eeEk/vI8nN
         galsylQyIXHk1f1L7hLwUWDSgstMhPF5iJrBriihElB6Ks5/PWMt1l/LFLN4YuEvPD5c
         JYcPu/gxSyMz1LILKgX8inQHPpPhKniBsc5VBXhZY2owpJksYOTIasv8Ftu1u/lGb03o
         KB2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XReVY2xQtHetUZYvyEAVJNhsvn3U+rEGg4o8H/7DTLc=;
        b=zTQ3DeZRTu2CgH1THFXAEVdgYRQPC1maFSpJ7olxQrCSv+d21ofEix5DXkL2xN6tBH
         W4vFkHvFJLnZfcit+ldpvMBXfCYU3iodXWQz5AsJuNQMSKCTxLrDaw/Eyg47H6uyMRXo
         2K6FKBqKhP1o+rm+g4/LjS7d24zpLVPL3jiikI5mqeYzVAoJN6xHL3lOO7EJG9kOpEXe
         HwTw0G5bXtVjWetG55+YVk9qhqIe7IEsIg9kEr3TzwwVoPu5NyamD5CV5fW1Gt9v+WqO
         8aMZysQMgf9yDQzrxJDBPxV/kYbh1XlKN5bW1DL3nViPrsCaJTfN78J+vgpJsfhp8gIk
         2cXA==
X-Gm-Message-State: AOAM5304sEYw8ep1TjZuFoMckD9bW/Nv0oArYpfcRYttlgldrGJqXsxk
        N6hYF1/CbDfZH/ZmRF313jqPQSac83k=
X-Google-Smtp-Source: ABdhPJwaC32t5N7Que1odAMj/S7ZnJe4TkUmnp0rPmFcAUtF1yTXg3xmFSh4OIzZjF/HCQIkTQaeOQ==
X-Received: by 2002:a17:902:8215:: with SMTP id x21mr315423pln.10.1644506984288;
        Thu, 10 Feb 2022 07:29:44 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:850b:c1e2:34a1:2aa4])
        by smtp.gmail.com with ESMTPSA id c8sm24844022pfv.57.2022.02.10.07.29.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 07:29:43 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH] Fix __io_uring_get_cqe() for IORING_SETUP_IOPOLL
Date:   Fri, 11 Feb 2022 00:29:24 +0900
Message-Id: <20220210152924.14413-1-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.25.1
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

If __io_uring_get_cqe() is called for the ring setup with IOPOLL, we must enter the kernel
to get completion events. Even if that is called with wait_nr is zero.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 src/queue.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/src/queue.c b/src/queue.c
index eb0c736..f8384d1 100644
--- a/src/queue.c
+++ b/src/queue.c
@@ -31,6 +31,11 @@ static inline bool cq_ring_needs_flush(struct io_uring *ring)
 	return IO_URING_READ_ONCE(*ring->sq.kflags) & IORING_SQ_CQ_OVERFLOW;
 }
 
+static inline bool cq_ring_needs_enter(struct io_uring *ring)
+{
+	return (ring->flags & IORING_SETUP_IOPOLL) || cq_ring_needs_flush(ring);
+}
+
 static int __io_uring_peek_cqe(struct io_uring *ring,
 			       struct io_uring_cqe **cqe_ptr,
 			       unsigned *nr_available)
@@ -84,7 +89,6 @@ static int _io_uring_get_cqe(struct io_uring *ring, struct io_uring_cqe **cqe_pt
 
 	do {
 		bool need_enter = false;
-		bool cq_overflow_flush = false;
 		unsigned flags = 0;
 		unsigned nr_available;
 		int ret;
@@ -93,13 +97,13 @@ static int _io_uring_get_cqe(struct io_uring *ring, struct io_uring_cqe **cqe_pt
 		if (err)
 			break;
 		if (!cqe && !data->wait_nr && !data->submit) {
-			if (!cq_ring_needs_flush(ring)) {
+			if (!cq_ring_needs_enter(ring)) {
 				err = -EAGAIN;
 				break;
 			}
-			cq_overflow_flush = true;
+			need_enter = true;
 		}
-		if (data->wait_nr > nr_available || cq_overflow_flush) {
+		if (data->wait_nr > nr_available || need_enter) {
 			flags = IORING_ENTER_GETEVENTS | data->get_flags;
 			need_enter = true;
 		}
-- 
2.25.1

