Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBDF57FE6C
	for <lists+io-uring@lfdr.de>; Mon, 25 Jul 2022 13:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234327AbiGYLei (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Jul 2022 07:34:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbiGYLei (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Jul 2022 07:34:38 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 271D718B3F
        for <io-uring@vger.kernel.org>; Mon, 25 Jul 2022 04:34:37 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id q18so5105831wrx.8
        for <io-uring@vger.kernel.org>; Mon, 25 Jul 2022 04:34:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aHcYq1k/ljRYj0PQhz7OPPTH7eSinoIjjdGQ8BjNjIg=;
        b=mlZLyIhDdPcobGMN640o0ymvzG9b0lxJZPLaubQJGMs7xJIwpztSxxEgjV1x9W6Vqy
         iqljiL5B6B3+Iq7NflUOfH/anXfkyLtF1a0lhRTQV2jSnVkSVAROL9Hp2Z6A2D8FGf0K
         z7KQORXQAaG9xYeWIlZRGIP9JzX9zmiwCGAPfpS853D3xoG0iHVsTOqz/WaG7UAth7WF
         WIxSoF9FOwT5t2SB2m+27LciraXVO30Lc7iXKWk0Gg+dAbJ755VYBlXndWMIgTEEgKaJ
         LMf4EDYlP91unItACbupKQoJOpyM/LWUOrEtEMYGYd0rZ/hEwTlo1QBs6YSIrxJHj8xW
         dHKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aHcYq1k/ljRYj0PQhz7OPPTH7eSinoIjjdGQ8BjNjIg=;
        b=3fGhVz1pFHsPNbSGc2Wlj5VWLUnxlsbY+/p8q0YA+zEnWSSd9oPKcqR2bSvlyca6iP
         h3qPNCdzU+m57YnUyFwczKhkiaIm6qKBKGIoBsw72oMVnoTE5VtVZKM2k1IqRotD6Aqm
         IQVGW/V2gHs7lRKwvuvacX3pTaZsmFMm3Wnl2QINXTjpSMmlYiNHTYINZK9JCAas84Ct
         lzT0duifMx9+BqbVDhPhucuIafB80RKqRZ8mdarunmeQImSl1tJelbFiMhf0/b+bcq0v
         ymdByXlPmrQvgcx5DNZPHnhQ4g6yeFIOU8wjq8t4SB8jx59tljDqv1fXzR3sJiOXt6Kw
         qyJg==
X-Gm-Message-State: AJIora9W37iANJDspEDrD072y717griEftUmU7X5xC/wRcoGBomuSumu
        TppHt46XcOxXC9uUFsAhD/+BgbSm67gMyQ==
X-Google-Smtp-Source: AGRyM1u/y52klHAnfnR6ykbytLlEFXRnosTBT0bIeJtmiF/gfWB8WQ5qjdjg8E2pAdLHpsjYyMS53Q==
X-Received: by 2002:a05:6000:1086:b0:21e:72d9:96b3 with SMTP id y6-20020a056000108600b0021e72d996b3mr6577939wrw.170.1658748875301;
        Mon, 25 Jul 2022 04:34:35 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c093:600::1:9f35])
        by smtp.gmail.com with ESMTPSA id e29-20020a5d595d000000b0021e501519d3sm11659991wri.67.2022.07.25.04.34.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 04:34:34 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH liburing v2 2/5] liburing: add zc send and notif helpers
Date:   Mon, 25 Jul 2022 12:33:19 +0100
Message-Id: <b17478e75fc676260acf618b60cf31a85d8c3b06.1658748624.git.asml.silence@gmail.com>
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

Add helpers for notification registration and preparing zerocopy send
requests.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/include/liburing.h | 42 ++++++++++++++++++++++++++++++++++++++++++
 src/liburing.map       |  2 ++
 src/register.c         | 20 ++++++++++++++++++++
 3 files changed, 64 insertions(+)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index fc7613d..20cd308 100644
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
@@ -677,6 +681,44 @@ static inline void io_uring_prep_send(struct io_uring_sqe *sqe, int sockfd,
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
+	io_uring_prep_rw(IORING_OP_FILES_UPDATE, sqe, -1, 0, nr,
+			 (__u64)offset);
+	sqe->addr = new_tag;
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

