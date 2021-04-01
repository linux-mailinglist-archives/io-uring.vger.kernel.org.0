Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71F5A35115D
	for <lists+io-uring@lfdr.de>; Thu,  1 Apr 2021 11:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbhDAI7j (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Apr 2021 04:59:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233404AbhDAI7R (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Apr 2021 04:59:17 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9396FC0613E6
        for <io-uring@vger.kernel.org>; Thu,  1 Apr 2021 01:59:16 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id j4-20020a05600c4104b029010c62bc1e20so500613wmi.3
        for <io-uring@vger.kernel.org>; Thu, 01 Apr 2021 01:59:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XI9S09kMWEyXFq9QJk31KsBqcahZFZ1/PFI35c1qKB8=;
        b=MjqwzsyPmc+xj9/1K8B4cObkGJX35fGKNCdRwZI+Pr0SFmoriU040c6XmYhnUSml3P
         Cm3knoxIofWYjXhB7YKnsUpfxNyScwoFsACoSbFQJTs3+Y8VOHZb2dxrUTnRo33jovgV
         JOeST05r4QCUYBAfMhSp2CFdRbjA7lyFW1o5BMWzvGrPcph91qYJGg1NIpHpWIHmGfxi
         AIgEjsOqFI9cMsrYjjk4bss4WFSaYdM38U5IuQiJ5NxRq/es3kDwg5tffaB/clcBHiQL
         TBAiKipX2GllCX61PAMYU8a4ST9Y45zJKk8ItaKrPqj6bUcTKOdBgquRpHVDoMYPTuuh
         1pPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XI9S09kMWEyXFq9QJk31KsBqcahZFZ1/PFI35c1qKB8=;
        b=sw7marMz1sCepveW3aFF0lOJHvzCdk/2RSctTE3EriaoeNIRKdxLODOp3y47Z2AAOw
         PuMRzYeTLHEALKDBtMMCDqUrTJpMFsEdLdZvOGLvSRKUcp8BW/1sKStoA/MmOxLerWLi
         blCt14WpiOoGIItiQu3CCMLykfCqCyGnBEEj3ewfHboRMOEvIlkw7a+bRnuXp6aQ7U2S
         7EM4RXPKjB4cLyBwIP23J1wyjbs70XLRLP3ZHjQ68EK0CNeXFozhlcAeLdUEYHT4jz5E
         gE8IZMhgVQJiWI1YY8FfQLErELst4q9yVddiSc/FG3J/4L916dsxImF857NGudu/V2BT
         K9RA==
X-Gm-Message-State: AOAM531hSsm5ULs1Kb5wriQf6Zyf+XHiRvUAn65csFbE0RYZdRQAIqxh
        n5X0lQVeRM/xNeCa/1xaCfQ=
X-Google-Smtp-Source: ABdhPJyOVT0TVj77+2fGFBb0znx2AyQFwV7DSQhaDOZHXd/OsChKbJvDFEXvuhCiNHdMksnZRhwbKw==
X-Received: by 2002:a1c:7901:: with SMTP id l1mr7189360wme.114.1617267555381;
        Thu, 01 Apr 2021 01:59:15 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.152])
        by smtp.gmail.com with ESMTPSA id u3sm8639949wrt.82.2021.04.01.01.59.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 01:59:15 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 5.12] io_uring/io-wq: protect against sprintf overflow
Date:   Thu,  1 Apr 2021 09:55:04 +0100
Message-Id: <1702c6145d7e1c46fbc382f28334c02e1a3d3994.1617267273.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

task_pid may be large enough to not fit into the left space of
TASK_COMM_LEN-sized buffers and overflow in sprintf. We not so care
about uniqueness, so replace it with safer snprintf().

Reported-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c    | 4 ++--
 fs/io_uring.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 45771bc06651..8dc200fafc79 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -509,7 +509,7 @@ static int io_wqe_worker(void *data)
 	worker->flags |= (IO_WORKER_F_UP | IO_WORKER_F_RUNNING);
 	io_wqe_inc_running(worker);
 
-	sprintf(buf, "iou-wrk-%d", wq->task_pid);
+	snprintf(buf, sizeof(buf), "iou-wrk-%d", wq->task_pid);
 	set_task_comm(current, buf);
 
 	while (!test_bit(IO_WQ_BIT_EXIT, &wq->state)) {
@@ -742,7 +742,7 @@ static int io_wq_manager(void *data)
 	char buf[TASK_COMM_LEN];
 	int node;
 
-	sprintf(buf, "iou-mgr-%d", wq->task_pid);
+	snprintf(buf, sizeof(buf), "iou-mgr-%d", wq->task_pid);
 	set_task_comm(current, buf);
 
 	do {
diff --git a/fs/io_uring.c b/fs/io_uring.c
index cc018402ab07..c8ceb5ef66a7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6718,7 +6718,7 @@ static int io_sq_thread(void *data)
 	char buf[TASK_COMM_LEN];
 	DEFINE_WAIT(wait);
 
-	sprintf(buf, "iou-sqp-%d", sqd->task_pid);
+	snprintf(buf, sizeof(buf), "iou-sqp-%d", sqd->task_pid);
 	set_task_comm(current, buf);
 	current->pf_io_worker = NULL;
 
-- 
2.24.0

