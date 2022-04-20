Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3AF3508621
	for <lists+io-uring@lfdr.de>; Wed, 20 Apr 2022 12:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377756AbiDTKmw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Apr 2022 06:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377812AbiDTKmu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Apr 2022 06:42:50 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3FDEB848
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 03:40:04 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id y14so781653pfe.10
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 03:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WAR2cEsTH0pMy733egywQNadVUxS4Ux6jVfPlwGC8FY=;
        b=S83+99ish14K8Icw76InJfdKqU+/RKMCi6yZRNl65eZev/4w+O3yXpGPhAGcNIA/QH
         bwSz3AJwPEEpwowb9MCWvEBfH4HAMLfzcTT6YTvEjM8ZzqDlDbxAaZTFn7YgJvg41E1p
         J9WK6YB6PANoImhTU09bfAc6E9KHGx+6MwuvZ3KQyyMeNGjyXkS3pFlzRS+TWPzLDE1V
         1QaSczdQiUPcZuNF0jN0eJ3s0LeUWxDmu9qFb7xnnusWtrqt5Pj2Atv2eqZJPrlKs58i
         fno8M0zy0IUuAOqmwgxoANSDOvsHc7SrEh8/vNfuK+qbzPIXldmRO2dP30yfDecoXzpw
         DPFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WAR2cEsTH0pMy733egywQNadVUxS4Ux6jVfPlwGC8FY=;
        b=n55PA2girvjObfWH8ezsrI/wXVgpndSiSUrULIFsgWXRJ0EQZEV4cfOvydfJgjENTu
         ni5pWAbKEE5jC8gf1og1NGEnOeyAaN7/hcsgQxfpyJNreiCslzWQqMJ35EtLqwUXddVm
         m0jlwSy1B7Ml418qt7SmgsJD6zr9fjQAZV9k7F1lIWQKhsuZaX1QM3aNocey1Z0yzKQp
         EgP31enVlhDyDZ9P9YCAa/LzYXJjBYrSu3rxV/POV3xfbBgdJyaN3rCyVUPhn/KIYsct
         prq1jUnqHI1XwDCGyUsbyHWS1I8kxP4grj7Qz6Z9IgKqV1cxlg1c70ILsiuPbkVeHWN9
         gaWQ==
X-Gm-Message-State: AOAM5306bdP5bvPaoPGSW9HKl/vpbG2aP4wLZJTtpowJTMLfROROvCLt
        SHVUM2gnKvvR/A/3frBLhWHJN6RKSARDug==
X-Google-Smtp-Source: ABdhPJyppJ+FR7EK79W+Vqgnez0vJPbLkaS+ZReXAUEDrg+x7KhHk7bwUK0jYLed+C/34PAmmIVOIQ==
X-Received: by 2002:a63:981a:0:b0:398:49ba:a65e with SMTP id q26-20020a63981a000000b0039849baa65emr18857953pgd.231.1650451204087;
        Wed, 20 Apr 2022 03:40:04 -0700 (PDT)
Received: from HOWEYXU-MB0.tencent.com ([106.53.4.151])
        by smtp.gmail.com with ESMTPSA id y16-20020a63b510000000b00398d8b19bbfsm19491670pge.23.2022.04.20.03.40.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Apr 2022 03:40:03 -0700 (PDT)
From:   Hao Xu <haoxu.linux@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 4/9] io-wq: tweak io_get_acct()
Date:   Wed, 20 Apr 2022 18:39:55 +0800
Message-Id: <20220420104000.23214-5-haoxu.linux@gmail.com>
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

Add an argument for io_get_acct() to indicate fixed or normal worker

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/io-wq.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 451b8fb389d1..f1c9e7936988 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -208,20 +208,24 @@ static void io_worker_release(struct io_worker *worker)
 		complete(&worker->ref_done);
 }
 
-static inline struct io_wqe_acct *io_get_acct(struct io_wqe *wqe, bool bound)
+static inline struct io_wqe_acct *io_get_acct(struct io_wqe *wqe, bool bound,
+					      bool fixed)
 {
-	return &wqe->acct[bound ? IO_WQ_ACCT_BOUND : IO_WQ_ACCT_UNBOUND];
+	unsigned index = bound ? IO_WQ_ACCT_BOUND : IO_WQ_ACCT_UNBOUND;
+
+	return fixed ? &wqe->fixed_acct[index] : &wqe->acct[index];
 }
 
 static inline struct io_wqe_acct *io_work_get_acct(struct io_wqe *wqe,
 						   struct io_wq_work *work)
 {
-	return io_get_acct(wqe, !(work->flags & IO_WQ_WORK_UNBOUND));
+	return io_get_acct(wqe, !(work->flags & IO_WQ_WORK_UNBOUND), false);
 }
 
 static inline struct io_wqe_acct *io_wqe_get_acct(struct io_worker *worker)
 {
-	return io_get_acct(worker->wqe, worker->flags & IO_WORKER_F_BOUND);
+	return io_get_acct(worker->wqe, worker->flags & IO_WORKER_F_BOUND,
+			   worker->flags & IO_WORKER_F_FIXED);
 }
 
 static void io_worker_ref_put(struct io_wq *wq)
@@ -1124,7 +1128,7 @@ static void io_wqe_cancel_pending_work(struct io_wqe *wqe,
 	int i;
 retry:
 	for (i = 0; i < IO_WQ_ACCT_NR; i++) {
-		struct io_wqe_acct *acct = io_get_acct(wqe, i == 0);
+		struct io_wqe_acct *acct = io_get_acct(wqe, i == 0, false);
 
 		if (io_acct_cancel_pending_work(wqe, acct, match)) {
 			if (match->cancel_all)
-- 
2.36.0

