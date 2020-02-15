Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD7B1600CD
	for <lists+io-uring@lfdr.de>; Sat, 15 Feb 2020 23:03:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbgBOWCe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Feb 2020 17:02:34 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55770 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727799AbgBOWCb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Feb 2020 17:02:31 -0500
Received: by mail-wm1-f67.google.com with SMTP id q9so13537871wmj.5;
        Sat, 15 Feb 2020 14:02:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=IvaFbqPAtgQzpGIdnB8UOF2k7maJMvX4GVy4+SohdLA=;
        b=ZPtsQmQBdeFNDn2nGkuVcoJ0ypRvop8RiSx2l62W8EU4mYcZmIJ9ffh/28cOjnpzxS
         nD/PbUrApxYFU3x9ZkDqQbG495Hur3JK52LSbrAkxK3uC4xOIQ4ZHQmZu7MelCDXwYkN
         2eIwD6zap/sy3wS0Ngeru5uIzzSxQOCOKCvORI6got5Ijnk8qHp+3BvrasLJVuxymJeB
         HG/MH851kH5DgNBMB9mgOZoLZyg8P7+VQRth2MeR1F+gXnpgjTex4tZBKMMeU4/GkvgP
         4bxZonRdH3A9tAD9raxLJl/m2V1cb+MbwAK7P62M2VTeSGaUndwuHsoKTbFvmGGhzVvx
         Y2Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IvaFbqPAtgQzpGIdnB8UOF2k7maJMvX4GVy4+SohdLA=;
        b=ONDwzX+p61KImosGfFFXgms8rve480VxCo1hRsHB/7sd0euddVLYM/f3V0WTBq50Ms
         Chyi/6qCxY3NVzv772e3mFh8qcPOHL0pC7x7KDe6XbzqbZuPhfLuNWgFtjKbnD8m2LrY
         T4dnOklqc+PEJILPOmW9BQJmstTif03CyWVBF1N9dvhuPZa5W49DIeAhettLAMzTcrOi
         jpNuB3/nfHYZJP039E7d6oNMoUImXFNUIPUqU7jaTBc4CiUa8hLOgaAfEimK6bgUPwgo
         QYcxeQlHMWshq0y1UIbpJkJmErasuNvBOX2PvpfIM3iAhM9kmecgVZ4jtGnCI4GorIgZ
         QrhQ==
X-Gm-Message-State: APjAAAV+mUyaZvLnJZ+0keiie+9QOXMupCFKhPc6JMRTu3RxEvS6NEBL
        F5rfkagmcNF6LK61HlyZzuc=
X-Google-Smtp-Source: APXvYqyNG/DL2TOxbrHZ0WPIxuUkmDw7x+VSi1h1cRhSil1A24lsJdYir4/941RPS7JMgEr+RxO9oQ==
X-Received: by 2002:a05:600c:2552:: with SMTP id e18mr12296706wma.103.1581804149567;
        Sat, 15 Feb 2020 14:02:29 -0800 (PST)
Received: from localhost.localdomain ([109.126.146.5])
        by smtp.gmail.com with ESMTPSA id b18sm13377021wru.50.2020.02.15.14.02.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Feb 2020 14:02:29 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/5] io_uring: remove req->in_async
Date:   Sun, 16 Feb 2020 01:01:22 +0300
Message-Id: <c78ec77d8d0f882cb471e94408e8e3df3619f9c7.1581785642.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1581785642.git.asml.silence@gmail.com>
References: <cover.1581785642.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

req->in_async is not really needed, it only prevents propagation of
@nxt for fast not-blocked submissions. Remove it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4515db6a64d6..5ff7c602ad4d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -553,7 +553,6 @@ struct io_kiocb {
 	 * llist_node is only used for poll deferred completions
 	 */
 	struct llist_node		llist_node;
-	bool				in_async;
 	bool				needs_fixed_file;
 	u8				opcode;
 
@@ -1980,14 +1979,13 @@ static inline void io_rw_done(struct kiocb *kiocb, ssize_t ret)
 	}
 }
 
-static void kiocb_done(struct kiocb *kiocb, ssize_t ret, struct io_kiocb **nxt,
-		       bool in_async)
+static void kiocb_done(struct kiocb *kiocb, ssize_t ret, struct io_kiocb **nxt)
 {
 	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
 
 	if (req->flags & REQ_F_CUR_POS)
 		req->file->f_pos = kiocb->ki_pos;
-	if (in_async && ret >= 0 && kiocb->ki_complete == io_complete_rw)
+	if (ret >= 0 && kiocb->ki_complete == io_complete_rw)
 		*nxt = __io_complete_rw(kiocb, ret);
 	else
 		io_rw_done(kiocb, ret);
@@ -2280,7 +2278,7 @@ static int io_read(struct io_kiocb *req, struct io_kiocb **nxt,
 
 		/* Catch -EAGAIN return for forced non-blocking submission */
 		if (!force_nonblock || ret2 != -EAGAIN) {
-			kiocb_done(kiocb, ret2, nxt, req->in_async);
+			kiocb_done(kiocb, ret2, nxt);
 		} else {
 copy_iov:
 			ret = io_setup_async_rw(req, io_size, iovec,
@@ -2393,7 +2391,7 @@ static int io_write(struct io_kiocb *req, struct io_kiocb **nxt,
 		if (ret2 == -EOPNOTSUPP && (kiocb->ki_flags & IOCB_NOWAIT))
 			ret2 = -EAGAIN;
 		if (!force_nonblock || ret2 != -EAGAIN) {
-			kiocb_done(kiocb, ret2, nxt, req->in_async);
+			kiocb_done(kiocb, ret2, nxt);
 		} else {
 copy_iov:
 			ret = io_setup_async_rw(req, io_size, iovec,
@@ -4530,7 +4528,6 @@ static void io_wq_submit_work(struct io_wq_work **workptr)
 	}
 
 	if (!ret) {
-		req->in_async = true;
 		do {
 			ret = io_issue_sqe(req, NULL, &nxt, false);
 			/*
@@ -5066,7 +5063,6 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 			*mm = ctx->sqo_mm;
 		}
 
-		req->in_async = async;
 		req->needs_fixed_file = async;
 		trace_io_uring_submit_sqe(ctx, req->opcode, req->user_data,
 						true, async);
-- 
2.24.0

