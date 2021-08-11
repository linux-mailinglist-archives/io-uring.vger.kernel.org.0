Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF373E97A2
	for <lists+io-uring@lfdr.de>; Wed, 11 Aug 2021 20:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbhHKS3f (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Aug 2021 14:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbhHKS3e (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Aug 2021 14:29:34 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BC09C0613D3
        for <io-uring@vger.kernel.org>; Wed, 11 Aug 2021 11:29:10 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id w21-20020a7bc1150000b02902e69ba66ce6so2626646wmi.1
        for <io-uring@vger.kernel.org>; Wed, 11 Aug 2021 11:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=o1XNc5t6MdKwv8DjUlLjFqRz7r9QgtGHzzIpGvbSEPQ=;
        b=POeHNBMkpbJEB8en6bKNpP1LYIkO2h9xjNrnBeSy4BswNETJ2rvDbOi6zTdQck5wRM
         VPybU1YVlv+owk1Sp/4/KvXgQlkb6FOvL6H4QpZDkyyg+apo6x6upp+SPUsXl3rE3S0g
         4d1/i4vsZIL/3WSLuZ1q8W2oRp0lYybGQqh5lRuMdl8BycclHZQD4NZSVOJ4R74MVKn2
         c97t1/3kspSR6ggQcuFe9qlsUTqhKo09TNLz+ONq5VxATEk1bwMROrrQHM8+rnarvbud
         lnShJ47lc8We5qZaeY9jSREkCmkDa2pgq5kwMKfej1BAA0l/HbdiHHQqZQeXLETKOzuz
         xMiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o1XNc5t6MdKwv8DjUlLjFqRz7r9QgtGHzzIpGvbSEPQ=;
        b=W64NqrZkH05lxVyVrXvCwkF7+xmVvW3JFxxUtM6yZn/RwbASKldVsH3DEtpEeUSuYY
         60xlyiTRRpTwhG1mKZJvWN4MtBVfILn7EKLTWnPFyGXPAxDiAiclmjOY2uUS7fWofk9z
         gbFRmPixZb9bWtDJpHOORniXMnGRFrY/eUyhKIrHipsrwD0wZV7E1fGKaHhuYmgD9Su/
         y5Y1W0C3HPDK31otxm7DqI880raUivV8M9IkL74rzaSCb0D7FiSEdTg6xl1OoXwF7ZL9
         sqf3V9wItFF+ellEQs222QSJnIQswuoCrIoOYSxWRwsv7txrC2uZFzUU3IWVRfpCCK0X
         vNaQ==
X-Gm-Message-State: AOAM532UJFeiwsuC4doLUGznLYDAJBMQFK18k+DzXM/FSiQJYqkFcp0a
        RhvQZby6/zwLXU/awBjl48Q=
X-Google-Smtp-Source: ABdhPJzSKfxbW2Yod5dh6S1XSVoKTlZ5ENnnUECzLKVXVeJek1UxMM6f945kEwavXGxquvyoYr5h+g==
X-Received: by 2002:a05:600c:4f8c:: with SMTP id n12mr28876201wmq.137.1628706549130;
        Wed, 11 Aug 2021 11:29:09 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.97])
        by smtp.gmail.com with ESMTPSA id 129sm867wmz.26.2021.08.11.11.29.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 11:29:08 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 1/5] io_uring: move req_ref_get() and friends
Date:   Wed, 11 Aug 2021 19:28:27 +0100
Message-Id: <89fd36f6f3fe5b733dfe4546c24725eee40df605.1628705069.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628705069.git.asml.silence@gmail.com>
References: <cover.1628705069.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move all request refcount helpers to avoid forward declarations in the
future.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 70 +++++++++++++++++++++++++--------------------------
 1 file changed, 35 insertions(+), 35 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 08025ef39d7b..a088c8c2b1ef 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1078,6 +1078,41 @@ EXPORT_SYMBOL(io_uring_get_socket);
 #define io_for_each_link(pos, head) \
 	for (pos = (head); pos; pos = pos->link)
 
+/*
+ * Shamelessly stolen from the mm implementation of page reference checking,
+ * see commit f958d7b528b1 for details.
+ */
+#define req_ref_zero_or_close_to_overflow(req)	\
+	((unsigned int) atomic_read(&(req->refs)) + 127u <= 127u)
+
+static inline bool req_ref_inc_not_zero(struct io_kiocb *req)
+{
+	return atomic_inc_not_zero(&req->refs);
+}
+
+static inline bool req_ref_sub_and_test(struct io_kiocb *req, int refs)
+{
+	WARN_ON_ONCE(req_ref_zero_or_close_to_overflow(req));
+	return atomic_sub_and_test(refs, &req->refs);
+}
+
+static inline bool req_ref_put_and_test(struct io_kiocb *req)
+{
+	WARN_ON_ONCE(req_ref_zero_or_close_to_overflow(req));
+	return atomic_dec_and_test(&req->refs);
+}
+
+static inline void req_ref_put(struct io_kiocb *req)
+{
+	WARN_ON_ONCE(req_ref_put_and_test(req));
+}
+
+static inline void req_ref_get(struct io_kiocb *req)
+{
+	WARN_ON_ONCE(req_ref_zero_or_close_to_overflow(req));
+	atomic_inc(&req->refs);
+}
+
 static inline void io_req_set_rsrc_node(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -1533,41 +1568,6 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx)
 	return ret;
 }
 
-/*
- * Shamelessly stolen from the mm implementation of page reference checking,
- * see commit f958d7b528b1 for details.
- */
-#define req_ref_zero_or_close_to_overflow(req)	\
-	((unsigned int) atomic_read(&(req->refs)) + 127u <= 127u)
-
-static inline bool req_ref_inc_not_zero(struct io_kiocb *req)
-{
-	return atomic_inc_not_zero(&req->refs);
-}
-
-static inline bool req_ref_sub_and_test(struct io_kiocb *req, int refs)
-{
-	WARN_ON_ONCE(req_ref_zero_or_close_to_overflow(req));
-	return atomic_sub_and_test(refs, &req->refs);
-}
-
-static inline bool req_ref_put_and_test(struct io_kiocb *req)
-{
-	WARN_ON_ONCE(req_ref_zero_or_close_to_overflow(req));
-	return atomic_dec_and_test(&req->refs);
-}
-
-static inline void req_ref_put(struct io_kiocb *req)
-{
-	WARN_ON_ONCE(req_ref_put_and_test(req));
-}
-
-static inline void req_ref_get(struct io_kiocb *req)
-{
-	WARN_ON_ONCE(req_ref_zero_or_close_to_overflow(req));
-	atomic_inc(&req->refs);
-}
-
 /* must to be called somewhat shortly after putting a request */
 static inline void io_put_task(struct task_struct *task, int nr)
 {
-- 
2.32.0

