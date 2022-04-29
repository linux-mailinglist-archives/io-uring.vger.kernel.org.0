Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDD6451468E
	for <lists+io-uring@lfdr.de>; Fri, 29 Apr 2022 12:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357369AbiD2KWd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Apr 2022 06:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357367AbiD2KW1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Apr 2022 06:22:27 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DDA9C6ED2;
        Fri, 29 Apr 2022 03:19:09 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id q8so6758882plx.3;
        Fri, 29 Apr 2022 03:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TTN28+3w03uGqyxVlPe5iW084zUJw2KOuFLG4iC8iPc=;
        b=Si5i5YG1OQNZLPcqryXd6o9MwTja20/74uWCiPw9vMzkVNJob6v6wN8BvP4/U1oNRI
         ZpZuqbSVrnLewHdxkdfiUaDSlNOvql4shpySpSuijbUk3Y5uVV6Zq8rDLqCDoaIvRoQC
         gQDH4ZlzaC94D5Rnj9g656cPNM0IFA5shH2cN08CGhLPUlGzK6CCpEtrv+N/OMQCvxIZ
         7WJCHzXNHkgqFhqpntDVOc5PhecTbhWGYRIO2cE6zTvy5gs2UG7y5XeLf4BrO+27dWvD
         swYMvhWosKejJ7pCWH7OdEJpRIZI9QTHcmH9LpuBTSQZFdtnmpDfqp/pEd8OdGXKkQXi
         5eHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TTN28+3w03uGqyxVlPe5iW084zUJw2KOuFLG4iC8iPc=;
        b=gJLU1pDw8yZuEjSIIQt3A8tGgvWNHqguLMJO6vnEf3ObfEiMKuLKCEsEvZop5/T6YE
         fO6zvAVdQchL0aXyAWHjeu1K9WKadF2EYtG9xeTE1RXWHWuUMh0eJUoWEgax9txaehZ5
         V3UUUfW1vRMiasT3ddEwyjxbilIpBUOIO31d1mn0DjuS5veFAdVXFZxtaP96TliYTv4p
         jvPAnoeyGnvPpt6UxLckGv+bgn379ZgTRMfJCrI8azL/XKtoTI6PfZDg/qjkKMo3utGb
         Ur9Lz5qQDG7Jpj72MC3fFGb67GFK31i6FW7FblO2WvCwJhAXJu2oiL9lZYsFmHIAXen8
         AQ+A==
X-Gm-Message-State: AOAM531v4OJg5xZ6/Kn+N0ae6hdxJUmYYYWp4Ee/2ziWx4cLCoW0+Kp3
        2ureHBZCMmr/O4kYkwFc9UlJA7iSgoI=
X-Google-Smtp-Source: ABdhPJxckGGSnbxK56aYeAoptHcHku6qa2wXcpKtd2WVJEKcPAWmel/cYhm7oWbMDQBYxom4LSbVVg==
X-Received: by 2002:a17:90b:314e:b0:1dc:ae7:8588 with SMTP id ip14-20020a17090b314e00b001dc0ae78588mr1653101pjb.125.1651227548706;
        Fri, 29 Apr 2022 03:19:08 -0700 (PDT)
Received: from HOWEYXU-MB0.tencent.com ([106.53.33.166])
        by smtp.gmail.com with ESMTPSA id k17-20020a628e11000000b0050d8d373331sm2600016pfe.214.2022.04.29.03.19.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 29 Apr 2022 03:19:08 -0700 (PDT)
From:   Hao Xu <haoxu.linux@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/9] io-wq: fixed worker exit
Date:   Fri, 29 Apr 2022 18:18:55 +0800
Message-Id: <20220429101858.90282-7-haoxu.linux@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220429101858.90282-1-haoxu.linux@gmail.com>
References: <20220429101858.90282-1-haoxu.linux@gmail.com>
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
index a1a10fb204a7..2feff19970ca 100644
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

