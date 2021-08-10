Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 494133E599C
	for <lists+io-uring@lfdr.de>; Tue, 10 Aug 2021 14:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238591AbhHJMGz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Aug 2021 08:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238215AbhHJMGy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Aug 2021 08:06:54 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72C33C0613D3
        for <io-uring@vger.kernel.org>; Tue, 10 Aug 2021 05:06:32 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id q10so2675844wro.2
        for <io-uring@vger.kernel.org>; Tue, 10 Aug 2021 05:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=9wY1432YqKw4O3Ca0ilT8LsxcXkvogvTzkSRhFY3ji8=;
        b=PE8/qypqRFvWqF/5EhD3//o74DwVrrfD3KAEmcnXy6wpLsYgrxGHCoQfL0D4AMoInT
         e+A3P1QM81rLq9JQF0EksMe60Ndoy0WI3fFLg7iXPUK4Srdz6SQHRrugYN2uhvnFrJf+
         nVRcmIPb9JMTM4JjEDvLFf6nSymUadzA9V6digGE1SyeEoyLc0jAygkF6Owaix0vIdXo
         wB73+k1JYoK6sRzXM6YrlIYvHWWdIWbFKMshN7w6Vg5z+juROXKj/JNtd+sWrO9wmBcm
         xR2KyBodqR5xOZQQkIRNRd4uXHCvieNistHEiidVWKKg6FwGCfDXTTp7cG5eXb/b2Iy6
         y+IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9wY1432YqKw4O3Ca0ilT8LsxcXkvogvTzkSRhFY3ji8=;
        b=c6WHk7x9B4e7PLyIlBvXJaUIiLIY/cnxIQlzco9GNmW5FK5q/IM+Qa1SZPXoW0a6ke
         YhMMFmRKJpQj17yprVZU4JGgSXYuvl8Qe4qQ/ZKU4tftNMtduL65X9Nald5J8Wi/s4kx
         57cc4qHNEPPnTf1RpRFEpzwwpZ81zHGGJWfcGi31NxFubYdf/3KzL86EL0Sl6CgX9C82
         EIZ/p+ZyHzqwwhCe8O9Vlwv+sg2Hd+LpAxnhw3WUYHhJKp8qKpJ2yftu4zBOtjEoAq8j
         tcxJNpSemTUgXIATRDmzD71o5IAHJrLZKcSqEyzxUC6x9uDdgPzaUStlq94ZgA+5qwaJ
         2lGA==
X-Gm-Message-State: AOAM531yNFEnYxvufp1o0t9zRX2t1pTUImr+6fZC85N3HaMWrD3PrliC
        3hEhskMsUGDBvB06CFcYluo=
X-Google-Smtp-Source: ABdhPJwlurINCAD6AyUNb2Xr+WM42vyusg41l6bvWEgovP6uaHjroohDNLrUpu+gfpj9vKuhK5jpFA==
X-Received: by 2002:adf:fc50:: with SMTP id e16mr31750372wrs.382.1628597191001;
        Tue, 10 Aug 2021 05:06:31 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.97])
        by smtp.gmail.com with ESMTPSA id d15sm24954362wri.96.2021.08.10.05.06.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 05:06:30 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/5] io_uring: move req_ref_get() and friends
Date:   Tue, 10 Aug 2021 13:05:50 +0100
Message-Id: <7a5b4dba69fff554f54e47e31bdbc5017fa47ff1.1628595748.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628595748.git.asml.silence@gmail.com>
References: <cover.1628595748.git.asml.silence@gmail.com>
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
index 3b17fce0b7e3..e7dabbe885b3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1081,6 +1081,41 @@ EXPORT_SYMBOL(io_uring_get_socket);
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
@@ -1539,41 +1574,6 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx)
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

