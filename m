Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E409508627
	for <lists+io-uring@lfdr.de>; Wed, 20 Apr 2022 12:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377758AbiDTKm4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Apr 2022 06:42:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377754AbiDTKmx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Apr 2022 06:42:53 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50DD6B7D7
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 03:40:08 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id mm4-20020a17090b358400b001cb93d8b137so4603545pjb.2
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 03:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HnNo0uOPrWp6BeNgzpzxUn2dUYV+NXLzaqF3OzbiUd0=;
        b=a7LHAV9V3zU7elhfBQGqDl/34ZkHvZZirYEY4BRokcQ1jC6Zu3SkVwBQiGTAMhhqPV
         u+MeoVoStvF5R7Tv1IpYao8hLc7QLZC3jcwAu7OaqAfQgjdSWxpQWUj2mprTyCY14HlW
         2/GEd03SFna8YkG4x1q5u0JPh4aZdQghzN2hQj5TpO3lXmePzUxxP80LoVZ993CKLeP3
         5WOpeUskC5kqCcdUqMum58rrjMPqX3U+/gST/mIlPeYv4BozZ8r6O4IaIB8CSfApOmj7
         vNIQx7Ox4Qx1R82NgoD8LywnglunWhGzZBxvvMyZ8SQOOO3CJUTw0MM8+cb75p0+JCYE
         SRNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HnNo0uOPrWp6BeNgzpzxUn2dUYV+NXLzaqF3OzbiUd0=;
        b=n2rbYScfEQ+dmHOPcsYFPQeR+sMXOmFwrwdmqoKsn9f2c369HINI/+Lf0RgOwA7QZB
         ea1puirroLg2nVB8Efa7beWNxGfSC1GgNtdBfjuoZPtgEt9Pw+fF5aAtaHhw17M52fMb
         IEa5/PoqKq8TXgtpgHtrDJd8Ok2WMkBHn+1LTrhxrcNGJ6XyINSe7sUPiHxiYEL+2Ud4
         clOpg21OBbQ7Y0T+2fgdbTtUtmSQld5rvtEzBWmPYWkIrr0TB+fuw0tp3S3OW9xHydY3
         dIRHg9LQVSyVNxgrfCWolcXuG63njde/MtCQHOjmqL6hp57mzmo+vlas+/MVu4psFwAN
         izdg==
X-Gm-Message-State: AOAM531lquJp6zHg9lIQ5D7bj1sQu7i13aarp/uH9ld3SY4gv7QRNFgC
        u0U4ltJ65YX2cpgPKZ6OtUih5H9Xl1ftMA==
X-Google-Smtp-Source: ABdhPJzEU+R9dB206Ztg3ZZLAqfsBzdu4jd+ddU+6PwE6A8Uu/5fiFzjUbJBgElhLXqVtD+Ns/UZtA==
X-Received: by 2002:a17:90b:3b46:b0:1c7:9ca8:a19e with SMTP id ot6-20020a17090b3b4600b001c79ca8a19emr3563070pjb.245.1650451207779;
        Wed, 20 Apr 2022 03:40:07 -0700 (PDT)
Received: from HOWEYXU-MB0.tencent.com ([106.53.4.151])
        by smtp.gmail.com with ESMTPSA id y16-20020a63b510000000b00398d8b19bbfsm19491670pge.23.2022.04.20.03.40.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Apr 2022 03:40:07 -0700 (PDT)
From:   Hao Xu <haoxu.linux@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 6/9] io-wq: fixed worker exit
Date:   Wed, 20 Apr 2022 18:39:57 +0800
Message-Id: <20220420104000.23214-7-haoxu.linux@gmail.com>
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

Implement the fixed worker exit

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/io-wq.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 02f9b15a998f..a43dcb55ff77 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -259,6 +259,29 @@ static bool io_task_worker_match(struct callback_head *cb, void *data)
 	return worker == data;
 }
 
+static void io_fixed_worker_exit(struct io_worker *worker)
+{
+	int *nr_fixed;
+	int index = worker->acct.index;
+	struct io_wqe *wqe = worker->wqe;
+	struct io_wqe_acct *acct = io_get_acct(wqe, index == 0, true);
+	struct io_worker **fixed_workers;
+
+	raw_spin_lock(&acct->lock);
+	fixed_workers = acct->fixed_workers;
+	if (!fixed_workers || worker->index == -1) {
+		raw_spin_unlock(&acct->lock);
+		return;
+	}
+	nr_fixed = &acct->nr_fixed;
+	/* reuse variable index to represent fixed worker index in its array */
+	index = worker->index;
+	fixed_workers[index] = fixed_workers[*nr_fixed - 1];
+	(*nr_fixed)--;
+	fixed_workers[index]->index = index;
+	raw_spin_unlock(&acct->lock);
+}
+
 static void io_worker_exit(struct io_worker *worker)
 {
 	struct io_wqe *wqe = worker->wqe;
@@ -682,6 +705,7 @@ static int io_wqe_worker(void *data)
 	struct io_wqe *wqe = worker->wqe;
 	struct io_wq *wq = wqe->wq;
 	bool last_timeout = false;
+	bool fixed = worker->flags & IO_WORKER_F_FIXED;
 	char buf[TASK_COMM_LEN];
 
 	worker->flags |= (IO_WORKER_F_UP | IO_WORKER_F_RUNNING);
@@ -732,6 +756,8 @@ static int io_wqe_worker(void *data)
 
 	if (test_bit(IO_WQ_BIT_EXIT, &wq->state))
 		io_worker_handle_work(worker);
+	if (fixed)
+		io_fixed_worker_exit(worker);
 
 	audit_free(current);
 	io_worker_exit(worker);
-- 
2.36.0

