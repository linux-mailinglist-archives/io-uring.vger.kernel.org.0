Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 206771A6B57
	for <lists+io-uring@lfdr.de>; Mon, 13 Apr 2020 19:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732579AbgDMR0R (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Apr 2020 13:26:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732778AbgDMR0Q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Apr 2020 13:26:16 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26082C0A3BDC
        for <io-uring@vger.kernel.org>; Mon, 13 Apr 2020 10:26:16 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id r20so3123046pfh.9
        for <io-uring@vger.kernel.org>; Mon, 13 Apr 2020 10:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yJZkJXm0tWRLblPjTPd3oXwFey6mSjKyBT0xHMGidc4=;
        b=aP55ugDgmQB8OrwTkwVZWgXO/OodFl4c7CWcxAxMwnZF89c9CrTp75Vo8RESK0+twe
         NiHpcrjYmMKkKIeUDf/C+568mZiObVlVh6K8Kc3UhxT8uENoQXCVZQosKkUtoQ816qAr
         m93bykEjiiun8s1tN5sAZ00y4NBt0Bq1o95ZFrE4/qnSEfw9YiLTLdqaZL7iJOlLrU41
         twkY8TO6LtYet9pwYN9Ouh/dSniFwJh5A8vFH9FNB08IkF6vFgf9cSS2oUa7tKSiDdJJ
         PJc1nmlrh3yi5zAr/eOIDG8KPxa7TgfANOyLwBPcXtLcvMvgC9oQoQZ6NYfnU6yg5+5o
         +Frg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yJZkJXm0tWRLblPjTPd3oXwFey6mSjKyBT0xHMGidc4=;
        b=fHoxucbMmCfvAOpVvDgzcf2+z726mrjQ7rPldOHkHBa4BSoGjSyLH7xYVl0pCD/U5V
         1QD5H4A0qcmqbo0Br43cIk2ZCpeIOJ9qbJLqS3v6zqpUx9fpgsAu3hxtZFma4h/4uQwU
         MZm2EfgTXJ8QSP7gx+C2STC8ZeyzMgO3Txnuvd6RiD7amjlr4kL4QffpCv/4OGjsdvvU
         kKrlrVfAJtJ09HjvYhzCUvGirX/MLh1iyxvtURfBTJQXboytjMqm9467xYHB0juujUmX
         UUaIhStV8ag7ESXwha3zzUggblDDM2DLTU1+Ghn+Lm16xyf8r9k3cwwaONiWNKYwskDE
         zEeg==
X-Gm-Message-State: AGi0PuZ5Yw065yO2A+j43uEcU5aDxKhGAICEtKFukY5NxWfF68jh3iud
        0QjSVo6bs//rYWuByQlYVm/n6EK0mIBDaQ==
X-Google-Smtp-Source: APiQypL4hO9m+6Ba6b/efLRCN36lMBr6gYgv6nbuBcUXSPtdeIIGcmUtbjNfH2sl0nXaGC3oSGoVfg==
X-Received: by 2002:aa7:9146:: with SMTP id 6mr19469826pfi.201.1586798775326;
        Mon, 13 Apr 2020 10:26:15 -0700 (PDT)
Received: from x1.localdomain ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id q2sm2228834pfl.174.2020.04.13.10.26.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2020 10:26:14 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring: io_async_task_func() should check and honor cancelation
Date:   Mon, 13 Apr 2020 11:26:06 -0600
Message-Id: <20200413172606.8836-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200413172606.8836-1-axboe@kernel.dk>
References: <20200413172606.8836-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If the request has been marked as canceled, don't try and issue it.
Instead just fill a canceled event and finish the request.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7b41f6231955..aac54772e12e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4181,6 +4181,7 @@ static void io_async_task_func(struct callback_head *cb)
 	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
 	struct async_poll *apoll = req->apoll;
 	struct io_ring_ctx *ctx = req->ctx;
+	bool canceled;
 
 	trace_io_uring_task_run(req->ctx, req->opcode, req->user_data);
 
@@ -4192,8 +4193,22 @@ static void io_async_task_func(struct callback_head *cb)
 	if (hash_hashed(&req->hash_node))
 		hash_del(&req->hash_node);
 
+	canceled = READ_ONCE(apoll->poll.canceled);
+	if (canceled) {
+		io_cqring_fill_event(req, -ECANCELED);
+		io_commit_cqring(ctx);
+	}
+
 	spin_unlock_irq(&ctx->completion_lock);
 
+	if (canceled) {
+		kfree(apoll);
+		io_cqring_ev_posted(ctx);
+		req_set_fail_links(req);
+		io_put_req(req);
+		return;
+	}
+
 	/* restore ->work in case we need to retry again */
 	memcpy(&req->work, &apoll->work, sizeof(req->work));
 
-- 
2.26.0

