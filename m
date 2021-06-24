Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 916913B30FE
	for <lists+io-uring@lfdr.de>; Thu, 24 Jun 2021 16:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbhFXOMr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Jun 2021 10:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbhFXOMq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Jun 2021 10:12:46 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C76D4C061574
        for <io-uring@vger.kernel.org>; Thu, 24 Jun 2021 07:10:26 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id m18so6838805wrv.2
        for <io-uring@vger.kernel.org>; Thu, 24 Jun 2021 07:10:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=gfBtRUn2zuho+ckBM7bWZUM3U7BiMTntDsAkDPL8A98=;
        b=eqtzQZEL95nccha45RgztKejhM8O3iZfnvwA87KUGhplyo2vh/SsLzYXl46kulWzBZ
         MrpwR8cyiQlIPAnfJ4yDYmLc0FKaAK/foHccMNrxbo66bNFiGyTriG1WI/ICarlyP6Rc
         CuVJh5HH36tcQj3G8GiHYTarXLdnrREd55CT4lPoFcZCoLRP+3+M5g4A+Lgw4+4CxGM3
         ENszgWIElFOVpOYZWM8xQHXYw/p/1wx0HyOWSDkigVDsaeRUW1IKYAVVGR3OQtxWXbIK
         uIZ3MT+1wfgLzZG6LnJAO7xr+JaLI/pAAGNPkdL4BRZUSC/mxAL0wl8c+wicmaZxvMMh
         TGtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gfBtRUn2zuho+ckBM7bWZUM3U7BiMTntDsAkDPL8A98=;
        b=gFhOsbHz6YefLqT1Wp6K8oWbicUmh+xw6XoPcVuzLVHt69/hX44/xUzin+HQ78m2oS
         oDoM+LITSNv1fmfbtt5iWOfj3CIOZIqwWTbgohRbZwbdlcJK0/y8aICCOk7hoXW9qW0j
         s7LLWgviteQMT82zHRH1eI8tY/oajc98t2AC7n/bPmZil1p6MRAsh+x6g7+bFqYnJibb
         pcY5HRraifZ0vD72Cw533KUflTmREiYvt026cGHukQzdovL3Y92BIxemSQWzLQzr+1Nt
         edFkliYlrXOlVjLZYeQrW1dvBENcrjohJKfy4X2htTn/4zMGkfUHTOEuVDx1ipQX+O71
         cXSw==
X-Gm-Message-State: AOAM531fhAvTmYFZaxTS5C8JN9/q3+ZsudALaZ75usEwBVLG4x/yyTKg
        SELzegLI5niJNtNanXp654s=
X-Google-Smtp-Source: ABdhPJx5nSF4eKqTaGJIo5cpDwfYWLCPcEXwAAxiKzuZiQLQcv3M9JGu75/8r2BdcCWYzDXvlwveWw==
X-Received: by 2002:adf:eb0c:: with SMTP id s12mr4735149wrn.281.1624543825439;
        Thu, 24 Jun 2021 07:10:25 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.93])
        by smtp.gmail.com with ESMTPSA id w2sm3408428wrp.14.2021.06.24.07.10.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 07:10:25 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/6] io_uring: fix code style problems
Date:   Thu, 24 Jun 2021 15:09:57 +0100
Message-Id: <cfaf9a2f27b43934144fe9422a916bd327099f44.1624543113.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1624543113.git.asml.silence@gmail.com>
References: <cover.1624543113.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Fix a bunch of problems mostly found by checkpatch.pl

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5745b3809b0d..669d1b48e4cb 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -173,7 +173,7 @@ struct io_rings {
 	 * Written by the application, shouldn't be modified by the
 	 * kernel.
 	 */
-	u32                     cq_flags;
+	u32			cq_flags;
 	/*
 	 * Number of completion events lost because the queue was full;
 	 * this should be avoided by the application by making sure
@@ -883,7 +883,7 @@ struct io_kiocb {
 	struct hlist_node		hash_node;
 	struct async_poll		*apoll;
 	struct io_wq_work		work;
-	const struct cred 		*creds;
+	const struct cred		*creds;
 
 	/* store used ubuf, so we can prevent reloading */
 	struct io_mapped_ubuf		*imu;
@@ -1736,7 +1736,7 @@ static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx)
 {
 	struct io_submit_state *state = &ctx->submit_state;
 
-	BUILD_BUG_ON(IO_REQ_ALLOC_BATCH > ARRAY_SIZE(state->reqs));
+	BUILD_BUG_ON(ARRAY_SIZE(state->reqs) < IO_REQ_ALLOC_BATCH);
 
 	if (!state->free_reqs) {
 		gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
@@ -2798,7 +2798,7 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
 	else
 		io_rw_done(kiocb, ret);
 
-	if (check_reissue && req->flags & REQ_F_REISSUE) {
+	if (check_reissue && (req->flags & REQ_F_REISSUE)) {
 		req->flags &= ~REQ_F_REISSUE;
 		if (io_resubmit_prep(req)) {
 			req_ref_get(req);
@@ -3761,7 +3761,7 @@ static int io_shutdown(struct io_kiocb *req, unsigned int issue_flags)
 static int __io_splice_prep(struct io_kiocb *req,
 			    const struct io_uring_sqe *sqe)
 {
-	struct io_splice* sp = &req->splice;
+	struct io_splice *sp = &req->splice;
 	unsigned int valid_flags = SPLICE_F_FD_IN_FIXED | SPLICE_F_ALL;
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
@@ -3815,7 +3815,7 @@ static int io_tee(struct io_kiocb *req, unsigned int issue_flags)
 
 static int io_splice_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	struct io_splice* sp = &req->splice;
+	struct io_splice *sp = &req->splice;
 
 	sp->off_in = READ_ONCE(sqe->splice_off_in);
 	sp->off_out = READ_ONCE(sqe->off);
@@ -8763,6 +8763,7 @@ static int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg)
 	ctx->cq_ev_fd = eventfd_ctx_fdget(fd);
 	if (IS_ERR(ctx->cq_ev_fd)) {
 		int ret = PTR_ERR(ctx->cq_ev_fd);
+
 		ctx->cq_ev_fd = NULL;
 		return ret;
 	}
@@ -9543,9 +9544,8 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		io_cqring_overflow_flush(ctx, false);
 
 		ret = -EOWNERDEAD;
-		if (unlikely(ctx->sq_data->thread == NULL)) {
+		if (unlikely(ctx->sq_data->thread == NULL))
 			goto out;
-		}
 		if (flags & IORING_ENTER_SQ_WAKEUP)
 			wake_up(&ctx->sq_data->wait);
 		if (flags & IORING_ENTER_SQ_WAIT) {
-- 
2.32.0

