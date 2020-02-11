Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0A4A159A2A
	for <lists+io-uring@lfdr.de>; Tue, 11 Feb 2020 21:03:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731734AbgBKUC4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Feb 2020 15:02:56 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37913 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731722AbgBKUC4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Feb 2020 15:02:56 -0500
Received: by mail-wr1-f68.google.com with SMTP id y17so14056196wrh.5;
        Tue, 11 Feb 2020 12:02:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=qMiSHIRbdzW3UGsV0CTSItDQk6U8dFeQqM5nwbwYTLk=;
        b=JhItJE9v3lQu9D40opOS6v9TouSFMBTYwvO1dSj/Jw1E2q2tySJVLIEDAgYL0/Ldr7
         dOAT7q+AG6ZjLCFhR/PcLwje5nrkbyXi45EqG4lSrXvauA/pe354mh9MLOH8LvxAcFG3
         aTL+58dd46iwnUx1/CyL4LHrq4QqNzmxQeVotzwtnlr3tRVh6H5XnGa/ME8pZmqK2duW
         rQG/UM0xfQDkQJHElzpFdNzPAODmpGKzo2b0PwffYhwo8iEEjg3BCVYFOEBx3Q8dV/Hb
         EyKeZwwMyBwHZUMvXYSL1e/qZA8dt5y6eJKqWRQIw3NlxSBsFRlhC2JdmbnzQYhS80Bo
         8Wbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qMiSHIRbdzW3UGsV0CTSItDQk6U8dFeQqM5nwbwYTLk=;
        b=LCgS7IVDIjlzo2ULsOjh+GK78ARnmRMIZwEtW0vYmLJEtrWLxLlNLcLYsZ54X9WbAQ
         3Zhw3pUmiFZ2u36Nfb4NCx0RVwB5+kpOQC3Rh4/veeD4nbYLadcgjRpJA3lPqVghzKxu
         scziNUnTLUkbQ19+7yze24b2h8ROLXDOR/2dn4ByajUFSlhWqWvNrU7928/lB5wYAt8v
         nfKiE2P/1gDo3vsdZ6bzxPMNnZY5vtWI2CxLPy4gW4Q7nQmra7E5YRJQrTmudNYzsjn8
         w+qBluFOfI2PRyRWyWW5twtd5RWb5QETwYjaX+mnOOkqI/8XquHwZrUjTJsBEIKp9mVQ
         3Fzg==
X-Gm-Message-State: APjAAAU39s7bKNGd6Eyz19wOHrZIecD6wyzExQOD8F2uRUMheo0iFzv2
        YrSduarA947PvCPuu/p0nBXpPo8P
X-Google-Smtp-Source: APXvYqzyVSJFs9k3jXMni0lOF58D9WNghqgSRDIWYrxWCBrA+Hye+zfx8cJo7CRXQel+EB1d9azW4A==
X-Received: by 2002:a5d:6ac4:: with SMTP id u4mr10145014wrw.318.1581451374009;
        Tue, 11 Feb 2020 12:02:54 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.62])
        by smtp.gmail.com with ESMTPSA id 4sm4955101wmg.22.2020.02.11.12.02.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2020 12:02:53 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] io_uring: purge req->in_async
Date:   Tue, 11 Feb 2020 23:01:58 +0300
Message-Id: <4ec21bcc4b477808d918efa6ec691469207b1db1.1581450491.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1581450491.git.asml.silence@gmail.com>
References: <cover.1581450491.git.asml.silence@gmail.com>
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
index b33f2521040e..a50e7ac41668 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -550,7 +550,6 @@ struct io_kiocb {
 	 * llist_node is only used for poll deferred completions
 	 */
 	struct llist_node		llist_node;
-	bool				in_async;
 	bool				needs_fixed_file;
 	u8				opcode;
 
@@ -1974,14 +1973,13 @@ static inline void io_rw_done(struct kiocb *kiocb, ssize_t ret)
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
@@ -2274,7 +2272,7 @@ static int io_read(struct io_kiocb *req, struct io_kiocb **nxt,
 
 		/* Catch -EAGAIN return for forced non-blocking submission */
 		if (!force_nonblock || ret2 != -EAGAIN) {
-			kiocb_done(kiocb, ret2, nxt, req->in_async);
+			kiocb_done(kiocb, ret2, nxt);
 		} else {
 copy_iov:
 			ret = io_setup_async_rw(req, io_size, iovec,
@@ -2387,7 +2385,7 @@ static int io_write(struct io_kiocb *req, struct io_kiocb **nxt,
 		if (ret2 == -EOPNOTSUPP && (kiocb->ki_flags & IOCB_NOWAIT))
 			ret2 = -EAGAIN;
 		if (!force_nonblock || ret2 != -EAGAIN) {
-			kiocb_done(kiocb, ret2, nxt, req->in_async);
+			kiocb_done(kiocb, ret2, nxt);
 		} else {
 copy_iov:
 			ret = io_setup_async_rw(req, io_size, iovec,
@@ -4523,7 +4521,6 @@ static void io_wq_submit_work(struct io_wq_work **workptr)
 	}
 
 	if (!ret) {
-		req->in_async = true;
 		do {
 			ret = io_issue_sqe(req, NULL, &nxt, false);
 			/*
@@ -5059,7 +5056,6 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 			*mm = ctx->sqo_mm;
 		}
 
-		req->in_async = async;
 		req->needs_fixed_file = async;
 		trace_io_uring_submit_sqe(ctx, req->opcode, req->user_data,
 						true, async);
-- 
2.24.0

