Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2F3B3F02F7
	for <lists+io-uring@lfdr.de>; Wed, 18 Aug 2021 13:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233798AbhHRLoE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Aug 2021 07:44:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235943AbhHRLoB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Aug 2021 07:44:01 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40517C061796
        for <io-uring@vger.kernel.org>; Wed, 18 Aug 2021 04:43:26 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id h13so3082317wrp.1
        for <io-uring@vger.kernel.org>; Wed, 18 Aug 2021 04:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=dIhlfb21vpL3flEyZOCE3wV9y9gCGPDiVSRTgdvfzCU=;
        b=vXDWn7I3H0mG2lxCt56Bw/eK3z0WqS6do0HIsZYfp1SiBw27FYHM0BvHT+kZp5DtKo
         hZQhHsbkXwfPso2914Z4w2ejbDzjp8BZ5F9mbCYzZItXH1qbuEmQtnGTw8TDstMJFyvx
         DpbNA5EjDUJGZxJ8JpleUOtXsln8AHBnr98Go+siMOXtn85IqXlEmCIxk7zdeIrKgBEi
         r/5lLezZdbirG2j/lNXrbmTk0L73vVhuSG8X+giVOLGxT/iIh13XAkRqYO1VjT7BEK2P
         cD6lWziEZbgjsruLT/PWZvbX3Sb/TWKGyx/X3StDf0UyDEuPNVNJe5vJC829ZsQTAdoC
         NhBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dIhlfb21vpL3flEyZOCE3wV9y9gCGPDiVSRTgdvfzCU=;
        b=lldXh3oKSX2b/VVtmjGffZAl/OOM4cau5HGfVol0Mv6b15BbeElmHezGL2ojHm2L+e
         LN6YREoDHdNUvZXTscb4F69YNchBikmgbEXuK1xNlo9kbVuZzaPtUuPGwcvc2tMSgL66
         KDK6OMCUSm0DFcdKJXKdR37kpxvheocRsHCkep0MmnxPUQ5U0OsQTysTd6XpJdpKC/vA
         rZoY/9occ7eFE/7fanGBa7SjwQqZELd8VF8aY+W7HCcI2q7wJ0f/Xl9aikVvpF2OsUY/
         LHCIhYmki/FiSlXfu3lJzwb8taGCcLKl+Cr5rntIUFn+kNzqEIf2FaT7YGXtOlRI9gDs
         MjMg==
X-Gm-Message-State: AOAM532qoSrvg1TImz4MIXe7tdggYlgXsEqZVrwVu8hSC8AGUfrwiuyf
        cf4r1N/uHIiC7DkPDj8SXjY=
X-Google-Smtp-Source: ABdhPJx2VP5nEVSInE3OV+ZjCNdlSwpbOD90+1YM47bTeTxnsS1pV7fEiLW7Nk8OOM0CmLrPD+0yQA==
X-Received: by 2002:a5d:6e0c:: with SMTP id h12mr10251900wrz.334.1629287004965;
        Wed, 18 Aug 2021 04:43:24 -0700 (PDT)
Received: from localhost.localdomain ([185.69.145.2])
        by smtp.gmail.com with ESMTPSA id c7sm4581918wmq.13.2021.08.18.04.43.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 04:43:24 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/3] io_uring: IRQ rw completion batching
Date:   Wed, 18 Aug 2021 12:42:47 +0100
Message-Id: <94589c3ce69eaed86a21bb1ec696407a54fab1aa.1629286357.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1629286357.git.asml.silence@gmail.com>
References: <cover.1629286357.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Employ inline completion logic for read/write completions done via
io_req_task_complete(). If ->uring_lock is contended, just do normal
request completion, but if not, make tctx_task_work() to grab the lock
and do batched inline completions in io_req_task_complete().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 54c4d8326944..7179e34df8e9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2061,6 +2061,8 @@ static void tctx_task_work(struct callback_head *cb)
 			if (req->ctx != ctx) {
 				ctx_flush_and_put(ctx, &locked);
 				ctx = req->ctx;
+				/* if not contended, grab and improve batching */
+				locked = mutex_trylock(&ctx->uring_lock);
 			}
 			req->io_task_work.func(req, &locked);
 			node = next;
@@ -2572,7 +2574,20 @@ static bool __io_complete_rw_common(struct io_kiocb *req, long res)
 
 static void io_req_task_complete(struct io_kiocb *req, bool *locked)
 {
-	__io_req_complete(req, 0, req->result, io_put_rw_kbuf(req));
+	unsigned int cflags = io_put_rw_kbuf(req);
+	long res = req->result;
+
+	if (*locked) {
+		struct io_ring_ctx *ctx = req->ctx;
+		struct io_submit_state *state = &ctx->submit_state;
+
+		io_req_complete_state(req, res, cflags);
+		state->compl_reqs[state->compl_nr++] = req;
+		if (state->compl_nr == ARRAY_SIZE(state->compl_reqs))
+			io_submit_flush_completions(ctx);
+	} else {
+		io_req_complete_post(req, res, cflags);
+	}
 }
 
 static void __io_complete_rw(struct io_kiocb *req, long res, long res2,
-- 
2.32.0

