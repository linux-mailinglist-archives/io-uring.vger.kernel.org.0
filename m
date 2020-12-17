Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70BCC2DC9F4
	for <lists+io-uring@lfdr.de>; Thu, 17 Dec 2020 01:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbgLQA30 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Dec 2020 19:29:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726155AbgLQA30 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Dec 2020 19:29:26 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBB1AC06138C
        for <io-uring@vger.kernel.org>; Wed, 16 Dec 2020 16:28:09 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id i9so24872363wrc.4
        for <io-uring@vger.kernel.org>; Wed, 16 Dec 2020 16:28:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Ywy+Fqu+ky+OsOlTAG9olO7vcuNwwqbqLejRpZ3a62Q=;
        b=VosYuSXQfU9dSeIdczcUi75zLKVT9nlYOWCOK4AxyDZ9Hh0QB8bQsmLQ47w7Fy1/Gg
         C8nhoFkTIPvao/lJYYHER8ucXsrl4ClRfph30dYgTNX5IScPZeOa4tkFvcXwWAoVhOLY
         L/wW83wBZyK3+FIMUwKA6q2Ji28t56c3QcwbPIzbnsxLem6p14q1LyiwZlFIK0IfD0s8
         RUyArvLqwbCqDaeFoJKm1nkYGKeogoV6Mrj7LC0YUvV1GU3C0p39jEmsUVquv4MyhMha
         FozxMI0QcBpW75XJHtk9H58Go1qTlcsXZ0ZHmpWUHtIAh9XE0yEbNOMeGT32giGuocGU
         P+NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ywy+Fqu+ky+OsOlTAG9olO7vcuNwwqbqLejRpZ3a62Q=;
        b=tp6M4b9VpWOWLSSDIfzU324937jjWg95AfJeHV5YAuQvnN/qoiQr3OaHoNLzRPS+S+
         CN18fIXbWdUDd+UwBZ/m2ZJbnEiSijRlFkWT9h/jfVi3GYdxwjcZM6iWMaRCTQ4vv3rG
         Q0xOmfY3gLd6AKT3wBWwWz8utuI1rQ5wdGTuXfErVGoT/jiCXxXXXF9foDQsBkvom44S
         PyDOOPucFiOL+ubmPs5qjEqW6kaFsqKTZn6YhRGNhxjTmor9N4YJ7TJtmX0dBYRzYWGe
         KpGl/BdB8c/X3g04bbGeMCbkaSBKYst4Fk/jOzNzJ6xQKdw31wLZaktF0hH1A8pu897q
         Bwqw==
X-Gm-Message-State: AOAM532abAewIioHkOOGEgDh1QRE6bFT+I8xZ0ul9cmzSDB9yQMBJAmA
        zFHqywZCswd7skpbHtrm3epbxMDJNcKt2A==
X-Google-Smtp-Source: ABdhPJyVDmvVUy19Xkilj+WxZmGJAbbDP24r5q7DOwPph3pwRpqlCYvaZu4Ksy9K5TTUENysJvtD8Q==
X-Received: by 2002:adf:b647:: with SMTP id i7mr40797017wre.241.1608164888593;
        Wed, 16 Dec 2020 16:28:08 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.225])
        by smtp.gmail.com with ESMTPSA id h29sm5711161wrc.68.2020.12.16.16.28.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 16:28:08 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5/5] io_uring: limit {io|sq}poll submit locking scope
Date:   Thu, 17 Dec 2020 00:24:39 +0000
Message-Id: <b6ca9998691af60c816ca816f7ddae886f781a3b.1608164394.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1608164394.git.asml.silence@gmail.com>
References: <cover.1608164394.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We don't need to take uring_lock for SQPOLL|IOPOLL to do
io_cqring_overflow_flush() when cq_overflow_list is empty, remove it
from the hot path.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ce580678b8ed..fdb7271127c9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9162,10 +9162,13 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	 */
 	ret = 0;
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
-		io_ring_submit_lock(ctx, (ctx->flags & IORING_SETUP_IOPOLL));
-		if (!list_empty_careful(&ctx->cq_overflow_list))
+		if (!list_empty_careful(&ctx->cq_overflow_list)) {
+			bool needs_lock = ctx->flags & IORING_SETUP_IOPOLL;
+
+			io_ring_submit_lock(ctx, needs_lock);
 			io_cqring_overflow_flush(ctx, false, NULL, NULL);
-		io_ring_submit_unlock(ctx, (ctx->flags & IORING_SETUP_IOPOLL));
+			io_ring_submit_unlock(ctx, needs_lock);
+		}
 		if (flags & IORING_ENTER_SQ_WAKEUP)
 			wake_up(&ctx->sq_data->wait);
 		if (flags & IORING_ENTER_SQ_WAIT)
-- 
2.24.0

