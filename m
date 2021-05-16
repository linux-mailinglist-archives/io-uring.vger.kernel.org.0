Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85F3D382160
	for <lists+io-uring@lfdr.de>; Sun, 16 May 2021 23:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbhEPV7z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 16 May 2021 17:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbhEPV7y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 16 May 2021 17:59:54 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C28FC06174A
        for <io-uring@vger.kernel.org>; Sun, 16 May 2021 14:58:38 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id v12so4415417wrq.6
        for <io-uring@vger.kernel.org>; Sun, 16 May 2021 14:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Mr7nIegtbdOiHnjicI3zuECs50N5NwDkFdMKa0I9s1o=;
        b=gQ/Ymvtf6bJtF+RvH2qQcQnovcWQwq2NBqrrAdGBjkuqhRucbD7cAPaRYUX4240vPe
         FZaM7odb7aJRdLfg2wOuxm3a/x9HL9YsjpzUGRcctcV/FHpyTj/S0gjQGgXNGyBtoA6d
         MjNZt1QC7oElHFLFQ/LGmfXhrFXu6KcuNwWLBGobLojC5F1jriw4CRnmtpdhjg/PKecM
         59h8ZZoxRHfnPe4x369qlkDKubPQR2r4+LfRKJj/gTtjWBEltfWXKQmuUriYWNaq40Qc
         iXHtbuqYtxUZ7t46aVNhzNENspvto0dqWh5Mr/nA39RtNb/AHtVdBzB14rMmcSxwMhIN
         Q+mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Mr7nIegtbdOiHnjicI3zuECs50N5NwDkFdMKa0I9s1o=;
        b=EH5UuWetQIzu00PXkjTPTD63ibXetNJr1SeneepWa/yxo/AEAr8D1mXhW5IvCbsoF0
         y9geFTqWmQz8o11lh+z+h+IYYd+Keq0hpT9wi3d0m2djAhs1kgSDC44UG1tK447Fh+Vs
         lYEh2J9o2nOxnG9YicXAdZeEZ6Uglan4vrl+Ojir8vCW4CQ59zFbtMZqOeKMzTQkBqxn
         LI+4YzQcMrHNV30545QZME+5Dn8MCCLhfwr1z2Hrx9/QfNRssxBHYcZ+QMYrSMHRKNVP
         DsiWjOglPCjJbNLgSGyt9clJXifJpWK3eHFL9ya20LY6WzYzWzrqNy4YagoWMrpWuD4M
         1k+w==
X-Gm-Message-State: AOAM533U2zNbibbKJ3KUwjnQwFWacMDQ9Tow1QHiAKltM5x8/BRDiGpO
        UkYbNX+wATLJ6936LDGeUnw=
X-Google-Smtp-Source: ABdhPJzahDHPt3JPXvD/EbLKPPGk4tx8q45YOO8yuEWEKQTHoqMtki+yLQR9ftqazdsXkd1oNXiCpQ==
X-Received: by 2002:a5d:69d2:: with SMTP id s18mr70590306wrw.241.1621202316945;
        Sun, 16 May 2021 14:58:36 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.7])
        by smtp.gmail.com with ESMTPSA id p10sm13666365wmq.14.2021.05.16.14.58.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 May 2021 14:58:36 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 12/13] io_uring: rename io_get_cqring
Date:   Sun, 16 May 2021 22:58:11 +0100
Message-Id: <a46a53e3f781de372f5632c184e61546b86515ce.1621201931.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1621201931.git.asml.silence@gmail.com>
References: <cover.1621201931.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Rename io_get_cqring() into io_get_cqe() for consistency with SQ, and
just because the old name is not as clear.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index df5d407a3ca2..a0b3a9c99044 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -11,7 +11,7 @@
  * before writing the tail (using smp_load_acquire to read the tail will
  * do). It also needs a smp_mb() before updating CQ head (ordering the
  * entry load(s) with the head store), pairing with an implicit barrier
- * through a control-dependency in io_get_cqring (smp_store_release to
+ * through a control-dependency in io_get_cqe (smp_store_release to
  * store head will do). Failure to do so could lead to reading invalid
  * CQ entries.
  *
@@ -1363,7 +1363,7 @@ static inline unsigned int __io_cqring_events(struct io_ring_ctx *ctx)
 	return ctx->cached_cq_tail - READ_ONCE(ctx->rings->cq.head);
 }
 
-static inline struct io_uring_cqe *io_get_cqring(struct io_ring_ctx *ctx)
+static inline struct io_uring_cqe *io_get_cqe(struct io_ring_ctx *ctx)
 {
 	struct io_rings *rings = ctx->rings;
 	unsigned tail, mask = ctx->cq_entries - 1;
@@ -1435,7 +1435,7 @@ static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 	posted = false;
 	spin_lock_irqsave(&ctx->completion_lock, flags);
 	while (!list_empty(&ctx->cq_overflow_list)) {
-		struct io_uring_cqe *cqe = io_get_cqring(ctx);
+		struct io_uring_cqe *cqe = io_get_cqe(ctx);
 		struct io_overflow_cqe *ocqe;
 
 		if (!cqe && !force)
@@ -1557,7 +1557,7 @@ static inline bool __io_cqring_fill_event(struct io_ring_ctx *ctx, u64 user_data
 	 * submission (by quite a lot). Increment the overflow count in
 	 * the ring.
 	 */
-	cqe = io_get_cqring(ctx);
+	cqe = io_get_cqe(ctx);
 	if (likely(cqe)) {
 		WRITE_ONCE(cqe->user_data, user_data);
 		WRITE_ONCE(cqe->res, res);
-- 
2.31.1

