Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 274353DA70F
	for <lists+io-uring@lfdr.de>; Thu, 29 Jul 2021 17:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237518AbhG2PG3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Jul 2021 11:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbhG2PG3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Jul 2021 11:06:29 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 401EDC061765
        for <io-uring@vger.kernel.org>; Thu, 29 Jul 2021 08:06:25 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id m12so2555980wru.12
        for <io-uring@vger.kernel.org>; Thu, 29 Jul 2021 08:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=wCt58O+n2xA1+Auoi/OZmAedIo2ZqqOeDWEgLE13VNA=;
        b=CYTfZpBzQFXofD4ttDXmDcfJMn7pUdfkmvO2A0cp2te3KlIJiwF3KNNWCwOXKoDKff
         6KzaLyU0ha3sjTS4kyfqRcnEWS5vVOqMdgdXvAuoBlB/p6PO45hIhTbPyvjB2qW7dg9t
         u41KVhLxAE6Nqw20tAc3QRLWNzXjhdihZ718NGPT4wMMC1RsNdwUF/VZu6VcCzK63xfZ
         A/ZzS9nZSOYE00D7xgWCiBI4Mi8UzaKeE3lPb29y7ZakeNRT41059K6XGUlMUkKJpvcH
         YXUG5ruX2Fw8oGe2PXJTfnK9Lk+clqQb8LZIh4LjJZEbB54w3ft72hv6iPC/sx+8Hyio
         4M/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wCt58O+n2xA1+Auoi/OZmAedIo2ZqqOeDWEgLE13VNA=;
        b=TIv4lCw5c4MdesZoq8ZbBS2+IqmcggGHm34KN7Cqh6p5iPGctFrSIxrWnmBXoAGeD5
         58ltqHrF0sPPZ5G4f2UEwmhjqOrRXRWadO4lJS57jCsgF/Vom+3LHdXawKGVbjPcNLWf
         pQ0yGtTOe4wkmShIqP3sUlUVczyjWQtRJ7DTw5raJCgqExbqef2nqF0uDkGderexd0Zt
         5/CH3Und31dNSzs2T7sd89Yufk4o+nNCUYTvKHlF8ulIfMhR0jfKgnp0mf8MLKHZ4bsL
         VUqpKQR3zkGydllh/nDVXCVGwwe4GX+ftU0GKMnfMiVLEV+mQhQAH7q1nES8ZB6dNHJu
         lGVw==
X-Gm-Message-State: AOAM532BJOUXhqh0xtU/qgPRj0gH47lQJLzOju/hlVWlgVCHW9cJ12ID
        8wkZBLXdk5wR7K31omkeduE=
X-Google-Smtp-Source: ABdhPJxV7rMpjvgagdyDWB6WmeCdZGbIywj6drlYuyGFSCgtFA7oExH+4edHrdSIqixNg266+e1Amw==
X-Received: by 2002:a5d:59ab:: with SMTP id p11mr4280031wrr.238.1627571183818;
        Thu, 29 Jul 2021 08:06:23 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.141])
        by smtp.gmail.com with ESMTPSA id e6sm4764577wrg.18.2021.07.29.08.06.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 08:06:23 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 01/23] io_uring: remove unnecessary PF_EXITING check
Date:   Thu, 29 Jul 2021 16:05:28 +0100
Message-Id: <c9d786e99decec19c8381141e7ae7c59c5b51da6.1627570633.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1627570633.git.asml.silence@gmail.com>
References: <cover.1627570633.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We prefer nornal task_works even if it would fail requests inside. Kill
a PF_EXITING check in io_req_task_work_add(), task_work_add() handles
well dying tasks, i.e. return error when can't enqueue due to late
stages of do_exit().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bf548af0426c..2c4a61153bd1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1994,8 +1994,6 @@ static void io_req_task_work_add(struct io_kiocb *req)
 	if (test_bit(0, &tctx->task_state) ||
 	    test_and_set_bit(0, &tctx->task_state))
 		return;
-	if (unlikely(tsk->flags & PF_EXITING))
-		goto fail;
 
 	/*
 	 * SQPOLL kernel thread doesn't need notification, just a wakeup. For
@@ -2008,7 +2006,7 @@ static void io_req_task_work_add(struct io_kiocb *req)
 		wake_up_process(tsk);
 		return;
 	}
-fail:
+
 	clear_bit(0, &tctx->task_state);
 	spin_lock_irqsave(&tctx->task_lock, flags);
 	node = tctx->task_list.first;
-- 
2.32.0

