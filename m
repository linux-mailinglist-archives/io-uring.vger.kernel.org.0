Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB5B74216FA
	for <lists+io-uring@lfdr.de>; Mon,  4 Oct 2021 21:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238881AbhJDTFx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Oct 2021 15:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238855AbhJDTFv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Oct 2021 15:05:51 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63D6BC061745
        for <io-uring@vger.kernel.org>; Mon,  4 Oct 2021 12:04:02 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id x7so66654082edd.6
        for <io-uring@vger.kernel.org>; Mon, 04 Oct 2021 12:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TfgzfRncRu+DlF0DE1+1Hy53x06fG4YoOqnrRxipPSk=;
        b=O9cGa3MNmaouhdfODgvBbJZmZbp5vLZ7NHIXxlwKSZVv9PfNymdEQ81d97vWk6kwOk
         8gV5TJAcJCGMS2W2963z6osBeTj5rKl/mk4O70ytXnThseAMzIqI+zoAqVQO/aDQmRBA
         Uf68Ke7NbaXvAXITPh/pAO/braOFPN3hRVLUH1HNfDneryD8g2fKpNedwHDIWlLfuJMo
         pRFC1Yrxzt4+DxS3WLFixakSrFxFkXvkG01KPY1uC7yAvTUsY9AKRCrqVmITVQw5YRre
         wmUNJPGEjzTGrWNkbdTBMM7B+O5D4EF8c9yZFY9JrXie4mgQLYCdQxf7OJW09d4vjD7b
         0iCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TfgzfRncRu+DlF0DE1+1Hy53x06fG4YoOqnrRxipPSk=;
        b=BjVessSDyg2PZ4s0YtTfstgsgEHy22utoxMqAD5JCoyJNCoghpJyLXujypmt3EU9K1
         uW7AAaShHKL6m4onN4mJXlVz+NCXLW603UEg46hwoxtQipcH7QpKuJaDGArIaqywXP7Z
         k9h/OSN3XmdAelKfPO58QI/gXbNpKS3hxHIvZqd86eellROo+riRRd9rx/KnyFq36c6V
         P2g33m+WAJ6OrfCQNisYHeLFEt4GLsy9pkB/0fMzQTJREvrElMCU4g/Fkdj7tn7FTKS4
         mphyyv6NRwT6nblnE5lR1C80mB13dTra+OEGA6Fvp5xyUxflIxtXIkhwqdtytP6vRmrR
         HXAw==
X-Gm-Message-State: AOAM530V1gUrMcjJr7xP2iTbTGYFFtkoZ4whKdhNgd4O9tRVix3tiFBq
        nrEl6BGg6NpddFhVu/uFRksGLr4R9Kk=
X-Google-Smtp-Source: ABdhPJyOQnQRN2fyd05YkLD8ss1dW/1/Zdo9kICdHn0l1DlW5HYD0Wxu/3VZqzOdvMDY+J/s5T8XOQ==
X-Received: by 2002:a50:9dca:: with SMTP id l10mr20312680edk.61.1633374240689;
        Mon, 04 Oct 2021 12:04:00 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.101])
        by smtp.gmail.com with ESMTPSA id k12sm6855045ejk.63.2021.10.04.12.03.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 12:04:00 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 14/16] io_uring: inline io_poll_complete
Date:   Mon,  4 Oct 2021 20:02:59 +0100
Message-Id: <933d7ee3e4450749a2d892235462c8f18d030293.1633373302.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1633373302.git.asml.silence@gmail.com>
References: <cover.1633373302.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Inline io_poll_complete(), it's simple and doesn't have any particular
purpose.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1ffa811eb76a..f60818602544 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5295,16 +5295,6 @@ static bool __io_poll_complete(struct io_kiocb *req, __poll_t mask)
 	return !(flags & IORING_CQE_F_MORE);
 }
 
-static inline bool io_poll_complete(struct io_kiocb *req, __poll_t mask)
-	__must_hold(&req->ctx->completion_lock)
-{
-	bool done;
-
-	done = __io_poll_complete(req, mask);
-	io_commit_cqring(req->ctx);
-	return done;
-}
-
 static void io_poll_task_func(struct io_kiocb *req, bool *locked)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -5794,7 +5784,8 @@ static int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (mask) { /* no async, we'd stolen it */
 		ipt.error = 0;
-		done = io_poll_complete(req, mask);
+		done = __io_poll_complete(req, mask);
+		io_commit_cqring(req->ctx);
 	}
 	spin_unlock(&ctx->completion_lock);
 
-- 
2.33.0

