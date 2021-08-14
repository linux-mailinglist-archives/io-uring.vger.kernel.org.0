Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6C413EC3D0
	for <lists+io-uring@lfdr.de>; Sat, 14 Aug 2021 18:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235202AbhHNQ1S (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 14 Aug 2021 12:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234941AbhHNQ1R (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 14 Aug 2021 12:27:17 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09722C061764
        for <io-uring@vger.kernel.org>; Sat, 14 Aug 2021 09:26:49 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id q11so17491597wrr.9
        for <io-uring@vger.kernel.org>; Sat, 14 Aug 2021 09:26:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=S+JzyijSWcsZ/CNO4Pn+QVufVB4fJpDt/9S5X8A9eA8=;
        b=Gu3HpL/mFs94WAIwJVTgaU0TTIaVUhATsXLq/gPpbVUW09vS1B574OU4UCLs5gGNgc
         +GW6fzP6YXLYm+TBFHZRn3Wh7DCgJ0Aio4w2xxVAULHyUJT6ZptClMKlp2JVHu0y2coD
         axGPcelmQDpTtT9cvCL/lrGtu45hPARtwXdULGoohW3Ek0VKMJyoIGc4MJtJxpSWo337
         jXJGIoal7/vdxDaVtknj7Bxiq/tcaHd1dsq42hpWJInoJw1mOSB/KXBkYEtYQ7sCT1Ap
         sMewLu25OIYFqjcgLVgN5Y3E6bq0ganM+PAcP4NPQHsZ//5MI7bbQn53PX5+YAQIVoTQ
         OuQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S+JzyijSWcsZ/CNO4Pn+QVufVB4fJpDt/9S5X8A9eA8=;
        b=L4Uorqr7C55KKHAp5CDDzeqDGwMCsak/uKPPgGf8meh08hDQAAAqgon6PRjMSosCW9
         tNs/epNW6lhoRP/AOiSOiE4/g/4ckKfITM6aLivvdsEvTObon+UuEkW4IZI2wHUpMhvm
         fL+pTLylFmaxN2e6Paghb88dWIHGu10HNOa56R7+K5kigYT1mH8Q0d7zysx4gTd3kL3k
         jN1YqsANrgyPq+5QfB1ClXoNWKlIleG+rbv+hDDSfArKbdIkDYh/u9S0wnP60T5AN6tD
         ZoBEKCeeNB149+79ZTtyGNymZGFS1KlxqcLCulIPwxLW5UqiFtArW65Ie5F1UGeSX2ng
         SM7Q==
X-Gm-Message-State: AOAM533/v7q6y4A36uKrBw1uKxuheWaCrXDbFGT9lRTl8Qf70lx2p5EO
        Bxv38wKojDboEqTkST4djUh4Op0Isv8=
X-Google-Smtp-Source: ABdhPJyyrUIKXdioddtNU8BHC4Ll3al3P6+QoAUrzHhNLln9YoQFBLt/ubvOlzCmeX9fetsfGpvLwA==
X-Received: by 2002:a05:6000:18c2:: with SMTP id w2mr8923262wrq.282.1628958407610;
        Sat, 14 Aug 2021 09:26:47 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.97])
        by smtp.gmail.com with ESMTPSA id m62sm5028263wmm.8.2021.08.14.09.26.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Aug 2021 09:26:47 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/5] io_uring: optimise iowq refcounting
Date:   Sat, 14 Aug 2021 17:26:06 +0100
Message-Id: <3243f06098128ce6587b3fbfdddeb1f63e21f418.1628957788.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628957788.git.asml.silence@gmail.com>
References: <cover.1628957788.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If a requests is forwarded into io-wq, there is a good chance it hasn't
been refcounted yet and we can save one req_ref_get() by setting the
refcount number to the right value directly.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 51c4166f68b5..0d9a443d4987 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1115,14 +1115,19 @@ static inline void req_ref_get(struct io_kiocb *req)
 	atomic_inc(&req->refs);
 }
 
-static inline void io_req_refcount(struct io_kiocb *req)
+static inline void __io_req_refcount(struct io_kiocb *req, int nr)
 {
 	if (!(req->flags & REQ_F_REFCOUNT)) {
 		req->flags |= REQ_F_REFCOUNT;
-		atomic_set(&req->refs, 1);
+		atomic_set(&req->refs, nr);
 	}
 }
 
+static inline void io_req_refcount(struct io_kiocb *req)
+{
+	__io_req_refcount(req, 1);
+}
+
 static inline void io_req_set_rsrc_node(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -6311,9 +6316,11 @@ static void io_wq_submit_work(struct io_wq_work *work)
 	struct io_kiocb *timeout;
 	int ret = 0;
 
-	io_req_refcount(req);
-	/* will be dropped by ->io_free_work() after returning to io-wq */
-	req_ref_get(req);
+	/* one will be dropped by ->io_free_work() after returning to io-wq */
+	if (!(req->flags & REQ_F_REFCOUNT))
+		__io_req_refcount(req, 2);
+	else
+		req_ref_get(req);
 
 	timeout = io_prep_linked_timeout(req);
 	if (timeout)
-- 
2.32.0

