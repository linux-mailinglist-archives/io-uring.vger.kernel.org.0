Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93E973A721F
	for <lists+io-uring@lfdr.de>; Tue, 15 Jun 2021 00:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbhFNWkO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Jun 2021 18:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbhFNWkM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Jun 2021 18:40:12 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51BD6C0617AF
        for <io-uring@vger.kernel.org>; Mon, 14 Jun 2021 15:37:57 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 3-20020a05600c0243b029019f2f9b2b8aso830453wmj.2
        for <io-uring@vger.kernel.org>; Mon, 14 Jun 2021 15:37:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Nl9YiEIQL3P4zjqtba+NiHfeuSkZ0H4t3/tJZSb6um0=;
        b=HcIBkywigXICsWiRj5VGd/FsDLmHZXNZa0tiuLYnoshSoXRHILm9vIDOmDgJGp2uoY
         ivRIQQGPhLk9r2/zW/vlU1325zJUt7DX4yTr2GtHZbi39hCcOtefVUfSvh4fa8ChJQQx
         5Xle6AkDwG6avum7xVB5cYwN8PB+dCnzx2M9EK3xbcI3Q3cQYeXfysGgN3RXTdqIbVJY
         tuO429TT5Q+5WRLMOMtX8XT5T52HgtYBdc+trk8gSPGLZT9rr44oUcq4p8JeaOkyPx8Q
         jm7nsY/aMiAgJasoCdbX7R5bL2dmXA8EJGmBZnFTrk5baJjbggsTe2zI1RtLo+AS7cQJ
         KrVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Nl9YiEIQL3P4zjqtba+NiHfeuSkZ0H4t3/tJZSb6um0=;
        b=idDiSjf1z1do6/Iig84vVr0b6rWs8KXrMfmXVC2CHeePAHR8FpPHbc+gaS7n/v7TUa
         enTHiREx7k+WjfK9lWl10ykw6NvhaXNeViObG1iEfG4zleBw0EMqh/UiVA2WBk3Ym5kg
         2CUid2mqMSDX8Llw0Hxt3SqmrLabILmbLcBS52ZZMDD6kegTL4ALO5969wlwPPv5tLYb
         MeX9g/vqeS0ysSs12b1BRE+P76N7+qKN8Td6TiD7XyKKP4Vm+FcxNDYZpYNgFTQ2hne1
         dIqMgv44j+g7KhRJw+eN9tRhNyqGBic4jdGTwEM6gqDAP7Q4+NcJ4Hv+YWXybQt5/e8e
         RGHA==
X-Gm-Message-State: AOAM533DleiZ+4rEkAlBf7/JW8Y/+C/LheqiGwETW51wUHuATMNnVv+o
        Ogvc/toiKCpM8r+m9oyjTgk=
X-Google-Smtp-Source: ABdhPJxygKRVT2+OdSpbCuzRf0wEP3AtzBhRBxbyXRB+bwiHbRJlMo88KtnPLlbLediHTQbZrCLg1Q==
X-Received: by 2002:a05:600c:1d0a:: with SMTP id l10mr1499413wms.124.1623710275999;
        Mon, 14 Jun 2021 15:37:55 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.209])
        by smtp.gmail.com with ESMTPSA id x3sm621074wmj.30.2021.06.14.15.37.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 15:37:55 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 05/12] io_uring: don't cache number of dropped SQEs
Date:   Mon, 14 Jun 2021 23:37:24 +0100
Message-Id: <088aceb2707a534d531e2770267c4498e0507cc1.1623709150.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623709150.git.asml.silence@gmail.com>
References: <cover.1623709150.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Kill ->cached_sq_dropped and wire DRAIN sequence number correction via
->cq_extra, which is there exactly for that purpose. User visible
dropped counter will be populated by incrementing it instead of keeping
a copy, similarly as it was done not so long ago with cq_overflow.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3baacfe2c9b7..6dd14f4aa5f1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -370,7 +370,6 @@ struct io_ring_ctx {
 		struct io_uring_sqe	*sq_sqes;
 		unsigned		cached_sq_head;
 		unsigned		sq_entries;
-		unsigned		cached_sq_dropped;
 		unsigned long		sq_check_overflow;
 		struct list_head	defer_list;
 
@@ -5994,13 +5993,11 @@ static u32 io_get_sequence(struct io_kiocb *req)
 {
 	struct io_kiocb *pos;
 	struct io_ring_ctx *ctx = req->ctx;
-	u32 total_submitted, nr_reqs = 0;
+	u32 nr_reqs = 0;
 
 	io_for_each_link(pos, req)
 		nr_reqs++;
-
-	total_submitted = ctx->cached_sq_head - ctx->cached_sq_dropped;
-	return total_submitted - nr_reqs;
+	return ctx->cached_sq_head - nr_reqs;
 }
 
 static int io_req_defer(struct io_kiocb *req)
@@ -6701,8 +6698,9 @@ static const struct io_uring_sqe *io_get_sqe(struct io_ring_ctx *ctx)
 		return &ctx->sq_sqes[head];
 
 	/* drop invalid entries */
-	ctx->cached_sq_dropped++;
-	WRITE_ONCE(ctx->rings->sq_dropped, ctx->cached_sq_dropped);
+	ctx->cq_extra--;
+	WRITE_ONCE(ctx->rings->sq_dropped,
+		   READ_ONCE(ctx->rings->sq_dropped) + 1);
 	return NULL;
 }
 
-- 
2.31.1

