Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9D1A31EEF6
	for <lists+io-uring@lfdr.de>; Thu, 18 Feb 2021 19:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233369AbhBRSwL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Feb 2021 13:52:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232686AbhBRSf5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Feb 2021 13:35:57 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 627FCC0617A7
        for <io-uring@vger.kernel.org>; Thu, 18 Feb 2021 10:33:47 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id n10so4842843wmq.0
        for <io-uring@vger.kernel.org>; Thu, 18 Feb 2021 10:33:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=E22oZ3xO+5P3r1eEWOlsAQRLFuYc2i7++E0WWA1bMPU=;
        b=RzMpQxGGi1HcBS9chPhzMRuUCH4YfCtdC42Ezsd+UFkP+e+ah6HuaEE2EXkGZXVnrc
         JBCfsPkJBnhVNFN5wsXtqm03WJsu2bNBP3mc2e5XJf0PoWoqzKsvBiLjrGXsY98XtmBo
         RyZVbT9v9z2zHjmawPo3xHLZ8InqAU2BPM2S29V3l71jdT40WnKp4NDkjKgp2ZEBrv9E
         7pebI9R9HuXUpqITVER3dxVqDVoTMX8Jl0pkxdkJUvqACNyJ+VpR0RPecC6dRHf5596c
         8PROmrLgTZ/dJkyBTYtqNPhngpviy8SgYwYL/h1YlnKQdA93W55SJ4PGVu6h+W1sQlUW
         JV/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E22oZ3xO+5P3r1eEWOlsAQRLFuYc2i7++E0WWA1bMPU=;
        b=GtlxEeBDpLX8XeHiARSuBbuZnoPjYTPxb1hYydQDK7PKxwBr5HJTe1ZPKlpgY38MqF
         NWMr8DpX9nzu/EQ/gTs0WsgjaDhN679ALMVsDfSjfRzMMfsnmzkXgHaB9xrO2d3GnVa4
         GdElFhzcKKQaU80yGUdFhhYuBBcE8c4bwHznqlRQxJ+im3HcnM+yHHb2qMWNJzSTG7OW
         FJHpCWTVFYr46PAF9GSNXcwhMrbGjTvNBsiTPv7m7ZaLPotwPF+qQwIhoNDBubnEOvDT
         7wY2MzFTSJgmOPmSoQNluYYESwAcIEac6Cw1xil0PY+kSjtUszISPaVpPvRcNVcBBR/K
         unWQ==
X-Gm-Message-State: AOAM530hefC9c+xHueD/rH0W2njsjEprrk8R0WJVmseXAlBBA5lv/CP8
        O9+u8/73l2sY5LJfrEa+ZqicbPSIv9C+eg==
X-Google-Smtp-Source: ABdhPJyUzJA1pRVTvInJqcbxV1OQWQHHR3Lnu9gMVONPqCvOGcV5UH4wSmhbbxTNKHepbsxx9yooUA==
X-Received: by 2002:a7b:c2aa:: with SMTP id c10mr4764910wmk.101.1613673226165;
        Thu, 18 Feb 2021 10:33:46 -0800 (PST)
Received: from localhost.localdomain ([85.255.236.139])
        by smtp.gmail.com with ESMTPSA id 36sm4034459wrh.94.2021.02.18.10.33.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 10:33:45 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 02/11] io_uring: keep io_*_prep() naming consistent
Date:   Thu, 18 Feb 2021 18:29:38 +0000
Message-Id: <6a317da20c80788cd97a10883773aa09c3192a08.1613671791.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1613671791.git.asml.silence@gmail.com>
References: <cover.1613671791.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Follow io_*_prep() naming pattern, there are only fsync and sfr that
don't do that.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 32a6c89e69b1..adb5cd4b760d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4008,7 +4008,7 @@ static int io_nop(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
-static int io_prep_fsync(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+static int io_fsync_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
@@ -4595,7 +4595,7 @@ static int io_close(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
-static int io_prep_sfr(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+static int io_sfr_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
@@ -6081,9 +6081,9 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	case IORING_OP_POLL_REMOVE:
 		return io_poll_remove_prep(req, sqe);
 	case IORING_OP_FSYNC:
-		return io_prep_fsync(req, sqe);
+		return io_fsync_prep(req, sqe);
 	case IORING_OP_SYNC_FILE_RANGE:
-		return io_prep_sfr(req, sqe);
+		return io_sfr_prep(req, sqe);
 	case IORING_OP_SENDMSG:
 	case IORING_OP_SEND:
 		return io_sendmsg_prep(req, sqe);
-- 
2.24.0

