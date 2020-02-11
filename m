Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 534A2159A27
	for <lists+io-uring@lfdr.de>; Tue, 11 Feb 2020 21:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731089AbgBKUCv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Feb 2020 15:02:51 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36314 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730912AbgBKUCv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Feb 2020 15:02:51 -0500
Received: by mail-wr1-f65.google.com with SMTP id z3so14081782wru.3;
        Tue, 11 Feb 2020 12:02:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=nPuj7TemWcqy/RKQwtEp7IOqjSWo0LWqgPLFOZx3hMs=;
        b=fLXqyI37iW8UweuYeHmhdkbPhTCbRt1tVeVCh6ReNhiMZGCVWvIC5MMt2pzFWtS0Vf
         NEoSK8KScR83rl0031O/yqALycI31fLMIc/VJdZ+s6/tY2HKFezfKdm4jygrnKzFT/pR
         h5NL/fPR1eIP2Hx9vfUlUy4QErN1N34PtWGfYUPLoRGWp6unJ2mg3Vu+w0IEiAH3Evqz
         V/nCOcZC/6xdjX/IdGDYcRbKWhHilpmgiIKqe5J9B2yRpmm1JNwObWUopjVKGMRs9HfX
         U0QqlqiIeN4vQyHoPrZBbRtUEFW0Svo1rxeRNS7uUXE/PFvp7QF4BiKPFcqUUbZPtwCD
         ZdYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nPuj7TemWcqy/RKQwtEp7IOqjSWo0LWqgPLFOZx3hMs=;
        b=rlv9kcS7e7b/1b2GM8YwhGz6qVhe6ecBmeXYWJqik4M3+xL1bx5OfQLiUX/etInJfk
         YGhXkiKVVo2WZk1zhvTd+i8MN1Qg4r/gI3R8+4vhsMaw59jvr7imE5tGtO5HiIGo4bkM
         z5YN1B28tWsWJTJtpzNT4dfMA/NF+pEE9mzn7AW1irs1hxoO5KoQcWCBSTo3ajqMxYez
         Ui7hMMr6KfFLJKgaxQstv2gt+D3FDcrIE9n4Yhb6Xqvy5MlL/TzUyGlaL1Co4Tgq+fYc
         Mgdp3wgYmbMoO3bRP/jpvJrybYM+Nh6IcqPSegYhmYtB4O4iLBWFC60F74OseIPdVml9
         j3wg==
X-Gm-Message-State: APjAAAXl1n6+fpWdQACz9/rXOC5cY1yP9Dy4jn1yjtIso2iqDq4qgDGf
        Hcf2yGYK1pr41+3oqF31KTQ=
X-Google-Smtp-Source: APXvYqwBjGeRTQ4tUW+zTz3j8XIpBk/aiiYL0ZyV1H+HnvyY783N0OBIfNWetk18N7N5Vf3P7mRB9A==
X-Received: by 2002:a5d:6292:: with SMTP id k18mr10205180wru.256.1581451369507;
        Tue, 11 Feb 2020 12:02:49 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.62])
        by smtp.gmail.com with ESMTPSA id 4sm4955101wmg.22.2020.02.11.12.02.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2020 12:02:49 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] io_uring: remove REQ_F_MUST_PUNT
Date:   Tue, 11 Feb 2020 23:01:54 +0300
Message-Id: <ea87b4425681664d82ea3454003038abc33376cb.1581450491.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1581450491.git.asml.silence@gmail.com>
References: <cover.1581450491.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

REQ_F_MUST_PUNT is needed to ignore REQ_F_NOWAIT and thus always punt
async if have got -EAGAIN. It's enough to clear REQ_F_NOWAIT instead of
having yet another flag.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 63beda9bafc5..98da478ae56c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -477,7 +477,6 @@ enum {
 	REQ_F_LINK_TIMEOUT_BIT,
 	REQ_F_TIMEOUT_BIT,
 	REQ_F_ISREG_BIT,
-	REQ_F_MUST_PUNT_BIT,
 	REQ_F_TIMEOUT_NOSEQ_BIT,
 	REQ_F_COMP_LOCKED_BIT,
 	REQ_F_NEED_CLEANUP_BIT,
@@ -513,8 +512,6 @@ enum {
 	REQ_F_TIMEOUT		= BIT(REQ_F_TIMEOUT_BIT),
 	/* regular file */
 	REQ_F_ISREG		= BIT(REQ_F_ISREG_BIT),
-	/* must be punted even for NONBLOCK */
-	REQ_F_MUST_PUNT		= BIT(REQ_F_MUST_PUNT_BIT),
 	/* no timeout sequence */
 	REQ_F_TIMEOUT_NOSEQ	= BIT(REQ_F_TIMEOUT_NOSEQ_BIT),
 	/* completion under lock */
@@ -2246,11 +2243,11 @@ static int io_read(struct io_kiocb *req, struct io_kiocb **nxt,
 		req->result = io_size;
 
 	/*
-	 * If the file doesn't support async, mark it as REQ_F_MUST_PUNT so
-	 * we know to async punt it even if it was opened O_NONBLOCK
+	 * If the file doesn't support async, async punt it even if it
+	 * was opened O_NONBLOCK
 	 */
 	if (force_nonblock && !io_file_supports_async(req->file)) {
-		req->flags |= REQ_F_MUST_PUNT;
+		req->flags &= ~REQ_F_NOWAIT;
 		goto copy_iov;
 	}
 
@@ -2335,11 +2332,11 @@ static int io_write(struct io_kiocb *req, struct io_kiocb **nxt,
 		req->result = io_size;
 
 	/*
-	 * If the file doesn't support async, mark it as REQ_F_MUST_PUNT so
-	 * we know to async punt it even if it was opened O_NONBLOCK
+	 * If the file doesn't support async, async punt it even if it
+	 * was opened O_NONBLOCK
 	 */
 	if (force_nonblock && !io_file_supports_async(req->file)) {
-		req->flags |= REQ_F_MUST_PUNT;
+		req->flags &= ~REQ_F_NOWAIT;
 		goto copy_iov;
 	}
 
@@ -4715,8 +4712,7 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	 * We async punt it if the file wasn't marked NOWAIT, or if the file
 	 * doesn't support non-blocking read/write attempts
 	 */
-	if (ret == -EAGAIN && (!(req->flags & REQ_F_NOWAIT) ||
-	    (req->flags & REQ_F_MUST_PUNT))) {
+	if (ret == -EAGAIN && !(req->flags & REQ_F_NOWAIT)) {
 punt:
 		if (io_op_defs[req->opcode].file_table) {
 			ret = io_grab_files(req);
-- 
2.24.0

