Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71E37508623
	for <lists+io-uring@lfdr.de>; Wed, 20 Apr 2022 12:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355631AbiDTKmx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Apr 2022 06:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377806AbiDTKms (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Apr 2022 06:42:48 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 175AF3FBD0
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 03:40:01 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id h5so1249145pgc.7
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 03:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sBpnDaMZyIyN1522GsoRas+uM6qAC1bVM/NRwDAyFxc=;
        b=pyRhceee6wcSXtOKbu4pxxxDqtvsjJkb/PpkxIGY6mPFpe7Dfy3ykigjgGdXp7sbOG
         ntaneCzrhBlhHvf2w/LG2TlwLEgi1tZeJ0Np52idVLmyC9Rn76cd3g34unk6GwXqDXVu
         zhdc5CeIOm0JcXpvq+Ws2qQKXw8ab5e66vtSMKrNuRlGDaMWhltlhbJrLxWrluhPUBC6
         9mJZYW9+p7sYGNATUY2Guh419RrwBDv8xXp78tfa4VPz3l5isvo8pksaqEGGgFFiHZcP
         ASWjWLdmBMhv/P0HoAQbnGNfIa9JdYOgM4YYbIKDXbpfGFE2KWugC6hER38JfM0B6UDk
         +5Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sBpnDaMZyIyN1522GsoRas+uM6qAC1bVM/NRwDAyFxc=;
        b=fYVrRSWo4L3tHfhRgaJ4opnEsa2rt+Mw2iApNWDVjyPg6TDEu780rRXaR0qWtZb6he
         +1kaahYsvnHcWXCkJ7w+QMqEVaha9DymAoPBe/ieqqEwJluEGDcdL8PhYr/24QdjL6j1
         Lqj/VyA5suM602cdj24aF14Z+FhpBo5nVQKDEFHuK3s/ey3zQ8wheHIh+HmmHdC3HSby
         CuT7nO/FGutfcC1QlAWMfNxBJMbDP2E6weB2BWQ35E1yBYfVPMqOCcRLmfE1KR0PR9Ej
         fqVuvL+bMLAvbZKLA0RUJ/IpIX6V8viQNCIsr+vRGb7zD+H084yp4o0Ad/LZbvmEQ1p9
         bLSw==
X-Gm-Message-State: AOAM532Mef3T78Ij39zt3Kke9+UV3JG5uNxMcDBLafkRamQMUqV7Tnyy
        5dojGkCJ1rgdyi8W77lJ4Trf24gvoYL8VQ==
X-Google-Smtp-Source: ABdhPJyTjz609bWe+l0iSpK+7yDNs5nbE92r4d90XTTXQ6z9OrZQ+SNBQtDCZ1A1FoiqzgZSvRj0+g==
X-Received: by 2002:a63:5917:0:b0:39c:c450:3143 with SMTP id n23-20020a635917000000b0039cc4503143mr18713969pgb.531.1650451200443;
        Wed, 20 Apr 2022 03:40:00 -0700 (PDT)
Received: from HOWEYXU-MB0.tencent.com ([106.53.4.151])
        by smtp.gmail.com with ESMTPSA id y16-20020a63b510000000b00398d8b19bbfsm19491670pge.23.2022.04.20.03.39.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Apr 2022 03:40:00 -0700 (PDT)
From:   Hao Xu <haoxu.linux@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 2/9] io-wq: change argument of create_io_worker() for convienence
Date:   Wed, 20 Apr 2022 18:39:53 +0800
Message-Id: <20220420104000.23214-3-haoxu.linux@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220420104000.23214-1-haoxu.linux@gmail.com>
References: <20220420104000.23214-1-haoxu.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

Change index to acct itself for create_io_worker() for convienence in
the next patches.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/io-wq.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 4239aa4e2c8b..e4f5575750f4 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -139,7 +139,8 @@ struct io_cb_cancel_data {
 	bool cancel_all;
 };
 
-static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index);
+static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe,
+			     struct io_wqe_acct *acct);
 static void io_wqe_dec_running(struct io_worker *worker);
 static bool io_acct_cancel_pending_work(struct io_wqe *wqe,
 					struct io_wqe_acct *acct,
@@ -306,7 +307,7 @@ static bool io_wqe_create_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
 	raw_spin_unlock(&wqe->lock);
 	atomic_inc(&acct->nr_running);
 	atomic_inc(&wqe->wq->worker_refs);
-	return create_io_worker(wqe->wq, wqe, acct->index);
+	return create_io_worker(wqe->wq, wqe, acct);
 }
 
 static void io_wqe_inc_running(struct io_worker *worker)
@@ -335,7 +336,7 @@ static void create_worker_cb(struct callback_head *cb)
 	}
 	raw_spin_unlock(&wqe->lock);
 	if (do_create) {
-		create_io_worker(wq, wqe, worker->create_index);
+		create_io_worker(wq, wqe, acct);
 	} else {
 		atomic_dec(&acct->nr_running);
 		io_worker_ref_put(wq);
@@ -812,9 +813,10 @@ static void io_workqueue_create(struct work_struct *work)
 		kfree(worker);
 }
 
-static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
+static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe,
+			     struct io_wqe_acct *acct)
 {
-	struct io_wqe_acct *acct = &wqe->acct[index];
+	int index = acct->index;
 	struct io_worker *worker;
 	struct task_struct *tsk;
 
-- 
2.36.0

