Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A271D57FCEB
	for <lists+io-uring@lfdr.de>; Mon, 25 Jul 2022 12:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233325AbiGYKFQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Jul 2022 06:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234508AbiGYKFP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Jul 2022 06:05:15 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0368E2AD6
        for <io-uring@vger.kernel.org>; Mon, 25 Jul 2022 03:05:12 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id h8so15216081wrw.1
        for <io-uring@vger.kernel.org>; Mon, 25 Jul 2022 03:05:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VDC7Zr+G3EzXARNEMbmPQH2N/3IHzVaWTsIyQTl4WoA=;
        b=HGs5UgtBpzfotoIfe1LdPDT6s/HqY0PTgSuR5c6Q41R2frNKVZBEWdNbK8yNeH4WBJ
         HlSdOMKIeQrPboLNhUPL2IYOvi7oitzKpoUwKFMYUbzlo0KIWeIMP3REsEuZeaJxUnOf
         3TB8DpZumeBrPJYoBNOdLtimQVb+3Shl6ZzTdSBpnWD+xoTD3eP5J7Z1fMh8HjZMcnep
         l9QtL9g/3Ta+czs7C7NF4j2H5XwCDKNiPJXFkpgdxq30R3/puqTFcZceTnP1OsnvGeLF
         Z1wi7wsZp5xTtTvUf0ArBry1WDx6aGJns8aWs9H5wv4AK/dd/rH0uF+2DNbjtO2+TgD9
         SbsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VDC7Zr+G3EzXARNEMbmPQH2N/3IHzVaWTsIyQTl4WoA=;
        b=kys8i36gIlcaxW17Wmdvq/x77a/qeiVsrU88pKCn7240SpAcb0Tgtk4Mwv5o7i48K9
         gI9Xm1j3NzA7f4vEHa84Vxbj24kRDPujLGWR/fHsoenMnGODd0dtDm4jRdqjKB6EwKS/
         1FooPA/AZIn9Uc9wGvIpYfU+1n5UwORhegKkKJ8ofqCTGtTN/XEua5/xafVmPtpsFXBY
         wa/LwSNzOugkMRgNM63ENmtaWFdxSL2n5J6RDV89R6VVA2s/MDOw5vUF1FxDNneyR34i
         9itdgQs4xL/Orp68ZsdqGcfjNsTKEeziIenOmLRYrUQOXX0nf2C2Bnlsw0PwIywH9zys
         5brA==
X-Gm-Message-State: AJIora+nrlr3Pz9Sm9/++CqsMPl1XJ6YA1harriZNbZl5l8i2xzOx5s/
        S00YqAaEFtqMGtw4KPOzSeImyPuCJC4SWw==
X-Google-Smtp-Source: AGRyM1tYq6eKIip/qLkowrXSrYZkm52MDAAT7q1IMHP/aiLnbai81UhY67Qn3iiUD3CHwWJrPg+duw==
X-Received: by 2002:a5d:5a83:0:b0:21e:2adc:e381 with SMTP id bp3-20020a5d5a83000000b0021e2adce381mr7061313wrb.703.1658743510884;
        Mon, 25 Jul 2022 03:05:10 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c093:600::1:9f35])
        by smtp.gmail.com with ESMTPSA id j23-20020a05600c1c1700b003a32251c3f9sm20553959wms.5.2022.07.25.03.05.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 03:05:10 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 2/4] liburing: add zc send and notif helpers
Date:   Mon, 25 Jul 2022 11:03:55 +0100
Message-Id: <7f705b208e5f7baa6ee94904e39d3d0da2e28150.1658743360.git.asml.silence@gmail.com>
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

Add helpers for notification registration and preparing zerocopy send
requests.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/include/liburing.h | 41 +++++++++++++++++++++++++++++++++++++++++
 src/liburing.map       |  2 ++
 src/register.c         | 20 ++++++++++++++++++++
 3 files changed, 63 insertions(+)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index fc7613d..f3c5887 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -189,6 +189,10 @@ int io_uring_register_sync_cancel(struct io_uring *ring,
 int io_uring_register_file_alloc_range(struct io_uring *ring,
 					unsigned off, unsigned len);
 
+int io_uring_register_notifications(struct io_uring *ring, unsigned nr,
+				    struct io_uring_notification_slot *slots);
+int io_uring_unregister_notifications(struct io_uring *ring);
+
 /*
  * Helper for the peek/wait single cqe functions. Exported because of that,
  * but probably shouldn't be used directly in an application.
@@ -677,6 +681,43 @@ static inline void io_uring_prep_send(struct io_uring_sqe *sqe, int sockfd,
 	sqe->msg_flags = (__u32) flags;
 }
 
+static inline void io_uring_prep_sendzc(struct io_uring_sqe *sqe, int sockfd,
+				        const void *buf, size_t len, int flags,
+				        unsigned slot_idx, unsigned zc_flags)
+{
+	io_uring_prep_rw(IORING_OP_SENDZC_NOTIF, sqe, sockfd, buf, (__u32) len, 0);
+	sqe->msg_flags = (__u32) flags;
+	sqe->notification_idx = slot_idx;
+	sqe->ioprio = zc_flags;
+}
+
+static inline void io_uring_prep_sendzc_fixed(struct io_uring_sqe *sqe, int sockfd,
+					      const void *buf, size_t len,
+					      int flags, unsigned slot_idx,
+					      unsigned zc_flags, unsigned buf_idx)
+{
+	io_uring_prep_sendzc(sqe, sockfd, buf, len, flags, slot_idx, zc_flags);
+	sqe->ioprio |= IORING_RECVSEND_FIXED_BUF;
+	sqe->buf_index = buf_idx;
+}
+
+static inline void io_uring_prep_sendzc_set_addr(struct io_uring_sqe *sqe,
+						 const struct sockaddr *dest_addr,
+						 __u16 addr_len)
+{
+	sqe->addr2 = (unsigned long)(void *)dest_addr;
+	sqe->addr_len = addr_len;
+}
+
+static inline void io_uring_prep_notif_update(struct io_uring_sqe *sqe,
+					      __u64 new_tag, /* 0 to ignore */
+					      unsigned offset, unsigned nr)
+{
+	io_uring_prep_rw(IORING_OP_FILES_UPDATE, sqe, -1, (void *)new_tag, nr,
+			 (__u64)offset);
+	sqe->ioprio = IORING_RSRC_UPDATE_NOTIF;
+}
+
 static inline void io_uring_prep_recv(struct io_uring_sqe *sqe, int sockfd,
 				      void *buf, size_t len, int flags)
 {
diff --git a/src/liburing.map b/src/liburing.map
index 318d3d7..7d8f143 100644
--- a/src/liburing.map
+++ b/src/liburing.map
@@ -60,4 +60,6 @@ LIBURING_2.3 {
 	global:
 		io_uring_register_sync_cancel;
 		io_uring_register_file_alloc_range;
+		io_uring_register_notifications;
+		io_uring_unregister_notifications;
 } LIBURING_2.2;
diff --git a/src/register.c b/src/register.c
index 2b37e5f..7482112 100644
--- a/src/register.c
+++ b/src/register.c
@@ -364,3 +364,23 @@ int io_uring_register_file_alloc_range(struct io_uring *ring,
 				       IORING_REGISTER_FILE_ALLOC_RANGE, &range,
 				       0);
 }
+
+int io_uring_register_notifications(struct io_uring *ring, unsigned nr,
+				    struct io_uring_notification_slot *slots)
+{
+	struct io_uring_notification_register r = {
+		.nr_slots = nr,
+		.data = (unsigned long)slots,
+	};
+
+	return __sys_io_uring_register(ring->ring_fd,
+				       IORING_REGISTER_NOTIFIERS,
+				       &r, sizeof(r));
+}
+
+int io_uring_unregister_notifications(struct io_uring *ring)
+{
+	return __sys_io_uring_register(ring->ring_fd,
+				       IORING_UNREGISTER_NOTIFIERS,
+				       NULL, 0);
+}
-- 
2.37.0

