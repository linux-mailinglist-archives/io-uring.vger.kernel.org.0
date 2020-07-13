Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7899421E18C
	for <lists+io-uring@lfdr.de>; Mon, 13 Jul 2020 22:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgGMUjZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jul 2020 16:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbgGMUjY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jul 2020 16:39:24 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B00EC061755
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 13:39:24 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id l12so18918466ejn.10
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 13:39:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Nz14pYKZlnmdz2ed6VKkiyyulmgeYB34PP3u05Sk8HM=;
        b=M4PsvrkEkUPg0KtJIkGZBmWuczQqAG8SzQVBaZFoe1wPMiLdnljg7ce0CR5YI1DxGc
         0WMZH0tQWevipIhM1cccI+v3rYx32bC30GAh+4jxUUub/bfrAqoGOAjeB4peMN/cToaI
         GvyljI6hHbjgN4GVBmB2N98jMF+jrIWczdD29YHIJ0wpfxewlePXuGUJJsfVJdXznOTD
         WSzFJTwMDf/xAwuKId0nev1gBuELayxRwKwBLZTYNSy4Sl4JUht5LcaMOjfBF0UN2aRW
         tshUTbzusxn1WTwc3VJl+mxa9rcWa2FnDeodZRoWvwTXapgcsHqHwh7+0D88VBroeeRE
         Nckw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Nz14pYKZlnmdz2ed6VKkiyyulmgeYB34PP3u05Sk8HM=;
        b=A3p0MzKyY6DsBI3VPfic2a4sIXZZ9EvsY9UdKXyrXL3cdvKiUPdzLqgPIw0ZFZCexV
         ND97ljZPl1lBSuEcgx6WEG+r84VbtOulvd2XFKzrYHBaQdYI/aFCOcoqYdAIjNrMTSut
         1XKp7DFFaXaeiDGVhdwnybUvZoJub6LjswMAgmrcUh8baPcGtLUuIQyrJ5yJriszYY/W
         DYJ7fW36gJOzbXhvE/h1PcYHq7Y/7YchdcnaGtD+2J3hz3RogzQhCngg7//WZ1o2Ygks
         VnkNdTZ2R3efBsxq9UT8AcpzDOv+b0XO6sAhsV/zVJhXMPz03AaVKVJ+ipkqixM8fMGT
         +GaQ==
X-Gm-Message-State: AOAM531JcHMFDvLjVEF7ERpV+Pgn5WSHZG3TAZ6rk1i+/Pp1m+C8byjD
        iKrBZhyOQ1GjKlIV37EWc5I=
X-Google-Smtp-Source: ABdhPJz7c66JYCy8ooDeM+iyykrGk5f1yByaqaBIqjDWJekwXWR5jah/AI5HeBO2qhvL+b2E0JZzug==
X-Received: by 2002:a17:906:8157:: with SMTP id z23mr1511950ejw.349.1594672763305;
        Mon, 13 Jul 2020 13:39:23 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id m14sm10491855ejx.80.2020.07.13.13.39.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 13:39:22 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 4/9] io_uring: use completion list for CQ overflow
Date:   Mon, 13 Jul 2020 23:37:11 +0300
Message-Id: <704e86325e43e743f61ea17752e5ced93a5cd577.1594670798.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1594670798.git.asml.silence@gmail.com>
References: <cover.1594670798.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

As with the completion path, also use compl.list for overflowed
requests. If cleaned up properly, nobody needs per-op data there
anymore.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1ad6d47a6223..584ff83cf0a4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1338,8 +1338,8 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 			break;
 
 		req = list_first_entry(&ctx->cq_overflow_list, struct io_kiocb,
-						list);
-		list_move(&req->list, &list);
+						compl.list);
+		list_move(&req->compl.list, &list);
 		req->flags &= ~REQ_F_OVERFLOW;
 		if (cqe) {
 			WRITE_ONCE(cqe->user_data, req->user_data);
@@ -1361,8 +1361,8 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 	io_cqring_ev_posted(ctx);
 
 	while (!list_empty(&list)) {
-		req = list_first_entry(&list, struct io_kiocb, list);
-		list_del(&req->list);
+		req = list_first_entry(&list, struct io_kiocb, compl.list);
+		list_del(&req->compl.list);
 		io_put_req(req);
 	}
 
@@ -1395,11 +1395,12 @@ static void __io_cqring_fill_event(struct io_kiocb *req, long res, long cflags)
 			set_bit(0, &ctx->cq_check_overflow);
 			ctx->rings->sq_flags |= IORING_SQ_CQ_OVERFLOW;
 		}
+		io_clean_op(req);
 		req->flags |= REQ_F_OVERFLOW;
-		refcount_inc(&req->refs);
 		req->result = res;
 		req->cflags = cflags;
-		list_add_tail(&req->list, &ctx->cq_overflow_list);
+		refcount_inc(&req->refs);
+		list_add_tail(&req->compl.list, &ctx->cq_overflow_list);
 	}
 }
 
@@ -7812,7 +7813,7 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 
 		if (cancel_req->flags & REQ_F_OVERFLOW) {
 			spin_lock_irq(&ctx->completion_lock);
-			list_del(&cancel_req->list);
+			list_del(&cancel_req->compl.list);
 			cancel_req->flags &= ~REQ_F_OVERFLOW;
 			if (list_empty(&ctx->cq_overflow_list)) {
 				clear_bit(0, &ctx->sq_check_overflow);
-- 
2.24.0

