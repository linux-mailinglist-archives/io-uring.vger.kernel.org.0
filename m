Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2400619515
	for <lists+io-uring@lfdr.de>; Fri,  4 Nov 2022 12:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231876AbiKDLDR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 4 Nov 2022 07:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231916AbiKDLCf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 4 Nov 2022 07:02:35 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA3C62C65A
        for <io-uring@vger.kernel.org>; Fri,  4 Nov 2022 04:02:34 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id l11so7060824edb.4
        for <io-uring@vger.kernel.org>; Fri, 04 Nov 2022 04:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s7kMLHKuOOjs0FBY3ISWz8diaVZj6jaS7ZiegJtMLHc=;
        b=TOSESZB9Goyu6yYbab0Nrrk6t0nTmhn7oVq1k7hEz+ljdfLT8jRVl9YUXxronVLtAW
         ucBtyGrVN4p1soWRH83IOhp2R27hsPDq9aYtbOGW/NIYOysIyJpNlqGEgNYWE8tLcTKy
         k3h1dfTsvjM4D4Z17jcaHaJQns3UDUXvhENVuL5w9ak7jpee82BJyKTWat/8wRt9WN17
         u60o3PNWMB4STCGrqGIl0+CXA+r+XXhUw2s+uUKq6cZM9kI1PJ+iVdT79C9uM/Z0GlbM
         OggYNk4PLrv9D4vtKBvAjU3h1Gj8XNiST7gvQ6qUJXbIsFUev16tQEyVXK/IZDZXmAuT
         iOOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s7kMLHKuOOjs0FBY3ISWz8diaVZj6jaS7ZiegJtMLHc=;
        b=Jypu5K9oy6Z9EY9G5AgkSgkm86aHe0ZMwoMJ+XLiU0ePAJFwAWPmKthFx4CppI/6eB
         2/vtU4zv2d7ibLrQb9ETQ6itVMzbQDrW1DCSQPMHpYxz63rAr945tYxkupJrE9svwWB8
         ZC6U5LdOIyjqWrxTuvycNIElSyLQeVKV6slGlMrH56erFNfx+92WRYsr5ZMz9JL+03fo
         fTVsf197h9zu/IDb1K0gRDjN0x5neDAvXsEpPARtDXBxQBHA6fh95tdRcTmmoT6EJIoN
         CPbYlD5bZ65KGn8RSKh8qE4jMeCzYjRFp+COLi2Towgc7E+4IzYef+o98JIHdHjjtb3m
         A32A==
X-Gm-Message-State: ACrzQf3QBNEgE537DqJxP5rx60aTguOIgB5HSdA6NB+UOY27Hqzw83ja
        wzcg0ZM+BSYGOv/RaMGYaQDNjXZ/2E4=
X-Google-Smtp-Source: AMsMyM6EaUNSWJZFzxePXCVUQ6o6Rf8oU8RX3/CTYN9NGMphW3ioaVOriClcJ7xngVat62hOiZtBjA==
X-Received: by 2002:a05:6402:5024:b0:440:e4ad:f7b6 with SMTP id p36-20020a056402502400b00440e4adf7b6mr7274313eda.358.1667559752828;
        Fri, 04 Nov 2022 04:02:32 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:4173])
        by smtp.gmail.com with ESMTPSA id u25-20020aa7db99000000b00458947539desm1757768edt.78.2022.11.04.04.02.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 04:02:32 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 5/7] io_uring/net: inline io_notif_flush()
Date:   Fri,  4 Nov 2022 10:59:44 +0000
Message-Id: <332359e7bd124138dfe51340bbec829c9b265c18.1667557923.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <cover.1667557923.git.asml.silence@gmail.com>
References: <cover.1667557923.git.asml.silence@gmail.com>
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

io_notif_flush() is pretty simple, we can inline it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/notif.c | 10 ----------
 io_uring/notif.h | 11 ++++++++++-
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/io_uring/notif.c b/io_uring/notif.c
index 5b0e7bb1198f..c287adf24e66 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -67,13 +67,3 @@ struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx)
 	refcount_set(&nd->uarg.refcnt, 1);
 	return notif;
 }
-
-void io_notif_flush(struct io_kiocb *notif)
-	__must_hold(&slot->notif->ctx->uring_lock)
-{
-	struct io_notif_data *nd = io_notif_to_data(notif);
-
-	/* drop slot's master ref */
-	if (refcount_dec_and_test(&nd->uarg.refcnt))
-		io_req_task_work_add(notif);
-}
diff --git a/io_uring/notif.h b/io_uring/notif.h
index 4ae696273c78..7f00176020d3 100644
--- a/io_uring/notif.h
+++ b/io_uring/notif.h
@@ -18,7 +18,6 @@ struct io_notif_data {
 	bool			zc_copied;
 };
 
-void io_notif_flush(struct io_kiocb *notif);
 struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx);
 
 static inline struct io_notif_data *io_notif_to_data(struct io_kiocb *notif)
@@ -26,6 +25,16 @@ static inline struct io_notif_data *io_notif_to_data(struct io_kiocb *notif)
 	return io_kiocb_to_cmd(notif, struct io_notif_data);
 }
 
+static inline void io_notif_flush(struct io_kiocb *notif)
+	__must_hold(&notif->ctx->uring_lock)
+{
+	struct io_notif_data *nd = io_notif_to_data(notif);
+
+	/* drop slot's master ref */
+	if (refcount_dec_and_test(&nd->uarg.refcnt))
+		io_req_task_work_add(notif);
+}
+
 static inline int io_notif_account_mem(struct io_kiocb *notif, unsigned len)
 {
 	struct io_ring_ctx *ctx = notif->ctx;
-- 
2.38.0

