Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5004216FC
	for <lists+io-uring@lfdr.de>; Mon,  4 Oct 2021 21:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238886AbhJDTF4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Oct 2021 15:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238883AbhJDTFx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Oct 2021 15:05:53 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A140C06174E
        for <io-uring@vger.kernel.org>; Mon,  4 Oct 2021 12:04:04 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id g10so9264068edj.1
        for <io-uring@vger.kernel.org>; Mon, 04 Oct 2021 12:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XzUTCK60fxivrYu7b+U0p9wWCGJtp8kGvdcK4/U4pNc=;
        b=XwAdS12d1p6Zkg84iQ44HwciDlo1+LzVhUjXaup36m8TGa01VD59Od7htAGJnEK1He
         KQ0VnriQ7ZxRFsscG3eZPhV9Hq8pl6EubFbkLboPZuPtPy6w4u4hmLem2Qj4uBeFQOMC
         4sVQrV/y+HpSx47ClpJb/EHO8fMqo/FyHWixLIYVjQ3RDjP8Y8wm5CTooneZaqEIvEX9
         T6uCNmD4G6eRgA3k45mFwybEucugwDm6+aDLnW3cX4orUN9wQnuhsLbzhWOIPNnRGImu
         R+0nzLmuR6RerPn3KgWvrx5Lf9mBe31Qt4x6G+LLd5VxVcm/Wn31FMVBVFYogSe4iqNL
         VlUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XzUTCK60fxivrYu7b+U0p9wWCGJtp8kGvdcK4/U4pNc=;
        b=muM1bxFiOyCXPoK5wKAwIbvBmrcWadmSHz6ewpAC0JYSjYG2EhtAW62/Ny++WnuFOC
         DAWho+sllwOG+6y6LyXA+8JK7vRPOlZFS9JozfT9OtintcFHScO/y8Kaj9zE1m+LMLSO
         7mplrXG7S5y/XbOxLdXgUtVc60pBt7kzYR43ZiblntaX3TTmST7MZE6Ncg66LFG/LCQ/
         sm/4or7jNV02L1OHDJN2qYbB4IGBtTUW4XfDXUv2bXjLn07E+5JepxZKQJ91DR1ILYxY
         yhE+PPp3/f376ogoyMSkYcgUhekIJl6QNSWHcNqJyWoRf1X4K8tvOgSWE0j5edD+zlB8
         SFxA==
X-Gm-Message-State: AOAM533NWVSf3cf8XIcKaAFLYjm+7zJuHK04s4sZSX+H+GIqBpIZkoJy
        dH0qEC4p0jGTY9DSJRj+aOgLJJXZwvk=
X-Google-Smtp-Source: ABdhPJziTwKoua9zF7HUFMAhs3YsG+y6vu6Td1BaaJWKxvfsKj/5ZyIHlfkT/yyu+jHZV5XT5jfGgA==
X-Received: by 2002:a50:bf0f:: with SMTP id f15mr19868652edk.43.1633374241634;
        Mon, 04 Oct 2021 12:04:01 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.101])
        by smtp.gmail.com with ESMTPSA id k12sm6855045ejk.63.2021.10.04.12.04.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 12:04:01 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 15/16] io_uring: correct fill events helpers types
Date:   Mon,  4 Oct 2021 20:03:00 +0100
Message-Id: <7ca6f15255e9117eae28adcac272744cae29b113.1633373302.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1633373302.git.asml.silence@gmail.com>
References: <cover.1633373302.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

CQE result is a 32-bit integer, so the functions generating CQEs are
better to accept not long but ints. Convert io_cqring_fill_event() and
other helpers.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f60818602544..62dc128e9b6b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1072,7 +1072,7 @@ static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 static void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd);
 
 static bool io_cqring_fill_event(struct io_ring_ctx *ctx, u64 user_data,
-				 long res, unsigned int cflags);
+				 s32 res, u32 cflags);
 static void io_put_req(struct io_kiocb *req);
 static void io_put_req_deferred(struct io_kiocb *req);
 static void io_dismantle_req(struct io_kiocb *req);
@@ -1730,7 +1730,7 @@ static inline void io_get_task_refs(int nr)
 }
 
 static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
-				     long res, unsigned int cflags)
+				     s32 res, u32 cflags)
 {
 	struct io_overflow_cqe *ocqe;
 
@@ -1758,7 +1758,7 @@ static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
 }
 
 static inline bool __io_cqring_fill_event(struct io_ring_ctx *ctx, u64 user_data,
-					  long res, unsigned int cflags)
+					  s32 res, u32 cflags)
 {
 	struct io_uring_cqe *cqe;
 
@@ -1781,13 +1781,13 @@ static inline bool __io_cqring_fill_event(struct io_ring_ctx *ctx, u64 user_data
 
 /* not as hot to bloat with inlining */
 static noinline bool io_cqring_fill_event(struct io_ring_ctx *ctx, u64 user_data,
-					  long res, unsigned int cflags)
+					  s32 res, u32 cflags)
 {
 	return __io_cqring_fill_event(ctx, user_data, res, cflags);
 }
 
-static void io_req_complete_post(struct io_kiocb *req, long res,
-				 unsigned int cflags)
+static void io_req_complete_post(struct io_kiocb *req, s32 res,
+				 u32 cflags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
@@ -1816,8 +1816,8 @@ static void io_req_complete_post(struct io_kiocb *req, long res,
 	io_cqring_ev_posted(ctx);
 }
 
-static inline void io_req_complete_state(struct io_kiocb *req, long res,
-					 unsigned int cflags)
+static inline void io_req_complete_state(struct io_kiocb *req, s32 res,
+					 u32 cflags)
 {
 	req->result = res;
 	req->cflags = cflags;
@@ -1825,7 +1825,7 @@ static inline void io_req_complete_state(struct io_kiocb *req, long res,
 }
 
 static inline void __io_req_complete(struct io_kiocb *req, unsigned issue_flags,
-				     long res, unsigned cflags)
+				     s32 res, u32 cflags)
 {
 	if (issue_flags & IO_URING_F_COMPLETE_DEFER)
 		io_req_complete_state(req, res, cflags);
@@ -1833,12 +1833,12 @@ static inline void __io_req_complete(struct io_kiocb *req, unsigned issue_flags,
 		io_req_complete_post(req, res, cflags);
 }
 
-static inline void io_req_complete(struct io_kiocb *req, long res)
+static inline void io_req_complete(struct io_kiocb *req, s32 res)
 {
 	__io_req_complete(req, 0, res, 0);
 }
 
-static void io_req_complete_failed(struct io_kiocb *req, long res)
+static void io_req_complete_failed(struct io_kiocb *req, s32 res)
 {
 	req_set_fail(req);
 	io_req_complete_post(req, res, 0);
@@ -2613,7 +2613,7 @@ static bool __io_complete_rw_common(struct io_kiocb *req, long res)
 static void io_req_task_complete(struct io_kiocb *req, bool *locked)
 {
 	unsigned int cflags = io_put_rw_kbuf(req);
-	long res = req->result;
+	int res = req->result;
 
 	if (*locked) {
 		io_req_complete_state(req, res, cflags);
-- 
2.33.0

