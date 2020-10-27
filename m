Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECC0629CCFA
	for <lists+io-uring@lfdr.de>; Wed, 28 Oct 2020 02:38:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbgJ1Bid (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Oct 2020 21:38:33 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46781 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1832996AbgJ0XUY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Oct 2020 19:20:24 -0400
Received: by mail-wr1-f65.google.com with SMTP id n6so3676394wrm.13
        for <io-uring@vger.kernel.org>; Tue, 27 Oct 2020 16:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Oox0vUrTrEPd81BzUHRPDa+HCEWkqEh9x0obMTzksTk=;
        b=S7X741hVqgTofZA1nxp9xA/9TmEjZuBFK2pb/IxR+WyAbzywOm1zt0JHbmPt+RyOep
         pVWGBrFKn3a4Ho2bxs/9SeIRNWiSq5YtZAwEINvZYTsu95eXvXK8MnSbexx2d/bLimax
         2dDNQ+iENCqaiQSqHKBmLqvV0+1TaOLAcbuTom6F8pz3Qwxtlyi0KDhFt68wxDrZIAcW
         cNctQNEiqfgHw49bb2pFyh9SM4HhaMON41UCPQx4bn6U6PCxTrv8cBIKqQfcyvLDkl1A
         fWF0H8n0BLWu3xzSIOt//pzxJ+dqsuarXjjZKtrov9QDXcHaRclpeEI6WysllTihWoSQ
         96GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Oox0vUrTrEPd81BzUHRPDa+HCEWkqEh9x0obMTzksTk=;
        b=Iwn1rL/a3p/2AmxIPejxsaLj3HTx6XjrzzRJcN8m4DwIuI0cZvfpiCVwV9FFxnmjz7
         oP+PlWY8WN3e2KDm6sffNat+Zeavb6nNkJ4Fr6Rf1BV0qgLTAsGQQGgVFV0pQKQpA8d6
         P7UbBAFmtXq4uWft92WVIXNUFewSmK3Y7QvsBCuDqkBDGLzT4zPAl+0FKKx4T0cS8vwI
         6M8jAjJJTEKZe569RL+ESlZkE1Z8VUtppc7oGD5Gcng9hGv265ttpl5soCgcenQSdZ2D
         G+WBz7EDgm9AvR/PoW367dklyFFeBprTyjwz8r84YjAOL5IBCwTioUgzyUntxb/yTLVE
         oQlQ==
X-Gm-Message-State: AOAM533PoW1NuVjfuDnpMRrHpq43J65+hCcDUD4tap4vt8GPut00TBRQ
        JYh5vBT50ePf7h1TGeqfh1PCbnPudQ1zGA==
X-Google-Smtp-Source: ABdhPJzZoUhRFaQ/7pNAGpvYdsNWNxDQHZPQ6PE4115gPczpYcDPA3Sdy2cLNxlllB8wVKASE7LlWQ==
X-Received: by 2002:adf:a354:: with SMTP id d20mr5757954wrb.29.1603840821968;
        Tue, 27 Oct 2020 16:20:21 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id x10sm3749688wrp.62.2020.10.27.16.20.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 16:20:21 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH] io_uring: split poll and poll_remove structs
Date:   Tue, 27 Oct 2020 23:17:18 +0000
Message-Id: <82ba9ad37b37e28e325f7512ed15c8bda8c19986.1603805098.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't use a single struct for polls and poll remove requests, they have
totally different layout.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2f6af230e86e..3d244c61a5c3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -394,16 +394,18 @@ struct io_ring_ctx {
  */
 struct io_poll_iocb {
 	struct file			*file;
-	union {
-		struct wait_queue_head	*head;
-		u64			addr;
-	};
+	struct wait_queue_head		*head;
 	__poll_t			events;
 	bool				done;
 	bool				canceled;
 	struct wait_queue_entry		wait;
 };
 
+struct io_poll_rem {
+	struct file			*file;
+	u64				addr;
+};
+
 struct io_close {
 	struct file			*file;
 	struct file			*put_file;
@@ -649,6 +651,7 @@ struct io_kiocb {
 		struct file		*file;
 		struct io_rw		rw;
 		struct io_poll_iocb	poll;
+		struct io_poll_rem	poll_rem;
 		struct io_accept	accept;
 		struct io_sync		sync;
 		struct io_cancel	cancel;
@@ -5280,7 +5283,7 @@ static int io_poll_remove_prep(struct io_kiocb *req,
 	    sqe->poll_events)
 		return -EINVAL;
 
-	req->poll.addr = READ_ONCE(sqe->addr);
+	req->poll_rem.addr = READ_ONCE(sqe->addr);
 	return 0;
 }
 
@@ -5291,12 +5294,10 @@ static int io_poll_remove_prep(struct io_kiocb *req,
 static int io_poll_remove(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	u64 addr;
 	int ret;
 
-	addr = req->poll.addr;
 	spin_lock_irq(&ctx->completion_lock);
-	ret = io_poll_cancel(ctx, addr);
+	ret = io_poll_cancel(ctx, req->poll_rem.addr);
 	spin_unlock_irq(&ctx->completion_lock);
 
 	if (ret < 0)
-- 
2.24.0

