Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4F13223F8
	for <lists+io-uring@lfdr.de>; Tue, 23 Feb 2021 03:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbhBWCBL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Feb 2021 21:01:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbhBWCBI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Feb 2021 21:01:08 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86EF7C061797
        for <io-uring@vger.kernel.org>; Mon, 22 Feb 2021 17:59:55 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id i9so922656wml.5
        for <io-uring@vger.kernel.org>; Mon, 22 Feb 2021 17:59:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=NEVhsoTB+fYS5j0kWErPQbihLoi1xovGjtIYH1iqhA4=;
        b=beq5Oadk2LMPFZLBNqwRxA8gJ6ixnMmyJ4t3a9MDP90jEjLatvXa8qRlQk26cv3L+O
         DJnwMSuE50jGT+kP5aRl+H7SRe++8lvTvqOZ/t/HyAngRHKvxziVZQJYcIbZFZiZdWqs
         Q/PGSjbXDNUKl14WSsws7XGjZSz3E1BVihgsMvxLhJ9K138G6a5hKDL6BaqTQCEFKvnK
         Zk8z+XNpfOQJrZZIJZn0O5ptJV2dvxrrZ6ItM/pjpplnWZ6Y3hKNpbj1kngXD9lbVgIq
         XFTAxHw4w4Sq1RIk5xLMv8RTHjB4j1MOLPSVRRTbM+ixcSawFVTus+o+5IpkUs/Twn3J
         ruyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NEVhsoTB+fYS5j0kWErPQbihLoi1xovGjtIYH1iqhA4=;
        b=RDm1K93UsIsElpIsVZCJXdGqhzPuYOwqrPLvhC/wBpwFzcOhXAIXCDy9tmTklLxcib
         jRsmTjsmTJctF3rhRpGv79vofUXMUDXgPfsOQgKGQJEwWcvQeDtoZPItm7jmXgCJxlo1
         T5XjpoTw5if2iNAMPeKh6wQq3ugIOvF3/i97to4pbUDCTDpq4fXwAvj3y6W/SF5W27+a
         fSHLxLZc4onOgEo2/hSRUbq6tjZ8bYf+nHk9MFlMrjilfTpc4CGZrVMPa4BjsaCd9fya
         Jmo+Mgk8/mZzDwwnJNQEESrsyfm3ayqcaLZ6UDQJFrBmgvKJdQOsEgKWLRinRlRTDmBw
         Cgcg==
X-Gm-Message-State: AOAM530nr7Blq+CK8C6JwYszwFvFg2LV8cAW8/4SobJ4NsBmZU54bztG
        i7EydN7F83bh0nyrdkitmTRXJBP/vEc=
X-Google-Smtp-Source: ABdhPJyM8Gglf/ndZg+xnDOui1hzW9e6zfNRRF/3uHVg8GE27WRX6SWxX7Hf++20CoGbJxGiaPYjYg==
X-Received: by 2002:a1c:4d0d:: with SMTP id o13mr5969773wmh.147.1614045594274;
        Mon, 22 Feb 2021 17:59:54 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.56])
        by smtp.gmail.com with ESMTPSA id 4sm32425501wrr.27.2021.02.22.17.59.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 17:59:53 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 08/13] io_uring: use better types for cflags
Date:   Tue, 23 Feb 2021 01:55:43 +0000
Message-Id: <0de541aacf75e6db0f73a31f60bc318598ed5a02.1614045169.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614045169.git.asml.silence@gmail.com>
References: <cover.1614045169.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

__io_cqring_fill_event() takes cflags as long to squeeze it into u32 in
an CQE, awhile all users pass int or unsigned. Replace it with unsigned
int and store it as u32 in struct io_completion to match CQE.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d2cbee73fd4a..b4d69f9db5fb 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -643,7 +643,7 @@ struct io_unlink {
 struct io_completion {
 	struct file			*file;
 	struct list_head		list;
-	int				cflags;
+	u32				cflags;
 };
 
 struct io_async_connect {
@@ -1547,7 +1547,8 @@ static void io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force,
 	}
 }
 
-static void __io_cqring_fill_event(struct io_kiocb *req, long res, long cflags)
+static void __io_cqring_fill_event(struct io_kiocb *req, long res,
+				   unsigned int cflags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_uring_cqe *cqe;
-- 
2.24.0

