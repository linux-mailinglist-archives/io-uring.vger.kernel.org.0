Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C89BC154AE2
	for <lists+io-uring@lfdr.de>; Thu,  6 Feb 2020 19:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727662AbgBFSRF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Feb 2020 13:17:05 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:35006 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727358AbgBFSRE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Feb 2020 13:17:04 -0500
Received: by mail-ed1-f67.google.com with SMTP id f8so7000682edv.2;
        Thu, 06 Feb 2020 10:17:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FDNhC9WMlrP1LhXrRyNHyiDOG67giK/5xeZUkY6OGb8=;
        b=OzjuQ7GsD5pMv7xXrCU3SwSvWEuiZNWOnzoOAi4qdyrLDEBs293wDpCCd/3j/wwW6U
         veyrB1fVhcfDBcsaGC/3Q/rGrIVO54Ch6/lk+BPj4m6731rqxuKAfv1E/v+M1Zf/QVpX
         RiNvBxeOtmNFq2bErF79oCO2Q8XSw3MhPXTiTaS0nF3/SSZeX9+JqI64X1Lv7HIB97n1
         vXmP8r130y3NuL56h+ps1xMsrKQi9RJPMal4ifSZ4FtbzjfsvjkgA/3vsz96yQGmSkOe
         Y7f7JSHL3kDMSv/oHob1F/WaqMHRgC8Szqqb9521hDpqsBv3UjqLWzdMoBl5emw3bDdq
         /Wdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FDNhC9WMlrP1LhXrRyNHyiDOG67giK/5xeZUkY6OGb8=;
        b=rQFD9oclwRuB2tEay/Oh7rxh6mNtVqzer/MwPO37k8ZiG3dla5uZSMQ4eb7VQZmNtA
         wrzZbtyw+5EYt5dXB3se5X1ii+hE9qDMNYWtL5BewFjeVGz+J5Klv9hgThuD1q8xyZ+T
         zH+eCD/j4b6n3kLdBSFRTj7Kf3FV3r8PCTskNuZ74KsnuVvG5pJ7yCpVxjgOdDJsdis5
         ehM6LBSJxB0jZbneIde0bDlW2bbO5iT5YqdwTQ+QoGpkZ4eNvG8ytZ7k6LozGFPig0Dm
         PHuPjk3pvZaSaOIi4bRJ5RXVo1K5dBT3DaN6IKljpnW4vsJpK22AYY6qK18NljBY379M
         ftCw==
X-Gm-Message-State: APjAAAXAJIolfhcdUExzLUtY+nVdI5nCciVql7yANQ3SXBaoJw6UQ7O4
        q0VVwEmajNyZs1xgpW+AGqwY970p
X-Google-Smtp-Source: APXvYqxKsSxAckbPtZqtY+huWTHiiIk/6Ntj+OuEcFhnmjdagXVqKT3uv/SQgJsZLMY3t4mt3OG5Kw==
X-Received: by 2002:a05:6402:17aa:: with SMTP id j10mr4051042edy.256.1581013022914;
        Thu, 06 Feb 2020 10:17:02 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.62])
        by smtp.gmail.com with ESMTPSA id n11sm24909eje.86.2020.02.06.10.16.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 10:17:02 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] io_uring: fix delayed mm check
Date:   Thu,  6 Feb 2020 21:16:09 +0300
Message-Id: <5c7db203bb5aa23c22f16925ac00d50bdbe406e0.1581012158.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Fail fast if can't grab mm, so past that requests always have an mm
when required. This fixes not checking mm fault for
IORING_OP_{READ,WRITE}, as well allows to remove req->has_user
altogether.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

v2: remove ->has_user (Jens)

 fs/io_uring.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ce3dbd2b1b5c..1914351ebd5e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -516,6 +516,7 @@ enum {
 	REQ_F_TIMEOUT_NOSEQ	= BIT(REQ_F_TIMEOUT_NOSEQ_BIT),
 	/* completion under lock */
 	REQ_F_COMP_LOCKED	= BIT(REQ_F_COMP_LOCKED_BIT),
+
 };
 
 /*
@@ -548,7 +549,6 @@ struct io_kiocb {
 	 * llist_node is only used for poll deferred completions
 	 */
 	struct llist_node		llist_node;
-	bool				has_user;
 	bool				in_async;
 	bool				needs_fixed_file;
 	u8				opcode;
@@ -2051,9 +2051,6 @@ static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
 		return iorw->size;
 	}
 
-	if (!req->has_user)
-		return -EFAULT;
-
 #ifdef CONFIG_COMPAT
 	if (req->ctx->compat)
 		return compat_import_iovec(rw, buf, sqe_len, UIO_FASTIOV,
@@ -4418,7 +4415,6 @@ static void io_wq_submit_work(struct io_wq_work **workptr)
 	}
 
 	if (!ret) {
-		req->has_user = (work->flags & IO_WQ_WORK_HAS_MM) != 0;
 		req->in_async = true;
 		do {
 			ret = io_issue_sqe(req, NULL, &nxt, false);
@@ -4922,6 +4918,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 	for (i = 0; i < nr; i++) {
 		const struct io_uring_sqe *sqe;
 		struct io_kiocb *req;
+		int err;
 
 		req = io_get_req(ctx, statep);
 		if (unlikely(!req)) {
@@ -4938,20 +4935,23 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 		submitted++;
 
 		if (unlikely(req->opcode >= IORING_OP_LAST)) {
-			io_cqring_add_event(req, -EINVAL);
+			err = -EINVAL;
+fail_req:
+			io_cqring_add_event(req, err);
 			io_double_put_req(req);
 			break;
 		}
 
 		if (io_op_defs[req->opcode].needs_mm && !*mm) {
 			mm_fault = mm_fault || !mmget_not_zero(ctx->sqo_mm);
-			if (!mm_fault) {
-				use_mm(ctx->sqo_mm);
-				*mm = ctx->sqo_mm;
+			if (unlikely(mm_fault)) {
+				err = -EFAULT;
+				goto fail_req;
 			}
+			use_mm(ctx->sqo_mm);
+			*mm = ctx->sqo_mm;
 		}
 
-		req->has_user = *mm != NULL;
 		req->in_async = async;
 		req->needs_fixed_file = async;
 		trace_io_uring_submit_sqe(ctx, req->opcode, req->user_data,
-- 
2.24.0

