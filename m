Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32E5A50A10C
	for <lists+io-uring@lfdr.de>; Thu, 21 Apr 2022 15:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386670AbiDUNsA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Apr 2022 09:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354829AbiDUNsA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Apr 2022 09:48:00 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81EF3B1C3
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 06:45:10 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id r4-20020a05600c35c400b0039295dc1fc3so3437283wmq.3
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 06:45:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZNbB0YTunVpcZFHphwJZ899FPVi4xOGb9Ff8JzbfsLk=;
        b=UKE/Nidi6h0PVwHI+HlqQJqMjUs2XHmQggO/YegaaE+KB2YCHVm2NJE4ThSL1CvRUT
         YuqSz1T2LdfpgoNHBz6jCYsI/5kQoEz5Ar2NiYzz6tbM9yIOUL5dc3/v63oP1rt5BbYU
         tXevJ1dr38XR6ao+A32m5Hoi64dUCvpj4FP9F9TOfROpMxRV02rXRjmjwyBRmMeMp0Dj
         QEGeACI/f7qCVTx/pNHx5t65mndFvHRMKypt/OOj7szermKNvrcZkdHoyPxa47rvdSs7
         /1/wqq5Jg+OI5qh7y5slAj+cvLf6RfZDJSdFyE/BUD4+jqXrB8/6Yb52UTPjcnOBQfZN
         JmWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZNbB0YTunVpcZFHphwJZ899FPVi4xOGb9Ff8JzbfsLk=;
        b=1apk4PH3Ch+q2VYFyaUkP2vqCy7I9YOuUvI5tjlIfIv+rHx7cbnh/cZ5BzZZMI+bnJ
         TbU/caw4675Vi+tPjEjzOdKNL8nT+kQAjAwy6+95OKdGRWzZpGAFHPXKpIzIz98Qc1Zk
         hxJ8wNrSPEaP7Qn/OA0VwL+DspC+vmCy5ld/9O+FFdFFYXzB7cqa+n7M+6XYwrHe7PfY
         haIqgQOW4cEMQUdjBcpgx5yIxLNNeS6Y2s9f+MCzrP0jBJ8kCuTUKvuE5qYA89ltnTsW
         h6ty+0A9hxbdiD+sEIP8USNoirL1cn6mVzZRW1a/yqQmP5Lv2Ax6fgtHs8DLAxdKyrqb
         wKMA==
X-Gm-Message-State: AOAM532qAX2lSz/LOtfeMbmc3tEUFEBfUsVTNziTxGpZ11y7ofcISBIz
        W7SLVgwIPTPsszrZxYKZyYPXjLt4r4o=
X-Google-Smtp-Source: ABdhPJyUS0qBca1VuBnZQiJFky0o+L12lYb8Q3S6iQ9nXO5VVIPY/nH0hS5HcEOLRvDYy1DPppZuOQ==
X-Received: by 2002:a05:600c:350f:b0:392:90a9:41d0 with SMTP id h15-20020a05600c350f00b0039290a941d0mr9000906wmq.62.1650548708897;
        Thu, 21 Apr 2022 06:45:08 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.218])
        by smtp.gmail.com with ESMTPSA id m7-20020adfe0c7000000b002060e7bbe49sm2837821wri.45.2022.04.21.06.45.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 06:45:08 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [RFC 01/11] io_uring: optimise io_req_task_work_add
Date:   Thu, 21 Apr 2022 14:44:14 +0100
Message-Id: <ae55a3cccd60b694b21841493c2959675354a660.1650548192.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <cover.1650548192.git.asml.silence@gmail.com>
References: <cover.1650548192.git.asml.silence@gmail.com>
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

Deduplicate wq_list_add_tail() calls in io_req_task_work_add(), becasue,
apparently, some compilers fail to optimise it and generate a bunch of
extra instructions.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3905b3ec87b8..8011a61e6bd4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2580,6 +2580,7 @@ static void tctx_task_work(struct callback_head *cb)
 
 static void io_req_task_work_add(struct io_kiocb *req, bool priority)
 {
+	struct io_wq_work_list *list;
 	struct task_struct *tsk = req->task;
 	struct io_uring_task *tctx = tsk->io_uring;
 	enum task_work_notify_mode notify;
@@ -2592,10 +2593,8 @@ static void io_req_task_work_add(struct io_kiocb *req, bool priority)
 	io_drop_inflight_file(req);
 
 	spin_lock_irqsave(&tctx->task_lock, flags);
-	if (priority)
-		wq_list_add_tail(&req->io_task_work.node, &tctx->prior_task_list);
-	else
-		wq_list_add_tail(&req->io_task_work.node, &tctx->task_list);
+	list = priority ? &tctx->prior_task_list : &tctx->task_list;
+	wq_list_add_tail(&req->io_task_work.node, list);
 	running = tctx->task_running;
 	if (!running)
 		tctx->task_running = true;
-- 
2.36.0

