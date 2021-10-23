Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE62A438353
	for <lists+io-uring@lfdr.de>; Sat, 23 Oct 2021 13:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbhJWLQt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 Oct 2021 07:16:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbhJWLQo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 Oct 2021 07:16:44 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A48FBC061243
        for <io-uring@vger.kernel.org>; Sat, 23 Oct 2021 04:14:17 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id a16so1557626wrh.12
        for <io-uring@vger.kernel.org>; Sat, 23 Oct 2021 04:14:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ohgXO3Kj73bW/wW7RYWHZyV9r60832cbaj48hlWfLXg=;
        b=ky4hkqoKX8N3kx0UBKAv1Nze60bMoQKYf1PRGi29BfM8ge9kscps0aI3qWCeDWsK9D
         edznz6+HR/KcN9Lnl1icjbWXRp/hDjLI2JoYTScuKVMH1tYUsZaRX5VyxmsvRyUD9bKc
         fLKT5C5ivCF9vZniBSqFjNW3vjmppu9lDXgtrqESwSNx736qs8E8GV+9f9mTeqaQ57o5
         ZUEx6/7JfMYncD3+7dO5796jXmlZ1GWUdffyFhcPStgXVwGI2DJ/OmbKskpjAFT0zfd9
         TtnTthznbPS3C3bxHKEF0+BVj9I7Vh6Q/UymK6mkC0zBLijfAm4rDeUir122EjVnNQxR
         C8Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ohgXO3Kj73bW/wW7RYWHZyV9r60832cbaj48hlWfLXg=;
        b=RvnVKbqLK00esYrt/overDWVLUIIScUBEgfm3fI5B07RMOoP2D3tH0G7WIUjgBZwnN
         +6HXE85UhAGfF8mAvq97zGZEBsbF4nrfnR47R5XdaFzBCp+vkCU0Z8FeY6YIRNG9nOUS
         wMpm7K6RWycpA1fysz7iywfUjI95r54LqwMAjMSl5EVO63ncU+FGUOTjjZrl987F+G5L
         goAIXFz1TRC8UHrolW3b3F8cUcS4ezomNxZbs7UBtgy8cnffQRynBUpcPU4Qc9YWaIC6
         H8qGmJxTl31LayneNtIbfohzOsefL5j+ZiMcCyII3ETrsNnzZwT0fC5ch6HJ3eXgWuwB
         f64g==
X-Gm-Message-State: AOAM533udI0WyCEzM3iYiFPlPY2+uNnnczoOMCQzCAH2URn4twl0aI+K
        r9s3UbhRwqnq+D1DvHpBm/sSHfhz9F0=
X-Google-Smtp-Source: ABdhPJzJNPbIxr+PPEzVSYPc/RSwJUSyYe8BOZ/vbTloW3ThbBjJMmgztckHzoV9VA7l0XPEjs+gyA==
X-Received: by 2002:adf:c70f:: with SMTP id k15mr7206663wrg.98.1634987656040;
        Sat, 23 Oct 2021 04:14:16 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.133.195])
        by smtp.gmail.com with ESMTPSA id w2sm10416316wrt.31.2021.10.23.04.14.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Oct 2021 04:14:15 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Hao Xu <haoxu@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 8/8] io_uring: clusterise ki_flags access in rw_prep
Date:   Sat, 23 Oct 2021 12:14:02 +0100
Message-Id: <8ee98779c06f1b59f6039b1e292db4332efd664b.1634987320.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1634987320.git.asml.silence@gmail.com>
References: <cover.1634987320.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

ioprio setup doesn't depend on other fields that are modified in
io_prep_rw() and we can move it down in the function without worrying
about performance. It's useful as it makes iocb->ki_flags
accesses/modifications closer together, so it's more likely the compiler
will cache it in a register and avoid extra reloads.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7042ed870b52..bba2f77ae7e7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2840,16 +2840,6 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	    ((file->f_flags & O_NONBLOCK) && !io_file_supports_nowait(req)))
 		req->flags |= REQ_F_NOWAIT;
 
-	ioprio = READ_ONCE(sqe->ioprio);
-	if (ioprio) {
-		ret = ioprio_check_cap(ioprio);
-		if (ret)
-			return ret;
-
-		kiocb->ki_ioprio = ioprio;
-	} else
-		kiocb->ki_ioprio = get_current_ioprio();
-
 	if (ctx->flags & IORING_SETUP_IOPOLL) {
 		if (!(kiocb->ki_flags & IOCB_DIRECT) || !file->f_op->iopoll)
 			return -EOPNOTSUPP;
@@ -2863,6 +2853,17 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		kiocb->ki_complete = io_complete_rw;
 	}
 
+	ioprio = READ_ONCE(sqe->ioprio);
+	if (ioprio) {
+		ret = ioprio_check_cap(ioprio);
+		if (ret)
+			return ret;
+
+		kiocb->ki_ioprio = ioprio;
+	} else {
+		kiocb->ki_ioprio = get_current_ioprio();
+	}
+
 	req->imu = NULL;
 	req->rw.addr = READ_ONCE(sqe->addr);
 	req->rw.len = READ_ONCE(sqe->len);
-- 
2.33.1

