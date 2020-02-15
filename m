Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 280761600CF
	for <lists+io-uring@lfdr.de>; Sat, 15 Feb 2020 23:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727799AbgBOWCk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Feb 2020 17:02:40 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44248 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726273AbgBOWCZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Feb 2020 17:02:25 -0500
Received: by mail-wr1-f67.google.com with SMTP id m16so15136418wrx.11;
        Sat, 15 Feb 2020 14:02:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Mjj1IxLNFWUTyDB8HRS0Csc4RBUjRWyDOD91E1pMNvA=;
        b=hbem07l4r8PvKkWVTdXDfXgermLK3/Ba3RvreWQvH15cUuY88hKR1ZA4wYYyB7gJxM
         b9syaFeTJctWtSZylT8pJfVTYIZx1z7M70jbN5lzv9VDpuspUPe9Aq54MiXSKY46OYoH
         bjdTM+QiItOx+C1ww1QBhpy6ccKt39K8BjB/LawtbKMtLXRMb9F+T+fk8aX8+Larr3yR
         QylW+0oNehqEFn07BKPcBi+Jii0iV9KXmOIiQ3Fw2Upu8HYEX6rLCAH48DHpdAYTwls3
         vJYVfBR+mLmDw4T0u3FbP+zK6Y/nwmJoxxvvJZBoQoCZHNRZBlxSXBl0xgOiQrr1vNNa
         yYng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Mjj1IxLNFWUTyDB8HRS0Csc4RBUjRWyDOD91E1pMNvA=;
        b=g2+lHQ2eO+mAYBw91A40E02c35SsfjUuxbQUzvyK/8Yw2bW+vCEbchfc4RP/aZCS04
         Dkl0iZoZhmKKnJkr6cJrynWB1LjGWwkoeviVQSJEaUeNsAsBiqQiGTn7QR1izBzOcX3h
         Gmo4hHKftxC+BBqhsVl+ws4pk6DpAQaImvEYmsvmAbmH0Q+vaEOazjvdh2JjtUV+w4sf
         m/sGxpIv8OS1R2VB2P3eusDIj1vncTOz2PvBeefUOy96AjgjgJAvlilYpF6xnmdfmDIb
         nFwOgzDY4QiMh8lK7P5MrnV9AdevyYfTFBSrZtRSI079tXKpxivDMdzaa7aJH0M5M94y
         /SxQ==
X-Gm-Message-State: APjAAAX1hWmJJwRjFGVON8EmPFugFDH/8IJw4gQJyvd7AuivmMpp8io6
        Ko3h+LFVCrplatc9YyPyQ92Yr2P2
X-Google-Smtp-Source: APXvYqyTtwPn8W7bV0kTfLaIHamgJXTjo/2ADXM42ozfJF+19dTj1DNdasmJ79lhVBju3KrRTFlv4A==
X-Received: by 2002:adf:fe50:: with SMTP id m16mr12331824wrs.217.1581804143946;
        Sat, 15 Feb 2020 14:02:23 -0800 (PST)
Received: from localhost.localdomain ([109.126.146.5])
        by smtp.gmail.com with ESMTPSA id b18sm13377021wru.50.2020.02.15.14.02.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Feb 2020 14:02:23 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/5] io_uring: remove REQ_F_MUST_PUNT
Date:   Sun, 16 Feb 2020 01:01:19 +0300
Message-Id: <f0d8ec082bc4cf7057c5ac071756d952be908217.1581785642.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1581785642.git.asml.silence@gmail.com>
References: <cover.1581785642.git.asml.silence@gmail.com>
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
index 7a132be72863..1dc83d887183 100644
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
@@ -514,8 +513,6 @@ enum {
 	REQ_F_TIMEOUT		= BIT(REQ_F_TIMEOUT_BIT),
 	/* regular file */
 	REQ_F_ISREG		= BIT(REQ_F_ISREG_BIT),
-	/* must be punted even for NONBLOCK */
-	REQ_F_MUST_PUNT		= BIT(REQ_F_MUST_PUNT_BIT),
 	/* no timeout sequence */
 	REQ_F_TIMEOUT_NOSEQ	= BIT(REQ_F_TIMEOUT_NOSEQ_BIT),
 	/* completion under lock */
@@ -2252,11 +2249,11 @@ static int io_read(struct io_kiocb *req, struct io_kiocb **nxt,
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
 
@@ -2341,11 +2338,11 @@ static int io_write(struct io_kiocb *req, struct io_kiocb **nxt,
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
 
@@ -4725,8 +4722,7 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
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

