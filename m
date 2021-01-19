Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5BB92FBA77
	for <lists+io-uring@lfdr.de>; Tue, 19 Jan 2021 15:57:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391467AbhASOzj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Jan 2021 09:55:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394448AbhASNiA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Jan 2021 08:38:00 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01CBAC061786
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 05:36:41 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id a9so16303414wrt.5
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 05:36:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=xB1a7PoqN/1/u4ZW16Q61eY5xhq6kSBdmQ2O8l/zKRs=;
        b=tH/l1USsIpl7uEC2BZzLzRdrP0qo8z8oyoNpKnv7AwwKZu/qqEPmXpQbuawD+CBNIA
         ehIbZ1XvWvvDEMjT+UOP2whe66FKfF9lWDVLLq3f+rHSikPFWfpZkL2MDu9/JM/xR/ow
         ARTfCyu99j/VNg7XuK3Kb1UVoHYLbm0YzKdHCJiunlNPLT7Efb/ZhCJE141w/IOJOWRr
         7Q8X0Xl29HB5WKHv4dJsXf2lllYF/cJwCQan7UozN31Cc2DwVa1YdcpeWgpCW460YgDT
         4naR6cwXt5qHP5KT4cQ5RkyS+JE/mp/QLLNwoRoe8vamOGErQMauyUNa480KAD/NRfYM
         vdKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xB1a7PoqN/1/u4ZW16Q61eY5xhq6kSBdmQ2O8l/zKRs=;
        b=K0aEOj5vU1d6MvrVajx0DP1sp2AKCWX4XH0EKV/JbYLnzytr9aH0VVBxwMGj1uPEn3
         5zd46hLj8rUDnvDCbWg+z8zqvoH8jZa7kTDgYhpT9xNAuz385tnAnqBanur7aoapoesF
         MEMSZs8YHefnIBnPMioT2MUgYts+0B0RWtcE/EB0ttX4AaHaGJpn63D0N111qYOXW5/p
         brIptxwziwKB833JhGXNb+TG4o+twn75XIyHfeljrJCbhgGyyfpNj2y3wqudeugChAWM
         8HpYXv+VJi/Vi8uPPXDY4bzXI6c6Jv4YdK8e+eZxOyLkj3TeRAeNg7Rm+6bPYTYVplyx
         UJHA==
X-Gm-Message-State: AOAM5337UXnkblqQVW4148eW4dzAY1wpNRc0QWg3t4fewSLGrpBjyx4v
        pNE4kJFKl8IOzdudpAECsVeadr2Qol+iKQ==
X-Google-Smtp-Source: ABdhPJxBfhek0GX2Z+7NKCAmQjQ4Y+kcovh66d/QIZDWrs4HTYXG/f/CUu7NIosbDgGvWD56ImV+uA==
X-Received: by 2002:adf:82c5:: with SMTP id 63mr4547292wrc.38.1611063399808;
        Tue, 19 Jan 2021 05:36:39 -0800 (PST)
Received: from localhost.localdomain ([85.255.234.152])
        by smtp.gmail.com with ESMTPSA id f68sm4988443wmf.6.2021.01.19.05.36.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 05:36:39 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 08/14] io_uring: remove __io_state_file_put
Date:   Tue, 19 Jan 2021 13:32:41 +0000
Message-Id: <499e267d7241475afa3ef7e58490a257ee2dcd03.1611062505.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1611062505.git.asml.silence@gmail.com>
References: <cover.1611062505.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The check in io_state_file_put() is optimised pretty well when called
from __io_file_get(). Don't pollute the code with all these variants.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d1ced93c1ea3..93c14bc970d3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2790,16 +2790,12 @@ static void io_iopoll_req_issued(struct io_kiocb *req, bool in_async)
 		wake_up(&ctx->sq_data->wait);
 }
 
-static inline void __io_state_file_put(struct io_submit_state *state)
-{
-	fput_many(state->file, state->file_refs);
-	state->file_refs = 0;
-}
-
 static inline void io_state_file_put(struct io_submit_state *state)
 {
-	if (state->file_refs)
-		__io_state_file_put(state);
+	if (state->file_refs) {
+		fput_many(state->file, state->file_refs);
+		state->file_refs = 0;
+	}
 }
 
 /*
@@ -2817,7 +2813,7 @@ static struct file *__io_file_get(struct io_submit_state *state, int fd)
 			state->file_refs--;
 			return state->file;
 		}
-		__io_state_file_put(state);
+		io_state_file_put(state);
 	}
 	state->file = fget_many(fd, state->ios_left);
 	if (unlikely(!state->file))
-- 
2.24.0

