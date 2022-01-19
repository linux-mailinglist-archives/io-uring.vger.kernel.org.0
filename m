Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5B86493311
	for <lists+io-uring@lfdr.de>; Wed, 19 Jan 2022 03:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344650AbiASCms (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Jan 2022 21:42:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348845AbiASCmr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Jan 2022 21:42:47 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F66C061574
        for <io-uring@vger.kernel.org>; Tue, 18 Jan 2022 18:42:47 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id x15so960493ilc.5
        for <io-uring@vger.kernel.org>; Tue, 18 Jan 2022 18:42:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EuGch+zmt0c+XDfWKdyirMFlKli7LRIf+EM3JgrZuYo=;
        b=sruN2Qa8WR3moGY5cJyMJ5XOUeh+gMYOi6aOgGyhBIxLGnvlbEWgveYNkFCQ1xfHj+
         fenJnBFCyfvWDkRQAicD02lOLqR+MjkQtThcpSkYHGi5fxLraIrYIF7UfyM48NXrdenH
         q+Kios76fzrf6rUL+RErdXRjdYeSK7K+VNnfz1s4kdd51zroP4rhokWctSWTpgAwBIwd
         GVkdgxXsmehZLAdy8zeg7+noZHSs8EKCY67BTp2pAWsrtFe1RvAKxle+C7g/P1ErfPnU
         hZJ2YgH819nl2cigK3wKjdY35uSfxhnjW+0xS8XWEgbCXpODwDvhRSCrBlJAnM8bamK7
         rV1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EuGch+zmt0c+XDfWKdyirMFlKli7LRIf+EM3JgrZuYo=;
        b=JhIKzFfDRNZlAiDpLVB6/SxZTCGZK1MNsR4j/A1ETysfQwNkkterwV+v/r0eW9Sl6B
         KjSRFUk5e/YF4l9dQWj2mWITcQtjdcquNH9acXzEwPi4A824dh2b8Bf/zxpAwgYQfln0
         O35PF5yCOcIVMElE2he0fFbHmY5rqRtbabNsaGV+YazqeNNKQ1sLG3cua8ZOLe7KbSxq
         Z3NxTY+dsDxShyE/VYoKSvHIbIaKkahgtTXZ71Bl9tP8PJ/pUi+xEDizGrro9R0nIxuW
         ew6oj8k225txMn8jElnX5Qxd40htunSQqe600V0XbkxO3GDNLD+hgXVoLG0zn2EuiRgp
         5g7A==
X-Gm-Message-State: AOAM531WtNIRi7SCvPLKUyFqDTbGrchWWsLocosUhMSXZn3fK6qOkrED
        cz3JnfujK3CIzOqBapE2xjuW5WK+7iuYtA==
X-Google-Smtp-Source: ABdhPJxFLt2jZmPzjGs7N9uF/n1mMiUpKff4YuFLgYH5YsbwxFY15OnCBF7OdPn0atcsklSikO2sxw==
X-Received: by 2002:a92:8e42:: with SMTP id k2mr15782007ilh.72.1642560166677;
        Tue, 18 Jan 2022 18:42:46 -0800 (PST)
Received: from localhost.localdomain ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id v5sm9863704ile.72.2022.01.18.18.42.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 18:42:46 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/6] io-wq: invoke work cancelation with wqe->lock held
Date:   Tue, 18 Jan 2022 19:42:38 -0700
Message-Id: <20220119024241.609233-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119024241.609233-1-axboe@kernel.dk>
References: <20220119024241.609233-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_wqe_cancel_pending_work() grabs it internally, grab it upfront
instead. For the running work cancelation, grab the lock around it as
well.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index c369910de793..a92fbdc8bea3 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -1038,17 +1038,16 @@ static void io_wqe_cancel_pending_work(struct io_wqe *wqe,
 {
 	int i;
 retry:
-	raw_spin_lock(&wqe->lock);
 	for (i = 0; i < IO_WQ_ACCT_NR; i++) {
 		struct io_wqe_acct *acct = io_get_acct(wqe, i == 0);
 
 		if (io_acct_cancel_pending_work(wqe, acct, match)) {
+			raw_spin_lock(&wqe->lock);
 			if (match->cancel_all)
 				goto retry;
-			return;
+			break;
 		}
 	}
-	raw_spin_unlock(&wqe->lock);
 }
 
 static void io_wqe_cancel_running_work(struct io_wqe *wqe,
@@ -1077,7 +1076,9 @@ enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq, work_cancel_fn *cancel,
 	for_each_node(node) {
 		struct io_wqe *wqe = wq->wqes[node];
 
+		raw_spin_lock(&wqe->lock);
 		io_wqe_cancel_pending_work(wqe, &match);
+		raw_spin_unlock(&wqe->lock);
 		if (match.nr_pending && !match.cancel_all)
 			return IO_WQ_CANCEL_OK;
 	}
@@ -1091,7 +1092,9 @@ enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq, work_cancel_fn *cancel,
 	for_each_node(node) {
 		struct io_wqe *wqe = wq->wqes[node];
 
+		raw_spin_lock(&wqe->lock);
 		io_wqe_cancel_running_work(wqe, &match);
+		raw_spin_unlock(&wqe->lock);
 		if (match.nr_running && !match.cancel_all)
 			return IO_WQ_CANCEL_RUNNING;
 	}
@@ -1262,7 +1265,9 @@ static void io_wq_destroy(struct io_wq *wq)
 			.fn		= io_wq_work_match_all,
 			.cancel_all	= true,
 		};
+		raw_spin_lock(&wqe->lock);
 		io_wqe_cancel_pending_work(wqe, &match);
+		raw_spin_unlock(&wqe->lock);
 		free_cpumask_var(wqe->cpu_mask);
 		kfree(wqe);
 	}
-- 
2.34.1

