Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60E9628A3EB
	for <lists+io-uring@lfdr.de>; Sun, 11 Oct 2020 01:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389447AbgJJWzm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 10 Oct 2020 18:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731266AbgJJTFU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 10 Oct 2020 15:05:20 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF27DC08EAE0
        for <io-uring@vger.kernel.org>; Sat, 10 Oct 2020 10:37:17 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id h5so3631656wrv.7
        for <io-uring@vger.kernel.org>; Sat, 10 Oct 2020 10:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=jqz5SmSTDwwfqyARoxTCWKo/0K8KU3ICbaLX4P2M8f8=;
        b=CA111z+6hTUoCvHweQcEk4VScW6+BrLhqYSns7tbqSWGLm6RZiHBuRAFrVAPzNHqGN
         ehpz9jqBdHWuOnfwCaHWQrw47GhCglAtVxSg2U+3Js5z4L0T5Azaa008dfHsr9TSbORB
         iZMOXzzhRBeY7KyCVlG7czkpPFC+t/U+JfXdVocMefltuly5WKYxeUdZZ/sJohCGZbUZ
         oHNqJGH53NNiB9flOmMVSNvEOeAMWr0ayjX8C+LYVsGVzZ7f9CpfHqhU1XQOn0uE287b
         edmrYuwHcFoXF0ykk3pG+4T97WI3+pOzEY8PvKTlwLbzOqOyK+NhD/4nKjb9v93BwMNe
         RH8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jqz5SmSTDwwfqyARoxTCWKo/0K8KU3ICbaLX4P2M8f8=;
        b=M0ibh8E9ravZR+ellWN6+6dIaCXWA9mfTgsSFS/BRWpFz86kJMXyS6TyFJ7AcB6Sh8
         SyYL02DUPgXOZp9mTapiAaRHuB85qmjp4YEdZq8VfpOhxeLUbTN4Ok8BFehMDZx+3nGT
         vmMl62YxejfUo44JVGdC0xbqdb9rHcnBuPuwmnnyvcrLcNgjHLpvs7vUS6RYwm80NJmq
         fPpn1noXnRU3dTALT5b27eYm8T3ISszEzHQojIVHUnzEdKMyUCaEEEDXXEyekUBuR0oX
         mcVXD/d/dg9q0CqwPZq1XirNoDUE3smbFG1t9qNOUNNT/iKb1gbqm/kJmcX2c4PiPMIO
         numA==
X-Gm-Message-State: AOAM531F1iLPFKIlwSNYqB3xs2eFnRDqOI7QTSJE7Z+A73eBEP4YGcfH
        2rwl/Iyd+4Ua5AOOicuv55U=
X-Google-Smtp-Source: ABdhPJzpDo562g9YVMuihppOqgHz5X+4Y8f/EyNZaYw1UQZvgqyKeRyc6B5TZjQ2Rg4sTk1ysoXQqQ==
X-Received: by 2002:adf:e849:: with SMTP id d9mr11726530wrn.25.1602351436413;
        Sat, 10 Oct 2020 10:37:16 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-228.range109-152.btcentralplus.com. [109.152.100.228])
        by smtp.gmail.com with ESMTPSA id t16sm17269005wmi.18.2020.10.10.10.37.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2020 10:37:15 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 05/12] io_uring: improve submit_state.ios_left accounting
Date:   Sat, 10 Oct 2020 18:34:09 +0100
Message-Id: <b16b486d3eaafa271e9a7c4877d7105cd3d2f85c.1602350806.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1602350805.git.asml.silence@gmail.com>
References: <cover.1602350805.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

state->ios_left isn't decremented for requests that don't need a file,
so it might be larger than number of SQEs left. That in some
circumstances makes us to grab more files that is needed so imposing
extra put.
Deaccount one ios_left for each request.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ffdaea55e820..250eefbe13cb 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2581,7 +2581,6 @@ static struct file *__io_file_get(struct io_submit_state *state, int fd)
 	if (state->file) {
 		if (state->fd == fd) {
 			state->has_refs--;
-			state->ios_left--;
 			return state->file;
 		}
 		__io_state_file_put(state);
@@ -2591,8 +2590,7 @@ static struct file *__io_file_get(struct io_submit_state *state, int fd)
 		return NULL;
 
 	state->fd = fd;
-	state->ios_left--;
-	state->has_refs = state->ios_left;
+	state->has_refs = state->ios_left - 1;
 	return state->file;
 }
 
@@ -6386,7 +6384,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		       struct io_submit_state *state)
 {
 	unsigned int sqe_flags;
-	int id;
+	int id, ret;
 
 	req->opcode = READ_ONCE(sqe->opcode);
 	req->user_data = READ_ONCE(sqe->user_data);
@@ -6432,7 +6430,9 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	if (!io_op_defs[req->opcode].needs_file)
 		return 0;
 
-	return io_req_set_file(state, req, READ_ONCE(sqe->fd));
+	ret = io_req_set_file(state, req, READ_ONCE(sqe->fd));
+	state->ios_left--;
+	return ret;
 }
 
 static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
-- 
2.24.0

