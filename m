Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71FD412D360
	for <lists+io-uring@lfdr.de>; Mon, 30 Dec 2019 19:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727571AbfL3SZi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 Dec 2019 13:25:38 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40463 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727403AbfL3SZh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 30 Dec 2019 13:25:37 -0500
Received: by mail-wr1-f67.google.com with SMTP id c14so33414012wrn.7
        for <io-uring@vger.kernel.org>; Mon, 30 Dec 2019 10:25:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=GB48Qj7dlqp0lFT5379PwuWBx+BGQ+yQcyAjHcrxWYA=;
        b=j/hZ6wqXT55GXx4RfIBHI3JBZZycFlPRP7p3sfnRisEgVfGnL5GZiRALEWDlMiPKG0
         qKiRlIT24rLvU74alH/I9se8OOJ7oizKnTvyaziBt91r8xRHSmykDv7NOOpk6g955ssE
         W1yKuiwc/NQTHsRhML+lTC8z4E7EosO7Ul51XLcyAib+Yl9fWsmp1sPb3NI32cYpYbJ2
         1qUPrjIpRhGmXUjttuEnJEx4uXGTQ8L25yPVN7cAqV9/lHePPp5cWW/BxlIc3g6rclP9
         fNIrBJJ4ftn2X5OzASsqs5ygXADu8Ek72tjKWVHkXssHdufaU9ON5nwHHXHqzpnNPADx
         /5og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GB48Qj7dlqp0lFT5379PwuWBx+BGQ+yQcyAjHcrxWYA=;
        b=VamELQ6k4Icar+7vbLWWxwlM5kkPcFV36oY7f2KeE2pl3DtrQAu85NddSMzcJYkJZe
         a9dSGQE1AkB81p5yAXXRpfsgtkuN82iO2geiKn1YcKf9hpD/PIUlTYspo4r7Bz/7DGCA
         H52I+GvkvQi//9XHtTMrC7WYSwicMwKinA/V0FiFhOwozma+qNGIIlg8UiCrHRW++mxS
         wpyzEcDY6w/uKgiC87B95XNGeGgIbpDQ8N0Ozuzx7eLuNNRuV92pj7B2TbT4cA6pqOoW
         fLtzjg7tbIXuiaK6d3q5rpHJFjKRbzOUI0WfqL0VyL63/yDFzN7PEHPdLdKWX1/n0Evg
         0GoQ==
X-Gm-Message-State: APjAAAUMTUM9ojbFjw6Qs9WOV77LNQb9DP68AGDBTDZTrHRluK5uZMNU
        fYslW3CEVv7jecfQPdLsmA+uzmlT
X-Google-Smtp-Source: APXvYqwA/OMIXMQ2yXH97XAGoOlegAG0YMILZxslzz/KmMkqYiv4IqZ4A0lr2ZBpslwd/UxKht8GqQ==
X-Received: by 2002:adf:90e7:: with SMTP id i94mr66384547wri.47.1577730335894;
        Mon, 30 Dec 2019 10:25:35 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id u24sm231590wml.10.2019.12.30.10.25.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Dec 2019 10:25:35 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 4/4] io_uring: remove extra io_wq_current_is_worker()
Date:   Mon, 30 Dec 2019 21:24:47 +0300
Message-Id: <13007d169fd9a7ae7988e65733c289d6c80befe4.1577729827.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1577729827.git.asml.silence@gmail.com>
References: <cover.1577729827.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_wq workers use io_issue_sqe() to forward sqes and never
io_queue_sqe(). Remove extra check for io_wq_current_is_worker()

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 642aca3f2d1f..ef0308126fac 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4376,8 +4376,7 @@ static void io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 			req_set_fail_links(req);
 			io_double_put_req(req);
 		}
-	} else if ((req->flags & REQ_F_FORCE_ASYNC) &&
-		   !io_wq_current_is_worker()) {
+	} else if (req->flags & REQ_F_FORCE_ASYNC) {
 		/*
 		 * Never try inline submit of IOSQE_ASYNC is set, go straight
 		 * to async execution.
-- 
2.24.0

