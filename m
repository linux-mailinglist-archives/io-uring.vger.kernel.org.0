Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2527B4178EA
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 18:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347479AbhIXQiU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 12:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347577AbhIXQh5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 12:37:57 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAF3BC06129F
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 09:33:02 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id eg28so38475560edb.1
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 09:33:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=IhC4MFAziMarJux+K1xpT1XxNTcSYTxaAnpPQPCiMjM=;
        b=ggOE9wnQdvGCg7G7QFBVNbPt8aZGn5UF7A7qiTT32IXYPQVX9Jg9mAvwMN5ZyurIQI
         4XH/wTXV2jWIdhut5PYaX2rq7OihG7qJuJqbe6QDrO5KY3/J2vX5fYl+bUiR4NMR4PBI
         Dffln1GyLQV1QPSLghJtps7EzQSd03IQ4NBEF9N9vQjKZ+JbjGGUKP3hZKyuziJ0cnLQ
         lF2PcBeqvvhHdrCloZwaGJ5AX8mZmzW309VpmOEV8KAkkbaImES7MWY+yniIsHxUbXrq
         j41An3D6nEyDj5cCXO3RnBMI0cwBblqoIKQD8yPLLOACCDqmex8hXlK9wneC0RvtW8J3
         eRBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IhC4MFAziMarJux+K1xpT1XxNTcSYTxaAnpPQPCiMjM=;
        b=wt2IOpKt4eKXEN8YlGkOZr039oDe+6/pIiE5Z3meCMyb3tbV1M1KGl7CfCH/RHzGTk
         nXZSbXmVaPbb+SQzorTLHf2/CDt6bc3qumzdI7xmUEgCsVsdWR0cvoOL7RqnVntEpeuj
         4VrUk/3oIgDpL1n8HbIIQbxG0XlqonvKlQcy1CUKDXN+YNX1kGiLCxH9rGUzECQii0BC
         IkMGxi73obo/+lh3IFTmHd3Yu7yiXFR4mz8K7y0nev8zwNR2xfCuHi9k6Q3SzppYb2z7
         IOdR3MrlzpwrAS2ndqX5ImO78GkX6NPAv1+rXmjaQQOotZ1zCKvQQkxFONapY3wM6aaf
         9okw==
X-Gm-Message-State: AOAM532jtDGq2ZwDY41eghMmSAqDWHiFVG6lIjnW0vCoNWaBcfjBAhxY
        0VaKRriZwqXs09cl7j2iRQ3dh8goS0M=
X-Google-Smtp-Source: ABdhPJwGpZIc3HmEydWFLbbs0943XvgJeBSW1NhHxSoT2ecNLk1hAuKy5Xw0Yqjo3R/Orqb14itkkg==
X-Received: by 2002:a17:906:688a:: with SMTP id n10mr12198076ejr.389.1632501181498;
        Fri, 24 Sep 2021 09:33:01 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id w10sm6167021eds.30.2021.09.24.09.33.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 09:33:01 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 16/23] io_uring: deduplicate io_queue_sqe() call sites
Date:   Fri, 24 Sep 2021 17:31:54 +0100
Message-Id: <eba97d6b0379052ca1bf6a270e4b8abb72414f90.1632500264.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1632500264.git.asml.silence@gmail.com>
References: <cover.1632500264.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There are two call sites of io_queue_sqe() in io_submit_sqe(), combine
them into one, because io_queue_sqe() is inline and we don't want to
bloat binary, and will become even bigger

   text    data     bss     dec     hex filename
  92126   13986       8  106120   19e88 ./fs/io_uring.o
  91966   13986       8  105960   19de8 ./fs/io_uring.o

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 26342ff481cb..5cffbfc8a61f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7109,20 +7109,18 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		link->last->link = req;
 		link->last = req;
 
+		if (req->flags & (REQ_F_LINK | REQ_F_HARDLINK))
+			return 0;
 		/* last request of a link, enqueue the link */
-		if (!(req->flags & (REQ_F_LINK | REQ_F_HARDLINK))) {
-			link->head = NULL;
-			io_queue_sqe(head);
-		}
-	} else {
-		if (req->flags & (REQ_F_LINK | REQ_F_HARDLINK)) {
-			link->head = req;
-			link->last = req;
-		} else {
-			io_queue_sqe(req);
-		}
+		link->head = NULL;
+		req = head;
+	} else if (req->flags & (REQ_F_LINK | REQ_F_HARDLINK)) {
+		link->head = req;
+		link->last = req;
+		return 0;
 	}
 
+	io_queue_sqe(req);
 	return 0;
 }
 
-- 
2.33.0

