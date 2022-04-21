Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BABA50A111
	for <lists+io-uring@lfdr.de>; Thu, 21 Apr 2022 15:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386711AbiDUNsI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Apr 2022 09:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386698AbiDUNsG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Apr 2022 09:48:06 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04C7BB879
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 06:45:16 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id m14so6778454wrb.6
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 06:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ld+y3E5VS6/fN9Ge84pUk+4+WD4B5CC2yMs3IHIg66Y=;
        b=TMyYbE49OoK9tpgpj9hzyc5jTBUNKoxRYddLGUxzqXmfuTzEN3vIdNTDgoE9G0GMDU
         C9k8A1g2Q2eAaX5P7/xK6tdKQi/4khxCEil5heKJZHpznEshahcGDvU8PllZxrkJqS/A
         SytZgU90bnaGJhZoTApYIbRvmBIonSAo/4H9F1Y819k/DdlmTYTe6FR/AiT7YtVwepGM
         8JPWg+mDwZySimWuVVosCOBrEC0arDyMTNb2fZ6oGBKIXXUtZeyqj79pT1EVSItKfq8u
         NGNmdzaB0a3knuDvwAYXqRrzr66zA/UXDydB4iCOHMPoVg7HtC0P1bi6OjAGGOmgPUzN
         leGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ld+y3E5VS6/fN9Ge84pUk+4+WD4B5CC2yMs3IHIg66Y=;
        b=UNr11eF4df1yt17ug0ymcpwJPgq9aEYd4xp/03BRadiASPDCoKPDQ2b6h1DJHIZF6z
         2Vfv2+cOdSp6+EpZclIR9zLBWnxMDBQqLuH7OmJA+xeay/SuS1b2pEp2N3Y4KgZLnCp8
         WY8Aw9w8GcB55AGM5cP/zzklsn9p/6+fFqC497QDUMPUtOOJOrb8OAn4oIZVuUxgX/fQ
         mi6gKQki3WOVBuWr10jo0SF/mM/zbn/szd5SuTRCnlJamsCljI4KMXGXOSem3QfviU6L
         B/IWq4vS5jYfoZd/YKaWW/zDVbol0dOIowlRupw81wg9KYotr6PoPUnC58WQxuthb1gi
         9zeA==
X-Gm-Message-State: AOAM530uH6q573WW3TXQCI1H5tKt1Ae54W3zbdvAmjgmjyJDUO5QMnID
        jxhsv0eBpWugGanTYhouqilkSQnNKsI=
X-Google-Smtp-Source: ABdhPJwjn/u4S4OOYi6uYKEQEJw9w5O65zlvsZcCqPE6KSQ16B4TGMec9JmHJ7bXbsi+3bSOh/MVzA==
X-Received: by 2002:a5d:490a:0:b0:207:b3d0:18d6 with SMTP id x10-20020a5d490a000000b00207b3d018d6mr19270500wrq.503.1650548714439;
        Thu, 21 Apr 2022 06:45:14 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.218])
        by smtp.gmail.com with ESMTPSA id m7-20020adfe0c7000000b002060e7bbe49sm2837821wri.45.2022.04.21.06.45.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 06:45:14 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [RFC 07/11] io_uring: run io_uring task_works on TIF_NOTIFY_SIGNAL
Date:   Thu, 21 Apr 2022 14:44:20 +0100
Message-Id: <c312834681e9a60c847cbc189a35bd8382e8f4db.1650548192.git.asml.silence@gmail.com>
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

Now TIF_NOTIFY_SIGNAL can mean not only normal task_work but also
io_uring specific task requests. Make sure to run them when needed.

TODO: add hot path when not having io_uring tw items

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c                | 1 +
 fs/io_uring.c             | 1 +
 include/linux/task_work.h | 1 +
 kernel/entry/kvm.c        | 1 +
 kernel/signal.c           | 2 ++
 5 files changed, 6 insertions(+)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 32aeb2c581c5..35d8c2b46699 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -523,6 +523,7 @@ static bool io_flush_signals(void)
 	if (unlikely(test_thread_flag(TIF_NOTIFY_SIGNAL))) {
 		__set_current_state(TASK_RUNNING);
 		clear_notify_signal();
+		io_uring_task_work_run();
 		if (task_work_pending(current))
 			task_work_run();
 		return true;
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8d5aff1ecb4c..22dcd2fb9687 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2798,6 +2798,7 @@ static inline bool io_run_task_work(void)
 	if (test_thread_flag(TIF_NOTIFY_SIGNAL) || task_work_pending(current)) {
 		__set_current_state(TASK_RUNNING);
 		clear_notify_signal();
+		io_uring_task_work_run();
 		if (task_work_pending(current))
 			task_work_run();
 		return true;
diff --git a/include/linux/task_work.h b/include/linux/task_work.h
index 0c5fc557ecd9..66852f4a2ca0 100644
--- a/include/linux/task_work.h
+++ b/include/linux/task_work.h
@@ -4,6 +4,7 @@
 
 #include <linux/list.h>
 #include <linux/sched.h>
+#include <linux/io_uring.h>
 
 typedef void (*task_work_func_t)(struct callback_head *);
 
diff --git a/kernel/entry/kvm.c b/kernel/entry/kvm.c
index 9d09f489b60e..46d7d23d3cc6 100644
--- a/kernel/entry/kvm.c
+++ b/kernel/entry/kvm.c
@@ -10,6 +10,7 @@ static int xfer_to_guest_mode_work(struct kvm_vcpu *vcpu, unsigned long ti_work)
 
 		if (ti_work & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL)) {
 			clear_notify_signal();
+			io_uring_task_work_run();
 			if (task_work_pending(current))
 				task_work_run();
 		}
diff --git a/kernel/signal.c b/kernel/signal.c
index 30cd1ca43bcd..8d46c4b63204 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2357,6 +2357,7 @@ int ptrace_notify(int exit_code, unsigned long message)
 	int signr;
 
 	BUG_ON((exit_code & (0x7f | ~0xffff)) != SIGTRAP);
+	io_uring_task_work_run();
 	if (unlikely(task_work_pending(current)))
 		task_work_run();
 
@@ -2637,6 +2638,7 @@ bool get_signal(struct ksignal *ksig)
 	int signr;
 
 	clear_notify_signal();
+	io_uring_task_work_run();
 	if (unlikely(task_work_pending(current)))
 		task_work_run();
 
-- 
2.36.0

