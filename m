Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A781559562C
	for <lists+io-uring@lfdr.de>; Tue, 16 Aug 2022 11:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbiHPJ1G (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Aug 2022 05:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbiHPJ0h (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Aug 2022 05:26:37 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D08289C218
        for <io-uring@vger.kernel.org>; Tue, 16 Aug 2022 00:43:22 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id dc19so17376200ejb.12
        for <io-uring@vger.kernel.org>; Tue, 16 Aug 2022 00:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=wli84RS/gEgVUPbgbSmPokmw5HWw7zXztjijpxFndag=;
        b=YGc6AtrlSXXfQQ3R53DijGTNZGi9D2+ne+e+V42k/w9tAz5nZGnkJ2e4FLX8rVOysN
         3svtZKya01pRivZ8HQKtDAF4dVSXyasEwQGDT4S4vbc1IMtco3kyghcSD7VgQLiyuR5c
         KbWZa5K4Aplb2WFquyTN7nt12IelZqVFFbbwFRlKCPtSQ+ijqTdZRguDNwrUIeDNkumR
         SDLNp3+mFyBIq6P5NrQrC11jec/2Q0JACYuMksAVNsAxjmRlh5JqkxJ1fcjqXOhEJDYb
         XPKdv0oVGK5ydqQ62Q7dkC5XwKQY9PdkMcI7sEl6OBGDNRsuXmeBpWo7FbOSw4v4804H
         uA6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=wli84RS/gEgVUPbgbSmPokmw5HWw7zXztjijpxFndag=;
        b=65r/65qpBc8WElUM37zvTah+Xek9lHSXlpzFxik0Q+9L5AQQvmNXbYpXrZxv9onYO7
         7BYd9YyFUupZ5pSRvnUMveoVp+PM8IMtEof76YR7RXn04jzQVc7nkqmGNnJxtBR23Nw+
         +VBhdqlXM7L9+JO61NBG2/fhOdD5YJCWCARkpWZ+Tveq8rMh7h+u0Sw4zJHsWR7IT8Nd
         Tv7jrffKIwG55hwbYjTRqLA69HHO26ZuqLlTWBH9AXw1gN6uVCGiotZHzWSX6hGbwdLE
         +9jjvXSc5hGhnl5L5kiDkeic4z0VyAZeOiWt4/3e2/E/Me/PLFop/2Ks3xhVxcsIqpmN
         P7GQ==
X-Gm-Message-State: ACgBeo1I7hJqIs9tP4tQzMcCS18dZ+V8ZPJJmytemfS3mSIkCZdZ2jck
        VZ61rw+qau+zLvFMxTNXvaBNq8jQN9s=
X-Google-Smtp-Source: AA6agR7ByRrm3crsxgIaMIJzCBi1yRyQhH4CSXanvTWpx+DBgPNZ6EcJYjzGpYXJpYwJ8Opmi6cg3A==
X-Received: by 2002:a17:906:4598:b0:738:4282:995f with SMTP id qs24-20020a170906459800b007384282995fmr6133609ejc.592.1660635801132;
        Tue, 16 Aug 2022 00:43:21 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.126.24.threembb.co.uk. [188.28.126.24])
        by smtp.gmail.com with ESMTPSA id e1-20020a1709062c0100b00730799724c3sm5057363ejh.149.2022.08.16.00.43.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 00:43:20 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        Dylan Yudaken <dylany@fb.com>,
        Stefan Metzmacher <metze@samba.org>
Subject: [RFC 1/2] io_uring/notif: change notif CQE uapi format
Date:   Tue, 16 Aug 2022 08:42:00 +0100
Message-Id: <1ef0d539e1eb74d9aa0456d07198ecaadaf1b6a4.1660635140.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <cover.1660635140.git.asml.silence@gmail.com>
References: <cover.1660635140.git.asml.silence@gmail.com>
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

Change the notification CQE layout while we can, put the seq number into
cqe->res so we can cqe->flags to mark notification CQEs with
IORING_CQE_F_NOTIF and add other flags in the future if needed. This
will be needed to distinguish notifications from send completions when
they use the same user_data.

Also, limit the sequence number to u16 and reserve upper 16 bits for the
future. We also want it to mask out the sign bit for userspace
convenience as it's easier to test for (cqe->res < 0).

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h | 6 ++++++
 io_uring/notif.c              | 4 ++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 1463cfecb56b..20368394870e 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -286,6 +286,9 @@ enum io_uring_op {
 #define IORING_RECVSEND_FIXED_BUF	(1U << 2)
 #define IORING_RECVSEND_NOTIF_FLUSH	(1U << 3)
 
+/* cqe->res mask for extracting the notification sequence number */
+#define IORING_NOTIF_SEQ_MASK		0xFFFFU
+
 /*
  * accept flags stored in sqe->ioprio
  */
@@ -337,10 +340,13 @@ struct io_uring_cqe {
  * IORING_CQE_F_BUFFER	If set, the upper 16 bits are the buffer ID
  * IORING_CQE_F_MORE	If set, parent SQE will generate more CQE entries
  * IORING_CQE_F_SOCK_NONEMPTY	If set, more data to read after socket recv
+ * IORING_CQE_F_NOTIF	Set for notification CQEs. Can be used to distinct
+ *			them from sends.
  */
 #define IORING_CQE_F_BUFFER		(1U << 0)
 #define IORING_CQE_F_MORE		(1U << 1)
 #define IORING_CQE_F_SOCK_NONEMPTY	(1U << 2)
+#define IORING_CQE_F_NOTIF		(1U << 3)
 
 enum {
 	IORING_CQE_BUFFER_SHIFT		= 16,
diff --git a/io_uring/notif.c b/io_uring/notif.c
index 714715678817..6e17d1ae5a0d 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -60,8 +60,8 @@ struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx,
 	notif->rsrc_node = NULL;
 	io_req_set_rsrc_node(notif, ctx, 0);
 	notif->cqe.user_data = slot->tag;
-	notif->cqe.flags = slot->seq++;
-	notif->cqe.res = 0;
+	notif->cqe.flags = IORING_CQE_F_NOTIF;
+	notif->cqe.res = slot->seq++ & IORING_NOTIF_SEQ_MASK;
 
 	nd = io_notif_to_data(notif);
 	nd->account_pages = 0;
-- 
2.37.0

