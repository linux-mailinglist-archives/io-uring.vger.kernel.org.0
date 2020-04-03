Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC1519DD30
	for <lists+io-uring@lfdr.de>; Fri,  3 Apr 2020 19:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbgDCRwt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Apr 2020 13:52:49 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46139 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727923AbgDCRwt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Apr 2020 13:52:49 -0400
Received: by mail-pl1-f193.google.com with SMTP id s23so2973360plq.13
        for <io-uring@vger.kernel.org>; Fri, 03 Apr 2020 10:52:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VBt7FX6uReMrn/MDpdDO3h+pPGXlNlDe4OTnF8X7TNo=;
        b=k22i+4frWYkJbhZk/EcKNH3pHLpgbV5lU43t2w3AD4UHPoyIH21NxkNSpw+eB9ffAE
         90HMdEzof7v2hTWlg20odu7Be0ImORe5XJ2eLkcU1GD+0RtV8sEMfaQNAhUk3IB/JYmz
         UylT4nckt+9cEkomaFNIq7vQxLpvw93NaUsc+42QUz6aFB1DAfu01vfHN4q6EEa6Mpth
         31lRATbX/ZvBs7yYbgKPA5PnwCgEFpVs3b26wEXgxY33tdu7JoLNcRN9+7tBPhwyFnUx
         eceZZ3e/mZXqQ0GwKa/46oKH1ETIS7nghrb3L5sW1mk3+HMtL8sG7cJUFoYDuztR45fp
         xZcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VBt7FX6uReMrn/MDpdDO3h+pPGXlNlDe4OTnF8X7TNo=;
        b=NATELD7MwMG4ecb4E+0xJGYiyjt8nN4YCS5hFJBNgIf4v2qqBu+1cYuOzvBZ697bCJ
         YMJNT2hTktize+otZFtHWaIuvbzfFDh5NFQAg+ewNcxZ9oy61mrt+71k3BPEgaq2yWZ/
         s3YFIeD/mdIrCbcusCbx3bFRewQBJsyd4XCDWrM1My3bjvWSvj3mn5HyltPdB+QH6KzV
         L+qw0t6Cpng7Lmaq/LwUgpouGRallZxRHvaNWr6oV45n27I6UMPU0ZCaGKtizk7XlguH
         aKi8h/ZOHxHH/921a/JuYCTHDXf13+Zzd24+V+ltSdxEHdW7elwQRvFov3G7F5jsq9HV
         4Uhw==
X-Gm-Message-State: AGi0Pubc15wF524fXXMQEdLv5QSSALWL3mTktWs9u8p9BUDohpakoSdS
        WG8zOHOL1HmJgMJHC5IBsG1taLGKhwQzKw==
X-Google-Smtp-Source: APiQypKBckZOZ1a88dicf5MFWEXo+toBYA9G4J1ypm37KXG7kqmdAdxoq/m001NH09PLNrE9T0TESA==
X-Received: by 2002:a17:902:a588:: with SMTP id az8mr8704194plb.338.1585936368021;
        Fri, 03 Apr 2020 10:52:48 -0700 (PDT)
Received: from x1.localdomain ([2620:10d:c090:400::5:8ed0])
        by smtp.gmail.com with ESMTPSA id f8sm6168449pfq.178.2020.04.03.10.52.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2020 10:52:47 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Dan Melnic <dmm@fb.com>
Subject: [PATCH 1/3] io_uring: retry poll if we got woken with non-matching mask
Date:   Fri,  3 Apr 2020 11:52:41 -0600
Message-Id: <20200403175243.14009-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200403175243.14009-1-axboe@kernel.dk>
References: <20200403175243.14009-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If we get woken and the poll doesn't match our mask, re-add the task
to the poll waitqueue and try again instead of completing the request
with a mask of 0.

Reported-by: Dan Melnic <dmm@fb.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 10645077d6b4..8ad4a151994d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4412,8 +4412,20 @@ static void io_poll_complete(struct io_kiocb *req, __poll_t mask, int error)
 static void io_poll_task_handler(struct io_kiocb *req, struct io_kiocb **nxt)
 {
 	struct io_ring_ctx *ctx = req->ctx;
+	struct io_poll_iocb *poll = &req->poll;
+
+	if (!req->result && !READ_ONCE(poll->canceled)) {
+		struct poll_table_struct pt = { ._key = poll->events };
+
+		req->result = vfs_poll(req->file, &pt) & poll->events;
+	}
 
 	spin_lock_irq(&ctx->completion_lock);
+	if (!req->result && !READ_ONCE(poll->canceled)) {
+		add_wait_queue(poll->head, &poll->wait);
+		spin_unlock_irq(&ctx->completion_lock);
+		return;
+	}
 	hash_del(&req->hash_node);
 	io_poll_complete(req, req->result, 0);
 	req->flags |= REQ_F_COMP_LOCKED;
-- 
2.26.0

