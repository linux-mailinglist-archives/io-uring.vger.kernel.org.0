Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E37F250A112
	for <lists+io-uring@lfdr.de>; Thu, 21 Apr 2022 15:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356692AbiDUNsH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Apr 2022 09:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386713AbiDUNsE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Apr 2022 09:48:04 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36356B7E9
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 06:45:15 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id x18so6806287wrc.0
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 06:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pkaOLIgiqjGGQuwJv6Ke48Yr3Ag+68S9b0zcmBqFfws=;
        b=Cjl55kN/m3lp4/yIW+6vXMaQFQ3q7rSXw6E6sdx9ZVJSOHuWQ27XZdQB2P7xbPAahm
         w7iCuays3PIXqIc1WPXDfGkw3md/yl7n57LlqrCAJJ2+zCQag+3u0M09JTrAXmF8OL62
         dWTEAB3gaBYM7cTtRvL9AXvsbGNGJiid8ZL1HJ3OmdF9nWXu755Wh8d1z3E5sxt078PD
         MdYZtjI+zfDi2oT+2y1pQRockdE+dDkTpERDSV7DeN05Dq6VQnX3KKCDrfd9UJBLH9fF
         FMfdfr0/LRWae/W/opa8ZPCofhjPR0OExCgk2oNB/oaEk1e64HKb/dxPTB37P/7JKvlq
         uM/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pkaOLIgiqjGGQuwJv6Ke48Yr3Ag+68S9b0zcmBqFfws=;
        b=3CZwbaHiJYA5x4TKjT2C7pqRXbdNCKMZOl1HCEsaFcsJdHQVxVrwH9NktLZz9huQgn
         2ICAaAR+l+cYyO6UcLcqfxAhmgW6QmJRJg74auAoC3l7EmMsX0woAnAbtn5HpODfL06Y
         HBUMHDByJVp4MLbqhmI1i3/7pQpJ6W70iZgZqt5duzRdD6CsYpq978YBaDSqBMLsFcdL
         /QW/IFyVvWj8ZLYjXPrSe7MOAzZjt0bOXpN0yfjTO+wYmjf4JJa/cjUU56512TmCkM/X
         Yi9XhT9BzxZW0iIVcQAWeaaaaY3zQBawyT+xLtuDolKX3Qyx/W57SUFQIeXMhgzxesE6
         HcxA==
X-Gm-Message-State: AOAM532TAb62vhRk3iaVEBwhmMs121s1QqsR4sgoapqs3t6+5rMHSSrw
        KVjWBQIVYF/wq7QKefE+9sx9VDt0QWs=
X-Google-Smtp-Source: ABdhPJy12pEwmMi1qYA41rUee0w/BR+LZlf4+sjlJGYLwjqQl5X5Kifv/m3STZmmkkf7CM/5Hd2vHw==
X-Received: by 2002:adf:fdc2:0:b0:207:a57c:10f3 with SMTP id i2-20020adffdc2000000b00207a57c10f3mr19681373wrs.278.1650548713570;
        Thu, 21 Apr 2022 06:45:13 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.218])
        by smtp.gmail.com with ESMTPSA id m7-20020adfe0c7000000b002060e7bbe49sm2837821wri.45.2022.04.21.06.45.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 06:45:13 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [RFC 06/11] task_work: add helper for signalling a task
Date:   Thu, 21 Apr 2022 14:44:19 +0100
Message-Id: <12c006fc159c885a44e8b773b14b3c935ff8abb7.1650548192.git.asml.silence@gmail.com>
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

Extract a task_work_notify() helper from task_work_add(), so we can use
it in the future.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/task_work.h |  3 +++
 kernel/task_work.c        | 33 +++++++++++++++++++--------------
 2 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/include/linux/task_work.h b/include/linux/task_work.h
index 897494b597ba..0c5fc557ecd9 100644
--- a/include/linux/task_work.h
+++ b/include/linux/task_work.h
@@ -27,6 +27,9 @@ static inline bool task_work_pending(struct task_struct *task)
 int task_work_add(struct task_struct *task, struct callback_head *twork,
 			enum task_work_notify_mode mode);
 
+void task_work_notify(struct task_struct *task,
+			enum task_work_notify_mode notify);
+
 struct callback_head *task_work_cancel_match(struct task_struct *task,
 	bool (*match)(struct callback_head *, void *data), void *data);
 struct callback_head *task_work_cancel(struct task_struct *, task_work_func_t);
diff --git a/kernel/task_work.c b/kernel/task_work.c
index c59e1a49bc40..cce8a7ca228f 100644
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -5,6 +5,24 @@
 
 static struct callback_head work_exited; /* all we need is ->next == NULL */
 
+void task_work_notify(struct task_struct *task,
+		     enum task_work_notify_mode notify)
+{
+	switch (notify) {
+	case TWA_NONE:
+		break;
+	case TWA_RESUME:
+		set_notify_resume(task);
+		break;
+	case TWA_SIGNAL:
+		set_notify_signal(task);
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		break;
+	}
+}
+
 /**
  * task_work_add - ask the @task to execute @work->func()
  * @task: the task which should run the callback
@@ -44,20 +62,7 @@ int task_work_add(struct task_struct *task, struct callback_head *work,
 		work->next = head;
 	} while (cmpxchg(&task->task_works, head, work) != head);
 
-	switch (notify) {
-	case TWA_NONE:
-		break;
-	case TWA_RESUME:
-		set_notify_resume(task);
-		break;
-	case TWA_SIGNAL:
-		set_notify_signal(task);
-		break;
-	default:
-		WARN_ON_ONCE(1);
-		break;
-	}
-
+	task_work_notify(task, notify);
 	return 0;
 }
 
-- 
2.36.0

