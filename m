Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2780D2B33F2
	for <lists+io-uring@lfdr.de>; Sun, 15 Nov 2020 11:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgKOKkA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 Nov 2020 05:40:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727073AbgKOKjE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 Nov 2020 05:39:04 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 923B5C0617A7
        for <io-uring@vger.kernel.org>; Sun, 15 Nov 2020 02:39:04 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id u12so8269384wrt.0
        for <io-uring@vger.kernel.org>; Sun, 15 Nov 2020 02:39:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=4fWNwK5lGnln3p8oQU6/SvGOq/OsiF1xOEZJ4QjoV8Q=;
        b=s+8UEZyeTRrXdYM5mvmsIsJ3n4Cw7pthGo9A+eEcS/4iS3MeammbyCC1+v156gvf1y
         dGFUhCcpJDOtjbX4cTnfhSADHUw28X3Z+m61UzFYAfugtIDLAtsjJSUbAcbrEoAC1CLL
         8xq10fOgI3E0tFeZSqyyq4neixLdoXBtgM8zytLWiFEcBwGCRs0o/MVdlMu5sz/zpom3
         cMgxrUwVeWXNe/hFb5hMqtW7NT2YzpPdhBkUvzxeCvETnnOrJ57BIOzHXnHqSw3yjWtj
         kZ+1vKEIku3QJI7oEBcoXSxGEq+tj6ikf0tfdPVe39m/sJYdO/FHx40GV+ThH0CDPcni
         LnIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4fWNwK5lGnln3p8oQU6/SvGOq/OsiF1xOEZJ4QjoV8Q=;
        b=UUiMqumHtSyH6/ty9IfDW+7jhL/pUvBESyLBJgXu8FBdq2PpI16fThd51RnFciQrRZ
         cEhDRRZY7ZAKHzglgmzMBWbqpsTjioAwwaeo2X3S8hnKSuPZKDn7luYzoNW1+wpPM3Dx
         8pT+P5KlMbAMwq6eCwi9Il9Bj5vxokT3AONf87L4U8purOZ2wU4jflTS2+c4YU7DJV9h
         twAw+3kn/2BfgWNf8PwKVGyemhDpf8r+inVsUUE8bJglVJE1X370hgKdMoTx+SrX0nrx
         2EeU9bUp2pENy6tnnnKg6sByLcQwoxIYWOLKHQVRLlkyPjE7K3L8PU9ExHOHje5pDSCV
         ip2w==
X-Gm-Message-State: AOAM5334kn8mOM01MbZ2NC1T24TflnMA8SudwYAk9yzN3s7FCtqwUxKV
        EtdrY5Gxw5mXFjoNe+6QFgU=
X-Google-Smtp-Source: ABdhPJyLG9KbAo10Hv95Q0Zv8v5a52o1KBMYD1zXYN0Msjj4sRw4L3LOvutSDH2AUaXmzikAlmEeUA==
X-Received: by 2002:adf:a54d:: with SMTP id j13mr14317604wrb.132.1605436743306;
        Sun, 15 Nov 2020 02:39:03 -0800 (PST)
Received: from localhost.localdomain (host109-152-100-189.range109-152.btcentralplus.com. [109.152.100.189])
        by smtp.gmail.com with ESMTPSA id b14sm17790900wrs.46.2020.11.15.02.39.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 02:39:02 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        v@nametag.social
Subject: [PATCH 3/5] io_uring: opcode independent import_fixed
Date:   Sun, 15 Nov 2020 10:35:42 +0000
Message-Id: <ca7010375770aef88dda800021e79db1e6729585.1605435507.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1605435507.git.asml.silence@gmail.com>
References: <cover.1605435507.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Pass a buf explicitly into io_import_fixed(), so it can be used not only
for rw requests.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 88daf5fc7e8e..7703291617f3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2933,21 +2933,18 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
 		io_rw_done(kiocb, ret);
 }
 
-static ssize_t io_import_fixed(struct io_kiocb *req, int rw,
-			       struct iov_iter *iter)
+static ssize_t io_import_fixed(struct io_kiocb *req, int rw, u64 buf_addr,
+			       size_t len, struct iov_iter *iter)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	size_t len = req->rw.len;
 	struct io_mapped_ubuf *imu;
 	u16 index, buf_index = req->buf_index;
 	size_t offset;
-	u64 buf_addr;
 
 	if (unlikely(buf_index >= ctx->nr_user_bufs))
 		return -EFAULT;
 	index = array_index_nospec(buf_index, ctx->nr_user_bufs);
 	imu = &ctx->user_bufs[index];
-	buf_addr = req->rw.addr;
 
 	/* overflow */
 	if (buf_addr + len < buf_addr)
@@ -3153,7 +3150,7 @@ static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
 	opcode = req->opcode;
 	if (opcode == IORING_OP_READ_FIXED || opcode == IORING_OP_WRITE_FIXED) {
 		*iovec = NULL;
-		return io_import_fixed(req, rw, iter);
+		return io_import_fixed(req, rw, req->rw.addr, sqe_len, iter);
 	}
 
 	/* buffer index only valid with fixed read/write, or buffer select  */
-- 
2.24.0

