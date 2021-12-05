Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC1ED468B6A
	for <lists+io-uring@lfdr.de>; Sun,  5 Dec 2021 15:39:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234952AbhLEOmn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 5 Dec 2021 09:42:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234931AbhLEOmm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 5 Dec 2021 09:42:42 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E43C061714
        for <io-uring@vger.kernel.org>; Sun,  5 Dec 2021 06:39:15 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id r11so32125135edd.9
        for <io-uring@vger.kernel.org>; Sun, 05 Dec 2021 06:39:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m8jI2e4vtIRUvbDrG2Rp1kUa0vdcXNX713NyeDRD+Yo=;
        b=QWjzLvtEs3cSj1/zZNqAhfG0tARgFmXw2NtUTVP05wc+00HfQHDv7u9Rb/tKPVeHE3
         TkePzcpwfPESZGmGx2Hj809JVmc8Qi8C1SPjXet+uA8EgDwNefLb4hL+1U1fJI2zYV1p
         jS8CBAyHKmkqhKib5WWVyNLzQb8E/em01RsLBmdOjV/Oijo3567By8prv1gBjdKPGRQD
         VeOOBxC4Bn7OT8K6ZYc5heAzHIYkYZvK+IoN27QoXIoKJ7GTKiYNY2SzynDqWnF4Vpyh
         h33myuhrjeKHbUot0rSStdRXsTodTieySw5e3rgiR1ou0GkCSFJKEVp/Xr6G3Ix6tp5P
         5onA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m8jI2e4vtIRUvbDrG2Rp1kUa0vdcXNX713NyeDRD+Yo=;
        b=rwAHtUICcul6FeiFS+3PwelQIUsMfrodut6QgMSyIxUg37fW47ubJMGjeAF0UaC+NY
         CcKAlLwJP9R7hprd/2onH34JCMmQlCingBGtOfuxzeEm1eTlfbBeZ13mF9lszic66wz4
         GmKx6DVXwUoKdOo9cxgItkM2NVPtwXFgwp3RBk6WPX7ch5MU6/0IL0GHbVvIS7PQv939
         ONHo9kPnd1jnMCd9U7nexL9XxIkSK4pRZ+lxOxovPMecuiqjJY7rkT3SzQyqYQKJ+2BN
         YfDg41zAboLNRrbAmv+RlB4/ZwyG+FfkXRTyNi2aL9aMwp7y7qQ9gtwy0EHHi18hUQCz
         UOIg==
X-Gm-Message-State: AOAM5310T8ZzHC9VxPvHZekZGre9yvol+vD0ZC45FYNBVHnBJobn59Xd
        rsunHz2ZbwhJQdMYb9HQLZRDirE/12I=
X-Google-Smtp-Source: ABdhPJyvacC+MQwp3JWcHVNqkghYZb5QZe5AQeT8CKLlkt7vJTpDzRB0QBciu0TP2P79Y0eQzjJkmw==
X-Received: by 2002:a05:6402:50c6:: with SMTP id h6mr43843572edb.228.1638715153839;
        Sun, 05 Dec 2021 06:39:13 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.129.50])
        by smtp.gmail.com with ESMTPSA id ar2sm5224935ejc.20.2021.12.05.06.39.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Dec 2021 06:39:13 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, Hao Xu <haoxu@linux.alibaba.com>
Subject: [PATCH v2 1/4] io_uring: move up io_put_kbuf() and io_put_rw_kbuf()
Date:   Sun,  5 Dec 2021 14:37:57 +0000
Message-Id: <3631243d6fc4a79bbba0cd62597fc8cd5be95924.1638714983.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <cover.1638714983.git.asml.silence@gmail.com>
References: <cover.1638714983.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <haoxu@linux.alibaba.com>

Move them up to avoid explicit declaration. We will use them in later
patches.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8b6bfed16f65..ffbe1b76f3a0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1273,6 +1273,24 @@ static inline void io_req_set_rsrc_node(struct io_kiocb *req,
 	}
 }
 
+static unsigned int io_put_kbuf(struct io_kiocb *req, struct io_buffer *kbuf)
+{
+	unsigned int cflags;
+
+	cflags = kbuf->bid << IORING_CQE_BUFFER_SHIFT;
+	cflags |= IORING_CQE_F_BUFFER;
+	req->flags &= ~REQ_F_BUFFER_SELECTED;
+	kfree(kbuf);
+	return cflags;
+}
+
+static inline unsigned int io_put_rw_kbuf(struct io_kiocb *req)
+{
+	if (likely(!(req->flags & REQ_F_BUFFER_SELECTED)))
+		return 0;
+	return io_put_kbuf(req, req->kbuf);
+}
+
 static void io_refs_resurrect(struct percpu_ref *ref, struct completion *compl)
 {
 	bool got = percpu_ref_tryget(ref);
@@ -2456,24 +2474,6 @@ static inline unsigned int io_sqring_entries(struct io_ring_ctx *ctx)
 	return smp_load_acquire(&rings->sq.tail) - ctx->cached_sq_head;
 }
 
-static unsigned int io_put_kbuf(struct io_kiocb *req, struct io_buffer *kbuf)
-{
-	unsigned int cflags;
-
-	cflags = kbuf->bid << IORING_CQE_BUFFER_SHIFT;
-	cflags |= IORING_CQE_F_BUFFER;
-	req->flags &= ~REQ_F_BUFFER_SELECTED;
-	kfree(kbuf);
-	return cflags;
-}
-
-static inline unsigned int io_put_rw_kbuf(struct io_kiocb *req)
-{
-	if (likely(!(req->flags & REQ_F_BUFFER_SELECTED)))
-		return 0;
-	return io_put_kbuf(req, req->kbuf);
-}
-
 static inline bool io_run_task_work(void)
 {
 	if (test_thread_flag(TIF_NOTIFY_SIGNAL) || current->task_works) {
-- 
2.34.0

